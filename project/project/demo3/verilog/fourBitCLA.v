module fourBitCLA(InA, InB, Out, c0, c4, p, g);

input [3:0] InA, InB;
input c0;
output [3:0] Out;
output c4, p, g;

wire p0, p1, p2, p3, g0, g1, g2, g3, c1, c2, c3;

PFA pfa1(.InA(InA[0]), .InB(InB[0]), .Cin(c0), .P(p0), .G(g0), .Out(Out[0]));
PFA pfa2(.InA(InA[1]), .InB(InB[1]), .Cin(c1), .P(p1), .G(g1), .Out(Out[1]));
PFA pfa3(.InA(InA[2]), .InB(InB[2]), .Cin(c2), .P(p2), .G(g2), .Out(Out[2]));
PFA pfa4(.InA(InA[3]), .InB(InB[3]), .Cin(c3), .P(p3), .G(g3), .Out(Out[3]));

assign c1 = g0 | (p0 & c0);
assign c2 = g1 | (p1 & g0) | (p1 & p0 & c0);
assign c3 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & c0);
assign c4 = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) | (p3 & p2 & p1 & p0 & c0);

assign p = p0 & p1 & p2 & p3;
assign g = g3 | (g2 & p3) | (g1 & p2 & p3) | (g0 & p1 & p2 & p3);

endmodule