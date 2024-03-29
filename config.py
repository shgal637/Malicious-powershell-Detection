# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 14:03
# 文件名称 : config.py
import os
from keras.models import load_model

path_malicious = "./data/malicious_pure"             # 恶性样本相对路径
path_mixed = "./data/mixed_malicious"                # 混杂样本相对路径
path_benign = "./data/powershell_benign_dataset"     # 良性样本相对路径
Dataset = './data/dataset.csv'

# 39
headers = ['label', 'AST1', 'AST2', 'AST3', 'AST4', 'AST5', 'AST6', 'AST7', 'AST8', 'AST9', 'AST10', 'AST11', 'AST12', 'AST13', 'AST14', 'AST15', 'AST16', 'AST17', 'AST18', 'AST19', 'AST20', 'AST21', 'AST22','AST23',
           'behaviour','shell','entropy','top1char', 'top2char', 'top3char', 'top4char', 'top5char','UrlIp','strNum','maxLen','AveLen','var','L','confidence']

# AST中的23种节点类型
# ParameterAst, CommandParameterAst?
# AttributeAst, Attributes?
NodeType = ['VariableExpressionAst', 'TypeExpressionAst', 'SubExpressionAst', 'StringConstantExpressionAst',
                'StatementBlockAst',
                'ScriptBlockExpressionAst', 'ScriptBlockAst', 'PipelineAst', 'ParenExpressionAst', 'ParameterAst',
                'NamedBlockAst',
                'MemberExpressionAst', 'IndexExpressionAst', 'IfStatementAst', 'ForStatementAst',
                'ExpandableStringExpressionAst',
                'ConvertExpressionAst', 'CommandParameterAst', 'CommandExpressionAst', 'CommandAst',
                'BinaryExpressionAst', 'AttributeAst',
                'AssignmentStatementAst']

if os.path.exists('./model/Fasttext_model.h5'):
    FastTextmodel = load_model('./model/Fasttext_model.h5')