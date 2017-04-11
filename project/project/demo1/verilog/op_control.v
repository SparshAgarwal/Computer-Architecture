module op_control(opcode, err, halt, regDesSel, jump, branch, memRdEn, regWrSel, aluOp, memWrEn, aluSrcSel, regWrEn, jriSel, extendSign, data1Sel, r7Sel);

input [4:0] opcode;
output reg err, halt, jump, branch, memRdEn, regWrSel, memWrEn, aluSrcSel, regWrEn, extendSign, data1Sel, r7Sel;
output reg[1:0] regDesSel, jriSel;
output [4:0] aluOp;

assign aluOp = opcode;

  always@(*)
	begin
		casex (opcode)
		
		5'b00000: begin //HALT
			halt = 1;
			regDesSel = 0;
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0;
			memWrEn = 0;
			aluSrcSel = 0;
			regWrEn = 0;
			extendSign = 0;
			data1Sel = 0;
			r7Sel = 0;
		end
		
		5'b00001: begin //NOP
			halt = 0;
			regDesSel = 0;
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0;
			memWrEn = 0;
			aluSrcSel = 0;
			regWrEn = 0;
			jriSel = 0; 
			extendSign = 0;
			data1Sel = 0;
			r7Sel = 0;
		end
		
		5'b01000: begin //ADDI
			halt = 0;
			regDesSel = 2'b01; //write reg address is [7:5]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU result to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b00; //extend [4:0]
			extendSign = 1; //sign extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b01001: begin //SUBI
			halt = 0;
			regDesSel = 2'b01; //write reg address is [7:5]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU reult to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b00; //extend [4:0]
			extendSign = 1; //sign extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b01010: begin //XORI
			halt = 0;
			regDesSel = 2'b01; //write reg address is [7:5]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU reult to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b00; //extend [4:0]
			extendSign = 0; //zero extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b01011: begin //ANDNI
			halt = 0;
			regDesSel = 2'b01; //write reg address is [7:5]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU reult to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b00; //extend [4:0]
			extendSign = 0; //zero extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b10100: begin //ROLI
			halt = 0;
			regDesSel = 2'b01; //write reg address is [7:5]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU reult to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b11; //don't care, not extending
			extendSign = 0; //don't care
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b10101: begin //SLLI
			halt = 0;
			regDesSel = 2'b01; //write reg address is [7:5]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU reult to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b11; //don't care, not extending
			extendSign = 0; //don't care
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b10110: begin //RORI
			halt = 0;
			regDesSel = 2'b01; //write reg address is [7:5]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU reult to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b00; //don't care, noto extending
			extendSign = 0; //don't care
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b10111: begin //SRLI
			halt = 0;
			regDesSel = 2'b01; //write reg address is [7:5]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU reult to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b11; //don't care, not extending
			extendSign = 0; //don't care
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b10000: begin //ST
			halt = 0;
			regDesSel = 2'b11; //don't care - not writing to register
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //don't care - not writing to regiter
			memWrEn = 1;		
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 0;
			jriSel = 2'b00; //extend [4:0]
			extendSign = 1; //sign extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b10001: begin //LD
			halt = 0;
			regDesSel = 2'b01; //write reg add is [7:5]
			jump = 0;
			branch = 0;
			memRdEn = 1;
			regWrSel = 1; //write memory data to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b00; //extend [4:0]
			extendSign = 1; //sign extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b10011: begin //STU
			halt = 0;
			regDesSel = 2'b11;//write reg add is [10:8]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU result to register
			memWrEn = 1;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b00; //extend [4:0]
			extendSign = 1; //sign extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end
		
		5'b11001: begin //BTR
			halt = 0;
			regDesSel = 2'b00; //write reg address is [4:2]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU result to register
			memWrEn = 0;
			aluSrcSel = 0; //use reg data 2
			regWrEn = 1;
			jriSel = 2'b11; //don't care - not sign-extending
			extendSign = 0; //don't care, not extending
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end	
		
		5'b1101?: begin //ADD, SUB, XOR, ANDN, ROL, SLL, ROR, SRL
			halt = 0;
			regDesSel = 2'b00; //write reg address is [4:2]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU result to register
			memWrEn = 0;
			aluSrcSel = 0; //use reg data 2
			regWrEn = 1;
			jriSel = 2'b11; //don't care - not sign-extending
			extendSign = 0; //don't care, not extending
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end	
		
		5'b111??: begin //SEQ, SLT, SLE, SCO
			halt = 0;
			regDesSel = 2'b00; //write reg address is [4:2]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //0 and 1 comes from ALU result
			memWrEn = 0;
			aluSrcSel = 0; //use reg data 2
			regWrEn = 1;
			jriSel = 2'b11; //don't care - not sign-extending
			extendSign = 0; //don't care, not extending
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end	
		
		5'b011??: begin //BEQZ, BNEZ, BLTZ, BGEZ
			halt = 0;
			regDesSel = 2'b00; //don't care - not writing to register
			jump = 0;
			branch = 1;
			memRdEn = 0;
			regWrSel = 0; //don't care - not writing to register (PC)
			memWrEn = 0;
			aluSrcSel = 0; //don't care - not using immediate or reg data
			regWrEn = 0;
			jriSel = 2'b01; //extend [7:0]
			extendSign = 1; //sign extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end			
		
		5'b11000: begin //LBI		
			halt = 0;
			regDesSel = 2'b11; //write to [10:8]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU result to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b01; //extend [7:0]
			extendSign = 1; //sign extend
			data1Sel = 0; //ALU input A is zero
			r7Sel = 0;
		end	
		
		5'b10010: begin //SLBI
			halt = 0;
			regDesSel = 2'b11; //write to [10:8]
			jump = 0;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //write ALU result to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b01; //extend [7:0]	
			extendSign = 0; //zero extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end	
		
		5'b00100: begin //J
			halt = 0;
			regDesSel = 0; //don't care - not writing to register
			jump = 0; //instruction same as branch
			branch = 1;
			memRdEn = 0;
			regWrSel = 0; //don't care - not writing to register
			memWrEn = 0;
			aluSrcSel = 0; //don't care - not using ALU
			regWrEn = 0; 
			jriSel = 2'b10; //extend [10:0]
			extendSign = 1; //sign extend
			data1Sel = 0; //don't care - not using ALU
			r7Sel = 0;
		end	
		
		5'b00101: begin //JR
			halt = 0;
			regDesSel = 0; //don't care - not writing to register
			jump = 1;
			branch = 0; //doesn't matter what branch is
			memRdEn = 0;
			regWrSel = 0; //don't care - not writing to register
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 0;
			jriSel = 2'b01; //sign extend [7:0]
			extendSign = 1; //sign extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 0;
		end	
		
		5'b00110: begin //JAL
			halt = 0;
			regDesSel = 2'b10; //write to R7
			jump = 0; //so PC+2 chosen to be written
			branch = 1;
			memRdEn = 0;
			regWrSel = 0; //don't care - not using memory or ALU result 
			memWrEn = 0;
			aluSrcSel = 0; //don't care - not using ALU 
			regWrEn = 1;
			jriSel = 2'b10; //sign extend [10:0]
			extendSign = 1; //sign extend
			data1Sel = 0; //don't care
			r7Sel = 1;
		end	
		
		5'b00111: begin //JALR
			halt = 0;
			regDesSel = 2'b10; //write to R7			
			jump = 1;
			branch = 0;
			memRdEn = 0;
			regWrSel = 0; //don't care - writing PC+2
			memWrEn = 0;
			aluSrcSel = 1; //use sign-extended immediate
			regWrEn = 1;
			jriSel = 2'b01; //sign extend [7:0]
			extendSign = 1; //sign extend
			data1Sel = 1; //ALU input is register data
			r7Sel = 1;
		end			
		
		default: begin
			err = 1;
		end
		
		endcase
		
	end

endmodule