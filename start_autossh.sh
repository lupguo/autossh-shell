#!/bin/bash
#
# 
RemoteAddress=
RemotePort=

function getPID() {
    pid=$(ps -ef|grep -E '[a]utossh.*-M'|awk '{print $2}')
    echo "$pid"
}

# check running
pid=$(getPID)
if [ "$pid" != "" ]; then
    echo "🙌 autossh pid($pid) is already running, no need to run repeatedly!"
    exit -1
fi

# start
portMaps=(
    10443:"127.0.0.1:10443" 
    6379:"127.0.0.1:6379" 
    3306:"127.0.0.1:3306"
    #9092:"127.0.0.1:9092"
)

# concat local str
for portMap in ${portMaps[@]}; do
    localStr="$localStr -L $portMap"
done

# echo start shell & start shell
startSH="autossh -f -M0 $localStr $RemoteAddress -p $RemotePort-N"
echo $startSH
$startSH

# check start success
pid=$(getPID)
if [ "$pid" != "" ]; then
    echo "autossh start succ, pid(${pid}) is running... "
    sleep 1
    netstat -anptcp |grep LISTEN|grep -E '10443|3306|6379'
else
    echo "autossh start fail."
fi
