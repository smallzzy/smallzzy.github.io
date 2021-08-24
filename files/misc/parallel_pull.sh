#!/bin/bash

# 1. end with slash so you copy over the folder content
# 2. use absolute path
SRC=/volume1/Testing_Data/
DEST=/mnt/bigdata/Testing_Data/

# set the amount of rsync to run at the same time
# note that a value above ssh max connection can be dropped
PROC=5

# parallel on folders based on depth
# start from a specific depth when a previous sync has completed on this level
# do it for each layer until most folders has been went through
START_DEPTH=$1
DEPTH=$2
for d in $(seq $START_DEPTH 1 $DEPTH); do
    # find folder to be copied from remote
    LIST_FILE='find $SRC -type d -mindepth $d -maxdepth $d ! \( -path \"./@eaDir/*\" -o -path \"./#recycle/*\" \) -print0"'

    # make sure that rsync does not copy from subdir because parent folder might not exist
    RSYNC='xargs -0 -n1 -P$PROC -I {} -t '"rsync -aSP --no-perms --no-owner --no-group --no-links -e \"ssh -p 234\" -f'- */' -f'+ *' ""\"$SRC/{}/ $DEST/{}/\""

    # eval the pipe
    eval "$LIST_FILE | $RSYNC"
done

# another possible solution is to first copy over folder structure (or copy on the fly with --mkpath)
# and then paralel on all depth at the same time.
# but I cannot find a way to copy over folder structure very quickly.
# Maybe there is no trivial way to look for only folders?

# do not use over ssh channel because it puts a high stress on cpu
