#!/bin/bash

OUTPUT_FOLDER=$1
FEATURES_TRAIN_FOLDER=$OUTPUT_FOLDER/googleNetRep_train
FEATURES_TEST_FOLDER=$OUTPUT_FOLDER/googleNetRep_test

PCA_FEATURES_TRAIN_FOLDER=$OUTPUT_FOLDER/pca_googleNetRep_train
PCA_FEATURES_TEST_FOLDER=$OUTPUT_FOLDER/pca_googleNetRep_test

PCA_NUMBER=$2
SMALL_PCA_SET=$OUTPUT_FOLDER/pca_small_set
PCA_MODEL=$OUTPUT_FOLDER/pca_googleNet_train.pkl

#--- Get PCA features -------------------------------------------------------------------

#create random subset
echo "create small subset from training" 
mkdir -p $SMALL_PCA_SET
cp -r $(ls -d -1 $PWD/$FEATURES_TRAIN_FOLDER/** | shuf -n 2000) $SMALL_PCA_SET

echo "Computing PCA on a small set of the train set..."
mkdir -p $PCA_FEATURES_TRAIN_FOLDER
touch $PCA_MODEL
chmod 777 $PCA_MODEL
source /data/sparks/share/asl/asl/bin/activate
python src/python/apply_pca.py $SMALL_PCA_SET $SMALL_PCA_SET $PCA_NUMBER $PCA_MODEL
rm -r $SMALL_PCA_SET

echo "Applying PCA on train..."
mkdir -p $PCA_FEATURES_TRAIN_FOLDER
python src/python/apply_pca_model.py $FEATURES_TRAIN_FOLDER $PCA_FEATURES_TRAIN_FOLDER $PCA_MODEL
chmod -R 777 $PCA_FEATURES_TRAIN_FOLDER

echo "Applying PCA on test..."
mkdir -p $PCA_FEATURES_TEST_FOLDER
python src/python/apply_pca_model.py $FEATURES_TEST_FOLDER $PCA_FEATURES_TEST_FOLDER $PCA_MODEL
chmod -R 777 $PCA_FEATURES_TEST_FOLDER
