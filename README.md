
HPFIA is a FPGA-based fuzzy inference accelerator for situation assessment application.
We evaluate HPFIA at FPGA board equipped with Xilinx XC7VX690T, which work frequency is 125MHz.
We host the FPGA board on a server configured with Phytium CPU @2.2GHz for control, and 32GB of DDR4-2133 RAM.


## Requirements

HPFIA is written entirely in Verilog. It requires Xilinx Vivado version 18.3 or superior.
The upper software on host server is written in C. It has been tested with gcc compiler version 7.3.0 on Ubuntu OS.


## Folder structure

`src` contains the source files of fis core.

`testbench` contains the testbench files of simulations both for fis core and entire system. 

`fpga_protype` contains the datasets, upper software program and test results on FPGA board.



## More information

More information about the use and test of HPFIA are found on '/fpga_protype/README.md' and '/testbench/README.md' 


The artifacts are available for [HPFIA](https://github.com/gloria139com/HPFIA/).
