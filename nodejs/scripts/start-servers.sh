#!/usr/bin/env bash

# get list of worktrees names and remove bare repository from list
worktrees=$(git worktree list --porcelain | grep worktree | cut -d' ' -f2)
workdir="/app"

# branch names passed through comma separated string
# BRANCHES="branch1,branch2,branch3"
branches=$1

domains_file="/domains-list/domains"

# if branches is empty read branches from domains file
if [ -z $branches ]; then
    domains=$(cat $domains_file | cut -d'.' -f1 | tr '\n' ',')
    branches=${domains::-1}
fi

# filter out the worktrees having package.json file
worktrees=$(for worktree in $worktrees; do
    # create worktrees path by appeding $workdir and last folder in worktree
    branch=$(echo $worktree | rev | cut -d'/' -f1 | rev)
    path=$workdir/$branch
    # check if $branch exists in $branches only if $branches is not empty and package.json exists
    if [ -f $path/package.json ] && ( [ -z $branches ] || [[ $branches == *$branch* ]] ); then
        echo $path
    fi
done)

# install npm in these worktrees
for worktree in $worktrees; do
    cd $worktree
    npm install
done

#sort worktrees by name
worktrees=$(echo $worktrees | tr ' ' '\n' | sort)


i=0
# get port number and start server for each worktree
for worktree in $worktrees; do
    # get subdomain by splitting worktree path and picking last element
    subdomain=$(echo $worktree | rev | cut -d'/' -f1 | rev)
    # get port number
    port=$((9000 + i++))
    # start server
    if [ ! -z $port ]; then
        cd $worktree
        echo "Starting server for $subdomain on port $port"
        # run server and save pid to kill later
        # show output in stdout
        npm run dev -- --port $port & echo $! > /tmp/$subdomain.server.pid & wait $!
    fi
done
