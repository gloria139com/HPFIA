`timescale 1 ns / 1 ps
`define DIM 3

module CalculateAntecedentDegree(
	input wire                  clk,
	input wire                  rst,
	input wire                  input_valid,
	input wire signed [31:0]    input_data,
	input wire[95:0]            inMF_data,
	output reg signed [31:0]    antecedent_degree,
	output reg                  antecedent_degree_valid,	
	input  wire  [31:0]         prs_time_cnt
);

    reg signed [31:0]      c;
    reg signed [63:0]      dividend;
    reg signed [31:0]      divisor;
    wire                   dividend_tready;
    wire                   divisor_tready;
    reg                    div_valid;
    wire signed [63:0]     quotient;
    wire                   quotient_valid;
    reg                    wait_tready;
    wire  [31:0]           prs_time_cnt_4;
        
    reg [95:0]     inMF_data_fifo[11:0];
    reg [3:0]      fifo_in_cnt;
    reg [3:0]      fifo_out_cnt; 
    reg            rd_en;
    reg            dividend_tready_t;
    reg            divisor_tready_t;
    reg [2:0]      rd_cnt;
    
    
   assign prs_time_cnt_4 = prs_time_cnt;   
    
    always@(posedge clk)begin
		if(~rst) 
			fifo_in_cnt <= 4'b0;
		else if(input_valid) 
			fifo_in_cnt <= fifo_in_cnt +4'd1;
		else
			fifo_in_cnt <= fifo_in_cnt;
	end
	
	always@(posedge clk)begin
		if(~rst) 
			fifo_out_cnt <= 4'b0;
		else if(rd_en && (fifo_out_cnt < fifo_in_cnt)) 
			fifo_out_cnt <= fifo_out_cnt + 4'd1;
		else
			fifo_out_cnt <= fifo_out_cnt;
	end
	
	always@(posedge clk)begin
		if(~rst) 
			rd_cnt <= 3'b0;
		else if(rd_en && (rd_cnt < 3'd6)) 
			rd_cnt <= rd_cnt + 3'd1;
		else
			rd_cnt <= 3'b0;
	end
	
	always@(posedge clk)begin
		if(~rst) begin
			inMF_data_fifo[0] <= 96'b0;
			inMF_data_fifo[1] <= 96'b0;
			inMF_data_fifo[2] <= 96'b0;
			inMF_data_fifo[3] <= 96'b0;
			inMF_data_fifo[4] <= 96'b0;
			inMF_data_fifo[5] <= 96'b0;
			inMF_data_fifo[6] <= 96'b0;
			inMF_data_fifo[7] <= 96'b0;
			inMF_data_fifo[8] <= 96'b0;
			inMF_data_fifo[9] <= 96'b0;
			inMF_data_fifo[10] <= 96'b0;
			inMF_data_fifo[11] <= 96'b0;
		end
		else if(input_valid) 
			inMF_data_fifo[fifo_in_cnt] <= inMF_data;
		else
			inMF_data_fifo[0] <= inMF_data_fifo[0];
	end
	
	always@(posedge clk)begin
		if(~rst) begin
			dividend_tready_t <= 1'b0;
			divisor_tready_t <= 1'b0;
		end
		else begin
			dividend_tready_t <= dividend_tready;
			divisor_tready_t <= divisor_tready;
		end
	end
			
			
    always@(posedge clk)begin
		if(~rst)
			rd_en <= 1'b0;
		else if(input_valid && dividend_tready && divisor_tready && (rd_cnt < 3'd3)) 
			rd_en <= 1'b1;
		else if(~dividend_tready || ~divisor_tready || (rd_cnt == 3'd3) || (rd_en && (fifo_out_cnt == (fifo_in_cnt-4'd1))))
			rd_en <= 1'b0;
		else if((dividend_tready & ~dividend_tready_t) && (divisor_tready & ~divisor_tready_t) && (fifo_out_cnt < fifo_in_cnt) && (rd_cnt < 3'd3))
			rd_en <= 1'b1;		
		else
			rd_en <= rd_en;
	end
 
	always@(*)begin
    	if(rd_en) begin
             if(input_data < $signed(inMF_data_fifo[fifo_out_cnt][95:64]))
		    	c = $signed(inMF_data_fifo[fifo_out_cnt][95:64]);
		    else if(input_data > $signed(inMF_data_fifo[fifo_out_cnt][31:0]))
		    	c = $signed(inMF_data_fifo[fifo_out_cnt][31:0]);
		    else
		    	c = input_data; 
		end
	    else begin
	    	c = 32'b0;
    	end
	end
	
	
	always@(posedge clk)begin
		if(~rst) begin
			dividend <= 64'b0;
			divisor <= 32'b0;
		end
		else if(rd_en) begin
			if(c == $signed(inMF_data_fifo[fifo_out_cnt][63:32])) begin
				dividend <= 64'h1000 << 12;
		    	divisor <= 32'h1000;
		    end
		    else if((c == $signed(inMF_data_fifo[fifo_out_cnt][31:0])) || (c == $signed(inMF_data_fifo[fifo_out_cnt][95:64]))) begin
		    	dividend <= 40'b0;
		    	divisor <= 32'h1000;
		    end
			else if((c > $signed(inMF_data_fifo[fifo_out_cnt][95:64])) && (c < $signed(inMF_data_fifo[fifo_out_cnt][63:32]))) begin
				dividend <= ({32'b0,(c - $signed(inMF_data_fifo[fifo_out_cnt][95:64]))}) <<< 12;
		    	divisor <= $signed(inMF_data_fifo[fifo_out_cnt][63:32]) - $signed(inMF_data_fifo[fifo_out_cnt][95:64]);
		    end
			else begin
				dividend <= ({((($signed(inMF_data_fifo[fifo_out_cnt][31:0]) - c)>0)? 32'h0:32'hffffffff),($signed(inMF_data_fifo[fifo_out_cnt][31:0]) - c)}) <<< 12;
		    	divisor <= $signed(inMF_data_fifo[fifo_out_cnt][31:0]) - $signed(inMF_data_fifo[fifo_out_cnt][63:32]);
		    end
	    end
		else begin
			dividend <= dividend;
			divisor <= divisor;
		end
	end  
  
  
  
	always@(posedge clk) begin
		if(~rst) 
			div_valid <= 1'b0;
		else if(rd_en)
			div_valid <= 1'b1;
		else 
			div_valid <= 1'b0;
	end
	
					
	div_pack   div_uut1(
	      .clk                    (clk),
	      .input_valid            (div_valid),
	      .dividend               (dividend),
	      .dividend_tready        (dividend_tready),
	      .divisor_tready         (divisor_tready),
	      .divisor                (divisor),
	      .quotient               (quotient),
	      .quotient_valid	      (quotient_valid)
    );
	
	always@(posedge clk)begin
		if(~rst) begin          
			antecedent_degree <= 32'b0;
			antecedent_degree_valid <= 1'b0;
		end
		else if(quotient_valid) begin
			antecedent_degree <= {quotient[63],quotient[30:0]};
			antecedent_degree_valid <= 1'b1;
	    end
		else 
			antecedent_degree_valid <= 1'b0;
	end
				
				
endmodule
    
	

	