#!/bin/bash

OUTPUT_FOLDER=$1
L=$2

TRAIN_FOLDER=$3
GROUND_TRUTH_FILE_TRAIN=$4

CTW_FOLDER=$5

PCA_FEATURES_TRAIN_FOLDER=$OUTPUT_FOLDER/pca_googleNetRep_train
PCA_MODEL=$OUTPUT_FOLDER/pca_googleNet_train.pkl

TRAIN_CLASS_FOLDER=$OUTPUT_FOLDER/train_perclass
PCA_FEATURES_TRAIN_CLASS_FOLDER=$OUTPUT_FOLDER/pca_features_train_perclass

ALIGNMENT_INDEXES_TRAIN=$OUTPUT_FOLDER/alignment_indexes_train
ALIGNED_TRAIN_FOLDER=$OUTPUT_FOLDER/aligned_frames_train
ALIGNED_PCA_FEATURES_CLASS_TRAIN=$OUTPUT_FOLDER/aligned_pca_features_train_perclass


#--- Moving features by class -----------------------------------------------------------

echo "Moving train features by class..."
mkdir -p $PCA_FEATURES_TRAIN_CLASS_FOLDER
src/script_bash/move_frames_features.sh $PCA_FEATURES_TRAIN_FOLDER $GROUND_TRUTH_FILE_TRAIN $PCA_FEATURES_TRAIN_CLASS_FOLDER
chmod -R 777 $PCA_FEATURES_TRAIN_CLASS_FOLDER

#--- Alignment --------------------------------------------------------------------------

# Aligning train
echo "Aligning train features by class..."
mkdir -p $ALIGNMENT_INDEXES_TRAIN
src/script_bash/align_deep_pca_gctw_interface_train.sh $PCA_FEATURES_TRAIN_CLASS_FOLDER $ALIGNMENT_INDEXES_TRAIN $L $CTW_FOLDER
chmod -R 777 $ALIGNMENT_INDEXES_TRAIN

#--- Moving frames by class -------------------------------------------------------------

# Moving by class train
echo "Moving train frames by class..."
mkdir -p $TRAIN_CLASS_FOLDER
src/script_bash/move_video_frames.sh $TRAIN_FOLDER $GROUND_TRUTH_FILE_TRAIN $TRAIN_CLASS_FOLDER
chmod -R 777 $TRAIN_CLASS_FOLDER


#--- Align videos from GCTW indexes ----------------------------------------------------------

# Extract aligned frames train
echo "Extracting aligned train frames..."
mkdir -p $ALIGNED_TRAIN_FOLDER
src/script_bash/extract_aligned_frames_from_indexes_interface.sh $TRAIN_CLASS_FOLDER $ALIGNMENT_INDEXES_TRAIN $ALIGNED_TRAIN_FOLDER
chmod -R 777 $ALIGNED_TRAIN_FOLDER

#--- Aligned features extraction --------------------------------------------------------

# Extract aligned frames train
echo "Extracting aligned train frames..."
mkdir -p $ALIGNED_PCA_FEATURES_CLASS_TRAIN
src/script_bash/extract_aligned_features_from_indexes_interface.sh $PCA_FEATURES_TRAIN_CLASS_FOLDER $ALIGNMENT_INDEXES_TRAIN $ALIGNED_PCA_FEATURES_CLASS_TRAIN
chmod -R 777 $ALIGNED_PCA_FEATURES_CLASS_TRAIN

