from genericpath import isfile
from os.path import isfile,isdir, join
from spectral import *
import spectral.io.envi as envi
import numpy as np
import cv2

class HSI_Model:
    """ An object designed to house: Hypercube, wavelengths used, RGB image, logical mask """
    imageName = None
    hcube = None
    wv = None
    rgb = None
    mask = None

    def __init__(self, path_hcube, imgName, path_mask = None) -> None:
        """ Takes absolute path to HDR file, name of this HSI, optional path to associated multi-class mask """
        print("loading hypercube...")
        envi_obj = envi.open(path_hcube)
        envi_obj = envi_obj.load()
        r = envi_obj[:,:,73] # red
        g = envi_obj[:,:,14] # green
        b = envi_obj[:,:,6]
        # r = envi_obj[:,:,14]
        # g = envi_obj[:,:,30]
        # b = envi_obj[:,:,7]

        # Assign properties:
        self.imageName = imgName
        self.wv = envi_obj.bands.centers
        self.hcube = np.array(envi_obj)
        self.rgb = cv2.merge([b,g,r])
        if path_mask != None:
            self.load_mask(path_mask)
        print("HSI load complete...")

    def load_mask(self,path_mask):
        """ Called on initialization, if a path to multi-class mask is provided to constructor """
        if isfile(path_mask):
            mask_multiclass = cv2.imread(path_mask)
            mask_multiclass = cv2.cvtColor(mask_multiclass, cv2.COLOR_BGR2RGB)
            self.mask = (mask_multiclass[:,:,2] == mask_multiclass[:,:,1]).astype(np.int8) * 255

    def save_rgb(self,path_save_dir):
        """ Used to save the composite rgb image of HSI """
        cv2.imwrite(f"{join(path_save_dir,self.imageName)}.jpg",self.rgb/150)

    def save_mask(self,path_save_dir):
        cv2.imwrite(f"{join(path_save_dir,self.imageName)}.png",self.mask)
