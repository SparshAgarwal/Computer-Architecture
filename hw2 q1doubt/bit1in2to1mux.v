module bit1in2to1mux (lnA, lnB, S, Out);
	input lnA;
	input lnB;
	input S;
	output Out; 
	wire w1;
	wire w2;
	wire w3;

	not1 c1(S, w1);
	nand2 c2(lnA, w1, w2);
	nand2 c3(lnB, S, w3);
	nand2 c4(w2, w3, Out);
   
endmodule 
