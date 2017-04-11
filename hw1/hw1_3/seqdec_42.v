// student ID is 9075905142

module seqdec_42 (
		input InA,
		input Clk,
		input Reset,
		output Out
               ) ;

   wire [3:0]                state;
   reg [3:0]                 next_state;

  dff curr_state[3:0] (
                        // Outputs
                        .q              (state),
                        // Inputs
                        .d              (next_state),
                        .clk            (Clk),
                        .rst            (Reset));

   always @ (*) begin
      case (state) 
        4'h0: begin
           next_state = InA ? 4'h0 : 4'h1;
        end
        4'h1: begin
           next_state = InA ? 4'h2 : 4'h1;
        end
        4'h2: begin
           next_state = InA ? 4'h0 : 4'h3;
        end
        4'h3: begin
           next_state = InA ? 4'h1 : 4'h4;
        end
        4'h4: begin
           next_state = InA ? 4'h1 : 4'h5;
        end
        4'h5: begin
           next_state = InA ? 4'h1 : 4'h6;
        end
        4'h6: begin
           next_state = InA ? 4'h7 : 4'h1;
        end
        4'h7: begin
           next_state = InA ? 4'h0 : 4'h8;
        end
        4'h8: begin
           next_state = InA ? 4'h2 : 4'h4;
        end
        default: begin
           next_state = 4'h0;
        end
      endcase // case (state)
      
   end // always @ (*)

   assign Out = (state==4'h8)?1:0;

endmodule 