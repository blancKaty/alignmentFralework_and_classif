#!/usr/bin/env bash

INPUT_FOLDER=$1
OUTPUT_FOLDER=$2
L=$3

CLASS_NUMBER=$(ls $INPUT_FOLDER | wc -l);

MATLAB=/usr/local/bin/matlab2017a
CTW_FOLDER=$4
MATLAB_FOLDER=./src/matlab/

for class in $( seq -w $CLASS_NUMBER);
do
    echo Aligning class $class
    echo Aligning class $class

    CMD="\
        addpath(genpath(['$CTW_FOLDER'])); \
	addpath(genpath(['$MATLAB_FOLDER'])); \
        align_deep_pca_gctw_class_train('${INPUT_FOLDER}/${class}', '$class', '$OUTPUT_FOLDER', '$CTW_FOLDER', '$L' ) ; \
        exit;
    "

    $MATLAB -r "$CMD"

done
