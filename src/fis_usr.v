
`timescale 1ns / 1ps

module fis_usr(
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
    
    fis_para_set        ,
    inmf_ena            ,
    inmf_addra          ,
    inmf_dina           ,
    outmf_ena           ,
    outmf_addra         ,
    outmf_dina          ,
    rule_ena            ,
    rule_addra          ,
    rule_dina           ,
    in_data_ena         ,
    in_data_addra       ,
    in_data_dina        ,
    fis_dim             ,
    output_num          ,
    fis_start           ,
    
    localbus_bs         ,
    localbus_wr         ,
    localbus_addr       ,
    localbus_wdat       ,
    pc_fis_rst          ,
    pc_fis_start        ,
    pc_mig_rst          ,
    fis_unit_done       ,
    fis_unit_return     ,
    pc_fis_done         ,
    
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
    fis_9_done           
    );
    //parameter defination
    parameter       CMD_SADDR        = 32'h0000_0000  ;
    parameter       CMD_RLEN         = 32'h0000_0010  ;
    parameter       FIS_STEP_ADDRESS = 32'h40_0000    ;
    parameter       FIS_UNIT_NUM     = 10              ;
    
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
    
    parameter       PARA_GP_ADDR     = 6'h08        ;
    parameter       PARA_START_ADDR  = 6'h10        ;
    parameter       PARA_END_ADDR    = 6'h1F        ;
    parameter       FIS_NUM_ADDR     = 6'h21        ;
    //-------------------------------------------------------------------
    // Defination of Ports
    //-------------------------------------------------------------------
    ////clock and reset
    input  wire  [00:0]       usr_synclk            ;
    input  wire  [00:0]       sys_rst_p             ;
    //user dram operation signals.
    output reg   [00:0]       ddr3_fcfifo_wr        ;
    output reg   [79:0]       ddr3_fcfifo_wdata     ;
    input  wire  [00:0]       ddr3_fcfifo_afull     ;
    output reg   [00:0]       ddr3_fxfifo_wr        ;
    output reg   [511:0]      ddr3_fxfifo_wdata     ;
    input  wire  [00:0]       ddr3_fxfifo_afull     ;
    input  wire  [00:0]       ddr3_frx_sign         ;
    input  wire  [00:0]       ddr3_rxfifo_wr        ;
    input  wire  [511:0]      ddr3_rxfifo_wdata     ;
    output wire  [00:0]       ddr3_rxfifo_afull     ;
    
    output reg   [FIS_UNIT_NUM-1:0] fis_para_set    ;
    output reg   [00:0]       inmf_ena              ;
    output reg   [07:0]       inmf_addra            ;
    output reg   [31:0]       inmf_dina             ;
    output reg   [00:0]       outmf_ena             ;
    output reg   [04:0]       outmf_addra           ;
    output reg   [31:0]       outmf_dina            ;
    output reg   [00:0]       rule_ena              ;
    output reg   [28:0]       rule_addra            ;
    output reg   [31:0]       rule_dina             ;
    output reg   [00:0]       in_data_ena           ;
    output reg   [01:0]       in_data_addra         ;
    output reg   [31:0]       in_data_dina          ;
    output reg   [127:0]      fis_dim               ;
    output wire  [04:0]       output_num            ;
    output reg   [00:0]       fis_start             ;
    
    input  wire  [00:0]       localbus_bs           ;
    input  wire  [00:0]       localbus_wr           ;
    input  wire  [23:0]       localbus_addr         ;
    input  wire  [31:0]       localbus_wdat         ;
    input  wire  [00:0]       pc_fis_rst            ;
    input  wire  [00:0]       pc_fis_start          ;
    input  wire  [00:0]       pc_mig_rst            ;
    input  wire  [FIS_UNIT_NUM-1:0]    fis_unit_done;
    input  wire  [FIS_UNIT_NUM*32-1:0] fis_unit_return;  
    output reg   [00:0]       pc_fis_done           ;
    
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
    output reg   [31:0]       fis_0_return          ;
    output reg   [31:0]       fis_1_return          ;
    output reg   [31:0]       fis_2_return          ;
    output reg   [31:0]       fis_3_return          ;
    output reg   [31:0]       fis_4_return          ;
    output reg   [31:0]       fis_5_return          ;
    output reg   [31:0]       fis_6_return          ;
    output reg   [31:0]       fis_7_return          ;
    output reg   [31:0]       fis_8_return          ;
    output reg   [31:0]       fis_9_return          ;
    //====================================================================//
    //----------------------internal signals------------------------------//
    //====================================================================//
    wire  [00:0]         ap_rst                     ;
    reg   [05:0]         fis_unit_num               ;
    reg   [FIS_UNIT_NUM-1:0]  fis_para_rr           ;
    reg   [FIS_UNIT_NUM-1:0]  fis_unit_done_r0      ;
    reg   [FIS_UNIT_NUM-1:0]  fis_unit_done_r1      ;
    //ddr read operation;
    reg   [07:0]         fsm_fis_curr               ;
    reg   [07:0]         fsm_fis_next               ;

    parameter            FSM_FIS_IDLE    = 8'd0     ;
    parameter            FSM_FIS_0_WAIT  = 8'd1     ;
    parameter            FSM_FIS_0_CMD   = 8'd2     ;
    parameter            FSM_FIS_0_CHAL  = 8'd3     ;
    parameter            FSM_FIS_0_INMF  = 8'd4     ;
    parameter            FSM_FIS_0_IHAL  = 8'd5     ;
    parameter            FSM_FIS_0_OUTMF = 8'd6     ;
    parameter            FSM_FIS_0_OHAL  = 8'd7     ;
    parameter            FSM_FIS_0_RULE  = 8'd8     ;
    parameter            FSM_FIS_0_RHAL  = 8'd9     ;
    parameter            FSM_FIS_0_NDAT  = 8'd10    ;
    parameter            FSM_FIS_0_DHAL  = 8'd11    ;
    parameter            FSM_FIS_0_START = 8'd12    ;
    parameter            FSM_FIS_1_WAIT  = 8'd13    ;
    parameter            FSM_FIS_1_CMD   = 8'd14    ;
    parameter            FSM_FIS_1_CHAL  = 8'd15    ;
    parameter            FSM_FIS_1_INMF  = 8'd16    ;
    parameter            FSM_FIS_1_IHAL  = 8'd17    ;
    parameter            FSM_FIS_1_OUTMF = 8'd18    ;
    parameter            FSM_FIS_1_OHAL  = 8'd19    ;
    parameter            FSM_FIS_1_RULE  = 8'd20    ;
    parameter            FSM_FIS_1_RHAL  = 8'd21    ;
    parameter            FSM_FIS_1_NDAT  = 8'd22    ;
    parameter            FSM_FIS_1_DHAL  = 8'd23    ;
    parameter            FSM_FIS_1_START = 8'd24    ;
    parameter            FSM_FIS_2_WAIT  = 8'd25    ;
    parameter            FSM_FIS_2_CMD   = 8'd26    ;
    parameter            FSM_FIS_2_CHAL  = 8'd27    ;
    parameter            FSM_FIS_2_INMF  = 8'd28    ;
    parameter            FSM_FIS_2_IHAL  = 8'd29    ;
    parameter            FSM_FIS_2_OUTMF = 8'd30    ;
    parameter            FSM_FIS_2_OHAL  = 8'd31    ;
    parameter            FSM_FIS_2_RULE  = 8'd32    ;
    parameter            FSM_FIS_2_RHAL  = 8'd33    ;
    parameter            FSM_FIS_2_NDAT  = 8'd34    ;
    parameter            FSM_FIS_2_DHAL  = 8'd35    ;
    parameter            FSM_FIS_2_START = 8'd36    ;
    parameter            FSM_FIS_3_WAIT  = 8'd37    ;
    parameter            FSM_FIS_3_CMD   = 8'd38    ;
    parameter            FSM_FIS_3_CHAL  = 8'd39    ;
    parameter            FSM_FIS_3_INMF  = 8'd40    ;
    parameter            FSM_FIS_3_IHAL  = 8'd41    ;
    parameter            FSM_FIS_3_OUTMF = 8'd42    ;
    parameter            FSM_FIS_3_OHAL  = 8'd43    ;
    parameter            FSM_FIS_3_RULE  = 8'd44    ;
    parameter            FSM_FIS_3_RHAL  = 8'd45    ;
    parameter            FSM_FIS_3_NDAT  = 8'd46    ;
    parameter            FSM_FIS_3_DHAL  = 8'd47    ;
    parameter            FSM_FIS_3_START = 8'd48    ;  
    parameter            FSM_FIS_4_WAIT  = 8'd49    ;
    parameter            FSM_FIS_4_CMD   = 8'd50    ;
    parameter            FSM_FIS_4_CHAL  = 8'd51    ;
    parameter            FSM_FIS_4_INMF  = 8'd52    ;
    parameter            FSM_FIS_4_IHAL  = 8'd53    ;
    parameter            FSM_FIS_4_OUTMF = 8'd54    ;
    parameter            FSM_FIS_4_OHAL  = 8'd55    ;
    parameter            FSM_FIS_4_RULE  = 8'd56    ;
    parameter            FSM_FIS_4_RHAL  = 8'd57    ;
    parameter            FSM_FIS_4_NDAT  = 8'd58    ;
    parameter            FSM_FIS_4_DHAL  = 8'd59    ;
    parameter            FSM_FIS_4_START = 8'd60    ;
    parameter            FSM_FIS_5_WAIT  = 8'd61    ;
    parameter            FSM_FIS_5_CMD   = 8'd62    ;
    parameter            FSM_FIS_5_CHAL  = 8'd63    ;
    parameter            FSM_FIS_5_INMF  = 8'd64    ;
    parameter            FSM_FIS_5_IHAL  = 8'd65    ;
    parameter            FSM_FIS_5_OUTMF = 8'd66    ;
    parameter            FSM_FIS_5_OHAL  = 8'd67    ;
    parameter            FSM_FIS_5_RULE  = 8'd68    ;
    parameter            FSM_FIS_5_RHAL  = 8'd69    ;
    parameter            FSM_FIS_5_NDAT  = 8'd70    ;
    parameter            FSM_FIS_5_DHAL  = 8'd71    ;
    parameter            FSM_FIS_5_START = 8'd72    ;
    parameter            FSM_FIS_6_WAIT  = 8'd73    ;
    parameter            FSM_FIS_6_CMD   = 8'd74    ;
    parameter            FSM_FIS_6_CHAL  = 8'd75    ;
    parameter            FSM_FIS_6_INMF  = 8'd76    ;
    parameter            FSM_FIS_6_IHAL  = 8'd77    ;
    parameter            FSM_FIS_6_OUTMF = 8'd78    ;
    parameter            FSM_FIS_6_OHAL  = 8'd79    ;
    parameter            FSM_FIS_6_RULE  = 8'd80    ;
    parameter            FSM_FIS_6_RHAL  = 8'd81    ;
    parameter            FSM_FIS_6_NDAT  = 8'd82    ;
    parameter            FSM_FIS_6_DHAL  = 8'd83    ;
    parameter            FSM_FIS_6_START = 8'd84    ;
    parameter            FSM_FIS_7_WAIT  = 8'd85    ;
    parameter            FSM_FIS_7_CMD   = 8'd86    ;
    parameter            FSM_FIS_7_CHAL  = 8'd87    ;
    parameter            FSM_FIS_7_INMF  = 8'd88    ;
    parameter            FSM_FIS_7_IHAL  = 8'd89    ;
    parameter            FSM_FIS_7_OUTMF = 8'd90    ;
    parameter            FSM_FIS_7_OHAL  = 8'd91    ;
    parameter            FSM_FIS_7_RULE  = 8'd92    ;
    parameter            FSM_FIS_7_RHAL  = 8'h93    ;
    parameter            FSM_FIS_7_NDAT  = 8'h94    ;
    parameter            FSM_FIS_7_DHAL  = 8'd95    ;
    parameter            FSM_FIS_7_START = 8'd96    ;
    parameter            FSM_FIS_8_WAIT  = 8'd97    ;
    parameter            FSM_FIS_8_CMD   = 8'd98    ;
    parameter            FSM_FIS_8_CHAL  = 8'd99    ;
    parameter            FSM_FIS_8_INMF  = 8'd100    ;
    parameter            FSM_FIS_8_IHAL  = 8'd101    ;
    parameter            FSM_FIS_8_OUTMF = 8'd102    ;
    parameter            FSM_FIS_8_OHAL  = 8'd103    ;
    parameter            FSM_FIS_8_RULE  = 8'd104    ;
    parameter            FSM_FIS_8_RHAL  = 8'd105    ;
    parameter            FSM_FIS_8_NDAT  = 8'd106    ;
    parameter            FSM_FIS_8_DHAL  = 8'd107    ;
    parameter            FSM_FIS_8_START = 8'd108    ;
    parameter            FSM_FIS_9_WAIT  = 8'd109    ;
    parameter            FSM_FIS_9_CMD   = 8'd110    ;
    parameter            FSM_FIS_9_CHAL  = 8'd111    ;
    parameter            FSM_FIS_9_INMF  = 8'd112    ;
    parameter            FSM_FIS_9_IHAL  = 8'd113    ;
    parameter            FSM_FIS_9_OUTMF = 8'd114    ;
    parameter            FSM_FIS_9_OHAL  = 8'd115    ;
    parameter            FSM_FIS_9_RULE  = 8'd116    ;
    parameter            FSM_FIS_9_RHAL  = 8'd117    ;
    parameter            FSM_FIS_9_NDAT  = 8'd118    ;
    parameter            FSM_FIS_9_DHAL  = 8'd119    ;
    parameter            FSM_FIS_9_START = 8'd120    ; 
    
    
     
    
    reg   [03:0]         fis_index                  ;
    reg   [05:0]         fis_len                    ;
    reg   [07:0]         inmf_tlen                  ;
    reg   [31:0]         inmf_saddr                 ;
    reg   [31:0]         inmf_rlen                  ;
    reg   [04:0]         outmf_tlen                 ;
    reg   [31:0]         outmf_saddr                ;
    reg   [31:0]         outmf_rlen                 ;
    reg   [31:0]         rule_tlen                  ;
    reg   [31:0]         rule_saddr                 ;
    reg   [31:0]         rule_rlen                  ;
    reg   [31:0]         ddr_read_len               ;
    reg   [31:0]         ddr_read_true              ;
    reg   [31:0]         ddr_read_cnt               ;
    reg   [00:0]         ddr3_info_wr               ;
    reg   [255:0]        ddr3_info_lwdata           ;
    reg   [255:0]        ddr3_info_hwdata           ;
    wire  [00:0]         ddr3_info_afull            ;
    wire  [00:0]         ddr3_info_empty            ;
    reg   [00:0]         ddr3_info_lrpre            ;
    reg   [00:0]         ddr3_info_hrpre            ;
    wire  [00:0]         ddr3_info_lrd              ;
    wire  [00:0]         ddr3_info_hrd              ;
    reg   [00:0]         ddr3_info_empty_r0         ;
    reg   [00:0]         ddr3_info_empty_r1         ;
    wire  [00:0]         ddr3_info_empty_rise       ;
    reg   [31:0]         ddr3_info_rdcnt            ;
    wire  [31:0]         ddr3_info_lrdata           ;
    wire  [31:0]         ddr3_info_hrdata           ;
    
    reg   [00:0]         idata_dpram_wea            ;
    reg   [06:0]         idata_dpram_addra          ;
    reg   [31:0]         idata_dpram_dina           ;
    reg   [00:0]         idata_dpram_enb            ;
    reg   [04:0]         idata_dpram_addrb          ;
    reg   [00:0]         idata_dpram_enb_r0         ;
    reg   [00:0]         idata_dpram_enb_r1         ;
    wire  [31:0]         idata_dpram_doutb          ;
    reg   [01:0]         wait_cycle_cnt             ;

    //====================================================================//
    //--------------------------main process------------------------------//
    //====================================================================//
    //ap_rst
    assign      ap_rst = sys_rst_p | pc_fis_rst ;
    //ddr3_info_empty_rise
    assign      ddr3_info_empty_rise = ddr3_info_empty_r0 & (~ddr3_info_empty_r1) ;
    //output_num
    assign      output_num = outmf_tlen ;
    //fis_x_done
    assign      fis_0_done = fis_unit_done[0] ;
    assign      fis_1_done = fis_unit_done[1] ;
    assign      fis_2_done = fis_unit_done[2] ;
    assign      fis_3_done = fis_unit_done[3] ;
    assign      fis_4_done = fis_unit_done[4] ;
    assign      fis_5_done = fis_unit_done[5] ;
    assign      fis_6_done = fis_unit_done[6] ;
    assign      fis_7_done = fis_unit_done[7] ;
    assign      fis_8_done = fis_unit_done[8] ;
    assign      fis_9_done = fis_unit_done[9] ;
    //1st segment;
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fsm_fis_curr <= FSM_FIS_IDLE ;
        end
        else
        begin
            fsm_fis_curr <= fsm_fis_next ;
        end
    end
    //2nd segment;
    always @( * )
    begin
        case(fsm_fis_curr)
            FSM_FIS_IDLE:
            begin
                if(fis_0_start==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_0_CMD ;
                end
                else if(fis_1_start==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_1_CMD ;
                end
                else if(fis_2_start==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_2_CMD ;
                end
                else if(fis_3_start==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_3_CMD ;
                end
                else if(fis_4_start==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_4_CMD ;
                end
                else if(fis_5_start==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_5_CMD ;
                end
                else if(fis_6_start==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_6_CMD ;
                end
                else if(fis_7_start==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_7_CMD ;
                end
                else if(fis_8_start==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_8_CMD ;
                end
                else if(fis_9_start==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_9_CMD ;
                end                
                else
                begin
                    fsm_fis_next = FSM_FIS_IDLE ;
                end
            end
            FSM_FIS_0_WAIT:
            begin
                if(wait_cycle_cnt==2'b11)
                begin
                    if(fis_1_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_1_CMD ;
                    end
                    else if(fis_2_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_2_CMD ;
                    end
                    else if(fis_3_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_3_CMD ;
                    end
                    else if(fis_4_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_4_CMD ;
                    end
                    else if(fis_5_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_5_CMD ;
                    end
                    else if(fis_6_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_6_CMD ;
                    end
                    else if(fis_7_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_7_CMD ;
                    end
                    else if(fis_8_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_8_CMD ;
                    end
                    else if(fis_9_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_9_CMD ;
                    end                    
                    else
                    begin
                        fsm_fis_next = FSM_FIS_IDLE ;
                    end
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_0_WAIT ;
                end
            end
            FSM_FIS_0_CMD:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_0_CHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_0_CMD ;
                end
            end
            FSM_FIS_0_CHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    fsm_fis_next = FSM_FIS_0_INMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_0_CHAL ;
                end
            end
            FSM_FIS_0_INMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_0_IHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_0_INMF ;
                end
            end
            FSM_FIS_0_IHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_0_OUTMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_0_IHAL ;
                end
            end
            FSM_FIS_0_OUTMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_0_OHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_0_OUTMF ;
                end
            end
            FSM_FIS_0_OHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_0_RULE ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_0_OHAL ;
                end
            end
            FSM_FIS_0_RULE:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_0_RHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_0_RULE ;
                end
            end
            FSM_FIS_0_RHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_0_NDAT ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_0_RHAL ;
                end
            end
            FSM_FIS_0_NDAT:
            begin
                fsm_fis_next = FSM_FIS_0_DHAL ;
            end
            FSM_FIS_0_DHAL:
            begin
                if(idata_dpram_enb_r0==1'b0 && idata_dpram_enb_r1==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_0_START ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_0_DHAL ;
                end
            end
            FSM_FIS_0_START:
            begin
                fsm_fis_next = FSM_FIS_0_WAIT ;
            end
            FSM_FIS_1_WAIT:
            begin
                if(wait_cycle_cnt==2'b11)
                begin
                    if(fis_2_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_2_CMD ;
                    end
                    else if(fis_3_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_3_CMD ;
                    end
                    else if(fis_4_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_4_CMD ;
                    end
                    else if(fis_5_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_5_CMD ;
                    end
                    else if(fis_6_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_6_CMD ;
                    end
                    else if(fis_7_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_7_CMD ;
                    end
                    else if(fis_8_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_8_CMD ;
                    end
                    else if(fis_9_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_9_CMD ;
                    end    
                    else
                    begin
                        fsm_fis_next = FSM_FIS_IDLE ;
                    end
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_1_WAIT ;
                end
            end
            FSM_FIS_1_CMD:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_1_CHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_1_CMD ;
                end
            end
            FSM_FIS_1_CHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    fsm_fis_next = FSM_FIS_1_INMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_1_CHAL ;
                end
            end
            FSM_FIS_1_INMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_1_IHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_1_INMF ;
                end
            end
            FSM_FIS_1_IHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_1_OUTMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_1_IHAL ;
                end
            end
            FSM_FIS_1_OUTMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_1_OHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_1_OUTMF ;
                end
            end
            FSM_FIS_1_OHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_1_RULE ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_1_OHAL ;
                end
            end
            FSM_FIS_1_RULE:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_1_RHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_1_RULE ;
                end
            end
            FSM_FIS_1_RHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_1_NDAT ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_1_RHAL ;
                end
            end
            FSM_FIS_1_NDAT:
            begin
                fsm_fis_next = FSM_FIS_1_DHAL ;
            end
            FSM_FIS_1_DHAL:
            begin
                if(idata_dpram_enb_r0==1'b0 && idata_dpram_enb_r1==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_1_START ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_1_DHAL ;
                end
            end
            FSM_FIS_1_START:
            begin
                fsm_fis_next = FSM_FIS_1_WAIT ;
            end
            FSM_FIS_2_WAIT:
            begin
                if(wait_cycle_cnt==2'b11)
                begin
                    if(fis_3_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_3_CMD ;
                    end
                    else if(fis_4_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_4_CMD ;
                    end
                    else if(fis_5_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_5_CMD ;
                    end
                    else if(fis_6_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_6_CMD ;
                    end
                    else if(fis_7_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_7_CMD ;
                    end
                    else if(fis_8_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_8_CMD ;
                    end
                    else if(fis_9_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_9_CMD ;
                    end    
                    else
                    begin
                        fsm_fis_next = FSM_FIS_IDLE ;
                    end
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_2_WAIT ;
                end
            end
            FSM_FIS_2_CMD:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_2_CHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_2_CMD ;
                end
            end
            FSM_FIS_2_CHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    fsm_fis_next = FSM_FIS_2_INMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_2_CHAL ;
                end
            end
            FSM_FIS_2_INMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_2_IHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_2_INMF ;
                end
            end
            FSM_FIS_2_IHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_2_OUTMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_2_IHAL ;
                end
            end
            FSM_FIS_2_OUTMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_2_OHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_2_OUTMF ;
                end
            end
            FSM_FIS_2_OHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_2_RULE ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_2_OHAL ;
                end
            end
            FSM_FIS_2_RULE:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_2_RHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_2_RULE ;
                end
            end
            FSM_FIS_2_RHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_2_NDAT ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_2_RHAL ;
                end
            end
            FSM_FIS_2_NDAT:
            begin
                fsm_fis_next = FSM_FIS_2_DHAL ;
            end
            FSM_FIS_2_DHAL:
            begin
                if(idata_dpram_enb_r0==1'b0 && idata_dpram_enb_r1==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_2_START ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_2_DHAL ;
                end
            end
            FSM_FIS_2_START:
            begin
                fsm_fis_next = FSM_FIS_2_WAIT ;
            end
            FSM_FIS_3_WAIT:
            begin
                if(wait_cycle_cnt==2'b11)
                begin
                    if(fis_4_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_4_CMD ;
                    end
                    else if(fis_5_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_5_CMD ;
                    end
                    else if(fis_6_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_6_CMD ;
                    end
                    else if(fis_7_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_7_CMD ;
                    end
                    else if(fis_8_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_8_CMD ;
                    end
                    else if(fis_9_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_9_CMD ;
                    end    
                    else
                    begin
                        fsm_fis_next = FSM_FIS_IDLE ;
                    end
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_3_WAIT ;
                end
            end
            FSM_FIS_3_CMD:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_3_CHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_3_CMD ;
                end
            end
            FSM_FIS_3_CHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    fsm_fis_next = FSM_FIS_3_INMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_3_CHAL ;
                end
            end
            FSM_FIS_3_INMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_3_IHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_3_INMF ;
                end
            end
            FSM_FIS_3_IHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_3_OUTMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_3_IHAL ;
                end
            end
            FSM_FIS_3_OUTMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_3_OHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_3_OUTMF ;
                end
            end
            FSM_FIS_3_OHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_3_RULE ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_3_OHAL ;
                end
            end
            FSM_FIS_3_RULE:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_3_RHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_3_RULE ;
                end
            end
            FSM_FIS_3_RHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_3_NDAT ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_3_RHAL ;
                end
            end
            FSM_FIS_3_NDAT:
            begin
                fsm_fis_next = FSM_FIS_3_DHAL ;
            end
            FSM_FIS_3_DHAL:
            begin
                if(idata_dpram_enb_r0==1'b0 && idata_dpram_enb_r1==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_3_START ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_3_DHAL ;
                end
            end
            FSM_FIS_3_START:
            begin
                fsm_fis_next = FSM_FIS_3_WAIT ;
            end
            FSM_FIS_4_WAIT:
            begin
                if(wait_cycle_cnt==2'b11)
                begin
                    if(fis_5_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_5_CMD ;
                    end
                    else if(fis_6_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_6_CMD ;
                    end
                    else if(fis_7_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_7_CMD ;
                    end
                    else if(fis_8_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_8_CMD ;
                    end
                    else if(fis_9_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_9_CMD ;
                    end    
                    else
                    begin
                        fsm_fis_next = FSM_FIS_IDLE ;
                    end
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_4_WAIT ;
                end
            end
            FSM_FIS_4_CMD:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_4_CHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_4_CMD ;
                end
            end
            FSM_FIS_4_CHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    fsm_fis_next = FSM_FIS_4_INMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_4_CHAL ;
                end
            end
            FSM_FIS_4_INMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_4_IHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_4_INMF ;
                end
            end
            FSM_FIS_4_IHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_4_OUTMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_4_IHAL ;
                end
            end
            FSM_FIS_4_OUTMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_4_OHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_4_OUTMF ;
                end
            end
            FSM_FIS_4_OHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_4_RULE ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_4_OHAL ;
                end
            end
            FSM_FIS_4_RULE:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_4_RHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_4_RULE ;
                end
            end
            FSM_FIS_4_RHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_4_NDAT ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_4_RHAL ;
                end
            end
            FSM_FIS_4_NDAT:
            begin
                fsm_fis_next = FSM_FIS_4_DHAL ;
            end
            FSM_FIS_4_DHAL:
            begin
                if(idata_dpram_enb_r0==1'b0 && idata_dpram_enb_r1==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_4_START ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_4_DHAL ;
                end
            end
            FSM_FIS_4_START:
            begin
                fsm_fis_next = FSM_FIS_4_WAIT ;
            end
            FSM_FIS_5_WAIT:
            begin
                if(wait_cycle_cnt==2'b11)
                begin
                    if(fis_6_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_6_CMD ;
                    end
                    else if(fis_7_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_7_CMD ;
                    end
                    else if(fis_8_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_8_CMD ;
                    end
                    else if(fis_9_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_9_CMD ;
                    end    
                    else
                    begin
                        fsm_fis_next = FSM_FIS_IDLE ;
                    end
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_5_WAIT ;
                end
            end
            FSM_FIS_5_CMD:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_5_CHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_5_CMD ;
                end
            end
            FSM_FIS_5_CHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    fsm_fis_next = FSM_FIS_5_INMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_5_CHAL ;
                end
            end
            FSM_FIS_5_INMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_5_IHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_5_INMF ;
                end
            end
            FSM_FIS_5_IHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_5_OUTMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_5_IHAL ;
                end
            end
            FSM_FIS_5_OUTMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_5_OHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_5_OUTMF ;
                end
            end
            FSM_FIS_5_OHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_5_RULE ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_5_OHAL ;
                end
            end
            FSM_FIS_5_RULE:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_5_RHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_5_RULE ;
                end
            end
            FSM_FIS_5_RHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_5_NDAT ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_5_RHAL ;
                end
            end
            FSM_FIS_5_NDAT:
            begin
                fsm_fis_next = FSM_FIS_5_DHAL ;
            end
            FSM_FIS_5_DHAL:
            begin
                if(idata_dpram_enb_r0==1'b0 && idata_dpram_enb_r1==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_5_START ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_5_DHAL ;
                end
            end
            FSM_FIS_5_START:
            begin
                fsm_fis_next = FSM_FIS_5_WAIT ;
            end
            FSM_FIS_6_WAIT:
            begin
                if(wait_cycle_cnt==2'b11)
                begin
                    if(fis_7_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_7_CMD ;
                    end
                    else if(fis_8_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_8_CMD ;
                    end
                    else if(fis_9_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_9_CMD ;
                    end    
                    else
                    begin
                        fsm_fis_next = FSM_FIS_IDLE ;
                    end
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_6_WAIT ;
                end
            end
            FSM_FIS_6_CMD:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_6_CHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_6_CMD ;
                end
            end
            FSM_FIS_6_CHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    fsm_fis_next = FSM_FIS_6_INMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_6_CHAL ;
                end
            end
            FSM_FIS_6_INMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_6_IHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_6_INMF ;
                end
            end
            FSM_FIS_6_IHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_6_OUTMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_6_IHAL ;
                end
            end
            FSM_FIS_6_OUTMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_6_OHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_6_OUTMF ;
                end
            end
            FSM_FIS_6_OHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_6_RULE ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_6_OHAL ;
                end
            end
            FSM_FIS_6_RULE:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_6_RHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_6_RULE ;
                end
            end
            FSM_FIS_6_RHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_6_NDAT ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_6_RHAL ;
                end
            end
            FSM_FIS_6_NDAT:
            begin
                fsm_fis_next = FSM_FIS_6_DHAL ;
            end
            FSM_FIS_6_DHAL:
            begin
                if(idata_dpram_enb_r0==1'b0 && idata_dpram_enb_r1==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_6_START ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_6_DHAL ;
                end
            end
            FSM_FIS_6_START:
            begin
                fsm_fis_next = FSM_FIS_6_WAIT ;
            end
            FSM_FIS_7_WAIT:
            begin
                if(wait_cycle_cnt==2'b11)
                begin
                    if(fis_8_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_8_CMD ;
                    end
                    else if(fis_9_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_9_CMD ;
                    end    
                    else
                    begin
                    fsm_fis_next = FSM_FIS_IDLE ;
                    end
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_7_WAIT ;
                end
            end
            FSM_FIS_7_CMD:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_7_CHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_7_CMD ;
                end
            end
            FSM_FIS_7_CHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    fsm_fis_next = FSM_FIS_7_INMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_7_CHAL ;
                end
            end
            FSM_FIS_7_INMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_7_IHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_7_INMF ;
                end
            end
            FSM_FIS_7_IHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_7_OUTMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_7_IHAL ;
                end
            end
            FSM_FIS_7_OUTMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_7_OHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_7_OUTMF ;
                end
            end
            FSM_FIS_7_OHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_7_RULE ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_7_OHAL ;
                end
            end
            FSM_FIS_7_RULE:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_7_RHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_7_RULE ;
                end
            end
            FSM_FIS_7_RHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_7_NDAT ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_7_RHAL ;
                end
            end
            FSM_FIS_7_NDAT:
            begin
                fsm_fis_next = FSM_FIS_7_DHAL ;
            end
            FSM_FIS_7_DHAL:
            begin
                if(idata_dpram_enb_r0==1'b0 && idata_dpram_enb_r1==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_7_START ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_7_DHAL ;
                end
            end
            FSM_FIS_7_START:
            begin
                fsm_fis_next = FSM_FIS_7_WAIT ;
            end
            FSM_FIS_8_WAIT:
            begin
                if(wait_cycle_cnt==2'b11)
                begin
                   if(fis_9_start==1'b1)
                    begin
                        fsm_fis_next = FSM_FIS_9_CMD ;
                    end                   
                    else
                    begin
                    fsm_fis_next = FSM_FIS_IDLE ;
                    end 
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_8_WAIT ;
                end
            end
            FSM_FIS_8_CMD:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_8_CHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_8_CMD ;
                end
            end
            FSM_FIS_8_CHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    fsm_fis_next = FSM_FIS_8_INMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_8_CHAL ;
                end
            end
            FSM_FIS_8_INMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_8_IHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_8_INMF ;
                end
            end
            FSM_FIS_8_IHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_8_OUTMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_8_IHAL ;
                end
            end
            FSM_FIS_8_OUTMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_8_OHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_8_OUTMF ;
                end
            end
            FSM_FIS_8_OHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_8_RULE ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_8_OHAL ;
                end
            end
            FSM_FIS_8_RULE:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_8_RHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_8_RULE ;
                end
            end
            FSM_FIS_8_RHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_8_NDAT ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_8_RHAL ;
                end
            end
            FSM_FIS_8_NDAT:
            begin
                fsm_fis_next = FSM_FIS_8_DHAL ;
            end
            FSM_FIS_8_DHAL:
            begin
                if(idata_dpram_enb_r0==1'b0 && idata_dpram_enb_r1==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_8_START ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_8_DHAL ;
                end
            end
            FSM_FIS_8_START:
            begin
                fsm_fis_next = FSM_FIS_8_WAIT ;
            end            
            FSM_FIS_9_WAIT:
            begin
                if(wait_cycle_cnt==2'b11)
                begin        
                    fsm_fis_next = FSM_FIS_IDLE ;                    
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_9_WAIT ;
                end
            end
            FSM_FIS_9_CMD:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_9_CHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_9_CMD ;
                end
            end
            FSM_FIS_9_CHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    fsm_fis_next = FSM_FIS_9_INMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_9_CHAL ;
                end
            end
            FSM_FIS_9_INMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_9_IHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_9_INMF ;
                end
            end
            FSM_FIS_9_IHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_9_OUTMF ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_9_IHAL ;
                end
            end
            FSM_FIS_9_OUTMF:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_9_OHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_9_OUTMF ;
                end
            end
            FSM_FIS_9_OHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_9_RULE ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_9_OHAL ;
                end
            end
            FSM_FIS_9_RULE:
            begin
                if(ddr3_fcfifo_afull==1'b0)
                begin
                    fsm_fis_next = FSM_FIS_9_RHAL ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_9_RULE ;
                end
            end
            FSM_FIS_9_RHAL:
            begin
                if(ddr_read_cnt>=ddr_read_len && ddr3_info_empty_rise==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_9_NDAT ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_9_RHAL ;
                end
            end
            FSM_FIS_9_NDAT:
            begin
                fsm_fis_next = FSM_FIS_9_DHAL ;
            end
            FSM_FIS_9_DHAL:
            begin
                if(idata_dpram_enb_r0==1'b0 && idata_dpram_enb_r1==1'b1)
                begin
                    fsm_fis_next = FSM_FIS_9_START ;
                end
                else
                begin
                    fsm_fis_next = FSM_FIS_9_DHAL ;
                end
            end
            FSM_FIS_9_START:
            begin
                fsm_fis_next = FSM_FIS_8_WAIT ;
            end
           default:
            begin
                fsm_fis_next = FSM_FIS_IDLE ;
            end
        endcase
    end
    //3rd segment;
    //pc_fis_done
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            pc_fis_done <= 1'b0 ;
        end
        else
        begin
            pc_fis_done <= fis_0_done&fis_1_done&fis_2_done&fis_3_done&fis_5_done&fis_5_done&fis_6_done&fis_7_done&fis_8_done&fis_9_done ;
        end
    end
    //fis_para_rr/fis_para_set
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_para_rr <= {FIS_UNIT_NUM{1'b0}} ;
            fis_para_set <= {FIS_UNIT_NUM{1'b0}} ;
            fis_unit_done_r0 <= {FIS_UNIT_NUM{1'b0}} ;
            fis_unit_done_r1 <= {FIS_UNIT_NUM{1'b0}} ;
        end
        else
        begin
            fis_para_set <= fis_para_rr ;
            fis_unit_done_r0 <= fis_unit_done ;
            fis_unit_done_r1 <= fis_unit_done_r0 ;
            if(fsm_fis_curr==FSM_FIS_0_CMD)
            begin
                fis_para_rr <= {{9{1'b0}},1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_1_CMD)
            begin
                fis_para_rr <= {{8{1'b0}},1'b1,1'b0} ;
            end
            else if(fsm_fis_curr==FSM_FIS_2_CMD)
            begin
                fis_para_rr <= {{7{1'b0}},1'b1,2'b00} ;
            end
            else if(fsm_fis_curr==FSM_FIS_3_CMD)
            begin
                fis_para_rr <= {{6{1'b0}},1'b1,3'b000} ;
            end
            else if(fsm_fis_curr==FSM_FIS_4_CMD)
            begin
                fis_para_rr <= {{5{1'b0}},1'b1,4'b0000} ;
            end
            else if(fsm_fis_curr==FSM_FIS_5_CMD)
            begin
                fis_para_rr <= {{4{1'b0}},1'b1,5'b00000} ;
            end
            else if(fsm_fis_curr==FSM_FIS_6_CMD)
            begin
                fis_para_rr <= {{3{1'b0}},1'b1,6'b000000} ;
            end
            else if(fsm_fis_curr==FSM_FIS_7_CMD)
            begin
                fis_para_rr <= {{2{1'b0}},1'b1,7'b0000000} ;
            end
            else if(fsm_fis_curr==FSM_FIS_8_CMD)
            begin
                fis_para_rr <= {{1{1'b0}},1'b1,8'b00000000} ;
            end
            else if(fsm_fis_curr==FSM_FIS_9_CMD)
            begin
                fis_para_rr <= {1'b1,9'b000000000} ;
            end
            else if(fsm_fis_curr==FSM_FIS_IDLE)
            begin
                fis_para_rr <= {10{1'b0}} ;
            end
            else
            begin
                fis_para_rr <= fis_para_rr ;
            end
        end
    end
    //fis_0_return
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_0_return <= 32'b0 ;
        end
        else
        begin
            if(fis_start==1'b1 && fis_para_set[0]==1'b1)
            begin
                fis_0_return <= 32'b0 ;
            end
            else if(fis_unit_done_r0[0]==1'b1 && fis_unit_done_r1[0]==1'b0)
            begin
                fis_0_return <= fis_unit_return[32*1-1:32*0] ;
            end
            else
            begin
                fis_0_return <= fis_0_return ;
            end
        end
    end
    //fis_1_return
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_1_return <= 32'b0 ;
        end
        else
        begin
            if(fis_start==1'b1 && fis_para_set[1]==1'b1)
            begin
                fis_1_return <= 32'b0 ;
            end
            else if(fis_unit_done_r0[1]==1'b1 && fis_unit_done_r1[1]==1'b0)
            begin
                fis_1_return <= fis_unit_return[32*2-1:32*1] ;
            end
            else
            begin
                fis_1_return <= fis_1_return ;
            end
        end
    end
    //fis_2_return
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_2_return <= 32'b0 ;
        end
        else
        begin
            if(fis_start==1'b1 && fis_para_set[2]==1'b1)
            begin
                fis_2_return <= 32'b0 ;
            end
            else if(fis_unit_done_r0[2]==1'b1 && fis_unit_done_r1[2]==1'b0)
            begin
                fis_2_return <= fis_unit_return[32*3-1:32*2] ;
            end
            else
            begin
                fis_2_return <= fis_2_return ;
            end
        end
    end
    //fis_3_return
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_3_return <= 32'b0 ;
        end
        else
        begin
            if(fis_start==1'b1 && fis_para_set[3]==1'b1)
            begin
                fis_3_return <= 32'b0 ;
            end
            else if(fis_unit_done_r0[3]==1'b1 && fis_unit_done_r1[3]==1'b0)
            begin
                fis_3_return <= fis_unit_return[32*4-1:32*3] ;
            end
            else
            begin
                fis_3_return <= fis_3_return ;
            end
        end
    end
    //fis_4_return
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_4_return <= 32'b0 ;
        end
        else
        begin
            if(fis_start==1'b1 && fis_para_set[4]==1'b1)
            begin
                fis_4_return <= 32'b0 ;
            end
            else if(fis_unit_done_r0[4]==1'b1 && fis_unit_done_r1[4]==1'b0)
            begin
                fis_4_return <= fis_unit_return[32*5-1:32*4] ;
            end
            else
            begin
                fis_4_return <= fis_4_return ;
            end
        end
    end
    //fis_5_return
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_5_return <= 32'b0 ;
        end
        else
        begin
            if(fis_start==1'b1 && fis_para_set[5]==1'b1)
            begin
                fis_5_return <= 32'b0 ;
            end
            else if(fis_unit_done_r0[5]==1'b1 && fis_unit_done_r1[5]==1'b0)
            begin
                fis_5_return <= fis_unit_return[32*6-1:32*5] ;
            end
            else
            begin
                fis_5_return <= fis_5_return ;
            end
        end
    end
    //fis_6_return
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_6_return <= 32'b0 ;
        end
        else
        begin
            if(fis_start==1'b1 && fis_para_set[6]==1'b1)
            begin
                fis_6_return <= 32'b0 ;
            end
            else if(fis_unit_done_r0[6]==1'b1 && fis_unit_done_r1[6]==1'b0)
            begin
                fis_6_return <= fis_unit_return[32*7-1:32*6] ;
            end
            else
            begin
                fis_6_return <= fis_6_return ;
            end
        end
    end
    //fis_7_return
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_7_return <= 32'b0 ;
        end
        else
        begin
            if(fis_start==1'b1 && fis_para_set[7]==1'b1)
            begin
                fis_7_return <= 32'b0 ;
            end
            else if(fis_unit_done_r0[7]==1'b1 && fis_unit_done_r1[7]==1'b0)
            begin
                fis_7_return <= fis_unit_return[32*8-1:32*7] ;
            end
            else
            begin
                fis_7_return <= fis_7_return ;
            end
        end
    end   
    //fis_8_return
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_8_return <= 32'b0 ;
        end
        else
        begin
            if(fis_start==1'b1 && fis_para_set[8]==1'b1)
            begin
                fis_8_return <= 32'b0 ;
            end
            else if(fis_unit_done_r0[8]==1'b1 && fis_unit_done_r1[8]==1'b0)
            begin
                fis_8_return <= fis_unit_return[32*9-1:32*8] ;
            end
            else
            begin
                fis_8_return <= fis_8_return ;
            end
        end
    end
    //fis_9_return
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_9_return <= 32'b0 ;
        end
        else
        begin
            if(fis_start==1'b1 && fis_para_set[9]==1'b1)
            begin
                fis_9_return <= 32'b0 ;
            end
            else if(fis_unit_done_r0[9]==1'b1 && fis_unit_done_r1[9]==1'b0)
            begin
                fis_9_return <= fis_unit_return[32*10-1:32*9] ;
            end
            else
            begin
                fis_9_return <= fis_9_return ;
            end
        end
    end        
    
    //fis_index/fis_dim/fis_len/inmf_tlen/inmf_saddr/inmf_rlen
    always @(posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_index   <= 4'h6  ;
//            fis_dim     <= 4'h3  ;
            fis_len     <= 6'h9  ;
            inmf_tlen   <= 8'h36 ;
            inmf_saddr  <= 32'h0 ;
            inmf_rlen   <= 32'h0 ;
            outmf_tlen  <= 5'h09 ;
            outmf_saddr <= 32'h0 ;
            outmf_rlen  <= 32'h0 ;
            rule_tlen   <= 32'h2d9 ;
            rule_saddr  <= 32'h0 ;
            rule_rlen   <= 32'h0 ;
//            ndat_pnum   <= 32'b0 ;
//            ndat_tlen   <= 10'h1 ;
//            ndat_saddr  <= 32'h0 ;
//            ndat_rlen   <= 32'h0 ;
            fis_dim     <= 128'b0;
        end
        else
        begin
            if(fsm_fis_curr==FSM_FIS_0_CHAL||fsm_fis_curr==FSM_FIS_1_CHAL||fsm_fis_curr==FSM_FIS_2_CHAL||fsm_fis_curr==FSM_FIS_3_CHAL||fsm_fis_curr==FSM_FIS_4_CHAL||fsm_fis_curr==FSM_FIS_5_CHAL||fsm_fis_curr==FSM_FIS_6_CHAL||fsm_fis_curr==FSM_FIS_7_CHAL||fsm_fis_curr==FSM_FIS_8_CHAL||fsm_fis_curr==FSM_FIS_9_CHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    if(ddr_read_cnt==32'h0)
                    begin
                        outmf_rlen  <= ddr3_rxfifo_wdata[31:0]     ;
                        rule_tlen   <= ddr3_rxfifo_wdata[63:32]   ;
                        rule_saddr  <= ddr3_rxfifo_wdata[95:64]   ;
                        rule_rlen   <= ddr3_rxfifo_wdata[127:96]  ;
//                        ndat_pnum   <= ddr3_rxfifo_wdata[159:128] ;
//                        ndat_tlen   <= ddr3_rxfifo_wdata[169:160] ;
//                        ndat_saddr  <= ddr3_rxfifo_wdata[223:192] ;
//                        ndat_rlen   <= ddr3_rxfifo_wdata[255:224] ;
                        fis_index   <= ddr3_rxfifo_wdata[287:256] ;
//                        fis_dim     <= ddr3_rxfifo_wdata[319:288] ;
                        fis_len     <= ddr3_rxfifo_wdata[351:320] ;
                        inmf_tlen   <= ddr3_rxfifo_wdata[359:352] ;
                        inmf_saddr  <= ddr3_rxfifo_wdata[415:384] ;
                        inmf_rlen   <= ddr3_rxfifo_wdata[447:416] ;
                        outmf_tlen  <= ddr3_rxfifo_wdata[452:448] ;
                        outmf_saddr <= ddr3_rxfifo_wdata[511:480] ;
                        fis_dim <= fis_dim ;
                    end
                    else if(ddr_read_cnt==32'h8)
                    begin
                        fis_dim <= ddr3_rxfifo_wdata[383:256] ;//128
                    end
                    else
                    begin
                        fis_index   <= fis_index   ;
                        fis_len     <= fis_len     ;
                        inmf_tlen   <= inmf_tlen   ;
                        inmf_saddr  <= inmf_saddr  ;
                        inmf_rlen   <= inmf_rlen   ;
                        outmf_tlen  <= outmf_tlen  ;
                        outmf_saddr <= outmf_saddr ;
                        outmf_rlen  <= outmf_rlen  ;
                        rule_tlen   <= rule_tlen   ;
                        rule_saddr  <= rule_saddr  ;
                        rule_rlen   <= rule_rlen   ;
//                        ndat_pnum   <= ndat_pnum   ;
//                        ndat_tlen   <= ndat_tlen   ;
//                        ndat_saddr  <= ndat_saddr  ;
//                        ndat_rlen   <= ndat_rlen   ;
                        fis_dim     <= fis_dim     ;
                    end
                end
                else
                begin
                    fis_index   <= fis_index   ;
                    fis_dim     <= fis_dim     ;
                    fis_len     <= fis_len     ;
                    inmf_tlen   <= inmf_tlen   ;
                    inmf_saddr  <= inmf_saddr  ;
                    inmf_rlen   <= inmf_rlen   ;
                    outmf_tlen  <= outmf_tlen  ;
                    outmf_saddr <= outmf_saddr ;
                    outmf_rlen  <= outmf_rlen  ;
                    rule_tlen   <= rule_tlen   ;
                    rule_saddr  <= rule_saddr  ;
                    rule_rlen   <= rule_rlen   ;
//                    ndat_pnum   <= ndat_pnum   ;
//                    ndat_tlen   <= ndat_tlen   ;
//                    ndat_saddr  <= ndat_saddr  ;
//                    ndat_rlen   <= ndat_rlen   ;
                end
            end
            else
            begin
                fis_index   <= fis_index   ;
                fis_dim     <= fis_dim     ;
                fis_len     <= fis_len     ;
                inmf_tlen   <= inmf_tlen   ;
                inmf_saddr  <= inmf_saddr  ;
                inmf_rlen   <= inmf_rlen   ;
                outmf_tlen  <= outmf_tlen  ;
                outmf_saddr <= outmf_saddr ;
                outmf_rlen  <= outmf_rlen  ;
                rule_tlen   <= rule_tlen   ;
                rule_saddr  <= rule_saddr  ;
                rule_rlen   <= rule_rlen   ;
//                ndat_pnum   <= ndat_pnum   ;
//                ndat_tlen   <= ndat_tlen   ;
//                ndat_saddr  <= ndat_saddr  ;
//                ndat_rlen   <= ndat_rlen   ;
            end
        end
    end
    
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            ddr_read_len <= 32'b0 ;
            ddr_read_cnt <= 32'b0 ;
            ddr_read_true <= 32'b0 ;
        end
        else
        begin
            if(fsm_fis_curr!=FSM_FIS_0_CMD && fsm_fis_next==FSM_FIS_0_CMD)
            begin
                ddr_read_len <= CMD_RLEN ;
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= 32'b0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_0_CHAL && fsm_fis_next==FSM_FIS_0_INMF)
            begin
                ddr_read_true <= inmf_tlen ;
                ddr_read_cnt <= 32'b0 ;
                if(inmf_rlen[2:0]==3'b000 && inmf_rlen>32'h0)
                begin
                    ddr_read_len <= inmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {inmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_0_IHAL && fsm_fis_next==FSM_FIS_0_OUTMF)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= outmf_tlen ;
                if(outmf_rlen[2:0]==3'b000 && outmf_rlen>32'h0)
                begin
                    ddr_read_len <= outmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {outmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_0_OHAL && fsm_fis_next==FSM_FIS_0_RULE)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= rule_tlen ;
                if(rule_rlen[2:0]==3'b000 && rule_rlen>32'h0)
                begin
                    ddr_read_len <= rule_rlen ;
                end
                else
                begin
                    ddr_read_len <= {rule_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_0_CHAL || fsm_fis_curr==FSM_FIS_0_IHAL || fsm_fis_curr==FSM_FIS_0_OHAL  || fsm_fis_curr==FSM_FIS_0_RHAL)
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_true <= ddr_read_true ;
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr_read_cnt <= ddr_read_cnt + 32'h8 ;
                end
                else
                begin
                    ddr_read_cnt <= ddr_read_cnt ;
                end
            end
            else if(fsm_fis_curr!=FSM_FIS_1_CMD && fsm_fis_next==FSM_FIS_1_CMD)
            begin
                ddr_read_len <= CMD_RLEN ;
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= 32'b0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_1_CHAL && fsm_fis_next==FSM_FIS_1_INMF)
            begin
                ddr_read_true <= inmf_tlen ;
                ddr_read_cnt <= 32'b0 ;
                if(inmf_rlen[2:0]==3'b000 && inmf_rlen>32'h0)
                begin
                    ddr_read_len <= inmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {inmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_1_IHAL && fsm_fis_next==FSM_FIS_1_OUTMF)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= outmf_tlen ;
                if(outmf_rlen[2:0]==3'b000 && outmf_rlen>32'h0)
                begin
                    ddr_read_len <= outmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {outmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_1_OHAL && fsm_fis_next==FSM_FIS_1_RULE)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= rule_tlen ;
                if(rule_rlen[2:0]==3'b000 && rule_rlen>32'h0)
                begin
                    ddr_read_len <= rule_rlen ;
                end
                else
                begin
                    ddr_read_len <= {rule_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_1_CHAL || fsm_fis_curr==FSM_FIS_1_IHAL || fsm_fis_curr==FSM_FIS_1_OHAL  || fsm_fis_curr==FSM_FIS_1_RHAL)
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_true <= ddr_read_true ;
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr_read_cnt <= ddr_read_cnt + 32'h8 ;
                end
                else
                begin
                    ddr_read_cnt <= ddr_read_cnt ;
                end
            end
            else if(fsm_fis_curr!=FSM_FIS_2_CMD && fsm_fis_next==FSM_FIS_2_CMD)
            begin
                ddr_read_len <= CMD_RLEN ;
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= 32'b0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_2_CHAL && fsm_fis_next==FSM_FIS_2_INMF)
            begin
                ddr_read_true <= inmf_tlen ;
                ddr_read_cnt <= 32'b0 ;
                if(inmf_rlen[2:0]==3'b000 && inmf_rlen>32'h0)
                begin
                    ddr_read_len <= inmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {inmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_2_IHAL && fsm_fis_next==FSM_FIS_2_OUTMF)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= outmf_tlen ;
                if(outmf_rlen[2:0]==3'b000 && outmf_rlen>32'h0)
                begin
                    ddr_read_len <= outmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {outmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_2_OHAL && fsm_fis_next==FSM_FIS_2_RULE)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= rule_tlen ;
                if(rule_rlen[2:0]==3'b000 && rule_rlen>32'h0)
                begin
                    ddr_read_len <= rule_rlen ;
                end
                else
                begin
                    ddr_read_len <= {rule_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_2_CHAL || fsm_fis_curr==FSM_FIS_2_IHAL || fsm_fis_curr==FSM_FIS_2_OHAL  || fsm_fis_curr==FSM_FIS_2_RHAL)
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_true <= ddr_read_true ;
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr_read_cnt <= ddr_read_cnt + 32'h8 ;
                end
                else
                begin
                    ddr_read_cnt <= ddr_read_cnt ;
                end
            end
            else if(fsm_fis_curr!=FSM_FIS_3_CMD && fsm_fis_next==FSM_FIS_3_CMD)
            begin
                ddr_read_len <= CMD_RLEN ;
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= 32'b0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_3_CHAL && fsm_fis_next==FSM_FIS_3_INMF)
            begin
                ddr_read_true <= inmf_tlen ;
                ddr_read_cnt <= 32'b0 ;
                if(inmf_rlen[2:0]==3'b000 && inmf_rlen>32'h0)
                begin
                    ddr_read_len <= inmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {inmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_3_IHAL && fsm_fis_next==FSM_FIS_3_OUTMF)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= outmf_tlen ;
                if(outmf_rlen[2:0]==3'b000 && outmf_rlen>32'h0)
                begin
                    ddr_read_len <= outmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {outmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_3_OHAL && fsm_fis_next==FSM_FIS_3_RULE)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= rule_tlen ;
                if(rule_rlen[2:0]==3'b000 && rule_rlen>32'h0)
                begin
                    ddr_read_len <= rule_rlen ;
                end
                else
                begin
                    ddr_read_len <= {rule_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_3_CHAL || fsm_fis_curr==FSM_FIS_3_IHAL || fsm_fis_curr==FSM_FIS_3_OHAL  || fsm_fis_curr==FSM_FIS_3_RHAL)
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_true <= ddr_read_true ;
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr_read_cnt <= ddr_read_cnt + 32'h8 ;
                end
                else
                begin
                    ddr_read_cnt <= ddr_read_cnt ;
                end
            end
            else if(fsm_fis_curr!=FSM_FIS_4_CMD && fsm_fis_next==FSM_FIS_4_CMD)
            begin
                ddr_read_len <= CMD_RLEN ;
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= 32'b0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_4_CHAL && fsm_fis_next==FSM_FIS_4_INMF)
            begin
                ddr_read_true <= inmf_tlen ;
                ddr_read_cnt <= 32'b0 ;
                if(inmf_rlen[2:0]==3'b000 && inmf_rlen>32'h0)
                begin
                    ddr_read_len <= inmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {inmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_4_IHAL && fsm_fis_next==FSM_FIS_4_OUTMF)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= outmf_tlen ;
                if(outmf_rlen[2:0]==3'b000 && outmf_rlen>32'h0)
                begin
                    ddr_read_len <= outmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {outmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_4_OHAL && fsm_fis_next==FSM_FIS_4_RULE)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= rule_tlen ;
                if(rule_rlen[2:0]==3'b000 && rule_rlen>32'h0)
                begin
                    ddr_read_len <= rule_rlen ;
                end
                else
                begin
                    ddr_read_len <= {rule_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_4_CHAL || fsm_fis_curr==FSM_FIS_4_IHAL || fsm_fis_curr==FSM_FIS_4_OHAL  || fsm_fis_curr==FSM_FIS_4_RHAL)
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_true <= ddr_read_true ;
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr_read_cnt <= ddr_read_cnt + 32'h8 ;
                end
                else
                begin
                    ddr_read_cnt <= ddr_read_cnt ;
                end
            end
            else if(fsm_fis_curr!=FSM_FIS_5_CMD && fsm_fis_next==FSM_FIS_5_CMD)
            begin
                ddr_read_len <= CMD_RLEN ;
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= 32'b0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_5_CHAL && fsm_fis_next==FSM_FIS_5_INMF)
            begin
                ddr_read_true <= inmf_tlen ;
                ddr_read_cnt <= 32'b0 ;
                if(inmf_rlen[2:0]==3'b000 && inmf_rlen>32'h0)
                begin
                    ddr_read_len <= inmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {inmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_5_IHAL && fsm_fis_next==FSM_FIS_5_OUTMF)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= outmf_tlen ;
                if(outmf_rlen[2:0]==3'b000 && outmf_rlen>32'h0)
                begin
                    ddr_read_len <= outmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {outmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_5_OHAL && fsm_fis_next==FSM_FIS_5_RULE)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= rule_tlen ;
                if(rule_rlen[2:0]==3'b000 && rule_rlen>32'h0)
                begin
                    ddr_read_len <= rule_rlen ;
                end
                else
                begin
                    ddr_read_len <= {rule_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_5_CHAL || fsm_fis_curr==FSM_FIS_5_IHAL || fsm_fis_curr==FSM_FIS_5_OHAL  || fsm_fis_curr==FSM_FIS_5_RHAL)
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_true <= ddr_read_true ;
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr_read_cnt <= ddr_read_cnt + 32'h8 ;
                end
                else
                begin
                    ddr_read_cnt <= ddr_read_cnt ;
                end
            end
            else if(fsm_fis_curr!=FSM_FIS_6_CMD && fsm_fis_next==FSM_FIS_6_CMD)
            begin
                ddr_read_len <= CMD_RLEN ;
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= 32'b0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_6_CHAL && fsm_fis_next==FSM_FIS_6_INMF)
            begin
                ddr_read_true <= inmf_tlen ;
                ddr_read_cnt <= 32'b0 ;
                if(inmf_rlen[2:0]==3'b000 && inmf_rlen>32'h0)
                begin
                    ddr_read_len <= inmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {inmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_6_IHAL && fsm_fis_next==FSM_FIS_6_OUTMF)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= outmf_tlen ;
                if(outmf_rlen[2:0]==3'b000 && outmf_rlen>32'h0)
                begin
                    ddr_read_len <= outmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {outmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_6_OHAL && fsm_fis_next==FSM_FIS_6_RULE)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= rule_tlen ;
                if(rule_rlen[2:0]==3'b000 && rule_rlen>32'h0)
                begin
                    ddr_read_len <= rule_rlen ;
                end
                else
                begin
                    ddr_read_len <= {rule_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_6_CHAL || fsm_fis_curr==FSM_FIS_6_IHAL || fsm_fis_curr==FSM_FIS_6_OHAL  || fsm_fis_curr==FSM_FIS_6_RHAL)
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_true <= ddr_read_true ;
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr_read_cnt <= ddr_read_cnt + 32'h8 ;
                end
                else
                begin
                    ddr_read_cnt <= ddr_read_cnt ;
                end
            end
            else if(fsm_fis_curr!=FSM_FIS_7_CMD && fsm_fis_next==FSM_FIS_7_CMD)
            begin
                ddr_read_len <= CMD_RLEN ;
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= 32'b0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_7_CHAL && fsm_fis_next==FSM_FIS_7_INMF)
            begin
                ddr_read_true <= inmf_tlen ;
                ddr_read_cnt <= 32'b0 ;
                if(inmf_rlen[2:0]==3'b000 && inmf_rlen>32'h0)
                begin
                    ddr_read_len <= inmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {inmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_7_IHAL && fsm_fis_next==FSM_FIS_7_OUTMF)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= outmf_tlen ;
                if(outmf_rlen[2:0]==3'b000 && outmf_rlen>32'h0)
                begin
                    ddr_read_len <= outmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {outmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_7_OHAL && fsm_fis_next==FSM_FIS_7_RULE)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= rule_tlen ;
                if(rule_rlen[2:0]==3'b000 && rule_rlen>32'h0)
                begin
                    ddr_read_len <= rule_rlen ;
                end
                else
                begin
                    ddr_read_len <= {rule_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_7_CHAL || fsm_fis_curr==FSM_FIS_7_IHAL || fsm_fis_curr==FSM_FIS_7_OHAL  || fsm_fis_curr==FSM_FIS_7_RHAL)
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_true <= ddr_read_true ;
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr_read_cnt <= ddr_read_cnt + 32'h8 ;
                end
                else
                begin
                    ddr_read_cnt <= ddr_read_cnt ;
                end
            end
            else if(fsm_fis_curr!=FSM_FIS_8_CMD && fsm_fis_next==FSM_FIS_8_CMD)
            begin
                ddr_read_len <= CMD_RLEN ;
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= 32'b0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_8_CHAL && fsm_fis_next==FSM_FIS_8_INMF)
            begin
                ddr_read_true <= inmf_tlen ;
                ddr_read_cnt <= 32'b0 ;
                if(inmf_rlen[2:0]==3'b000 && inmf_rlen>32'h0)
                begin
                    ddr_read_len <= inmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {inmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_8_IHAL && fsm_fis_next==FSM_FIS_8_OUTMF)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= outmf_tlen ;
                if(outmf_rlen[2:0]==3'b000 && outmf_rlen>32'h0)
                begin
                    ddr_read_len <= outmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {outmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_8_OHAL && fsm_fis_next==FSM_FIS_8_RULE)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= rule_tlen ;
                if(rule_rlen[2:0]==3'b000 && rule_rlen>32'h0)
                begin
                    ddr_read_len <= rule_rlen ;
                end
                else
                begin
                    ddr_read_len <= {rule_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_8_CHAL || fsm_fis_curr==FSM_FIS_8_IHAL || fsm_fis_curr==FSM_FIS_8_OHAL  || fsm_fis_curr==FSM_FIS_8_RHAL)
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_true <= ddr_read_true ;
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr_read_cnt <= ddr_read_cnt + 32'h8 ;
                end
                else
                begin
                    ddr_read_cnt <= ddr_read_cnt ;
                end
            end
            else if(fsm_fis_curr!=FSM_FIS_9_CMD && fsm_fis_next==FSM_FIS_9_CMD)
            begin
                ddr_read_len <= CMD_RLEN ;
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= 32'b0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_9_CHAL && fsm_fis_next==FSM_FIS_9_INMF)
            begin
                ddr_read_true <= inmf_tlen ;
                ddr_read_cnt <= 32'b0 ;
                if(inmf_rlen[2:0]==3'b000 && inmf_rlen>32'h0)
                begin
                    ddr_read_len <= inmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {inmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_9_IHAL && fsm_fis_next==FSM_FIS_9_OUTMF)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= outmf_tlen ;
                if(outmf_rlen[2:0]==3'b000 && outmf_rlen>32'h0)
                begin
                    ddr_read_len <= outmf_rlen ;
                end
                else
                begin
                    ddr_read_len <= {outmf_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_9_OHAL && fsm_fis_next==FSM_FIS_9_RULE)
            begin
                ddr_read_cnt <= 32'b0 ;
                ddr_read_true <= rule_tlen ;
                if(rule_rlen[2:0]==3'b000 && rule_rlen>32'h0)
                begin
                    ddr_read_len <= rule_rlen ;
                end
                else
                begin
                    ddr_read_len <= {rule_rlen[31:3],3'b000} + 32'h8 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_9_CHAL || fsm_fis_curr==FSM_FIS_9_IHAL || fsm_fis_curr==FSM_FIS_9_OHAL  || fsm_fis_curr==FSM_FIS_9_RHAL)
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_true <= ddr_read_true ;
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr_read_cnt <= ddr_read_cnt + 32'h8 ;
                end
                else
                begin
                    ddr_read_cnt <= ddr_read_cnt ;
                end
            end
            else
            begin
                ddr_read_len <= ddr_read_len ;
                ddr_read_cnt <= ddr_read_cnt ;
                ddr_read_true <= ddr_read_true ;
            end
        end
    end                
                
    
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            ddr3_fcfifo_wr <= 1'b0 ;
            ddr3_fcfifo_wdata <= 80'b0 ;
            ddr3_fxfifo_wr <= 1'b0 ;
            ddr3_fxfifo_wdata <= 512'b0 ;
        end
        else
        begin
            ddr3_fxfifo_wr <= 1'b0 ;
            ddr3_fxfifo_wdata <= 512'b0 ;
            if(fsm_fis_curr==FSM_FIS_0_CMD && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {CMD_SADDR+fis_0_num*FIS_STEP_ADDRESS,CMD_RLEN,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_1_CMD && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {CMD_SADDR+fis_1_num*FIS_STEP_ADDRESS,CMD_RLEN,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_2_CMD && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {CMD_SADDR+fis_2_num*FIS_STEP_ADDRESS,CMD_RLEN,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_3_CMD && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {CMD_SADDR+fis_3_num*FIS_STEP_ADDRESS,CMD_RLEN,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_4_CMD && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {CMD_SADDR+fis_4_num*FIS_STEP_ADDRESS,CMD_RLEN,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_5_CMD && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {CMD_SADDR+fis_5_num*FIS_STEP_ADDRESS,CMD_RLEN,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_6_CMD && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {CMD_SADDR+fis_6_num*FIS_STEP_ADDRESS,CMD_RLEN,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_7_CMD && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {CMD_SADDR+fis_7_num*FIS_STEP_ADDRESS,CMD_RLEN,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_8_CMD && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {CMD_SADDR+fis_8_num*FIS_STEP_ADDRESS,CMD_RLEN,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_9_CMD && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {CMD_SADDR+fis_9_num*FIS_STEP_ADDRESS,CMD_RLEN,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_0_INMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {inmf_saddr+fis_0_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_0_OUTMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {outmf_saddr+fis_0_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_0_RULE && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {rule_saddr+fis_0_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_1_INMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {inmf_saddr+fis_1_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_1_OUTMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {outmf_saddr+fis_1_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_1_RULE && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {rule_saddr+fis_1_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_2_INMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {inmf_saddr+fis_2_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_2_OUTMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {outmf_saddr+fis_2_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_2_RULE && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {rule_saddr+fis_2_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_3_INMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {inmf_saddr+fis_3_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_3_OUTMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {outmf_saddr+fis_3_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_3_RULE && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {rule_saddr+fis_3_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_4_INMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {inmf_saddr+fis_4_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_4_OUTMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {outmf_saddr+fis_4_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_4_RULE && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {rule_saddr+fis_4_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_5_INMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {inmf_saddr+fis_5_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_5_OUTMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {outmf_saddr+fis_5_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_5_RULE && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {rule_saddr+fis_5_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_6_INMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {inmf_saddr+fis_6_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_6_OUTMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {outmf_saddr+fis_6_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_6_RULE && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {rule_saddr+fis_6_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_7_INMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {inmf_saddr+fis_7_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_7_OUTMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {outmf_saddr+fis_7_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_7_RULE && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {rule_saddr+fis_7_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_8_INMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {inmf_saddr+fis_8_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_8_OUTMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {outmf_saddr+fis_8_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_8_RULE && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {rule_saddr+fis_8_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_9_INMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {inmf_saddr+fis_9_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_9_OUTMF && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {outmf_saddr+fis_9_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else if(fsm_fis_curr==FSM_FIS_9_RULE && ddr3_fcfifo_afull==1'b0)
            begin
                ddr3_fcfifo_wr <= 1'b1 ;
                ddr3_fcfifo_wdata <= {rule_saddr+fis_9_num*FIS_STEP_ADDRESS,ddr_read_len,12'h8,3'b000,1'b1} ;
            end
            else
            begin
                ddr3_fcfifo_wr <= 1'b0 ;
                ddr3_fcfifo_wdata <= 80'b0 ;
            end
        end
    end
   
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            ddr3_info_wr <= 1'b0 ;
            ddr3_info_lwdata <= 256'b0 ;
            ddr3_info_hwdata <= 256'b0 ;
            ddr3_info_empty_r0 <= 1'b0 ;
            ddr3_info_empty_r1 <= 1'b0 ;
        end
        else
        begin
            ddr3_info_empty_r0 <= ddr3_info_empty ;
            ddr3_info_empty_r1 <= ddr3_info_empty_r0 ;
            if(fsm_fis_curr==FSM_FIS_0_IHAL || fsm_fis_curr==FSM_FIS_0_OHAL || fsm_fis_curr==FSM_FIS_0_RHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr3_info_wr <= 1'b1 ;
//                    ddr3_info_lwdata <= ddr3_rxfifo_wdata[255:0] ;
//                    ddr3_info_hwdata <= ddr3_rxfifo_wdata[511:256] ;
//                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],,ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[511:480]};
//                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[223:192],ddr3_rxfifo_wdata[255:224]} ;
                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[223:192]};
                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[319:288],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[511:480],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[255:224]} ;
                end
                else
                begin
                    ddr3_info_wr <= 1'b0 ;
                    ddr3_info_lwdata <= ddr3_info_lwdata ;
                    ddr3_info_hwdata <= ddr3_info_hwdata ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_1_IHAL || fsm_fis_curr==FSM_FIS_1_OHAL || fsm_fis_curr==FSM_FIS_1_RHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr3_info_wr <= 1'b1 ;
//                    ddr3_info_lwdata <= ddr3_rxfifo_wdata[255:0] ;
//                    ddr3_info_hwdata <= ddr3_rxfifo_wdata[511:256] ;
//                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],,ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[511:480]};
//                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[223:192],ddr3_rxfifo_wdata[255:224]} ;
                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[223:192]};
                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[319:288],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[511:480],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[255:224]} ;
                end
                else
                begin
                    ddr3_info_wr <= 1'b0 ;
                    ddr3_info_lwdata <= ddr3_info_lwdata ;
                    ddr3_info_hwdata <= ddr3_info_hwdata ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_2_IHAL || fsm_fis_curr==FSM_FIS_2_OHAL || fsm_fis_curr==FSM_FIS_2_RHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr3_info_wr <= 1'b1 ;
//                    ddr3_info_lwdata <= ddr3_rxfifo_wdata[255:0] ;
//                    ddr3_info_hwdata <= ddr3_rxfifo_wdata[511:256] ;
//                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],,ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[511:480]};
//                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[223:192],ddr3_rxfifo_wdata[255:224]} ;
                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[223:192]};
                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[319:288],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[511:480],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[255:224]} ;
                end
                else
                begin
                    ddr3_info_wr <= 1'b0 ;
                    ddr3_info_lwdata <= ddr3_info_lwdata ;
                    ddr3_info_hwdata <= ddr3_info_hwdata ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_3_IHAL || fsm_fis_curr==FSM_FIS_3_OHAL || fsm_fis_curr==FSM_FIS_3_RHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr3_info_wr <= 1'b1 ;
//                    ddr3_info_lwdata <= ddr3_rxfifo_wdata[255:0] ;
//                    ddr3_info_hwdata <= ddr3_rxfifo_wdata[511:256] ;
//                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],,ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[511:480]};
//                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[223:192],ddr3_rxfifo_wdata[255:224]} ;
                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[223:192]};
                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[319:288],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[511:480],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[255:224]} ;
                end
                else
                begin
                    ddr3_info_wr <= 1'b0 ;
                    ddr3_info_lwdata <= ddr3_info_lwdata ;
                    ddr3_info_hwdata <= ddr3_info_hwdata ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_4_IHAL || fsm_fis_curr==FSM_FIS_4_OHAL || fsm_fis_curr==FSM_FIS_4_RHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr3_info_wr <= 1'b1 ;
//                    ddr3_info_lwdata <= ddr3_rxfifo_wdata[255:0] ;
//                    ddr3_info_hwdata <= ddr3_rxfifo_wdata[511:256] ;
//                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],,ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[511:480]};
//                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[223:192],ddr3_rxfifo_wdata[255:224]} ;
                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[223:192]};
                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[319:288],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[511:480],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[255:224]} ;
                end
                else
                begin
                    ddr3_info_wr <= 1'b0 ;
                    ddr3_info_lwdata <= ddr3_info_lwdata ;
                    ddr3_info_hwdata <= ddr3_info_hwdata ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_5_IHAL || fsm_fis_curr==FSM_FIS_5_OHAL || fsm_fis_curr==FSM_FIS_5_RHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr3_info_wr <= 1'b1 ;
//                    ddr3_info_lwdata <= ddr3_rxfifo_wdata[255:0] ;
//                    ddr3_info_hwdata <= ddr3_rxfifo_wdata[511:256] ;
//                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],,ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[511:480]};
//                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[223:192],ddr3_rxfifo_wdata[255:224]} ;
                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[223:192]};
                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[319:288],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[511:480],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[255:224]} ;
                end
                else
                begin
                    ddr3_info_wr <= 1'b0 ;
                    ddr3_info_lwdata <= ddr3_info_lwdata ;
                    ddr3_info_hwdata <= ddr3_info_hwdata ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_6_IHAL || fsm_fis_curr==FSM_FIS_6_OHAL || fsm_fis_curr==FSM_FIS_6_RHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr3_info_wr <= 1'b1 ;
//                    ddr3_info_lwdata <= ddr3_rxfifo_wdata[255:0] ;
//                    ddr3_info_hwdata <= ddr3_rxfifo_wdata[511:256] ;
//                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],,ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[511:480]};
//                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[223:192],ddr3_rxfifo_wdata[255:224]} ;
                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[223:192]};
                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[319:288],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[511:480],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[255:224]} ;
                end
                else
                begin
                    ddr3_info_wr <= 1'b0 ;
                    ddr3_info_lwdata <= ddr3_info_lwdata ;
                    ddr3_info_hwdata <= ddr3_info_hwdata ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_7_IHAL || fsm_fis_curr==FSM_FIS_7_OHAL || fsm_fis_curr==FSM_FIS_7_RHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr3_info_wr <= 1'b1 ;
//                    ddr3_info_lwdata <= ddr3_rxfifo_wdata[255:0] ;
//                    ddr3_info_hwdata <= ddr3_rxfifo_wdata[511:256] ;
//                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],,ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[511:480]};
//                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[223:192],ddr3_rxfifo_wdata[255:224]} ;
                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[223:192]};
                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[319:288],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[511:480],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[255:224]} ;
                end
                else
                begin
                    ddr3_info_wr <= 1'b0 ;
                    ddr3_info_lwdata <= ddr3_info_lwdata ;
                    ddr3_info_hwdata <= ddr3_info_hwdata ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_8_IHAL || fsm_fis_curr==FSM_FIS_8_OHAL || fsm_fis_curr==FSM_FIS_8_RHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr3_info_wr <= 1'b1 ;
//                    ddr3_info_lwdata <= ddr3_rxfifo_wdata[255:0] ;
//                    ddr3_info_hwdata <= ddr3_rxfifo_wdata[511:256] ;
//                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],,ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[511:480]};
//                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[223:192],ddr3_rxfifo_wdata[255:224]} ;
                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[223:192]};
                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[319:288],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[511:480],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[255:224]} ;
                end
                else
                begin
                    ddr3_info_wr <= 1'b0 ;
                    ddr3_info_lwdata <= ddr3_info_lwdata ;
                    ddr3_info_hwdata <= ddr3_info_hwdata ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_9_IHAL || fsm_fis_curr==FSM_FIS_9_OHAL || fsm_fis_curr==FSM_FIS_9_RHAL)
            begin
                if(ddr3_rxfifo_wr==1'b1 && ddr3_frx_sign==1'b1)
                begin
                    ddr3_info_wr <= 1'b1 ;
//                    ddr3_info_lwdata <= ddr3_rxfifo_wdata[255:0] ;
//                    ddr3_info_hwdata <= ddr3_rxfifo_wdata[511:256] ;
//                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],,ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[511:480]};
//                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[223:192],ddr3_rxfifo_wdata[255:224]} ;
                    ddr3_info_lwdata <= {ddr3_rxfifo_wdata[287:256],ddr3_rxfifo_wdata[351:320],ddr3_rxfifo_wdata[415:384],ddr3_rxfifo_wdata[479:448],ddr3_rxfifo_wdata[31:0],ddr3_rxfifo_wdata[95:64],ddr3_rxfifo_wdata[159:128],ddr3_rxfifo_wdata[223:192]};
                    ddr3_info_hwdata <= {ddr3_rxfifo_wdata[319:288],ddr3_rxfifo_wdata[383:352],ddr3_rxfifo_wdata[447:416],ddr3_rxfifo_wdata[511:480],ddr3_rxfifo_wdata[63:32],ddr3_rxfifo_wdata[127:96],ddr3_rxfifo_wdata[191:160],ddr3_rxfifo_wdata[255:224]} ;
                end
                else
                begin
                    ddr3_info_wr <= 1'b0 ;
                    ddr3_info_lwdata <= ddr3_info_lwdata ;
                    ddr3_info_hwdata <= ddr3_info_hwdata ;
                end
            end
            else
            begin
                ddr3_info_wr <= 1'b0 ;
                ddr3_info_lwdata <= ddr3_info_lwdata ;
                ddr3_info_hwdata <= ddr3_info_hwdata ;
            end
        end
    end
    
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            ddr3_info_lrpre <= 1'b0 ;
            ddr3_info_hrpre <= 1'b0 ;
            ddr3_info_rdcnt <= 32'b0 ;
        end
        else
        begin
            if(fsm_fis_curr==FSM_FIS_0_IHAL || fsm_fis_curr==FSM_FIS_0_OHAL || fsm_fis_curr==FSM_FIS_0_RHAL)
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    if(ddr3_info_rdcnt<ddr_read_true)
                    begin
                        ddr3_info_hrpre <= ddr3_info_lrd ;
                        //ddr3_info_lrpre
                        if(ddr3_info_lrd==1'b0 && ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                        end
                        //ddr3_info_rdcnt
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        end
                        else
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                    else if(ddr3_info_rdcnt==ddr_read_true && ddr_read_true[0]==1'b1)
                    begin
                        ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        ddr3_info_lrpre <= 1'b0 ;
                        ddr3_info_hrpre <= 1'b1 ;
                    end
                    else
                    begin
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                            ddr3_info_hrpre <= 1'b1 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h2 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                            ddr3_info_hrpre <= 1'b0 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                end
                else
                begin
                    ddr3_info_lrpre <= 1'b0 ;
                    ddr3_info_hrpre <= 1'b0 ;
                    ddr3_info_rdcnt <= 32'b0 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_1_IHAL || fsm_fis_curr==FSM_FIS_1_OHAL || fsm_fis_curr==FSM_FIS_1_RHAL)
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    if(ddr3_info_rdcnt<ddr_read_true)
                    begin
                        ddr3_info_hrpre <= ddr3_info_lrd ;
                        //ddr3_info_lrpre
                        if(ddr3_info_lrd==1'b0 && ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                        end
                        //ddr3_info_rdcnt
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        end
                        else
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                    else if(ddr3_info_rdcnt==ddr_read_true && ddr_read_true[0]==1'b1)
                    begin
                        ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        ddr3_info_lrpre <= 1'b0 ;
                        ddr3_info_hrpre <= 1'b1 ;
                    end
                    else
                    begin
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                            ddr3_info_hrpre <= 1'b1 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h2 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                            ddr3_info_hrpre <= 1'b0 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                end
                else
                begin
                    ddr3_info_lrpre <= 1'b0 ;
                    ddr3_info_hrpre <= 1'b0 ;
                    ddr3_info_rdcnt <= 32'b0 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_2_IHAL || fsm_fis_curr==FSM_FIS_2_OHAL || fsm_fis_curr==FSM_FIS_2_RHAL)
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    if(ddr3_info_rdcnt<ddr_read_true)
                    begin
                        ddr3_info_hrpre <= ddr3_info_lrd ;
                        //ddr3_info_lrpre
                        if(ddr3_info_lrd==1'b0 && ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                        end
                        //ddr3_info_rdcnt
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        end
                        else
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                    else if(ddr3_info_rdcnt==ddr_read_true && ddr_read_true[0]==1'b1)
                    begin
                        ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        ddr3_info_lrpre <= 1'b0 ;
                        ddr3_info_hrpre <= 1'b1 ;
                    end
                    else
                    begin
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                            ddr3_info_hrpre <= 1'b1 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h2 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                            ddr3_info_hrpre <= 1'b0 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                end
                else
                begin
                    ddr3_info_lrpre <= 1'b0 ;
                    ddr3_info_hrpre <= 1'b0 ;
                    ddr3_info_rdcnt <= 32'b0 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_3_IHAL || fsm_fis_curr==FSM_FIS_3_OHAL || fsm_fis_curr==FSM_FIS_3_RHAL)
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    if(ddr3_info_rdcnt<ddr_read_true)
                    begin
                        ddr3_info_hrpre <= ddr3_info_lrd ;
                        //ddr3_info_lrpre
                        if(ddr3_info_lrd==1'b0 && ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                        end
                        //ddr3_info_rdcnt
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        end
                        else
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                    else if(ddr3_info_rdcnt==ddr_read_true && ddr_read_true[0]==1'b1)
                    begin
                        ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        ddr3_info_lrpre <= 1'b0 ;
                        ddr3_info_hrpre <= 1'b1 ;
                    end
                    else
                    begin
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                            ddr3_info_hrpre <= 1'b1 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h2 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                            ddr3_info_hrpre <= 1'b0 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                end
                else
                begin
                    ddr3_info_lrpre <= 1'b0 ;
                    ddr3_info_hrpre <= 1'b0 ;
                    ddr3_info_rdcnt <= 32'b0 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_4_IHAL || fsm_fis_curr==FSM_FIS_4_OHAL || fsm_fis_curr==FSM_FIS_4_RHAL)
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    if(ddr3_info_rdcnt<ddr_read_true)
                    begin
                        ddr3_info_hrpre <= ddr3_info_lrd ;
                        //ddr3_info_lrpre
                        if(ddr3_info_lrd==1'b0 && ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                        end
                        //ddr3_info_rdcnt
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        end
                        else
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                    else if(ddr3_info_rdcnt==ddr_read_true && ddr_read_true[0]==1'b1)
                    begin
                        ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        ddr3_info_lrpre <= 1'b0 ;
                        ddr3_info_hrpre <= 1'b1 ;
                    end
                    else
                    begin
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                            ddr3_info_hrpre <= 1'b1 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h2 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                            ddr3_info_hrpre <= 1'b0 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                end
                else
                begin
                    ddr3_info_lrpre <= 1'b0 ;
                    ddr3_info_hrpre <= 1'b0 ;
                    ddr3_info_rdcnt <= 32'b0 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_5_IHAL || fsm_fis_curr==FSM_FIS_5_OHAL || fsm_fis_curr==FSM_FIS_5_RHAL)
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    if(ddr3_info_rdcnt<ddr_read_true)
                    begin
                        ddr3_info_hrpre <= ddr3_info_lrd ;
                        //ddr3_info_lrpre
                        if(ddr3_info_lrd==1'b0 && ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                        end
                        //ddr3_info_rdcnt
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        end
                        else
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                    else if(ddr3_info_rdcnt==ddr_read_true && ddr_read_true[0]==1'b1)
                    begin
                        ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        ddr3_info_lrpre <= 1'b0 ;
                        ddr3_info_hrpre <= 1'b1 ;
                    end
                    else
                    begin
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                            ddr3_info_hrpre <= 1'b1 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h2 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                            ddr3_info_hrpre <= 1'b0 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                end
                else
                begin
                    ddr3_info_lrpre <= 1'b0 ;
                    ddr3_info_hrpre <= 1'b0 ;
                    ddr3_info_rdcnt <= 32'b0 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_6_IHAL || fsm_fis_curr==FSM_FIS_6_OHAL || fsm_fis_curr==FSM_FIS_6_RHAL)
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    if(ddr3_info_rdcnt<ddr_read_true)
                    begin
                        ddr3_info_hrpre <= ddr3_info_lrd ;
                        //ddr3_info_lrpre
                        if(ddr3_info_lrd==1'b0 && ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                        end
                        //ddr3_info_rdcnt
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        end
                        else
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                    else if(ddr3_info_rdcnt==ddr_read_true && ddr_read_true[0]==1'b1)
                    begin
                        ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        ddr3_info_lrpre <= 1'b0 ;
                        ddr3_info_hrpre <= 1'b1 ;
                    end
                    else
                    begin
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                            ddr3_info_hrpre <= 1'b1 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h2 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                            ddr3_info_hrpre <= 1'b0 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                end
                else
                begin
                    ddr3_info_lrpre <= 1'b0 ;
                    ddr3_info_hrpre <= 1'b0 ;
                    ddr3_info_rdcnt <= 32'b0 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_7_IHAL || fsm_fis_curr==FSM_FIS_7_OHAL || fsm_fis_curr==FSM_FIS_7_RHAL)
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    if(ddr3_info_rdcnt<ddr_read_true)
                    begin
                        ddr3_info_hrpre <= ddr3_info_lrd ;
                        //ddr3_info_lrpre
                        if(ddr3_info_lrd==1'b0 && ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                        end
                        //ddr3_info_rdcnt
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        end
                        else
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                    else if(ddr3_info_rdcnt==ddr_read_true && ddr_read_true[0]==1'b1)
                    begin
                        ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        ddr3_info_lrpre <= 1'b0 ;
                        ddr3_info_hrpre <= 1'b1 ;
                    end
                    else
                    begin
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                            ddr3_info_hrpre <= 1'b1 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h2 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                            ddr3_info_hrpre <= 1'b0 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                end
                else
                begin
                    ddr3_info_lrpre <= 1'b0 ;
                    ddr3_info_hrpre <= 1'b0 ;
                    ddr3_info_rdcnt <= 32'b0 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_8_IHAL || fsm_fis_curr==FSM_FIS_8_OHAL || fsm_fis_curr==FSM_FIS_8_RHAL)
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    if(ddr3_info_rdcnt<ddr_read_true)
                    begin
                        ddr3_info_hrpre <= ddr3_info_lrd ;
                        //ddr3_info_lrpre
                        if(ddr3_info_lrd==1'b0 && ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                        end
                        //ddr3_info_rdcnt
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        end
                        else
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                    else if(ddr3_info_rdcnt==ddr_read_true && ddr_read_true[0]==1'b1)
                    begin
                        ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        ddr3_info_lrpre <= 1'b0 ;
                        ddr3_info_hrpre <= 1'b1 ;
                    end
                    else
                    begin
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                            ddr3_info_hrpre <= 1'b1 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h2 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                            ddr3_info_hrpre <= 1'b0 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                end
                else
                begin
                    ddr3_info_lrpre <= 1'b0 ;
                    ddr3_info_hrpre <= 1'b0 ;
                    ddr3_info_rdcnt <= 32'b0 ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_9_IHAL || fsm_fis_curr==FSM_FIS_9_OHAL || fsm_fis_curr==FSM_FIS_9_RHAL)
            begin
                if(ddr_read_cnt>=ddr_read_len)
                begin
                    if(ddr3_info_rdcnt<ddr_read_true)
                    begin
                        ddr3_info_hrpre <= ddr3_info_lrd ;
                        //ddr3_info_lrpre
                        if(ddr3_info_lrd==1'b0 && ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                        end
                        //ddr3_info_rdcnt
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        end
                        else
                        begin
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                    else if(ddr3_info_rdcnt==ddr_read_true && ddr_read_true[0]==1'b1)
                    begin
                        ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h1 ;
                        ddr3_info_lrpre <= 1'b0 ;
                        ddr3_info_hrpre <= 1'b1 ;
                    end
                    else
                    begin
                        if(ddr3_info_empty==1'b0)
                        begin
                            ddr3_info_lrpre <= 1'b1 ;
                            ddr3_info_hrpre <= 1'b1 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt + 32'h2 ;
                        end
                        else
                        begin
                            ddr3_info_lrpre <= 1'b0 ;
                            ddr3_info_hrpre <= 1'b0 ;
                            ddr3_info_rdcnt <= ddr3_info_rdcnt ;
                        end
                    end
                end
                else
                begin
                    ddr3_info_lrpre <= 1'b0 ;
                    ddr3_info_hrpre <= 1'b0 ;
                    ddr3_info_rdcnt <= 32'b0 ;
                end
            end
            else
            begin
                ddr3_info_lrpre <= 1'b0 ;
                ddr3_info_hrpre <= 1'b0 ;
                ddr3_info_rdcnt <= 32'b0 ;
            end
        end
    end
    
    assign      ddr3_info_lrd = ddr3_info_lrpre & (~ddr3_info_empty) ;
    assign      ddr3_info_hrd = ddr3_info_hrpre & (~ddr3_info_empty) ;
    
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            inmf_ena <= 1'b0 ;
            inmf_addra <= 8'b0 ;
            inmf_dina <= 32'b0 ;
            outmf_ena <= 1'b0 ;
            outmf_addra <= 5'b0 ;
            outmf_dina <= 32'b0 ;
            rule_ena <= 1'b0 ;
            rule_addra <= 29'b0 ;
            rule_dina <= 32'b0 ;
        end
        else
        begin
            if(fsm_fis_curr==FSM_FIS_0_IHAL||fsm_fis_curr==FSM_FIS_1_IHAL||fsm_fis_curr==FSM_FIS_2_IHAL||fsm_fis_curr==FSM_FIS_3_IHAL||fsm_fis_curr==FSM_FIS_4_IHAL||fsm_fis_curr==FSM_FIS_5_IHAL||fsm_fis_curr==FSM_FIS_6_IHAL||fsm_fis_curr==FSM_FIS_7_IHAL||fsm_fis_curr==FSM_FIS_8_IHAL||fsm_fis_curr==FSM_FIS_9_IHAL)
            begin
                outmf_ena <= 1'b0 ;
                rule_ena <= 1'b0 ;
                if(ddr3_info_lrd==1'b1 && ddr3_info_hrd==1'b0)
                begin
                    inmf_ena   <= 1'b1 ;
                    inmf_dina  <= ddr3_info_lrdata ;
                    if(ddr3_info_rdcnt==32'h1)
                    begin
                        inmf_addra <= 8'b0 ;
                    end
                    else
                    begin
                        inmf_addra <= inmf_addra + 8'h1 ;
                    end
                end
                else if(ddr3_info_lrd==1'b0 && ddr3_info_hrd==1'b1 && (inmf_addra<inmf_tlen-8'h1))
                begin
                    inmf_ena   <= 1'b1 ;
                    inmf_addra <= inmf_addra + 8'h1 ;
                    inmf_dina  <= ddr3_info_hrdata ;
                end
                else
                begin
                    inmf_ena   <= 1'b0 ;
                    inmf_addra <= inmf_addra ;
                    inmf_dina <= inmf_dina ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_0_OHAL||fsm_fis_curr==FSM_FIS_1_OHAL||fsm_fis_curr==FSM_FIS_2_OHAL||fsm_fis_curr==FSM_FIS_3_OHAL||fsm_fis_curr==FSM_FIS_4_OHAL||fsm_fis_curr==FSM_FIS_5_OHAL||fsm_fis_curr==FSM_FIS_6_OHAL||fsm_fis_curr==FSM_FIS_7_OHAL||fsm_fis_curr==FSM_FIS_8_OHAL||fsm_fis_curr==FSM_FIS_9_OHAL)
            begin
                inmf_ena <= 1'b0 ;
                rule_ena <= 1'b0 ;
                if(ddr3_info_lrd==1'b1 && ddr3_info_hrd==1'b0)
                begin
                    outmf_ena   <= 1'b1 ;
                    outmf_dina  <= ddr3_info_lrdata ;
                    if(ddr3_info_rdcnt==32'h1)
                    begin
                        outmf_addra <= 5'b0 ;
                    end
                    else
                    begin
                        outmf_addra <= outmf_addra + 5'h1 ;
                    end
                end
                else if(ddr3_info_lrd==1'b0 && ddr3_info_hrd==1'b1 && (outmf_addra<outmf_tlen-5'h1))
                begin
                    outmf_ena   <= 1'b1 ;
                    outmf_addra <= outmf_addra + 5'h1 ;
                    outmf_dina  <= ddr3_info_hrdata ;
                end
                else
                begin
                    outmf_ena   <= 1'b0 ;
                    outmf_addra <= outmf_addra ;
                    outmf_dina <= outmf_dina ;
                end
            end
            else if(fsm_fis_curr==FSM_FIS_0_RHAL||fsm_fis_curr==FSM_FIS_1_RHAL||fsm_fis_curr==FSM_FIS_2_RHAL||fsm_fis_curr==FSM_FIS_3_RHAL||fsm_fis_curr==FSM_FIS_4_RHAL||fsm_fis_curr==FSM_FIS_5_RHAL||fsm_fis_curr==FSM_FIS_6_RHAL||fsm_fis_curr==FSM_FIS_7_RHAL||fsm_fis_curr==FSM_FIS_8_RHAL||fsm_fis_curr==FSM_FIS_9_RHAL)
            begin
                inmf_ena <= 1'b0 ;
                outmf_ena <= 1'b0 ;
                if(ddr3_info_lrd==1'b1 && ddr3_info_hrd==1'b0)
                begin
                    rule_ena   <= 1'b1 ;
                    rule_dina  <= ddr3_info_lrdata ;
                    if(ddr3_info_rdcnt==32'h1)
                    begin
                        rule_addra <= 29'b0 ;
                    end
                    else
                    begin
                        rule_addra <= rule_addra + 29'h1 ;
                    end
                end
                else if(ddr3_info_lrd==1'b0 && ddr3_info_hrd==1'b1 && (rule_addra<rule_tlen-29'h1))
                begin
                    rule_ena   <= 1'b1 ;
                    rule_addra <= rule_addra + 29'h1 ;
                    rule_dina  <= ddr3_info_hrdata ;
                end
                else
                begin
                    rule_ena   <= 1'b0 ;
                    rule_addra <= rule_addra ;
                    rule_dina <= rule_dina ;
                end
            end
            else
            begin
                inmf_ena <= 1'b0 ;
                outmf_ena <= 1'b0 ;
                rule_ena <= 1'b0 ;
            end
        end
    end
    
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            idata_dpram_wea <= 1'b0 ;
            idata_dpram_addra <= 7'b0 ;
            idata_dpram_dina <= 32'b0 ;
        end
        else
        begin
            //idata_dpram_wea/idata_dpram_addra/idata_dpram_dina
            if(localbus_bs==1'b1 && localbus_wr==1'b1 && (localbus_addr>=FIS_0_IDAT_0_ADDR&&localbus_addr<=FIS_9_IDAT_2_ADDR))
            begin
                idata_dpram_wea <= 1'b1 ;
                idata_dpram_dina <= localbus_wdat ;
                idata_dpram_addra <= localbus_addr-FIS_0_IDAT_0_ADDR;
            end
            else
            begin
                idata_dpram_wea <= 1'b0 ;
                idata_dpram_addra <= idata_dpram_addra ;
                idata_dpram_dina <= idata_dpram_dina ;
            end
        end
    end
    
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            idata_dpram_enb <= 1'b0 ;
            idata_dpram_addrb <= 5'b0 ;
            idata_dpram_enb_r0 <= 1'b0 ;
            idata_dpram_enb_r1 <= 1'b0 ;
        end
        else
        begin
            idata_dpram_enb_r0 <= idata_dpram_enb ;
            idata_dpram_enb_r1 <= idata_dpram_enb_r0 ;
            if(fsm_fis_curr==FSM_FIS_0_NDAT)
            begin
                idata_dpram_enb <= 1'b1 ;
                idata_dpram_addrb <= 5'h0 ;
            end
            else if(fsm_fis_curr==FSM_FIS_1_NDAT)
            begin
                idata_dpram_enb <= 1'b1 ;
                idata_dpram_addrb <= 5'h4 ;
            end
            else if(fsm_fis_curr==FSM_FIS_2_NDAT)
            begin
                idata_dpram_enb <= 1'b1 ;
                idata_dpram_addrb <= 5'h8 ;
            end
            else if(fsm_fis_curr==FSM_FIS_3_NDAT)
            begin
                idata_dpram_enb <= 1'b1 ;
                idata_dpram_addrb <= 5'hc ;
            end
            else if(fsm_fis_curr==FSM_FIS_4_NDAT)
            begin
                idata_dpram_enb <= 1'b1 ;
                idata_dpram_addrb <= 5'h10 ;
            end
            else if(fsm_fis_curr==FSM_FIS_5_NDAT)
            begin
                idata_dpram_enb <= 1'b1 ;
                idata_dpram_addrb <= 5'h14 ;
            end
            else if(fsm_fis_curr==FSM_FIS_6_NDAT)
            begin
                idata_dpram_enb <= 1'b1 ;
                idata_dpram_addrb <= 5'h18 ;
            end
            else if(fsm_fis_curr==FSM_FIS_7_NDAT)
            begin
                idata_dpram_enb <= 1'b1 ;
                idata_dpram_addrb <= 5'h1c ;
            end
            else if(fsm_fis_curr==FSM_FIS_8_NDAT)
            begin
                idata_dpram_enb <= 1'b1 ;
                idata_dpram_addrb <= 5'h20 ;
            end
            else if(fsm_fis_curr==FSM_FIS_9_NDAT)
            begin
                idata_dpram_enb <= 1'b1 ;
                idata_dpram_addrb <= 5'h24 ;
            end
            else if(fsm_fis_curr==FSM_FIS_0_DHAL||fsm_fis_curr==FSM_FIS_1_DHAL||fsm_fis_curr==FSM_FIS_2_DHAL||fsm_fis_curr==FSM_FIS_3_DHAL||fsm_fis_curr==FSM_FIS_4_DHAL||fsm_fis_curr==FSM_FIS_5_DHAL||fsm_fis_curr==FSM_FIS_6_DHAL||fsm_fis_curr==FSM_FIS_7_DHAL||fsm_fis_curr==FSM_FIS_8_DHAL||fsm_fis_curr==FSM_FIS_9_DHAL)
            begin
                if(idata_dpram_addrb[1:0]==2'b10)
                begin
                    idata_dpram_enb <= 1'b0 ;
                    idata_dpram_addrb <= idata_dpram_addrb;
                end
                else
                begin
                    idata_dpram_enb <= 1'b1 ;
                    idata_dpram_addrb <= idata_dpram_addrb + 5'h1 ;
                end
            end
            else
            begin
                idata_dpram_enb <= 1'b0 ;
                idata_dpram_addrb <= 5'b0 ;
            end
        end
    end
    
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            in_data_ena <= 1'b0 ;
            in_data_addra <= 2'b0 ;
            in_data_dina <= 32'b0 ;
        end
        else
        begin
            if(idata_dpram_enb_r0==1'b1 && idata_dpram_enb_r1==1'b0)
            begin
                in_data_ena <= 1'b1 ;
                in_data_addra <= 2'b0 ;
                in_data_dina <= idata_dpram_doutb ;
            end
            else if(idata_dpram_enb_r0==1'b1)
            begin
                in_data_ena <= 1'b1 ;
                in_data_addra <= in_data_addra + 2'h1 ;
                in_data_dina <= idata_dpram_doutb ;
            end
            else
            begin
                in_data_ena <= 1'b0 ;
                in_data_addra <= in_data_addra ;
                in_data_dina <= in_data_dina ;
            end
        end
    end
    
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_start <= 1'b0 ;
        end
        else
        begin
            if(fsm_fis_curr==FSM_FIS_0_START||fsm_fis_curr==FSM_FIS_1_START||fsm_fis_curr==FSM_FIS_2_START||fsm_fis_curr==FSM_FIS_3_START||fsm_fis_curr==FSM_FIS_4_START||fsm_fis_curr==FSM_FIS_5_START||fsm_fis_curr==FSM_FIS_6_START||fsm_fis_curr==FSM_FIS_7_START||fsm_fis_curr==FSM_FIS_8_START||fsm_fis_curr==FSM_FIS_9_START)
            begin
                fis_start <= 1'b1 ;
            end
            else
            begin
                fis_start <= 1'b0 ;
            end
        end
    end
    
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            wait_cycle_cnt <= 2'b0 ;
        end
        else
        begin
            if(fsm_fis_curr==FSM_FIS_0_WAIT||fsm_fis_curr==FSM_FIS_1_WAIT||fsm_fis_curr==FSM_FIS_2_WAIT||fsm_fis_curr==FSM_FIS_3_WAIT||fsm_fis_curr==FSM_FIS_4_WAIT||fsm_fis_curr==FSM_FIS_5_WAIT||fsm_fis_curr==FSM_FIS_6_WAIT||fsm_fis_curr==FSM_FIS_7_WAIT||fsm_fis_curr==FSM_FIS_8_WAIT||fsm_fis_curr==FSM_FIS_9_WAIT)
            begin
                if(wait_cycle_cnt==2'b11)
                begin
                    wait_cycle_cnt <= wait_cycle_cnt ;
                end
                else
                begin
                    wait_cycle_cnt <= wait_cycle_cnt + 2'h1 ;
                end
            end
            else
            begin
                wait_cycle_cnt <= 2'b0 ;
            end
        end
    end
   
    usr_idata_dpram u_usr_idata_dpram(
    .clka                  ( usr_synclk           ),
    .wea                   ( idata_dpram_wea      ),
    .addra                 ( idata_dpram_addra[6:2]),
    .dina                  ( idata_dpram_dina     ),
    .clkb                  ( usr_synclk           ),
    .enb                   ( idata_dpram_enb      ),
    .addrb                 ( idata_dpram_addrb    ),
    .doutb                 ( idata_dpram_doutb    ) 
    );   
    
    ddr_info_fifo ddr_info_lfifo(
    .rst                   ( ap_rst                ),
    .wr_clk                ( usr_synclk            ),
    .rd_clk                ( usr_synclk            ),
    .wr_en                 ( ddr3_info_wr          ),
    .din                   ( ddr3_info_lwdata      ),
    .prog_full             ( ddr3_rxfifo_afull     ),
    .full                  (                       ),
    .rd_en                 ( ddr3_info_lrd         ),
    .dout                  ( ddr3_info_lrdata      ),
    .wr_rst_busy           (                       ),
    .rd_rst_busy           (                       ),
    .empty                 (                       )
    );
    ddr_info_fifo ddr_info_hfifo(
    .rst                   ( ap_rst                ),
    .wr_clk                ( usr_synclk            ),
    .rd_clk                ( usr_synclk            ),
    .wr_en                 ( ddr3_info_wr          ),
    .din                   ( ddr3_info_hwdata      ),
    .prog_full             (                       ),
    .full                  (                       ),
    .rd_en                 ( ddr3_info_hrd         ),
    .dout                  ( ddr3_info_hrdata      ),
    .wr_rst_busy           (                       ),
    .rd_rst_busy           (                       ),
    .empty                 ( ddr3_info_empty       )
    );             
    //====================================================================//
    //-------------------------------  end  ------------------------------//
    //====================================================================//

endmodule
