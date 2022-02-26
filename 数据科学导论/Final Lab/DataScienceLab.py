from sklearn import tree 
from sklearn.datasets import load_iris
import time
import pandas as pd
import numpy as np
import plotly
import plotly.figure_factory as ff
import pydotplus
from IPython.display import Image
import os

train = pd.read_csv("C:\\Users\\Huawei\\Desktop\\2021秋\\数据科学导论\\train_dataset (1)\\train_public.csv",encoding='gbk', nrows= 9000)
test = pd.read_csv("C:\\Users\\Huawei\\Desktop\\2021秋\\数据科学导论\\train_dataset (1)\\train_public_test.csv",encoding='gbk', nrows = 599) 
print(train.head())


def data_transfer(train):
   #数据预处理
    train = train.drop(['loan_id', 'user_id', 'censor_status', 'post_code', 'region', 'earlies_credit_mon'], axis = 1)    #删除若干无关列

    def time_transfer(issue_date):
        issue_date = issue_date + ' 00:00:00'
        a = time.strptime(issue_date,'%Y/%m/%d %H:%M:%S') #转换为时间组对象
        return time.mktime(a)

    # 0.01265888   0.01213446
    train['issue_date'] = train['issue_date'].apply(time_transfer)

    def score_numjudge(scoring_high, scoring_low):      #利用上下界计算平均信用分
        return 1/2 *(scoring_high + scoring_low)
    train['ave_credits'] = train.apply(lambda x: score_numjudge(x['scoring_high'], x['scoring_low']), axis= 1)
    train = train.drop(['scoring_low', 'scoring_high'], axis = 1)

    #total_loan , year_of_loan:  0.03692911, 0.03114437
    #0.0323906 , 0.01897186
    def loan_peryear(total_loan, year_of_loan):
        return total_loan * year_of_loan
    train['loan_peryear'] = train.apply(lambda x: loan_peryear(x['total_loan'], x['year_of_loan']), axis= 1)
    train = train.drop(['total_loan', 'year_of_loan'], axis = 1)

    temp = train.pop('loan_peryear')
    train.insert(1, 'loan_peryear', temp)

    #print(train['work_year'].describe())
    #print(train['work_year'].value_counts())
    #print(train.isnull().any()) #查找缺失值

    def work_year_trans(work_year):      #处理工作时间, 1 代表<=1, 2 代表 >2 and <= 5, 3 代表 >5 and <= 9, 4 代表 > 9
        work_year = str(work_year)
        if work_year == '< 1 year' or work_year == '1 year':
            return 1
        elif work_year[0] >= '2' and work_year[0] < '5':
            return 2
        elif work_year[0] >= '5' and work_year[0] <= '9':
            return 3
        elif work_year == '10+ years':
            return 4

    train['work_year'] = train['work_year'].apply(work_year_trans)

    #train['work_year'].fillna(train['work_year'].median(), inplace=True)    #用中位数处理缺失的数据
    train['work_year'].fillna(method ='ffill', inplace=True) 
    #print(train['work_year'].describe())
    #print(train['work_year'].value_counts())


    #处理等级
    #print(train['class'].describe())
    #print(train['class'].value_counts())
    def class_trans(stri):
        #stri = str(stri)
        if stri == 'A':
            return 0
        elif stri == 'B':
            return 1
        elif stri == 'C':
            return 2
        elif stri == 'D':
            return 3
        elif stri == 'E':
            return 4
        elif stri == 'F':
            return 5
        elif stri == 'G':
            return 6
    train['class'] = train['class'].apply(class_trans)

    #print(train['class'].describe())
    #print(train['industry'].value_counts())
    def industry_transfer(industry):
        industrylist = ['金融业', '电力、热力生产供应业', '公共服务、社会组织', '住宿和餐饮业', '信息传输、软件和信息技术服务业',
                        '文化和体育业', '建筑业', '房地产业', '采矿业', '交通运输、仓储和邮政业', '农、林、牧、渔业', '制造业',
                        '批发和零售业', '国际组织']
        return industrylist.index(industry)
    train['industry'] = train['industry'].apply(industry_transfer)

    def employer_transfer(employer_type):
        employerlist = ['普通企业', '政府机构', '幼教与中小学校', '上市企业', '世界五百强', '高等教育机构']
        return employerlist.index(employer_type)
    train['employer_type'] = train['employer_type'].apply(employer_transfer)

    score = train.pop('ave_credits')
    train.insert(1, 'ave_credits', score)

    train = train.fillna(0)     #处理其他缺失值

    #print(train.isnull().any()) #查找缺失值
    #预处理完成
    print(train.head())
    return train


train = data_transfer(train)
#print(test['industry'].value_counts())
test = data_transfer(test)
#print(test.head())

from sklearn.tree import DecisionTreeClassifier as DTC, export_graphviz
X = train.iloc[:, 0:29]
y = train.iloc[:, 30]
dtc = DTC(criterion='gini',max_depth = 8, min_samples_leaf= 10,max_features= 15)  # 基于信息熵
dtc.fit(X, y)
#print('准确率：', dtc.score(X, y))
#with open('C:\\Users\\Huawei\\Desktop\\tree.dot', 'w+') as f:
 #   f = export_graphviz(dtc, feature_names=X.columns, out_file=f)

#print([*zip(X.columns),dtc.feature_importances_])
#'''
dot_data = tree.export_graphviz(dtc, out_file=None,
                         feature_names=X.columns,                        
                         #class_names=np.unique(y),
                         )

graph = pydotplus.graph_from_dot_data(dot_data)
graph.write_pdf('iris_md_2.pdf')
#'''
#print(train.isnull().any()) #查找缺失值
#print(train['work_year'].describe())
y_pre = dtc.predict(test.iloc[:, 0:29])
y_test = test.iloc[:, 30]
X_test = test.iloc[:, 0:29]

print(dtc.score(test.iloc[:, 0:29], test.iloc[:, 30]))
#print(train.head())
from sklearn import  metrics
mse = metrics.mean_squared_error(y_test, y_pre)
print("MSE: %.4f" % mse)

mae = metrics.mean_absolute_error(y_test, y_pre)
print("MAE: %.4f" % mae)
#print(y_test[0:100])
#print(y_pre[0:100])

R2 = metrics.r2_score(y_test,y_pre)
print("R2: %.4f" % R2)

score = metrics.accuracy_score(y_test, y_pre)
print("%.4f" %score)


import matplotlib.pyplot as plt
display = metrics.plot_roc_curve(dtc, X_test, y_test)
print('type(display):',type(display))
plt.show()