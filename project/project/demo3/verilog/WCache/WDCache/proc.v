/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
	// Outputs
	err,
	// Inputs
	clk, rst
	);

	input clk;
	input rst;

	output err;
	// None of the above lines can be modified
	
	wire [15:0] instrOut, pcCurrent, pcNext, pcNext_final, plus2Out, writedata, memAluData, memDataOut, read1data, read2data, mainALUresult,mainALUresult_branch, imm, aluA, aluB, aluBtemp, read2dataTemp, read2dataTemp_final, read2dataTemp_branch, aluA_branch, aluB_branch, aluBtemp_branch, sixteenZero;
	wire [15:0] instrOut_IDEX, instrOut_IFID, instrOut_EXMEM, instrOut_MEMWB, instrOut_MEMWB_final, instrOut_WBEND, plus2Out_EXMEM, plus2Out_IDEX, plus2Out_IFID, plus2Out_MEMWB, memDataOut_MEMWB, memDataIn, read1data_IDEX, read2data_EXMEM, read2data_IDEX, mainALUresult_EXMEM, mainALUresult_MEMWB, imm_IDEX, simpleALUResult, simpleALUResult_EXMEM, instrOutTemp, instrOutTemp2;
	wire [4:0] aluOp, op, op_branch;
	wire [4:0] aluOp_IDEX, instrOut_IFID_final;
	wire [2:0] addition;
	wire [2:0] writereg1, writereg2, writeregsel;
	wire [2:0] writeregsel_EXMEM, writeregsel_IDEX, writeregsel_MEMWB;
	wire [1:0] regDesSel, jriSel, inputForA, inputForB;
	wire [1:0] regDesSel_IDEX;
	wire halt, jump, branch, memRdEn, regWrSel, memWrEn, aluSrcSel, regWrEn, opCtrlErr, branchCon, extendSign, cin, cin_branch, invA, invB, invA_branch, invB_branch, sign, sign_branch, aluCtrlErr, aluCtrlErr_branch, data1Sel, aluErr, aluErr_branch, ofl, ofl_branch, zeroFlag, r7Sel, zero, temp1, temp2, temp3, temp4, temp5, temp9, temp10, temp11, temp12, temp13, temp14, temp15, temp16, temp17, temp18, temp20, temp21;
	wire halt_EXMEM, halt_IDEX, jump_MEMWB, jump_EXMEM, jump_IDEX, branch_MEMWB, branch_EXMEM, branch_IDEX, regWrSel_EXMEM, regWrSel_IDEX, regWrSel_MEMWB, memWrEn_EXMEM, memWrEn_IDEX, aluSrcSel_IDEX, regWrEn_EXMEM, regWrEn_IDEX, regWrEn_MEMWB, branchCon_EXMEM, branchCon_IDEX, branchCon_MEMWB, data1Sel_IDEX, r7Sel_EXMEM, r7Sel_IDEX, r7Sel_MEMWB, stall, halt_MEMWB, halt_MEMWB_final, halt_WBEND, readEn1, readEn2, readEn1_IDEX, readEn2_IDEX, readEn1_IFID, readEn1_final, readEn2_final, readEn2_IFID , flush, branch_detect, branch_detect_IDEX, branch_detect_EXMEM, branch_detect_MEMWB, jump_detect, jump_detect_IDEX, jump_detect_EXMEM, jump_detect_MEMWB, memRdEn_IDEX, memRdEn_EXMEM, bypass, bypassReg1, bypassReg2;

	//New mem_systems
	wire dataMemErr, data_mem_hit, data_mem_stall, data_mem_done, LS;
	wire [15:0] mainALUresult_final, plus2Out_IDEX_final, instrOut_IDEX_final, read2data_IDEX_final, simpleALUResult_final;
	wire [2:0] writeregsel_IDEX_final;
	wire branch_detect_IDEX_final, jump_detect_IDEX_final, dataRW_final, halt_IDEX_final, regWrSel_IDEX_final, memWrEn_IDEX_final, regWrEn_IDEX_final, r7Sel_IDEX_final, branchCon_final, branch_IDEX_final, jump_IDEX_final, memRdEn_IDEX_final ;
	wire  regWrSel_EXMEM_final, regWrEn_EXMEM_final, r7Sel_EXMEM_final, halt_EXMEM_final, branchCon_EXMEM_final, branch_EXMEM_final, jump_EXMEM_final;
	wire [15:0] plus2Out_IFID_final, instrOut_IFID_final2, read1data_final, read2data_final, imm_final, plus2Out_final, instrOutTemp2_final;
	wire[4:0] aluOp_final;
	wire [2:0] writeregsel_final;
	wire branch_detect_final, jump_detect_final, halt_final, regWrSel_final, memWrEn_final, aluSrcSel_final, data1Sel_final, regWrEn_final, r7Sel_final, branch_final, jump_final, memRdEn_final, readEn_IDEX_final, branchCon_IDEX_final, readEn_final, readEn1_IFID_final, readEn2_IFID_final, readEn_IDEX, readEn, readEn_EXMEM, dataReading, dataRW;
	wire [15:0] memDataOut_final, mainALUresult_EXMEM_final, plus2Out_EXMEM_final, instrOut_EXMEM_final ;
	wire[2:0] writeregsel_EXMEM_final;
	wire branch_detect_EXMEM_final, jump_detect_EXMEM_final;
	//end new mem_systems


  reg  data;
  wire  [4:0]aluOpFinal;
	
	wire one;
	assign one = 1'b1;
	assign addition = 3'b100;

