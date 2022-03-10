# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 16:00
# 文件名称 : features.py
import numpy as np
import math
import re



def  ShellCode_Detect(text):
    '''
    detect the presence of shellcode
    :param text: code
    :return: 1，存在   0不存在
    '''
    '''
    如果字串是一段shellcode，那么其中一定包含”call”(0xe8)或者“fnstenv”(0xd9)指令(GetPC code)
    [在shellcode的编写一般都要进行地址定位，而地址定位就很难绕过call/ret或者类fnstenv的浮点数指令]
    '''
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
    T=sum(result.values())
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
    '''
    次数最多的五个字符从大到小取前五的ascii码，作为特征保存在一个字符串中 比如:'67 85 42 77 91'，具体形式后面需更改
    '''
    result = {}
    top5_character = ''
    for i in set(text):
        result[i]= text.count(i)
        result_order = sorted(result.items(), key=lambda x:x[1], reverse=True)    # sorted返回的是一个元组构成的list
    print('result_order:', result_order)
    for i in range(0, 5):
        # top5_character = top5_character + str(ord(str(result_order[i])))
        if i != 4:
            top5_character = top5_character + ' '
    return top5_character

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
    cut_text = re.split(')({} ;][', text)
    # print(cut_text)
    str_num = len(cut_text)
    for i in cut_text:
        aver_length = aver_length + len(i)
        if max_length < len(i):
            max_length = len(i)
    aver_length = aver_length / str_num
    three_features = (str_num, max_length, aver_length)
    return three_features

def URL_IP(text):
    '''
    extract the presence of URLs or IP as a feature
    以是否出现URL或IP作为特征
    :param text:
    :return:presence is 1, else 0
    '''
    p_ip = re.compile('^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$')
    p = re.compile(
        r'^(?:http|ftp)s?://' # http:// or https://
        r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' #domain...
        r'localhost|' #localhost...
        r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' # ...or ip
        r'(?::\d+)?' # optional port
        r'(?:/?|[/?]\S+)$', re.IGNORECASE)

    if p.search(text) or p_ip.search(text):
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


def AST(text):
    '''
    extract the proportion of these 23 nodes in the abstract syntax tree、the depth of the abstract syntax tree as features
    抽取23类节点的比例、AST的设定作为特征
    :param text:
    :return:features
    '''
    return 0


