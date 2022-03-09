# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 14:03
# 文件名称 : config.py
path_malicious = "./data/malicious_pure"             # 恶性样本相对路径
path_mixed = "./data/mixed_malicious"                # 混杂样本相对路径
path_benign = "./data/powershell_benign_dataset"     # 良性样本相对路径
Trainjson = './data/train.json'                      # 训练数据集json格式
Testjson = './data/test.json'                        # 测试数据集json格式
Dataset = './data/dataset.txt'
Traintxt = './data/train.txt'
Testtxt = './data/test.txt'
# embed_dim = 300     # 暂时的参数，注意更换模型
# epoch = 100

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