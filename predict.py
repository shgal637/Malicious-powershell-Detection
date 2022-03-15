import torch
import numpy as np
from features import *
from PowerShellProfiler import *
from FastText import fasttext_predict


def Alter_data(path):
    '''
     preprocess the script
    :param path: the path of ps1
    :return:code
    '''
    fileStr_row = ''  # 存放最后一整行字符串的变量
    f = open(path, 'r', encoding='utf-8')
    fileStr = f.readlines()  # 把每行以字符串，存放到fileStr列表中
    for i in range(0, len(fileStr)):  # 遍历每行
        fileStr_row = fileStr_row + fileStr[i].strip('\n').lstrip().replace('"', '').replace('\\','\\\\')  # 去掉两边的换行，去掉左边的空格，去掉双引号
    f.close()
    return fileStr_row


def Features(path):
    '''
    extract the features and write to csv
    :param path: ps1
    :return:
    '''
    features = []
    # preprocess script
    code = Alter_data(path)

    # AST
    # /data/powershell_benign_dataset_xml/1.xml
    astpath = path.rsplit("/",1)[0] + '_xml/' + path.rsplit("/",1)[-1].replace('ps1','xml')
    astDir = astpath.rsplit("/", 1)[0]
    if os.path.exists(astDir) == False:  # 创建对应row文件夹，没有就新建
        os.mkdir(astDir)
    # list[23]
    proportion = AST(path,astpath)
    if proportion is None:
        return 0

    # features.append(proportion)
    for i in proportion:
        features.append(i)

    # function level, behaviour based,int
    behaviour_scores = Scores(path,False)
    features.append(behaviour_scores)

    # ShellCode Detection,int
    shell = ShellCode_Detect(code)
    features.append(shell)

    # Information entropy, int
    entropy = Information_entropy(code)
    features.append(entropy)

    # Top_five_characters, list[5]
    top5char = Top_five_characters(code)
    for i in top5char:
        features.append(i)

    # URL_IP, int
    urlIp = URL_IP(code)
    features.append(urlIp)

    # Character_length,list[3]
    char = Character_length(code)
    for i in char:
        features.append(i)

    # Special_variable_names
    var = Special_variable_names(code)
    features.append(var)

    # FastText,list[2]
    fasttext = fasttext_predict(code)
    for i in fasttext:
        features.append(i)

    return features

def predict(path):
    '''
    use model to detect malicious ps1
    :param path: the path of the ps1
    :return: predict label
    '''
    if os.path.exists('model/model-random-tree.pkl'):
        Model = torch.load('model/model-random-tree.pkl')
        features = Features(path)
        features = np.array(features).reshape(1,-1)
        label = Model.predict(features)
        label = label.astype(np.int)
        Label = label[0]
        return Label


if __name__ == '__main__':
    path = 'data/mixed_malicious/46_637.ps1'
    label = predict(path)
    print(label)
    print(type(label))
