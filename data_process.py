# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 13:29
# 文件名称 : data_process.py
from torch.utils.data import Dataset
from torch.nn.utils.rnn import pad_sequence
import json
import torch
import numpy as np
from config import *
import os
from features import *
from PowerShellProfiler import *
import csv
import pandas as pd

def ReadData():
    '''
    get the features from csv
    :return: features and labels
    '''
    raw_data = pd.read_csv(Dataset, header=0)
    data = raw_data.values
    features = data[:, 1:]
    labels = data[:, 0]
    return features,labels


def DataSet(Dirpath):
    '''
    create the features.csv, the datasets
    :param path:Directory
    :return:
    '''
    files = os.listdir(Dirpath)  # 读取目录下所有文件名
    # Write to csv
    f = open(Dataset, 'a', encoding='utf-8',newline='')
    Log = open('./log.txt', 'a', encoding='utf-8')
    write = csv.writer(f)
    # write.writerow(headers)
    for file in files:  # 依次读取每个ps1文件
        filepath = Dirpath + "/" + file
        print(filepath)
        features = Extract_Features(filepath)
        print('\n')
        if features == 0:
            Log.write('features NONE :  ' + filepath + '\n')
            continue
        write.writerow(features)
    f.close()
    Log.close()


def Extract_Features(path):
    '''
    extract the features and write to csv
    :param path: ps1
    :return:
    '''
    features = []
    # preprocess script
    code, label = alter_data(path)
    features.append(label)

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

    # FastText
    # Adding......

    return features


def batch_process(batch):
    '''
    用于DataLoader装载数据时进一步处理batch数据
    :param batch:batch size
    :return:
    '''
    text_list, label_list = zip(*batch)
    text_list_ = []

    # token转化成ascii
    for i in range(len(text_list)):
        code = np.fromstring(text_list[i], dtype=np.uint8)  # <class 'numpy.ndarray'>
        text_list_.append(torch.LongTensor(code))

    text_list_ = pad_sequence(text_list_, batch_first=True, padding_value=0)  # padding数据
    # 将数据类型转化成tensor
    label_list = torch.tensor(label_list, dtype=torch.long)
    return text_list_, label_list


def alter_data(path):
    '''
     preprocess the script and get label
    :param path: the path of ps1
    :return:code and label
    '''
    fileStr_row = ''  # 存放最后一整行字符串的变量

    f = open(path, 'r', encoding='utf-8')
    fileStr = f.readlines()  # 把每行以字符串，存放到fileStr列表中
    for i in range(0, len(fileStr)):  # 遍历每行
        fileStr_row = fileStr_row + fileStr[i].strip('\n').lstrip().replace('"', '').replace('\\','\\\\')  # 去掉两边的换行，去掉左边的空格，去掉双引号
    f.close()

    label = 1
    if 'benign' in path:
        label = 0
    return fileStr_row, label


def strip_control_characters(s):
    word = ''
    for i in s:
        if ord(i) > 31 and ord(i) < 127:
            word += i
        else:
            print(i, ord(i))
    return word
