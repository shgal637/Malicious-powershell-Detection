# *_* coding : utf-8 *_*
# 开发人员 : DELL
# 开发时间 : 2022/3/8 13:18
# 文件名称 : train.py

from data_process import *
import sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split


def train_model(model):
    model.fit(train_features, train_label)
    acu_train = model.score(train_features, train_label)
    acu_test = model.score(test_features, test_label)
    y_pred = model.predict(test_features)
    recall = sklearn.metrics.recall_score(test_label, y_pred, average="macro")
    return acu_train, acu_test, recall


def model_save():
	'''
	save the trained model
	:return:
	'''
	# 创建文件目录
	Dir = r'./model/'
	path = Dir + r'model-random-tree' + r'.pkl'
	# joblib.dump(model, path)
	torch.save(model, path)


if __name__ == '__main__':
	# TORCH_SEED = 21  # 随机数种子
	# os.environ["CUDA_VISIBLE_DEVICES"] = '0'  # 设置模型在几号GPU上跑
	# device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')  # 设置device
	#
	# # 设置随机数种子，保证结果一致
	# os.environ['PYTHONHASHSEED'] = str(TORCH_SEED)
	# torch.manual_seed(TORCH_SEED)
	# torch.cuda.manual_seed_all(TORCH_SEED)
	# np.random.seed(TORCH_SEED)
	# torch.backends.cudnn.deterministic = True
	# torch.backends.cudnn.benchmark = False

	# 创建数据集
	# predata()
	# print('prepare trainset')
	# train_dataset = MyDataset(Trainjson)
	# train_features, train_label = MyDataset(Traintxt)
	# print('prepare testset')
	# test_dataset = MyDataset(Testjson)
	# test_features, test_label = MyDataset(Testtxt)
	# print('prepare train iter')
	# train_iter = DataLoader(train_dataset, batch_size=25, shuffle=True, collate_fn=batch_process)
	# print('prepare test iter')
	# test_iter = DataLoader(test_dataset, batch_size=25, shuffle=True, collate_fn=batch_process)

	# get all infos, csv
	print('get malicious datasets......\n')
	DataSet(new_path_malicious)
	print('get mixed datasets......\n')
	DataSet(new_path_mixed)
	print('get benign datasets......\n')
	DataSet(new_path_benign)

	# read features and labels from csv......
	print('Read features and labels......\n')
	features, labels = ReadData()

	print('training......\n')
	train_features, test_features, train_label,test_label = train_test_split(features, labels, test_size=0.3, random_state=2300)
	model = RandomForestClassifier(n_estimators=70, max_features=8, random_state=0)
	acu_train, acu_test, recall = train_model(model)
	print('acu_train, acu_test, recall is :')
	print(acu_train, acu_test, recall)
	print('model save......\n')
	model_save()
	print('finish')
