TRAIN_FOLDER=$1
TEST_FOLDER=$2
OUTPUT_FOLDER=$3
L=$4
CTW_FOLDER=$5

CLASS_NUMBER=$(ls $TRAIN_FOLDER | wc -l )

echo CLASSES : $CLASS_NUMBER

for CLASS in $(seq -w $CLASS_NUMBER)
do
    echo "Started alignment for class " $CLASS
    mkdir -p $OUTPUT_FOLDER/$CLASS

    for TEST_SAMPLE in $(ls $TEST_FOLDER/)
    do
        TEST_SAMPLE_ID=${TEST_SAMPLE%_*}
        OUTPUT_FILE="$OUTPUT_FOLDER/$CLASS/${TEST_SAMPLE}"
	echo $OUTPUT_FILE
        if [ ! -f $OUTPUT_FILE ]; then
            echo "Sample $TEST_SAMPLE is being aligned to class $CLASS"

	    src/script_bash/align_deep_pca_gctw_interface_test.sh $TRAIN_FOLDER/$CLASS $CLASS $TEST_FOLDER/$TEST_SAMPLE $OUTPUT_FOLDER/$CLASS $L $CTW_FOLDER
	fi
    done
done

