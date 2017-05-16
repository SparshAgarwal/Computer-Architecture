module reg16bit(clk, reset, in, out);


	parameter WIDTH = 16;
	input clk, reset;
	input [WIDTH-1:0] in;
	output [WIDTH-1:0] out;
	wire [WIDTH-1:0] w1;

  dff outp[WIDTH-1:0] (.q(w1), .d(in), .clk(clk), .rst(reset));
  
						
   assign out = w1;

endmodule