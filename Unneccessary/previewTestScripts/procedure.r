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
# wv::wavelength_value of each individual image //maybe generate with extract function later
wv <-c(500.0,505.1,510.1,515.2,520.3,525.3,530.4,535.4,540.5,545.6,550.6,555.7,560.8,565.8,570.9,575.9,581.0,586.1,591.1,596.2,601.3,606.3,611.4,616.5,621.5,626.6,631.6,636.7,641.8,646.8,651.9,657.0,662.0,667.1,672.2,677.2,682.3,687.3,692.4,697.5,702.5,707.6,712.7,717.7,722.8,727.8,732.9,738.0,743.0,748.1,753.2,758.2,763.3,768.4,773.4,778.5,783.5,788.6,793.7,798.7,803.8,808.9,813.9,819.0,824.1,829.1,834.2,839.2,844.3,849.4,854.4,859.5,864.6,869.6,874.7,879.7,884.8,889.9,894.9,900.0)
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
   iTH_image_dir <- paste(rootDir, leafIdList[i], sep='/')                   # setTempWorkDir
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
   # Bind all these img vals as rows
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
       #str("gain value: ")
       #str(gainVec[j])
       #str("radiance: ")
       outs <- sapply(leaf_df, function(x){x=x*as.double(gainVec[j])})
       #str(mean(outs))
       output_vector <- c(output_vector,mean(outs))                         # Vector for 80 radiance averages

       
   }
   #  turn output vector into column within DataFrame and append to csv 
   output_vector <- cbind(output_vector)
   output_vector <- unlist(output_vector)
   df <- data.frame("fileID"=img_list,"band"=wv,"rad_avg"= output_vector)
   str("inserting into csv")
   write.table(df, file = "C:/Users/Ben's PC/Documents/research/hyperspectral/testoutput.csv", row.names = FALSE,sep = ',',col.names = colnames(df) ,append = TRUE)
   str("finished Write\n")
}