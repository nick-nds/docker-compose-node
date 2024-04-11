#!/usr/bin/env bash

# get server name from argument
server_name=$1

# check if server name is passed
# if not passed then pick the list of servers from /tmp/*.server.pid file
if [ -z $server_name ]; then
    # get list of servers from /tmp/*.server.pid file
    servers=$(ls /tmp/*.server.pid)
    # loop through each server and stop the server
    for server in $servers; do
        # get server name from file name
        server_name=$(echo $server | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)
        # stop the server
        kill -15 $(cat $server)
        # remove the server file
        rm $server
        echo "Stopped server $server_name"
    done
else
    # stop the server
    kill -15 $(cat /tmp/$server_name.server.pid)
    # remove the server file
    rm /tmp/$server_name.server.pid
    echo "Stopped server $server_name"
fi
