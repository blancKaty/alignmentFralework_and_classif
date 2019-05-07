INPUT_FOLDER=$1
ALIGN_IDX_FOLDER=$2
OUTPUT_FOLDER=$3

CLASS_NUMBER=$(ls $ALIGN_IDX_FOLDER | wc -l )

for CLASS in $(seq -w $CLASS_NUMBER) ;
do
    echo "For sample class: " $CLASS
    echo
    for align_file in $(ls $ALIGN_IDX_FOLDER/$CLASS)
    do
        SAMPLE_FOLDER=`echo $align_file | cut -d"." -f1`
        SAMPLE_FOLDER=`echo $align_file | cut -d"_" -f1-2`
        echo -e "\t\tCreating video for: " $align_file " in " $SAMPLE_FOLDER
        echo
        VID_INPUT_FOLDER=$INPUT_FOLDER/$SAMPLE_FOLDER
        VID_ALIGN_FILE=$ALIGN_IDX_FOLDER/$CLASS/$align_file
        VID_OUTPUT_FOLDER=$OUTPUT_FOLDER/$SAMPLE_FOLDER/
        echo -e "\t\tCreating output folder: " $VID_OUTPUT_FOLDER

	if [ ! -d $VID_OUTPUT_FOLDER ]
	then 
	    mkdir -p $VID_OUTPUT_FOLDER
	    python src/python/frames_from_indexes_sample.py $VID_INPUT_FOLDER $VID_ALIGN_FILE $VID_OUTPUT_FOLDER
	fi 
    done
done
