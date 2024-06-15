`timescale 1 ns / 1 ps


module fis
(
    input   wire                        ap_clk,
    input   wire                        ap_rst,
    input   wire                        ap_start,       
    output  wire                        ap_done,        
    output  reg                         ap_idle,        

    output  reg [3:0]                   input_data_i_address0,
    output  wire                        input_data_i_ce0,
    input   wire signed[31:0]           input_data_i_q0,

    input   wire[3:0]                   input_dim,      

    output  wire[3:0]                   input_nums_address0,  
    output  wire                        input_nums_ce0,       
    input   wire[11:0]                  input_nums_q0,        

    input   wire[4:0]                   output_num,         

    output  reg [7:0]                   inMF_i_address0,
    output  wire                        inMF_i_ce0,
    input   wire signed[31:0]           inMF_i_q0,

    output  reg [4:0]                   outMF_i_address0,
    output  wire                        outMF_i_ce0,
    input   wire signed[31:0]           outMF_i_q0,

    output  reg [14:0]                  rule_i_address0,
    output  wire                        rule_i_ce0,
    input   wire[5:0]                   rule_i_q0,

    input   wire[31:0]                  weight,          
    output  wire signed[31:0]           ap_return,       
    output  wire                       ap_ready,         
    input   wire  [31:0]               prs_time_cnt,
    output  wire  [31:0]               prs_time_cnt_2
);

    wire signed[31:0]                   ap_weight;
    wire                                ap_weight_valid;
    reg  [32*15-1:0]                    inMF_0;
    reg  [32*15-1:0]                    inMF_1;
    reg  [32*15-1:0]                    inMF_2;
    reg  [4:0]                          inMF_couter;
    reg                                 inMF_rready;
    reg                                 inMF_rdone;
    reg  [32*21-1:0]                    outMF_0;
    reg  [4:0]                          outMF_couter;
    reg                                 outMF_rready;
    reg                                 outMF_rdone;
    reg  [6*36-1:0]                     rule_0;
    reg  [5:0]                          rule_couter;
    reg                                 rule_rready;
    reg                                 rule_rdone;
    reg  [32*3-1:0]                     input_data_0;
    reg  [2:0]                          input_data_couter;
    reg                                 input_data_rready;
    reg                                 input_data_rdone;
//  reg  [31:0]                         times;
    wire [3:0]                          nums_0;
    wire [3:0]                          nums_1;
    wire [3:0]                          nums_2;
    wire [5:0]                          rule_len;
    reg  [31:0]                         ap_return_tt;
    wire [4:0]                         tmp1;
    wire [5:0]                         tmp2;


    assign nums_0 = input_nums_q0[11:8];
    assign nums_1 = ~(|input_nums_q0[7:4]) ? 4'd1:input_nums_q0[7:4];
    assign nums_2 = ~(|input_nums_q0[3:0]) ? 4'd1:input_nums_q0[3:0];
    assign rule_len = nums_0 * nums_1 * nums_2;

    assign input_nums_address0 =   4'd0;
    assign input_nums_ce0 = 1'b1;
    assign prs_time_cnt_2 = prs_time_cnt;

    reg ap_start_tmp;
    reg start_new;


    always@(posedge ap_clk) begin
        if(ap_rst)
           ap_start_tmp <= 1'b0;
        else
           ap_start_tmp <= ap_start;
    end

    always@(posedge ap_clk) begin
        if(ap_rst)
           start_new <= 1'b0;
        else if(ap_start & ~ap_start_tmp)
           start_new <= 1'b1;
        else
           start_new <= start_new;
    end


    /***********************************************************************************************************/
    //inMF read logic
    always@(posedge ap_clk) begin
        if(ap_rst) begin
            inMF_i_address0  <= 8'd0;
            inMF_rready      <= 1'b0;
        end
        else if(start_new && (inMF_couter < ((input_nums_q0[11:8] + input_nums_q0[7:4] + input_nums_q0[3:0]) * 4'd3))) begin
                inMF_i_address0  <= inMF_i_address0 + 8'd1;
                inMF_rready      <= inMF_i_ce0;
        end
        else begin
            inMF_i_address0  <= 8'd0;
            inMF_rready      <= inMF_i_ce0;
        end
    end

    assign inMF_i_ce0 =  start_new && (inMF_couter < ((input_nums_q0[11:8] + input_nums_q0[7:4] + input_nums_q0[3:0]) * 4'd3));

    always@(posedge ap_clk) begin
        if(ap_rst)
            inMF_couter <= 5'd0;
        else if(start_new && (inMF_couter < ((input_nums_q0[11:8] + input_nums_q0[7:4] + input_nums_q0[3:0]) * 4'd3))) begin
            inMF_couter <= inMF_couter + 5'd1;
        end
        else
            inMF_couter <= inMF_couter;
    end


    assign tmp1 = (input_nums_q0[11:8] + input_nums_q0[7:4] + input_nums_q0[3:0]) * 4'd3;
    assign tmp2 = nums_0 * nums_1 * nums_2;


    always@(posedge ap_clk) begin
        if(ap_rst)
            inMF_rdone <= 1'd0;
        else if(start_new && (inMF_couter == tmp1))
            inMF_rdone <= 1'd1;
        else
            inMF_rdone <= inMF_rdone;
    end

    always@(posedge ap_clk) begin
         if(ap_rst) begin
             inMF_0 <= 480'b0;
             inMF_1 <= 480'b0;
             inMF_2 <= 480'b0;
         end
         else if(inMF_rready) begin
             if(inMF_couter <= (input_nums_q0[11:8]*4'd3)) begin
                 if(inMF_couter == (input_nums_q0[11:8]*4'd3))
                     inMF_0 <= {inMF_0[479:32],inMF_i_q0} << (480 - input_nums_q0[11:8]*7'd96);
                 else
                     inMF_0 <= {inMF_0[479:32],inMF_i_q0} << 32;
             end
             else if(inMF_couter <= ((input_nums_q0[11:8] + input_nums_q0[7:4])*4'd3)) begin
                 if(inMF_couter == ((input_nums_q0[11:8] + input_nums_q0[7:4])*4'd3))
                     inMF_1 <= {inMF_1[479:32],inMF_i_q0} << (480 - input_nums_q0[7:4]*7'd96);
                 else
                     inMF_1 <= {inMF_1[479:32],inMF_i_q0} << 32;
             end
             else if(inMF_couter <= ((input_nums_q0[11:8] + input_nums_q0[7:4] + input_nums_q0[3:0]) * 4'd3)) begin
                 if(inMF_couter == ((input_nums_q0[11:8] + input_nums_q0[7:4] + input_nums_q0[3:0]) * 4'd3))
                     inMF_2 <= {inMF_2[479:32],inMF_i_q0} << (480 - input_nums_q0[3:0]*7'd96);
                 else
                     inMF_2 <= {inMF_2[479:32],inMF_i_q0} << 32;
             end
             else begin
                 inMF_0 <= inMF_0;
                 inMF_1 <= inMF_1;
                 inMF_2 <= inMF_2;
             end
         end
         else begin
             inMF_0 <= inMF_0;
             inMF_1 <= inMF_1;
             inMF_2 <= inMF_2;
         end
    end
    /***********************************************************************************************************/

    /***********************************************************************************************************/
    //outMF read logic
    always@(posedge ap_clk) begin
        if(ap_rst) begin
            outMF_i_address0  <= 5'h0;
            outMF_rready      <= 1'b0;
        end
        else if(start_new && (outMF_couter < (output_num))) begin
                outMF_i_address0  <= outMF_i_address0 + 5'd1;
                outMF_rready      <= outMF_i_ce0;
        end
        else begin
            outMF_i_address0  <= 5'h0;
            outMF_rready      <= outMF_i_ce0;
        end
    end

    assign outMF_i_ce0 = start_new && (outMF_couter < (output_num));

    always@(posedge ap_clk) begin
        if(ap_rst)
            outMF_couter <= 5'd0;
        else if(start_new && (outMF_couter < (output_num)))
            outMF_couter <= outMF_couter + 5'd1;
        else
            outMF_couter <= outMF_couter;
    end

    always@(posedge ap_clk) begin
        if(ap_rst)
            outMF_rdone <= 1'd0;
        else if(outMF_couter == (output_num))
            outMF_rdone <= 1'd1;
        else
            outMF_rdone <= outMF_rdone;
    end

    always@(posedge ap_clk) begin
         if(ap_rst) begin
             outMF_0 <= 672'b0;
         end
         else if(outMF_rready) begin
             if(outMF_couter <= (output_num)) begin
                 if(outMF_couter == (output_num))
                     outMF_0 <= {outMF_0[671:32],outMF_i_q0} << (672 - (output_num * 7'd32));
                 else
                     outMF_0 <= {outMF_0[671:32],outMF_i_q0} << 32;
             end
         end
         else
             outMF_0 <= outMF_0;
    end

    /***********************************************************************************************************/

    /***********************************************************************************************************/
    //rule read logic
    always@(posedge ap_clk) begin
        if(ap_rst) begin
            rule_i_address0  <= 15'd0;
            rule_rready      <= 1'b0;
        end
        else if(start_new && (rule_couter < (nums_0 * nums_1 * nums_2))) begin
            rule_i_address0  <= rule_i_address0 + 15'd1;
            rule_rready      <= rule_i_ce0;
        end
        else begin
            rule_i_address0  <= 15'd0;
            rule_rready      <= rule_i_ce0;
        end
    end

    assign rule_i_ce0 = start_new && (rule_couter < (nums_0 * nums_1 * nums_2));

    always@(posedge ap_clk) begin
        if(ap_rst)
            rule_couter <= 6'd0;
        else if(start_new && (rule_couter < (nums_0 * nums_1 * nums_2)))
            rule_couter <= rule_couter + 6'd1;
        else
            rule_couter <= rule_couter;
    end

    always@(posedge ap_clk) begin
        if(ap_rst)
            rule_rdone <= 1'd0;
        else if(start_new && (rule_couter == tmp2))
            rule_rdone <= 1'd1;
        else
            rule_rdone <= rule_rdone;
    end

    always@(posedge ap_clk) begin
         if(ap_rst)
             rule_0 <= 216'b0;
         else if(rule_rready) begin
             if(rule_couter <= (nums_0 * nums_1 * nums_2)) begin
                 if(rule_couter == (nums_0 * nums_1 * nums_2))
                     rule_0 <= {rule_0[215:6],rule_i_q0} << (216 - ((nums_0 * nums_1 * nums_2) * 4'd6));
                 else
                     rule_0 <= {rule_0[215:6],rule_i_q0} << 6;
             end
         end
         else
             rule_0 <= rule_0;
    end
    /***********************************************************************************************************/

    /***********************************************************************************************************/
    //input data read logic
    always@(posedge ap_clk) begin
        if(ap_rst) begin
            input_data_i_address0  <= 4'b0;
            input_data_rready      <= 1'b0;
        end
        else if(start_new && (input_data_couter < input_dim)) begin
                input_data_i_address0  <= input_data_i_address0 + 4'd1;
                input_data_rready      <= input_data_i_ce0;
        end
        else begin
            input_data_i_address0  <= 4'b0;
            input_data_rready      <= input_data_i_ce0;
        end
    end

    assign input_data_i_ce0 = start_new && (input_data_couter < input_dim);

    always@(posedge ap_clk) begin
        if(ap_rst)
            input_data_couter <= 3'd0;
        else if(start_new && (input_data_couter < input_dim))
            input_data_couter <= input_data_couter + 3'd1;
        else
            input_data_couter <= input_data_couter;
    end

    always@(posedge ap_clk) begin
        if(ap_rst)
            input_data_rdone <= 1'd0;
        else if(input_data_couter == input_dim)
            input_data_rdone <= 1'd1;
        else
            input_data_rdone <= input_data_rdone;
    end

    always@(posedge ap_clk) begin
         if(ap_rst) begin
             input_data_0 <= 96'b0;
         end
         else if(input_data_rready) begin
             if(input_data_couter <= input_dim) begin
                 if(input_data_couter == input_dim)
                     input_data_0 <= {input_data_0[95:32],input_data_i_q0} << (96 - input_dim*32);
                 else
                     input_data_0 <= {input_data_0[95:32],input_data_i_q0} << 32;
             end
         end
         else
             input_data_0 <= input_data_0;
    end
    /***********************************************************************************************************/

    fis_core
          fis_core_uut(
        .clk            (ap_clk             ),
        .rst            (~ap_rst            ),
        .start          (start_new && input_data_rdone && rule_rdone && outMF_rdone && inMF_rdone),
        .inMF_0         (inMF_0             ),
        .inMF_1         (inMF_1             ),
        .inMF_2         (inMF_2             ),
        .input_dim      (input_dim          ),
        .rule_len       (rule_len           ),
        .nums           ({nums_0,nums_1,nums_2}),
        .outMF_0        (outMF_0            ),
        .rule_0         (rule_0             ),
        .input_data_0   (input_data_0       ),
        .weight         (ap_weight          ),
        .weight_valid   (ap_weight_valid    ),
        .prs_time_cnt   (prs_time_cnt_2     ) 
    );

    assign ap_return = ap_return_tt;
    assign ap_ready  = ap_weight_valid;
    assign ap_done   = ap_ready;


    always@(posedge ap_clk) begin
         if(ap_rst) begin
               ap_return_tt <= 32'b0;
         end
         else if(ap_done) begin
               ap_return_tt <= ap_weight;
         end
         else begin
               ap_return_tt <= ap_return_tt;
         end
      end

    always@(posedge ap_clk) begin
         if(ap_rst) begin
             ap_idle  <= 1'b0;
         end
         else if(ap_weight_valid) begin
             ap_idle  <= 1'b1;
         end
         else begin
             ap_idle  <= ap_idle;
         end
    end


endmodule








