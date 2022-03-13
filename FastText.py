from os import listdir
import numpy as np

import pandas as pd
from config import *
import csv
import os
import re
import math

from collections import defaultdict

import keras
import keras.backend as K
from keras.layers import Dense, GlobalAveragePooling1D, Embedding
from keras.callbacks import EarlyStopping
from keras.models import Sequential
from keras.preprocessing.sequence import pad_sequences
from keras.preprocessing.text import Tokenizer
from keras.utils import to_categorical
from keras.models import load_model
from sklearn.model_selection import train_test_split


# 将数据集按4:1比例划分为训练集和测试集，分别存放在./data下的train.csv和test.csv
def alter_csv(path, label, mode):
    f_train = open('./data/train.csv', mode, encoding='utf-8', newline="")
    f_test = open('./data/test.csv', mode, encoding='utf-8', newline="")
    
    csv_writer_train = csv.writer(f_train)
    csv_writer_test = csv.writer(f_test)

    # 构建列表头
    if mode == 'w':
        csv_writer_train.writerow(["id", "code", "label"])
        csv_writer_test.writerow(["id", "code", "label"])

    files = os.listdir(path) # 读取目录下所有文件名
    for count in range(len(files)):  # 依次读取每个ps1文件
        # 预处理字符串
        file = files[count]
        f = open(path + "/" + file, 'r', encoding='utf-8')
        fileStr = f.readlines()  # 把每行以字符串，存放到fileStr列表中
        fileStr_row = ''  # 存放最后一整行字符串的变量
        if count == 438: print(file)
        for i in range(0, len(fileStr)):  # 遍历每行
            # print(fileStr[i])
            fileStr_row = fileStr_row + fileStr[i].replace('\n', '').lstrip().replace('"', '').replace('\\','\\\\')  # 去掉两边的换行，去掉左边的空格，去掉双引号
        if count % 5 != 4:
            csv_writer_train.writerow([count, str(fileStr_row), label])
        else:
            csv_writer_test.writerow([count, str(fileStr_row), label])

    f_train.close()
    f_test.close()
# 不存在csv文件的时候，执行生成csv文件指令
if not os.path.exists('./data/train.csv'):
    alter_csv(path_malicious, 1, 'w')
    alter_csv(path_mixed, 1, 'a')
    alter_csv(path_benign, 0, 'a')



np.random.seed(7)                            # 生成随机数种子

df = pd.read_csv('./data/train.csv')

# y = np.array([a for a in df.label])
y = np.array([int(a) for a in df.label])
y = to_categorical(y)                        # 就是先初始化一个max(y) + 1长度的数组，其值全部为0，在将label值当成索引，对应位置置为1
# print(y)

'''
# print(set(df.label))
counter = {a : defaultdict(int) for a in set(df.label)}  # defaultdict接受一个factory_function函数作为参数,factory_function可以是list、set、str等等，作用是当key不存在时，返回的是工厂函数的默认值，比如list对应[ ]，str对应的是空字符串，set对应set( )，int对应0

for (id, code, label) in zip(df.id, list(df.code), (df.label)):
#     code = code.replace(' ', '')
    # print(code)
    # print(id)
    if pd.isnull(code):                             # 从dataframe列检查字符串是否为nan
        counter[label][''] += 1
    else:
        for c in code:                              # 一直报一个float的错误，查找后发现循环到某一个文件时，code的读取有问题，经排查发现是1397_1652.ps1
            counter[label][c] += 1

chars = set()
for v in counter.values():
    # print(v.keys())
    chars |= v.keys()                               # 找到所有的单个字符，存放在chars里

labels = [label for label in counter.keys()]
'''
'''
print('c ', end='')
for n in labels:
    print(n, end='   ')
print()
for c in chars:    
    print(c, end=' ')
    for n in labels:
        print(counter[n][c], end=' ')
    print()
'''
def preprocess(text):
    # text = text.replace("' ", " ' ")                      # 在单引号空格前面加空格
    text = re.sub("\d+", "*", text)                       # 数字变成*
    text = re.sub("[^a-zA-Z*$]", " ", text)               # 不相关字符变成空格s
    # text = re.split(r'[ \)\({} ;\]\[]', text)
    text = re.split(r'[ \)\({};]', text)
    text = [x.strip() for x in text if x.strip()!='' and x.strip() != '*' and (not re.findall(r'\*x.*?\*', x.strip()))]
    return text
    # signs = set(',.:;"?!')                                # 确定特殊字符
    # prods = set(text) & signs                             # 字符串找有无特殊字符
    # if not prods:                                         # 没有直接返回
    #     return text
    # for sign in prods:
    #     text = text.replace(sign, ' {} '.format(sign) )   # 特殊字符前后加空格
    # return text

