#!/bin/bash

# 1. end with slash so you copy over the folder content
# 2. use absolute path
REMOTE=sbot@10.200.100.16
SRC=/volume1/ds1819_shared/
DEST=/mnt/bigdata/Data_Ingestion/
PROC=10
DEPTH=$1

# find folder to be copied from remote
LIST_FILE='ssh $REMOTE "cd \"$SRC\" && find . -type d -maxdepth $DEPTH ! \( -path \"./@eaDir/*\" -o -path \"./#recycle/*\" \) -print0"'

# run mutlple rsync for each command
# make sure that sync does not copy from subdir
RSYNC='xargs -0 -n1 -P$PROC -I {} -t '"rsync -aSP --no-perms --no-owner --no-group --no-links -e \"ssh -p 234\" -f'- */' -f'+ *' ""$REMOTE:$SRC""/{}/ ""$DEST""/{}/"

# eval the pipe
eval "$LIST_FILE | $RSYNC"
