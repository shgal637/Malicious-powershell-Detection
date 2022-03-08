# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 13:18
# 文件名称 : train.py

# train the shellcode detection model
import torch
import torch.nn as nn
import tensorflow as tf
import os
import numpy as np
from torch.utils.data import DataLoader
from data_process import *

# config
embed_dim = 300
epoch = 100

# 训练函数
def train(epochs):
	model.train()  # 模型设置成训练模式
	for epoch in range(epochs):  # 训练epochs轮
		print('epoch: ', epoch)
		loss_sum = 0   # 记录每轮loss
		for batch in train_iter:
			input_, label = batch
			optimizer.zero_grad()  # 每次迭代前设置grad为0

			output = model(input_)

			loss = criterion(output, label)  # 计算loss
			loss.backward()  # 反向传播
			optimizer.step()  # 更新模型参数
			loss_sum += loss.item()  # 累积loss
		print('epoch: ', epoch, 'loss:', loss_sum / len(train_iter))

	test_acc = evaluate()  # 模型训练完后进行测试
	print('test_acc:', test_acc)

# 测试函数
def evaluate():
	model.eval()
	total_acc, total_count = 0, 0
	loss_sum = 0

	with torch.no_grad():  # 测试时不计算梯度
		for batch in test_iter:
			input_, label = batch

			predicted_label = model(input_)

			loss = criterion(predicted_label, label)  # 计算loss
			total_acc += (predicted_label.argmax(1) == label).sum().item()  # 累计正确预测数
			total_count += label.size(0)  # 累积总数
			loss_sum += loss.item()  # 累积loss
		print('test_loss:', loss_sum / len(test_iter))

	return total_acc/total_count


# BiLSTM模型
class LSTM_Network(nn.Module):
	def __init__(self):
		super(LSTM_Network, self).__init__()
		self.embedding = nn.Embedding(vocab_size, embed_dim)
		self.lstm = nn.GRU(input_size=embed_dim, hidden_size=int(embed_dim / 2), batch_first=True, bidirectional=True)
		# 如果bidirectional设置True则为BiLSTM，但是相应的hidden_size记得除2
		self.fc = nn.Linear(in_features=embed_dim, out_features=2)  # 全连接层

	def forward(self, input):
		input = self.embedding(input)
		output, _ = self.lstm(input)  # output的size为[batch, seq, embedding]
		output = self.fc(output[:, -1, :])   # 句子最后时刻的 hidden state

		return output


def model_save():
	'''
	save the trained model
	:return:
	'''
	# 创建文件目录
	Dir = r'./model/Bilstm/'
	path = Dir + r'model-' + str(epoch) + r'.pkl'
	# joblib.dump(model, path)
	torch.save(model, path)


if __name__ == '__main__':
	TORCH_SEED = 21  # 随机数种子
	os.environ["CUDA_VISIBLE_DEVICES"] = '0'  # 设置模型在几号GPU上跑
	device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')  # 设置device

	# 设置随机数种子，保证结果一致
	os.environ['PYTHONHASHSEED'] = str(TORCH_SEED)
	torch.manual_seed(TORCH_SEED)
	torch.cuda.manual_seed_all(TORCH_SEED)
	np.random.seed(TORCH_SEED)
	torch.backends.cudnn.deterministic = True
	torch.backends.cudnn.benchmark = False

	# 创建数据集
	# Txt2json()
	print('prepare trainset')
	train_dataset = MyDataset(Trainjson)
	print('prepare testset')
	test_dataset = MyDataset(Testjson)
	print('prepare train iter')
	train_iter = DataLoader(train_dataset, batch_size=25, shuffle=True, collate_fn=batch_process)
	print('prepare test iter')
	test_iter = DataLoader(test_dataset, batch_size=25, shuffle=False, collate_fn=batch_process)

	# 定义模型
	model = LSTM_Network().to(device)

	# 定义loss函数、优化器
	criterion = nn.CrossEntropyLoss()
	optimizer = torch.optim.Adagrad(model.parameters(), lr=0.01, weight_decay=0.001)

	# 开始训练
	print('begin train......')
	train(epoch)
	model_save()
