module pc_control(jump, branch, imm, pcCurrent, mainALUresult, readAdd, plus2Out, err ,branchCon);

input jump, branch, branchCon;
input [15:0] imm, mainALUresult,pcCurrent;
output [15:0] readAdd, plus2Out;
output err;

wire aluOfl, aluZero, zero;
wire plus2Ofl, plus2Zero, pcSrc1 ;
wire [15:0]  aluResult, readAddWire, pcSrc2, plus2OutWire, two;
wire [2:0] addition;
 
assign two = 16'd2;
assign addition = 3'b100;
assign zero = 0;

simpleAlu plus2(.A(pcCurrent), .B(two), .Cin(zero), .Op(addition), .sign(zero), .Out(plus2OutWire), .Ofl(plus2Ofl), .Z(plus2Zero));
simpleAlu pcALU(.A(plus2OutWire), .B(imm), .Cin(zero), .Op(addition), .sign(zero), .Out(aluResult), .Ofl(aluOfl), .Z(aluZero));

assign pcSrc1 = branch & branchCon;
assign pcSrc2 = pcSrc1 ? aluResult : plus2Out;
assign readAddWire = jump ? mainALUresult : pcSrc2;
assign readAdd = readAddWire;
assign plus2Out = plus2OutWire;
assign err = plus2Ofl | aluOfl;

endmodule