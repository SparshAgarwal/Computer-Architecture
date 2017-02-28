/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */

module sc( clk, rst, ctr_rst, out, err);
   input clk;
   input rst;
   input ctr_rst;
   output [2:0] out;
   output err;
   wire [2:0]                state;
   reg [2:0]                 next_state;
	

dff curr_state[2:0] (
                        // Outputs
                        .q              (state),
                        // Inputs
                        .d              (next_state),
                        .clk            (clk),
                        .rst            (rst));	

always@(*)begin
	casex(state)
		3'b000:begin
				next_state = rst?3'b000:(ctr_rst?3'b000:3'b001);
			end
		3'b001:begin
				next_state  = rst?3'b000:(ctr_rst?3'b000:3'b010);
			end
		3'b010:begin
				next_state  = rst?3'b000:(ctr_rst?3'b000:3'b011);
			end
		3'b011:begin
				next_state  = rst?3'b000:(ctr_rst?3'b000:3'b100);
			end
		3'b1??:begin
				next_state  = rst?3'b000:(ctr_rst?3'b000:3'b101);
			end
		default:begin
				$display("error");
			end
	endcase
	
end  
assign out = state;
//hello
endmodule

// DUMMY LINE FOR REV CONTROL :1:
