module alu_op_branch(aluOp, last2Bits, Cin, Op, invA, invB, sign, err);

input [4:0] aluOp;
input[1:0]last2Bits;
output reg Cin, invA, invB, sign, err;
output reg [4:0]Op;

  always@(*)
	begin
		casex (aluOp) 
		
		5'b00000: begin  //halt
		end

		5'b00001: begin  //nop
		end

		5'b01100: begin //BEQZ
			Cin = 0;
	        Op = 5'b01010; //RT == RT
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end

		5'b01101: begin //BNEZ
			Cin = 0;
	        Op = 5'b01110; //RS != RT
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end
		
		5'b01110: begin //BLTZ
			Cin = 1;
	        Op = 5'b01011; //RS < RT
	        invA = 0;
	        invB = 1;
	        sign = 1;
		end

		5'b01111: begin //BGEZ
			Cin = 1;
	        Op = 5'b01111; //RS GT RT
	        invA = 0;
	        invB = 1;
	        sign = 1;
		end

		5'b001?0: begin //J and JAL
			Cin = 0;
	        Op = 5'b00100; //ADD
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end


		5'b00101: begin //JR
			Cin = 0;
	        Op = 5'b00100; //ADD
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end

		5'b00111: begin //JALR
			Cin = 0;
	        Op = 5'b00100; //ADD
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end

		default: begin
			err = 1;
		end
		
		endcase
		
	end

endmodule