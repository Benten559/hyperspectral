from os import listdir
from os.path import isfile,isdir, join
import pandas as pd
import numpy as np
#####################
# change log:       #
#####################
# 
## 12/17/2021
# Adding function to return the values of ENVI line : "Solar Irradiance"
##

# 
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

def get_gain_array(path):
    """Grab the data gain values as an array"""
    hdrInfo = get_hdr_contents(path)
    gains = np.array(hdrInfo[14])
    return gains

def get_solar_irradiance_from_hdr_path(path):
    """Return the value of the solar irrdiance field from HDR file"""
    hdrInfo = get_hdr_contents(path)
    solarIrr = hdrInfo[16].split('=')[1]
    solarIrr = solarIrr.split('{')[1]
    solarIrr = solarIrr.split('}')[0]
    solarIrr = solarIrr.split(',')
    return solarIrr