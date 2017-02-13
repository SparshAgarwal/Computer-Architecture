module shift_right_logical(input [3:0]S,[15:0]A,B,
			output [15:0]Out);

	bit16_2to1mux a1(S[3],A,{8'b00000000,A[15:8]},A);
	bit16_2to1mux a2(S[2],A,{4'b0000,A[15:4]},A);
	bit16_2to1mux a3(S[1],A,{2'b00,A[15:2]},A);
	bit16_2to1mux a4(S[0],A,{1'b0,A[15:1]},A);


endmodule