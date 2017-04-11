	wire [15:0] current_out;

	
assign current_out[15:0]=Cnt[3]?((Op==2'b10)?{In[7:0],In[15:8]}:
		((Op==2'b01)?{In[7:0],8'b00000000}:
		((Op==2'b10)?{{8{In[15]}},In[15:8]}:
		((Op==2'b11)?{8'b00000000,In[15:8]}:
		In[15:0])))):
		In[15:0];
assign In[15:0]=Cnt[2]?((Op==2'b00)?{current_out[11:0],current_out[15:12]}:
		((Op==2'b01)?{current_out[11:0],4'b0000}:
		((Op==2'b10)?{{4{current_out[15]}},current_out[15:4]}:
		((Op==2'b11)?{4'b0000,current_out[15:4]}:
		current_out[15:0])))):
		current_out[15:0];
assign current_out[15:0]=Cnt[1]?((Op==2'b00)?{In[13:0],In[15:14]}:
		((Op==2'b01)?{In[13:0],2'b00}:
		((Op==2'b10)?{{2{In[15]}},In[15:2]}:
		((Op==2'b11)?{2'b00,In[15:2]}:
		In[15:0])))):
		In[15:0];
assign In[15:0]=Cnt[0]?((Op==2'b00)?{current_out[14:0],current_out[15]}:
		((Op==2'b01)?{current_out[14:0],1'b0}:
		((Op==2'b10)?{{1{current_out[15]}},current_out[15:1]}:
		((Op==2'b11)?{1'b0,current_out[15:1]}:
		current_out[15:0])))):
		current_out[15:0];		 
	assign Out=In;
