
`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module indata_dram (
  clka,
  ena,
  wea,
  addra,
  dina,
  clkb,
  enb,
  addrb,
  doutb
);

(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *)
input wire clka;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *)
input wire ena;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *)
input wire [0 : 0] wea;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *)
input wire [3 : 0] addra;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *)
input wire [31 : 0] dina;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *)
input wire clkb;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *)
input wire enb;
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *)
input wire [3 : 0] addrb;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *)
output wire [31 : 0] doutb;

  blk_mem_gen_v8_4_2 #(
    .C_FAMILY("virtex7"),
    .C_XDEVICEFAMILY("virtex7"),
    .C_ELABORATION_DIR("./"),
    .C_INTERFACE_TYPE(0),
    .C_AXI_TYPE(1),
    .C_AXI_SLAVE_TYPE(0),
    .C_USE_BRAM_BLOCK(0),
    .C_ENABLE_32BIT_ADDRESS(0),
    .C_CTRL_ECC_ALGO("NONE"),
    .C_HAS_AXI_ID(0),
    .C_AXI_ID_WIDTH(4),
    .C_MEM_TYPE(1),
    .C_BYTE_SIZE(9),
    .C_ALGORITHM(1),
    .C_PRIM_TYPE(1),
    .C_LOAD_INIT_FILE(1),
    .C_INIT_FILE_NAME("indata_dram.mif"),
    .C_INIT_FILE("indata_dram.mem"),
    .C_USE_DEFAULT_DATA(0),
    .C_DEFAULT_DATA("0"),
    .C_HAS_RSTA(0),
    .C_RST_PRIORITY_A("CE"),
    .C_RSTRAM_A(0),
    .C_INITA_VAL("0"),
    .C_HAS_ENA(1),
    .C_HAS_REGCEA(0),
    .C_USE_BYTE_WEA(0),
    .C_WEA_WIDTH(1),
    .C_WRITE_MODE_A("NO_CHANGE"),
    .C_WRITE_WIDTH_A(32),
    .C_READ_WIDTH_A(32),
    .C_WRITE_DEPTH_A(16),
    .C_READ_DEPTH_A(16),
    .C_ADDRA_WIDTH(4),
    .C_HAS_RSTB(0),
    .C_RST_PRIORITY_B("CE"),
    .C_RSTRAM_B(0),
    .C_INITB_VAL("0"),
    .C_HAS_ENB(1),
    .C_HAS_REGCEB(0),
    .C_USE_BYTE_WEB(0),
    .C_WEB_WIDTH(1),
    .C_WRITE_MODE_B("WRITE_FIRST"),
    .C_WRITE_WIDTH_B(32),
    .C_READ_WIDTH_B(32),
    .C_WRITE_DEPTH_B(16),
    .C_READ_DEPTH_B(16),
    .C_ADDRB_WIDTH(4),
    .C_HAS_MEM_OUTPUT_REGS_A(0),
    .C_HAS_MEM_OUTPUT_REGS_B(0),
    .C_HAS_MUX_OUTPUT_REGS_A(0),
    .C_HAS_MUX_OUTPUT_REGS_B(0),
    .C_MUX_PIPELINE_STAGES(0),
    .C_HAS_SOFTECC_INPUT_REGS_A(0),
    .C_HAS_SOFTECC_OUTPUT_REGS_B(0),
    .C_USE_SOFTECC(0),
    .C_USE_ECC(0),
    .C_EN_ECC_PIPE(0),
    .C_READ_LATENCY_A(1),
    .C_READ_LATENCY_B(1),
    .C_HAS_INJECTERR(0),
    .C_SIM_COLLISION_CHECK("ALL"),
    .C_COMMON_CLK(0),
    .C_DISABLE_WARN_BHV_COLL(0),
    .C_EN_SLEEP_PIN(0),
    .C_USE_URAM(0),
    .C_EN_RDADDRA_CHG(0),
    .C_EN_RDADDRB_CHG(0),
    .C_EN_DEEPSLEEP_PIN(0),
    .C_EN_SHUTDOWN_PIN(0),
    .C_EN_SAFETY_CKT(0),
    .C_DISABLE_WARN_BHV_RANGE(0),
    .C_COUNT_36K_BRAM("0"),
    .C_COUNT_18K_BRAM("1"),
    .C_EST_POWER_SUMMARY("Estimated Power for IP     :     3.68295 mW")
  ) inst (
    .clka(clka),
    .rsta(1'D0),
    .ena(ena),
    .regcea(1'D0),
    .wea(wea),
    .addra(addra),
    .dina(dina),
    .douta(),
    .clkb(clkb),
    .rstb(1'D0),
    .enb(enb),
    .regceb(1'D0),
    .web(1'B0),
    .addrb(addrb),
    .dinb(32'B0),
    .doutb(doutb),
    .injectsbiterr(1'D0),
    .injectdbiterr(1'D0),
    .eccpipece(1'D0),
    .sbiterr(),
    .dbiterr(),
    .rdaddrecc(),
    .sleep(1'D0),
    .deepsleep(1'D0),
    .shutdown(1'D0),
    .rsta_busy(),
    .rstb_busy(),
    .s_aclk(1'H0),
    .s_aresetn(1'D0),
    .s_axi_awid(4'B0),
    .s_axi_awaddr(32'B0),
    .s_axi_awlen(8'B0),
    .s_axi_awsize(3'B0),
    .s_axi_awburst(2'B0),
    .s_axi_awvalid(1'D0),
    .s_axi_awready(),
    .s_axi_wdata(32'B0),
    .s_axi_wstrb(1'B0),
    .s_axi_wlast(1'D0),
    .s_axi_wvalid(1'D0),
    .s_axi_wready(),
    .s_axi_bid(),
    .s_axi_bresp(),
    .s_axi_bvalid(),
    .s_axi_bready(1'D0),
    .s_axi_arid(4'B0),
    .s_axi_araddr(32'B0),
    .s_axi_arlen(8'B0),
    .s_axi_arsize(3'B0),
    .s_axi_arburst(2'B0),
    .s_axi_arvalid(1'D0),
    .s_axi_arready(),
    .s_axi_rid(),
    .s_axi_rdata(),
    .s_axi_rresp(),
    .s_axi_rlast(),
    .s_axi_rvalid(),
    .s_axi_rready(1'D0),
    .s_axi_injectsbiterr(1'D0),
    .s_axi_injectdbiterr(1'D0),
    .s_axi_sbiterr(),
    .s_axi_dbiterr(),
    .s_axi_rdaddrecc()
  );
endmodule
