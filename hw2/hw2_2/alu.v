module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z);
   
        input [15:0] A;
        input [15:0] B;
        input Cin;
        input [2:0] Op;
        input invA;
        input invB;
        input sign;
        output [15:0] Out;
        output Ofl;
        output Z;

	reg [15:0]value;
	reg zero_value = 0'b0;
	wire [15:0] w1,w2,w3,w4,cout;

	assign A = invA? ~A:A;
	assign B = invB? ~B:B;
	
	carry_lookahead_16bit a1(A,b,Cin,cout,Out)
	assign Ofl = sign?((A[15]~^B[15])&cout? 1'b1:1'b0 ):1'b0;

	shifter s1(A, B[3:0], Op[1:0], w1);
	shifter s2(A, B[3:0], Op[1:0], w2);
	shifter s3(A, B[3:0], Op[1:0], w3);
	shifter s4(A, B[3:0], Op[1:0], w4);


always @ (*) begin
	case(Op)
		3'o0:begin
			value = w1;
		end
		3'o1:begin
			value = w2;
		end
		3'o2:begin
			value = w3;
		end
		3'o3:begin
			value = w4;
		end
		3'o4:begin
			value = w4;
		end
		3'o5:begin
			value = A|B;
		end
		3'o6:begin
			value = A^B;
		end
		3'o7:begin
			value = A&B;
		end
		default: begin
	        	value =A;
	        end
	endcase
end

assign Out=value;
assign Z=zero_value;
    
endmodule
