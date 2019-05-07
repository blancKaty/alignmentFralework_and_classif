import os 
import numpy as np 
import sys
import time


def main():

    input_folder=sys.argv[1];

    label_file=sys.argv[2]

    video_list=[]
    label_list=[]
    with open(label_file) as f:
	for line in f:
		video_list.append(line.split()[0])
		label_list.append(int(line.split()[2]))
    
    print len(video_list) , len(label_list)

    comptVideo=0
    comptTop1=0

    nbClass=max(label_list)  

    confusionMat=np.zeros([nbClass,nbClass]) 

    allProba=np.zeros([len(video_list) , nbClass])

    start = time.time()
    
    # get all probabilities
    for alignment_class in range(1,nbClass+1):
	class_pad='%01d' % alignment_class
	output_file=input_folder+'protocol3_'+class_pad+'.out'
	print output_file
	cmptProba=0
	video_id=-1
	for line in open(output_file):
	    if (" Batch " in line )&(", prob =" in line):
		idx=line.split()[-4][:-1]
	        #print line
	    	if ( int(idx) != video_id):
	            #print idx , video_id , cmptProba
		    video_id=int(idx)
		    cmptProba=0
                proba=float(line.split(" ")[-1])
		#print "proba" , proba
		#print "cmptProba" , cmptProba
		#print "alignment_class" , alignment_class
		if cmptProba <= nbClass :
		    if cmptProba==alignment_class-1 :
			#print video_id , alignment_class , cmptProba, label_list[video_id], proba
			allProba[video_id , cmptProba]=proba
		cmptProba=cmptProba+1	
    
    end = time.time()
    print end-start , 'to get all probas'

    #print allProba 

    #Compute scores and confusion matrix
    for idx, video_folder in enumerate(video_list):
	label=label_list[idx] -1
	print video_folder , label
	itsProba=[]
	start = time.time()
        itsProba=allProba[idx , :]
	
	probas=np.array(itsProba).argsort()[-1:][::-1]
	end = time.time()
	#print end-start , 'for' , video_folder
	
	if label == probas[0]:
	    comptTop1=comptTop1+1

	confusionMat[label, probas[0]] = confusionMat[label, probas[0]]+1 
	comptVideo=comptVideo+1
	#print  video_folder , label , probas[0]
	#print "compteur : ",  comptVideo , comptTop1

    np.set_printoptions(threshold=np.nan)
    
    print 
    print "#######################"
    print "confusion matrix : true labels x predicted labels" 
    print "_"*(nbClass)*4
    
    for i in range(nbClass):
	sys.stdout.write("| ")
	for j in range(nbClass):
            sys.stdout.write(str(int(confusionMat[i,j]))+"| ")
	print ""
	
    print "_"*(nbClass)*4
    print 

	
    print "top-1 accuracy : "
    print float(comptTop1)/comptVideo
    print 


if __name__ == '__main__':
    main()



