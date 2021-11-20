import datetime
from math import dist
import pandas as pd
import time
from datetime import timedelta, datetime
from dateutil.parser import parse
from geopy import distance


def find_earliest_time(key, imgIndex, df_plant, df_img):
    """ Searches a DataFrame for the index of the earliest time stamp, if the row item 
        has a value of "MATCHED" skip it. Returns index assigned, and updated DataFrames plant/image """
    if len(imgIndex) >= 1 :
        minTime = parse( df_img.iloc[imgIndex[0], 3] )
        minIndex = -1
    else: 
        print("No match could be made")
        return (-1,df_plant,df_img)

    for i in imgIndex:
        if parse(df_img.iloc[i,3] ) <= minTime and df_img.iloc[i,4] == '': # lowest time value 
            minIndex = i
            df_plant.loc[df_plant['Name'] == key,'match'] = df_img.iloc[i,0]
            df_img.iloc[i,0] = key 
    return (minIndex,df_plant,df_img)

def pop_matched_index(dict_p,ind):
    """ Given the matched index of an image DataFrame, eliminate all edges to the vertex 
        returns the updated dictionary of vertices """
    for key in dict_p.keys():
        if ind in dict_p[key]:
            dict_p[key].pop(dict_p[key].index(ind))
    return dict_p

def assign_singleton_matches(dict_plant, df_plant, df_img):
    """Loops through dictionary of matches, assigns any which have only 1
        Returns the updated dictionary and DataFrames for plant and images """
    for key in dict_plant.keys():
        print("Attempting access on key: " + str(key))
        if len(dict_plant[key]) == 1: # The length of edges is 1
            print(" Found a singleton ")
            if df_img.iloc[dict_plant[key][0],4] == '': # if it hasn't been matched
                matchIndex = dict_plant[key][0]
                print(" popping index of :"+ str(matchIndex))
                df_img.iloc[matchIndex,4] = key
                df_plant.loc[df_plant['Name'] == key,'match'] = df_img.iloc[matchIndex,0]
                #df_plant.ix[str(key),3] = df_img.iloc[matchIndex,0] remove?
                print(df_plant.head())
                dict_plant = pop_matched_index(dict_plant, dict_plant[key][0])
    return (dict_plant, df_plant, df_img)




# df_matched =  pd.read_csv("Bens_WORKFILE_ST_07.csv")
df_plantData = pd.read_csv('LeafLocations.csv')

# Prepping dataframes for pair-matching
# df_imageData = df_matched[df_matched['Plant #'] != 'STD']
df_plants = df_plantData[['Name','X','Y']]
df_image = pd.read_csv('TripodAvgWTime.csv')#df_imageData[['Image','X','Y','DT']]

df_plants['match'] = '' # append column
df_image['match'] = '' #append column

df_plants = df_plants.sort_values(by=['Name'])

print(df_plants.head())
print(df_image.head())
df_input = []

dict_plants = dict() # Graph of the vinyard
for i in range(len(df_plants)): # initialize node of the graph
    plantName = df_plants.iloc[i,0] # the plant id is the key value
    dict_plants[plantName] = list() # the edges to connect to images
#Notes on dataframes:
# plants [name,x,y,match]
# images [image,x,y,dt,match]
# Label matching:
for i in range(len(df_plants)):     # for each plant location
    plantX,plantY = df_plants.iloc[i,1], df_plants.iloc[i,2]
    print("Matching id:"+ str( df_plants.iloc[i,0] ))
    for j in range(len(df_image)):  # for each image point location
        imgX, imgY = df_image.iloc[j,1], df_image.iloc[j,2]
        imgTime = parse(df_image.iloc[j,3]) # timestamp of image
        diff = distance.distance((plantY,plantX),(imgY,imgX)).feet # find the distance
        #print("Iteration: " + str(df_plants.iloc[i,0]) +" currently examining image: "+ df_image.iloc[j,0])
        #print("Calulated Diff: " + str(diff))
        if diff <= 10: # if plant & image less than N feet away, store its index from df_image
            dict_plants[df_plants.iloc[i,0]].extend([j])  
    
print(df_plants.head())
print(df_image.head())
# Once all edges have been accumulated within dict-graph
for i in range(len(df_plants)):
    currentPlant = int(df_plants.iloc[i,0])
    (dict_plants, df_plants, df_image) = assign_singleton_matches(dict_plants,df_plants,df_image) # assign any with only a single match
    if df_plants.iloc[i,3] == '': # If this current plant is not yet matched
        (imgIndex, df_plants, df_image) = find_earliest_time(currentPlant, dict_plants[currentPlant], df_plants, df_image)
        if imgIndex != -1:
            dict_plants = pop_matched_index(dict_plants,imgIndex) # the index has been removed from graph

    df_input.append([  df_plants.iloc[i,0] , df_plants.iloc[i,3] ])#df_image.iloc[bestImageMatch,0]
df_ToFrom = pd.DataFrame(df_input,columns=['To','From'])
df_ToFrom.to_csv("SampleMatchWAvg.csv",index=False)




