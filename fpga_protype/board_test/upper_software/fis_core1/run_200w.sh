#!/bin/bash

now=`date +'%Y-%m-%d %H:%M:%S'`
start_time=$(date --date="$now" +%s);

./200w.out

echo "Testing finished!"

now=`date +'%Y-%m-%d %H:%M:%S'`
end_time=$(date --date="$now" +%s);
echo "used time:"$((end_time-start_time))"s"

