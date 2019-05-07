#!/bin/bash

source /data/sparks/share/asl/asl/bin/activate

TRAIN_FOLDER=$1
TEST_FOLDER=$2

OUTPUT_FOLDER=$3

NORMALIZED_TRAIN_FOLDER=$OUTPUT_FOLDER/normalized_train
NORMALIZED_TEST_FOLDER=$OUTPUT_FOLDER/normalized_test

FPS_RATE=$5
FINAL_LENGTH=$4

# reduce fps and save for the train set
echo ********** REDUCE FPS *********************
mkdir -p $NORMALIZED_TRAIN_FOLDER
python src/python/reduce_fps_parallel.py $TRAIN_FOLDER $NORMALIZED_TRAIN_FOLDER $FPS_RATE $FINAL_LENGTH

# make videos same length for the train set
echo ********** REPLICATE LAST FRAME ***********
python src/python/replicate_last_frame_parallel.py $NORMALIZED_TRAIN_FOLDER $FINAL_LENGTH
chmod 777 $NORMALIZED_TRAIN_FOLDER

# reduce fps and save for the test set
echo ********** REDUCE FPS *********************
mkdir -p $NORMALIZED_TEST_FOLDER
python src/python/reduce_fps_parallel.py $TEST_FOLDER $NORMALIZED_TEST_FOLDER $FPS_RATE $FINAL_LENGTH

# make videos same length for the train set
python src/python/replicate_last_frame_parallel.py $NORMALIZED_TEST_FOLDER $FINAL_LENGTH
chmod 777 $NORMALIZED_TEST_FOLDER

