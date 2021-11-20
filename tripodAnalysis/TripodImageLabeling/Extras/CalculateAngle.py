import pandas as pd
import numpy

df_orderme = pd.read_csv('TripodImage_avgX_avgY_DT.csv')

df_orderme = df_orderme.sort_values(by='DT',ascending=True)

df_orderme['degree'] = ''
for i in range( len(df_orderme)-1 ):
    xDiff = df_orderme.iloc[i,1] - df_orderme.iloc[i+1,1]
    yDiff = df_orderme.iloc[i,2] - df_orderme.iloc[i+1,2]
    atan2 = numpy.arctan2(xDiff,yDiff)
    df_orderme.iloc[i,4] = atan2
df_orderme.to_csv("TripodImage_avgX_avgY_DT_DegreeTEST$44.csv")