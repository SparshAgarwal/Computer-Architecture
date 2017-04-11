module simpleAlu (A, B, Cin, Op, sign, Out, Ofl, Z);
   
        input [15:0] A;
        input [15:0] B;
        input Cin; //carry in for LSB of adder
        input [2:0] Op;
        input sign; //signed if 1
        output [15:0] Out;
        output Ofl; //overflow
        output Z; //result is zero	

	assign Z = Out == 0 ? 1 : 0;
	
	wire [15:0] out1, out2;
	wire	overflow;
	
	additionLogic addlogic(.A(A), .B(B), .Cin(Cin), .sign(sign), .Op(Op[1:0]), .Out(out2), .Ofl(overflow));
		
	assign Out = out2; //no more shifter
    assign Ofl = Op[2] ? overflow : 0;
	
endmodule
