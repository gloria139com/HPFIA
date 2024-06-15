
We provide simulation files both for fis core and entire system.

# Simulating fis core

  Link the testbench file '/testbench/fis_tb/fis_simu.v' with the source files for fis core in directory `/src/` to simulate on Vivado.


# Siulating system

  Use the netlist file '/testbench/sys_tb/acl_card_top.edf' to simulate the entire system on Vivado.



## Folder structure

`fis_sim` contains the testbench file for simulating fis core.

`sys_sim` contains the netlist files for simulating system. We also provide the system top file 'acl_card_top_src.v' to give an overview of entire system framework.

