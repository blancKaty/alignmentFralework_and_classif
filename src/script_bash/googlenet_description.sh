TRAIN_FOLDER=$1
TEST_FOLDER=$2

OUTPUT_FOLDER=$3

FEATURES_TRAIN_FOLDER=$OUTPUT_FOLDER/googleNetRep_train
FEATURES_TEST_FOLDER=$OUTPUT_FOLDER/googleNetRep_test


CAFFE_FOLDER=$4

MODEL_PATH=$CAFFE_FOLDER/models/bvlc_googlenet
NET=$CAFFE_FOLDER/models/bvlc_googlenet/deploy.prototxt
MEAN_FILE=$CAFFE_FOLDER/python/caffe/imagenet/ilsvrc_2012_mean.npy
LAYER="pool5/7x7_s1"


source /data/sparks/share/asl/asl/bin/activate
source /etc/profile.d/modules.sh
module load cuda/8.0
module load cudnn/5.1-cuda-8.0

echo "Extract googleNet features from each frame from the train set..."
mkdir -p $FEATURES_TRAIN_FOLDER
python src/python/extract_features.py $TRAIN_FOLDER $MODEL_PATH $NET $MEAN_FILE $FEATURES_TRAIN_FOLDER $LAYER $CAFFE_FOLDER/python 
chmod 777 $FEATURES_TRAIN_FOLDER

#Create deep_features_test
echo "Extract googleNet features from each frame from the test set..."
mkdir -p $FEATURES_TEST_FOLDER
python src/python/extract_features.py $TEST_FOLDER $MODEL_PATH $NET $MEAN_FILE $FEATURES_TEST_FOLDER $LAYER $CAFFE_FOLDER/python
chmod 777 $FEATURES_TEST_FOLDER


