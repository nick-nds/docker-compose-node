#!/usr/bin/env bash

# get server name from argument
server_name=$1

# split the server name by comma
server_names=$(echo $server_name | tr ',' ' ')

stop_server() {
    pid_file="/tmp/$1.server.pid"
    # stop the server
    kill -15 $(cat $pid_file)
    # remove the server file
    rm $pid_file
    echo "Stopped server $1"
}
# if server_names is empty then get server names from /tmp/*.server.pid file
if [ -z $server_name ]; then
    # get list of servers from /tmp/*.server.pid file
    servers=$(ls /tmp/*.server.pid)
    # loop through each server and stop the server
    for server in $servers; do
        # get server name from file name
        server_name=$(echo $server | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)
        echo "Stopping server $server_name"
        stop_server $server_name
    done
else 
    # loop through each server_name
    # stop the server and remove the server file
    for server_name in $server_names; do
        echo "Stopping server $server_name"
        stop_server $server_name
    done
fi

# wait for 5 seconds
sleep 5

# check if process of patter `npm run dev --port` is running
process=$(ps aux | grep "npm run dev --port" | grep -v grep)
if [ -z "$process" ]; then
    echo "All servers are stopped."
    # kill all bash processes
    kill $(ps aux | grep bash | grep -v grep | awk '{print $1}' | xargs -I {} kill -9 {})
fi
