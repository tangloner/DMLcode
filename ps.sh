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

get_ps_conf $1 
#echo $ps
get_worker_conf $1 $2
#echo $worker

for(( i=35; i>35-$1-$2; i-- ))
do   
	{
	ssh ssd$i "source activate tensorflow"
	n=`expr 35 - $1`
	if [ $i -gt $n ]
	then
		index=`expr 35 - $i`
		ssh ssd$i "python /root/DMLcode/example.py" $ps $worker "--job_name=ps --task_index="$index ">> /root/DMLcode/result/ps"$index".txt"
		echo "python /root/DMLcode/example.py" $ps $worker "--job_name=ps --task_index="$index ">> /root/DMLcode/result/ps"$index".txt"
	else
		index=`expr 35 - $1 - $i`
		ssh ssd$i "python /root/DMLcode/example.py" $ps $worker "--job_name=worker --task_index="$index ">> /root/DMLcode/result/worker"$index".txt"
		echo "python /root/DMLcode/example.py" $ps $worker "--job_name=worker --task_index="$index ">> /root/DMLcode/result/worker"$index".txt"
	fi
	}&
done 
wait
echo "done"
