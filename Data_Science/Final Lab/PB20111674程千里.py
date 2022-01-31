#!/usr/bin/env python
# coding: utf-8

# In[5]:


import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import re
from sklearn.metrics import roc_auc_score, precision_recall_curve, roc_curve, average_precision_score
from sklearn.model_selection import KFold
from sklearn.model_selection import StratifiedKFold
from dateutil.relativedelta import relativedelta
from sklearn.cluster import KMeans
from sklearn.preprocessing import MinMaxScaler
from sklearn.preprocessing import LabelEncoder, OneHotEncoder

pd.set_option('max_columns', None)#便于查看所有的属性
pd.set_option('max_rows', 200)


# In[2]:


train_public = pd.read_csv(r"D:\Data\train_public.csv")
test_public = pd.read_csv(r"D:\Data\test_public.csv")
train_inte = pd.read_csv(r"D:\Data\train_internet.csv")


# In[3]:


def WorkYearTransform(x):
    if str(x)=='nan':
        return -1
    x = x.replace('< 1','0')
    return int(re.search('(\d+)', x).group())
        #search扫描整个字符串，返回第一个匹配成功的。group是获取字符串整体。

def DateTransform(x):
    a = re.search('(\d+-)', x)
    if a is None:
        return '1-'+x#无年份则默认2001
    return x + '-01'#无日则默认1日


# In[6]:


train_public['work_year'] = train_public['work_year'].map(WorkYearTransform)
test_public['work_year'] = test_public['work_year'].map(WorkYearTransform)
train_inte['work_year'] = train_inte['work_year'].map(WorkYearTransform)

#将日期标准化
train_public['earlies_credit_mon'] = pd.to_datetime(train_public['earlies_credit_mon'].map(DateTransform))
test_public['earlies_credit_mon'] = pd.to_datetime(test_public['earlies_credit_mon'].map(DateTransform))
train_inte['earlies_credit_mon'] = pd.to_datetime(train_inte['earlies_credit_mon'].map(DateTransform))

train_public['issue_date'] = pd.to_datetime(train_public['issue_date'])
test_public['issue_date'] = pd.to_datetime(test_public['issue_date'])
train_inte['issue_date'] = pd.to_datetime(train_inte['issue_date'])


# In[7]:


#将日期转化为数字
train_public['issue_date_month'] = train_public['issue_date'].dt.month
test_public['issue_date_month'] = test_public['issue_date'].dt.month
train_inte['issue_date_month'] = train_inte['issue_date'].dt.month
train_public['issue_date_year'] = train_public['issue_date'].dt.year
test_public['issue_date_year'] = test_public['issue_date'].dt.year
train_inte['issue_date_year'] = train_inte['issue_date'].dt.year
    #issue_data里面全是一号,当然我认为都可以忽略日

train_public['earlies_credit_month'] = train_public['earlies_credit_mon'].dt.month
test_public['earlies_credit_month'] = test_public['earlies_credit_mon'].dt.month
train_inte['earlies_credit_month'] = train_inte['earlies_credit_mon'].dt.month
train_public['earlies_credit_year'] = train_public['earlies_credit_mon'].dt.year
test_public['earlies_credit_year'] = test_public['earlies_credit_mon'].dt.year
train_inte['earlies_credit_year'] = train_inte['earlies_credit_mon'].dt.year


# In[8]:


#贷款类型的数字化
ClassTransform = {
    'A': 1,
    'B': 2,
    'C': 3,
    'D': 4,
    'E': 5,
    'F': 6,
    'G': 7,
}
train_public['class'] = train_public['class'].map(ClassTransform)
test_public['class'] = test_public['class'].map(ClassTransform)
train_inte['class'] = train_inte['class'].map(ClassTransform)

#企业类型数字化
EmployerTransform = {
    '政府机构':1,
    '世界五百强':2,
    '幼教与中小学校':3,
    '高等教育机构':4,
    '普通企业':5,
    '上市企业':6,
}
train_public['employer_type'] = train_public['employer_type'].map(EmployerTransform)
test_public['employer_type'] = test_public['employer_type'].map(EmployerTransform)
train_inte['employer_type'] = train_inte['employer_type'].map(EmployerTransform)

#行业类型数字化
IndustryTransform = {
    '金融业':1,
    '公共服务、社会组织':2,
    '文化和体育业':3,
    '信息传输、软件和信息技术服务业':4,
    '制造业':5,
    '住宿和餐饮业':6,
    '建筑业':7,
    '电力、热力生产供应业':8,
    '房地产业':9,
    '交通运输、仓储和邮政业':10,
    '批发和零售业':11,
    '农、林、牧、渔业':12,
    '采矿业':13,
    '国际组织':14,
}
train_public['industry'] = train_public['industry'].map(IndustryTransform)
test_public['industry'] = test_public['industry'].map(IndustryTransform)
train_inte['industry'] = train_inte['industry'].map(IndustryTransform)

#work_type数字化
WorkTypeTransform = {
    '职员':1,
    '工人':2,
    '工程师':3,
    '公务员':4,
    '其他':5,
}
train_inte['work_type'] = train_inte['work_type'].map(WorkTypeTransform)


