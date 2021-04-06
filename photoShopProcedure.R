# Post photoshop segmentation

require("raster")
library(base)
library(stringr)
#########################################
# Global variables
# blankSpace, ASSUMES the photoshop cropping placed empty values as 255
#               and that Values within leaf section remain unaltered.
blankSpace <- 255
crop_percent <- 0.2
crop_mask <- extent(crop_percent * 100, 128 * (1 - crop_percent),
                    crop_percent * 100, 128 * (1 - crop_percent))

# Where all the files are stored
rootDir = "F:/Madera_Harvester_2020_10_11_Cropped"
leafIdList = list.files(rootDir)
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
grabCropped <- function(iTH_id_dir)#index1 = 1000ms, index2 = 200ms
{
  #both 1000ms and 200ms img lists
  twoExposures <- list.files(iTH_id_dir)[1:2]
  croppedVector <- list()
  for(i in 1:2)
  {
    ins <-paste(twoExposures[i],"cropped",sep = '/')
    croppedVector <- c(croppedVector,ins)
  }
  return(croppedVector) #still needs to have root file directory at begin
}
#########################################
#Loop through and calculate radiance averages per img
for( i in 1:length(leafIdList))
{
  iTH_image_dir <- paste(rootDir, leafIdList[i], sep='/')                   # setTempWorkDir
  gainVec <- getGains(iTH_image_dir)
  exposures <- grabCropped(iTH_image_dir)
  #for loop for each exposure here:
  iTH_image_dir <- paste(iTH_image_dir,exposures[1],sep = '/') #should contain (root,imgDIr,CroppedDir)
  entire_img_list <- list.files(iTH_image_dir, recursive = TRUE, pattern = '.png',full.names=TRUE)      #contains all cropped imgs for exposure 1000
  
  output_vector <- list()
  for(j in 1:length(entire_img_list))
  {
    img <- raster(entire_img_list[j])                                            # Grab individual band Img after clustering
    img <- img[img != blankSpace]
    #str("gain value: ")
    #str(gainVec[j])
    #str("radiance: ")
    outs <- sapply(img, function(x){x=x*as.double(gainVec[j])})
    #str(mean(outs))
    output_vector <- c(output_vector,mean(outs))                         # Vector for 80 radiance averages
  }
  #  turn output vector into column within DataFrame and append to csv 
  output_vector <- cbind(output_vector)
  output_vector <- unlist(output_vector)
  df <- data.frame("fileID"=entire_img_list,"band"=wv,"rad_avg"= output_vector)
  str("inserting into csv")
  write.table(df, file = "C:/Users/Ben's PC/Documents/research/hyperspectral/1000msRadianceAvg.csv", row.names = FALSE,sep = ',',col.names = FALSE ,append = TRUE)
  str("finished Write\n")
  
}

