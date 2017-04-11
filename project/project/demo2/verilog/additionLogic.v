module additionLogic(A, B, Cin, sign, Op, Out, Ofl);

input [15:0] A, B;
input [1:0] Op;
input Cin, sign;
output [15:0] Out;
output Ofl;

wire c12, c16, p, g, signedOfl, unsignedOfl, neg, negOfl, posOfl;
wire[15:0] addOut, w1, w2, out1, out2, out3;

	sixteenBitCLA cla(.InA(A), .InB(B), .Out(addOut), .C0(Cin), .C12(c12), .C16(c16), .P(p), .G(g));
	
	assign out1 = A | B;
	assign out2 = A ^ B;
	assign out3 = A & B;
	
	assign w1 = Op[0] ? out1 : addOut;
	assign w2 = Op[0] ? out3 : out2;
	assign Out = Op[1] ? w2 : w1;

	assign neg = (A[15] & B[15]) ? 1 : 0;
	assign negOfl = (neg & ~Out[15]) ? 1 : 0; //if two negative numbers yield positive result
	assign posOfl = (~neg & Out[15]) ? 1 : 0; //if two positive numbers yield negative result
 	assign signedOfl = negOfl | posOfl;
	assign unsignedOfl = c16 ? 1 : 0;
	assign Ofl = sign ? signedOfl : unsignedOfl;
	
endmodule