import xml.etree.ElementTree as ET
import subprocess
import os

# the number of nodes
unique_id = 1

# 遍历所有的节点
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
    :param file_name: the path of ast file
    :return: list of nodes
    '''
    level = 1  # from level 1
    result_list = []
    root = ET.parse(file_name).getroot()
    Search(root, level, result_list)
    return result_list

if __name__ == '__main__':
    ps1 = r'E:\PY\Ransomware\Ransomware-RandomTree\data\malicious_pure\1.ps1'
    ast = r'E:\PY\Ransomware\Ransomware-RandomTree\testData\malicious-1.xml'
    Nodes = getXmlData(ast)
    # ParameterAst, CommandParameterAst?
    # AttributeAst, Attributes?
    NodeType = ['VariableExpressionAst','TypeExpressionAst','SubExpressionAst','StringConstantExpressionAst','StatementBlockAst',
             'ScriptBlockExpressionAst','ScriptBlockAst','PipelineAst','ParenExpressionAst','ParameterAst','NamedBlockAst',
             'MemberExpressionAst','IndexExpressionAst','IfStatementAst','ForStatementAst','ExpandableStringExpressionAst',
             'ConvertExpressionAst','CommandParameterAst','CommandExpressionAst','CommandAst','BinaryExpressionAst','AttributeAst',
             'AssignmentStatementAst']
    NodeCount = {}
    Count = 0
    for type in NodeType:
        NodeCount[type] = 0
    # count nodes
    for node in Nodes:
        if node[2] in NodeType:
            NodeCount[node[2]] += 1
            Count += 1
    # the proportion
    for type in NodeCount.keys():
        NodeCount[type] /= Count
    # return the value
    proportion = []
    for type in NodeCount.keys():
        proportion.append(NodeCount[type])
    print(proportion)
