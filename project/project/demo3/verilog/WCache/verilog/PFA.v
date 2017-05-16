module PFA(InA, InB, Cin, P, G, Out);

input InA, InB, Cin;
output P, G, Out;

wire w1;

assign P = InA ^ InB;
assign G = InA & InB;
assign Out = P ^ Cin; 

endmodule