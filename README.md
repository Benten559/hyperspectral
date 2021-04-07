# hyperspectral
Research on plants imagery
Work in progress*

This repo will contain the framework for a lab testing kit/package.
Individual modules will be implemented to do different tasks such as segmentation, analysis, render graphical statistics.
## Current status of analysis code:
### Analysis has been created into a multi-step procedure, some steps utilize a separate script for prep. 
### at present time a photoshop-preprocessed image data set is being used, for now ignore procedure.r and segScript.r
# Radiance Calculation: 
## utilizes : photoShopProcedure.r , folderRename.py
* Traverses through leaf data set file structure, extracts appropiate gain values from ".hdr" file within each image folder.
* execute "folderRename" script to faciliate R script calculation by conforming to uniform directory structure.
** changing "cropped"|"c" to "Cropped"
* Calculates radiance values for every individual image, respective of which wavelength.
* Stores them into two distinct csv files, one for each exposure 1000ms and 200ms, for further schema processing. 
# Dataframe Schema Process
## utilizes : reOrg.py
* Using resultant csv files from prior step, capture radiance average values into new format of shape:
 columns = imgID, wv_1,wv_2,..,wv_N
# Vegetation Index Calculation
## IN PROGRESS


### Current file structure of raw images:
Contained in "rootDirectory":
 *  List of all image ID's

Contained in "imgID[i]":
 * 1000ms and 200ms exposures folders, ".hdr" file for each

Contained in ".hdr":
 * gain values for 1000ms and 200ms exposures 

Contained in 1000ms and 200ms exposure folders:
 * 80 images of unique leaf at different wavelegnth values
 * ".hdr" file containing wavelength values and corresponding gain offset values
#### ex. root/imgID/1000ms/imgs[1:80]
 ### File structure of images post processing:
Similar to raw image file structure except for additional folder for segmented leaf and 'standard'
#### ex. root/imgID/1000ms/Cropped/imgs[1:80]
#### ex. root/imgID/1000ms/standard_dir/imgs[1:80]

