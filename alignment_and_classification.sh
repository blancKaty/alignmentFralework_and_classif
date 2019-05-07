#! /bin/bash

##VARIABLE DEFINITION

TRAIN_FOLDER=database/train
TEST_FOLDER=database/test

GROUND_TRUTH_TRAIN=database/train_list.txt
GROUND_TRUTH_TEST=database/test_list.txt

SRC_FOLDER=src
PYTHON_FOLDER=$SRC_FOLDER/python
BASH_FOLDER=$SRC_FOLDER/script_bash

OUTPUT_FOLDER=./output
PROTOTXT_FOLDER=prototxt_files

#CAFFE FOLDER TO DESCRIBE THE FRAMES USING 
CAFFE_FOLDER=/data/sparks/share/R-C3D/caffe3d
CTW_FOLDER=/home/kblanc/gctw_clean/ctw
WEIGHTS=$SRC_FOLDER/activitynet_iter_135000.caffemodel

#HYPERPARAMETERS
PCA_NUMBER=50

ALIGNED_VIDEO_LENGTH=35

FPS_REDUCTION=4
#one frame on $FPS_REDUCTION

NUM_GPUS=1

######################TRAIN SET ALIGNMENT#######################################

####googleNet representation of each frame of each video
$BASH_FOLDER/googlenet_description.sh $TRAIN_FOLDER $TEST_FOLDER $OUTPUT_FOLDER $CAFFE_FOLDER

####compute PCA to reduce the features and the computation cost
$BASH_FOLDER/pca_from_googleNet.sh $OUTPUT_FOLDER $PCA_NUMBER

####for each class in the training set, compute the alignment indexes by GCW
$BASH_FOLDER/gctw_alignment_train.sh $OUTPUT_FOLDER $ALIGNED_VIDEO_LENGTH $TRAIN_FOLDER $GROUND_TRUTH_TRAIN $CTW_FOLDER

######################TEST SET ALIGNMENT#######################################

####each test sample is aligned with its own class
$BASH_FOLDER/gctw_alignment_test.sh $OUTPUT_FOLDER $ALIGNED_VIDEO_LENGTH $TEST_FOLDER $GROUND_TRUTH_TEST $CTW_FOLDER

#####each test sample is aligned with each class
$BASH_FOLDER/gctw_alignment_test_with_all_classes.sh $OUTPUT_FOLDER $ALIGNED_VIDEO_LENGTH $TEST_FOLDER $GROUND_TRUTH_TEST $CTW_FOLDER

######################NORMALIZE SET#######################################

####normalized all original video lengths to train C3D as the baseline
$BASH_FOLDER/normalize_video.sh $TRAIN_FOLDER $TEST_FOLDER $OUTPUT_FOLDER $ALIGNED_VIDEO_LENGTH $FPS_REDUCTION

#####################C3D PREPROCESSING###################################

####create the right ground truth files for C3D
GROUND_TRUTH_TRAIN_C3D=$OUTPUT_FOLDER/train_list_c3d.txt
GROUND_TRUTH_TEST_C3D=$OUTPUT_FOLDER/test_list_c3d.txt

$BASH_FOLDER/change_ground_truth_for_c3d.sh $GROUND_TRUTH_TRAIN $GROUND_TRUTH_TRAIN_C3D
$BASH_FOLDER/change_ground_truth_for_c3d.sh $GROUND_TRUTH_TEST $GROUND_TRUTH_TEST_C3D

####create the prototxt files to train C3D
$BASH_FOLDER/createPrototxt_train.sh $OUTPUT_FOLDER $ALIGNED_VIDEO_LENGTH $PROTOTXT_FOLDER

####create the prototxt files to test C3D
$BASH_FOLDER/createPrototxt_test.sh $OUTPUT_FOLDER $PROTOTXT_FOLDER


################COMPUTE THE PROTOCOLS AND COMPARE########################

mkdir -p $OUTPUT_FOLDER/snapshots
chmod 777 $OUTPUT_FOLDER/snapshots

####TRAINING

#training on normalized train
source /data/sparks/share/asl/asl/bin/activate

SOLVER_FILE_NORM=$PROTOTXT_FOLDER/solver_normalized.prototxt
$BASH_FOLDER/c3d_finetuning.sh $SOLVER_FILE_NORM $NUM_GPUS $WEIGHTS $CAFFE_FOLDER

#training on aligned train
SOLVER_FILE_ALIG=$PROTOTXT_FOLDER/solver_aligned.prototxt
$BASH_FOLDER/c3d_finetuning.sh $SOLVER_FILE_ALIG $NUM_GPUS $WEIGHTS $CAFFE_FOLDER


####Baseline and Testing Protocols
mkdir -p $OUTPUT_FOLDER/classification_scores/

NUM_SAMPLE_TEST=$(wc -l $GROUND_TRUTH_TEST | cut -d ' ' -f 1)

#Baseline: train on normalized set and test on normalized test 
MODEL_CONFIG_FILE=$PROTOTXT_FOLDER/test_config_onTestNormalized.prototxt
WEIGHTS=$( ls -tr $OUTPUT_FOLDER/snapshots/snapshot_normalized_iter*.caffemodel | tail -n 1 )
OUTPUT_BASELINE_SCORE=$OUTPUT_FOLDER/classification_scores/baseline.out
$BASH_FOLDER/testing_asl_gpus.sh $MODEL_CONFIG_FILE $WEIGHTS $NUM_GPUS $NUM_SAMPLE_TEST > $OUTPUT_BASELINE_SCORE 2>&1 

#Protocol 1 : train on aligned set and test on normalized test
MODEL_CONFIG_FILE=$PROTOTXT_FOLDER/test_config_onTestNormalized.prototxt
WEIGHTS=$( ls -tr $OUTPUT_FOLDER/snapshots/snapshot_aligned_iter*.caffemodel | tail -n 1 )
OUTPUT_PROTOCOL1_SCORE=$OUTPUT_FOLDER/classification_scores/protocol1.out
$BASH_FOLDER/testing_asl_gpus.sh $MODEL_CONFIG_FILE $WEIGHTS $NUM_GPUS $NUM_SAMPLE_TEST > $OUTPUT_PROTOCOL1_SCORE 2>&1

#Protocol 2 : train on aligned train and test on aligned test 
MODEL_CONFIG_FILE=$PROTOTXT_FOLDER/test_config_onTestAligned.prototxt
WEIGHTS=$( ls -tr $OUTPUT_FOLDER/snapshots/snapshot_aligned_iter*.caffemodel | tail -n 1 )
OUTPUT_PROTOCOL2_SCORE=$OUTPUT_FOLDER/classification_scores/protocol2.out
$BASH_FOLDER/testing_asl_gpus.sh $MODEL_CONFIG_FILE $WEIGHTS $NUM_GPUS $NUM_SAMPLE_TEST > $OUTPUT_PROTOCOL2_SCORE 2>&1

#Protocol 3 : train on aligned train and test on all samples aligned with all classes
CLASS_NUMBER=$(cat $GROUND_TRUTH_TRAIN | cut -d ' ' -f 2 | sort -u | wc -l)
for class in $(seq -w $CLASS_NUMBER) 
do
    MODEL_CONFIG_FILE=$PROTOTXT_FOLDER/test_config_${class}.prototxt
    OUTPUT_PROTOCOL3_SCORE=$OUTPUT_FOLDER/classification_scores/protocol3_${class}.out
    $BASH_FOLDER/testing_asl_gpus.sh $MODEL_CONFIG_FILE $WEIGHTS $NUM_GPUS $NUM_SAMPLE_TEST > $OUTPUT_PROTOCOL3_SCORE 2>&1
done

OUTPUT_PROTOCOL3_SCORE=$OUTPUT_FOLDER/classification_scores/protocol3.out
python $PYTHON_FOLDER/computeScoreProtocol3.py $OUTPUT_FOLDER/classification_scores/ $GROUND_TRUTH_TEST_C3D > $OUTPUT_PROTOCOL3_SCORE 2>&1 







