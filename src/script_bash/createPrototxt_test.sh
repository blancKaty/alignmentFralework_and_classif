#! /bin/bash

OUTPUT_FOLDER=$1
PROTOTXT_FOLDER=$2
TEST_CONFIG_NORM=$PROTOTXT_FOLDER/test_config_onTestNormalized.prototxt

TEST_CONFIG_ALIG=$PROTOTXT_FOLDER/test_config_onTestAligned.prototxt


#####FOR THE TESTING ON THE NORMALIZED SAMPLES

SAMPLE_NUMBER=$(wc -l $OUTPUT_FOLDER/train_list_c3d.txt | cut -d ' ' -f 1 )

CLASS_NUMBER=$(cat $OUTPUT_FOLDER/train_list_c3d.txt | cut -d ' ' -f 3 | sort -u | wc -l)

#change the sample source
sed -i "19s@.*@    source: \"$OUTPUT_FOLDER/test_list_c3d.txt\"@" $TEST_CONFIG_NORM
sed -i "20s@.*@    root_folder : \"$OUTPUT_FOLDER/normalized_test/\"@" $TEST_CONFIG_NORM
sed -i "512s@.*@    num_output : $CLASS_NUMBER@" $TEST_CONFIG_NORM

#####FOR THE TESTING ON THE ALIGNED SAMPLES

#change the sample source
sed -i "19s@.*@    source: \"$OUTPUT_FOLDER/test_list_c3d.txt\"@" $TEST_CONFIG_ALIG
sed -i "20s@.*@    root_folder: \"$OUTPUT_FOLDER/aligned_frames_test/\"@" $TEST_CONFIG_ALIG
sed -i "512s@.*@    num_output : $CLASS_NUMBER@" $TEST_CONFIG_ALIG

#####FOR THE TESTING ON THE SAMPLES ALIGNED WITH ALL CLASSES
TEST_CONFIG_ALL=$PROTOTXT_FOLDER/test_config_withallclasses.prototxt

for class in $(seq -w $CLASS_NUMBER)
do
    sed "1s@.*@name :\"test_config_$class.prototxt\"@" $TEST_CONFIG_ALL > $PROTOTXT_FOLDER/test_config_$class.prototxt
    sed -i "19s@.*@    source: \"$OUTPUT_FOLDER/test_list_c3d.txt\"@" $PROTOTXT_FOLDER/test_config_$class.prototxt
    sed -i "20s@.*@    root_folder: \"$OUTPUT_FOLDER/aligned_frames_test_allclasses/$class/\"@" $PROTOTXT_FOLDER/test_config_$class.prototxt
    sed -i "512s@.*@    num_output : $CLASS_NUMBER@" $PROTOTXT_FOLDER/test_config_$class.prototxt
done 

