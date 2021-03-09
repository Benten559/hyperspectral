require("raster")
library(base)
#take imagery from the two folders with different exposure

#for ID 984
img_list<- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200919_094034_ID984/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000',pattern = ".png", full.names = TRUE)[1:25]
img_list2<- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200919_094034_ID984/leaf_2020_1000ms_80/leaf_2020_1000ms_80_000000',pattern = ".png", full.names = TRUE)[26:80]
# for ID 813
#img_list <- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_110333_ID813/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000', pattern = ".png", full.names = TRUE)[1:25]
#img_list2 <- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_110333_ID813/leaf_2020_1000ms_80/leaf_2020_1000ms_80_000000', pattern = ".png", full.names = TRUE)[26:80]
# for ID 810
#img_list <- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_104729_ID810/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000', pattern = ".png", full.names = TRUE)[1:25]
#img_list2 <- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_104729_ID810/leaf_2020_1000ms_80/leaf_2020_1000ms_80_000000', pattern = ".png", full.names = TRUE)[26:80]
# for ID 812
#img_list<- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_111217_ID812/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000',pattern = ".png", full.names = TRUE)[1:25]
#img_list<- list.files('G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_111217_ID812/leaf_2020_1000ms_80/leaf_2020_1000ms_80_000000',pattern = ".png", full.names = TRUE)[1:25]

#extract the reflectance values.
#TO DO: these are absolute values and should be replaced by calibrated ones
img_list <- c(img_list, img_list2)
#cropping mask
crop_percent <- 0.2
crop_mask <- extent(crop_percent * 100, 128 * (1 - crop_percent),
                    crop_percent * 100, 128 * (1 - crop_percent))

img_values <- sapply(img_list, function(x) {
  img <- raster(x)
  img <- crop(img, crop_mask)
  as.data.frame(img)
})

img_values <- do.call(rbind, img_values)
img_values <- t(img_values)

img_df <- as.data.frame(img_values)
k_img <- kmeans(img_df, 2)
#k_img

#Inspecting clusters:
#k_img$size
#clusters <- as.factor(k_img$cluster)
#str(clusters)
#img_sub$size

#for ID 984
img <-raster("G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200919_094034_ID984/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000/500.0_leaf_2020_200ms_80wl_200919_094034_378.png")


#for ID 812
#img <-raster("G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_111217_ID812/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000/500.0_leaf_2020_200ms_80wl_200828_111217_145.png")
#for ID 810
#img <-raster("G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_104729_ID810/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000/646.8_leaf_2020_200ms_80wl_200828_104803_261.png")
#for ID 813
#img <- raster("G:/Shared drives/Leaf_cabinet_data/leaf_2020_cabinet_200828_110333_ID813/leaf_2020_200ms_80wl/leaf_2020_200ms_80wl_000000/540.5_leaf_2020_200ms_80wl_200828_110428_859.png")

img <- crop(img, crop_mask)
img_df$x <- coordinates(img)[,1]
img_df$y <- coordinates(img)[,2]
img_df$z <- k_img$cluster

# -- Consider a test box to classify the leaf
# our image is of dimension 82x82 flattened
# linearIndex = width*x+y  
# Note: Pixel values still seem offset, instead create mini DF if creates problem
# the list of flattened testing points
bP <- c(3403,3162,3654,3152,3644)
#In order of C, TL, TR, BL, BR
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
  str(count1)
  if(count1 >= 3)return(1)
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
img_sub <- img_df[img_df$z == leaf,]
img_sub <- kmeans(img_sub[1:82], 2)#changed originally from 1:82
img_df[img_df$z == 1, "z"] <- 3
img_df[img_df$z == 2, "z"] <- NA
img_df[is.na(img_df$z), "z"] <- img_sub$cluster

img_plot <- rasterFromXYZ(img_df[81:83])
plot(img_plot)