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
	wire [15:0]sA,sB,w1,w5;
	wire cout;
	reg ofl = 1'b0;

	assign sA = invA? ~A:A;
	assign sB = invB? ~B:B;
	
	
	carry_lookahead_16bit a1(sA,sB,Cin,cout,w5);
	
	shifter s1(sA, sB[3:0], Op[1:0], w1);

always @ (*) begin
	casex(Op)
		3'b0??:begin
			value = w1;
		end
		3'o4:begin
			value = w5;
			assign ofl = sign?(((sA[15]~^sB[15])&(cout^sB[15]))? 1'b1:1'b0 ):(cout? 1'b1:1'b0 );
		end
		3'o5:begin
			value = sA|sB;
		end
		3'o6:begin
			value = sA^sB;
		end
		3'o7:begin
			value = sA&sB;
		end
		default: begin
			$display("Error");
	    end
	endcase
end

assign Ofl = ofl;
assign Out=value;
assign Z=&value;
    
endmodule
