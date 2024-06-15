
`timescale 1ns / 1ps

module fis_top(
    //clock and reset
    usr_synclk          ,
    sys_rst_p           ,
    
    ddr3_fcfifo_wr      ,
    ddr3_fcfifo_wdata   ,
    ddr3_fcfifo_afull   ,
    ddr3_fxfifo_wr      ,
    ddr3_fxfifo_wdata   ,
    ddr3_fxfifo_afull   ,
    ddr3_frx_sign       ,
    ddr3_rxfifo_wr      ,
    ddr3_rxfifo_wdata   ,
    ddr3_rxfifo_afull   ,
    
    localbus_bs         ,
    localbus_wr         ,
    localbus_addr       ,
    localbus_wdat       ,
    pc_fis_rst          ,
    pc_fis_start        ,
    pc_mig_rst          ,
    pc_fis_done         ,
    
    fis_start           ,
    fis_para_set        ,
    fis_0_num           ,
    fis_1_num           ,
    fis_2_num           ,
    fis_3_num           ,
    fis_4_num           ,
    fis_5_num           ,
    fis_6_num           ,
    fis_7_num           ,
    fis_8_num           ,
    fis_9_num           ,
    fis_0_start         ,
    fis_1_start         ,
    fis_2_start         ,
    fis_3_start         ,
    fis_4_start         ,
    fis_5_start         ,
    fis_6_start         ,
    fis_7_start         ,
    fis_8_start         ,
    fis_9_start         ,
    fis_0_return        ,
    fis_1_return        ,
    fis_2_return        ,
    fis_3_return        ,
    fis_4_return        ,
    fis_5_return        ,
    fis_6_return        ,
    fis_7_return        ,
    fis_8_return        ,
    fis_9_return        ,
    fis_0_done          ,
    fis_1_done          ,
    fis_2_done          ,
    fis_3_done          ,
    fis_4_done          ,
    fis_5_done          ,
    fis_6_done          ,
    fis_7_done          ,
    fis_8_done          ,
    fis_9_done          ,
    
    vio_fis_rst         ,
    vio_fis_start       ,
    vio_fis_num         
    );
    //parameter defination.
    parameter       CMD_SADDR        = 32'h0000_0000  ;
    parameter       CMD_RLEN         = 32'h0000_0010  ;
    parameter       FIS_STEP_ADDRESS = 32'h40_0000    ;
    parameter       FIS_UNIT_NUM     = 10             ;
    
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
    parameter       FIS_8_IDAT_0_ADDR  = 24'h22e0     ;
    parameter       FIS_8_IDAT_1_ADDR  = 24'h22e4     ;  
    parameter       FIS_8_IDAT_2_ADDR  = 24'h22e8     ; 
    parameter       FIS_9_IDAT_0_ADDR  = 24'h22f0     ; 
    parameter       FIS_9_IDAT_1_ADDR  = 24'h22f4     ;   
    parameter       FIS_9_IDAT_2_ADDR  = 24'h22f8     ;  
    //-------------------------------------------------------------------
    // Defination of Ports
    //-------------------------------------------------------------------
    ////clock and reset
    input  wire  [00:0]       usr_synclk            ;
    input  wire  [00:0]       sys_rst_p             ;
    
    output wire  [00:0]       ddr3_fcfifo_wr        ;
    output wire  [79:0]       ddr3_fcfifo_wdata     ;
    input  wire  [00:0]       ddr3_fcfifo_afull     ;
    output wire  [00:0]       ddr3_fxfifo_wr        ;
    output wire  [511:0]      ddr3_fxfifo_wdata     ;
    input  wire  [00:0]       ddr3_fxfifo_afull     ;
    input  wire  [00:0]       ddr3_frx_sign         ;
    input  wire  [00:0]       ddr3_rxfifo_wr        ;
    input  wire  [511:0]      ddr3_rxfifo_wdata     ;
    output wire  [00:0]       ddr3_rxfifo_afull     ;
    
    input  wire  [00:0]       localbus_bs           ;
    input  wire  [00:0]       localbus_wr           ;
    input  wire  [23:0]       localbus_addr         ;
    input  wire  [63:0]       localbus_wdat         ;
    input  wire  [00:0]       pc_fis_rst            ;
    input  wire  [00:0]       pc_fis_start          ;
    input  wire  [00:0]       pc_mig_rst            ;
    output wire  [00:0]       pc_fis_done           ;
    
    output wire  [00:0]       fis_start             ;
    output wire  [FIS_UNIT_NUM-1:0]  fis_para_set   ;
    input  wire  [05:0]       fis_0_num             ;
    input  wire  [05:0]       fis_1_num             ;
    input  wire  [05:0]       fis_2_num             ;
    input  wire  [05:0]       fis_3_num             ;
    input  wire  [05:0]       fis_4_num             ;
    input  wire  [05:0]       fis_5_num             ;
    input  wire  [05:0]       fis_6_num             ;
    input  wire  [05:0]       fis_7_num             ;
    input  wire  [05:0]       fis_8_num             ;
    input  wire  [05:0]       fis_9_num             ;
    input  wire  [00:0]       fis_0_start           ;
    input  wire  [00:0]       fis_1_start           ;
    input  wire  [00:0]       fis_2_start           ;
    input  wire  [00:0]       fis_3_start           ;
    input  wire  [00:0]       fis_4_start           ;
    input  wire  [00:0]       fis_5_start           ;
    input  wire  [00:0]       fis_6_start           ;
    input  wire  [00:0]       fis_7_start           ;
    input  wire  [00:0]       fis_8_start           ;
    input  wire  [00:0]       fis_9_start           ;
    output wire  [00:0]       fis_0_done            ;
    output wire  [00:0]       fis_1_done            ;
    output wire  [00:0]       fis_2_done            ;
    output wire  [00:0]       fis_3_done            ;
    output wire  [00:0]       fis_4_done            ;
    output wire  [00:0]       fis_5_done            ;
    output wire  [00:0]       fis_6_done            ;
    output wire  [00:0]       fis_7_done            ;
    output wire  [00:0]       fis_8_done            ;
    output wire  [00:0]       fis_9_done            ;
    output wire  [31:0]       fis_0_return          ;
    output wire  [31:0]       fis_1_return          ;
    output wire  [31:0]       fis_2_return          ;
    output wire  [31:0]       fis_3_return          ;
    output wire  [31:0]       fis_4_return          ;
    output wire  [31:0]       fis_5_return          ;
    output wire  [31:0]       fis_6_return          ;
    output wire  [31:0]       fis_7_return          ;
    output wire  [31:0]       fis_8_return          ;
    output wire  [31:0]       fis_9_return          ;
    //user debug signals;
    input  wire  [00:0]       vio_fis_rst           ;
    input  wire  [00:0]       vio_fis_start         ;
    input  wire  [15:0]       vio_fis_num           ;
    //====================================================================//
    //----------------------internal signals------------------------------//
    //====================================================================//
    wire  [127:0]        fis_dim                    ;
    wire  [04:0]         output_num                 ;
    wire  [00:0]         inmf_ena                   ;
    wire  [07:0]         inmf_addra                 ;
    wire  [31:0]         inmf_dina                  ;
    wire  [00:0]         outmf_ena                  ;
    wire  [04:0]         outmf_addra                ;
    wire  [31:0]         outmf_dina                 ;
    wire  [00:0]         rule_ena                   ;
    wire  [28:0]         rule_addra                 ;
    wire  [31:0]         rule_dina                  ;
    wire  [00:0]         in_data_ena                ;
    wire  [01:0]         in_data_addra              ;
    wire  [31:0]         in_data_dina               ;

    wire  [FIS_UNIT_NUM-1:0]     fis_unit_done      ;
    wire  [FIS_UNIT_NUM*32-1:0]  fis_unit_return    ;
    wire  [FIS_UNIT_NUM-1:0]     pc_reg_start       ;

    
    //====================================================================//
    //--------------------------main process------------------------------//
    //====================================================================//
    assign      pc_reg_start = {fis_9_start,fis_8_start,fis_7_start,fis_6_start,fis_5_start,fis_4_start,fis_3_start,fis_2_start,fis_1_start,fis_0_start} ;
    //fis_usr
    fis_usr #(
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
    .FIS_7_IDAT_2_ADDR        ( FIS_7_IDAT_2_ADDR     ),
    .FIS_8_IDAT_0_ADDR        ( FIS_8_IDAT_0_ADDR     ),
    .FIS_8_IDAT_1_ADDR        ( FIS_8_IDAT_1_ADDR     ),
    .FIS_8_IDAT_2_ADDR        ( FIS_8_IDAT_2_ADDR     ),
    .FIS_9_IDAT_0_ADDR        ( FIS_9_IDAT_0_ADDR     ),
    .FIS_9_IDAT_1_ADDR        ( FIS_9_IDAT_1_ADDR     ),
    .FIS_9_IDAT_2_ADDR        ( FIS_9_IDAT_2_ADDR     )
    )fis_usr(                                         
    .usr_synclk               ( usr_synclk            ),
    .sys_rst_p                ( sys_rst_p             ),
    .ddr3_fcfifo_wr           ( ddr3_fcfifo_wr        ),
    .ddr3_fcfifo_wdata        ( ddr3_fcfifo_wdata     ),
    .ddr3_fcfifo_afull        ( ddr3_fcfifo_afull     ),
    .ddr3_fxfifo_wr           ( ddr3_fxfifo_wr        ),
    .ddr3_fxfifo_wdata        ( ddr3_fxfifo_wdata     ),
    .ddr3_fxfifo_afull        ( ddr3_fxfifo_afull     ),
    .ddr3_frx_sign            ( ddr3_frx_sign         ),
    .ddr3_rxfifo_wr           ( ddr3_rxfifo_wr        ),
    .ddr3_rxfifo_wdata        ( ddr3_rxfifo_wdata     ),
    .ddr3_rxfifo_afull        ( ddr3_rxfifo_afull     ),
    .fis_para_set             ( fis_para_set          ),
    .inmf_ena                 ( inmf_ena              ),
    .inmf_addra               ( inmf_addra            ),
    .inmf_dina                ( inmf_dina             ),
    .outmf_ena                ( outmf_ena             ),
    .outmf_addra              ( outmf_addra           ),
    .outmf_dina               ( outmf_dina            ),
    .rule_ena                 ( rule_ena              ),
    .rule_addra               ( rule_addra            ),
    .rule_dina                ( rule_dina             ),
    .in_data_ena              ( in_data_ena           ),
    .in_data_addra            ( in_data_addra         ),
    .in_data_dina             ( in_data_dina          ),
    .fis_dim                  ( fis_dim               ),
    .output_num               ( output_num            ),
    .fis_start                ( fis_start             ),
    
    .localbus_bs              ( localbus_bs           ),
    .localbus_wr              ( localbus_wr           ),
    .localbus_addr            ( localbus_addr         ),
    .localbus_wdat            ( localbus_wdat         ),
    .pc_fis_rst               ( pc_fis_rst            ),
    .pc_fis_start             ( pc_fis_start          ),
    .pc_mig_rst               ( pc_mig_rst            ),
    .fis_unit_done            ( fis_unit_done         ),
    .fis_unit_return          ( fis_unit_return       ),
    .pc_fis_done              ( pc_fis_done           ),
    
    .fis_0_num                ( fis_0_num             ),
    .fis_1_num                ( fis_1_num             ),
    .fis_2_num                ( fis_2_num             ),
    .fis_3_num                ( fis_3_num             ),
    .fis_4_num                ( fis_4_num             ),
    .fis_5_num                ( fis_5_num             ),
    .fis_6_num                ( fis_6_num             ),
    .fis_7_num                ( fis_7_num             ),
    .fis_8_num                ( fis_8_num             ),
    .fis_9_num                ( fis_9_num             ),
    .fis_0_start              ( fis_0_start           ),
    .fis_1_start              ( fis_1_start           ),
    .fis_2_start              ( fis_2_start           ),
    .fis_3_start              ( fis_3_start           ),
    .fis_4_start              ( fis_4_start           ),
    .fis_5_start              ( fis_5_start           ),
    .fis_6_start              ( fis_6_start           ),
    .fis_7_start              ( fis_7_start           ),
    .fis_8_start              ( fis_8_start           ),
    .fis_9_start              ( fis_9_start           ),
    .fis_0_done               ( fis_0_done            ),
    .fis_1_done               ( fis_1_done            ),
    .fis_2_done               ( fis_2_done            ),
    .fis_3_done               ( fis_3_done            ),
    .fis_4_done               ( fis_4_done            ),
    .fis_5_done               ( fis_5_done            ),
    .fis_6_done               ( fis_6_done            ),
    .fis_7_done               ( fis_7_done            ),
    .fis_8_done               ( fis_8_done            ),
    .fis_9_done               ( fis_9_done            ),
    .fis_0_return             ( fis_0_return          ),
    .fis_1_return             ( fis_1_return          ),
    .fis_2_return             ( fis_2_return          ),
    .fis_3_return             ( fis_3_return          ),
    .fis_4_return             ( fis_4_return          ),
    .fis_5_return             ( fis_5_return          ),
    .fis_6_return             ( fis_6_return          ),
    .fis_7_return             ( fis_7_return          ),
    .fis_8_return             ( fis_8_return          ),
    .fis_9_return             ( fis_9_return          )
    );
    //u_even_data
    genvar i;
    generate
        for(i=0;i<FIS_UNIT_NUM;i=i+1)
        begin:fis_unit_loop
            fis_unit u_fis_unit(
            .usr_synclk       ( usr_synclk           ),
            .sys_rst_p        ( sys_rst_p            ),
            .inmf_ena         ( inmf_ena&fis_para_set[i]),
            .inmf_addra       ( inmf_addra           ),
            .inmf_dina        ( inmf_dina            ),
            .outmf_ena        ( outmf_ena&fis_para_set[i] ),
            .outmf_addra      ( outmf_addra          ),
            .outmf_dina       ( outmf_dina           ),
            .rule_ena         ( rule_ena&fis_para_set[i]),
            .rule_addra       ( rule_addra           ),
            .rule_dina        ( rule_dina            ),
            .in_data_ena      ( in_data_ena&fis_para_set[i]),
            .in_data_addra    ( {30'b0,in_data_addra}),
            .in_data_dina     ( in_data_dina         ),
            .fis_dim          ( fis_dim              ),
            .output_num       ( output_num           ),
            .pc_reg_start     ( pc_reg_start[i]      ),
            .pc_ap_start      ( fis_start&fis_para_set[i]),
            .pc_fis_done      ( fis_unit_done[i]     ),
            .pc_fis_return    ( fis_unit_return[32*i+31:32*i]),
            .localbus_bs      ( localbus_bs          ),
            .localbus_wr      ( localbus_wr          ),
            .localbus_addr    ( localbus_addr        ),
            .localbus_wdat    ( localbus_wdat        ),
            .pc_fis_rst       ( pc_fis_rst           ),
            .pc_fis_start     ( pc_fis_start         ),
            .vio_fis_rst      ( vio_fis_rst          ),
            .vio_fis_start    ( vio_fis_start        ),
            .vio_fis_num      ( vio_fis_num          )
            );
        end
    endgenerate
    //====================================================================//
    //-------------------------------  end  ------------------------------//
    //====================================================================//

endmodule
