#!/bin/sh

if [ "$1" = "ps" ]
then

python /root/code/LogicRgression/offline_logistic_regression.py --job_name=$1 --task_index=$2 --batch_size=500 --num_epochs=1 --train=/root/data/url_svmlight/Day#.svm --line_skip_count=0 --features=3231961

elif [ "$1" = "worker" ]
then

python /root/code/LogicRgression/offline_logistic_regression.py --job_name=$1 --task_index=$2 --btach_size=500 --num_epochs=1 --train=/root/data/url_svmlight/Day#.svm --line_skip_count=0 --features=3231961 --data_index_start=$3 --data_index_end=$4

fi
