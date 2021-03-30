# hyperspectral
Research on plants imagery
Work in progress*

This repo will contain the framework for a lab testing kit/package.
Individual modules will be implemented to do different tasks such as segmentation, analysis, render graphical statistics.
## Current status of analysis code:
### Analysis has been created into a procedure by using original code and inserting into necessary loop protocols.
* Traverses through leaf data set file structure, extracts appropiate gain values from ".hdr" file within each image folder.
* Calculates radiance values for every individual image, respective of which wavelength.
* Stores them into csv file for further calculation of vegetation indices

Current file structure:

Contained in "rootDirectory":
 *  List of all image ID's

Contained in "imgID[i]":
 * 1000ms and 200ms exposures folders, ".hdr" file for each

Contained in ".hdr":
 * gain values for 1000ms and 200ms exposures 

Contained in 1000ms and 200ms exposure folders:
 * 80 images of unique leaf at different wavelegnth values
 * ".hdr" file containing wavelength values and corresponding gain offset values
 
