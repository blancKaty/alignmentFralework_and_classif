APPLICATION OF GCTW TEMPORAL ALIGNMENT IN A VIDEO CLASSIFICATION TASK 

The whole framework from frame description to C3D classification protocols is contained in the source code alignment_and_classification.sh. This code must be run in its current folder.

Before running this file, change the variables according your environnement. 
The database folder must contains two text files, train_list.txt and test_list.txt, containing the labels, and two folders, train and test, containing the videos split by frame. 
See the folder database for an example from the IsoGD database samples.

You also need to download others librairies to use this code: 

- The R3D caffe folder can be find here : https://github.com/VisionLearningGroup/R-C3D/tree/master/caffe3d
This code is needed to represent the frame using the googleNet description and to train and test C3D.
Specify the location in the variable CAFFE_FOLDER. 

- The GCTW alignment program can be found here : https://github.com/LaikinasAkauntas/ctw
This code is needed to compute the alignment path (indexes). 
Specify the location in the variable CTW_FOLDER


The Framework: 

######ALIGNMENT PROCESS FOR THE TRAINING SET

- Describe each video frame by a googleNet representation or an other deep feature. 

- Compute a PCA to reduce the features and thus the computational cost in the GCTW alignment step

- For each class of the training set, align the videos using the PCA features as input of GCTW

Then the aligned videos will be in the aligned_frames_train folder. 

######ALIGNMENT FOR THE TESTING SET

- Aligning each test sample with its own class for the protocol 2

- Aligning each test sample with each class for protocol 3

######NORMALIZE THE SAMPLE FOR THE BASELINE

To compare the learning of C3D on each configuration, we compute a normalized train and test set. 
The test set is aligned or not according the choosen protocol. 

- Create a normalized version of the dataset where all videos have the same length to feed C3D. 

######CLASSIFICATION AND PROTOCOLS

- Compute the ground truth files for C3D

- Baseline : C3D is training on normalized data and it is tested on normalized data (same length but different execution speed). 

-->>>>

- Protocol 1 : C3D is trained on aligned data and it is tested on normalized data

->>>>>

- Protocol 2 : C3D is trained on aligned data and tested on aligned data 

->>>>

- Protocol 3 : C3D is trained on aligned data. Each test sample is aligned with each class. A special classification score is computed, thus C3D is tested on each aligned test sample. 
Finaly, a special classification score is computed using the C3D scores on the aligned samples for each test sample. 

---->>>>>>>

All the classification scores are stored in output/classification_scores/

References: 

- Jun Wan, Yibing Zhao, Shuai Zhou,  Isabelle Guyon, and Sergio Escalera and Stan Z. Li, "ChaLearn Looking at People RGB-D Isolated and Continuous Datasets for Gesture Recognition", CVPR workshop, 2016.

- Huijuan Xu and Abir Das and Kate Saenko, R-C3D: Region Convolutional 3D Network for Temporal Activity Detection, Proceedings of the International Conference on Computer Vision (ICCV), 2017.



