#!/usr/bin/env bash

# get list of worktrees names and remove bare repository from list
worktrees=$(git worktree list --porcelain | grep worktree | cut -d' ' -f2)
workdir="/app"

# branch names passed through comma separated string
# BRANCHES="branch1,branch2,branch3"
branches=$1

# filter out the worktrees having package.json file
worktrees=$(for worktree in $worktrees; do
    # create worktrees path by appeding $workdir and last folder in worktree
    branch=$(echo $worktree | rev | cut -d'/' -f1 | rev)
    path=$workdir/$branch
    # check if $branch exists in $branches only if $branches is not empty and package.json exists
    if [ -f $path/package.json ] && ( [ -z $branches ] || [[ $branches == *$branch* ]] ); then
        # install npm in these worktrees
        cd $path
        npm install
        echo $path
    fi
done)

domains_file="/domains/domains"
# domains_file="/home/codeclouds-nitin/projects/simplified/nginx/servers/domains"

get_port() {
    # get port number from domains file
    # 8080 foo.bar.com
    
    # Check if domains file exists
    if [ -f $domains_file ]; then
        # Read domains from domains.txt file
        while IFS= read -r line; do
            # Split the line into an array
            IFS=' ' read -r -a domain <<< "$line"
            # Get the port number
            port=${domain[0]}
            # Get the domain name
            domain_name=${domain[1]}
            # check if subdomain of domain_name exists in worktrees
            subdomain=$(echo $domain_name | cut -d'.' -f1)
            if [ $subdomain == $1 ]; then
                echo $port
            fi
        done < $domains_file
    fi
}

# get port number and start server for each worktree
for worktree in $worktrees; do
    # get subdomain by splitting worktree path and picking last element
    subdomain=$(echo $worktree | rev | cut -d'/' -f1 | rev)
    # get port number
    port=$(get_port $subdomain)
    echo $port
    # start server
    if [ ! -z $port ]; then
        echo "Starting server for $subdomain on port $port"
        cd $worktree
        # run server and save pid to kill later
        # show output in stdout
        npm run dev -- --port $port & echo $! > /tmp/$subdomain.server.pid & wait $!
    fi
done
