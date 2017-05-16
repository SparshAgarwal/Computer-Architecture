module sixteenBitCLA(InA, InB, Out, C0, C12, C16, P, G);

input [15:0] InA, InB;
input C0;
output [15:0] Out;
output C12, C16, P, G;

wire P0, P4, P8, P12, G0, G4, G8, G12, C4, C8, C12;

fourBitCLA cla1(.InA(InA[3:0]), .InB(InB[3:0]), .Out(Out[3:0]), .c0(C0), .c4(C4), .p(P0), .g(G0));
fourBitCLA cla2(.InA(InA[7:4]), .InB(InB[7:4]), .Out(Out[7:4]), .c0(C4), .c4(C8), .p(P4), .g(G4));
fourBitCLA cla3(.InA(InA[11:8]), .InB(InB[11:8]), .Out(Out[11:8]), .c0(C8), .c4(C12), .p(P8), .g(G8));
fourBitCLA cla4(.InA(InA[15:12]), .InB(InB[15:12]), .Out(Out[15:12]), .c0(C12), .c4(C16), .p(P12), .g(G12));

assign P = P0 & P4 & P8 & P12;
assign G = G12 | (G8 & P12) | (G4 & P8 & P12) | (G0 & P4 & P8 & P12);

endmodule