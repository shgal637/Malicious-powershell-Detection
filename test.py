from FastText import *
from data_process import *

if __name__ == '__main__':
    path = 'testData/test2.ps1'
    features = Extract_Features(path)
    print(features)
