`timescale 1 ns / 1 ps


module div_pack(
	input wire                  clk,
	input wire                  input_valid,
	input wire[63:0]            dividend,
	input wire[31:0]            divisor,
	output wire[63:0]           quotient,
	output wire                 quotient_valid,	
	output wire                 dividend_tready,
	output wire                 divisor_tready
);

    div_gen_0 div_uut(   
    .aclk                        (clk),
    .s_axis_divisor_tvalid       (input_valid),
    .s_axis_divisor_tready       (divisor_tready), //OUT STD_LOGIC;
    .s_axis_divisor_tdata        (divisor),
    .s_axis_dividend_tvalid      (input_valid),
    .s_axis_dividend_tready      (dividend_tready), //OUT STD_LOGIC; 
    .s_axis_dividend_tdata       (dividend),
    .m_axis_dout_tvalid          (quotient_valid),       
    .m_axis_dout_tdata           (quotient)  
    
    
  );
  
  
    
  
endmodule