#!/bin/bash

OUTPUT_FOLDER=$1
L=$2

TEST_FOLDER=$3
GROUND_TRUTH_FILE_TEST=$4

CTW_FOLDER=$5

ALIGNED_PCA_FEATURES_CLASS_TRAIN=$OUTPUT_FOLDER/aligned_pca_features_train_perclass

PCA_FEATURES_TEST_FOLDER=$OUTPUT_FOLDER/pca_googleNetRep_test
TEST_CLASS_FOLDER=$OUTPUT_FOLDER/test_perclass
PCA_FEATURES_TEST_CLASS_FOLDER=$OUTPUT_FOLDER/pca_features_test_perclass

ALIGNMENT_INDEXES_TEST=$OUTPUT_FOLDER/alignment_indexes_test
ALIGNED_TEST_FOLDER=$OUTPUT_FOLDER/aligned_frames_test


#--- Moving features by class -----------------------------------------------------------

echo "Moving train features by class..."
mkdir -p $PCA_FEATURES_TEST_CLASS_FOLDER
src/script_bash/move_frames_features.sh $PCA_FEATURES_TEST_FOLDER $GROUND_TRUTH_FILE_TEST $PCA_FEATURES_TEST_CLASS_FOLDER
chmod -R 777 $PCA_FEATURES_TEST_CLASS_FOLDER

#--- Moving frames by class -------------------------------------------------------------

# Moving by class train
echo "Moving train frames by class..."
mkdir -p $TEST_CLASS_FOLDER
src/script_bash/move_video_frames.sh $TEST_FOLDER $GROUND_TRUTH_FILE_TEST $TEST_CLASS_FOLDER
chmod -R 777 $TEST_CLASS_FOLDER

#--- Alignement of each test sample with its own class
echo "Aligning test features by class..."
mkdir -p $ALIGNMENT_INDEXES_TEST
src/script_bash/run_align_deep_pca_gctw_test_correct_class.sh $ALIGNED_PCA_FEATURES_CLASS_TRAIN $PCA_FEATURES_TEST_CLASS_FOLDER $ALIGNMENT_INDEXES_TEST $PCA_FEATURES_TEST_FOLDER $L $CTW_FOLDER
chmod -R 777 $ALIGNMENT_INDEXES_TEST


#--- Align videos from GCTW indexes--------------------------------------------------------
echo "Extracting aligned test frames..."
mkdir -p $ALIGNED_TEST_FOLDER
src/script_bash/frames_from_indexes_sample.sh $TEST_FOLDER $ALIGNMENT_INDEXES_TEST $ALIGNED_TEST_FOLDER
chmod -R 777 $ALIGNED_TEST_FOLDER

