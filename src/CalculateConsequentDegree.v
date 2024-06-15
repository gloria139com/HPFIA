`timescale 1 ns / 1 ps

module CalculateConsequentDegree(
	input wire                  clk,
	input wire                  rst,
	input wire                  input_valid,
	input wire[3:0]             input_dim,
	input wire[95:0]            antecedent_degree,
	output reg signed[31:0]     consequent_degree,
	output reg                  consequent_degree_valid
);
      
    always@(posedge clk)begin
    	if(~rst)begin
    		consequent_degree <= 32'b0;           
    		consequent_degree_valid <= 1'b0;
    	end
    	else if(input_valid) begin
    		case(input_dim)
    			4'd1:begin
    				consequent_degree <= $signed(antecedent_degree[95:64]);
    			end
    			4'd2:begin
    				if($signed(antecedent_degree[95:64]) <= $signed(antecedent_degree[63:32]))
    					consequent_degree <= $signed(antecedent_degree[95:64]);
    				else
    					consequent_degree <= $signed(antecedent_degree[63:32]);
    			end
    			4'd3:begin
    				if(($signed(antecedent_degree[95:64]) <= $signed(antecedent_degree[63:32])) && ($signed(antecedent_degree[95:64]) <= $signed(antecedent_degree[31:0])))
    					consequent_degree <= $signed(antecedent_degree[95:64]);
    				else if(($signed(antecedent_degree[63:32]) <= $signed(antecedent_degree[31:0])) && ($signed(antecedent_degree[63:32]) <= $signed(antecedent_degree[95:64])))
    					consequent_degree <= $signed(antecedent_degree[63:32]);
    				else
    					consequent_degree <= $signed(antecedent_degree[31:0]);
    			end
    			default: ;
    		endcase 			
    		
    		consequent_degree_valid <= 1'b1;
    	end
    	else
    		consequent_degree_valid <= 1'b0;
	end
    
endmodule
    