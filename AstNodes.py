# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/9 21:06
# 文件名称 : AstNodes.py
import xml.etree.ElementTree as ET

# the number of nodes
unique_id = 1

def Search(root_node, level, result_list):
    '''
    get all the nodes in ast
    :param root_node: the current node
    :param level: the level of current node
    :param result_list: list of nodes
    :return:
    '''
    global unique_id
    temp_list = [unique_id, level, root_node.tag, root_node.attrib]
    result_list.append(temp_list)
    unique_id += 1

    # the child nodes
    children_node = root_node.getchildren()
    if len(children_node) == 0:
        return
    for child in children_node:
        Search(child, level + 1, result_list)
    return

def getXmlData(file_name):
    '''
    get the nodes in ast
    :rtype: object
    :param file_name: the path of ast file
    :return: list of nodes
    '''
    level = 1  # from level 1
    result_list = []
    root = ET.parse(file_name).getroot()
    Search(root, level, result_list)
    return result_list