# In[9]:


#缺失值处理
train_public['pub_dero_bankrup']=train_public['pub_dero_bankrup'].fillna(train_public['pub_dero_bankrup'].mean())
train_inte['pub_dero_bankrup']=train_inte['pub_dero_bankrup'].fillna(train_inte['pub_dero_bankrup'].mean())
test_public['pub_dero_bankrup']=test_public['pub_dero_bankrup'].fillna(test_public['pub_dero_bankrup'].mean())

#f系列数据由大量缺失，但缺失率在5%左右
#先试试均值的情况
train_public['f0']=train_public['f0'].fillna(train_public['f0'].mean())
train_public['f1']=train_public['f1'].fillna(train_public['f1'].mean())
train_public['f2']=train_public['f2'].fillna(train_public['f2'].mean())
train_public['f3']=train_public['f3'].fillna(train_public['f3'].mean())
train_public['f4']=train_public['f4'].fillna(train_public['f4'].mean())

train_inte['f0']=train_inte['f0'].fillna(train_inte['f0'].mean())
train_inte['f1']=train_inte['f1'].fillna(train_inte['f1'].mean())
train_inte['f2']=train_inte['f2'].fillna(train_inte['f2'].mean())
train_inte['f3']=train_inte['f3'].fillna(train_inte['f3'].mean())
train_inte['f4']=train_inte['f4'].fillna(train_inte['f4'].mean())
train_inte['f5']=train_inte['f5'].fillna(train_inte['f5'].mean())

test_public['f0']=test_public['f0'].fillna(test_public['f0'].mean())
test_public['f1']=test_public['f1'].fillna(test_public['f1'].mean())
test_public['f2']=test_public['f2'].fillna(test_public['f2'].mean())
test_public['f3']=test_public['f3'].fillna(test_public['f3'].mean())
test_public['f4']=test_public['f4'].fillna(test_public['f4'].mean())

train_inte['debt_loan_ratio']=train_inte['debt_loan_ratio'].fillna(train_inte['debt_loan_ratio'].mean())
train_inte['recircle_u']=train_inte['recircle_u'].fillna(train_inte['recircle_u'].mean())
train_inte['title']=train_inte['title'].fillna(train_inte['title'].mode()[0])
train_inte['post_code'] = train_inte['post_code'].fillna(train_inte['post_code'].mode()[0])


# In[10]:


col_to_drop = ['issue_date', 'earlies_credit_mon']
train_public = train_public.drop(col_to_drop, axis=1)
test_public = test_public.drop(col_to_drop, axis=1 )
train_inte = train_inte.drop(col_to_drop, axis=1 )
train_inte = train_inte.rename(columns={'is_default':'isDefault'})


# In[11]:


#贷款种类和利率息息相关，而利率和还款压力是很相关的，故认为sub_class也很重要，
#故而填充相关缺失值
#用kmeans聚类，单独在train_data内聚类是因为这个数据集和train_inte有很多特征种类不同，
#不便于聚类，而且从经验上讲二者也不也有不同之处

#只有class为A的元组的sub_class才可能为A1、A2等，所以在class为A的元组中进行聚类得到A1等
def Kmeans(data, label):
    mms = MinMaxScaler()#归一化
    feats = [f for f in data.columns if f not in ['isDefault']]
    data = data[feats]
    mmsModel = mms.fit_transform(data.loc[data['class'] == label])
    clf = KMeans(5, random_state=1214)
    pre = clf.fit(mmsModel)
    test = pre.labels_
    final = pd.Series(test, index=data.loc[data['class'] == label].index)
    if label == 1:
        final = final.map({0: 'A1', 1: 'A2', 2: 'A3', 3: 'A4', 4: 'A5'})
    elif label == 2:
        final = final.map({0: 'B1', 1: 'B2', 2: 'B3', 3: 'B4', 4: 'B5'})
    elif label == 3:
        final = final.map({0: 'C1', 1: 'C2', 2: 'C3', 3: 'C4', 4: 'C5'})
    elif label == 4:
        final = final.map({0: 'D1', 1: 'D2', 2: 'D3', 3: 'D4', 4: 'D5'})
    elif label == 5:
        final = final.map({0: 'E1', 1: 'E2', 2: 'E3', 3: 'E4', 4: 'E5'})
    elif label == 6:
        final = final.map({0: 'F1', 1: 'F2', 2: 'F3', 3: 'F4', 4: 'F5'})
    elif label == 7:
        final = final.map({0: 'G1', 1: 'G2', 2: 'G3', 3: 'G4', 4: 'G5'})
    return final

train_public1 = Kmeans(train_public, 1)
train_public2 = Kmeans(train_public, 2)
train_public3 = Kmeans(train_public, 3)
train_public4 = Kmeans(train_public, 4)
train_public5 = Kmeans(train_public, 5)
train_public6 = Kmeans(train_public, 6)
train_public7 = Kmeans(train_public, 7)
train_all = pd.concat([train_public1, train_public2, train_public3, train_public4, train_public5, train_public6, train_public7]).reset_index(drop=True)
train_public['sub_class'] = train_all

