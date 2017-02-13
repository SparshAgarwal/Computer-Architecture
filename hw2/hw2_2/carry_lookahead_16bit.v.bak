module carry_lookahead_16bit(input [15:0] A,B,Cin,
			output Cout, [15:0] S);

	wire cout;

	carry_lookahead_4bit a1(A[3:0], B[3:0], Cin, cout, S[3:0]);
	carry_lookahead_4bit a2(A[7:4], B[7:4], cout, cout, S[7:4]);
	carry_lookahead_4bit a3(A[11:8], B[11:8], cout, cout, S[11:8]);
	carry_lookahead_4bit a4(A[15:12], B[15:12], cout, Cout, S[15:12]);

endmodule