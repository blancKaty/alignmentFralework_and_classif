import os
import shutil
import sys
import multiprocessing
import glob


def copy(source, dest):
    shutil.copyfile(source, dest)


def main():
    input_folder = sys.argv[1]
    output_folder = sys.argv[2]
    print 'input reduce fps  : ' , sys.argv
    fps = int(sys.argv[3]);

    final_length=float(sys.argv[4]) ;
    max_length=final_length * fps ;

    print 'normalisation param : ' , fps , final_length , max_length

    if os.path.exists(output_folder):
        shutil.rmtree(output_folder)

    os.makedirs(output_folder)

    pool = multiprocessing.Pool(multiprocessing.cpu_count())
    print "Using a Pool of", multiprocessing.cpu_count(), "processes"

    X = sorted(next(os.walk(input_folder))[1])
    print X
    for x in X:
        folder = os.path.join(output_folder, x)
        os.mkdir(folder)

        #Y = os.listdir(os.path.join(input_folder, x))
	#print input_folder , x 
	Y = glob.glob(input_folder+"/"+x+"/*.jpg")
        Y.sort()
	
	sizeV=len(Y)
	#print sizeV
	if (sizeV > max_length) : 
	    Y=Y[int(sizeV/2)-int(max_length/2): int(sizeV/2)+int(max_length/2)]
		
        for idx, i in enumerate(range(0, len(Y), fps)): 
            y = Y[i]
            source = y
	    #print y , "image_{:05d}.jpg".format(idx + 1)
            y = "image_{:05d}.jpg".format(idx + 1)
            dest = os.path.join(folder, y)
	    #print source , dest 
            pool.apply_async(copy, (source, dest))

    pool.close()
    pool.join()


if __name__ == '__main__':
    main()
