module extendImm(instr, jriSel, extendSign, extendedImm);

input [15:0] instr;
input [1:0] jriSel;
input extendSign;
output [15:0] extendedImm;
wire [15:0] ten,seven,four,fourSeven;

assign ten = extendSign ? {{5{instr[10]}}, instr[10:0]} : {5'b00000, instr[10:0]};
assign seven = extendSign ? {{8{instr[7]}}, instr[7:0]} : {8'h00, instr[7:0]};
assign four = extendSign ? {{11{instr[4]}}, instr[4:0]} : {11'b00000000, instr[4:0]};

//choose an immediate 
assign fourSeven = jriSel[0] ? seven : four; //choose between [4:0] and [7:0]
assign extendedImm = jriSel[1] ? ten : fourSeven; 

endmodule