# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 14:45
# 文件名称 : test.py
from torch.utils.data import Dataset
from torch.nn.utils.rnn import pad_sequence
import json
import torch
import numpy as np
from config import *
import os

def Txt2json():
    '''
	turn the txt to json, in order to train and test the model
	:return: json file, train and test
	'''
    # 准备json格式
    trainfile = open(Trainjson, mode='a', encoding='utf-8')
    testfile = open(Testjson, mode='a', encoding='utf-8')
    trainfile.write('[')
    testfile.write('[')
    trainfile.close()
    testfile.close()

    alter_data(path_malicious,1,0)
    alter_data(path_mixed,1,0)
    alter_data(path_benign,0,1)

    # 完善json格式
    trainfile = open(Trainjson, mode='a', encoding='utf-8')
    testfile = open(Testjson, mode='a', encoding='utf-8')
    trainfile.write(']')
    testfile.write(']')
    trainfile.close()
    testfile.close()
    return 0

def alter_data(path,label,option):
    '''
    把ps1脚本转换成一行的字符串，需要去除换行、空格等情况，转换后放在+row的文件夹下，并存储为相同名字的txt文件
    :param path: 文件夹路径
    :param label: 标签
    :param option: 指定是否是最后一个文件夹,1 最后一个文件
    :return:
    '''
    trainfile = open(Trainjson, mode='a', encoding='utf-8')
    testfile = open(Testjson, mode='a', encoding='utf-8')

    files = os.listdir(path)  # 读取目录下所有文件名
    for count in range(len(files)):  # 依次读取每个ps1文件
        # 预处理字符串
        file = files[count]
        f = open(path + "/" + file, 'r', encoding='utf-8')
        fileStr = f.readlines()  # 把每行以字符串，存放到fileStr列表中
        fileStr_row = ''  # 存放最后一整行字符串的变量
        for i in range(0, len(fileStr)):  # 遍历每行
            fileStr_row = fileStr_row + fileStr[i].strip('\n').lstrip()  # 去掉两边的换行，去掉左边的空格

        # train和test交替构建数据集
        if (count % 2 == 0):
            trainfile.write('{"code": "' + fileStr_row + '","label": ' + str(label) + '}')
            if option != 1:
                trainfile.write(',')
            else:
                if count < len(files) - 2:
                    trainfile.write(',')
        else:
            testfile.write('{"code": "' + fileStr_row + '","label": ' + str(label) + '}')
            if option != 1:
                testfile.write(',')
            else:
                if count < len(files) - 2:
                    testfile.write(',')
    trainfile.close()
    testfile.close()
    return 0

if __name__ == '__main__':
    Txt2json()
