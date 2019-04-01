import json
import pandas as pd
import numpy as np
import datetime  # deal with time

#  input files are business_train.json and review_brunch.csv from step 1-2
#  output file is 628_brunch_lv.csv

# load input files
df_review_brunch = pd.read_csv('review_brunch.csv', lineterminator='\n', index_col=0)
bus_train = []
for line in open ('business_train.json', 'r'):
    bus_train.append(json.loads(line))
df_bus_train = pd.DataFrame.from_dict(bus_train)
cols = df_bus_train.columns.tolist()
newcols = [cols[1],cols[8],cols[3],cols[10],cols[9],cols[6],cols[7],cols[5],cols[0],cols[2],cols[4]]
df_bus_1 = df_bus_train[newcols]

# view attributes
attributes = df_bus_train['attributes']
hours = df_bus_train['hours']
all_attributes = set(attributes[0].keys())
for i in range(1,len(attributes)):
    if pd.isna(attributes[i]) == False:
        all_attributes = all_attributes.union(set(attributes[i].keys()))
len(all_attributes)

# extract attributes from dictionary
all_attributes = list(all_attributes)
all_hrs = []
for i in range(len(hours)):
    if pd.isna(hours[i])==False:
        all_hrs = list(set(all_hrs + list(hours[i].keys())))
for i in range(len(all_attributes)):
    alist = []
    for j in range(len(attributes)):
            if pd.isna(attributes[j])==False:
                if all_attributes[i] in set(attributes[j].keys()):
                    alist.append(attributes[j][all_attributes[i]])
                else: alist.append('NA')
            else: alist.append('NA')
    df_bus_1[all_attributes[i]]=alist

# extract hours from dictionary
for i in range(len(all_hrs)):
    blist = []
    for j in range(len(hours)):
            if pd.isna(hours[j])==False:
                if all_hrs[i] in set(hours[j].keys()):
                    blist.append(hours[j][all_hrs[i]])
                else: blist.append('NA')
            else: blist.append('NA')
    df_bus_1[all_hrs[i]]=blist

# calculate open hours for each day
df_bus_1[['Monday_open','Monday_close']]=df_bus_1.pop('Monday').str.extract('(.*)-(.*)',  expand=True)
df_bus_1[['Tuesday_open','Tuesday_close']]=df_bus_1.pop('Tuesday').str.extract('(.*)-(.*)',  expand=True)
df_bus_1[['Wednesday_open','Wednesday_close']]=df_bus_1.pop('Wednesday').str.extract('(.*)-(Sunday.*)',  expand=True)
df_bus_1[['Thursday_open','Thursday_close']]=df_bus_1.pop('Thursday').str.extract('(.*)-(.*)',  expand=True)
df_bus_1[['Friday_open','Friday_close']]=df_bus_1.pop('Friday').str.extract('(.*)-(.*)',  expand=True)
df_bus_1[['Saturday_open','Saturday_close']]=df_bus_1.pop('Saturday').str.extract('(.*)-(.*)',  expand=True)
df_bus_1[['Sunday_open','Sunday_close']]=df_bus_1.pop('Sunday').str.extract('(.*)-(.*)',  expand=True)
week_day = ["Monday", "Tuesday" ,"Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
for temp_day in week_day:
    time_open = df_bus_1[temp_day+'_open'].replace(np.nan, '', regex=True)
    time_open_datetime = (pd.Series ([datetime.datetime.strptime(item, "%H:%M") if item != '' else None
                                     for item in time_open ]))
    time_close = df_bus_1[temp_day+'_close'].replace(np.nan, '', regex=True)
    time_close_datetime = (pd.Series ([datetime.datetime.strptime(item, "%H:%M") if item != '' else None
                                     for item in time_close ]))
    time_diff_1=(time_close_datetime-time_open_datetime)/np.timedelta64(1, 'h')
    time_diff_1[time_diff_1 <= 0]=time_diff_1[time_diff_1 <= 0]+24
    time_diff_1[time_diff_1.isnull() & df_bus_1[['hours']].notnull().iloc[:,0]] = 0
    df_bus_1[temp_day+"_hours"] = time_diff_1
for temp_day in week_day:
        df_bus_1=df_bus_1.drop(columns=[temp_day+'_open',temp_day+'_close'])

# select all Breakfast & Brunch business
df_bus_brunch=df_bus_1[df_bus_1['categories'].str.contains('Breakfast & Brunch', na=False)]
df_bus_brunch.shape  # (4322, 57)
sum( df_bus_brunch['city'].str.match('Las Vegas', na=False))

# merge All brunch business with review
df_merge = df_review_brunch.merge(df_bus_brunch, how = 'left', on = 'business_id')
df_merge_brunch = df_merge[df_merge['categories'].str.contains('Breakfast & Brunch', na=False)]
df_merge_brunch.shape  # (521672, 60)

# merge Las Vegas brunch with review
df_merge_brunch_lv = df_merge_brunch[df_merge_brunch['city'].str.match('Las Vegas', na=False)]
df_merge_brunch_lv.shape  # (169529, 60)
df_merge_brunch_lv.to_csv('628_brunch_lv.csv')
