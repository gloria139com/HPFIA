#!/bin/bash

now=`date +'%Y-%m-%d %H:%M:%S'`
start_time=$(date --date="$now" +%s);

./1.out & ./2.out & ./3.out & ./4.out & ./5.out & ./6.out & ./7.out & ./8.out

echo "Testing finished!"

now=`date +'%Y-%m-%d %H:%M:%S'`
end_time=$(date --date="$now" +%s);
echo "used time:"$((end_time-start_time))"s"
