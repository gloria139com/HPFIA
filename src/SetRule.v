`timescale 1 ns / 1 ps

module SetRule(
	input wire                  clk,
	input wire                  rst,
	input wire                  start,
	input wire[15:0]            index,
	input wire[6:0]             inner_index,
	input wire[3:0]             loop_index,
	input wire[11:0]            nums,
	input wire[3:0]             input_num,
	output reg[47:0]            rules_in_indices,
	output reg                  rules_in_indices_valid
);
  
    always@(posedge clk)begin
    	if(~rst)begin
    		rules_in_indices <= 48'd0;
    		rules_in_indices_valid <= 1'b0;
    	end
    	else if(start) begin  		
    		if(((nums[11:8] == 4'd3) || (nums[11:8] == 4'd4)) && (nums[7:4] == 4'd1) && (nums[3:0] == 4'd1))  begin
    			rules_in_indices[15:0]   <= {14'd0,index[1:0]};
    			rules_in_indices[31:16]  <= 16'd0;
    			rules_in_indices[47:32]  <= 16'd0;
    		end
    		else if((nums[11:8] == 4'd3) && ((nums[7:4] == 4'd3) || (nums[7:4] == 4'd4) || (nums[7:4] == 4'd5)) && (nums[3:0] == 4'd1)) begin
    			rules_in_indices[15:0]   <= {10'd0,inner_index};
    			rules_in_indices[31:16]  <= {12'd0,loop_index};
    			rules_in_indices[47:32]  <= 16'd0;
    		end
    		else if((nums[11:8] == 4'd4) && ((nums[7:4] == 4'd3) || (nums[7:4] == 4'd4)) && (nums[3:0] == 4'd1))  begin
    			rules_in_indices[15:0]   <= {14'd0,index[1:0]};
    			rules_in_indices[31:16]  <= {14'd0,index[3:2]};
    			rules_in_indices[47:32]  <= 16'd0;
    		end
    		else if((nums[11:8] == 4'd3) && (nums[7:4] == 4'd3) && (nums[3:0] == 4'd3)) begin
    			rules_in_indices[15:0]   <= {10'd0,inner_index};
    			rules_in_indices[31:16]  <= ((loop_index == 4'd1) || (loop_index == 4'd4) || (loop_index == 4'd7)) ? 16'd1:(((loop_index == 4'd2) || (loop_index == 4'd5) || (loop_index == 4'd8)) ? 16'd2 : 16'd0);
    			rules_in_indices[47:32]  <= (index < 16'd9) ? 16'd0:((index < 16'd18) ? 16'd1 : 16'd2);
    		end
    		else if((nums[11:8] == 4'd3) && (nums[7:4] == 4'd4) && (nums[3:0] == 4'd3)) begin
    			rules_in_indices[15:0]   <= {10'd0,inner_index};
    			rules_in_indices[31:16]  <= {14'd0,loop_index[1:0]};
    			rules_in_indices[47:32]  <= (index < 16'd12) ? 16'd0:((index < 16'd24) ? 16'd1 : 16'd2);
    		end
    		else if((nums[11:8] == 4'd4) && (nums[7:4] == 4'd3) && (nums[3:0] == 4'd3)) begin
    			rules_in_indices[15:0]   <= {14'd0,index[1:0]};
    			rules_in_indices[31:16]  <= {14'd0,loop_index[3:2]};
    			rules_in_indices[47:32]  <= (index < 16'd12) ? 16'd0:((index < 16'd24) ? 16'd1 : 16'd2);
    		end  				
    		if(index < (nums[11:8] * nums[7:4] * nums[3:0]))  		
    			rules_in_indices_valid <= 1'b1;
    		else
    			rules_in_indices_valid <= 1'b0;
    	end
        else begin
    		rules_in_indices <= 48'd0;
    		rules_in_indices_valid <= 1'b0;
    	end
    end
    
endmodule	
    