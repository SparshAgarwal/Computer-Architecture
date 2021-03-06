module rippleadd4bit (input CI, [3:0] A, B,
			output CO, [3:0]SUM);
	wire w1;
	wire w2;
	wire w3;

	fadd1bit c1(A[0], B[0], CI, SUM[0], w1);
	fadd1bit c2(A[1], B[1], w1, SUM[1], w2);
	fadd1bit c3(A[2], B[2], w2, SUM[2], w3);
	fadd1bit c4(A[3], B[3], w3, SUM[3], CO);
   
endmodule 