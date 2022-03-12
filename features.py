# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 16:00
# 文件名称 : features.py
import re
import subprocess
import os
from AstNodes import *
from config import *
import math

def  ShellCode_Detect(text):
    '''
    detect the presence of shellcode
    :param text: code
    :return: 1，存在   0不存在
    '''
    # 如果字串是一段shellcode，那么其中一定包含”call”(0xe8)或者“fnstenv”(0xd9)指令(GetPCcode)
    # [在shellcode的编写一般都要进行地址定位，而地址定位就很难绕过call / ret或者类fnstenv的浮点数指令]
    if '0xe8' in text or '0xd9' in text:
        return 1
    else:
        return 0


def Information_entropy(text):
    '''
    ectract Information entropy as features
    :param text:code
    :return:the entropy
    '''
    '''
        用信息熵公式H(X)=-∑(xi/T)log(xi/T)
        相对而言，Powershell脚本的语义更接近自然语言，良性脚本的英文字母分布接近于自然语言处理分布；
        换句话说，良性脚本的熵高于混淆脚本，因此把每个脚本的信息熵作为一个特征
        '''
    result = {}
    entropy = 0
    for i in set(text):
        result[i] = text.count(i)
    T = sum(result.values())
    for key in result.keys():
        entropy = entropy - (result[key] / T) * math.log10(result[key] / T)
    return entropy


def Top_five_characters(text):
    '''
    counted the number of strings, the maximum length of the strings,and the average length of the strings as three features
    提取字符串的数量、最大的字符串长度、字符串平均长度三个特征
    :param text:
    :return:features
    '''
    result = {}
    top5_character = []
    result_order = []
    for i in set(text):
        result[i] = text.count(i)
        result_order = sorted(result.items(), key=lambda x: x[1], reverse=True)  # sorted返回的是一个元组构成的list
    # print(result_order)
    for i in range(5):
        h = ord(result_order[i][0])
        top5_character.append(h)
    return top5_character


def URL_IP(text):
    '''
    extract the presence of URLs or IP as a feature
    以是否出现URL或IP作为特征
    :param text:
    :return:presence is 1, else 0
    '''
    url = re.findall(r"https?://(?:[-\w.]|(?:%[\da-fA-F]{2}))+", text)
    compile_rule = re.compile(r'\d+[\.]\d+[\.]\d+[\.]\d+')
    ip = re.findall(compile_rule, text)
    if url or ip:
        return 1
    else:
        return 0


def Special_variable_names(text):
    '''
    the number of Special variable names in the script
    以使用的特殊变量名的次数作为特征
    :param text:
    :return: the number
    '''
    '''
    这里采取的方式比较简单，选取了以$开头的字符串，认定为变量名；接着用正则匹配符选出所有，在里面找特殊变量名的次数
    '''
    p = re.compile(r'\$(.*?)[ -\.:=\[\]()]')

    variable_list = re.findall(p, text)
    special_list = ['cmd', 'Shell', 'c']
    count_special = 0

    if set(special_list) & set(variable_list):
        for k in special_list:
            count_special = count_special + variable_list.count(k)
        return count_special
    else:
        return 0


def Character_length(text):
    '''
    counted the number of strings, the maximum length of the strings,and the average length
    of the strings as three features for each script
    计算字符串数量、最大字符串长度、平均字符串长度，作为每个脚本的三个特征
    :param text:
    :return:three_features 格式为元组(str_num max_length aver_length)
    '''
    str_num = 0           #字符串数量
    max_length = 0        #最大字符串长度
    aver_length = 0       #平均字符串长度
    cut_text = re.split(r'[\)\({} ;\]\[]', text)    #利用多种切割符，格式为r'[]',必须要加中括号，所以中间的切割符涉及括号都要加转义
    # print(cut_text)                                 #这一步输出有个问题，当两种切割符在一起出现的时候，re也会进行切割，并生成''空字符，占位置
    cut_text = list(filter(None, cut_text))         #Python内建filter()函数 - 过滤list, 过滤空字符和None
    # print(cut_text)
    str_num = len(cut_text)
    for i in cut_text:
        aver_length = aver_length + len(i)
        if max_length < len(i):
            max_length = len(i)
    aver_length = aver_length / str_num
    three_features = [str_num, max_length, aver_length]
    return three_features


def AST(path,astfile):
    '''
    extract the proportion of these 23 nodes in the abstract syntax tree、the depth of the abstract syntax tree as features
    抽取23类节点的比例、AST的设定作为特征
    :param path: the path of ps1
    :param astfile: the path of xml, AST
    :return:proportion, list[23]
    '''
    proportion = []
    # use the Get-AST.ps1 to process the scripts
    try:
        psxmlgen = subprocess.Popen([r'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe',
                                     r'.\Get-AST.ps1', path, astfile], cwd=os.getcwd())
        result = psxmlgen.wait()
        # use xml to calculate the features
        Nodes = getXmlData(astfile)
    except:
        return None

    NodeCount = {}
    Count = 0
    for type in NodeType:
        NodeCount[type] = 0
    # count nodes
    for node in Nodes:
        if node[2] in NodeType:
            NodeCount[node[2]] += 1
            Count += 1
    # the proportion
    for type in NodeCount.keys():
        NodeCount[type] /= Count
    # return the value
    for type in NodeCount.keys():
        proportion.append(NodeCount[type])

    return proportion
