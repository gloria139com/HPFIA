#!/bin/bash

gcc -Iinclude ./main.c -L./ -lfis -o ./main

export LD_LIBRARY_PATH=export LD_LIBRARY_PATH=./:$LD_LIBRARY_PATH

./main


