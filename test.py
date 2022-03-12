import os
from config import *
import csv
from features import *

def compare(file1, file2):
    files1 = os.listdir(file1)  # 读取目录下所有文件名
    files2 = os.listdir(file2)
    for i in files1:
        if i not in files2:
            print(i)

if __name__ == '__main__':
    file = 'data/malicious_pure/git_35.ps1'
    ast = 'testData/git35.xml'
    h = AST(file,ast)
    print(h)
