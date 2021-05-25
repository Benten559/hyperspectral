import pandas as pd
df = pd.read_csv('1000msStandardRadianceAvg.csv')

wv = df['wv'].unique() #all wavelengths used in spectral imagery

#change the existing names of image ID's to make them more iterable
df.imgID = df.imgID.apply(lambda x:x[64:76]) 
ids = df['imgID'].unique()



newDF = pd.DataFrame(columns = wv)
newDF.insert(0,'imgID',ids)
for id in ids:
    for wave in wv:
        newDF.loc[newDF.imgID == id,[wave]] = df.rad_avg.where((df.imgID==id) & (df.wv==wave)).dropna(0).unique()[0]
newDF.to_csv('1000msStandardRadAvg.csv')

