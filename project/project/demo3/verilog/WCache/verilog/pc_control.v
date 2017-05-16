module pc_control(stall, jump, branch, pcCurrent, mainALUresult, readAdd, plus2Out, branchCon, simpleALUResult);

input jump, branch, branchCon, stall;
input [15:0] mainALUresult, pcCurrent, simpleALUResult;
output [15:0] readAdd, plus2Out;

wire aluOfl, aluZero, zero;
wire plus2Ofl, plus2Zero, pcSrc1 ;
wire [15:0]  readAddWire, pcSrc2, plus2OutWire, plus2B;
wire [2:0] addition;
 
assign addition = 3'b100;
assign zero = 0;
assign plus2B = stall? 0:16'd2;
simpleAlu plus2(.A(pcCurrent), .B(plus2B), .Cin(zero), .Op(addition), .sign(zero), .Out(plus2OutWire), .Ofl(plus2Ofl), .Z(plus2Zero));

assign pcSrc1 = branch & branchCon;
assign pcSrc2 = pcSrc1 ? simpleALUResult : plus2Out;
assign readAddWire = jump ? mainALUresult : pcSrc2;
assign readAdd = readAddWire;
assign plus2Out = plus2OutWire;

endmodule
