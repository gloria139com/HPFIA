
`timescale 1ns / 1ps

module fis_unit(
    //clock and reset signals.
    usr_synclk          ,
    sys_rst_p           ,
    
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
    pc_reg_start        ,
    pc_ap_start         ,
    pc_fis_done         ,
    pc_fis_return       ,
    
    localbus_bs         ,
    localbus_wr         ,
    localbus_addr       ,
    localbus_wdat       ,
    pc_fis_rst          ,
    pc_fis_start        ,
   
    vio_fis_rst         ,
    vio_fis_start       ,
    vio_fis_num         
    );
    //parameter defination.
    parameter       DEBUG_ENABLE       = 1'b1         ;
    parameter       FIS_0_DONE_ADDR    = 24'h2140     ;
    parameter       FIS_1_DONE_ADDR    = 24'h2144     ;
    parameter       FIS_2_DONE_ADDR    = 24'h2148     ;
    parameter       FIS_3_DONE_ADDR    = 24'h214c     ;
    parameter       FIS_4_DONE_ADDR    = 24'h2150     ;
    parameter       FIS_5_DONE_ADDR    = 24'h2154     ;
    parameter       FIS_6_DONE_ADDR    = 24'h2158     ;
    parameter       FIS_7_DONE_ADDR    = 24'h215c     ;
    parameter       FIS_8_DONE_ADDR    = 24'h2258     ;
    parameter       FIS_9_DONE_ADDR    = 24'h225c     ;
    
    //-------------------------------------------------------------------
    // Defination of Ports
    //-------------------------------------------------------------------
    //clock and reset signals.
    input  wire  [00:0]       usr_synclk            ;
    input  wire  [00:0]       sys_rst_p             ;
    
    input  wire  [00:0]       inmf_ena              ;
    input  wire  [07:0]       inmf_addra            ;
    input  wire  [31:0]       inmf_dina             ;
    input  wire  [00:0]       outmf_ena             ;
    input  wire  [04:0]       outmf_addra           ;
    input  wire  [31:0]       outmf_dina            ;
    input  wire  [00:0]       rule_ena              ;
    input  wire  [28:0]       rule_addra            ;
    input  wire  [31:0]       rule_dina             ;
    input  wire  [00:0]       in_data_ena           ;
    input  wire  [31:0]       in_data_addra         ;
    input  wire  [31:0]       in_data_dina          ;
    input  wire  [127:0]      fis_dim               ;
    input  wire  [04:0]       output_num            ;
    input  wire  [00:0]       pc_reg_start          ;
    input  wire  [00:0]       pc_ap_start           ;
    output reg   [00:0]       pc_fis_done           ;
    output reg   [31:0]       pc_fis_return         ;
    
    input  wire  [00:0]       localbus_bs           ;
    input  wire  [00:0]       localbus_wr           ;
    input  wire  [23:0]       localbus_addr         ;
    input  wire  [63:0]       localbus_wdat         ;
    input  wire  [00:0]       pc_fis_rst            ;
    input  wire  [00:0]       pc_fis_start          ;
    
    input  wire  [00:0]       vio_fis_rst           ;
    input  wire  [00:0]       vio_fis_start         ;
    input  wire  [15:0]       vio_fis_num           ;
    //====================================================================//
    //----------------------internal signals------------------------------//
    //====================================================================//
    wire  [00:0]         ap_rst                     ;
    wire  [00:0]         ap_start                   ;
    wire  [00:0]         ap_idle                    ;
    wire  [00:0]         ap_done                    ;
    wire  [00:0]         ap_ready                   ;
    wire  [31:0]         ap_return                  ;
    reg   [127:0]        fis_dim_r                  ;
    reg   [11:0]         input_nums_r0              ;
    reg   [11:0]         input_nums_r1              ;
    reg   [11:0]         input_nums_r2              ;
    reg   [04:0]         output_num_r               ;
    reg   [03:0]         ap_done_cnt                ;
    reg   [00:0]         ap_ip_rstp                 ;
    reg   [00:0]         ap_done_r                  ;

    wire  [03:0]         input_dim                  ;
    wire  [03:0]         input_nums_address0        ;
    wire  [00:0]         input_nums_ce0             ;
    reg   [11:0]         input_nums_q0              ;
    wire  [04:0]         input_nums_address         ;
    wire  [07:0]         inMF_i_address0            ;
    wire  [00:0]         inMF_i_ce0                 ;
    wire  [31:0]         inMF_i_q0                  ;
    wire  [04:0]         outMF_i_address0           ;
    wire  [00:0]         outMF_i_ce0                ;
    wire  [31:0]         outMF_i_q0                 ;
    wire  [14:0]         rule_i_address0            ;
    wire  [00:0]         rule_i_ce0                 ;
    wire  [03:0]         rule_i_q0                  ;
    wire  [03:0]         input_data_i_address0      ;
    wire  [00:0]         input_data_i_ce0           ;
    wire  [31:0]         input_data_i_q0            ;
    //debug and watch signals;
    wire  [00:0]         vio_ap_start               ;
    wire  [31:0]         prs_time_cnt               ;
    wire  [31:0]         prs_time_max               ;
    wire  [31:0]         prs_time_min               ;
    wire  [31:0]         pc_rdy_cnt                 ;
    
    //====================================================================//
    //--------------------------main process------------------------------//
    //====================================================================//
    //ap_start
    assign      ap_start = (DEBUG_ENABLE==1'b1)? (vio_ap_start|pc_ap_start) : pc_ap_start ;
    //ap_rst
    assign      ap_rst = sys_rst_p | pc_fis_rst ;
    //input_dim
    assign      input_dim  = 3  ;
    //pc_fis_done/pc_fis_return
    always @ (posedge usr_synclk or posedge sys_rst_p)
    begin
        if(sys_rst_p==1'b1)
        begin
            pc_fis_done <= 1'b0 ;
            pc_fis_return <= 32'b0 ;
            ap_done_r <= 1'b0 ;
        end
        else
        begin
            ap_done_r <= ap_done ;
            if(pc_reg_start==1'b1)//pc_ap_start;keep 1 clock period;
            begin
                pc_fis_done <= 1'b0 ;
                pc_fis_return <= 32'b0 ;
            end
            else if(ap_done_r==1'b1)
            begin
                pc_fis_done <= 1'b1 ;
                pc_fis_return <= ap_return ;
            end
            else
            begin
                pc_fis_done <= pc_fis_done ;
                pc_fis_return <= pc_fis_return ;
            end
        end
    end
    //fis_dim_r/output_num_r
    always @ (posedge usr_synclk or posedge sys_rst_p)
    begin
        if(sys_rst_p==1'b1)
        begin
            fis_dim_r <= 128'b0 ;
            output_num_r <= 5'b0 ;
        end
        else
        begin
            if(inmf_ena==1'b1)
            begin
                fis_dim_r <= fis_dim ;
                output_num_r <= output_num ;
            end
            else
            begin
                fis_dim_r <= fis_dim_r ;
                output_num_r <= output_num_r ;
            end
        end
    end
    //ap_done_cnt
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            ap_done_cnt <= 4'b0 ;
            ap_ip_rstp <= 1'b1 ;
        end
        else
        begin
            if(ap_done==1'b1)//keep 1 clock period;
            begin
                ap_done_cnt <= 4'h1 ;
                ap_ip_rstp <= 1'b0 ;
            end
            else if(ap_done_cnt>4'h0&&ap_done_cnt<4'h8)
            begin
                ap_done_cnt <= ap_done_cnt + 4'h1 ;
                if(ap_done_cnt>=4'h2 && ap_done_cnt<4'h6)
                begin
                    ap_ip_rstp <= 1'b1 ;
                end
                else
                begin
                    ap_ip_rstp <= 1'b0 ;
                end
            end
            else
            begin
                ap_done_cnt <= 4'h0 ;
                ap_ip_rstp <= 1'b0 ;
            end
        end
    end
    //fis
    fis u_fis(
    .ap_clk                ( usr_synclk            ),
    .ap_rst                ( ap_ip_rstp|vio_fis_rst),
    .ap_start              ( ap_start              ),
    .ap_done               ( ap_done               ),
    .ap_idle               ( ap_idle               ),
    .ap_ready              ( ap_ready              ),
    .input_dim             ( input_dim             ),
    .output_num            ( output_num_r          ),
    .weight                ( 32'h00000000          ),
    .ap_return             ( ap_return             ),
    
    .input_nums_ce0        ( input_nums_ce0        ),
    .input_nums_address0   ( input_nums_address0   ),
    .input_nums_q0         ( input_nums_q0         ),
    .inMF_i_ce0            ( inMF_i_ce0            ),
    .inMF_i_address0       ( inMF_i_address0       ),
    .inMF_i_q0             ( inMF_i_q0             ),
    .outMF_i_ce0           ( outMF_i_ce0           ),
    .outMF_i_address0      ( outMF_i_address0      ),
    .outMF_i_q0            ( outMF_i_q0            ),
    .rule_i_ce0            ( rule_i_ce0            ),
    .rule_i_address0       ( rule_i_address0       ),
    .rule_i_q0             ( rule_i_q0             ),
    .input_data_i_ce0      ( input_data_i_ce0      ),
    .input_data_i_address0 ( input_data_i_address0 ),
    .input_data_i_q0       ( input_data_i_q0       ),
    .prs_time_cnt          ( prs_time_cnt          ) 
    );
    //usr_watch
    usr_watch u_usr_watch(
    .ap_clk                ( usr_synclk            ),
    .ap_rst                ( ap_ip_rstp            ),
    .vio_fis_start         ( vio_fis_start         ),
    .vio_fis_num           ( vio_fis_num           ),
    .vio_ap_start          ( vio_ap_start          ),
    .ap_done               ( ap_done               ),
    .ap_start              ( ap_start              ),
    .pc_fis_start          ( pc_fis_start          ),
    .pc_ap_start           ( pc_ap_start           ),
    .prs_time_cnt          ( prs_time_cnt          ),
    .prs_time_max          ( prs_time_max          ),
    .prs_time_min          ( prs_time_min          ),
    .pc_rdy_cnt            ( pc_rdy_cnt            ) 
    );
    //input_nums_address
    assign      input_nums_address = {1'b0,input_nums_address0} ;
    //input_nums_q0
    always @ (posedge usr_synclk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            input_nums_r0 <= 12'b0 ;
            input_nums_r1 <= 12'b0 ;
            input_nums_r2 <= 12'b0 ;
            input_nums_q0 <= 12'b0 ;
        end
        else
        begin
            input_nums_r0 <= fis_dim_r[11:0] ;
            input_nums_r1 <= input_nums_r0   ;
            input_nums_r2 <= input_nums_r1   ;
            input_nums_q0 <= input_nums_r2   ;
        end
    end

    //inmf_dram:32bit*256,used 1 18kb blockram;
    inmf_dram u_inmf_dram(
    .clka                  ( usr_synclk            ),
    .ena                   ( inmf_ena              ),
    .wea                   ( inmf_ena              ),
    .addra                 ( inmf_addra            ),
    .dina                  ( inmf_dina[31:0]       ),
    .clkb                  ( usr_synclk            ),
    .enb                   ( inMF_i_ce0            ),
    .addrb                 ( inMF_i_address0       ),
    .doutb                 ( inMF_i_q0             ) 
    );
    //outmf_dram:32bit*32,used 1 18kb blockram;
    outmf_dram u_outmf_dram(
    .clka                  ( usr_synclk            ),
    .ena                   ( outmf_ena             ),
    .wea                   ( outmf_ena             ),
    .addra                 ( outmf_addra           ),
    .dina                  ( outmf_dina[31:0]      ),
    .clkb                  ( usr_synclk            ),
    .enb                   ( outMF_i_ce0           ),
    .addrb                 ( outMF_i_address0      ),
    .doutb                 ( outMF_i_q0            ) 
    );
    //rule_dram:4bit*32768,used 4 36kb blockram;
    rule_dram u_rule_dram(
    .clka                  ( usr_synclk           ),
    .ena                   ( rule_ena             ),
    .wea                   ( rule_ena             ),
    .addra                 ( rule_addra[14:0]     ),
    .dina                  ( rule_dina[3:0]       ),
    .clkb                  ( usr_synclk           ),
    .enb                   ( rule_i_ce0           ),
    .addrb                 ( rule_i_address0      ),
    .doutb                 ( rule_i_q0            ) 
    );
    //indata_dram:32bit*16,used 1 18kb blockram;
    indata_dram u_indata_dram(
    .clka                  ( usr_synclk           ),
    .ena                   ( in_data_ena          ),
    .wea                   ( in_data_ena          ),
    .addra                 ( in_data_addra[3:0]   ),
    .dina                  ( in_data_dina         ),
    .clkb                  ( usr_synclk           ),
    .enb                   ( input_data_i_ce0     ),
    .addrb                 ( input_data_i_address0),
    .doutb                 ( input_data_i_q0      ) 
    );                  
    //====================================================================//
    //-------------------------------  end  ------------------------------//
    //====================================================================//

endmodule
