module alu_branch (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z, err, branchCon);
   
        input [15:0] A;
        input [15:0] B;
        input Cin;
        input [4:0] Op;
        input invA;
        input invB;
        input sign;
        output [15:0] Out;
        output Ofl;
        output Z;
        output reg err;
        output reg branchCon;

	reg [15:0]value;
	wire [15:0]sA, sB, w5;
	wire cout;
	wire c12, p, g;
	reg ofl = 1'b0;

	assign sA = (Op==5'b01000)?16'h0010:
			(invA? ~A:A);
	assign sB = (Op==5'b01000)?~{12'h000,B[3:0]}:
			(invB? ~B:B);

sixteenBitCLA CLA(.InA(sA), .InB(sB), .Out(w5), .C0(Cin), .C12(c12), .C16(cout), .P(p), .G(g));		

always @ (*) begin
	casex(Op)
		5'b01010:begin
			value = (sA==sB)?1:0;
			branchCon = value==1?1:0;
		end
		5'b01110:begin
			value = (sA==sB)?0:1; //not equal
			branchCon = value==1?1:0;
		end
		5'b01011:begin
			value = (w5[15]&~sA[15]&~B[15])|(w5[15]&sA[15]&B[15])|(sA[15]&~B[15]);
			branchCon = value==1?1:0;
		end
		5'b01111:begin
			value = (w5[15]==1'b1)?0:1;
			branchCon = value==1?1:0;
		end
		5'b00100:begin //add
			branchCon = 1; //jump for J and JAL
			value = w5;
			ofl = sign?(((sA[15]~^sB[15])&(cout^sB[15]))? 1'b1:1'b0 ):(cout? 1'b1:1'b0 );
		end
		default: begin
			branchCon = 0;
			err = 1;
	    end
	endcase
end

assign Ofl = ofl;
assign Out=value;
assign Z=&value;
    
endmodule
