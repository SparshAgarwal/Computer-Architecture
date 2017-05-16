/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );

   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;
   output        err;
   
   wire [15:0] in0, in1, in2, in3, in4, in5, in6, in7;
   wire[15:0] readout0, readout1, readout2, readout3, readout4, readout5, readout6, readout7;
   reg[15:0] read1, read2;
   
  reg16bit reg0 (.out(readout0), .in(in0), .clk(clk), .reset(rst));
  reg16bit reg1 (.out(readout1), .in(in1), .clk(clk), .reset(rst));
  reg16bit reg2 (.out(readout2), .in(in2), .clk(clk), .reset(rst));
  reg16bit reg3 (.out(readout3), .in(in3), .clk(clk), .reset(rst));
  reg16bit reg4 (.out(readout4), .in(in4), .clk(clk), .reset(rst));
  reg16bit reg5 (.out(readout5), .in(in5), .clk(clk), .reset(rst));
  reg16bit reg6 (.out(readout6), .in(in6), .clk(clk), .reset(rst));
  reg16bit reg7 (.out(readout7), .in(in7), .clk(clk), .reset(rst));
  

  assign in0 = ((writeregsel == 3'b000) & write) ? writedata : readout0;
  assign in1 = ((writeregsel == 3'b001) & write) ? writedata : readout1;
  assign in2 = ((writeregsel == 3'b010) & write) ? writedata : readout2;
  assign in3 = ((writeregsel == 3'b011) & write) ? writedata : readout3;
  assign in4 = ((writeregsel == 3'b100) & write) ? writedata : readout4;
  assign in5 = ((writeregsel == 3'b101) & write) ? writedata : readout5;
  assign in6 = ((writeregsel == 3'b110) & write) ? writedata : readout6;
  assign in7 = ((writeregsel == 3'b111) & write) ? writedata : readout7;

  always@(*)
	begin
		case (read1regsel)
			3'b000:begin
					  read1 = readout0;
				end
			3'b001:begin
					  read1 = readout1;
				end
			3'b010:begin
					  read1 = readout2;
				end
			3'b011:begin
					  read1 = readout3;
				end	
			3'b100:begin
					 read1 = readout4;
				end	
			3'b101:begin
					 read1 = readout5;
				end
			3'b110:begin
					 read1 = readout6;
				end
			3'b111:begin
					 read1 = readout7;
				end
			default:
				$display("error");
		endcase
	end
	
always@(*)
	begin
		case (read2regsel)
			3'b000:begin
					 read2 = readout0;
				end
			3'b001:begin
					 read2 = readout1;
				end
			3'b010:begin
					 read2 = readout2;
				end
			3'b011:begin
					 read2 = readout3;
				end	
			3'b100:begin
					 read2 = readout4;
				end	
			3'b101:begin
					 read2 = readout5;
				end
			3'b110:begin
					 read2 = readout6;
				end
			3'b111:begin
					 read2 = readout7;
				end
			default:
				$display("error");
		endcase
	end

assign read2data = read2;
assign read1data = read1;

endmodule
// DUMMY LINE FOR REV CONTROL :1:
