module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;
	wire [15:0] current_out;

	
assign current_out[15:0]=Cnt[3]?((Op==2'd0)?{In[7:0],In[15:8]}:
		((Op==2'd1)?{In[7:0],8'b0}:
		((Op==2'd2)?{{8{In[15]}},In[15:8]}:
		((Op==2'd3)?{8'b0,In[15:8]}:
		In[15:0])))):
		In[15:0];
assign current_out[15:0]=Cnt[2]?((Op==2'd0)?{current_out[11:0],current_out[15:12]}:
		((Op==2'd1)?{current_out[11:0],4'b0}:
		((Op==2'd2)?{{4{current_out[15]}},current_out[15:4]}:
		((Op==2'd3)?{4'b0,current_out[15:4]}:
		current_out[15:0])))):
		current_out[15:0];
assign current_out[15:0]=Cnt[1]?((Op==2'd0)?{current_out[13:0],current_out[15:14]}:
		((Op==2'd1)?{current_out[13:0],2'b0}:
		((Op==2'd2)?{{2{current_out[15]}},current_out[15:2]}:
		((Op==2'd3)?{2'b0,current_out[15:2]}:
		current_out[15:0])))):
		current_out[15:0];
assign current_out[15:0]=Cnt[0]?((Op==2'd0)?{current_out[14:0],current_out[15]}:
		((Op==2'd1)?{current_out[14:0],1'b0}:
		((Op==2'd2)?{{1{current_out[15]}},current_out[15:1]}:
		((Op==2'd3)?{1'b0,current_out[15:1]}:
		current_out[15:0])))):
		current_out[15:0];		 
	assign Out=current_out;
endmodule

