/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */

module sc( clk, rst, ctr_rst, out, err);
   input clk;
   input rst;
   input ctr_rst;
   output [2:0] out;
   output err;

	reg[2:0] counter;
	
	always@(*)begin
		casex(counter)
			3'b000:begin
					counter = ctr_rst?3'b000:3'b001;
				end
			3'b001:begin
					counter = ctr_rst?3'b000:3'b010;
				end
			3'b010:begin
					counter = ctr_rst?3'b000:3'b011;
				end
			3'b011:begin
					counter = ctr_rst?3'b000:3'b100;
				end
			3'b1??:begin
					counter = ctr_rst?3'b000:3'b101;
				end
			default:begin
					$display("error");
				end
		endcase
		counter = rst?3'b000:counter;
	end  
assign out = counter;
endmodule

// DUMMY LINE FOR REV CONTROL :1:
