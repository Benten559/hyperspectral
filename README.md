# hyperspectral
Research on plants imagery
Work in progress*

This repo will contain the framework for a lab testing kit/package.
Individual modules will be implemented to do different tasks such as segmentation, analysis, render graphical statistics.

Current file structure:

Contained in "rootDirectory":
 *  List of all image ID's

Contained in "imgID[i]":
 * 1000ms and 200ms exposures folders, ".hdr" file for each

Contained in ".hdr":
 * gain values for 1000ms and 200ms exposures 

Contained in 1000ms and 200ms exposure folders:
 * 80 images of unique leaf at different wavelegnth values
