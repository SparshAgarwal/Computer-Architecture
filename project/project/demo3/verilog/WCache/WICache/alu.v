module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z, err);
   
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

	reg [15:0]value;
	wire [15:0]sA, sB, w1, w5;
	reg [3:0]cnt;
	reg [1:0]shiftType;
	wire cout;
	wire c12, p, g;
	reg ofl = 1'b0;

	assign sA = (Op==5'b01000)?16'h0010:
			(invA? ~A:A);
	assign sB = (Op==5'b01000)?~{12'h000,B[3:0]}:
			(invB? ~B:B);

sixteenBitCLA CLA(.InA(sA), .InB(sB), .Out(w5), .C0(Cin), .C12(c12), .C16(cout), .P(p), .G(g));							
							
shifter shift(
				//input
				.In		(A),
				.Cnt    (cnt),
				.Op     (shiftType),
				//output
				.Out    (w1));

always @ (*) begin
	casex(Op)
		5'b000??:begin
			cnt = sB[3:0];
			shiftType = Op[1:0];
			value = w1;
		end
		5'b00100:begin //add
			value = w5;
			ofl = sign?(((sA[15]~^sB[15])&(cout^sB[15]))? 1'b1:1'b0 ):(cout? 1'b1:1'b0 );
		end
		5'b00101:begin
			value = sA|sB;
		end
		5'b00110:begin
			value = sA^sB;
		end
		5'b00111:begin
			value = sA&sB;
		end
		5'b01000:begin //rotate right
			cnt = w5[3:0];
			shiftType = 2'b00;
			value = w1;
		end
		5'b01010:begin
			value = (sA==sB)?1:0;
		end
		5'b01011:begin
			value = (w5[15]&~sA[15]&~B[15])|(w5[15]&sA[15]&B[15])|(sA[15]&~B[15]);
		end
		5'b01100:begin
			value = (w5[15]&~sA[15]&~B[15])|(w5[15]&sA[15]&B[15])|(sA[15]&~B[15])|(A==B);
		end
		5'b01101:begin
			value = (cout==1'b1)?1'b1:1'b0;
		end
		5'b01110:begin
			value = (sA==sB)?0:1; //not equal
		end
		5'b01111:begin
			value = (w5[15]==1'b1)?0:1;
		end
		5'b01001:begin
			value = {A[0],A[1],A[2],A[3],A[4],A[5],A[6],A[7],A[8],A[9],A[10],A[11],A[12],A[13],A[14],A[15]};
			
		end
		5'b10000:begin
			cnt = 4'b1000;
			shiftType = 2'b01;
			value = {w1[15:8],sB[7:0]};
		end
		default: begin
			err = 1;
	    end
	endcase
end

assign Ofl = ofl;
assign Out=value;
assign Z=&value;
    
endmodule
