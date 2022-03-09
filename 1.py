# from config import *
# import json

# with open(Trainjson, mode='r', encoding='utf-8') as f:
#     file = json.load(f) # dict type
# print(file)
from features import *

# string = 'https://s.weibo.com/weibo?q=%23%E9%95%BF%E6%B4%A5%E6%B9%96%E4%B8%BB%E6%BC%94%E6%9C%AA%E6%9B%9D%E5%85%89%E7%9A%84%E9%80%A0%E5%9E%8B%23&topic_ad='
# a = URL_IP(string)
# print(a)

string1 = r'{$g = $z.Length};$x=$w::VirtualAlloc(0,0x1000,$g,0x40);for ($i=0;$i -le ($z.Length-1);$i++) {$w::memset([IntPtr]($x.ToInt32()+$i), $z[$i], 1)};$w::CreateThread(0,0,$x,0,0,0);for (;;){Start-sleep 60};","label": 1},{"code": "[void] [System.Reflection.Assembly]::LoadWithPartialName(System.Drawing) [void] [System.Reflection.Assembly]::LoadWithPartialName(System.Windows.Forms) $objForm = New-Object System.Windows.Forms.Form $objForm.Text = Incorrect Key!$objForm.Size = New-Object System.Drawing.Size(300,200) $objForm.StartPosition = CenterScreen$objForm.KeyPreview = $True$objForm.Add_KeyDown({if ($_.KeyCode -eq Enter) {$x=$objTextBox.Text;$objForm.Close()}})$objForm.Add_'
# string1 = 'http://10000000000000000000000000006568535.tkincorrect_email.htmL yes is ahwuwheeeh 192.168.23.451'
a1 = Special_variable_names(string1)
print(a1)