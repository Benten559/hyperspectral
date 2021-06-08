## Note: current status: version1.1 of leaf segmentation
# hyperspectral
Research on plant imagery
This repo will contain the framework for a lab testing kit/package.
Individual modules will be implemented to do different tasks such as segmentation, analysis, render graphical statistics.

Current Status:
5/136 cases failed the segmentation process, labeling procedure needs to be done manually for analysis on these images.

## Order of execution:

# Leaf segmentation ver1.1 complete (5/29/2021) 
* Image preprocessing
* cluster using k-means, k = 2 (background and objects of interest)
* application of mask to focus on leaf - (depends on circular 'standard' segmentation)

# Circular 'Standard' segmentation (5/28/2021)
* utilizes "segCircle.m" - generated using image processing toolbox

# Radiance Calculation - (6/5/2021)
* Calculates radiance values for every individual image, respective of which wavelength.
* Stores them into two distinct csv files, one for each exposure 1000ms and 200ms, for further schema processing. 
# Dataframe Schema Process
* columns = imgID, wv_1,wv_2,..,wv_N
* row values = gain X digitalPixelValue
 
# Vegetation Index Calculation - PENDING 
