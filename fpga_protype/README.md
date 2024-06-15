
The FPGA protype for HPFIA is tested on Xilinx XC7VX690T board. 
We use the application datasets for test, which include 18 datasets for two-dimensional coordinates and 10 datasets for three-dimensional coordinates, 28 datasets in total. Each dataset includes coordinate data, input information, output information and rule information.
We provide partial test results of HPFIA with single-core, 4-core and 8-core.

## Folder structure

`datasets` contains the datasets in binary format used for test on FPGA board. 

`board_test` contains the files for test on FPGA board, including bitstream and upper software program.

`results` contains the files of partial test results on FPGA board. 