//***************INSTRUCTION FETCH STAGE***************//
	//Instruction Memory
	assign zero = 0;
	assign sixteenZero = 16'b0;

	memory2c instrMem(
 								.data_out(instrOut),
 								.data_in(sixteenZero),
 								.addr(pcCurrent),
 								.enable(one),
 								.wr(zero),
								.createdump(zero),
								.clk(clk),
								.rst(rst));

		
	assign pcNext_final = data_mem_stall ? pcCurrent : pcNext; 

	dff pc [15:0](.q(pcCurrent), .d(pcNext_final), .clk(clk), .rst(rst));
		
	//PC Control
	pc_control pcCtrl(
								.stall(stall),
								.jump(jump),
								.branch(branch),
								.mainALUresult(mainALUresult_branch), 
								.pcCurrent(pcCurrent),
								.readAdd(pcNext),
								.plus2Out(plus2Out), //note: there's also an internal plus2Out wire
								.branchCon(branchCon),
								.simpleALUResult(simpleALUResult));	
	
	//***************************************************//

	//read readenables //TODO branch_detect and jump_detect may not be required now
	readEnOp_Control readEnOps(.opcode(instrOut_IFID[15:11]), .readEn1(readEn1), .readEn2(readEn2), .branch(branch_detect), .jump(jump_detect));

	assign stall =  0; // TODO Include memory stall // TODO what do with instructions in diff stages when mem_stall
	assign flush = (branchCon_IDEX & branch_IDEX & branch_detect_IDEX) | 
                  ((jump_IDEX ^ branch_IDEX) & jump_detect_IDEX) | 
                 (halt_IDEX | halt_EXMEM | halt_MEMWB | halt_WBEND) ? 1:0;
	
	assign instrOutTemp = flush ? 16'h0800 : instrOut_IFID;
  	assign instrOutTemp2 = stall ? instrOutTemp : instrOut;

  	//data_mem_system
	assign plus2Out_final = data_mem_stall  ? plus2Out_IFID : plus2Out;
	assign instrOutTemp2_final = data_mem_stall  ? instrOut_IFID : instrOutTemp2;
	assign readEn1_final = data_mem_stall  ? readEn1_IFID : readEn1;
	assign readEn2_final = data_mem_stall  ? readEn2_IFID : readEn2;
	//end data_mem_system

	
	//IF/ID REGISTERS
	dff IFIDplus2Out [15:0](.q(plus2Out_IFID), .d(plus2Out_final), .clk(clk), .rst(rst)); 
	
  dff IFIDinstructiona [3:0](.q(instrOut_IFID[15:12]), .d(instrOutTemp2_final[15:12]), .clk(clk), .rst(rst));
	dff IFIDinstructionb (.q(instrOut_IFID[11]), .d(data), .clk(clk), .rst(zero));
	dff IFIDinstructionc [10:0](.q(instrOut_IFID[10:0]), .d(instrOutTemp2_final[10:0]), .clk(clk), .rst(rst));
	dff IFIDreadEn1  (.q(readEn1_IFID), .d(readEn1_final), .clk(clk), .rst(rst));
	dff IFIDreadEn2  (.q(readEn2_IFID), .d(readEn2_final), .clk(clk), .rst(rst));




 

  always@(*)begin case(rst)
    1'b0: begin 
        data = instrOutTemp2_final[11];
      end
    1'b1: begin
        data = 1; 
      end
    default begin
        data = 1;
      end
    endcase
  end

	//*******INSTRUCTION DECODE/REG FILE READ STAGE*******//

	assign instrOut_IFID_final = (stall|flush) ? 5'b00001: instrOut_IFID[15:11];
	
	//OP Control
	op_control opCtrl (.opcode(instrOut_IFID_final), .err(opCtrlErr), .halt(halt), .regDesSel(regDesSel), .jump(jump), .branch(branch), .memRdEn(memRdEn), .regWrSel(regWrSel), .aluOp(aluOp), .memWrEn(memWrEn), .aluSrcSel(aluSrcSel), .regWrEn(regWrEn), .jriSel(jriSel), .extendSign(extendSign), .data1Sel(data1Sel), .r7Sel(r7Sel), .rst(rst));

	assign bypass =  (regWrEn_MEMWB && (((instrOut_IFID[10:8] == writeregsel_MEMWB) && (readEn1)) || (instrOut_IFID[7:5] == writeregsel_MEMWB) && (readEn2)))? 1 : 0;
	assign bypassReg1 = (instrOut_IFID[10:8] == writeregsel_MEMWB)? 1 : 0;
	assign bypassReg2 = (instrOut_IFID[7:5] == writeregsel_MEMWB)? 1 : 0;


	//Register File
	rf_bypass regFile (.read1data(read1data), .read2data(read2data), .err(regFileErr), .clk(clk), .rst(rst), .read1regsel(instrOut_IFID[10:8]), .read2regsel(instrOut_IFID[7:5]), .writeregsel(writeregsel_MEMWB), .writedata(writedata), .write(regWrEn_MEMWB), .bypass(bypass), .bypassReg1(bypassReg1), .bypassReg2(bypassReg2));
	//regWrEn set in writeback stage, writeregsel determined in execute stage and piped down

	//Immediate Extend
	extendImm extend(.instr(instrOut_IFID), .jriSel(jriSel), .extendSign(extendSign), .extendedImm(imm));

	//choose register to write to
	assign writereg1 = regDesSel[0] ? instrOut_IFID[7:5] : instrOut_IFID[4:2] ; //choose between [4:2] and [7:5]
	assign writereg2 = regDesSel[0] ? instrOut_IFID[10:8] : 3'b111; //choose between R7 and [10:8]
	assign writeregsel = regDesSel[1] ? writereg2 : writereg1;

	//pc control ALU
	simpleAlu pcALU(.A(pcCurrent), .B(imm), .Cin(zero), .Op(addition), .sign(zero), .Out(simpleALUResult), .Ofl(aluOfl), .Z(aluZero));
	//aluOfl, aluZero not used

	//ALU Control for branch
	alu_op_branch aluCtrl_branch(.aluOp(aluOp), .last2Bits(instrOut[1:0]), .Cin(cin_branch), .Op(op_branch), .invA(invA_branch), .invB(invB_branch), .sign(sign_branch), .err(aluCtrlErr_branch));


	assign temp9 = ((instrOut_IFID[10:8] == writeregsel_EXMEM) & regWrEn_EXMEM & readEn1 ) ? 1 : 0; // For A
	assign temp10 = ((instrOut_IFID[10:8] == writeregsel_MEMWB) & regWrEn_MEMWB & readEn1 ) ? 1 : 0; // For A
	assign temp13 = ((instrOut_IFID[10:8] == writeregsel_IDEX) & regWrEn_IDEX & readEn1 ) ? 1 : 0; // For A
	assign temp15 = instrOut_IFID[15:11] == 5'b00110 ? 1 : 0; // For A jal
	assign temp16 = (instrOut_IFID[15:11] == 5'b00111) & (( 3'b111 == writeregsel_IDEX) & (instrOut_IFID[10:8] == writeregsel_IDEX) & regWrEn_IDEX ) ? 1 : 0; // For A jalr
	assign temp17 = (instrOut_IFID[15:11] == 5'b00111) & (( 3'b111 == writeregsel_EXMEM) & (instrOut_IFID[10:8] == writeregsel_EXMEM) & regWrEn_EXMEM ) ? 1 : 0; // For A jalr

	assign temp11 = ((instrOut_IFID[7:5] == writeregsel_EXMEM) & regWrEn_EXMEM & readEn2 )? 1 : 0; // For B
	assign temp12 = ((instrOut_IFID[7:5] == writeregsel_MEMWB) & regWrEn_MEMWB & readEn2 )? 1 : 0; // For B
	assign temp14 = ((instrOut_IFID[7:5] == writeregsel_IDEX) & regWrEn_IDEX & readEn2 )? 1 : 0; // For B
	 
	assign aluA_branch =  temp16 ? plus2Out_IDEX : (temp17 ? plus2Out_EXMEM : (temp15 ? plus2Out : (temp13 ? mainALUresult : (temp9 ? mainALUresult_EXMEM :( temp10 ? writedata : ( data1Sel ? read1data : 0))))));
	assign read2dataTemp_branch = temp14 ? mainALUresult : (temp11 ? mainALUresult_EXMEM : (temp12 ? writedata : read2data));
	assign aluB_branch = branch ? 0 : (aluSrcSel ? imm : read2dataTemp_branch);
	 
	//ALU for branch
	//assign aluA_branch = data1Sel ? read1data : 0;
	//assign aluBtemp_branch = aluSrcSel ? imm : read2data;
	//assign aluB_branch = branch ? 0 : aluBtemp_branch;
	alu_branch mainALU_branch(.A(aluA_branch), .B(aluB_branch), .Cin(cin_branch), .Op(op_branch), .invA(invA_branch), .invB(invB_branch), .sign(sign_branch), .Out(mainALUresult_branch), .Ofl(ofl_branch), .Z(zeroFlag), .err(aluErr_branch), .branchCon(branchCon));
	//outputs ofl, zeroFlag not used, no need to pipeline

	//***************************************************//
	 
	//data_mem_system
	assign plus2Out_IFID_final = data_mem_stall  ? plus2Out_IDEX : plus2Out_IFID;
	assign instrOut_IFID_final2 = data_mem_stall  ? instrOut_IDEX : instrOut_IFID;
	assign read1data_final = data_mem_stall  ? read1data_IDEX : read1data;
	assign read2data_final = data_mem_stall  ? read2data_IDEX : read2data;
	assign imm_final = data_mem_stall  ? imm_IDEX : imm;
	assign aluOp_final = data_mem_stall  ? aluOp_IDEX : aluOp;
	assign writeregsel_final = data_mem_stall  ? writeregsel_IDEX : writeregsel;
	assign branch_detect_final = data_mem_stall  ? branch_detect_IDEX : branch_detect;
	assign jump_detect_final = data_mem_stall  ? jump_detect_IDEX : jump_detect;
	
	assign halt_final = data_mem_stall  ? halt_IDEX : halt;
	assign regWrSel_final = data_mem_stall  ? regWrSel_IDEX : regWrSel;
	assign memWrEn_final = data_mem_stall  ? memWrEn_IDEX : memWrEn;
	assign aluSrcSel_final = data_mem_stall  ? aluSrcSel_IDEX : aluSrcSel;
	assign data1Sel_final = data_mem_stall  ? data1Sel_IDEX : data1Sel;
	assign regWrEn_final = data_mem_stall  ? regWrEn_IDEX : regWrEn;
	assign r7Sel_final = data_mem_stall  ? r7Sel_IDEX : r7Sel;
	assign branch_final = data_mem_stall  ? branch_IDEX : branch;
	assign jump_final = data_mem_stall  ? jump_IDEX : jump;
	assign memRdEn_final = data_mem_stall  ? memRdEn_IDEX : memRdEn;
	assign readEn_final = data_mem_stall  ? readEn_IDEX : readEn;
	assign readEn1_IFID_final = data_mem_stall  ? readEn1_IDEX : readEn1_IFID;
	assign readEn2_IFID_final = data_mem_stall  ? readEn2_IDEX : readEn2_IFID;
	assign branchCon_final = data_mem_stall  ? branchCon_IDEX : branchCon;
	//end data_mem_system
	 
	dff IDEXplus2Out [15:0](.q(plus2Out_IDEX), .d(plus2Out_IFID_final), .clk(clk), .rst(rst)); 
	dff IDEXinstrOut [15:0](.q(instrOut_IDEX), .d(instrOut_IFID_final2), .clk(clk), .rst(rst));
	dff IDEXread1data [15:0](.q(read1data_IDEX), .d(read1data_final), .clk(clk), .rst(rst));
	dff IDEXread2data [15:0](.q(read2data_IDEX), .d(read2data_final), .clk(clk), .rst(rst));
	dff IDEXimm [15:0](.q(imm_IDEX), .d(imm_final), .clk(clk), .rst(rst));
	dff IDEXaluOp [4:0](.q(aluOp_IDEX), .d(aluOp_final), .clk(clk), .rst(rst));
	dff IDEXwriteregsel [2:0] (.q(writeregsel_IDEX), .d(writeregsel_final), .clk(clk), .rst(rst));
  	dff IDEXbranch_detect (.q(branch_detect_IDEX), .d(branch_detect_final), .clk(clk), .rst(rst)); 
	dff IDEXjump_detect (.q(jump_detect_IDEX), .d(jump_detect_final), .clk(clk), .rst(rst)); 

	//control signals: 
	dff IDEXreadEn  (.q(readEn_IDEX), .d(readEn_final), .clk(clk), .rst(rst));
	dff IDEXreadEn1  (.q(readEn1_IDEX), .d(readEn1_IFID_final), .clk(clk), .rst(rst));
	dff IDEXreadEn2  (.q(readEn2_IDEX), .d(readEn2_IFID_final), .clk(clk), .rst(rst));
	dff IDEXhalt (.q(halt_IDEX), .d(halt_final), .clk(clk), .rst(rst));
	dff IDEXregWrSel (.q(regWrSel_IDEX), .d(regWrSel_final), .clk(clk), .rst(rst));
	dff IDEXmemWrEn(.q(memWrEn_IDEX), .d(memWrEn_final), .clk(clk), .rst(rst));
	dff IDEXaluSrcSel(.q(aluSrcSel_IDEX), .d(aluSrcSel_final), .clk(clk), .rst(rst));
	dff IDEXbranchCon (.q(branchCon_IDEX), .d(branchCon_final), .clk(clk), .rst(rst));
	dff IDEXdata1Sel(.q(data1Sel_IDEX), .d(data1Sel_final), .clk(clk), .rst(rst));
	dff IDEXregWrEn(.q(regWrEn_IDEX), .d(regWrEn_final), .clk(clk), .rst(rst));
	dff IDEXr7Sel(.q(r7Sel_IDEX), .d(r7Sel_final), .clk(clk), .rst(rst));
	dff IDEXbranch(.q(branch_IDEX), .d(branch_final), .clk(clk), .rst(rst));
	dff IDEXjump(.q(jump_IDEX), .d(jump_final), .clk(clk), .rst(rst));
	dff IDEXmemRdEn(.q(memRdEn_IDEX), .d(memRdEn_final), .clk(clk), .rst(rst));

	//*******************EXECUTE STAGE*******************//

	//HAZARD DETECTION: IFID latch not updated, instructions in IF and ID stay
	//EX/MEM.WriteRegister = IF/ID.ReadRegister1,2
	//MEM/WB.WriteRegister = IF/ID.ReadRegister1,2
	//ID/EX.WriteRegister = IF/ID.ReadRegister1,2
	//TODO memory forwarding
	
	assign temp1 = ((instrOut_IDEX[10:8] == writeregsel_EXMEM) & regWrEn_EXMEM & readEn1_IFID ) ? 1 : 0; // For A
	assign temp2 = ((instrOut_IDEX[10:8] == writeregsel_MEMWB) & regWrEn_MEMWB & readEn1_IFID ) ? 1 : 0; // For A
	assign temp3 = ((instrOut_IDEX[7:5] == writeregsel_EXMEM) & regWrEn_EXMEM & readEn2_IFID )? 1 : 0; // For B
	assign temp4 = ((instrOut_IDEX[7:5] == writeregsel_MEMWB) & regWrEn_MEMWB & readEn2_IFID )? 1 : 0; // For B
	assign temp20 = ((instrOut_IDEX[7:5] == writeregsel_EXMEM) & regWrEn_EXMEM & readEn2_IFID & (instrOut_EXMEM[15:11] ==  5'b10001))? 1 : 0; // For B and load
	assign temp21 = ((instrOut_IDEX[10:8] == writeregsel_EXMEM) & regWrEn_EXMEM & readEn1_IFID & (instrOut_EXMEM[15:11] ==  5'b10001))? 1 : 0; // For A and load

	assign  aluOpFinal = (branchCon_IDEX & branch_IDEX & branch_detect_IDEX) | 
                  		((jump_IDEX ^ branch_IDEX) & jump_detect_IDEX) ? 5'b00001 : aluOp_IDEX;  

	//ALU Control
	alu_op aluCtrl(.aluOp(aluOpFinal), .last2Bits(instrOut_IDEX[1:0]), .Cin(cin), .Op(op), .invA(invA), .invB(invB), .sign(sign), .err(aluCtrlErr));
	 
	//ALU
	//data1Sel_IDEX
	assign aluA =  data1Sel_IDEX ? (temp21 ? memDataOut : (temp1 ? mainALUresult_EXMEM :( temp2 ? writedata : read1data_IDEX))) : 0 ;
	assign read2dataTemp = temp20 ? memDataOut : (temp3 ? mainALUresult_EXMEM : (temp4 ? writedata : read2data_IDEX));
	assign aluB =  aluSrcSel_IDEX ? imm_IDEX : read2dataTemp ;
	alu mainALU(.A(aluA), .B(aluB), .Cin(cin), .Op(op), .invA(invA), .invB(invB), .sign(sign), .Out(mainALUresult), .Ofl(ofl), .Z(zeroFlag), .err(aluErr));
	//outputs ofl, zeroFlag not used, no need to pipeline


	//***************************************************//

	//data_mem_system
	assign mainALUresult_final = data_mem_stall  ? mainALUresult_EXMEM : mainALUresult;
	assign plus2Out_IDEX_final = data_mem_stall  ? plus2Out_EXMEM : plus2Out_IDEX;
	assign instrOut_IDEX_final = data_mem_stall  ? instrOut_EXMEM : instrOut_IDEX;
	assign read2dataTemp_final = data_mem_stall  ? read2data_EXMEM :read2dataTemp;
	assign simpleALUResult_final = data_mem_stall  ? simpleALUResult_EXMEM : simpleALUResult;
	assign writeregsel_IDEX_final = data_mem_stall  ? writeregsel_EXMEM : writeregsel_IDEX;
	assign branch_detect_IDEX_final = data_mem_stall  ? branch_detect_EXMEM : branch_detect_IDEX;
	assign jump_detect_IDEX_final = data_mem_stall  ? jump_detect_EXMEM : jump_detect_IDEX;
	assign dataRW_final = data_mem_stall  ? 0 : (((instrOut_IDEX[15:11] == 5'b10000) | (instrOut_IDEX[15:11] == 5'b10001) | (instrOut_IDEX[15:11] == 5'b10011))? 1 : 0);
	
	assign readEn_IDEX_final = data_mem_stall  ? readEn_EXMEM : readEn_IDEX;
	assign halt_IDEX_final = data_mem_stall  ? halt_EXMEM : halt_IDEX;
	assign regWrSel_IDEX_final = data_mem_stall  ? regWrSel_EXMEM : regWrSel_IDEX;
	assign memWrEn_IDEX_final = data_mem_stall  ? memWrEn_EXMEM : memWrEn_IDEX;
	assign regWrEn_IDEX_final = data_mem_stall  ? regWrEn_EXMEM : regWrEn_IDEX;
	assign r7Sel_IDEX_final = data_mem_stall  ? r7Sel_EXMEM :  r7Sel_IDEX;
	assign memRdEn_IDEX_final = data_mem_stall  ? memRdEn_EXMEM : memRdEn_IDEX;
	//data_mem_system

	dff EXMEMmainALUresult [15:0] (.q(mainALUresult_EXMEM), .d(mainALUresult_final), .clk(clk), .rst(rst));
	dff EXMEMplus2Out [15:0](.q(plus2Out_EXMEM), .d(plus2Out_IDEX_final), .clk(clk), .rst(rst)); 
  	dff EXMEMinstrOut [15:0](.q(instrOut_EXMEM), .d(instrOut_IDEX_final), .clk(clk), .rst(rst));
	dff EXMEMread2data[15:0] (.q(read2data_EXMEM), .d(read2dataTemp_final), .clk(clk), .rst(rst));
	dff EXMEMsimpleALUresult[15:0] (.q(simpleALUResult_EXMEM), .d(simpleALUResult_final), .clk(clk), .rst(rst));
	dff EXMEMwriteregsel[2:0] (.q(writeregsel_EXMEM), .d(writeregsel_IDEX_final), .clk(clk), .rst(rst));
 	dff EXMEMbranch_detect (.q(branch_detect_EXMEM), .d(branch_detect_IDEX_final), .clk(clk), .rst(rst)); 
	dff EXMEMjump_detect (.q(jump_detect_EXMEM), .d(jump_detect_IDEX_final), .clk(clk), .rst(rst)); 
	dff EXMEMdataRW (.q(dataRW), .d(dataRW_final), .clk(clk), .rst(rst)); 

	//control signals
	dff EXMEMreadEn  (.q(readEn_EXMEM), .d(readEn_IDEX_final), .clk(clk), .rst(rst));
	dff EXMEMhalt (.q(halt_EXMEM), .d(halt_IDEX_final), .clk(clk), .rst(rst));
	dff EXMEMregWrSel (.q(regWrSel_EXMEM), .d(regWrSel_IDEX_final), .clk(clk), .rst(rst));
	dff EXMEMmemWrEn (.q(memWrEn_EXMEM), .d(memWrEn_IDEX_final), .clk(clk), .rst(rst));
	dff EXMEMregWrEn(.q(regWrEn_EXMEM), .d(regWrEn_IDEX_final), .clk(clk), .rst(rst));
	dff EXMEMr7Sel(.q(r7Sel_EXMEM), .d(r7Sel_IDEX_final), .clk(clk), .rst(rst));
	dff EXMEMmemRdEn(.q(memRdEn_EXMEM), .d(memRdEn_IDEX_final), .clk(clk), .rst(rst));

	//*******************MEMORY STAGE*******************//

	assign temp5 = ((instrOut_EXMEM[7:5] == writeregsel_MEMWB) & regWrEn_MEMWB & readEn2_IDEX ) ? 1 : 0;

	assign memDataIn = temp5 ? memAluData : read2data_EXMEM; 

	assign dataReading = instrOut_EXMEM[15:11] == 5'b10001;

	data_mem_system data_mem(//outputs
												.DataOut(memDataOut), 
												.Done(data_mem_done), 
												.Stall(data_mem_stall), 
												.CacheHit(data_mem_hit), 
												.err(dataMemErr), 
												//inputs
												.Addr(mainALUresult_EXMEM), 
												.DataIn(memDataIn), 
												.Rd(dataReading), 
												.Wr(memWrEn_EXMEM), 
												.createdump(halt_EXMEM), 
												.clk(clk), .rst(rst));
	assign LS = ((instrOut_IDEX[15:11] == 5'b10011) | (instrOut_IDEX[15:11] == 5'b10001) | (instrOut_IDEX[15:11] == 5'b10000)) ? 1 : 0;

	//***************************************************//



	//datamem_system
	assign regWrSel_EXMEM_final = data_mem_stall  ? regWrSel_MEMWB : regWrSel_EXMEM;
	assign regWrEn_EXMEM_final = data_mem_stall  ? regWrEn_MEMWB : regWrEn_EXMEM;
	assign r7Sel_EXMEM_final = data_mem_stall  ? r7Sel_MEMWB : r7Sel_EXMEM;
	assign halt_EXMEM_final = data_mem_stall  ? halt_MEMWB :  halt_EXMEM;

	assign memDataOut_final = data_mem_stall  ? memDataOut_MEMWB :  memDataOut;
	assign mainALUresult_EXMEM_final = data_mem_stall  ? mainALUresult_MEMWB :  mainALUresult_EXMEM;
	assign plus2Out_EXMEM_final = data_mem_stall  ? plus2Out_MEMWB :  plus2Out_EXMEM;
	assign instrOut_EXMEM_final = data_mem_stall  ? instrOut_MEMWB :  instrOut_EXMEM;
	assign writeregsel_EXMEM_final = data_mem_stall  ? writeregsel_MEMWB :  writeregsel_EXMEM;
	assign branch_detect_EXMEM_final = data_mem_stall  ? branch_detect_MEMWB :  branch_detect_EXMEM;
	assign jump_detect_EXMEM_final = data_mem_stall  ? jump_detect_MEMWB :  jump_detect_EXMEM;
	//end data_mem_system

	dff MEMWBmemDataOut [15:0](.q(memDataOut_MEMWB), .d(memDataOut_final), .clk(clk), .rst(rst));
	dff MEMWBmainALUresult [15:0](.q(mainALUresult_MEMWB), .d(mainALUresult_EXMEM_final), .clk(clk), .rst(rst));
	dff MEMWBplus2Out [15:0](.q(plus2Out_MEMWB), .d(plus2Out_EXMEM_final), .clk(clk), .rst(rst)); 
 	dff MEMWBinstrOut [15:0](.q(instrOut_MEMWB), .d(instrOut_EXMEM_final), .clk(clk), .rst(rst));
	dff MEMWBwriteregsel[2:0] (.q(writeregsel_MEMWB), .d(writeregsel_EXMEM_final), .clk(clk), .rst(rst));
  	dff MEMWBbranch_detect (.q(branch_detect_MEMWB), .d(branch_detect_EXMEM_final), .clk(clk), .rst(rst));
	dff MEMWBjump_detect (.q(jump_detect_MEMWB), .d(jump_detect_EXMEM_final), .clk(clk), .rst(rst));

	//control signals
	dff MEMWBregWrSel (.q(regWrSel_MEMWB), .d(regWrSel_EXMEM_final), .clk(clk), .rst(rst));
	dff MEMWBregWrEn (.q(regWrEn_MEMWB), .d(regWrEn_EXMEM_final), .clk(clk), .rst(rst));
	dff MEMWBr7Sel(.q(r7Sel_MEMWB), .d(r7Sel_EXMEM_final), .clk(clk), .rst(rst));
	dff MEMWBhalt (.q(halt_MEMWB), .d(halt_EXMEM_final), .clk(clk), .rst(rst));

	//****************WRITEBACK STAGE*******************//
	assign memAluData = regWrSel_MEMWB ? memDataOut_MEMWB : mainALUresult_MEMWB;
	assign writedata = r7Sel_MEMWB ? plus2Out_MEMWB : memAluData; //choose data to write
	//writedata doesn't need to be pipelined, assign in WB stage

	//***************************************************//

	assign halt_MEMWB_final = data_mem_stall  ? halt_WBEND :  halt_MEMWB;
	assign instrOut_MEMWB_final = data_mem_stall  ? instrOut_WBEND : instrOut_MEMWB ;

	dff WBENDhalt (.q(halt_WBEND), .d(halt_MEMWB_final), .clk(clk), .rst(rst));
  dff WBENDinstrOut [15:0](.q(instrOut_WBEND), .d(instrOut_MEMWB_final), .clk(clk), .rst(rst));

	// OR all the err ouputs for every sub-module and assign it as this err output
	assign err = opCtrlErr | aluErr | aluCtrlErr;

	 
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:


//ToDO  for set-ass use for both pc and memory, two diff stalls how to use and whether to use mem_stall or busy
// TODO for store and load there can be multiple forwarding required