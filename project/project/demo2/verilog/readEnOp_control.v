module readEnOp_control(opcode, readEn1, readEn2, branch);

input [4:0] opcode;
output reg readEn1, readEn2, branch;

assign aluOp = opcode;

  always@(*)
	begin
		casex (opcode)
		
		5'b00000: begin //HALT
			readEn1 = 0;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b00001: begin //NOP
			readEn1 = 0;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b01000: begin //ADDI
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b01001: begin //SUBI
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b01010: begin //XORI
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b01011: begin //ANDNI
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b10100: begin //ROLI
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b10101: begin //SLLI
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b10110: begin //RORI
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b10111: begin //SRLI
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b10000: begin //ST
			readEn1 = 1;
			readEn2 = 1;
			branch = 0;
		end
		
		5'b10001: begin //LD
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end
		
		5'b10011: begin //STU
			readEn1 = 1;
			readEn2 = 1;
			branch = 0;
		end
		
		5'b11001: begin //BTR
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end	
		
		5'b1101?: begin //ADD, SUB, XOR, ANDN, ROL, SLL, ROR, SRL
			readEn1 = 1;
			readEn2 = 1;
			branch = 0;
		end	
		
		5'b111??: begin //SEQ, SLT, SLE, SCO
			readEn1 = 1;
			readEn2 = 1;
			branch = 0;
		end	
		
		5'b011??: begin //BEQZ, BNEZ, BLTZ, BGEZ
			readEn1 = 1;
			readEn2 = 0;
			branch = 1;
		end			
		
		5'b11000: begin //LBI		
			readEn1 = 0;
			readEn2 = 0;
			branch = 0;
		end	
		
		5'b10010: begin //SLBI
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end	
		
		5'b00100: begin //J
			readEn1 = 0;
			readEn2 = 0;
			branch = 0;
		end	
		
		5'b00101: begin //JR
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end	
		
		5'b00110: begin //JAL
			readEn1 = 0;
			readEn2 = 0;
			branch = 0;
		end	
		
		5'b00111: begin //JALR
			readEn1 = 1;
			readEn2 = 0;
			branch = 0;
		end			
		
		default: begin
			//err = 1;
		end
		
		endcase
		
	end

endmodule