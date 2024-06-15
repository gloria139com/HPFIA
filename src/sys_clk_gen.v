
`timescale 1 ps / 1 ps

module sys_clk_gen # (
  parameter TCQ       = 100,
  parameter offset    = 0,
  parameter halfcycle = 500

)(
  output reg sys_clk = 1'b0
);

  initial begin
    #(offset);
    forever #(halfcycle) sys_clk = ~sys_clk;
  end

endmodule



