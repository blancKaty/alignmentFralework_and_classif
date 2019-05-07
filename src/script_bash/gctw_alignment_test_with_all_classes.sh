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

ALIGNMENT_INDEXES_TEST_ALLCLASSES=$OUTPUT_FOLDER/alignment_indexes_test_allclasses
ALIGNED_TEST_FOLDER_ALLCLASSES=$OUTPUT_FOLDER/aligned_frames_test_allclasses

#--- Alignement of each test sample with its own class
echo "Aligning test features by class..."
mkdir -p $ALIGNMENT_INDEXES_TEST_ALLCLASSES
src/script_bash/run_align_deep_pca_gctw_test_all_classes.sh $ALIGNED_PCA_FEATURES_CLASS_TRAIN $PCA_FEATURES_TEST_FOLDER $ALIGNMENT_INDEXES_TEST_ALLCLASSES $L $CTW_FOLDER
chmod -R 777 $ALIGNMENT_INDEXES_TEST_ALLCLASSES


#--- Align videos from GCTW indexes--------------------------------------------------------
echo "Extracting aligned test frames..."
mkdir -p $ALIGNED_TEST_FOLDER_ALLCLASSES
src/script_bash/frames_from_indexes_sample_all_classes.sh $TEST_FOLDER $ALIGNMENT_INDEXES_TEST_ALLCLASSES $ALIGNED_TEST_FOLDER_ALLCLASSES
chmod -R 777 $ALIGNED_TEST_FOLDER_ALLCLASSES

