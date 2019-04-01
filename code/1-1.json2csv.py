import json
import pandas as pd
import time
# Each line contains valid JSON, but as a whole, it is not a valid JSON value as
# there is no top-level list or object definition.
def flatten_json(y):
    out = {}
    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '_')
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + '_')
                i += 1
        else:
            out[name[:-1]] = x
    flatten(y)
    return out
    
#### preprocessing business datasets

# every time you call append, Pandas returns a copy of the original dataframe plus your new row.
# this is called quadratic copy, it is an O(N^2) operation that will quickly become very slow
# thus we use append here
start = time.time()
df = []
file_str = '/home/kirin/Documents/STAT628/ratingsInYelp/data/business_test.json'
with open(file_str, 'r', encoding = 'utf-8') as fin:
    for line in fin:
        j_content = json.loads(line)
        tmp = pd.DataFrame.from_dict(flatten_json(j_content), orient='index').transpose()
        df.append(tmp)
business_test = pd.concat(df, sort=False, ignore_index=True)
business_test.shape # (38000, 56)
business_test.head()
business_test.columns
business_test.to_csv('/home/kirin/Documents/STAT628/ratingsInYelp/data/business_test.csv')
end = time.time()
print(end - start) # 101.61s

start = time.time()
df = []
file_str = '/home/kirin/Documents/STAT628/ratingsInYelp/data/business_train.json'
with open(file_str, 'r', encoding = 'utf-8') as fin:
    for line in fin:
        j_content = json.loads(line)
        tmp = pd.DataFrame.from_dict(flatten_json(j_content), orient='index').transpose()
        df.append(tmp)
business_train = pd.concat(df, sort=False, ignore_index=True)
business_train.shape # (154606, 57)
business_train.head()
business_train.to_csv('/home/kirin/Documents/STAT628/ratingsInYelp/data/business_train.csv')
end = time.time()
print(end - start) # 376.68s


#### preprocessing review datasets
def load_json(file_name):
    with open(file_name) as fin:
        return pd.DataFrame.from_dict([json.loads(l) for l in fin if l.strip()])
review_test = load_json('/home/kirin/Documents/STAT628/ratingsInYelp/data/review_test.json')
review_test.to_csv('/home/kirin/Documents/STAT628/ratingsInYelp/data/review_test.csv')
review_train = load_json('/home/kirin/Documents/STAT628/ratingsInYelp/data/review_train.json')
review_train.to_csv('/home/kirin/Documents/STAT628/ratingsInYelp/data/review_train.csv')
