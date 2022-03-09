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


def MyDataset(path):
    '''
    用于加载和处理数据
    :param path: 路径
    :return:
    '''
    text_list = []
    label_list = []
        # 读取数据并且处理数据
    with open(path, mode='r', encoding='utf-8') as f:
        file = f.readlines()
    for line in file:
        features = []
        label, code = line.split('\t', 1)
        # extract the features
        # waiting for adding......


        text_list.append(features)
        label_list.append(label)
    return text_list,label_list


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


def predata():
    '''
	turn the datasets to json, and create dataset for training and testing
	因为ps1文件内容中含有{}等符号，会导致后续json文件读取出现错误，所以更改文件格式为txt
	:return: json file, train and test
	'''
    alter_data(path_malicious,1)
    alter_data(path_mixed,1)
    alter_data(path_benign,0)
    return 0


def alter_data(path,label):
    '''
    把ps1脚本进行预处理（转换成一行的字符串，去除换行、空格等情况），并且构建数据集
    :param path: 文件夹路径
    :param label: 标签
    :return:
    '''
    dataset = open(Dataset, mode='a', encoding='utf-8')

    files = os.listdir(path)  # 读取目录下所有文件名
    for count in range(len(files)):  # 依次读取每个ps1文件
        # 预处理字符串
        file = files[count]
        f = open(path + "/" + file, 'r', encoding='utf-8')
        fileStr = f.readlines()  # 把每行以字符串，存放到fileStr列表中
        fileStr_row = ''  # 存放最后一整行字符串的变量
        for i in range(0, len(fileStr)):  # 遍历每行
            fileStr_row = fileStr_row + fileStr[i].strip('\n').lstrip()  # 去掉两边的换行，去掉左边的空格

        dataset.write(label + '\t' + fileStr_row + '\n')
    Dataset.close()
    return 0
