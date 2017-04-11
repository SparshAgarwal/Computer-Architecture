module shift_left(input [3:0]S,[15:0]A,B,
			output [15:0]Out);

	bit16_2to1mux a1(S[3],A,{A[7:0],8'b00000000},A);
	bit16_2to1mux a2(S[2],A,{A[11:0],4'b0000},A);
	bit16_2to1mux a3(S[1],A,{A[13:0],2'b00},A);
	bit16_2to1mux a4(S[0],A,{A[14:0],1'b0},A);


endmodule
