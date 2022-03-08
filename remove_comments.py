import os

path_pure = "./data/malicious_pure"                  #恶性样本相对路径
path_mixed = "./data/mixed_malicious"                #混杂样本相对路径
path_benign = "./data/powershell_benign_dataset"     #良性样本相对路径

#alter_data函数：把ps1脚本转换成一行的字符串，需要去除换行、空格等情况，转换后放在+row的文件夹下，并存储为相同名字的txt文件
def alter_data(path):
    files = os.listdir(path)                    #读取目录下所有文件名
    if os.path.exists(path) == False:           #创建对应row文件夹，没有就新建
        os.mkdir(path + '_row')
    for file in files:                          #依次读取每个ps1文件
        f = open(path + "/" + file, 'r', encoding='utf-8')
        fileStr = f.readlines()                 #把每行以字符串，存放到fileStr列表中
        fileStr_row = ''                        #存放最后一整行字符串的变量
        for i in range(0, len(fileStr)):        #遍历每行
            fileStr_row = fileStr_row + fileStr[i].strip('\n').lstrip()  #去掉两边的换行，去掉左边的空格
        # print(fileStr_row)
        f.close()
        with open(path + '_row/' + file.split('ps1')[0] + 'txt', 'w', encoding='utf-8') as a:  #以同名但是txt文件形式保存下来
            a.write(fileStr_row)
        a.close()

#执行三个路径下的数据
alter_data(path_pure)
alter_data(path_mixed)
alter_data(path_benign)






