module bit16_2to1mux (input S,[15:0]A,B,
			output [15:0]Out);
	
	bit1in2to1mux a1(A[0],B[0],S, Out[0]);
	bit1in2to1mux a2(A[1],B[1],S, Out[1]);
	bit1in2to1mux a3(A[2],B[2],S, Out[2]);
	bit1in2to1mux a4(A[3],B[3],S, Out[3]);
	bit1in2to1mux a5(A[4],B[4],S, Out[4]);
	bit1in2to1mux a6(A[5],B[5],S, Out[5]);
	bit1in2to1mux a7(A[6],B[6],S, Out[6]);
	bit1in2to1mux a8(A[7],B[7],S, Out[7]);
	bit1in2to1mux a9(A[8],B[8],S, Out[8]);
	bit1in2to1mux a10(A[9],B[9],S, Out[9]);
	bit1in2to1mux a11(A[10],B[10],S, Out[10]);
	bit1in2to1mux a12(A[11],B[11],S, Out[11]);
	bit1in2to1mux a13(A[12],B[12],S, Out[12]);
	bit1in2to1mux a14(A[13],B[13],S, Out[13]);
	bit1in2to1mux a15(A[14],B[14],S, Out[14]);
	bit1in2to1mux a16(A[15],B[15],S, Out[15]);
	
endmodule
