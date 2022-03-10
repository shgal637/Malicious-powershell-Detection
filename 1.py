from email.policy import strict
from config import *

import json

from features import Information_entropy, ShellCode_Detect, Top_five_characters



with open(Trainjson, mode='r', encoding='utf-8') as f:
    file = json.load(f, strict=False) # dict type
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
# PRECISE：0.997024  去掉了pure，只有两个
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

for line in file:
    print(Top_five_characters(line['code']))
    break

# from features import *

# string = 'https://s.weibo.com/weibo?q=%23%E9%95%BF%E6%B4%A5%E6%B9%96%E4%B8%BB%E6%BC%94%E6%9C%AA%E6%9B%9D%E5%85%89%E7%9A%84%E9%80%A0%E5%9E%8B%23&topic_ad='
# a = URL_IP(string)
# print(a)

# string1 = r'{$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};","label": 1},{"code": "[void] [System.Reflection.Assembly]::LoadWithPartialName(System.Drawing) [void] [System.Reflection.Assembly]::LoadWithPartialName(System.Windows.Forms) $objForm = New-Object System.Windows.Forms.Form $objForm.Text = Incorrect Key!$objForm.Size = New-Object System.Drawing.Size(300,200) $objForm.StartPosition = CenterScreen$objForm.KeyPreview = $True$objForm.Add_KeyDown({if ($_.KeyCode -eq Enter) {$x=$objTextBox.Text;$objForm.Close()}})$objForm.Add_'
# string1 = 'http://10000000000000000000000000006568535.tkincorrect_email.htmL yes is ahwuwheeeh 192.168.23.451'
# a1 = Special_variable_names(string1)
# print(a1)