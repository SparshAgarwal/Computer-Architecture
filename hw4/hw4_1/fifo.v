/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module fifo(/*AUTOARG*/
   // Outputs
   data_out, fifo_empty, fifo_full, err,
   // Inputs
   data_in, data_in_valid, pop_fifo, clk, rst
   );
   input [63:0] data_in;
   input        data_in_valid;
   input        pop_fifo;

   input        clk;
   input        rst;
   output [63:0] data_out;
   output        fifo_empty;
   output        fifo_full;
   output        err;

   wire [2:0] state;
   reg full, empty, error;
   reg [2:0] next_state;
   reg [63:0] outi, 
         dataIn1,  
         dataIn2, 
         dataIn3, 
         dataIn4;
   wire [63:0] out,
         dataOut1,  
         dataOut2, 
         dataOut3, 
         dataOut4;

dff curr_state[2:0] (
                        // Outputs
                        .q              (state),
                        // Inputs
                        .d              (next_state),
                        .clk            (clk),
                        .rst            (rst)); 

dff fifo1[63:0] (
                        // Outputs
                        .q              (dataOut1),
                        // Inputs
                        .d              (dataIn1),
                        .clk            (clk),
                        .rst            (rst)); 

dff fifo2[63:0] (
                        // Outputs
                        .q              (dataOut2),
                        // Inputs
                        .d              (dataIn2),
                        .clk            (clk),
                        .rst            (rst)); 

dff fifo3[63:0] (
                        // Outputs
                        .q              (dataOut3),
                        // Inputs
                        .d              (dataIn3),
                        .clk            (clk),
                        .rst            (rst)); 

dff fifo4[63:0] (
                        // Outputs
                        .q              (dataOut4),
                        // Inputs
                        .d              (dataIn4),
                        .clk            (clk),
                        .rst            (rst)); 

dff outputdff[63:0] (
                        // Outputs
                        .q              (out),
                        // Inputs
                        .d              (outi),
                        .clk            (clk),
                        .rst            (rst)); 

always@(*)begin
   case(state)
      3'b000:begin
            next_state = rst?3'b000:(data_in_valid?3'b001:3'b000);
            dataIn1 = rst?3'b000:(data_in_valid?data_in:dataOut1);
            outi = data_in_valid?dataIn1:0;
            empty = 1;
            full = 0;
         end
      3'b001:begin
            next_state  = rst?3'b000:(data_in_valid?(pop_fifo?3'b001:3'b010):(pop_fifo?3'b000:3'b001));
            dataIn1 = rst?3'b000:(data_in_valid?data_in:dataOut1);
            dataIn2 = rst?3'b000:(data_in_valid?dataOut1:dataOut2);
            outi = data_in_valid?(pop_fifo?dataIn1:dataIn2):(pop_fifo?0:dataIn1);
            empty = 0;
            full = 0;
         end
      3'b010:begin
            next_state  = rst?3'b000:(data_in_valid?(pop_fifo?3'b010:3'b011):(pop_fifo?3'b001:3'b010));
            dataIn1 = rst?3'b000:(data_in_valid?data_in:dataOut1);
            dataIn2 = rst?3'b000:(data_in_valid?dataOut1:dataOut2);
            dataIn3 = rst?3'b000:(data_in_valid?dataOut2:dataOut3);
            outi = data_in_valid?(pop_fifo?dataIn2:dataIn3):(pop_fifo?dataIn1:dataIn2);
            full = 0;
            empty = 0;
         end
      3'b011:begin
            next_state  = rst?3'b000:(data_in_valid?(pop_fifo?3'b011:3'b100):(pop_fifo?3'b010:3'b011));
            dataIn1 = rst?3'b000:(data_in_valid?data_in:dataOut1);
            dataIn2 = rst?3'b000:(data_in_valid?dataOut1:dataOut2);
            dataIn3 = rst?3'b000:(data_in_valid?dataOut2:dataOut3);
            dataIn4 = rst?3'b000:(data_in_valid?dataOut3:dataOut4);
            outi = data_in_valid?(pop_fifo?dataIn3:dataIn4):(pop_fifo?dataIn2:dataIn3);
            full = 0;
            empty = 0;
         end
      3'b100:begin
            next_state  = rst?3'b000:(pop_fifo?3'b011:3'b100);
            dataIn1 = rst?3'b000:(data_in_valid?dataOut1:dataOut1);
            dataIn2 = rst?3'b000:(data_in_valid?dataOut2:dataOut2);
            dataIn3 = rst?3'b000:(data_in_valid?dataOut3:dataOut3);
            dataIn4 = rst?3'b000:(data_in_valid?dataOut4:dataOut4);
            outi = pop_fifo?dataIn3:dataIn4;
            full = 1;
            empty = 0;
         end
      default:begin
            
         end
   endcase
   
end 

assign data_out = out;
assign fifo_full = full;
assign fifo_empty = empty;
assign err = error;

endmodule
// DUMMY LINE FOR REV CONTROL :1:
