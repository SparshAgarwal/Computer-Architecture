module quadmux4_1(InA, InB, InC, InD, S, Out);
	input [3:0] InA;
	input [3:0] InB;
	input [3:0] InC;
	input [3:0] InD;
	input [1:0] S;
	output [3:0] Out; 

	fourto1u2to1 a1 [3:0](InA[3:0], InB[3:0], InC[3:0], InD[3:0], S, Out[3:0]);

endmodule 