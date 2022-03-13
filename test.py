import os
from config import *
import csv
from features import *
from data_process import *

def compare(file1, file2):
    files1 = os.listdir(file1)  # 读取目录下所有文件名
    files2 = os.listdir(file2)
    for i in files1:
        if i not in files2:
            print(i)

if __name__ == '__main__':
    DataSet('./data/Test')
