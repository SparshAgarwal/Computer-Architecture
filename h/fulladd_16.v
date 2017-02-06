
module fulladd_16 (input [15:0] A, B,

		  output [15:0] SUM,
		  output CO);

   assign {CO, SUM} = A + B;
   
endmodule // fulladd_16

   
