module shift_right_arithmetic(input [3:0]S,[15:0]A,B,
			output [15:0]Out);

	bit16_2to1mux a1(S[3],A,{{8{A[15]}},A[15:8]},A);
	bit16_2to1mux a2(S[2],A,{{4{A[15]}},A[15:4]},A);
	bit16_2to1mux a3(S[1],A,{{2{A[15]}},A[15:2]},A);
	bit16_2to1mux a4(S[0],A,{{1{A[15]}},A[15:1]},A);


endmodule