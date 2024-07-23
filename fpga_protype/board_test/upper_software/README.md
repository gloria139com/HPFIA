
## Running the upper software

1. Loading board driver and downloading dataset files into DDR

		cd /fis_load
		
		./fpga_load.sh
		
2. Selecting fis cores and generating the executable file *.out. Take selecting fis_core1 for example:

    cd /fis_core1
    
    gcc -Iinclude ./main.c -L./ -lfis -o ./1.out (or ./run.sh)
 
  At this stage, the number of datasets and inference calculation for each fis core could be set in the configure file '/fis_core1/main.c' . 
   
  If selecting multiple fis cores, the executable file for each core should be generated in the same way mentioned above. That is to say, if using 8 fis cores, the executable files 1.out, 2.out, ..., 8.out should be generated seperately in the directories `/fis_core1/`, `/fis_core2/`,...,`/fis_core8/`.
  
  
3. Copying the executable files to the directory `/test_8core/`
 
4. Executing the script file

    cd /test_8core
    
    export LD_LIBRARY_PATH=./:$LD_LIBRARY_PATH
    
    ./run.sh   
    
    

## Folder structure

`fis_core1` contains the driver source files, configure files and run script for fis_core1.

`fis_core2` contains the device source files, configure files and run script for fis_core2.

`fis_core3` contains the device source files, configure files and run script for fis_core3.

`fis_core4` contains the device source files, configure files and run script for fis_core4.

`fis_core5` contains the device source files, configure files and run script for fis_core5.

`fis_core6` contains the driver source files, configure files and run script for fis_core6.

`fis_core7` contains the driver source files, configure files and run script for fis_core7.

`fis_core8` contains the driver source files, configure files and run script for fis_core8.

`fis_load` contains the driver source files and run script for FPGA board.

`test_8core` contains the executable files and run script for simulation.

Note that the driver source files may need to be modified as applying on different FPGA boards.

