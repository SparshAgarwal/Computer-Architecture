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
   
  wire [15:0] instrOut,pcCurrent, pcNext, plus2Out, writedata, memAluData, memDataOut, read1data, read2data, mainALUresult, imm, aluA, aluB, aluBtemp, sixteenZero; 
  wire [4:0] aluOp, op;
  wire [2:0] writereg1, writereg2, writeregsel;
  wire [1:0] regDesSel, jriSel;
  wire halt, jump, branch, memRdEn, regWrSel, memWrEn, aluSrcSel, regWrEn, opCtrlErr, branchCon, extendSign, cin, invA, invB, sign, aluCtrlErr, data1Sel, aluErr, ofl, zeroFlag, r7Sel, zero;

  wire one;
  assign one = 1'b1;
  
  
   //OP Control
   op_control opCtrl (.opcode(instrOut[15:11]), .err(opCtrlErr), .halt(halt), .regDesSel(regDesSel), .jump(jump), .branch(branch), .memRdEn(memRdEn), .regWrSel(regWrSel), .aluOp(aluOp), .memWrEn(memWrEn), .aluSrcSel(aluSrcSel), .regWrEn(regWrEn), .jriSel(jriSel), .extendSign(extendSign), .data1Sel(data1Sel), .r7Sel(r7Sel));
  
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

    //***************************************************//


	//*******INSTRUCTION DECODE/REG FILE READ STAGE*******//
	
	//PC Control
   pc_control pcCtrl(
                .jump(jump), 
                .branch(branch), 
                .imm(imm), 
                .mainALUresult(mainALUresult),
                .pcCurrent(pcCurrent), 
                .readAdd(pcNext), 
                .plus2Out(plus2Out), 
                .branchCon(branchCon));
				
	//choose register to write to
   assign writereg1 = regDesSel[0] ? instrOut[7:5] : instrOut[4:2] ; //choose between [4:2] and [7:5]
   assign writereg2 = regDesSel[0] ? instrOut[10:8] : 3'b111; //choose between R7 and [10:8]
   assign writeregsel = regDesSel[1] ? writereg2 : writereg1; 
   assign writedata = r7Sel ? plus2Out : memAluData; //choose data to write
 
   //Register File 
   rf regFile (.read1data(read1data), .read2data(read2data), .err(regFileErr), .clk(clk), .rst(rst), .read1regsel(instrOut[10:8]), .read2regsel(instrOut[7:5]), .writeregsel(writeregsel), .writedata(writedata), .write(regWrEn));
   
   //Immediate Extend
   extendImm extend(.instr(instrOut), .jriSel(jriSel), .extendSign(extendSign), .extendedImm(imm));
   
   //***************************************************//
   
   //*******************EXECUTE STAGE*******************//
   //ALU Control 
   alu_op aluCtrl(.aluOp(aluOp), .last2Bits(instrOut[1:0]), .Cin(cin), .Op(op), .invA(invA), .invB(invB), .sign(sign), .err(aluCtrlErr));
   
   //ALU
   assign aluA = data1Sel ? read1data : 0;
   assign aluBtemp = aluSrcSel ? imm : read2data;
   assign aluB = branch ? 0 : aluBtemp;
   alu mainALU(.A(aluA), .B(aluB), .Cin(cin), .Op(op), .invA(invA), .invB(invB), .sign(sign), .Out(mainALUresult), .Ofl(ofl), .Z(zeroFlag), .err(aluErr), .branchCon(branchCon));
   
   //***************************************************//
   
   //*******************MEMORY STAGE*******************//
   //Data Memory 
   memory2c dataMem(.data_out(memDataOut), .data_in(read2data), .addr(mainALUresult), .enable(~rst), .wr(memWrEn), .createdump(halt), .clk(clk), .rst(rst));
   
   //***************************************************//
   
   //****************WRITEBACK STAGE*******************//
    assign memAluData = regWrSel ? memDataOut : mainALUresult; 
   
   //***************************************************//
	
   // OR all the err ouputs for every sub-module and assign it as this err output
   assign err = opCtrlErr | aluErr | aluCtrlErr;

   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
