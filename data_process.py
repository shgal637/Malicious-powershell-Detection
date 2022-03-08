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


# 定义自己的Dataset类，用于加载和处理数据
class MyDataset(Dataset):
    '''
    根据json文件构建train、test数据集
    :return:
    '''
    def __init__(self, path):
        self.text_list = []
        self.label_list = []
        # 读取数据并且处理数据
        with open(path, mode='r', encoding='utf-8') as f:
            # self.file = json.load(f) # dict type
            self.file = f.readlines()
        for line in self.file:
            features = []
            label, code = line.split('\t', 1)
            # extract the features
            # waiting for adding......
            features.append()
            self.text_list.append(features)
            self.label_list.append(label)

    # 获取数据长度
    def __len__(self):
        return len(self.file)

    # 按照index获取数据
    def __getitem__(self, index):
        return self.text_list[index], self.label_list[index]


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
    # 准备json格式
    # trainfile = open(Trainjson, mode='a', encoding='utf-8')
    # testfile = open(Testjson, mode='a', encoding='utf-8')
    # trainfile.write('[')
    # testfile.write('[')
    # trainfile.close()
    # testfile.close()

    alter_data(path_malicious,1,0)
    alter_data(path_mixed,1,0)
    alter_data(path_benign,0,1)

    # 完善json格式
    # trainfile = open(Trainjson, mode='a', encoding='utf-8')
    # testfile = open(Testjson, mode='a', encoding='utf-8')
    # trainfile.write(']')
    # testfile.write(']')
    # trainfile.close()
    # testfile.close()
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
            # trainfile.write('{"code": "' + fileStr_row + '","label": ' + str(label) + '}')
            # if option != 1:
            #     trainfile.write(',')
            # else:
            #     if count < len(files) - 2:
            #         trainfile.write(',')
            trainfile.write(label + '\t' + fileStr_row + '\n')
        else:
            # testfile.write('{"code": "' + fileStr_row + '","label": ' + str(label) + '}')
            # if option != 1:
            #     testfile.write(',')
            # else:
            #     if count < len(files) - 2:
            #         testfile.write(',')
            testfile.write(label + '\t' + fileStr_row + '\n')
    trainfile.close()
    testfile.close()
    return 0
