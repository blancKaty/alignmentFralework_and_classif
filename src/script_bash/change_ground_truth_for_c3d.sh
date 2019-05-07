#! /bin/bash

INPUT=$1
OUTPUT=$2


nb=$(wc -l $INPUT | cut -d ' ' -f 1);
cat $INPUT | cut -d ' ' -f 1 > tmpNom ; 
cat $INPUT | cut -d ' ' -f 2 > tmpLabels ;
(for i in $(seq 1 $nb) ; do echo 1 ; done )  > tmp1 ;

paste -d ' ' tmpNom tmp1 tmpLabels tmp1 > $OUTPUT ;

rm tmpNom tmp1 tmpLabels ;
#./change_ground_truth_for_c3d.sh /data/sparks/share/isoGD/rawData100/train_list.txt /data/sparks/share/isoGD/rawData100/train_list_c3d.txt

