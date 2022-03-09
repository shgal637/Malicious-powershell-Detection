# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 16:00
# 文件名称 : features.py
import re
import subprocess
import os
from AstNodes import *
from config import *
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
    return 0


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
    psxmlgen = subprocess.Popen([r'C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe',
                                 r'.\Get-AST.ps1', path, astfile], cwd=os.getcwd())
    result = psxmlgen.wait()
    # use xml to calculate the features
    Nodes = getXmlData(astfile)
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
