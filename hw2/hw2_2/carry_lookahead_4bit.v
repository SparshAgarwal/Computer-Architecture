module carry_lookahead_4bit(input [3:0]A,B,[0:0]Cin,
			output Cout, [3:0]S);

	wire cout1,cout2,cout3;
	wire p;
	wire g;

	fadd1bit a1(A[0], B[0], Cin, S[0], p, g);
	assign cout1 = g|(Cin&p);
	fadd1bit a2(A[1], B[1], cout, S[1], p, g);
	assign cout2 = g|(cout1&p);
	fadd1bit a3(A[2], B[2], cout, S[2], p, g);
	assign cout3 = g|(cout2&p);
	fadd1bit a4(A[3], B[3], cout, S[3], p, g);
	assign Cout = g|(cout&p);

endmodule