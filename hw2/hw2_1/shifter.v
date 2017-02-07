module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

	(Cnt[3]&1'b1)?{
		bit16_2to1mux(Op==2'd0,In[15:0],{In[7:0],In[15:8]},In[15:0]);
		bit16_2to1mux(Op==2'd1,In[15:0],{In[7:0],8'b0},In[15:0]);
		bit16_2to1mux(Op==2'd2,In[15:0],{{In[15]{8}},In[15:8]},In[15:0]);	
		bit16_2to1mux(Op==2'd3,In[15:0],{8'b0,In[15:8]},In[15:0]);	
		}:; 		
	(Cnt[2]==1'b1)?{
		bit16_2to1mux(Op==2'd0,In[15:0],{In[11:0],In[15,12]},In[15:0]);
		bit16_2to1mux(Op==2'd1,In[15:0],{In[11:0],4'b0},In[15:0]);
		bit16_2to1mux(Op==2'd2,In[15:0],{{In[15]{4}},In[15:4]},In[15:0]);	
		bit16_2to1mux(Op==2'd3,In[15:0],{4'b0,In[15:4]},In[15:0]);
		}:; 		
	(Cnt[1]==1'b1)?{
		bit16_2to1mux(Op==2'd0,In[15:0],{In[13:0],In[15,14]},In[15:0]);
		bit16_2to1mux(Op==2'd1,In[15:0],{In[13:0],2'b0},In[15:0]);
		bit16_2to1mux(Op==2'd2,In[15:0],{{In[15]{2}},In[15:2]},In[15:0]);	
		bit16_2to1mux(Op==2'd3,In[15:0],{2'b0,In[15:2]},In[15:0]);
		}:; 
	(Cnt[0]==1'b1)?{
		bit16_2to1mux(Op==2'd0,In[15:0],{In[14:0],In[15]},In[15:0]);
		bit16_2to1mux(Op==2'd1,In[15:0],{In[14:0],1'b0},In[15:0]);
		bit16_2to1mux(Op==2'd2,In[15:0],{{In[15]{1}},In[15:1]},In[15:0]);	
		bit16_2to1mux(Op==2'd3,In[15:0],{1'b0,In[15:1]},In[15:0]);
		}:; 
	assign Out=In;
endmodule

