#!/usr/bin/env bash

INPUT_FOLDER=$1
CLASS=$2
TEST_SAMPLE=$3
OUTPUT_FOLDER=$4
L=$5

CTW_FOLDER=$6

MATLAB=/usr/local/bin/matlab2017a

CMD="\
    addpath(genpath(['$CTW_FOLDER'])); \
    addpath(genpath(['src/matlab/'])); \
    align_deep_pca_gctw_class_test('${INPUT_FOLDER}', '$CLASS', '$TEST_SAMPLE', '$OUTPUT_FOLDER', '$CTW_FOLDER' , '$L' ); \
    exit;
"

$MATLAB -r "$CMD"


