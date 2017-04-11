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
	reg [15:0]writein0,writein1,read1,writein2,read2,
		writein3,writein4,
		writein5,writein6,
		writein7;
	wire[15:0] readout0,readout1,
		readout2,readout3,
		readout4,readout5,
		readout6,readout7;

  reg16bit reg1 (
                        // Outputs
                        .out              (readout0),
                        // Inputs
                        .in              (writein0),
                        .clk            (clk),
                        .reset            (rst));
  reg16bit reg2 (
                        // Outputs
                        .out              (readoutt),
                        // Inputs
                        .in              (writein1),
                        .clk            (clk),
                        .reset            (rst));
  reg16bit reg3 (
                        // Outputs
                        .out              (readout2),
                        // Inputs
                        .in              (writein2),
                        .clk            (clk),
                        .reset            (rst));
  reg16bit reg4 (
                        // Outputs
                        .out              (readout3),
                        // Inputs
                        .in              (writein3),
                        .clk            (clk),
                        .reset            (rst));
  reg16bit reg5 (
                        // Outputs
                        .out              (readout4),
                        // Inputs
                        .in              (writein4),
                        .clk            (clk),
                        .reset            (rst));
  reg16bit reg6 (
                        // Outputs
                        .out              (readout5),
                        // Inputs
                        .in              (writein5),
                        .clk            (clk),
                        .reset            (rst));
  reg16bit reg7 (
                        // Outputs
                        .out              (readout6),
                        // Inputs
                        .in              (writein6),
                        .clk            (clk),
                        .reset            (rst));
 reg16bit reg8 (
                        // Outputs
                        .out             (readout7),
                        // Inputs
                        .in              (writein7),
                        .clk            (clk),
                        .reset            (rst));

 always@(*)
	begin
		case (writeregsel)
			3'b000:begin
					 writein0=write?writedata:readout0;
				end
			3'b001:begin
					 writein1=write?writedata:readout1;
				end
			3'b010:begin
					 writein2=write?writedata:readout2;
				end
			3'b011:begin
					 writein3=write?writedata:readout3;
				end
			3'b100:begin
					 writein4=write?writedata:readout4;
				end
			3'b101:begin
					 writein5=write?writedata:readout5;
				end
			3'b110:begin
					 writein6=write?writedata:readout6;
				end
			3'b111:begin
					 writein7=write?writedata:readout7;
				end
			default:
				$display("error");
		endcase
		
    	end

  always@(*)
	begin
		case (read1regsel)
			3'b000:begin
					  read1=readout0;
				end
			3'b001:begin
					  read1=readout1;
				end
			3'b010:begin
					  read1=readout2;
				end
			3'b011:begin
					  read1=readout3;
				end	
			3'b100:begin
					 read1=readout4;
				end	
			3'b101:begin
					 read1=readout5;
				end
			3'b110:begin
					 read1=readout6;
				end
			3'b111:begin
					 read1=readout7;
				end
			default:
				$display("error");
		endcase
		case (read2regsel)
			3'b000:begin
					 read2=readout0;
				end
			3'b001:begin
					 read2=readout1;
				end
			3'b010:begin
					 read2=readout2;
				end
			3'b011:begin
					 read2=readout3;
				end	
			3'b100:begin
					 read2=readout4;
				end	
			3'b101:begin
					 read2=readout5;
				end
			3'b110:begin
					 read2=readout6;
				end
			3'b111:begin
					 read2=readout7;
				end
			default:
				$display("error");
		endcase
	end



assign read2data = read2;
assign read1data = read1;

endmodule
// DUMMY LINE FOR REV CONTROL :1:
