#!/bin/sh

function usage {
    echo "usage: $0 old-branch-name new-branch-name"
}

function check_branch_exist {
    
}

if [ $# != 2 ] ; then
    echo "Invalid input parameters!"
    usage
fi

oldname=$1
newname=$2

if [ $(check_branch_exist $oldname) == "false" ] ; then
fi

if [ $(check_branch_exist $newname) == "true" ] ; then
fi

