module seqdec_bench;
   reg InA;
   wire Clk;
   wire Reset;
   wire [15:0] Out;
   reg [127:0] sequenc;
   integer    k;
   reg [1:0]  seq;
   reg [1:0]  seqp1;
   reg [15:0]       count;

   wire err;
   assign err = 1'b0;

   // seqdec_final DUT (.InA(InA),.Clk(Clk),.Reset(Reset),.Out(Out));
   seqdec DUT (.InA(InA),.Clk(Clk),.Reset(Reset),.Out(Out));
   clkrst my_ckrst ( .clk(Clk), .rst(Reset), .err(err));

   always@(posedge Clk)
     begin
	if (Reset == 1'b1) 
	  begin
	     InA = 1'b0;
	     k = 0;
	     sequenc = 128'h0028_850A_972E_4284_5353_28A0_8597_4253;    // Sequence detection is for 85, 97, 42, 53, 28
	     seq = 2'h0;
	     seqp1 = 2'h0;
   
	  end
	else
	  begin
	     InA = sequenc[127-k];
	     k = k + 1;
	     seq[1] <= seq[0];
	     seq[0] <= InA;
	     seqp1 <= seq;
	     
	     if (k == 128) $finish;
	     
	  end // else: !if(Reset == 1'b1)
     end // always@ (posedge Clk)

   always @ (posedge Clk ) begin
      if (Reset == 1'b1) begin
         count = 0;
      end else begin
         if (seqp1 === 2'h3) begin
            count = count + 1;
         end
      end
   end
   


   always@(negedge Clk)
     begin
	if (count !== Out)
	  $display("ERRORCHECK :: Output mismatch got: %d, expoected: %d", Out, count);
     end
endmodule // seqdec_28_bench
