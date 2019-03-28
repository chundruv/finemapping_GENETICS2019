import sys
import pandas as pd
from decimal import Decimal
import numpy as np

out=sys.argv[1]

x=pd.read_csv('output/'+out+'.single.txt', skiprows=1, sep=r'\s+', error_bad_lines=False)

x['bf10']=np.float128(10)**x['bf']
x=x.sort_values('bf10', ascending=False)
x=x.reset_index()

if np.isinf(sum(x['bf10'])):
    x['bf']=map(Decimal, x['bf'])
    x['bf10']=[Decimal(10)**i for i in x['bf']]
    x=x.sort_values('bf10', ascending=False)
    x=x.reset_index()

for i in range(1,(len(x)+1)):
    if sum(x[:i]['bf10'])/sum(x['bf10']) > 0.95:
        cred=x[x['bf10']>=x['bf10'].tolist()[i-1]]
        break

cred.to_csv('output/'+out+'.bimbam.credsets', header=False, index=False, sep=' ')
