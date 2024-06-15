#!/bin/bash

gcc -Iinclude ./download.c -L./ -ldev -o ./dat_load

export LD_LIBRARY_PATH=./:$LD_LIBRARY_PATH

echo "*****************Load driver and data files*******************"

sudo insmod  memDriver.ko
./dat_load

echo "End of loading!"

