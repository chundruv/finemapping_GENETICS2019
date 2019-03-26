import sys
import pandas as pd

out=sys.argv[1]

param = pd.read_csv(out+'.param.txt', sep=r'\s+')

gamma = pd.read_csv(out+'.gamma.txt', sep=r'\s+') 

param['count']=0

for i in range(0,len(gamma['s0'].value_counts().index)):
    if gamma['s0'].value_counts().index[i] != 0:
        param.loc[gamma['s0'].value_counts().index[i]-1, 'count'] += gamma['s0'].value_counts()[gamma['s0'].value_counts().index[i]]

param = param.sort_values('count', ascending=False)

for i in range(1,len(list(param['count']))):
    if sum(param['counts'][:i])*1./sum(param['count']) >= 0.95:
        cred = param[param['count']>=param['count'].tolist()[i-1]]
        break

cred.to_csv(out+'.bslmm.credsets', header=False, index=False, sep=' ')
