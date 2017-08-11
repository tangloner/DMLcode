#!/bin/bash
# $1 is the number of PSs
# $2 is the number of workers
# ps.sh run in ssd35

get_ps_conf(){
    ps=""
    for(( i=35; i > 35-$1; i-- ))
    do
        ps="$ps,ssd$i:2222"
    done
        ps=${ps:1}
};

get_worker_conf(){
    worker=""
    for(( i=35-$1; i > 35-$1-$2; i-- ))
    do
        worker="$worker,ssd$i:2222"
    done
    worker=${worker:1}
};


source ~/anaconda2/envs/tensorflow/bin/activate
python /root/DMLcode/example.py $1 $2 --job_name=ps --task_index=0
