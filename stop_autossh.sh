#!/bin/bash

function getPID() {
    pid=$(ps -ef|grep -E '[a]utossh.*-M'|awk '{print $2}')    
    echo $pid
}

pid=$(getPID)
if [ "$pid" != "" ]; then
    echo "now running autossh"
    ps -ef|grep -E '[a]utossh.*-M'
else
    echo "no autossh running..."
    exit -1
fi

# stop
killall autossh

# pid check
pid=$(getPID)

if [ "$pid" != "" ]; then
    echo "autossh stop fail! 🙀🔥"
else
    echo "autossh stop succ. 💯 "
    sleep 1
    netstat -anptcp |grep LISTEN|grep -E '10443|3306|6379'
fi



