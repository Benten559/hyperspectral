from os import listdir
from os.path import isfile,isdir, join
import pandas as pd
import numpy 
import datetime
from dateutil import parser

def get_hdr_file_path(path):
    """ Retrieves the path to find a header file of an image set """
    hdrFilename = [f for f in listdir(path) if f[-3:] == 'hdr'][0]
    return join(path,hdrFilename)

def get_hdr_contents(hdrPath):
    """" Opens the hdr file and returns all lines """
    hdr = open(hdrPath,'r') #open the header file
    return hdr.readlines()

def retrieve_decimal_degree_array(gps):
    """ Manipulate a string to produce an array of decimal degree values """
    # log output
    gpsSplit = gps[23].split('=')
    gpsSplit = gpsSplit[1].split('{')[1]
    gpsSplit = gpsSplit.split('}')[0]
    gpsSplit = gpsSplit.split('$GNRMC,')[1:]

    return gpsSplit

def grab_raw_coords(header):
    """ This is the main control over utility functions, return value is large array of dd points """
    gpsInfo = get_hdr_contents(header)#hdr.readlines() # find the unformatted gps info
    gpsDD = retrieve_decimal_degree_array(gpsInfo) # DD coordinate array
    return gpsDD

def dm(x):
    """ UTILITY: Takes a string in dddmmmm format and breaks it apart """
    degrees = int(x) // 100
    minutes = x - 100*degrees
    return degrees, minutes

def decimal_degrees(degrees, minutes):
    """ UTILITY: Converts decimal degress to coordinate point """
    return degrees + minutes/60 

def extract_dd_latitude(dd):
    """ UTILITY: Pulls latitude decimal degree characters from raw string """
    ddItems = dd.split(',')
    return ddItems[2]


def extract_dd_longitude(dd):
    """ UTILITY: Pulls longitude decimal degree characters from raw string """
    ddItems = dd.split(',')
    return ddItems[4]


def extract_coordinate(rawCoord):
    """ Takes in one raw unformatted data point and returns lat/long """
    try:

        ddLat = dm(float(extract_dd_latitude(rawCoord)))
        ddLong = dm(float(extract_dd_longitude(rawCoord)))
        degLat = decimal_degrees(ddLat[0],ddLat[1])
        degLong = decimal_degrees(ddLong[0],ddLong[1])
        return (degLat, degLong)
    except Exception as e:
        print(e)

def get_time(path):
    """Grabs and formats the timestamp within header file"""
    hdrInfo = get_hdr_contents(path)
    timestamp = hdrInfo[12].split('=')[1]
    timestamp = timestamp.split("\n")[0].strip()
    timestamp = pd.Timestamp(timestamp[0:19])#,"%Y-%m-%dT%H:%M:%S") 

    return timestamp.to_pydatetime()

# # 
# OVERVIEW:
#   This program takes a target path to image folders and produces a spreadsheet to
#   catergorize and display location-based patterns. 
#   The spreadsheet produced contains the following:
#   Image identifier, average latitude, average longitude, timestamp, degree
#  - The degree is optional 
#  
# Note:
#   A spreadsheet with matching images to reflectance standard is used as a guide to
#   skip certain image folders and calculate the direction of the next point.
#   In another, the folder names have a different naming convention.
#   You should adjust the output names of the file accordingly
# 
# TO GET STARTED:
#   To begin using this code, alter the file path variables to your own:
##<>##
# The guide to labeled images (This must be generated using the standard identification workflow)
# df_labelGuide = pd.read_csv('V:\\Data\\St_Supery\\Standards\\Standard Identification Process\\ImageCopy_IOP4\\IOP4_Tripod_Image_Label.csv').set_index('img_id')
# Network Attached Storage, The source path to imagery
nas = "V:\\Data\\St_Supery\\IOP4_August2021\\Tripod"
# Output name of your spreadsheet file
outputName = "TripodIOP4 Nope"
# If the radian metric is desired set CALCULATE_ANGLE to True
# CALCULATE_ANGLE = True
##<>##



## BEGIN
exposurePath = 'canopy_lb_2020_5ms\\canopy_lb_2020_5ms_000000'
# the accumulator
dfInput = []
# This is a list of Image Folders
imageFolder = listdir(nas)
# Search through all image folders
for folder in imageFolder:
    try:
        # if df_labelGuide.loc[folder,'Type'] != 'VINE':
        #     continue
        # # CASE: file name has been altered 
        # elif folder[-3:] == 'STD' or folder[-3:] == 'ERR':
        #     print("skipping: " + folder)
        #     continue
        # print(folder)
        imgSubPath = join(nas,folder,exposurePath)
        hdrPath = get_hdr_file_path(imgSubPath)
        timestamp = get_time(hdrPath)
        rawGPS = grab_raw_coords(hdrPath)
        latList = [extract_coordinate(x)[0] for x in rawGPS]
        longList = [extract_coordinate(x)[1] for x in rawGPS]
        avgLat = sum(latList)/len(latList)
        avgLong = sum(longList)/len(longList)
        dfInput.append([folder,avgLat,avgLong*-1,timestamp])
    except Exception as e:
        print(e)
        continue


df_image = pd.DataFrame(dfInput,columns=["img_id","latitude","longitude","DT"])
df_image = df_image.sort_values(by='DT',ascending=True)

# if CALCULATE_ANGLE:
#     df_image['degree'] = ''
for i in range( len(df_image)-1 ):
    xDiff = df_image.iloc[i,1] - df_image.iloc[i+1,1]
    yDiff = df_image.iloc[i,2] - df_image.iloc[i+1,2]
    atan2 = numpy.arctan2(xDiff,yDiff)
    df_image.iloc[i,4] = atan2
df_image.to_csv(outputName+"_avgGPS_DT_Degree_noStandards.csv",index= False)
# else:
#     df_image.to_csv(outputName+'_avgGPS_DT_noStandards.csv',index=False)




    

