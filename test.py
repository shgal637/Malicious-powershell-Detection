# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 13:29
# 文件名称 : data_process.py
from torch.utils.data import Dataset,DataLoader
from torch.nn.utils.rnn import pad_sequence
import json
import torch
import numpy as np
from config import *
import os



def MyDataset(path):
    '''
    根据json文件构建train、test数据集
    :return:
    '''
    text_list = []
    label_list = []
    # 读取数据并且处理数据
    with open(path, mode='r', encoding='utf-8') as f:
        file = f.readlines()
    for line in file:
        label, code = line.split('\t', 1)
        text_list.append(code)
        label_list.append(label)
    return label_list, text_list

def batch_process(batch):
    '''
    用于DataLoader装载数据时进一步处理batch数据
    :param batch:batch size
    :return:
    '''
    text_list, label_list = zip(*batch)
    print('textlist\n')
    print(text_list)
    print('label_list\n')
    print(label_list)

    return text_list, label_list


def predata():
    '''
	turn the datasets to json, and create dataset for training and testing
	:return: json file, train and test
	'''
    alter_data(path_malicious,1,0)
    alter_data(path_mixed,1,0)
    alter_data(path_benign,0,1)
    return 0


def alter_data(path,label,option):
    '''
    把ps1脚本进行预处理（转换成一行的字符串，去除换行、空格等情况），并且构建test和train数据集
    :param path: 文件夹路径
    :param label: 标签
    :param option: 指定是否是最后一个文件夹,1 最后一个文件
    :return:
    '''
    trainfile = open(Traintxt, mode='a', encoding='utf-8')
    testfile = open(Testtxt, mode='a', encoding='utf-8')

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
            trainfile.write(str(label) + '\t' + fileStr_row + '\n')
        else:
            testfile.write(str(label) + '\t' + fileStr_row + '\n')
    trainfile.close()
    testfile.close()
    return 0

if __name__ == '__main__':
    text_list = []
    string = r"(New-Object System.Netent)ss)"
    code = np.fromstring(string, dtype=np.uint8)
    text_list.append(torch.LongTensor(code))
    print(text_list)
