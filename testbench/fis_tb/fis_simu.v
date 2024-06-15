
`timescale 1ns / 1ps

module fis_simu;
    //-------------------------------------------------------------------
    // Defination of Ports
    //-------------------------------------------------------------------    
    wire  [00:0]         ap_clk                     ;
    reg   [00:0]         ap_rst                     ;
    wire  [00:0]         ap_start                   ;
    wire  [00:0]         ap_idle                    ;
    wire  [00:0]         ap_done                    ;
    wire  [00:0]         ap_ready                   ;
    wire  signed [31:0]  ap_return                  ;
    
    reg   [03:0]         fis_index                  ;
    reg   [03:0]         fis_dim                    ;
    reg   [05:0]         fis_len                    ;
    reg   [07:0]         inmf_tlen                  ;
    reg   [04:0]         outmf_tlen                 ;
    reg   [31:0]         rule_tlen                  ;
    reg   [31:0]         ndat_pnum                  ;
    reg   [09:0]         ndat_tlen                  ;
    
    reg   [00:0]         inmf_ena                   ;
    reg   [07:0]         inmf_addra                 ;
    reg   [31:0]         inmf_dina                  ;
    reg   [00:0]         outmf_ena                  ;
    reg   [04:0]         outmf_addra                ;
    reg   [31:0]         outmf_dina                 ;
    reg   [00:0]         rule_ena                   ;
    reg   [28:0]         rule_addra                 ;
    reg   [31:0]         rule_dina                  ;
    reg   [00:0]         in_data_ena                ;
    reg   [31:0]         in_data_addra              ;
    reg   [31:0]         in_data_dina               ;
    
    wire  [03:0]         input_dim                  ;
    wire  [04:0]         output_num                 ;
    wire  [03:0]         input_nums_address0        ;
    wire  [00:0]         input_nums_ce0             ;
    wire  [11:0]         input_nums_q0              ; 
    wire  [07:0]         inMF_i_address0            ;
    wire  [00:0]         inMF_i_ce0                 ;
    wire  signed [31:0]  inMF_i_q0                  ;
    wire  [04:0]         outMF_i_address0           ;
    wire  [00:0]         outMF_i_ce0                ;
    wire  signed [31:0]  outMF_i_q0                 ;
    wire  [14:0]         rule_i_address0            ;
    wire  [00:0]         rule_i_ce0                 ; 
    wire  [03:0]         rule_i_q0                  ;    
    wire  [03:0]         input_data_i_address0      ;
    wire  [00:0]         input_data_i_ce0           ;
    wire  signed [31:0]  input_data_i_q0            ;

    reg   [00:0]         vio_fis_start              ;
    wire  [00:0]         vio_fis_rst                ;
    wire  [15:0]         vio_fis_num                ;
    wire  [31:0]         prs_time_cnt               ;
    wire  [31:0]         prs_time_max               ;
    wire  [31:0]         prs_time_min               ;
    //====================================================================//
    //----------------------internal signals------------------------------//
    //====================================================================//
    reg   [15:0]    process_cnt   ;
    //====================================================================//
    //--------------------------main process------------------------------//
    //====================================================================//
    //clock
    sys_clk_gen #(
    .TCQ (0),
    .offset(0),
    .halfcycle(2500)
    )sys_clk_gen(
    .sys_clk(ap_clk)   
    );
    //reset
    initial 
    begin
        ap_rst  = 1'b1 ;
        #150000 ap_rst = 1'b0 ;
    end  
    //vio_fis_rst
    assign      vio_fis_rst = 1'b0 ;
    //vio_fis_num
    assign      vio_fis_num = 16'h1 ;
    //process_cnt
    always @ (posedge ap_clk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            process_cnt <= 16'h0 ;
            vio_fis_start <= 1'b0 ;
        end
        else
        begin
            if(process_cnt<16'h8000)
            begin           
                process_cnt <= process_cnt + 16'h1 ;
                if(process_cnt==16'h2000)
                begin
                    vio_fis_start <= 1'b1 ;
                end
                else
                begin
                    vio_fis_start <= 1'b0 ;
                end
            end
            else
            begin
                process_cnt <= process_cnt ;
                vio_fis_start <= 1'b0 ;
            end
        end
    end

    always @(posedge ap_clk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_index   <= 4'h6  ;
            fis_dim     <= 4'h3  ;
            fis_len     <= 6'h9  ;
            inmf_tlen   <= 8'h36 ;
            outmf_tlen  <= 5'h09 ;
            rule_tlen   <= 32'h2d9;
            ndat_tlen   <= 10'h1 ;
        end
        else
        begin
            fis_index   <= 4'h3  ;
            fis_dim     <= 4'h3  ;
            fis_len     <= 6'h9  ;
            inmf_tlen   <= 8'h1b ;
            outmf_tlen  <= 5'hf  ;
            rule_tlen   <= 32'h1b;
            ndat_tlen   <= 10'h3 ;
        end
    end
    //input_dim
    assign      input_dim  = fis_index  ;
    //output_num
    assign      output_num = outmf_tlen ;  
    //input_nums_q0
    assign      input_nums_q0 = {fis_dim,4'd3,4'd3} ;   
    //inmf_ena/outmf_ena/rule_ena/in_data_ena
    always @ (posedge ap_clk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            inmf_ena   <= 1'b0 ;
            inmf_addra <= 8'b0 ;
            inmf_dina  <= 32'b0;
            outmf_ena   <= 1'b0;
            outmf_addra <= 5'b0;
            outmf_dina  <= 32'b0;
            rule_ena <= 1'b0;
            rule_addra <= 29'b0;
            rule_dina <= 32'b0;
            in_data_ena <= 1'b0;
            in_data_addra <= 32'b0;
            in_data_dina <= 32'b0;
        end
        else
        begin
            inmf_ena   <= 1'b1;
            inmf_addra <= 8'd9;
            inmf_dina  <= 32'b0;
            outmf_ena   <= 1'b0;
            outmf_addra <= 5'b10000;
            outmf_dina  <= 32'b0;
            rule_ena <= 1'b0;
            rule_addra <= 29'b0;
            rule_dina <= 32'b0;
            in_data_ena <= 1'b0;
            in_data_addra <= 32'b0;
            in_data_dina <= 32'b0;
        end
    end
    //ap_start
    assign      ap_start = vio_fis_start ;
    //########################fis instance###################//
    fis u_fis(
    .ap_clk                ( ap_clk                ),
    .ap_rst                ( ap_rst|vio_fis_rst    ),
    .ap_start              ( ap_start              ),
    .ap_done               ( ap_done               ),
    .ap_idle               ( ap_idle               ),
    .ap_ready              ( ap_ready              ),
    .input_dim             ( input_dim             ),
    .output_num            ( output_num            ),
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
    .rule_i_q0             ( {2'd0,rule_i_q0}      ),
    .input_data_i_ce0      ( input_data_i_ce0      ),
    .input_data_i_address0 ( input_data_i_address0 ),
    .input_data_i_q0       ( input_data_i_q0       ) 
    );
    
    inmf_dram u_inmf_dram(
    .clka                  ( ap_clk                ),
    .ena                   ( inmf_ena              ),
    .wea                   ( inmf_ena              ),
    .addra                 ( inmf_addra            ),
    .dina                  ( inmf_dina             ),
    .clkb                  ( ap_clk                ),
    .enb                   ( inMF_i_ce0            ),
    .addrb                 ( inMF_i_address0       ),
    .doutb                 ( inMF_i_q0             ) 
    );
    
    outmf_dram u_outmf_dram(
    .clka                  ( ap_clk                ),
    .ena                   ( outmf_ena             ),
    .wea                   ( outmf_ena             ),
    .addra                 ( outmf_addra           ),
    .dina                  ( outmf_dina[31:0]      ),
    .clkb                  ( ap_clk                ),
    .enb                   ( outMF_i_ce0           ),
    .addrb                 ( outMF_i_address0      ),
    .doutb                 ( outMF_i_q0            ) 
    );
    
    rule_dram u_rule_dram(
    .clka                  ( ap_clk               ),
    .ena                   ( rule_ena             ),
    .wea                   ( rule_ena             ),
    .addra                 ( rule_addra[14:0]     ),
    .dina                  ( rule_dina[3:0]       ),
    .clkb                  ( ap_clk               ),
    .enb                   ( rule_i_ce0           ),
    .addrb                 ( rule_i_address0      ),
    .doutb                 ( rule_i_q0            ) 
    );
    
    indata_dram u_indata_dram(
    .clka                  ( ap_clk               ),
    .ena                   ( in_data_ena          ),
    .wea                   ( in_data_ena          ),
    .addra                 ( in_data_addra[3:0]   ),
    .dina                  ( in_data_dina         ),
    .clkb                  ( ap_clk               ),
    .enb                   ( input_data_i_ce0     ),
    .addrb                 ( input_data_i_address0),
    .doutb                 ( input_data_i_q0      ) 
    );    
    //####################debug and watch instance#############//
    usr_watch u_usr_watch(
    .ap_clk                ( ap_clk                ),
    .ap_rst                ( ap_rst                ),
    .vio_fis_start         ( vio_fis_start         ),
    .vio_fis_num           ( vio_fis_num           ),
    .vio_ap_start          ( vio_ap_start          ),
    .ap_done               ( ap_done               ),
    .ap_start              ( ap_start              ),
    .pc_fis_start          ( 1'b0                  ),
    .pc_ap_start           ( 1'b0                  ),
    .prs_time_cnt          ( prs_time_cnt          ),
    .prs_time_max          ( prs_time_max          ),
    .prs_time_min          ( prs_time_min          ),
    .pc_rdy_cnt            ( pc_rdy_cnt            ) 
    );  

endmodule

