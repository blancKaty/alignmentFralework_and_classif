#! /bin/bash

OUTPUT_FOLDER=$1
L=$2


PROTOTXT_FOLDER=$3
SOLVER_NORM=$PROTOTXT_FOLDER/solver_normalized.prototxt
TRAIN_CONFIG_NORM=$PROTOTXT_FOLDER/train_config_normalized.prototxt

SOLVER_ALIG=$PROTOTXT_FOLDER/solver_aligned.prototxt
TRAIN_CONFIG_ALIG=$PROTOTXT_FOLDER/train_config_aligned.prototxt

SAMPLE_NUMBER=$(wc -l $OUTPUT_FOLDER/train_list_c3d.txt | cut -d ' ' -f 1 )
CLASS_NUMBER=$(ls $OUTPUT_FOLDER/aligned_frames_test_allclasses/ | wc -l )

#####FOR THE TRAINING ON THE NORMALIZED SAMPLES

#change the number of samples in the solver file
sed -i "7s@.*@test_interval: $SAMPLE_NUMBER@" $SOLVER_NORM
sed -i "20s@.*@snapshot_prefix: \"$OUTPUT_FOLDER/snapshots/snapshot_normalized\"@" $SOLVER_NORM

#change the ground truth source
#training set
sed -i "19s@.*@    source: \"$OUTPUT_FOLDER/train_list_c3d.txt\"@" $TRAIN_CONFIG_NORM
sed -i "20s@.*@    root_folder: \"$OUTPUT_FOLDER/normalized_train/\"@" $TRAIN_CONFIG_NORM
sed -i "21s@.*@    new_length: $L@" $TRAIN_CONFIG_NORM

#validation set
sed -i "45s@.*@    source: \"$OUTPUT_FOLDER/train_list_c3d.txt\"@" $TRAIN_CONFIG_NORM
sed -i "46s@.*@    root_folder: \"$OUTPUT_FOLDER/normalized_train/\"@" $TRAIN_CONFIG_NORM
sed -i "47s@.*@    new_length: $L@" $TRAIN_CONFIG_NORM

#testing set
sed -i "71s@.*@    source: \"$OUTPUT_FOLDER/test_list_c3d.txt\"@" $TRAIN_CONFIG_NORM
sed -i "72s@.*@    root_folder: \"$OUTPUT_FOLDER/normalized_test/\"@" $TRAIN_CONFIG_NORM
sed -i "73s@.*@    new_length: $L@" $TRAIN_CONFIG_NORM

#Change the last layer to be the size of the class number
sed -i "564s@.*@    num_output:$CLASS_NUMBER@" $TRAIN_CONFIG_NORM

#####FOR THE TRAINING ON THE ALIGNED SAMPLES

#change the number of samples in the solver file
SAMPLE_NUMBER=$(wc -l $OUTPUT_FOLDER/train_list_c3d.txt | cut -d ' ' -f 1 )
sed -i "7s@.*@test_interval: $SAMPLE_NUMBER@" $SOLVER_ALIG
sed -i "20s@.*@snapshot_prefix: \"$OUTPUT_FOLDER/snapshots/snapshot_aligned\"@" $SOLVER_ALIG

#change the ground truth source
#training set
sed -i "19s@.*@    source: \"$OUTPUT_FOLDER/train_list_c3d.txt\"@" $TRAIN_CONFIG_ALIG
sed -i "20s@.*@    root_folder: \"$OUTPUT_FOLDER/aligned_frames_train/\"@" $TRAIN_CONFIG_ALIG
sed -i "21s@.*@    new_length: $L@" $TRAIN_CONFIG_ALIG

#validation set
sed -i "45s@.*@    source: \"$OUTPUT_FOLDER/train_list_c3d.txt\"@" $TRAIN_CONFIG_ALIG
sed -i "46s@.*@    root_folder: \"$OUTPUT_FOLDER/aligned_frames_train/\"@" $TRAIN_CONFIG_ALIG
sed -i "47s@.*@    new_length: $L@" $TRAIN_CONFIG_ALIG

#testing set
sed -i "71s@.*@    source: \"$OUTPUT_FOLDER/test_list_c3d.txt\"@" $TRAIN_CONFIG_ALIG
sed -i "72s@.*@    root_folder: \"$OUTPUT_FOLDER\/aligned_frames_test/\"@" $TRAIN_CONFIG_ALIG
sed -i "73s@.*@    new_length: $L@" $TRAIN_CONFIG_ALIG

#Change the last layer to be the size of the class number
sed -i "564s@.*@    num_output:$CLASS_NUMBER@" $TRAIN_CONFIG_ALIG

