# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/11 23:54
# 文件名称 : pre.py
import os
from config import *

def strip_control_characters(oldfile, newfile):
    f = open(oldfile,'r',encoding='utf-8')
    s = f.read()
    word = ''
    for i in s:
        if ord(i) > 31 and ord(i) < 127:
            word += i
    n = open(newfile,'a',encoding='utf-8')
    n.write(word)
    return 0


def Newdata(Dirpath):
    '''
    create the files that delete some special ascii
    :param path:Directory
    :return:
    '''
    files = os.listdir(Dirpath)  # 读取目录下所有文件名
    for file in files:  # 依次读取每个ps1文件
        filepath = Dirpath + "/" + file
        newDir = Dirpath + '_new'
        if os.path.exists(newDir) == False:  # 创建对应row文件夹，没有就新建
            os.mkdir(newDir)
        newfile = newDir + '/' + file
        strip_control_characters(filepath, newfile)


if __name__ == '__main__':
    Newdata(path_malicious)
    Newdata(path_mixed)
    Newdata(path_benign)
