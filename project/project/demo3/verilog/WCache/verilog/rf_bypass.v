/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf_bypass (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write, bypass, bypassReg1, bypassReg2
           );
   input clk, rst, bypass, bypassReg1, bypassReg2;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;
   output        err;
   
   reg [15:0] temp1read1data, temp1read2data;
   wire[15:0] temp2read1data, temp2read2data;
   
   rf regfile (.read1data(temp2read1data), .read2data(temp2read2data), .err(err), .clk(clk), .rst(rst), .read1regsel(read1regsel), .read2regsel(read2regsel), .writeregsel(writeregsel), .writedata(writedata), .write(write));
   
   assign read1data = (write & bypass & bypassReg1) ? temp1read1data : temp2read1data;
   assign read2data = (write & bypass & bypassReg2) ? temp1read2data : temp2read2data;
   
   always@(*)
	begin
		case (read1regsel)
			3'b000:begin
					  temp1read1data = (writeregsel == 3'b000) ? writedata : temp2read1data; 
				end
			3'b001:begin
					  temp1read1data = (writeregsel == 3'b001) ? writedata : temp2read1data; 
				end
			3'b010:begin
					   temp1read1data = (writeregsel == 3'b010) ? writedata : temp2read1data; 
				end
			3'b011:begin
					  temp1read1data = (writeregsel == 3'b011) ? writedata : temp2read1data; 
				end	
			3'b100:begin
					  temp1read1data = (writeregsel == 3'b100) ? writedata : temp2read1data; 
				end	
			3'b101:begin
					  temp1read1data = (writeregsel == 3'b101) ? writedata : temp2read1data; 
				end
			3'b110:begin
					  temp1read1data = (writeregsel == 3'b110) ? writedata : temp2read1data; 
				end
			3'b111:begin
					  temp1read1data = (writeregsel == 3'b111) ? writedata : temp2read1data; 
				end
			default:
				$display("error");
		endcase
	end
	
   always@(*)
	begin
		case (read2regsel)
			3'b000:begin
					   temp1read2data = (writeregsel == 3'b000) ? writedata : temp2read2data; 
				end
			3'b001:begin
					   temp1read2data = (writeregsel == 3'b001) ? writedata : temp2read2data; 
				end
			3'b010:begin
					   temp1read2data = (writeregsel == 3'b010) ? writedata : temp2read2data; 
				end
			3'b011:begin
					  temp1read2data = (writeregsel == 3'b011) ? writedata : temp2read2data; 
				end	
			3'b100:begin
					  temp1read2data = (writeregsel == 3'b100) ? writedata : temp2read2data; 
				end	
			3'b101:begin
					  temp1read2data = (writeregsel == 3'b101) ? writedata : temp2read2data; 
				end
			3'b110:begin
					  temp1read2data = (writeregsel == 3'b110) ? writedata : temp2read2data; 
				end
			3'b111:begin
					  temp1read2data = (writeregsel == 3'b111) ? writedata : temp2read2data; 
				end
			default:
				$display("error");
		endcase
	end	

endmodule
// DUMMY LINE FOR REV CONTROL :1:
