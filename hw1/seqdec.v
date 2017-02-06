module seqdec (
               input Clk,
               input Reset,
               input InA,

               output [15:0] Out
               ) ;

   wire [1:0]                state;
   reg [1:0]                 next_state;

   wire [15:0]               count, new_count, increment;

   dff curr_state[1:0] (
                        // Outputs
                        .q              (state),
                        // Inputs
                        .d              (next_state),
                        .clk            (Clk),
                        .rst            (Reset));

   always @ (*) begin
      case (state) 
        2'h0: begin
           next_state = InA ? 2'h1 : 2'h0;
        end
        2'h1: begin
           next_state = InA ? 2'h2 : 2'h0;
        end
        2'h2: begin
           next_state = InA ? 2'h2 : 2'h0;
        end
        default: begin
           next_state = 2'h0;
        end
      endcase // case (state)
      
   end // always @ (*)

   dff counter [15:0] (
                       // Outputs
                       .q               (count),
                       // Inputs
                       .d               (new_count),
                       .clk             (Clk),
                       .rst             (Reset));

   fulladd_16 adder (
                     // Outputs
                     .SUM               (new_count),
                     .CO                (),
                     // Inputs
                     .A                 (count),
                     .B                 (increment));

   assign increment = (state == 2'h2) ? 1 : 0;
   assign Out = count;

endmodule // seqdec
