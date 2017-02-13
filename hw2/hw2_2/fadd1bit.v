module fadd1bit (A, B, Cin, S, p,q);
	input A;
	input B;
	input Cin;
	output S;
	output p;
	output g; 
	wire w1;
	wire w2;
	wire w3;

	xor2 c1(A, B, w1);
	nand2 c2(A, B, w2);
	nand2 c3(Cin, w1, w3);
	xor2 c5(w1, Cin, S);
	assign p = w1;
	assign g = ~w2;
   
endmodule 
