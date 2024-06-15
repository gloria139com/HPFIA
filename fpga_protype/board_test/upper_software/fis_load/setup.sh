#modify makefile

gcc -Iinclude -fPIC -shared src/*.c -o ./libdev.so

#export LD_LIBRARY_PATH=$(pwd)/
#gcc -Iinclude ./main.c -L./ -lfis -o ./main

#configuration
#export LD_LIBRARY_PATH=./:$LD_LIBRARY_PATH
#sudo insmod  memDriver.ko
