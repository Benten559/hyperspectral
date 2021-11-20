from PIL import Image
from os import listdir 
from os.path import join

## This script saves a bigger thumbnail of all images taken into a local file path.
## The local file path should also have 3 folders within: [Errors, Standard, Plant]
## Don't forget to create thsoe folders for the next script!

#Change the myPath and localSavePath
mypath = 'V:\\Data\\St_Supery\\IOP6_October2021\\tripod' # The location of the images.
exposurePath = 'canopy_lb_2020_10ms\\canopy_lb_2020_10ms_000000'

localSavePath ='C:\\Users\\15593\\Documents\\repos\\hyperspectral\\DroneImageLabeling\\Standard Identification\\ImageCopy_IOP6'
resize_ratio = 4
# This is a list of Image Folders
imageFolder = listdir(mypath)
for folder in imageFolder:
    try:
        imgSubPath = join(mypath,folder,exposurePath)
        img = [img for img in listdir(imgSubPath) if '756.1_' in img][0]
    # if image of this vine exists with this wavelength store it in a local directory for seperation of standard
        if img: 
            newImage = Image.open(join(imgSubPath,img))
            newImageHeight = int( newImage.size[0] / (1/resize_ratio) )
            newImageWidth = int( newImage.size[1] / (1/resize_ratio) )
            newImage = newImage.resize((newImageHeight,newImageWidth),Image.ANTIALIAS)
            newImage.save(join(localSavePath,folder+".png"))
    except Exception as e:
        print("on: "+folder)
        print(e)
        continue