def create_docs(df, n_gram_max=2):
    def add_ngram(q, n_gram_max):
            ngrams = []
            for n in range(2, n_gram_max+1):
                for w_index in range(len(q)-n+1):
                    ngrams.append('--'.join(q[w_index:w_index+n]))   # 将字符串分成n-gram级，每个n-gram内部以--分割如['u--w--b--5--1']，存储在ngrams列表中
            # return q + ngrams
            return ngrams + q
        
    docs = []
    for doc in df.code:
        # print(doc)
        if pd.isnull(doc):
            doc = []
        else:
            doc = preprocess(doc)                                #!!!! zhe
            doc = [x.strip() for x in doc if x.strip()!='']      #去除空字符
        docs.append(' '.join(add_ngram(doc, n_gram_max)))            # 所有字符串的ngrams存储在 docs中
    
    return docs

min_count = 10

docs = create_docs(df)                 # len() = 10177
tokenizer = Tokenizer(lower=True, filters='')  # num_words() = 1049940 -> 94539
tokenizer.fit_on_texts(docs)
num_words = sum([1 for _, v in tokenizer.word_counts.items() if v >= min_count])

tokenizer = Tokenizer(num_words=num_words, lower=True, filters='')
tokenizer.fit_on_texts(docs)
docs = tokenizer.texts_to_sequences(docs)                           # 转换成序列列表，也就是用index代替如'u--w--b--5--1'

maxlen = 256

docs = pad_sequences(sequences=docs, maxlen=maxlen)                 # keras只能接受长度相同的序列输入，经过上部转换，针对每个字符串index的多少都会有影响，所以需要长度相同

input_dim = np.max(docs) + 1            # Return the maximum of an array or maximum along an axis.
embedding_dims = 300

def create_model(embedding_dims=300, optimizer='adam'):
    model = Sequential()                # Keras 顺序模型 FastText contains only three layers:
    model.add(Embedding(input_dim=input_dim, output_dim=embedding_dims)) # Embeddings layer: Input words (and word n-grams) are all words in a sentence/document
    model.add(GlobalAveragePooling1D())                                  # Mean/AveragePooling Layer: Taking average vector of Embedding vectors
    model.add(Dense(2, activation='softmax'))                            # Softmax layer

    model.compile(loss='categorical_crossentropy',                       # 目标函数(或称损失函数)，编译一个模型的必须两个参数之一
                  optimizer=optimizer,                                   # 多类的对数损失，该目标函数需要将标签转化为形如(nb.samples, nb_classes)的二值序列
                  metrics=['accuracy'])                                  # adam优化算法
    return model
'''
epochs = 8                                      # 一个epoch就是全数据集，这代表要整个数据集跑25次
x_train, x_test, y_train, y_test = train_test_split(docs, y, test_size=0.2) # 分离器函数, 划分为test_size大小的测试集，剩下做训练集
                                                 # docs seems: np.array([[0,0,0,1,3,5,6],[0,1,6,3,10,1,2],[1,1,1,1,2,3,7]])
model = create_model()
hist = model.fit(x_train, y_train,
                 batch_size=16,                  # 每次训练16个样本
                 validation_data=(x_test, y_test), # 用来评估损失，以及在每轮结束时的任何模型度量指标，模型不会在这上面训练
                 epochs=epochs,
                 callbacks=[EarlyStopping(patience=2, monitor='val_loss')]) #回调函数: monitor监控的数据接口 这里val_loss是验证集损失函数
                                                    #patient: 对于设置的monitor，可以忍受在多少个epoch内没有改进，不宜设置过小

# 重新读一遍字符串形式的docs, 做一遍转小写的准确度
docs = create_docs(df)
tokenizer = Tokenizer(lower=True, filters='')    # 这里加了全部转小写
tokenizer.fit_on_texts(docs)
num_words = sum([1 for _, v in tokenizer.word_counts.items() if v >= min_count])

tokenizer = Tokenizer(num_words=num_words, lower=True, filters='')
tokenizer.fit_on_texts(docs)
docs = tokenizer.texts_to_sequences(docs)

maxlen = 256

docs = pad_sequences(sequences=docs, maxlen=maxlen)

input_dim = np.max(docs) + 1

epochs = 16
x_train, x_test, y_train, y_test = train_test_split(docs, y, test_size=0.2)

model = create_model()
hist = model.fit(x_train, y_train,
                 batch_size=16,
                 validation_data=(x_test, y_test),
                 epochs=epochs,
                 callbacks=[EarlyStopping(patience=2, monitor='val_loss')])


model.save("./Fasttext_model.h5")
'''
model = load_model('./Fasttext_model.h5')

test_df = pd.read_csv('./data/test.csv')
docs = create_docs(test_df)
docs = tokenizer.texts_to_sequences(docs)
docs = pad_sequences(sequences=docs, maxlen=maxlen)
y = model.predict(docs)
# print(y)
y_label = np.array([np.argmax(y, axis=1)])
y_confidence = np.array([np.max(y, axis=1)])
Fasttext_vector = np.hstack((y_label.T, y_confidence.T))
test_label = np.array(test_df.label)
print('测试集上准确率：', sum(np.argmax(y, axis=1) == test_df.label) / len(list(test_df.label))  # 一维的array可以直接用==，得出true，sum总结个数




'''
a2c = {'Benign': 0, 'Malicious': 1}
result = pd.read_csv('./data/test.csv')
for a, i in a2c.items():
    result[a] = y[:, i]

result.to_csv('fastText_result.csv', index=False)
'''