// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Fri Jun 14 10:13:19 2024
// Host        : DESKTOP-TJCDNLS running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub
//               
// Design      : acl_card_top
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module acl_card_top(sys_clk_in, pcie_wake_n, spi_sel_n, spi_dqo, 
  spi_dqi, spi_wrn_vpp, spi_hold_n, c0_ddr3_reset_n, c0_ddr3_cs_n, c0_ddr3_ras_n, 
  c0_ddr3_cas_n, c0_ddr3_we_n, c0_ddr3_ba, c0_ddr3_addr, c0_ddr3_dq, c0_ddr3_dm, c0_ddr3_odt, 
  c0_ddr3_cke, c0_ddr3_ck_p, c0_ddr3_ck_n, c0_ddr3_dqs_p, c0_ddr3_dqs_n, pcie_clkp, pcie_clkn, 
  pcie_rst_n, pcie_txp, pcie_txn, pcie_rxp, pcie_rxn)
/* synthesis syn_black_box black_box_pad_pin="sys_clk_in[0:0],pcie_wake_n[0:0],spi_sel_n[0:0],spi_dqo[0:0],spi_dqi[0:0],spi_wrn_vpp[0:0],spi_hold_n[0:0],c0_ddr3_reset_n[0:0],c0_ddr3_cs_n[0:0],c0_ddr3_ras_n[0:0],c0_ddr3_cas_n[0:0],c0_ddr3_we_n[0:0],c0_ddr3_ba[2:0],c0_ddr3_addr[14:0],c0_ddr3_dq[63:0],c0_ddr3_dm[7:0],c0_ddr3_odt[0:0],c0_ddr3_cke[0:0],c0_ddr3_ck_p[0:0],c0_ddr3_ck_n[0:0],c0_ddr3_dqs_p[7:0],c0_ddr3_dqs_n[7:0],pcie_clkp[0:0],pcie_clkn[0:0],pcie_rst_n[0:0],pcie_txp[7:0],pcie_txn[7:0],pcie_rxp[7:0],pcie_rxn[7:0]" */;
  input [0:0]sys_clk_in;
  output [0:0]pcie_wake_n;
  output [0:0]spi_sel_n;
  output [0:0]spi_dqo;
  input [0:0]spi_dqi;
  output [0:0]spi_wrn_vpp;
  output [0:0]spi_hold_n;
  output [0:0]c0_ddr3_reset_n;
  output [0:0]c0_ddr3_cs_n;
  output [0:0]c0_ddr3_ras_n;
  output [0:0]c0_ddr3_cas_n;
  output [0:0]c0_ddr3_we_n;
  output [2:0]c0_ddr3_ba;
  output [14:0]c0_ddr3_addr;
  inout [63:0]c0_ddr3_dq;
  output [7:0]c0_ddr3_dm;
  output [0:0]c0_ddr3_odt;
  output [0:0]c0_ddr3_cke;
  output [0:0]c0_ddr3_ck_p;
  output [0:0]c0_ddr3_ck_n;
  inout [7:0]c0_ddr3_dqs_p;
  inout [7:0]c0_ddr3_dqs_n;
  input [0:0]pcie_clkp;
  input [0:0]pcie_clkn;
  input [0:0]pcie_rst_n;
  output [7:0]pcie_txp;
  output [7:0]pcie_txn;
  input [7:0]pcie_rxp;
  input [7:0]pcie_rxn;
endmodule
