#! /bin/bash

input_folder=$1
grd_truth_file=$2
output_folder=$3

#get the number of class
class_nb=$( cat $grd_truth_file | cut -d ' ' -f 2 | sort -n | tail -n 1 )

for class in $(seq -w $class_nb)
do
	mkdir -p $output_folder/$class
	new_class=$(echo $class | sed 's/^0*//')
	echo Class : $new_class
	file_list=$(cat $grd_truth_file | grep " $new_class"$ | cut -d ' ' -f 1)
	for video in $file_list
	do
		echo copy $video features
		cp $input_folder/"$video"_features.csv $output_folder/$class
	done
done


