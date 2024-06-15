`timescale 1 ns / 1 ps

module CalculateWeight(
	input wire                  clk,
	input wire                  rst,
	input wire                  input_valid,
	input wire signed[31:0]     consequent_degree,
	input wire [95:0]           outMF_data,
	output reg signed[31:0]     area_sum,
	output reg signed[31:0]     weighted_sum_of_centers,
	output reg                  output_valid
);

    reg  signed[31:0] x1,x2;
	reg  signed[31:0] center_of_gravity;
	reg  signed[31:0] area;
	reg               area_ready;
	
	reg signed[31:0] x1_s1,x1_s2;
	reg signed[31:0] x2_s1,x2_s2;
	reg signed[31:0] area_mul;
	reg              part_ready,x_ready,mul_ready;
	
	reg [127:0]    fifo_reg[9:0];
	reg [127:0]    fifo_t1,fifo_t2,fifo_t3;
    reg [3:0]      fifo_in_cnt;
    reg [3:0]      fifo_out_cnt; 
    reg            rd_en;
    reg            start_rd;
  
     
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
		if(~rst) begin
			fifo_reg[0] <= 128'b0;
			fifo_reg[1] <= 128'b0;
			fifo_reg[2] <= 128'b0;
			fifo_reg[3] <= 128'b0;
			fifo_reg[4] <= 128'b0;
			fifo_reg[5] <= 128'b0;
			fifo_reg[6] <= 128'b0;
			fifo_reg[7] <= 128'b0;
			fifo_reg[8] <= 128'b0;
			fifo_reg[9] <= 128'b0;
		end
		else if(input_valid) 
			fifo_reg[fifo_in_cnt] <= {consequent_degree,outMF_data};
		else
			fifo_reg[0] <= fifo_reg[0];
	end
	
	always@(posedge clk)begin
		if(~rst) 
			start_rd <= 1'b0;
		else if(input_valid && (fifo_in_cnt == 4'd0)) 
			start_rd <= 1'd1;
		else
			start_rd <= 1'b0;
	end
	
	always@(posedge clk)begin
		if(~rst)
			rd_en <= 1'b0;
		else if(start_rd || (area_ready && (fifo_out_cnt < fifo_in_cnt)) || (input_valid && (fifo_out_cnt == fifo_in_cnt) && (fifo_out_cnt > 4'd0)))
			rd_en <= 1'b1;	
		else
			rd_en <= 1'b0;
	end

 
	always@(posedge clk)begin
    	if(~rst) begin   
    		x1_s1 <= 32'b0;
    		x1_s2 <= 32'b0;
    		x2_s1 <= 32'b0;
    		x2_s2 <= 32'b0;  
    		part_ready <= 1'b0; 
    		fifo_t1 <= 128'b0;
    	end
    	else if(rd_en)  begin
    	    if($signed(fifo_reg[fifo_out_cnt][95:64]) >= $signed(fifo_reg[fifo_out_cnt][63:32]))
    			x1_s1 <= ($signed(fifo_reg[fifo_out_cnt][127:96]) * $signed((fifo_reg[fifo_out_cnt][95:64]) - $signed(fifo_reg[fifo_out_cnt][63:32]))) >>> 12;
    		else
    			x1_s2 <= ($signed(fifo_reg[fifo_out_cnt][127:96]) * $signed((fifo_reg[fifo_out_cnt][63:32]) - $signed(fifo_reg[fifo_out_cnt][95:64]))) >>> 12;
    			
    		if($signed(fifo_reg[fifo_out_cnt][31:0]) >= $signed(fifo_reg[fifo_out_cnt][63:32]))
    			x2_s1 <= ($signed(fifo_reg[fifo_out_cnt][127:96]) * ($signed(fifo_reg[fifo_out_cnt][31:0]) - $signed(fifo_reg[fifo_out_cnt][63:32]))) >>> 12;
    		else
    			x2_s2 <= ($signed(fifo_reg[fifo_out_cnt][127:96]) * ($signed(fifo_reg[fifo_out_cnt][63:32]) - $signed(fifo_reg[fifo_out_cnt][31:0]))) >>> 12;
    			
    		part_ready <= 1'b1; 
    		fifo_t1 <= fifo_reg[fifo_out_cnt];
    	end
    	else begin
    		part_ready <= 1'b0; 
    	end
    end
    
    always@(posedge clk)begin
    	if(~rst) begin   
    		x1 <= 32'b0;
    		x2 <= 32'b0;  
    		x_ready <= 1'b0;    
    		fifo_t2 <= 128'b0;
    	end
    	else if(part_ready) begin
    		if($signed(fifo_t1[95:64]) >= $signed(fifo_t1[63:32])) 
    			x1 <= $signed(fifo_t1[95:64]) - x1_s1;
    		else
    			x1 <= $signed(fifo_t1[95:64]) + x1_s2;
    			
    		if($signed(fifo_t1[31:0]) >= $signed(fifo_t1[63:32]))
    			x2 <= $signed(fifo_t1[31:0]) - x2_s1;
    		else
    			x2 <= $signed(fifo_t1[31:0]) + x2_s2;
    		
    		x_ready <= 1'b1; 
    		fifo_t2 <= fifo_t1;
    	end
    	else
    		x_ready <= 1'b0; 
    end
    
    always@(posedge clk)begin
    	if(~rst) begin   
    		area_mul <= 32'b0;
    		mul_ready <= 1'b0; 
    		fifo_t3 <= 128'b0;
    	end
    	else if(x_ready) begin
    		area_mul <= (($signed(fifo_t2[31:0]) - $signed(fifo_t2[95:64])) + (x2 - x1)) * $signed(fifo_t2[127:96]);
    		mul_ready <= 1'b1; 
    		fifo_t3 <= fifo_t2;
    	end
    	else
    		mul_ready <= 1'b0; 
    end
    
    // area
	always@(posedge clk)begin
    	if(~rst) begin          
    		area <= 32'b0;
    		area_ready <= 1'b0;
    		center_of_gravity <= 32'b0;
    	end
    	else if(mul_ready) begin
    		if($signed(fifo_t3[127:96]) == 32'h1000)
	    		area <= ($signed(fifo_t3[31:0]) - $signed(fifo_t3[95:64])) >>> 1;
	    	else 
	    		area <= area_mul >> 13;
	    		
	    	center_of_gravity <= ($signed(fifo_t3[95:64]) + x1 + x2 + $signed(fifo_t3[31:0])) >>> 2;
	    		
	    	area_ready <= 1'b1;
	    end
	    else begin
	    	area <= 32'b0;
	    	area_ready <= 1'b0;
	    	center_of_gravity <= 32'b0;
	    end
    end
    		       	
	    
	// weighted_sum_of_centers
	always@(posedge clk)begin
    	if(~rst) begin
    		area_sum <= 32'b0;        
    		weighted_sum_of_centers <= 32'b0;
    		output_valid <= 1'b0;
    	end
    	else if(area_ready) begin
    		weighted_sum_of_centers <= (center_of_gravity * area) >>> 12;  
    		area_sum <= area;
    		output_valid <= 1'b1;
    	end
    	else begin
    		area_sum <= 32'b0;        
    		weighted_sum_of_centers <= 32'b0;
    		output_valid <= 1'b0;
    	end
    end
    
    
endmodule
    
	

	