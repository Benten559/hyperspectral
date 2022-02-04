from os import listdir
from os.path import isfile,isdir, join
import pandas as pd
import numpy as np




def get_hsi_folder_names(path_RootFolder):
    return [x for x in listdir(path_RootFolder)]

def get_folder_list_from_root_dir(path_RootFolder, filter_last_three = None):
    """ Takes the root directory of spectral imagery, returns the array of full path folders. Optional filter param: last three characters of folder """
    if filter_last_three is None:
        return [join(path_RootFolder,x) for x in listdir(path_RootFolder)]
    else :
        return [join(path_RootFolder,x) for x in listdir(path_RootFolder) if x[-3:] == filter_last_three]

def get_absolute_path_HDR_from_parent_path_and_exposure(path_parent,exposure):
    """ Takes the parent folder(HSI folder) and select exposure, returns the absolute path to the HDR of that exposure """
    path_parent_exposure = [join(path_parent,x) for x in listdir(path_parent) if x.find(f'_{exposure}') != -1][0]
    path_parent_exposure_subdir = [join(path_parent_exposure,x) for x in listdir(path_parent_exposure)][0]
    path_hdr = [join(path_parent_exposure_subdir,x) for x in listdir(path_parent_exposure_subdir) if x.find('.hdr') != -1][0]
    return path_hdr

def get_mask_from_root_dir(path_RootFolder,ext_filetype):
    """" Utility to retrieve a multi-class mask from sub directory of parent spectral image folder """
    return [join(path_RootFolder,x) for x in listdir(path_RootFolder) if x[-3:] == ext_filetype][0]

def get_hdr_file_path(path):
    """ Retrieves the path to find a header file of an image set, must be have exposure sub directories in path already"""
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

def get_solar_irradiance_from_hdr_path(path):
    list_values = get_hdr_contents(path)
    irradiance = str(list_values[16].split('='))
    irradiance = np.array(irradiance.split('{')[1].split('}')[0].split(','))
    return irradiance