module carry_lookahead_16bit(input [15:0] A,B,[0:0]Cin,
			output Cout, [15:0] S);

	wire cout[2:0];

	carry_lookahead_4bit a1(A[3:0], B[3:0], Cin, cout[0], S[3:0]);
	carry_lookahead_4bit a2(A[7:4], B[7:4], cout[0], cout[1], S[7:4]);
	carry_lookahead_4bit a3(A[11:8], B[11:8], cout[1], cout[2], S[11:8]);
	carry_lookahead_4bit a4(A[15:12], B[15:12], cout[2], Cout, S[15:12]);

endmodule
