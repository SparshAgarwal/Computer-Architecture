module alu_op(aluOp, last2Bits, Cin, Op, invA, invB, sign, err);

input [4:0] aluOp;
input[1:0]last2Bits;
output reg Cin, invA, invB, sign, err;
output reg [4:0]Op;

  always@(*)
	begin
		casex (aluOp) 
		
		5'b00000: begin  //halt
		end

		5'b01000: begin  //addi
			Cin = 0;
	        Op = 5'b00100; //A+B
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end
		
		5'b01001: begin //subi
			Cin = 1;
	        Op = 5'b00100; //A+B
	        invA = 1;
	        invB = 0;
	        sign = 1;
		end
		
		5'b01010: begin //xori
			Cin = 0;
	        Op = 5'b00110; //A xor B
	        invA = 0;
	        invB = 0;
	        sign = 0;
		end
		
		5'b01011: begin //ANDNI
			Cin = 0;
	        Op = 5'b00111; //A AND B
	        invA = 0;
	        invB = 1;
	        sign = 0;
		end
		
		5'b10100: begin //ROLI
			Cin = 0;
	        Op = 5'b00000; //rotate left
	        invA = 0;
	        invB = 0;
	        sign = 0;
		end
		
		5'b10101: begin //SLLI
			Cin = 0;
	        Op = 5'b00001; //shift left
	        invA = 0;
	        invB = 0;
	        sign = 0;
		end
		
		5'b10110: begin //RORI
			Cin = 1;
	        Op = 5'b01000; //rotate right
	        invA = 0;
	        invB = 0;
	        sign = 0;
		end
		
		5'b10111: begin //SRLI
			Cin = 0;
	        Op = 5'b00011; //shift right log
	        invA = 0;
	        invB = 0;
	        sign = 0;
		end
		
		5'b1000?: begin //ST/LD
			Cin = 0;
	        Op = 5'b00100; //ADD
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end
		
		5'b10011: begin //STU
			Cin = 0;
	        Op = 5'b00100; //ADD
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end

		5'b11001: begin //BTR
			Cin = 0;
	        Op = 5'b01001; //revrse
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end
		
		5'b11011: begin //ADD, SUB...
			Cin = (last2Bits==2'b00)? 0:
				  (last2Bits==2'b01)? 1:
				  (last2Bits==2'b10)? 0:
				  0;
	        Op = (last2Bits==2'b00)?5'b00100:
				 (last2Bits==2'b01)?5'b00100:
				 (last2Bits==2'b10)?5'b00110:
				 5'b00111;
	        invB = (last2Bits==2'b11)?1:0;
	        invA = (last2Bits==2'b01)?1:0;
	        sign =(last2Bits==2'b00)?1:
				  (last2Bits==2'b01)?1:
				  (last2Bits==2'b10)?0:
				  0;
		end

		5'b11010: begin //rotate/shift
			Cin = 1;
	        Op = (last2Bits==2'b00)?5'b00000: //rotate left
				 (last2Bits==2'b01)?5'b00001: //shift left
				 (last2Bits==2'b10)?5'b01000: //rotate right
				 5'b00011; //shift right log
	        invA = 0;
	        invB = 0;
	        sign = 0;
		end

		5'b11100: begin //SEQ
			Cin = 0;
	        Op = 5'b01010; //RS == RT
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end

		5'b11101: begin //SLT
			Cin = 1;
	        Op = 5'b01011; //RS < RT
	        invA = 0;
	        invB = 1;
	        sign = 1;
		end

		5'b11110: begin //SLE
			Cin = 1;
	        Op = 5'b01100; //RS <= RT
	        invA = 0;
	        invB = 1;
	        sign = 1;
		end

		5'b11111: begin //SCO
			Cin = 0;
	        Op = 5'b01101; //CARRY
	        invA = 0;
	        invB = 0;
	        sign = 1;
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

		5'b11000: begin //LBI
			Cin = 0;
	        Op = 5'b00100; //ADD
	        invA = 0;
	        invB = 0;
	        sign = 1;
		end

		5'b10010: begin //SLBI
			Cin = 0;
	        Op = 5'b10000; //CONCAT
	        invA = 0;
	        invB = 0;
	        sign = 0;
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
			err = 1'b1;
		end
		
		endcase
		
	end

endmodule