
`timescale 1ns/1ps

module acl_card_top(
    //clock and reset signals.
    sys_clk_in              ,
    pcie_wake_n             ,
    //load flash signals.
    spi_sel_n               ,
    spi_dqo                 ,//spi_dq0
    spi_dqi                 ,//spi_dq1
    spi_wrn_vpp             ,//spi_dq2
    spi_hold_n              ,//spi_dq3
    //ddr fabric interface signals.
    c0_ddr3_reset_n         ,
    c0_ddr3_cs_n            ,
    c0_ddr3_ras_n           ,
    c0_ddr3_cas_n           ,
    c0_ddr3_we_n            ,
    c0_ddr3_ba              ,
    c0_ddr3_addr            ,
    c0_ddr3_dq              ,
    c0_ddr3_dm              ,
    c0_ddr3_odt             ,
    c0_ddr3_cke             ,
    c0_ddr3_ck_p            ,
    c0_ddr3_ck_n            ,
    c0_ddr3_dqs_p           ,
    c0_ddr3_dqs_n           ,
    //PCIe fabric interface signals.
    pcie_clkp               ,
    pcie_clkn               ,
    pcie_rst_n              ,
    pcie_txp                ,
    pcie_txn                ,
    pcie_rxp                ,
    pcie_rxn                
    );
    //parameters defination.
    parameter       LOGIC_DATA_TIME    = 32'h20230210 ;
    parameter       DDR_CLK_FEQCY      = 32'h00000064 ;
    parameter       FPGA_INFO          = 32'h0000_0004;
    
    parameter       DEEP_VER_INFO      = 32'h0004_0001;
    
    parameter       RESET_TIME         = 32'h1E8480   ;
    parameter       PCIE_DMA_LEN       = 15'h2000     ;
    
    parameter       FIS_UNIT_NUM       = 8            ;
    parameter       FIS_RST_ADDR       = 24'h2004     ;
    parameter       FIS_START_ADDR     = 24'h2008     ;
    parameter       MIG_RST_ADDR       = 24'h2014     ;
    parameter       FIS_IP_ADDR        = 24'h2080     ;
    parameter       FIS_NUM_ADDR       = 24'h2084     ;
    parameter       FIS_DONE_ADDR      = 24'h2088     ;
                                                             
    parameter       FIS_0_NUM_ADDR     = 24'h2100     ;
    parameter       FIS_1_NUM_ADDR     = 24'h2104     ;
    parameter       FIS_2_NUM_ADDR     = 24'h2108     ;
    parameter       FIS_3_NUM_ADDR     = 24'h210c     ;
    parameter       FIS_4_NUM_ADDR     = 24'h2110     ;
    parameter       FIS_5_NUM_ADDR     = 24'h2114     ;
    parameter       FIS_6_NUM_ADDR     = 24'h2118     ;
    parameter       FIS_7_NUM_ADDR     = 24'h211c     ;                                        
    parameter       FIS_0_START_ADDR   = 24'h2120     ;
    parameter       FIS_1_START_ADDR   = 24'h2124     ;
    parameter       FIS_2_START_ADDR   = 24'h2128     ;
    parameter       FIS_3_START_ADDR   = 24'h212c     ;
    parameter       FIS_4_START_ADDR   = 24'h2130     ;
    parameter       FIS_5_START_ADDR   = 24'h2134     ;
    parameter       FIS_6_START_ADDR   = 24'h2138     ;
    parameter       FIS_7_START_ADDR   = 24'h213c     ;
    parameter       FIS_0_DONE_ADDR    = 24'h2140     ;
    parameter       FIS_1_DONE_ADDR    = 24'h2144     ;
    parameter       FIS_2_DONE_ADDR    = 24'h2148     ;
    parameter       FIS_3_DONE_ADDR    = 24'h214c     ;
    parameter       FIS_4_DONE_ADDR    = 24'h2150     ;
    parameter       FIS_5_DONE_ADDR    = 24'h2154     ;
    parameter       FIS_6_DONE_ADDR    = 24'h2158     ;
    parameter       FIS_7_DONE_ADDR    = 24'h215c     ;
    parameter       FIS_0_RESULT_ADDR  = 24'h2160     ;
    parameter       FIS_1_RESULT_ADDR  = 24'h2164     ;
    parameter       FIS_2_RESULT_ADDR  = 24'h2168     ;
    parameter       FIS_3_RESULT_ADDR  = 24'h216c     ;
    parameter       FIS_4_RESULT_ADDR  = 24'h2170     ;
    parameter       FIS_5_RESULT_ADDR  = 24'h2174     ;
    parameter       FIS_6_RESULT_ADDR  = 24'h2178     ;
    parameter       FIS_7_RESULT_ADDR  = 24'h217c     ;
    
    parameter       FIS_0_IDAT_0_ADDR  = 24'h2180     ;
    parameter       FIS_0_IDAT_1_ADDR  = 24'h2184     ;
    parameter       FIS_0_IDAT_2_ADDR  = 24'h2188     ;
    parameter       FIS_1_IDAT_0_ADDR  = 24'h2190     ;
    parameter       FIS_1_IDAT_1_ADDR  = 24'h2194     ;
    parameter       FIS_1_IDAT_2_ADDR  = 24'h2198     ;
    parameter       FIS_2_IDAT_0_ADDR  = 24'h21a0     ;
    parameter       FIS_2_IDAT_1_ADDR  = 24'h21a4     ;
    parameter       FIS_2_IDAT_2_ADDR  = 24'h21a8     ;
    parameter       FIS_3_IDAT_0_ADDR  = 24'h21b0     ;
    parameter       FIS_3_IDAT_1_ADDR  = 24'h21b4     ;
    parameter       FIS_3_IDAT_2_ADDR  = 24'h21b8     ;
    parameter       FIS_4_IDAT_0_ADDR  = 24'h21c0     ;
    parameter       FIS_4_IDAT_1_ADDR  = 24'h21c4     ;
    parameter       FIS_4_IDAT_2_ADDR  = 24'h21c8     ;
    parameter       FIS_5_IDAT_0_ADDR  = 24'h21d0     ;
    parameter       FIS_5_IDAT_1_ADDR  = 24'h21d4     ;
    parameter       FIS_5_IDAT_2_ADDR  = 24'h21d8     ;                                                           
    parameter       FIS_6_IDAT_0_ADDR  = 24'h21e0     ;
    parameter       FIS_6_IDAT_1_ADDR  = 24'h21e4     ;
    parameter       FIS_6_IDAT_2_ADDR  = 24'h21e8     ;
    parameter       FIS_7_IDAT_0_ADDR  = 24'h21f0     ;
    parameter       FIS_7_IDAT_1_ADDR  = 24'h21f4     ;
    parameter       FIS_7_IDAT_2_ADDR  = 24'h21f8     ;
    
    parameter       CMD_SADDR        = 32'h0000_0000  ;
    parameter       CMD_RLEN         = 32'h0000_0010  ;
    parameter       FIS_STEP_ADDRESS = 32'h2_0000     ;
    //-------------------------------------------------------------------
    // Defination of Ports
    //-------------------------------------------------------------------
    //clock and reset signals.
    input   wire [00:0]             sys_clk_in               ;
    output  wire [00:0]             pcie_wake_n              ;
    //load flash signals.
    output  wire [00:0]             spi_sel_n                ;
    output  wire [00:0]             spi_dqo                  ;
    input   wire [00:0]             spi_dqi                  ;
    output  wire [00:0]             spi_wrn_vpp              ;
    output  wire [00:0]             spi_hold_n               ;
    // ddr fabric interface signals.
    inout   tri  [63:0]             c0_ddr3_dq               ;
    output  wire [14:0]             c0_ddr3_addr             ;
    output  wire [02:0]             c0_ddr3_ba               ;
    output  wire [00:0]             c0_ddr3_ras_n            ;
    output  wire [00:0]             c0_ddr3_cas_n            ;
    output  wire [00:0]             c0_ddr3_we_n             ;
    output  wire [00:0]             c0_ddr3_reset_n          ;
    output  wire [00:0]             c0_ddr3_cs_n             ;
    output  wire [00:0]             c0_ddr3_odt              ;
    output  wire [00:0]             c0_ddr3_cke              ;
    output  wire [07:0]             c0_ddr3_dm               ;
    inout   tri  [07:0]             c0_ddr3_dqs_p            ;
    inout   tri  [07:0]             c0_ddr3_dqs_n            ;
    output  wire [00:0]             c0_ddr3_ck_p             ;
    output  wire [00:0]             c0_ddr3_ck_n             ;
    //PCI Express Fabric Interface signals.
    input   wire [00:0]             pcie_clkp                ; 
    input   wire [00:0]             pcie_clkn                ; 
    input   wire [00:0]             pcie_rst_n               ; 
    output  wire [07:0]             pcie_txp                 ; 
    output  wire [07:0]             pcie_txn                 ; 
    input   wire [07:0]             pcie_rxp                 ; 
    input   wire [07:0]             pcie_rxn                 ; 
    //====================================================================//
    //----------------------internal signals------------------------------//
    //====================================================================//
    wire   [00:0]                   pcie_ref_clk             ;
    wire   [00:0]                   pcie_rst_n_c             ;
    wire   [00:0]                   sys_clk_100m             ;
    wire   [00:0]                   sys_clk_125m             ;
    wire   [00:0]                   sys_clk_200m             ;
    wire   [00:0]                   ddr_ref_clk              ;
    wire   [00:0]                   ddr_sys_clk              ;
    wire   [00:0]                   clk_spi                  ;
    wire   [00:0]                   sys_rst_i                ;
    wire   [00:0]                   usr_synclk               ;
    wire   [00:0]                   sys_rst_p                ;
           
    wire   [00:0]                   ddr3_synclk              ;
    wire   [00:0]                   ddr3_synrst              ;
    wire   [00:0]                   ddr3_fcfifo_wr           ;
    wire   [79:0]                   ddr3_fcfifo_wdata        ;
    wire   [00:0]                   ddr3_fcfifo_afull        ;
    wire   [00:0]                   ddr3_tcfifo_wr           ;
    wire   [79:0]                   ddr3_tcfifo_wdata        ;
    wire   [00:0]                   ddr3_tcfifo_afull        ;
    wire   [00:0]                   ddr3_fxfifo_wr           ;
    wire   [511:0]                  ddr3_fxfifo_wdata        ;
    wire   [00:0]                   ddr3_fxfifo_afull        ;
    wire   [00:0]                   ddr3_fxfifo_empty        ;
    wire   [00:0]                   ddr3_txfifo_wr           ;
    wire   [511:0]                  ddr3_txfifo_wdata        ;
    wire   [00:0]                   ddr3_txfifo_afull        ;
    wire   [00:0]                   ddr3_txfifo_empty        ;
    wire   [00:0]                   ddr3_0_tcfifo_wr         ;
    wire   [79:0]                   ddr3_0_tcfifo_wdata      ;
    wire   [00:0]                   ddr3_0_txfifo_wr         ;
    wire   [511:0]                  ddr3_0_txfifo_wdata      ;
    wire   [00:0]                   ddr3_1_tcfifo_wr         ;
    wire   [79:0]                   ddr3_1_tcfifo_wdata      ;
    wire   [00:0]                   ddr3_1_txfifo_wr         ;
    wire   [511:0]                  ddr3_1_txfifo_wdata      ;
    wire   [00:0]                   ddr3_frx_sign            ;
    wire   [00:0]                   ddr3_rxfifo_wr           ;
    wire   [511:0]                  ddr3_rxfifo_wdata        ;
    wire   [00:0]                   ddr3_rxfifo_afull        ;
    wire   [00:0]                   ddr3_0_rxfifo_afull      ;
    wire   [00:0]                   ddr3_1_rxfifo_afull      ;
    wire   [00:0]                   ddr3_2_rxfifo_afull      ;
    wire   [00:0]                   ddr3_ready               ;
    wire   [00:0]                   ddr3_read_done           ;
    wire   [11:0]                   device_temp              ;
    wire   [00:0]                   ddr_soft_rstp            ;
    wire   [00:0]                   ddr_mig_rstn             ;
           
    wire   [00:0]                   pcie_synclk              ;
    wire   [00:0]                   pcie_synrst              ;
    wire   [01:0]                   localbus_bs              ;
    wire   [00:0]                   localbus_wr              ;
    wire   [00:0]                   localbus_rd              ;
    wire   [23:0]                   localbus_addr            ;
    wire   [63:0]                   localbus_wdat            ;
    wire   [63:0]                   localbus_rdat0           ;
    wire   [00:0]                   localbus_rvld0           ;
    wire   [63:0]                   localbus_rdat1           ;
    wire   [00:0]                   localbus_rvld1           ;
    wire   [63:0]                   localbus_rdat2           ;
    wire   [00:0]                   localbus_rvld2           ;
    wire   [63:0]                   localbus_rdat3           ;
    wire   [00:0]                   localbus_rvld3           ;
    reg    [15:0]                   localbus_rdhalt          ;
    reg    [63:0]                   localbus_rdatt           ;
    reg    [00:0]                   localbus_rvldt           ;
    wire   [63:0]                   localbus_rdat            ;
    wire   [00:0]                   localbus_rvld            ;
    wire   [00:0]                   pcie_0_tcfifo_wr         ;
    wire   [95:0]                   pcie_0_tcfifo_wdata      ;
    wire   [00:0]                   pcie_0_txfifo_wr         ;
    wire   [255:0]                  pcie_0_txfifo_wdata      ;
    wire   [00:0]                   pcie_1_tcfifo_wr         ;
    wire   [95:0]                   pcie_1_tcfifo_wdata      ;
    wire   [00:0]                   pcie_1_txfifo_wr         ;
    wire   [255:0]                  pcie_1_txfifo_wdata      ;
    wire   [00:0]                   pcie_tcfifo_wr           ;
    wire   [95:0]                   pcie_tcfifo_wdata        ;
    wire   [00:0]                   pcie_tcfifo_afull        ;
    wire   [00:0]                   pcie_txfifo_wr           ;
    wire   [255:0]                  pcie_txfifo_wdata        ;
    wire   [00:0]                   pcie_txfifo_afull        ;
    wire   [00:0]                   pcie_rxfifo_wr           ;
    wire   [255:0]                  pcie_rxfifo_wdata        ;
    wire   [00:0]                   pcie_rxfifo_afull        ;
    wire   [00:0]                   pcie_0_rxfifo_afull      ;
    wire   [00:0]                   pcie_1_rxfifo_afull      ;
    //flash user signals;                                     
    wire   [00:0]                   spi_tcfifo_wr            ;
    wire   [71:0]                   spi_tcfifo_wdata         ;
    wire   [00:0]                   spi_tcfifo_afull         ;
    wire   [00:0]                   spi_txfifo_wr            ;
    wire   [07:0]                   spi_txfifo_wdata         ;
    wire   [00:0]                   spi_txfifo_afull         ;
    wire   [00:0]                   spi_rxfifo_wr            ;
    wire   [07:0]                   spi_rxfifo_wdata         ;
    wire   [00:0]                   spi_rxfifo_afull         ;
    wire   [00:0]                   spi_sta_vld              ;
    wire   [07:0]                   spi_sta_dat              ;
    wire   [00:0]                   spi_era_busy             ;
    wire   [00:0]                   spi_wr_busy              ;
    wire   [00:0]                   spi_rd_busy              ;
    //pcie  status signals.
    wire   [03:0]                   cfg_negotiated_width     ;
    wire   [02:0]                   cfg_current_speed        ;
    wire   [02:0]                   cfg_max_payload          ;
    wire   [02:0]                   cfg_max_read_req         ;
    wire   [07:0]                   bus_num                  ;
    wire   [07:0]                   tlp_op_halt              ;
    wire   [00:0]                   dma_para_mode            ;
    wire   [10:0]                   dma_payload_wlen         ;
    wire   [10:0]                   dma_payload_rlen         ;
    wire   [00:0]                   user_reset               ;
    wire   [00:0]                   user_lnk_up              ;
    //user register signals;
    wire   [00:0]                   pc_fis_rst               ;
    wire   [00:0]                   pc_fis_start             ;
    wire   [00:0]                   pc_fis_done              ;
    wire   [00:0]                   pc_mig_rst               ;
    
    wire   [00:0]                   fis_start                ;
    wire   [FIS_UNIT_NUM-1:0]       fis_para_set             ;
    wire   [05:0]                   fis_0_num                ;
    wire   [05:0]                   fis_1_num                ;
    wire   [05:0]                   fis_2_num                ;
    wire   [05:0]                   fis_3_num                ;
    wire   [05:0]                   fis_4_num                ;
    wire   [05:0]                   fis_5_num                ;
    wire   [05:0]                   fis_6_num                ;
    wire   [05:0]                   fis_7_num                ;
    wire   [00:0]                   fis_0_start              ;
    wire   [00:0]                   fis_1_start              ;
    wire   [00:0]                   fis_2_start              ;
    wire   [00:0]                   fis_3_start              ;
    wire   [00:0]                   fis_4_start              ;
    wire   [00:0]                   fis_5_start              ;
    wire   [00:0]                   fis_6_start              ;
    wire   [00:0]                   fis_7_start              ;
    wire   [00:0]                   fis_0_done               ;
    wire   [00:0]                   fis_1_done               ;
    wire   [00:0]                   fis_2_done               ;
    wire   [00:0]                   fis_3_done               ;
    wire   [00:0]                   fis_4_done               ;
    wire   [00:0]                   fis_5_done               ;
    wire   [00:0]                   fis_6_done               ;
    wire   [00:0]                   fis_7_done               ;
    wire   [31:0]                   fis_0_return             ;
    wire   [31:0]                   fis_1_return             ;
    wire   [31:0]                   fis_2_return             ;
    wire   [31:0]                   fis_3_return             ;
    wire   [31:0]                   fis_4_return             ;
    wire   [31:0]                   fis_5_return             ;
    wire   [31:0]                   fis_6_return             ;
    wire   [31:0]                   fis_7_return             ;
    //fis debug signals;
    wire   [00:0]                   vio_fis_start            ;
    wire   [00:0]                   vio_fis_rst              ;
    wire   [15:0]                   vio_fis_num              ;
   
    //====================================================================//
    //--------------------------main process------------------------------//
    //====================================================================//
    //IBUFDS_GTE
    IBUFDS_GTE2  refclk_ibufds(.O(pcie_ref_clk), .ODIV2(), .I(pcie_clkp), .CEB(1'b0), .IB(pcie_clkn));
    //usr_synclk

    assign      usr_synclk   = pcie_synclk ;
    //sys_rst_p
    assign      sys_rst_p    = sys_rst_i|pcie_synrst|ddr_soft_rstp ;
    //pcie_wake_n
    assign      pcie_wake_n  = 1'b1 ;
    //ddr_mig_rstn
    assign      ddr_mig_rstn = (~sys_rst_i)&(~ddr_soft_rstp) ;
    //clk_rst
    clk_rst #(
    .SYS_RESET                ( RESET_TIME            )
    )u_clk_rst(
    //system signals
    .sys_clk_in               ( sys_clk_in            ),
    .hard_rst_n               ( 1'b1                  ),
    .usr_synclk               ( usr_synclk            ),
    //user interface
    .logic_100m_clk           ( sys_clk_100m          ),
    .logic_125m_clk           ( sys_clk_125m          ),
    .logic_200m_clk           ( sys_clk_200m          ),
    .ddr_ref_clk              ( ddr_ref_clk           ),
    .ddr_sys_clk              ( ddr_sys_clk           ),
    .clk_spi                  ( clk_spi               ),
    .sys_rst                  ( sys_rst_i             ),
    .sys_led                  (                       )
    );
    //ddr3_cbb
    ddr3_cbb_c1 u_ddr3_cbb(
    .sys_rst_n                ( ddr_mig_rstn          ),
    .clk_200m_ref             ( ddr_ref_clk           ),
    .clk_ddr3_sys             ( ddr_sys_clk           ),
    
    .ddr3_addr                ( c0_ddr3_addr          ),
    .ddr3_ba                  ( c0_ddr3_ba            ),
    .ddr3_cas_n               ( c0_ddr3_cas_n         ),
    .ddr3_ck_n                ( c0_ddr3_ck_n          ),
    .ddr3_ck_p                ( c0_ddr3_ck_p          ),
    .ddr3_cke                 ( c0_ddr3_cke           ),
    .ddr3_ras_n               ( c0_ddr3_ras_n         ),
    .ddr3_reset_n             ( c0_ddr3_reset_n       ),
    .ddr3_we_n                ( c0_ddr3_we_n          ),
    .ddr3_dq                  ( c0_ddr3_dq            ),
    .ddr3_dqs_n               ( c0_ddr3_dqs_n         ),
    .ddr3_dqs_p               ( c0_ddr3_dqs_p         ),
    .ddr3_cs_n                ( c0_ddr3_cs_n          ),
    .ddr3_dm                  ( c0_ddr3_dm            ),
    .ddr3_odt                 ( c0_ddr3_odt           ),

    .user_synclk              ( usr_synclk            ),
    .user_synrst              ( sys_rst_p             ),
    .ddr3_synclk              ( ddr3_synclk           ),
    .ddr3_synrst              ( ddr3_synrst           ),
    .ddr3_fcfifo_wr           ( ddr3_fcfifo_wr        ),
    .ddr3_fcfifo_wdata        ( ddr3_fcfifo_wdata     ),
    .ddr3_fcfifo_afull        ( ddr3_fcfifo_afull     ),
    .ddr3_fxfifo_wr           ( ddr3_fxfifo_wr        ),
    .ddr3_fxfifo_wdata        ( ddr3_fxfifo_wdata     ),
    .ddr3_fxfifo_afull        ( ddr3_fxfifo_afull     ),
    .ddr3_fxfifo_empty        ( ddr3_fxfifo_empty     ),
    .ddr3_tcfifo_wr           ( ddr3_tcfifo_wr        ),
    .ddr3_tcfifo_wdata        ( ddr3_tcfifo_wdata     ),
    .ddr3_tcfifo_afull        ( ddr3_tcfifo_afull     ),
    .ddr3_txfifo_wr           ( ddr3_txfifo_wr        ),
    .ddr3_txfifo_wdata        ( ddr3_txfifo_wdata     ),
    .ddr3_txfifo_afull        ( ddr3_txfifo_afull     ),
    .ddr3_txfifo_empty        ( ddr3_txfifo_empty     ),
    .ddr3_frx_sign            ( ddr3_frx_sign         ),
    .ddr3_rxfifo_wr           ( ddr3_rxfifo_wr        ),
    .ddr3_rxfifo_wdata        ( ddr3_rxfifo_wdata     ),
    .ddr3_rxfifo_afull        ( ddr3_rxfifo_afull     ),
    // cbb status interface
    .ddr3_ready               ( ddr3_ready            ),
    .ddr3_read_done           ( ddr3_read_done        ),
    .device_temp              ( device_temp           )
    );
    //IBUF
    IBUF   sys_reset_n_ibuf(.O(pcie_rst_n_c), .I(pcie_rst_n));
    //pcie_cbb_v7
    pcie_cbb_v7 u_pcie_cbb(
    //User application REG interface signals.
    .pcie_synclk              ( pcie_synclk           ), 
    .pcie_synrst              ( pcie_synrst           ), 
    .localbus_bs              ( localbus_bs           ), 
    .localbus_wr              ( localbus_wr           ), 
    .localbus_rd              ( localbus_rd           ), 
    .localbus_addr            ( localbus_addr         ), 
    .localbus_wdat            ( localbus_wdat         ), 
    .localbus_rdat            ( localbus_rdat         ), 
    .localbus_rvld            ( localbus_rvld         ), 
    //User application DMA interface signals.
    .usr_synclk               ( usr_synclk            ), 
    .usr_synrst               ( pcie_synrst           ), 
    .pcie_tcfifo_wr           ( pcie_tcfifo_wr        ), 
    .pcie_tcfifo_wdata        ( pcie_tcfifo_wdata     ), 
    .pcie_tcfifo_afull        ( pcie_tcfifo_afull     ), 
    .pcie_txfifo_wr           ( pcie_txfifo_wr        ), 
    .pcie_txfifo_wdata        ( pcie_txfifo_wdata     ), 
    .pcie_txfifo_afull        ( pcie_txfifo_afull     ), 
    .pcie_rxfifo_wr           ( pcie_rxfifo_wr        ), 
    .pcie_rxfifo_wdata        ( pcie_rxfifo_wdata     ), 
    .pcie_rxfifo_afull        ( pcie_rxfifo_afull     ), 
    //PCIe fabric interface signals.
    .pcie_ref_clk             ( pcie_ref_clk          ), 
    .pcie_rst_n               ( pcie_rst_n_c          ), 
    .pcie_txp                 ( pcie_txp              ), 
    .pcie_txn                 ( pcie_txn              ), 
    .pcie_rxp                 ( pcie_rxp              ), 
    .pcie_rxn                 ( pcie_rxn              ), 
    //pcie status signals.
    .tlp_op_halt              ( tlp_op_halt           ),
//    .dma_para_mode            ( dma_para_mode         ),
//    .dma_payload_wlen         ( dma_payload_wlen      ),
//    .dma_payload_rlen         ( dma_payload_rlen      ),
    .cfg_negotiated_width     ( cfg_negotiated_width  ),
    .cfg_current_speed        ( cfg_current_speed     ),
    .cfg_max_payload          ( cfg_max_payload       ),
    .cfg_max_read_req         ( cfg_max_read_req      ),
    .user_reset               ( user_reset            ),
    .user_lnk_up              ( user_lnk_up           )
    );
    //frame_demo
    frame_demo #(
    .LOGIC_DATA_TIME          ( LOGIC_DATA_TIME       ),
    .DDR_CLK_FEQCY            ( DDR_CLK_FEQCY         ),
    .FPGA_INFO                ( FPGA_INFO             ),
    .DEEP_VER_INFO            ( DEEP_VER_INFO         ),
    .PCIE_DMA_LEN             ( PCIE_DMA_LEN          )
    )u_frame_demo(                                      
    //pcie localbus interface signals.                  
    .usr_synclk               ( usr_synclk            ),
    .sys_rst_p                ( sys_rst_p             ),
    .pcie_synrst              ( pcie_synrst           ),
    .localbus_bs              ( localbus_bs[0]        ),
    .localbus_wr              ( localbus_wr           ),
    .localbus_rd              ( localbus_rd           ),
    .localbus_addr            ( localbus_addr         ),
    .localbus_wdat            ( localbus_wdat         ),
    .localbus_rdat            ( localbus_rdat0        ),
    .localbus_rvld            ( localbus_rvld0        ),
    //ddr cbb interface signals.
    .ddr3_tcfifo_wr           ( ddr3_0_tcfifo_wr      ),
    .ddr3_tcfifo_wdata        ( ddr3_0_tcfifo_wdata   ),
    .ddr3_tcfifo_afull        ( ddr3_tcfifo_afull     ),
    .ddr3_txfifo_wr           ( ddr3_0_txfifo_wr      ),
    .ddr3_txfifo_wdata        ( ddr3_0_txfifo_wdata   ),
    .ddr3_txfifo_empty        ( ddr3_txfifo_empty     ),
    .ddr3_txfifo_afull        ( ddr3_txfifo_afull     ),
    .ddr3_rxfifo_wr           ( ddr3_rxfifo_wr&(~ddr3_frx_sign)),
    .ddr3_rxfifo_wdata        ( ddr3_rxfifo_wdata     ),
    .ddr3_rxfifo_afull        ( ddr3_0_rxfifo_afull   ),
    //pcie cbb interface signals.
    .pcie_tcfifo_wr           ( pcie_0_tcfifo_wr      ),
    .pcie_tcfifo_wdata        ( pcie_0_tcfifo_wdata   ),
    .pcie_tcfifo_afull        ( pcie_tcfifo_afull     ),
    .pcie_txfifo_wr           ( pcie_0_txfifo_wr      ),
    .pcie_txfifo_wdata        ( pcie_0_txfifo_wdata   ),
    .pcie_txfifo_afull        ( pcie_txfifo_afull     ),
    .pcie_rxfifo_wr           ( pcie_rxfifo_wr        ),
    .pcie_rxfifo_wdata        ( pcie_rxfifo_wdata     ),
    .pcie_rxfifo_afull        ( pcie_0_rxfifo_afull   ),
    //status signals.
    .bus_num                  ( bus_num               ),
    .tlp_op_halt              ( tlp_op_halt           ),
    .dma_para_mode            ( dma_para_mode         ),
    .dma_payload_wlen         ( dma_payload_wlen      ),
    .dma_payload_rlen         ( dma_payload_rlen      ),
    .ddr_soft_rstp            ( ddr_soft_rstp         ),
    .ddr3_ready               ( ddr3_ready            ),
    .cfg_negotiated_width     ( cfg_negotiated_width  ),
    .cfg_current_speed        ( cfg_current_speed     ),
    .cfg_max_payload          ( cfg_max_payload       ),
    .cfg_max_read_req         ( cfg_max_read_req      ),
    .ecl_info                 ( 13'h0001              ),
    .vol_info                 ( 13'h0002              )
    );
    //user_demo
    user_demo#(
    .PCIE_DMA_LEN             ( PCIE_DMA_LEN          )
    )u_user_demo(
    //pcie localbus interface signals.
    .usr_synclk               ( usr_synclk            ),
    .sys_rst_p                ( sys_rst_p             ),
    .pcie_synrst              ( pcie_synrst           ),
    .localbus_bs              ( localbus_bs[0]        ),
    .localbus_wr              ( localbus_wr           ),
    .localbus_rd              ( localbus_rd           ),
    .localbus_addr            ( localbus_addr         ),
    .localbus_wdat            ( localbus_wdat         ),
    .localbus_rdat            ( localbus_rdat1        ),
    .localbus_rvld            ( localbus_rvld1        ),
    //ddr cbb interface signals.
    .ddr3_tcfifo_wr           ( ddr3_1_tcfifo_wr      ),
    .ddr3_tcfifo_wdata        ( ddr3_1_tcfifo_wdata   ),
    .ddr3_tcfifo_afull        ( ddr3_tcfifo_afull     ),
    .ddr3_txfifo_wr           ( ddr3_1_txfifo_wr      ),
    .ddr3_txfifo_wdata        ( ddr3_1_txfifo_wdata   ),
    .ddr3_txfifo_afull        ( ddr3_txfifo_afull     ),
    .ddr3_rxfifo_wr           ( ddr3_rxfifo_wr&(~ddr3_frx_sign)),
    .ddr3_rxfifo_wdata        ( ddr3_rxfifo_wdata     ),
    .ddr3_rxfifo_afull        ( ddr3_1_rxfifo_afull   ),
    //pcie cbb interface signals.
    .pcie_tcfifo_wr           ( pcie_1_tcfifo_wr      ),
    .pcie_tcfifo_wdata        ( pcie_1_tcfifo_wdata   ),
    .pcie_tcfifo_afull        ( pcie_tcfifo_afull     ),
    .pcie_txfifo_wr           ( pcie_1_txfifo_wr      ),
    .pcie_txfifo_wdata        ( pcie_1_txfifo_wdata   ),
    .pcie_txfifo_afull        ( pcie_txfifo_afull     ),
    .pcie_rxfifo_wr           ( pcie_rxfifo_wr        ),
    .pcie_rxfifo_wdata        ( pcie_rxfifo_wdata     ),
    .pcie_rxfifo_afull        ( pcie_1_rxfifo_afull   )
    );
    //flash_load
    flash_load flash_load(
    .clk_spi                  ( clk_spi               ),
    .rst_spi                  ( sys_rst_p             ),
    .clk_sys                  ( usr_synclk            ),
    .rst_sys                  ( sys_rst_p             ),
    .spi_sel_n                ( spi_sel_n             ),
    .spi_dqo                  ( spi_dqo               ),
    .spi_dqi                  ( spi_dqi               ),
    .spi_hold_n               ( spi_hold_n            ),
    .spi_wrn_vpp              ( spi_wrn_vpp           ),
    .spi_tcfifo_wr            ( spi_tcfifo_wr         ),
    .spi_tcfifo_wdata         ( spi_tcfifo_wdata      ),
    .spi_tcfifo_afull         ( spi_tcfifo_afull      ),
    .spi_txfifo_wr            ( spi_txfifo_wr         ),
    .spi_txfifo_wdata         ( spi_txfifo_wdata      ),
    .spi_txfifo_afull         ( spi_txfifo_afull      ),
    .spi_rxfifo_wr            ( spi_rxfifo_wr         ),
    .spi_rxfifo_wdata         ( spi_rxfifo_wdata      ),
    .spi_rxfifo_afull         ( spi_rxfifo_afull      ),
    .vio_flash_4B             ( 1'b0                  ),
    .spi_sta_vld              ( spi_sta_vld           ),
    .spi_sta_dat              ( spi_sta_dat           ),
    .spi_era_busy             ( spi_era_busy          ),
    .spi_wr_busy              ( spi_wr_busy           ),
    .spi_rd_busy              ( spi_rd_busy           )
    );
    //pcie2flash
    pcie2flash u_pcie2flash(
    .usr_synclk               ( usr_synclk            ),
    .sys_rst_p                ( sys_rst_p             ),  
    .localbus_bs              ( localbus_bs[0]        ),
    .localbus_wr              ( localbus_wr           ),
    .localbus_rd              ( localbus_rd           ),
    .localbus_addr            ( localbus_addr         ),
    .localbus_wdat            ( localbus_wdat         ),
    .localbus_rdat            ( localbus_rdat2        ),
    .localbus_rvld            ( localbus_rvld2        ),
    .spi_tcfifo_wr            ( spi_tcfifo_wr         ),
    .spi_tcfifo_wdata         ( spi_tcfifo_wdata      ),
    .spi_tcfifo_afull         ( spi_tcfifo_afull      ),
    .spi_txfifo_wr            ( spi_txfifo_wr         ),
    .spi_txfifo_wdata         ( spi_txfifo_wdata      ),
    .spi_txfifo_afull         ( spi_txfifo_afull      ),
    .spi_rxfifo_wr            ( spi_rxfifo_wr         ),
    .spi_rxfifo_wdata         ( spi_rxfifo_wdata      ),
    .spi_rxfifo_afull         ( spi_rxfifo_afull      ),
    .spi_sta_vld              ( spi_sta_vld           ),
    .spi_sta_dat              ( spi_sta_dat           ),
    .spi_era_busy             ( spi_era_busy          ),
    .spi_wr_busy              ( spi_wr_busy           ),
    .spi_rd_busy              ( spi_rd_busy           )
    );
    //localbus_rdhalt/localbus_rvldt/localbus_rdatt
    always @ (posedge usr_synclk or posedge pcie_synrst)
    begin
        if(pcie_synrst==1'b1)
        begin
            localbus_rdhalt <= 16'b0 ;
            localbus_rvldt <= 1'b0 ;
            localbus_rdatt <= 64'b0 ;
        end
        else
        begin
            if(localbus_rvld0==1'b1 || localbus_rvld1==1'b1 || localbus_rvld2==1'b1 || localbus_rvld3==1'b1)
            begin
                localbus_rdhalt <= 16'b0 ;
                localbus_rvldt <= 1'b0 ;
                localbus_rdatt <= 64'b0 ;
            end
            else if(localbus_rd==1'b1)
            begin
                localbus_rdhalt <= localbus_rdhalt + 16'h1 ;
                if(localbus_rdhalt>16'h100)
                begin
                    localbus_rvldt <= 1'b1 ;
                    localbus_rdatt <= 64'h0123_4567_1234_5678 ;
                end
                else
                begin
                    localbus_rvldt <= 1'b0 ;
                    localbus_rdatt <= 64'b0 ;
                end
            end
            else
            begin
                localbus_rdhalt <= 16'b0 ;
                localbus_rvldt <= 1'b0 ;
                localbus_rdatt <= 64'b0 ;
            end
        end
    end
    //localbus_rvld/localbus_rdat
    assign      localbus_rvld = localbus_rvld0 | localbus_rvld1 | localbus_rvld2 | localbus_rvld3 | localbus_rvldt;
    assign      localbus_rdat = (localbus_rvld0==1'b1)? localbus_rdat0 : ((localbus_rvld1==1'b1)? localbus_rdat1:((localbus_rvld2==1'b1)? localbus_rdat2:((localbus_rvld3==1'b1)?localbus_rdat3:localbus_rdatt)));
    //====================================================================//
    //--------------------pcie frame/user logic together------------------//
    //====================================================================//
    //ddr3_rxfifo_afull
    assign      ddr3_rxfifo_afull = ddr3_0_rxfifo_afull | ddr3_1_rxfifo_afull | ddr3_2_rxfifo_afull ;
    //pcie_rxfifo_afull
    assign      pcie_rxfifo_afull = pcie_0_rxfifo_afull | pcie_1_rxfifo_afull ;
    //pcie_tcfifo_wr/pcie_tcfifo_wdata
    assign      pcie_tcfifo_wr = pcie_0_tcfifo_wr | pcie_1_tcfifo_wr ;
    assign      pcie_tcfifo_wdata = (pcie_0_tcfifo_wr==1'b1)? pcie_0_tcfifo_wdata : pcie_1_tcfifo_wdata ;
    //pcie_txfifo_wr/pcie_txfifo_wdata
    assign      pcie_txfifo_wr = pcie_0_txfifo_wr | pcie_1_txfifo_wr ;
    assign      pcie_txfifo_wdata = (pcie_0_txfifo_wr==1'b1)? pcie_0_txfifo_wdata : pcie_1_txfifo_wdata ;
    //ddr3_tcfifo_wr/ddr3_tcfifo_wdata
    assign      ddr3_tcfifo_wr = ddr3_0_tcfifo_wr | ddr3_1_tcfifo_wr ;
    assign      ddr3_tcfifo_wdata = (ddr3_0_tcfifo_wr==1'b1)? ddr3_0_tcfifo_wdata : ddr3_1_tcfifo_wdata ;
    //ddr3_txfifo_wr/ddr3_txfifo_wdata
    assign      ddr3_txfifo_wr = ddr3_0_txfifo_wr | ddr3_1_txfifo_wr ;
    assign      ddr3_txfifo_wdata = (ddr3_0_txfifo_wr==1'b1)? ddr3_0_txfifo_wdata : ddr3_1_txfifo_wdata ;
    //====================================================================//
    //------------------------------user logic here-----------------------//
    //====================================================================//
    fis_reg #(
    .FIS_UNIT_NUM             ( FIS_UNIT_NUM          ),
    .FIS_RST_ADDR             ( FIS_RST_ADDR          ),
    .FIS_START_ADDR           ( FIS_START_ADDR        ),
    .MIG_RST_ADDR             ( MIG_RST_ADDR          ),
    .FIS_NUM_ADDR             ( FIS_NUM_ADDR          ),
    .FIS_DONE_ADDR            ( FIS_DONE_ADDR         ),
    
    .FIS_0_NUM_ADDR           ( FIS_0_NUM_ADDR        ),
    .FIS_1_NUM_ADDR           ( FIS_1_NUM_ADDR        ),
    .FIS_2_NUM_ADDR           ( FIS_2_NUM_ADDR        ),
    .FIS_3_NUM_ADDR           ( FIS_3_NUM_ADDR        ),
    .FIS_4_NUM_ADDR           ( FIS_4_NUM_ADDR        ),
    .FIS_5_NUM_ADDR           ( FIS_5_NUM_ADDR        ),
    .FIS_6_NUM_ADDR           ( FIS_6_NUM_ADDR        ),
    .FIS_7_NUM_ADDR           ( FIS_7_NUM_ADDR        ),
    .FIS_0_START_ADDR         ( FIS_0_START_ADDR      ),
    .FIS_1_START_ADDR         ( FIS_1_START_ADDR      ),
    .FIS_2_START_ADDR         ( FIS_2_START_ADDR      ),
    .FIS_3_START_ADDR         ( FIS_3_START_ADDR      ),
    .FIS_4_START_ADDR         ( FIS_4_START_ADDR      ),
    .FIS_5_START_ADDR         ( FIS_5_START_ADDR      ),
    .FIS_6_START_ADDR         ( FIS_6_START_ADDR      ),
    .FIS_7_START_ADDR         ( FIS_7_START_ADDR      ),
    .FIS_0_DONE_ADDR          ( FIS_0_DONE_ADDR       ),
    .FIS_1_DONE_ADDR          ( FIS_1_DONE_ADDR       ),
    .FIS_2_DONE_ADDR          ( FIS_2_DONE_ADDR       ),
    .FIS_3_DONE_ADDR          ( FIS_3_DONE_ADDR       ),
    .FIS_4_DONE_ADDR          ( FIS_4_DONE_ADDR       ),
    .FIS_5_DONE_ADDR          ( FIS_5_DONE_ADDR       ),
    .FIS_6_DONE_ADDR          ( FIS_6_DONE_ADDR       ),
    .FIS_7_DONE_ADDR          ( FIS_7_DONE_ADDR       ),
    .FIS_0_RESULT_ADDR        ( FIS_0_RESULT_ADDR     ),
    .FIS_1_RESULT_ADDR        ( FIS_1_RESULT_ADDR     ),
    .FIS_2_RESULT_ADDR        ( FIS_2_RESULT_ADDR     ),
    .FIS_3_RESULT_ADDR        ( FIS_3_RESULT_ADDR     ),
    .FIS_4_RESULT_ADDR        ( FIS_4_RESULT_ADDR     ),
    .FIS_5_RESULT_ADDR        ( FIS_5_RESULT_ADDR     ),
    .FIS_6_RESULT_ADDR        ( FIS_6_RESULT_ADDR     ),
    .FIS_7_RESULT_ADDR        ( FIS_7_RESULT_ADDR     )
    )u_fis_reg(
    .usr_synclk               ( usr_synclk            ),
    .pcie_synrst              ( pcie_synrst           ),
    .localbus_bs              ( localbus_bs[0]        ),
    .localbus_wr              ( localbus_wr           ),
    .localbus_rd              ( localbus_rd           ),
    .localbus_addr            ( localbus_addr         ),
    .localbus_wdat            ( localbus_wdat         ),
    .localbus_rdat            ( localbus_rdat3        ),
    .localbus_rvld            ( localbus_rvld3        ),
    .pc_fis_rst               ( pc_fis_rst            ),
    .pc_fis_start             ( pc_fis_start          ),
    .pc_fis_done              ( pc_fis_done           ),
    .pc_mig_rst               ( pc_mig_rst            ),
    
    .fis_start                ( fis_start             ),
    .fis_para_set             ( fis_para_set          ),
    .fis_0_num                ( fis_0_num             ),
    .fis_1_num                ( fis_1_num             ),
    .fis_2_num                ( fis_2_num             ),
    .fis_3_num                ( fis_3_num             ),
    .fis_4_num                ( fis_4_num             ),
    .fis_5_num                ( fis_5_num             ),
    .fis_6_num                ( fis_6_num             ),
    .fis_7_num                ( fis_7_num             ),
    .fis_0_start              ( fis_0_start           ),
    .fis_1_start              ( fis_1_start           ),
    .fis_2_start              ( fis_2_start           ),
    .fis_3_start              ( fis_3_start           ),
    .fis_4_start              ( fis_4_start           ),
    .fis_5_start              ( fis_5_start           ),
    .fis_6_start              ( fis_6_start           ),
    .fis_7_start              ( fis_7_start           ),
    .fis_0_done               ( fis_0_done            ),
    .fis_1_done               ( fis_1_done            ),
    .fis_2_done               ( fis_2_done            ),
    .fis_3_done               ( fis_3_done            ),
    .fis_4_done               ( fis_4_done            ),
    .fis_5_done               ( fis_5_done            ),
    .fis_6_done               ( fis_6_done            ),
    .fis_7_done               ( fis_7_done            ),
    .fis_0_return             ( fis_0_return          ),
    .fis_1_return             ( fis_1_return          ),
    .fis_2_return             ( fis_2_return          ),
    .fis_3_return             ( fis_3_return          ),
    .fis_4_return             ( fis_4_return          ),
    .fis_5_return             ( fis_5_return          ),
    .fis_6_return             ( fis_6_return          ),
    .fis_7_return             ( fis_7_return          )
    );
    //fis_top
    fis_top #(
    .CMD_SADDR                ( CMD_SADDR             ),
    .CMD_RLEN                 ( CMD_RLEN              ),
    .FIS_STEP_ADDRESS         ( FIS_STEP_ADDRESS      ),
    .FIS_UNIT_NUM             ( FIS_UNIT_NUM          ),   
    
    .FIS_0_IDAT_0_ADDR        ( FIS_0_IDAT_0_ADDR     ),
    .FIS_0_IDAT_1_ADDR        ( FIS_0_IDAT_1_ADDR     ),
    .FIS_0_IDAT_2_ADDR        ( FIS_0_IDAT_2_ADDR     ),
    .FIS_1_IDAT_0_ADDR        ( FIS_1_IDAT_0_ADDR     ),
    .FIS_1_IDAT_1_ADDR        ( FIS_1_IDAT_1_ADDR     ),
    .FIS_1_IDAT_2_ADDR        ( FIS_1_IDAT_2_ADDR     ),
    .FIS_2_IDAT_0_ADDR        ( FIS_2_IDAT_0_ADDR     ),
    .FIS_2_IDAT_1_ADDR        ( FIS_2_IDAT_1_ADDR     ),
    .FIS_2_IDAT_2_ADDR        ( FIS_2_IDAT_2_ADDR     ),
    .FIS_3_IDAT_0_ADDR        ( FIS_3_IDAT_0_ADDR     ),
    .FIS_3_IDAT_1_ADDR        ( FIS_3_IDAT_1_ADDR     ),
    .FIS_3_IDAT_2_ADDR        ( FIS_3_IDAT_2_ADDR     ),
    .FIS_4_IDAT_0_ADDR        ( FIS_4_IDAT_0_ADDR     ),
    .FIS_4_IDAT_1_ADDR        ( FIS_4_IDAT_1_ADDR     ),
    .FIS_4_IDAT_2_ADDR        ( FIS_4_IDAT_2_ADDR     ),
    .FIS_5_IDAT_0_ADDR        ( FIS_5_IDAT_0_ADDR     ),
    .FIS_5_IDAT_1_ADDR        ( FIS_5_IDAT_1_ADDR     ),
    .FIS_5_IDAT_2_ADDR        ( FIS_5_IDAT_2_ADDR     ),
    .FIS_6_IDAT_0_ADDR        ( FIS_6_IDAT_0_ADDR     ),
    .FIS_6_IDAT_1_ADDR        ( FIS_6_IDAT_1_ADDR     ),
    .FIS_6_IDAT_2_ADDR        ( FIS_6_IDAT_2_ADDR     ),
    .FIS_7_IDAT_0_ADDR        ( FIS_7_IDAT_0_ADDR     ),
    .FIS_7_IDAT_1_ADDR        ( FIS_7_IDAT_1_ADDR     ),
    .FIS_7_IDAT_2_ADDR        ( FIS_7_IDAT_2_ADDR     )
    )u_fis_top(
    //clock and reset signals.
    .usr_synclk               ( usr_synclk            ),
    .sys_rst_p                ( sys_rst_p             ),
    //interface with user_demo module signals.
    .ddr3_fcfifo_wr           ( ddr3_fcfifo_wr        ),
    .ddr3_fcfifo_wdata        ( ddr3_fcfifo_wdata     ),
    .ddr3_fcfifo_afull        ( ddr3_fcfifo_afull     ),
    .ddr3_fxfifo_wr           ( ddr3_fxfifo_wr        ),
    .ddr3_fxfifo_wdata        ( ddr3_fxfifo_wdata     ),
    .ddr3_fxfifo_afull        ( ddr3_fxfifo_afull     ),
    .ddr3_frx_sign            ( ddr3_frx_sign         ),
    .ddr3_rxfifo_wr           ( ddr3_rxfifo_wr        ),
    .ddr3_rxfifo_wdata        ( ddr3_rxfifo_wdata     ),
    .ddr3_rxfifo_afull        ( ddr3_2_rxfifo_afull   ),
    //user register signals.
    .localbus_bs              ( localbus_bs[0]        ),
    .localbus_wr              ( localbus_wr           ),
    .localbus_addr            ( localbus_addr         ),
    .localbus_wdat            ( localbus_wdat         ),
    .pc_fis_rst               ( pc_fis_rst            ),
    .pc_fis_start             ( pc_fis_start          ),
    .pc_mig_rst               ( pc_mig_rst            ),
    .pc_fis_done              ( pc_fis_done           ),
    
    .fis_start                ( fis_start             ),
    .fis_para_set             ( fis_para_set          ),
    .fis_0_num                ( fis_0_num             ),
    .fis_1_num                ( fis_1_num             ),
    .fis_2_num                ( fis_2_num             ),
    .fis_3_num                ( fis_3_num             ),
    .fis_4_num                ( fis_4_num             ),
    .fis_5_num                ( fis_5_num             ),
    .fis_6_num                ( fis_6_num             ),
    .fis_7_num                ( fis_7_num             ),
    .fis_0_start              ( fis_0_start           ),
    .fis_1_start              ( fis_1_start           ),
    .fis_2_start              ( fis_2_start           ),
    .fis_3_start              ( fis_3_start           ),
    .fis_4_start              ( fis_4_start           ),
    .fis_5_start              ( fis_5_start           ),
    .fis_6_start              ( fis_6_start           ),
    .fis_7_start              ( fis_7_start           ),
    .fis_0_done               ( fis_0_done            ),
    .fis_1_done               ( fis_1_done            ),
    .fis_2_done               ( fis_2_done            ),
    .fis_3_done               ( fis_3_done            ),
    .fis_4_done               ( fis_4_done            ),
    .fis_5_done               ( fis_5_done            ),
    .fis_6_done               ( fis_6_done            ),
    .fis_7_done               ( fis_7_done            ),
    .fis_0_return             ( fis_0_return          ),
    .fis_1_return             ( fis_1_return          ),
    .fis_2_return             ( fis_2_return          ),
    .fis_3_return             ( fis_3_return          ),
    .fis_4_return             ( fis_4_return          ),
    .fis_5_return             ( fis_5_return          ),
    .fis_6_return             ( fis_6_return          ),
    .fis_7_return             ( fis_7_return          ),
    //user debug signals.
    .vio_fis_rst              ( vio_fis_rst           ),
    .vio_fis_start            ( vio_fis_start         ),
    .vio_fis_num              ( vio_fis_num           ) 
    );
    //====================================================================//
    //-------------------------------  end  ------------------------------//
    //====================================================================//

endmodule
