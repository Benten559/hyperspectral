import os
basedir = 'F:/Madera_Harvester_2020_10_11_Cropped'
for fn in os.listdir(basedir):
    id_dir = os.path.join(basedir,fn)
    expoArr = os.listdir(id_dir)[0:2]
    for exp in expoArr:
        work_dir = os.path.join(id_dir,exp) #base/id/exposure/
        view = os.listdir(work_dir)         #Contents of work directory: [c|cropped|Cropped imgs, standardImages]
        if not ('Cropped' in view[0]):      #if it doesn't conform to base/id/exposure/Cropped/imgs[0:79]
            print("within: ", work_dir)     #then rename the folder
            print('instead of "Cropped" it was: ',view[0])
            # change:
            print("changed from: ", work_dir + "\\" + view[0], 'to: ', work_dir+"\Cropped")
            os.rename(work_dir + "\\"+view[0],work_dir+"\Cropped")
            
