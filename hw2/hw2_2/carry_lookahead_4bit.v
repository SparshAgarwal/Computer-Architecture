module carry_lookahead_4bit(input [3:0]A,B,[0:0]Cin,
			output Cout, [3:0]S);

	wire cout1,cout2,cout3;
	wire p[3:0];
	wire g[3:0];

	fadd1bit a1(A[0], B[0], Cin, S[0], p[0], g[0]);
	assign cout1 = g[0]|(Cin&p[0]);
	fadd1bit a2(A[1], B[1], cout1, S[1], p[1], g[1]);
	assign cout2 = g[1]|(cout1&p[1]);
	fadd1bit a3(A[2], B[2], cout2, S[2], p[2], g[2]);
	assign cout3 = g[2]|(cout2&p[2]);
	fadd1bit a4(A[3], B[3], cout3, S[3], p[3], g[3]);
	assign Cout = g[3]|(cout3&p[3]);

endmodule
