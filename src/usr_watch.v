
`timescale 1ns / 1ps

module usr_watch(
    input   wire  [00:0]   ap_clk         ,
    input   wire  [00:0]   ap_rst         ,
    input   wire  [00:0]   vio_fis_start  ,
    input   wire  [15:0]   vio_fis_num    ,
    output  reg   [00:0]   vio_ap_start   ,
    input   wire  [00:0]   ap_done        ,
    input   wire  [00:0]   ap_start       ,
    input   wire  [00:0]   pc_fis_start   ,
    input   wire  [00:0]   pc_ap_start    ,
    output  reg   [31:0]   prs_time_cnt   ,
    output  reg   [31:0]   prs_time_max   ,
    output  reg   [31:0]   prs_time_min   ,
    output  reg   [31:0]   pc_rdy_cnt      
    
    );
    //parameter defination

    //=========================================================//
    //===================inernal signals=======================//
    //=========================================================//
    reg   [00:0]         vio_fis_start_r0           ;
    reg   [00:0]         vio_fis_start_r1           ;
    reg   [00:0]         vio_fis_start_r2           ;
    reg   [15:0]         vio_fis_num_r              ;
    reg   [15:0]         fis_num_cnt                ;
    reg   [00:0]         pc_rdy_on                  ;
    
    reg   [00:0]         ap_start_r0                ;
    reg   [00:0]         ap_start_r1                ;
    reg   [00:0]         ap_start_r2                ;
    reg   [00:0]         ap_done_r0                 ;
    reg   [00:0]         ap_done_r1                 ;
    reg   [00:0]         ap_done_r2                 ;

    //=========================================================//
    //======================main process=======================//
    //=========================================================//
    //vio_fis_start_r0/vio_fis_start_r1/vio_fis_start_r2
    always @ (posedge ap_clk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            vio_fis_start_r0 <= 1'b0 ;
            vio_fis_start_r1 <= 1'b0 ;
            vio_fis_start_r2 <= 1'b0 ;
            vio_fis_num_r <= 16'b0 ;
        end
        else
        begin
            vio_fis_start_r0 <= vio_fis_start ;
            vio_fis_start_r1 <= vio_fis_start_r0 ;
            vio_fis_start_r2 <= vio_fis_start_r1 ;
            vio_fis_num_r <= vio_fis_num ;
        end
    end
   
    always @ (posedge ap_clk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            fis_num_cnt <= 16'b0 ;
            vio_ap_start <= 1'b0 ;
        end
        else
        begin
            if(fis_num_cnt>16'h0 && fis_num_cnt<vio_fis_num_r)
            begin
                if(ap_done_r1==1'b1 && ap_done_r2==1'b0)
                begin
                    fis_num_cnt <= fis_num_cnt + 16'h1 ;
                    vio_ap_start <= 1'b1 ;
                end
                else
                begin
                    fis_num_cnt <= fis_num_cnt ;
                    vio_ap_start <= 1'b0 ;
                end
            end
            else if(vio_fis_start_r1==1'b1 && vio_fis_start_r2==1'b0)
            begin
                fis_num_cnt <= 16'h1 ;
                vio_ap_start <= 1'b1 ;
            end
            else
            begin
                fis_num_cnt <= 16'b0 ;
                vio_ap_start <= 1'b0 ;
            end
        end
    end
    
    always @ (posedge ap_clk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            ap_start_r0 <= 1'b0 ;
            ap_start_r1 <= 1'b0 ;
            ap_start_r2 <= 1'b0 ;
            ap_done_r0 <= 1'b0 ;
            ap_done_r1 <= 1'b0 ;
            ap_done_r2 <= 1'b0 ;
        end
        else
        begin
            ap_start_r0 <= ap_start ;
            ap_start_r1 <= ap_start_r0 ;
            ap_start_r2 <= ap_start_r1 ;
            ap_done_r0 <= ap_done ;
            ap_done_r1 <= ap_done_r0 ;
            ap_done_r2 <= ap_done_r1 ;
        end
    end
    
    always @ (posedge ap_clk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            prs_time_cnt <= 32'b0 ;
            prs_time_max <= 32'b0 ;
            prs_time_min <= 32'b0 ;
        end
        else
        begin
            if(ap_start_r1==1'b1 && ap_start_r2==1'b0)
            begin
                prs_time_cnt <= 32'h1 ;
                prs_time_max <= prs_time_max ;
                prs_time_min <= prs_time_min ;
            end
            else if(prs_time_cnt>32'h0)
            begin
                if(ap_done_r1==1'b1 && ap_done_r2==1'b0)
                begin
                    prs_time_cnt <= 32'b0 ;
                    if(prs_time_cnt>prs_time_max)
                    begin
                        prs_time_max <= prs_time_cnt ;
                        if(prs_time_min==32'b0)
                        begin
                            prs_time_min <= prs_time_cnt ;
                        end
                        else
                        begin
                            prs_time_min <= prs_time_min ;
                        end
                    end
                    else if(prs_time_cnt<prs_time_min)
                    begin
                        prs_time_min <= prs_time_cnt ;
                        prs_time_max <= prs_time_max ;
                    end
                    else
                    begin
                        prs_time_min <= prs_time_min ;
                        prs_time_max <= prs_time_max ;
                    end
                end
                else
                begin
                    prs_time_cnt <= prs_time_cnt + 32'h1 ;
                    prs_time_min <= prs_time_min ;
                    prs_time_max <= prs_time_max ;
                end
            end
            else
            begin
                prs_time_cnt <= 32'b0 ;
                prs_time_min <= prs_time_min ;
                prs_time_max <= prs_time_max ;
            end
        end
    end
    
    always @ (posedge ap_clk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            pc_rdy_on <= 1'b0 ;
        end
        else
        begin
            if(pc_fis_start==1'b1)
            begin
                pc_rdy_on <= 1'b1 ;
            end
            else if(pc_ap_start==1'b1)
            begin
                pc_rdy_on <= 1'b0 ;
            end
            else
            begin
                pc_rdy_on <= pc_rdy_on ;
            end
        end
    end
    
    always @ (posedge ap_clk or posedge ap_rst)
    begin
        if(ap_rst==1'b1)
        begin
            pc_rdy_cnt <= 32'b0 ;
        end
        else
        begin
            if(pc_fis_start==1'b1)
            begin
                pc_rdy_cnt <= 32'b0 ;
            end
            else if(pc_rdy_on==1'b1)
            begin
                pc_rdy_cnt <= pc_rdy_cnt + 32'h1 ;
            end
            else
            begin
                pc_rdy_cnt <= pc_rdy_cnt ;
            end
        end
    end
    //=========================================================//
    //===================inernal signals=======================//
    //=========================================================//

endmodule //main
