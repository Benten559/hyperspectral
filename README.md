## Note: current status: version1 of leaf segmentation
# hyperspectral
Research on plant imagery

This repo will contain the framework for a lab testing kit/package.
Individual modules will be implemented to do different tasks such as segmentation, analysis, render graphical statistics.

## Order of execution:

# Leaf segmentation ver1 complete (5/28/2021) 
* Image preprocessing
* cluster using k-means, k = 2 (background and objects of interest)
* application of mask to focus on leaf - (depends on circular 'standard' segmentation)

# Circular 'Standard' segmentation (5/28/2021)
* utilizes "segCircle.m" - generated using image processing toolbox

# Radiance Calculation - PENDING FULL SEGMENTATION
* Calculates radiance values for every individual image, respective of which wavelength.
* Stores them into two distinct csv files, one for each exposure 1000ms and 200ms, for further schema processing. 
# Dataframe Schema Process
* columns = imgID, wv_1,wv_2,..,wv_N
* row values = gain X digitalPixelValue
 
# Vegetation Index Calculation - PENDING RADIANCE CALCULATION

### Current file structure of raw images:
Contained in "rootDirectory":
 *  List of all image ID's

Contained in "imgID[i]":
 * 1000ms and 200ms exposures folders, ".hdr" file for each

Contained in 1000ms and 200ms exposure folders:
 * 80 images of unique leaf at different wavelegnth values
 * ".hdr" file containing wavelength values and corresponding gain offset values
 * ".dat" file which can be extracted as hypercube of dimensions [1024 x 1024 x 80]

Contained in ".hdr":
 * gain values for 1000ms and 200ms exposures 
 
#### ex. root/imgID/1000ms/imgs[1:80]

=======

Note: 
