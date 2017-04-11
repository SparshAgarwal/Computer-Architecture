module fourto1u2to1(lnA, lnB, lnC, lnD, S, Out);
	
	input lnA;
	input lnB;
	input lnC;
	input lnD;
	input [1:0] S;
	output Out; 


	wire w1;
	wire w2;
	wire w3;

	bit1in2to1mux b1(lnA, lnB, S[0], w1);
	bit1in2to1mux b2(lnC, lnD, S[0], w2);
	bit1in2to1mux b3(w1, w2, S[1], Out);
   
endmodule 