# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 16:00
# 文件名称 : features.py
import numpy as np

def  ShellCode_Detect(text):
    '''
    detect the presence of shellcode
    :param text: code
    :return: 1，存在   0不存在
    '''
    return 0


def Information_entropy(text):
    '''
    ectract Information entropy as features
    :param text:code
    :return:the entropy
    '''
    return 0


def Top_five_characters(text):
    '''
    counted the number of strings, the maximum length of the strings,and the average length of the strings as three features
    提取字符串的数量、最大的字符串长度、字符串平均长度三个特征
    :param text:
    :return:features
    '''
    return 0


def URL_IP(text):
    '''
    extract the presence of URLs or IP as a feature
    以是否出现URL或IP作为特征
    :param text:
    :return:presence is 1, else 0
    '''
    return 0


def Special_variable_names(text):
    '''
    the number of Special variable names in the script
    以使用的特殊变量名的次数作为特征
    :param text:
    :return: the number
    '''
    return 0


def AST(text):
    '''
    extract the proportion of these 23 nodes in the abstract syntax tree、the depth of the abstract syntax tree as features
    抽取23类节点的比例、AST的设定作为特征
    :param text:
    :return:features
    '''
    return 0


