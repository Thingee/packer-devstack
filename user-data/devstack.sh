#!/bin/sh

DIR='/opt/stack';

for f in `ls $DIR`;
do
    if [ "$f" != "data" ] && [ "$f" != "status" ]
    then
	echo "Updating $f"
        cd $DIR/$f && git pull
    fi
done

su ubuntu -c 'cd /home/ubuntu/devstack/;./stack.sh'
