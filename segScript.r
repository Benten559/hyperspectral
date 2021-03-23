require("raster")
library(base)
library(stringr)
#######################
#--Command line arguments:
# Root directory for for testing.
# Meant to be attained as commandline argument [rootDir]:
rootDir = "G:/Shared drives/Leaf_cabinet_data"

# Listed files within root, current testing is length [1-21]:
leafIdList = list.files(rootDir)

# To be ran iterative in production:
testIdImage = leafIdList[2]

# Where to search for '.hdr' file containing gain values
tempWorkingDir = paste(rootDir,testIdImage,sep = '/')

# The location of '.hdr' files within given imageID
# ASSUMES
# [1] for 1000ms exposure
# [2] for 200ms exposure wl
hdrArr = list.files(tempWorkingDir, recursive = 'TRUE', pattern = '.hdr')

#This is the location of the first set of Gains:
# ASSUMES for testing, starting with the 1000ms exposure
fullHdrDir = paste(tempWorkingDir,hdrArr[1],sep = '/')

# This is the rough shape of the gain vector
hdrFile = readLines(con = fullHdrDir)[16]

# Convert the hdrLine from string to object
# First remove all unnecessary chars:
gains = str_remove_all(hdrFile,"[datgivluesn={}]")
# next separate each string
gains = strsplit(gains,',')
# Convert them to double data types
gains = mapply(as.double,gains)

########################

### -- Prep for cluster process -- ###
#take imagery from the two folders with different exposure
# Notes: These img variables..(img_list, and img_list2) contain all exposures and frequencies of the same leaf.
img_list<- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200919_100050_ID980/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000',pattern = ".png", full.names = TRUE)[1:25]
img_list2<- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200919_100050_ID980/leaf_2020_1000ms_80/leaf_2020_1000ms_80_000000',pattern = ".png", full.names = TRUE)[26:80]

#for ID 984
#img_list<- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200919_094034_ID984/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000',pattern = ".png", full.names = TRUE)[1:25]
#img_list2<- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200919_094034_ID984/leaf_2020_1000ms_80/leaf_2020_1000ms_80_000000',pattern = ".png", full.names = TRUE)[26:80]
# for ID 813
#img_list <- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_110333_ID813/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000', pattern = ".png", full.names = TRUE)[1:25]
#img_list2 <- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_110333_ID813/leaf_2020_1000ms_80/leaf_2020_1000ms_80_000000', pattern = ".png", full.names = TRUE)[26:80]
# for ID 810
#img_list <- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_104729_ID810/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000', pattern = ".png", full.names = TRUE)[1:25]
#img_list2 <- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_104729_ID810/leaf_2020_1000ms_80/leaf_2020_1000ms_80_000000', pattern = ".png", full.names = TRUE)[26:80]
# for ID 812
#img_list<- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_111217_ID812/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000',pattern = ".png", full.names = TRUE)[1:25]
#img_list<- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_111217_ID812/leaf_2020_1000ms_80/leaf_2020_1000ms_80_000000',pattern = ".png", full.names = TRUE)[1:25]

## - extract the reflectance values - ##
#TO DO: these are absolute values and should be replaced by calibrated ones

#concatenate the list of exposures to one array.
img_list <- c(img_list, img_list2)
#cropping mask, this gets new view/size of current image dimensions
# Notes: Our lab data goes from 128x128 -> 82x82 (from center)
crop_percent <- 0.2
crop_mask <- extent(crop_percent * 100, 128 * (1 - crop_percent),
                    crop_percent * 100, 128 * (1 - crop_percent))

#Takes list of images and individually turn them into cropped bitmaps 
img_values <- sapply(img_list, function(x) {
  img <- raster(x)
  img <- crop(img, crop_mask)
  as.data.frame(img)
})
# -- Find functional definition for this part --
img_values <- do.call(rbind, img_values)
img_values <- t(img_values)
# - Produce the clustering object from applying Kmeans algorithm.
img_df <- as.data.frame(img_values)
k_img <- kmeans(img_df, 2)
#k_img

#Inspecting clusters:
#k_img$size
#clusters <- as.factor(k_img$cluster)
#str(clusters)
#img_sub$size

## -- Prep for semantic segmentation -- ##
# Notes: this portion selects a single image, converts it to a bitmap then applys previous cluster info to create leaf class within data frame.
img <-raster("G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200919_100050_ID980/leaf_2020_1000ms_80/leaf_2020_1000ms_80_000000/641.8_leaf_2020_1000ms_80_200919_100123_258.png")
#for ID 984
#img <-raster("G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200919_094034_ID984/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000/500.0_leaf_2020_200ms_80wl_200919_094034_378.png")
#for ID 812
#img <-raster("G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_111217_ID812/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000/500.0_leaf_2020_200ms_80wl_200828_111217_145.png")
#for ID 810
#img <-raster("G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_104729_ID810/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000/646.8_leaf_2020_200ms_80wl_200828_104803_261.png")
#for ID 813
#img <- raster("G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_110333_ID813/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000/540.5_leaf_2020_200ms_80wl_200828_110428_859.png")

#Adds additional columns to image DF from x, y coord values, the z designates the clustering group ie..(1 or 2)
img <- crop(img, crop_mask)
img_df$x <- coordinates(img)[,1]
img_df$y <- coordinates(img)[,2]
img_df$z <- k_img$cluster

# -- Consider a test box to classify the leaf
# our image is of dimension 82x82 flattened
# linearIndex = width*x+y  
# Note: Pixel values still seem slightly offset, instead create mini DF if creates classification problem
# bP <- the list of flattened testing points
bP <- c(3403,3162,3654,3152,3644)
#For the points C, TL, TR, BL, BR
k_img$cluster[3403]
k_img$cluster[3162]
k_img$cluster[3654]
k_img$cluster[3152]
k_img$cluster[3644]

# This functions contains the logic to designate the leaf cluster
assignLeaf <- function(img,boxPoints){
  #Assumes only two cluster labels of 1 and 2
  #Assumes only 5 test points 
  count1 <- 0
  for(boxPoint in boxPoints){
    if(img[boxPoint]==1){
      count1 <- count1+1
    }
  }
  #str(count1)
  #if points had more occurence in cluster #1
  if(count1 >= 3)return(1)
  # otherwise return the other cluster #2
  else return(2)
}
leaf <- assignLeaf(img_df$z,bP)

img_plot <- rasterFromXYZ(img_df[81:83])
plot(img_plot)
# These points represent the offset adjusted bounding points
# Goal: Check each point/cluster value pair to classify it.
points(61,61) #center
points(58,66) #Top Left
points(64,66) #Top Right
points(58,56) #Bottom Left
points(64,56) #Bottom Right
#reclassify leaf only
#img_sub <- img_df[img_df$z == leaf,]
#img_sub <- kmeans(img_sub[1:82], 2)#changed originally from 1:82
#img_df[img_df$z == 1, "z"] <- 3
#img_df[img_df$z == 2, "z"] <- NA
#this line won't throws error when Leaf is in cluster 1
#img_df[is.na(img_df$z), "z"] <- img_sub$cluster

#img_plot <- rasterFromXYZ(img_df[81:83])
#plot(img_plot)