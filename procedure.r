require("raster")
library(base)
library(stringr)

#########################################
# Global variables
crop_percent <- 0.2
crop_mask <- extent(crop_percent * 100, 128 * (1 - crop_percent),
                    crop_percent * 100, 128 * (1 - crop_percent))
# gP::the list of coordinate flattened grid-testing points
gP <- c(3403,3162,3654,3152,3644)
#########################################
# Global f(x)'s
# Extract gain vector
getGains <- function(hdrDir) 
{
  hdrArr = list.files(hdrDir, recursive = 'TRUE', pattern = '.hdr') 
  gains <- list()
  for(hdr in hdrArr)
  {
    fullHdrDir <- paste(hdrDir,hdr,sep = '/')
    hdrFile = readLines(con = fullHdrDir)[16]
    hdrFile = str_remove_all(hdrFile,"[datgivluesn={}]")
    hdrFile = strsplit(hdrFile,',')
    hdrFile = mapply(as.double,hdrFile)
    gains = c(gains,hdrFile)
  }
  return(gains) #[1:160]
}

# Decide which cluster belongs to the leaf
assignLeaf <- function(img,gridPoints){
  #Assumes only two cluster labels of 1 and 2
  #Assumes only 5 test points 
  count1 <- 0
  for(gridPoint in gridPoints){
    if(img[gridPoint]==1){
      count1 <- count1+1
    }
  }
  #if points had more occurence in cluster #1
  if(count1 >= 3)return(1)
  # otherwise return the other cluster #2
  else return(2)
}

#########################################
rootDir = "G:/Shared drives/Leaf_cabinet_data"

# Listed files within root, current testing is length [2-22]:
leafIdList = list.files(rootDir)

for( i in 2:length(leafIdList))
{
   iTH_image_dir <- pasterootDir, leafIdList[i], sep='/')                   # setTempWorkDir
   entire_img_list <- list.files(iTH_image_dir, recursive = TRUE, pattern = '.png',full.names=TRUE)        #contains all [1:160] 
   img_list <- list.files(iTH_image_dir, recursive = TRUE, pattern = '.png',full.names=TRUE)[1:80]          # input for clustering
   hdrArr<- list.files(iTH_image_dir, recursive = 'TRUE', pattern = '.hdr')  # hdr for 1000 & 200 respectively
   gainVec <- getGains(iTH_image_dir)                                        # currently [1:160]
   # CLUSTERING PRE-PROCESS                                              # Perform clustering then segmentation
   #Takes list of images and individually turn them into cropped bitmaps 
   img_values <- sapply(img_list, function(x) {
     img <- raster(x)
     img <- crop(img, crop_mask)
     as.data.frame(img)
   })
   # what?
   img_values <- do.call(rbind, img_values)
   img_values <- t(img_values)
   # - Produce the clustering object by applying Kmeans algorithm.
   img_df <- as.data.frame(img_values)
   
   k_img <- kmeans(img_df, 2)
   leaf <- assignLeaf(k_img$cluster,gP)
   output_vector <- list()
   for(j in 1:length(img_list))
   {
       img <- raster(img_list[j])                                            # Grab individual band Img after clustering
       leaf_df <- img[k_img$cluster == leaf]                                 # Identify leaf within image
       str("mean radiance for image: ")
       str(img_list[j])
       output_vector <- c(output_vector, mean(sapply(leaf_df, function(x){x=x*gains[j]}))) 
       str(output_vector)
    }
#   
}