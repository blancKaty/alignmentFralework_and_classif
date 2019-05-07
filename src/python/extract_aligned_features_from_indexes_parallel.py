import shutil
import sys
import os
import multiprocessing

import numpy as np


def copy(source, dest):
    shutil.copyfile(source, dest)


def main():
    input_folder = sys.argv[1]
    alignment_file = sys.argv[2]
    output_folder = sys.argv[3] if len(sys.argv) > 3 else input_folder

    print 'config : ', input_folder, alignment_file, output_folder
    # matlab is 1-indexed
    aligned_idx = np.loadtxt(alignment_file, delimiter=',')

    video_folders = sorted(os.listdir(input_folder))
    assert len(video_folders) == aligned_idx.shape[1], "lenght differs for the csv files : " + alignment_file

    pool = multiprocessing.Pool(multiprocessing.cpu_count())
    print "Using a Pool of", multiprocessing.cpu_count(), "processes"

    for idx, video_feature_file in enumerate(video_folders):
        print idx, video_feature_file

	pca_features = np.loadtxt(os.path.join(input_folder, video_feature_file) , delimiter=',')
	new_pca_features= np.zeros((aligned_idx.shape[0] , pca_features.shape[1]));

        for frame_idx, frame in enumerate(aligned_idx[:, idx]):
	    new_pca_features[frame_idx,:]=pca_features[int(round(frame))-1 , :];

	np.savetxt(os.path.join(output_folder, video_feature_file ) , new_pca_features , delimiter=',' );

    pool.close()
    pool.join()


if __name__ == '__main__':
    main()