test_public1 = Kmeans(test_public, 1)
test_public2 = Kmeans(test_public, 2)
test_public3 = Kmeans(test_public, 3)
test_public4 = Kmeans(test_public, 4)
test_public5 = Kmeans(test_public, 5)
test_public6 = Kmeans(test_public, 6)
test_public7 = Kmeans(test_public, 7)
test_all = pd.concat([test_public1, test_public2, test_public3, test_public4, test_public5, test_public6, test_public7]).reset_index(drop=True)
test_public['sub_class'] = test_all


# In[12]:


col = ['sub_class']
lbl = LabelEncoder().fit(train_public[col])
train_public[col] = lbl.transform(train_public[col])
test_public[col] = lbl.transform(test_public[col])
train_inte[col] = lbl.transform(train_inte[col])


# In[13]:


tr_cols = set(train_public.columns)
same_col = list(tr_cols.intersection(set(train_inte.columns)))
train_inteSame = train_inte[same_col].copy()
train = pd.concat([train_public,train_inteSame]).reset_index(drop=True)


# In[14]:


#缺失值用-1表示
train['known_outstanding_loan']=train['known_outstanding_loan'].fillna(-1)
train['known_dero']=train['known_dero'].fillna(-1)
train['app_type']=train['app_type'].fillna(-1)


# In[15]:


#注意到
#interest,class:0.952875
#total_loan,monthly_payment:0.952974，保留前者，因为其可以反应违约收益
#scoring_low,scoring_high:0.924619
#f3,f4:0.838122
#early_return_amount,early_return_amount_3mon:0.851380
train['total_payment']=train['year_of_loan']*12*train['monthly_payment']
del train['year_of_loan']
del train['monthly_payment']
del train['interest']
train['scoring']=(train['scoring_high']+train['scoring_low'])/2
del train['scoring_high']
del train['scoring_low']
del train['f4']
del train['early_return_amount']#近三个月的情况应该更有时效性
del train['loan_id']
del train['user_id']
del train['policy_code']#数据中此特征的值只有1


# In[16]:


test_public['total_payment']=test_public['year_of_loan']*12*test_public['monthly_payment']
del test_public['year_of_loan']
del test_public['monthly_payment']
del test_public['interest']
test_public['scoring']=(test_public['scoring_high']+test_public['scoring_low'])/2
del test_public['scoring_high']
del test_public['scoring_low']
del test_public['f4']
del test_public['early_return_amount']#近三个月的情况应该更有时效性
del test_public['policy_code']
test = test_public.drop(['loan_id','user_id'],axis=1,inplace=False)


# In[89]:


from sklearn.model_selection import GridSearchCV
from sklearn.tree import DecisionTreeClassifier, export_graphviz
from sklearn import  metrics
df_x=train.drop('isDefault',axis=1)
df_y=train.loc[:,'isDefault']
model=DecisionTreeClassifier(#默认基尼系数
    random_state=2021,
    max_depth=9,
    min_sample_leaf=99,
    #max_leaf_nodes=,
    min_impurity_decrease=0.001
)
dtc=model.fit(df_x,df_y)
display = metrics.plot_roc_curve(dtc, df_x, df_y)
print('type(display):',type(display))
plt.show()


# In[92]:


from sklearn.model_selection import cross_val_score
cross_val_score(model, df_x, df_y, cv=10, scoring='accuracy')


# In[93]:


cross_val_score(model, df_x, df_y, cv=10, scoring='roc_auc')


# In[49]:


import pydotplus
dot_data =export_graphviz(dtc, out_file=None,feature_names=df_x.columns)
graph = pydotplus.graph_from_dot_data(dot_data)
graph.write_pdf('iris.pdf')


# In[53]:


from sklearn.model_selection import cross_val_score
clf=DecisionTreeClassifier(criterion="gini")
cross_val_score(clf, df_x, df_y, cv=10, scoring='accuracy')


# In[59]:





# In[90]:


from sklearn.model_selection import train_test_split
x_train,x_test,y_train,y_test=train_test_split(df_x,df_y,test_size=0.3)
dtc2=dtc.fit(x_train,y_train)
y_pre = dtc2.predict(x_test)


# In[91]:


mse = metrics.mean_squared_error(y_test, y_pre)
print("MSE: %.4f" % mse)

mae = metrics.mean_absolute_error(y_test, y_pre)
print("MAE: %.4f" % mae)

ascore = metrics.accuracy_score(y_test, y_pre)
print("ACCURACY SCORE: %.4f" %ascore)


# In[78]:


display = metrics.plot_roc_curve(clf2, x_test, y_test)
print('type(display):',type(display))
plt.show()


# In[96]:


y_submission=dtc.predict(test)


# In[97]:


submission = pd.DataFrame({'id':test_public['loan_id'], 'isDefault':y_submission})


# In[98]:


submission


# In[100]:


submission['isDefault'].value_counts()


# In[ ]:




