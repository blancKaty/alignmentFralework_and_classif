#!/bin/bash

TRAIN_FOLDER=$1 
TEST_FOLDER=$2 
OUTPUT_FOLDER=$3
ORIGINAL_FOLDER=$4
L=$5
CTW_FOLDER=$6

CLASS_NUMBER=$(ls $TRAIN_FOLDER | wc -l );

for CLASS_FOLDER in $(seq -w $CLASS_NUMBER)
do
    echo "Queueing alignment for class " $CLASS_FOLDER
    echo
    mkdir -p $OUTPUT_FOLDER/$CLASS_FOLDER
    for TEST_SAMPLE in `ls -d $TEST_FOLDER/${CLASS_FOLDER}/*`
    do
	TEST_NAME=$(echo $TEST_SAMPLE | rev | cut -d '/' -f1 | rev );
	if [ ! -f  $OUTPUT_FOLDER/$CLASS_FOLDER/${TEST_NAME} ] 
	then
	    echo "Sample $TEST_NAME will be aligned.."
            
	    # align every class in parallel
            src/script_bash/align_deep_pca_gctw_interface_test.sh $TRAIN_FOLDER/$CLASS_FOLDER $CLASS_FOLDER ${TEST_SAMPLE} $OUTPUT_FOLDER/$CLASS_FOLDER $L $CTW_FOLDER
	else 
	    echo "Skip : "${TEST_NAME} 
	fi
    done
done
