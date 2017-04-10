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
   
  wire [15:0] instrOut, pcCurrent, pcNext, plus2Out, writedata, memAluData, memDataOut, read1data, read2data, mainALUresult, imm, aluA, aluB, aluBtemp, sixteenZero;
  wire [15:0] instrOut_IDEX, instrOut_IFID, plus2Out_EXMEM, plus2Out_IDEX, plus2Out_IFID, plus2Out_MEMWB, memDataOut_MEMWB, read1data_IDEX, read2data_EXMEM, read2data_IDEX, mainALUresult_EXMEM, mainALUresult_MEMWB, imm_IDEX, simpleALUResult, simpleALUResult_EXMEM, instrOutTemp;
  wire [4:0] aluOp, op;
  wire [4:0] aluOp_IDEX, instrOut_IFID_final;
  wire [2:0] addition;
  wire [2:0] writereg1, writereg2, writeregsel;
  wire [2:0] writeregsel_EXMEM, writeregsel_IDEX, writeregsel_MEMWB;
  wire [1:0] regDesSel, jriSel;
  wire [1:0] regDesSel_IDEX;
  wire halt, jump, branch, memRdEn, regWrSel, memWrEn, aluSrcSel, regWrEn, opCtrlErr, branchCon, extendSign, cin, invA, invB, sign, aluCtrlErr, data1Sel, aluErr, ofl, zeroFlag, r7Sel, zero, temp1, temp2, temp3, temp4, temp5, temp6;
  wire halt_EXMEM, halt_IDEX, jump_EXMEM, jump_IDEX, branch_EXMEM, branch_IDEX, regWrSel_EXMEM, regWrSel_IDEX, regWrSel_MEMWB, memWrEn_EXMEM, memWrEn_IDEX, aluSrcSel_IDEX, regWrEn_EXMEM, regWrEn_IDEX, regWrEn_MEMWB, branchCon_EXMEM, data1Sel_IDEX, r7Sel_EXMEM, r7Sel_IDEX, r7Sel_MEMWB, stall, halt_MEMWB, readEn1, readEn2 , flush, branch_detect, branch_detect_IDEX, branch_detect_EXMEM;
	
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
   dff pc [15:0](.q(pcCurrent), .d(pcNext), .clk(clk), .rst(rst));
    
    //PC Control
   pc_control pcCtrl(
              .stall(stall),
            	.jump(jump_EXMEM),
            	.branch(branch_EXMEM),
            	.mainALUresult(mainALUresult_EXMEM), 
            	.pcCurrent(pcCurrent),
            	.readAdd(pcNext),
            	.plus2Out(plus2Out), //note: there's also an internal plus2Out wire
            	.branchCon(branchCon_EXMEM),
				.simpleALUResult(simpleALUResult_EXMEM));
  
	//***************************************************//
	 //HAZARD DETECTION: IFID latch not updated, instructions in IF and ID stay
	//EX/MEM.WriteRegister = IF/ID.ReadRegister1,2 //TODO AND regwrite enabled?
	//MEM/WB.WriteRegister = IF/ID.ReadRegister1,2
  //ID/EX.WriteRegister = IF/ID.ReadRegister1,2

  //read readenables
  readEnOp_control readEnOps(.opcode(instrOut_IFID[15:11]), .readEn1(readEn1), .readEn2(readEn2), .branch(branch_detect));
  
  assign temp1 = ((instrOut_IFID[7:5] == writeregsel_MEMWB) & regWrEn_MEMWB & readEn2) | ((instrOut_IFID[10:8] == writeregsel_MEMWB) & regWrEn_MEMWB & readEn1);
  assign temp2 = ((instrOut_IFID[7:5] == writeregsel_EXMEM) & regWrEn_EXMEM & readEn2) | ((instrOut_IFID[10:8] == writeregsel_EXMEM) & regWrEn_EXMEM & readEn1);
  assign temp3 = ((instrOut_IFID[7:5] == writeregsel_IDEX) & regWrEn_IDEX & readEn2) | ((instrOut_IFID[10:8] == writeregsel_IDEX) & regWrEn_IDEX & readEn1);

  assign stall = (temp1 | temp2 | temp3 ) ? 1 : 0;
  assign flush = (branchCon & branch_IDEX) | (branchCon_EXMEM & branch_EXMEM)? 1:0;
	
	assign instrOutTemp = stall ? instrOut_IFID : instrOut;
	
	//IF/ID REGISTERS
	dff IFIDplus2Out [15:0](.q(plus2Out_IFID), .d(plus2Out), .clk(clk), .rst(rst)); 
  dff IFIDinstructiona [3:0](.q(instrOut_IFID[15:12]), .d(instrOutTemp[15:12]), .clk(clk), .rst(rst));
	sdff IFIDinstructionb (.q(instrOut_IFID[11]), .d(instrOutTemp[11]), .clk(clk), .rst(rst));
  dff IFIDinstructionc [10:0](.q(instrOut_IFID[10:0]), .d(instrOutTemp[10:0]), .clk(clk), .rst(rst));


    //*******INSTRUCTION DECODE/REG FILE READ STAGE*******//
   
   assign instrOut_IFID_final = (stall|flush) ? 5'b00001: instrOut_IFID[15:11];
   //assign instrOut_IFID_final = stall ? 5'b00001: instrOut_IFID[15:11];
	
  //OP Control
   op_control opCtrl (.opcode(instrOut_IFID_final), .err(opCtrlErr), .halt(halt), .regDesSel(regDesSel), .jump(jump), .branch(branch), .memRdEn(memRdEn), .regWrSel(regWrSel), .aluOp(aluOp), .memWrEn(memWrEn), .aluSrcSel(aluSrcSel), .regWrEn(regWrEn), .jriSel(jriSel), .extendSign(extendSign), .data1Sel(data1Sel), .r7Sel(r7Sel));
	//note: memRdEn never used
 
   //Register File
   rf regFile (.read1data(read1data), .read2data(read2data), .err(regFileErr), .clk(clk), .rst(rst), .read1regsel(instrOut_IFID[10:8]), .read2regsel(instrOut_IFID[7:5]), .writeregsel(writeregsel_MEMWB), .writedata(writedata), .write(regWrEn_MEMWB));
   //regWrEn set in writeback stage, writeregsel determined in execute stage and piped down
   
   //Immediate Extend
   extendImm extend(.instr(instrOut_IFID), .jriSel(jriSel), .extendSign(extendSign), .extendedImm(imm));

   //choose register to write to
   assign writereg1 = regDesSel[0] ? instrOut_IFID[7:5] : instrOut_IFID[4:2] ; //choose between [4:2] and [7:5]
   assign writereg2 = regDesSel[0] ? instrOut_IFID[10:8] : 3'b111; //choose between R7 and [10:8]
   assign writeregsel = regDesSel[1] ? writereg2 : writereg1;
   
   //***************************************************//
   
    dff IDEXplus2Out [15:0](.q(plus2Out_IDEX), .d(plus2Out_IFID), .clk(clk), .rst(rst)); 
	dff IDEXinstrOut [15:0](.q(instrOut_IDEX), .d(instrOut_IFID), .clk(clk), .rst(rst));
	dff IDEXread1data [15:0](.q(read1data_IDEX), .d(read1data), .clk(clk), .rst(rst));
    dff IDEXread2data [15:0](.q(read2data_IDEX), .d(read2data), .clk(clk), .rst(rst));
    dff IDEXimm [15:0](.q(imm_IDEX), .d(imm), .clk(clk), .rst(rst));
	dff IDEXaluOp [4:0](.q(aluOp_IDEX), .d(aluOp), .clk(clk), .rst(rst));
  dff IDEXwriteregsel [2:0] (.q(writeregsel_IDEX), .d(writeregsel), .clk(clk), .rst(rst));
	dff IDEXbranch_detect (.q(branch_detect_IDEX), .d(branch_detect), .clk(clk), .rst(rst)); 

	//control signals: 
  dff IDEXreadEn  (.q(readEn_IDEX), .d(readEn), .clk(clk), .rst(rst));
	dff IDEXhalt (.q(halt_IDEX), .d(halt), .clk(clk), .rst(rst));
	dff IDEXregWrSel (.q(regWrSel_IDEX), .d(regWrSel), .clk(clk), .rst(rst));
	dff IDEXmemWrEn(.q(memWrEn_IDEX), .d(memWrEn), .clk(clk), .rst(rst));
    dff IDEXaluSrcSel(.q(aluSrcSel_IDEX), .d(aluSrcSel), .clk(clk), .rst(rst));
	dff IDEXdata1Sel(.q(data1Sel_IDEX), .d(data1Sel), .clk(clk), .rst(rst));
	dff IDEXregWrEn(.q(regWrEn_IDEX), .d(regWrEn), .clk(clk), .rst(rst));
    dff IDEXr7Sel(.q(r7Sel_IDEX), .d(r7Sel), .clk(clk), .rst(rst));
	dff IDEXbranch(.q(branch_IDEX), .d(branch), .clk(clk), .rst(rst));
	dff IDEXjump(.q(jump_IDEX), .d(jump), .clk(clk), .rst(rst));
  
   //*******************EXECUTE STAGE*******************//
   //pc control ALU
   simpleAlu pcALU(.A(plus2Out_IDEX), .B(imm_IDEX), .Cin(zero), .Op(addition), .sign(zero), .Out(simpleALUResult), .Ofl(aluOfl), .Z(aluZero));
   //aluOfl, aluZero not used
   
   //ALU Control
   alu_op aluCtrl(.aluOp(aluOp_IDEX), .last2Bits(instrOut_IDEX[1:0]), .Cin(cin), .Op(op), .invA(invA), .invB(invB), .sign(sign), .err(aluCtrlErr));
   
   //ALU
   assign aluA = data1Sel_IDEX ? read1data_IDEX : 0;
   assign aluBtemp = aluSrcSel_IDEX ? imm_IDEX : read2data_IDEX;
   assign aluB = branch_IDEX ? 0 : aluBtemp;
   alu mainALU(.A(aluA), .B(aluB), .Cin(cin), .Op(op), .invA(invA), .invB(invB), .sign(sign), .Out(mainALUresult), .Ofl(ofl), .Z(zeroFlag), .err(aluErr), .branchCon(branchCon));
   //outputs ofl, zeroFlag not used, no need to pipeline
   

   

   //***************************************************//
   
   dff EXMEMmainALUresult [15:0] (.q(mainALUresult_EXMEM), .d(mainALUresult), .clk(clk), .rst(rst));
   dff EXMEMplus2Out [15:0](.q(plus2Out_EXMEM), .d(plus2Out_IDEX), .clk(clk), .rst(rst)); 
   dff EXMEMread2data[15:0] (.q(read2data_EXMEM), .d(read2data_IDEX), .clk(clk), .rst(rst));
   dff EXMEMsimpleALUresult[15:0] (.q(simpleALUResult_EXMEM), .d(simpleALUResult), .clk(clk), .rst(rst));
   dff EXMEMwriteregsel[2:0] (.q(writeregsel_EXMEM), .d(writeregsel_IDEX), .clk(clk), .rst(rst));
   dff EXMEMbranch_detect (.q(branch_detect_EXMEM), .d(branch_detect_IDEX), .clk(clk), .rst(rst)); 
   
   //control signals
    dff EXMEMreadEn  (.q(readEn_EXMEM), .d(readEn_IDEX), .clk(clk), .rst(rst));
   dff EXMEMhalt (.q(halt_EXMEM), .d(halt_IDEX), .clk(clk), .rst(rst));
   dff EXMEMregWrSel (.q(regWrSel_EXMEM), .d(regWrSel_IDEX), .clk(clk), .rst(rst));
   dff EXMEMmemWrEn (.q(memWrEn_EXMEM), .d(memWrEn_IDEX), .clk(clk), .rst(rst));
   dff EXMEMregWrEn(.q(regWrEn_EXMEM), .d(regWrEn_IDEX), .clk(clk), .rst(rst));
   dff EXMEMr7Sel(.q(r7Sel_EXMEM), .d(r7Sel_IDEX), .clk(clk), .rst(rst));
   dff EXMEMbranchCon (.q(branchCon_EXMEM), .d(branchCon), .clk(clk), .rst(rst));
   dff EXMEMbranch (.q(branch_EXMEM), .d(branch_IDEX), .clk(clk), .rst(rst));
   dff EXMEMjump(.q(jump_EXMEM), .d(jump_IDEX), .clk(clk), .rst(rst));
   
   //*******************MEMORY STAGE*******************//
   //Data Memory
   memory2c dataMem(.data_out(memDataOut), .data_in(read2data_EXMEM), .addr(mainALUresult_EXMEM), .enable(~rst), .wr(memWrEn_EXMEM), .createdump(halt_MEMWB), .clk(clk), .rst(rst));
   
   //***************************************************//
   
   dff MEMWBmemDataOut [15:0](.q(memDataOut_MEMWB), .d(memDataOut), .clk(clk), .rst(rst));
   dff MEMWBmainALUresult [15:0](.q(mainALUresult_MEMWB), .d(mainALUresult_EXMEM), .clk(clk), .rst(rst));
   dff EMEMWBplus2Out [15:0](.q(plus2Out_MEMWB), .d(plus2Out_EXMEM), .clk(clk), .rst(rst)); 
   dff MEMWBwriteregsel[2:0] (.q(writeregsel_MEMWB), .d(writeregsel_EXMEM), .clk(clk), .rst(rst));
   
   //control signals
    dff MEMWBreadEn  (.q(readEn_MEMWB), .d(readEn_EXMEM), .clk(clk), .rst(rst));
   dff MEMWBregWrSel (.q(regWrSel_MEMWB), .d(regWrSel_EXMEM), .clk(clk), .rst(rst));
   dff MEMWBregWrEn (.q(regWrEn_MEMWB), .d(regWrEn_EXMEM), .clk(clk), .rst(rst));
   dff MEMWBr7Sel(.q(r7Sel_MEMWB), .d(r7Sel_EXMEM), .clk(clk), .rst(rst));
   dff MEMWBhalt (.q(halt_MEMWB), .d(halt_EXMEM), .clk(clk), .rst(rst));
   
   //****************WRITEBACK STAGE*******************//
	assign memAluData = regWrSel_MEMWB ? memDataOut_MEMWB : mainALUresult_MEMWB;
    assign writedata = r7Sel_MEMWB ? plus2Out_MEMWB : memAluData; //choose data to write
   //writedata doesn't need to be pipelined, assign in WB stage
   
   //***************************************************//
   
   // OR all the err ouputs for every sub-module and assign it as this err output
   assign err = opCtrlErr | aluErr | aluCtrlErr;

   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:


