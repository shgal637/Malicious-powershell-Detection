import re
def Special_variable_names(text):
    '''
    the number of Special variable names in the script
    以使用的特殊变量名的次数作为特征
    :param text:
    :return: the number
    '''
    '''
    这里采取的方式比较简单，选取了以$开头的字符串，认定为变量名；接着用正则匹配符选出所有，在里面找特殊变量名的次数
    '''
    p = re.compile(r'\$(.*?)[ -\.:=\[\]()]')

    variable_list = re.findall(p, text)
    special_list = ['cmd', 'Shell', 'c']
    print(variable_list)
    count_special = 0

    if set(special_list) & set(variable_list):
        for k in special_list:
            count_special = count_special + variable_list.count(k)
        return count_special
    else:
        return 0

if __name__ == '__main__':
    H = 'helloworld hjshecmdj }klkkq{thank you}$var=1$cmd='
    sd = Special_variable_names(H)
    print(sd)