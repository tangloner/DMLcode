#!/bin/sh
#$1 is the number of PSs
#$2 is the number of members in cluster
#$3 is the index of node eg: ssd35's index is "35"
# build a folder named "result" as the path 
#the ps.sh run in ssd02
get_cluster_conf(){
    ps=""
    worker=""
    n=0
    for((i=0;i<$2;i++));
    do
	index=`expr $i + $3`
        if [ $i -lt $1 ]
        then
            ps="$ps,172.17.10.$index:22222"
        else
            worker="$worker,172.17.10.$index:22222"
        fi
    done
    cluster="--ps_hosts="${ps:1}" --worker_hosts="${worker:1}
};
#get cluster configuration eg: cluster="--ps_hosts=ip:port--worker_hosts=ip:port"
get_cluster_conf $1 $2 $3

for((i=0;i<$2;i++));  
do   
	{
	ssh ssd$i "source activate tensorflow"
	if [ $i -lt $1 ]
	then
		ssh ssd$i "python /root/DMLcode/example.py --job_name=ps --task_index=$i" >> /root/DMLcode/result/"ps"$i.txt
		echo "python /root/DMLcode/example.py "$cluster" --job_name=ps --task_index=$i"
	else
		ssh ssd$i "python /root/DMLcode/example.py --job_name=worker --task_index=$i" >> /root/DMLcode/result/"worker"$p.txt
		echo "python /root/DMLcode/example.py "$cluster" --job_name=worker --task_index="$[$i-$1]
	fi
	}&
done 
wait
echo "compile!"
