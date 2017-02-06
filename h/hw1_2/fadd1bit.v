module fadd1bit (A, B, Cin, S, Cout);
	input A;
	input B;
	input Cin;
	output S;
	output Cout; 
	wire w1;
	wire w2;
	wire w3;

	xor2 c1(A, B, w1);
	nand2 c2(A, B, w2);
	nand2 c3(Cin, w1, w3);
	nand2 c4(w2, w3, Cout);
	xor2 c5(w1, Cin, S);
   
endmodule 