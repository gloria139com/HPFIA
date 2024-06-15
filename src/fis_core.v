`timescale 1 ns / 1 ps


`define DIM 3

module fis_core #(
    parameter INPUT_DIM = 4'd3,
    parameter INPUT_DATA = 4'd3,
    parameter RULE_COE = 4'd3,
	parameter OUTPUT_DIM = 5'd21,
	parameter RULE_DIM = 6'd36
)
(
	input wire                                   clk,
	input wire                                   rst,
	input wire                                   start,
	input wire [32*15-1:0]                       inMF_0,
	input wire [32*15-1:0]                       inMF_1,
	input wire [32*15-1:0]                       inMF_2,
	input wire [3:0]                             input_dim,
	input wire [5:0]                             rule_len,
	input wire [11:0]                            nums,
	input wire [32*OUTPUT_DIM-1:0]               outMF_0,
	input wire [6*RULE_DIM-1:0]                  rule_0,
	input wire [32*INPUT_DATA-1:0]               input_data_0,
	output wire signed[31:0]                     weight,
	output wire                                  weight_valid,
	input  wire  [31:0]                          prs_time_cnt,
	output wire  [31:0]                          prs_time_cnt_3
);

	wire signed [31:0]       inMF[0:INPUT_DIM-1][0:14];
	wire signed [31:0]       outMF[0:OUTPUT_DIM-1];
	reg                      rules_in_indices_valid[0:RULE_COE-1];
	wire [16*INPUT_DIM-1:0]  rules_in_indices_tmp[0:RULE_COE-1];
	wire                     rules_in_indices_valid_tmp[0:RULE_COE-1];
	wire signed [31:0]       input_data[0:INPUT_DIM-1];
	reg  [95:0]              inMF_data[0:RULE_COE-1][0:INPUT_DIM-1];
	reg  signed [31:0]       outMF_data[0:RULE_COE-1][0:`DIM-1];
	wire signed [31:0]       antecedent_degree[0:RULE_COE-1][0:INPUT_DIM-1];
	wire                     antecedent_degree_valid[0:RULE_COE-1][0:INPUT_DIM-1];
	wire signed [31:0]       consequent_degree[0:RULE_COE-1];
	reg  signed [31:0]       consequent_degree_tmp[0:RULE_COE-1];
	wire                     consequent_degree_valid[0:RULE_COE-1];
	wire signed [31:0]       area_sum[0:RULE_COE-1];
	reg  signed [31:0]       area_total;
	wire signed [31:0]       weighted_sum_of_centers[0:RULE_COE-1];
	reg  signed [31:0]       weighted_sum_of_centers_total;
	reg  [15:0]              index_0[0:INPUT_DIM-1][0:RULE_COE-1];
	wire [15:0]              out_index[0:RULE_COE-1];
	reg                      data_ready[0:RULE_COE-1][0:INPUT_DIM-1];
	reg                      output_data_ready[0:RULE_COE-1];
	wire[RULE_COE-1:0]       output_valid;
	reg                      calculate_ready;
  reg    start_tmp;
  reg [3:0] loop_s2,loop_s3;
  reg [3:0] loop_s1;
  reg [3:0] loop_max;
  reg [6*RULE_DIM-1:0]    rule_tmp;


	//inMF
	assign inMF[0][14] = inMF_0[31:0];      assign inMF[1][14] = inMF_1[31:0];        assign inMF[2][14] = inMF_2[31:0];
	assign inMF[0][13] = inMF_0[63:32];     assign inMF[1][13] = inMF_1[63:32];       assign inMF[2][13] = inMF_2[63:32];
	assign inMF[0][12] = inMF_0[95:64];     assign inMF[1][12] = inMF_1[95:64];       assign inMF[2][12] = inMF_2[95:64];
	assign inMF[0][11] = inMF_0[127:96];    assign inMF[1][11] = inMF_1[127:96];      assign inMF[2][11] = inMF_2[127:96];
	assign inMF[0][10] = inMF_0[159:128];   assign inMF[1][10] = inMF_1[159:128];     assign inMF[2][10] = inMF_2[159:128];
	assign inMF[0][9]  = inMF_0[191:160];   assign inMF[1][9]  = inMF_1[191:160];     assign inMF[2][9]  = inMF_2[191:160];
	assign inMF[0][8]  = inMF_0[223:192];   assign inMF[1][8]  = inMF_1[223:192];     assign inMF[2][8]  = inMF_2[223:192];
	assign inMF[0][7]  = inMF_0[255:224];   assign inMF[1][7]  = inMF_1[255:224];     assign inMF[2][7]  = inMF_2[255:224];
	assign inMF[0][6]  = inMF_0[287:256];	  assign inMF[1][6]  = inMF_1[287:256];     assign inMF[2][6]  = inMF_2[287:256];
	assign inMF[0][5]  = inMF_0[319:288];   assign inMF[1][5]  = inMF_1[319:288];     assign inMF[2][5]  = inMF_2[319:288];
	assign inMF[0][4]  = inMF_0[351:320];   assign inMF[1][4]  = inMF_1[351:320];     assign inMF[2][4]  = inMF_2[351:320];
	assign inMF[0][3]  = inMF_0[383:352];   assign inMF[1][3]  = inMF_1[383:352];     assign inMF[2][3]  = inMF_2[383:352];
	assign inMF[0][2]  = inMF_0[415:384];   assign inMF[1][2]  = inMF_1[415:384];     assign inMF[2][2]  = inMF_2[415:384];
	assign inMF[0][1]  = inMF_0[447:416];   assign inMF[1][1]  = inMF_1[447:416];     assign inMF[2][1]  = inMF_2[447:416];
	assign inMF[0][0]  = inMF_0[479:448];	  assign inMF[1][0]  = inMF_1[479:448];	    assign inMF[2][0]  = inMF_2[479:448];

	//outMF
	assign outMF[20] = outMF_0[31:0];
	assign outMF[19] = outMF_0[63:32];
	assign outMF[18] = outMF_0[95:64];
	assign outMF[17] = outMF_0[127:96];
	assign outMF[16] = outMF_0[159:128];
	assign outMF[15] = outMF_0[191:160];
	assign outMF[14] = outMF_0[223:192];
	assign outMF[13] = outMF_0[255:224];
	assign outMF[12] = outMF_0[287:256];
	assign outMF[11] = outMF_0[319:288];
	assign outMF[10] = outMF_0[351:320];
	assign outMF[9]  = outMF_0[383:352];
	assign outMF[8]  = outMF_0[415:384];
	assign outMF[7]  = outMF_0[447:416];
	assign outMF[6]  = outMF_0[479:448];
	assign outMF[5]  = outMF_0[511:480];
	assign outMF[4]  = outMF_0[543:512];
	assign outMF[3]  = outMF_0[575:544];
	assign outMF[2]  = outMF_0[607:576];
	assign outMF[1]  = outMF_0[639:608];
	assign outMF[0]  = outMF_0[671:640];


	//input_data
	assign input_data[2] = input_data_0[32*INPUT_DATA-65:32*INPUT_DATA-96];
	assign input_data[1] = input_data_0[32*INPUT_DATA-33:32*INPUT_DATA-64];
	assign input_data[0] = input_data_0[32*INPUT_DATA-1 :32*INPUT_DATA-32];

	assign prs_time_cnt_3 = prs_time_cnt;
    
    
	always@(posedge clk) begin
    	 if(~rst)
    	 	start_tmp <= 1'b0;
    	 else
    	 	start_tmp <= ~start;
    end


always @ (*) begin
        if((nums[11:8] == 4'd4) && (nums[7:4] == 4'd1))
        	loop_max = 4'd2;
        else if((nums[11:8] == 4'd4) && (nums[11:8] == 4'd4))
        	loop_max = 4'd6;
        else if(nums[11:8] == 4'd4) 
        	loop_max = nums[11:8] * nums[3:0];
        else
        	loop_max = nums[7:4] * nums[3:0];
    end

    always@(posedge clk) begin
    	 if(~rst)  begin
    	     loop_s1 <= 4'b0; 
    	 end
    	 else if(start & start_tmp) begin
    	 	loop_s1 <= loop_s1 + 4'd1; 
    	 end
    	 else if(loop_s1 > 4'd0) begin
    	 	 if(loop_s1 == loop_max)
    	 	 	 loop_s1 <= 4'b0;
    	 	 else
    	 	 	loop_s1 <= loop_s1 + 4'd1;    	 	
    	 end
    	 else begin
    	 	 loop_s1 <= loop_s1; 
    	 end
    end

	genvar i,j;
	generate
		for(i = 0; i < RULE_COE; i = i+1)
		begin: setrule
			SetRule setrule_inst(
			      .clk                           (clk),
			      .rst                           (rst),
			      .start                         ((loop_s1 > 4'd0) && (loop_s1 <= loop_max)),
			      .index                         (RULE_COE*(loop_s1-4'd1)+i),
			      .inner_index                   (i),
			      .loop_index                    (loop_s1-4'd1),
			      .nums                          (nums),
			      .input_num                     (input_dim),
			      .rules_in_indices              (rules_in_indices_tmp[i]),
			      .rules_in_indices_valid        (rules_in_indices_valid_tmp[i])
			);

			for(j = 0; j < INPUT_DIM; j = j+1) begin: set_index
				always@(posedge clk) begin
    	    		    if(~rst)begin
    	    		    	index_0[j][i] <= 16'b0;
    	    		    	rules_in_indices_valid[i] <= 1'b0;
    	    		    end
    	    		    else if(rules_in_indices_valid_tmp[i]) begin
				        	case(j)
				        		4'd0: index_0[j][i] <= rules_in_indices_tmp[i][15:0]    * `DIM;
				        		4'd1: index_0[j][i] <= rules_in_indices_tmp[i][31:16]   * `DIM;
				        		4'd2: index_0[j][i] <= rules_in_indices_tmp[i][47:32]   * `DIM;
				        		default: index_0[j][i] <= rules_in_indices_tmp[i][15:0] * `DIM;
				        	endcase
				        	rules_in_indices_valid[i] <= 1'b1;
				        end else
				        	rules_in_indices_valid[i] <= 1'b0;
				end
			end
    	end
	endgenerate


	generate
		for(i = 0; i < RULE_COE; i = i+1)
		begin: read_inMF_data
			for(j = 0; j < INPUT_DIM; j = j+1) begin: set_inMF
				always@(posedge clk) begin
    	    	    if(~rst)begin
    	    	    	inMF_data[i][j] <= 96'b0;
    	    	    	data_ready[i][j] <= 1'b0;
    	    	    end
    	    	    else if(rules_in_indices_valid[i]) begin
    	    	    	inMF_data[i][j] <= {inMF[j][index_0[j][i] + 0],inMF[j][index_0[j][i] + 1],inMF[j][index_0[j][i] + 2]};
    	    	    	data_ready[i][j] <= 1'b1;
		    	    end
		    	    else begin
    	    	    	inMF_data[i][j] <= 96'b0;
    	    	    	data_ready[i][j] <= 1'b0;
    	    	    end
    	    	end
    	    end
    	end
    endgenerate

	wire[95:0]  antecedent_degree_tmp[0:RULE_DIM-1];

	generate
		for(i = 0; i < RULE_COE; i = i+1)
		begin:	calculate_antecedentDegree
			for(j = 0; j < INPUT_DIM; j = j+1) begin: antecedentDegree
		    	CalculateAntecedentDegree aninst_0(
		    			.clk (clk),
		    			.rst (rst),
		    			.input_valid (data_ready[i][j]),
		    			.input_data (input_data[j]),
		    			.inMF_data (inMF_data[i][j]),
		    			.antecedent_degree (antecedent_degree[i][j]),
		    			.antecedent_degree_valid (antecedent_degree_valid[i][j]),
		    			.prs_time_cnt (prs_time_cnt_3)
		    	);
		    end

    	    case(INPUT_DIM)
    	    	4'd1: assign antecedent_degree_tmp[i] = {antecedent_degree[i][0],64'b0};
    	    	4'd2: assign antecedent_degree_tmp[i] = {antecedent_degree[i][0],antecedent_degree[i][1],32'b0};
    	    	4'd3: assign antecedent_degree_tmp[i] = {antecedent_degree[i][0],antecedent_degree[i][1],antecedent_degree[i][2]};
    	    	default: assign antecedent_degree_tmp[i] = {antecedent_degree[i][0],antecedent_degree[i][1],32'b0};
    	    endcase

			CalculateConsequentDegree coninst(
					.clk (clk),
					.rst (rst),
					.input_valid (antecedent_degree_valid[i][0]),
					.input_dim   (input_dim),
					.antecedent_degree (antecedent_degree_tmp[i]),
					.consequent_degree (consequent_degree[i]),
					.consequent_degree_valid (consequent_degree_valid[i])
			);
		end
    endgenerate
    
    

    always@(posedge clk) begin
    	 if(~rst)  
    	     loop_s2 <= 4'b0;
    	 else if(antecedent_degree_valid[0][0]) 
    	 	loop_s2 <= loop_s2 + 4'd1;   	 		 	
    	 else if(loop_s2 == loop_max) 
    	 	 loop_s2 <= 4'b0;  	
    	 else 
    	 	 loop_s2 <= loop_s2;
    end
	
	
	
	always@(posedge clk) begin
    	if(~rst)  
    	    rule_tmp <= 216'b0;
    	else if(start & start_tmp)
    		rule_tmp <= rule_0;
    	else if((loop_s2 > 4'd0) && consequent_degree_valid[0])
    		rule_tmp <= rule_tmp << (6*RULE_COE);
    	else
    		rule_tmp <= rule_tmp;
    end
   
    generate
		for(i = 0; i < RULE_COE; i = i+1)
		begin: generate_outMF_data
			assign out_index[i] = rule_tmp[6*RULE_DIM-1-i*6:6*RULE_DIM-6-i*6] * `DIM;
			
			always@(posedge clk)begin
    	    	if(~rst) begin
					outMF_data[i][0] <= 32'b0;
					outMF_data[i][1] <= 32'b0;
					outMF_data[i][2] <= 32'b0;
					output_data_ready[i] <= 1'b0;
				end
				else if(consequent_degree_valid[i] && (consequent_degree[i] >= 0)) begin
					outMF_data[i][0] <= outMF[out_index[i] + 0];
					outMF_data[i][1] <= outMF[out_index[i] + 1];
					outMF_data[i][2] <= outMF[out_index[i] + 2];
					output_data_ready[i] <= 1'b1;
				end
				else begin
					outMF_data[i][0] <= 32'b0;
					outMF_data[i][1] <= 32'b0;
					outMF_data[i][2] <= 32'b0;
					output_data_ready[i] <= 1'b0;
				end
			end
			
			always@(posedge clk)begin
    	    	if(~rst)
    	    		consequent_degree_tmp[i] <= 32'b0;
    	    	else
    	    		consequent_degree_tmp[i] <= consequent_degree[i];
    	    end

			CalculateWeight	wei_inst(
					.clk (clk),
					.rst (rst),
					.input_valid(output_data_ready[i] && (consequent_degree_tmp[i] > 0)),
					.consequent_degree (consequent_degree_tmp[i]),
					.outMF_data ({outMF_data[i][0],outMF_data[i][1],outMF_data[i][2]}),
					.area_sum (area_sum[i]),
					.weighted_sum_of_centers (weighted_sum_of_centers[i]),
					.output_valid (output_valid[i])
			);
    	end
	endgenerate
	
	reg output_data_ready_s1,output_data_ready_s2;
	
	always@(posedge clk) begin
    	if(~rst)  begin
    	    output_data_ready_s1 <= 1'b0;
    	    output_data_ready_s2 <= 1'b0;
    	end
    	else begin
    		output_data_ready_s1 <= output_data_ready[0];
    	    output_data_ready_s2 <= output_data_ready_s1;
    	end
    end
    
    reg [3:0] out_ready_cnt,out_valid_cnt;
    
    always@(posedge clk) begin
    	if(~rst)  begin
    	    out_ready_cnt <= 4'b0;
    	end    	
    	else if((consequent_degree_valid[0] && (consequent_degree[0] > 32'b0)) || (consequent_degree_valid[1] && (consequent_degree[1] > 32'b0)) || (consequent_degree_valid[2] && (consequent_degree[2] > 32'b0)))
    		out_ready_cnt <= out_ready_cnt + 4'd1;
    	else begin
    		out_ready_cnt <= out_ready_cnt;
    	end
    end
    
    always@(posedge clk) begin
    	if(~rst)  begin
    	    out_valid_cnt <= 4'b0;
    	end
    	else if(|output_valid)
    		out_valid_cnt <= out_valid_cnt + 4'd1;
    	else begin
    	    out_valid_cnt <= out_valid_cnt;
    	end
    end
    	 		
	always@(posedge clk) begin
    	 if(~rst)  
    	     loop_s3 <= 4'b0;
    	 else if(output_data_ready_s2)  begin
    	 	if(loop_s3 < loop_max)		
    	 		loop_s3 <= loop_s3 + 4'd1;   
    	 end	 	
    	 else 
    	 	 loop_s3 <= loop_s3;
    end
	

    always@(posedge clk)begin
    	if(~rst) begin
    		area_total <= 32'b0;
    		weighted_sum_of_centers_total <= 32'b0;
    	end
    	else if(|output_valid) begin
    			area_total <= area_total + area_sum[0] + area_sum[1] + area_sum[2];
    			weighted_sum_of_centers_total <= weighted_sum_of_centers_total + weighted_sum_of_centers[0] + weighted_sum_of_centers[1] + weighted_sum_of_centers[2];
    	end
    	else begin
    		area_total <= area_total;
    		weighted_sum_of_centers_total <= weighted_sum_of_centers_total;
    	end    		
    end
    
    reg  calculate_ready_t;
    
    reg [4:0] reg_hold;
    
    always@(posedge clk)begin
    	if(~rst) begin
    		reg_hold <= 5'b0;
    	end
    	else if((out_ready_cnt <= out_valid_cnt) && (out_ready_cnt > 4'd0))
    		reg_hold <= reg_hold + 5'd1;
    	else
    		reg_hold <= 5'b0;
    end
    
    always@(posedge clk)begin
    	if(~rst) begin
    		calculate_ready <= 1'b0;
    	end
    	else if((out_ready_cnt <= out_valid_cnt) && (out_ready_cnt > 4'd0) && (reg_hold > 5'd10))
    		calculate_ready <= 1'b1;
    	else
    		calculate_ready <= calculate_ready;
    end 
 
 
     always@(posedge clk)begin
    	if(~rst) 
    		calculate_ready_t <= 1'b0;
    	else
    		calculate_ready_t <= calculate_ready;
    end

    
   div_pack    div_weight(
	      .clk                    (clk),
	      .input_valid            ((area_total > 0) && (weighted_sum_of_centers_total !== 32'd0) && (calculate_ready && ~calculate_ready_t)), //(calculate_ready & (~calculate_ready_tmp))),
	      .dividend               ({(weighted_sum_of_centers_total[31]? 32'hffffffff:32'b0),weighted_sum_of_centers_total} <<< 12),
	      .divisor                (area_total),
	      .quotient               (weight),
	      .quotient_valid	        (weight_valid),
	      .dividend_tready        (),
	      .divisor_tready         ()
    );



endmodule








