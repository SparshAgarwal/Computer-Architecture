module reg16bit( input clk, reset,[15:0]in,
		output [15:0]out);

	wire [15:0]w1;

  dff outp[15:0] (
                        // Outputs
                        .q              (w1),
                        // Inputs
                        .d              (in),
                        .clk            (clk),
                        .rst            (reset));
assign out = w1;

endmodule