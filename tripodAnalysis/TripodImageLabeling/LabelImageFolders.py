from os import listdir , rename
from os.path import join, exists
import pandas as pd
## This script creates a spreadsheet based on which folder each image is within
## Before starting this script, make sure that you have stored all standards and plants within 
## the appropriate folders.

## Additionaly, set the name of the spreadsheet below on line 44 to reflect the correct set of images

# Set the nas variable to the tripod image directory

# nas = 'V:\\Data\\St_Supery\\IOP3_July2021\\Tripod'
# nas = 'V:\\Data\\St_Supery\\IOP4_August2021\\Tripod'
# nas = 'V:\\Data\\St_Supery\\‭IOP5_Sep2021\\Tripod'
# nas = 'V:\\Data\\St_Supery\\‭IOP5_Sep2021\\Tripod'
nas = 'V:\\Data\\St_Supery\\IOP6_October2021\\tripod'
wd = 'C:\\Users\\15593\\Documents\\repos\\hyperspectral\\DroneImageLabeling\\Standard Identification\\ImageCopy_IOP3'
errorFolder = 'Errors'
plantFolder = 'Plant'
standardFolder = 'Standard'
imageFolders = listdir(nas)
df_input = []
for folder in imageFolders:
    try:
        # check if this image has been placed in Standard folder
        if exists(join(wd,standardFolder,folder+".png")):
            df_input.append([folder,'STD'])
            # if folder[-3:] == 'STD': # if the last 3 characters are already STD, skip
            #     print("already labeled: "+folder)
            #     continue
            # else: # append the STD to the folder name
            #     rename( join(nas,folder),join(nas,folder+" STD") )
        # check if this image has been placed in error folder 
        elif exists(join(wd,errorFolder,folder+".png")):
            df_input.append([folder,'ERR'])
            # rename( join(nas,folder),join(nas,folder+" ERR") )
        elif exists(join(wd,plantFolder,folder+".png")):
            df_input.append([folder,'VINE'])
        else:
            df_input.append([folder,'N/A'])
    except Exception as e:
        print(e)
        continue  
df_imgs = pd.DataFrame(df_input,columns=["img_id","Type"]).to_csv(join(wd,'IOP6_Tripod_Image_Label.csv'))

