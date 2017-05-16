module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;
	reg [15:0]value;
	
always @ (*) begin
	case(Op)
		2'b00:begin
			value =Cnt[3]?{In[7:0],In[15:8]}:In;
			value =Cnt[2]?{value[11:0],value[15:12]}:value;
			value =Cnt[1]?{value[13:0],value[15:14]}:value;
			value =Cnt[0]?{value[14:0],value[15]}:value;
		end
		2'b01:begin
			value =Cnt[3]?{In[7:0],8'b00000000}:In;
			value =Cnt[2]?{value[11:0],4'b0000}:value;
			value =Cnt[1]?{value[13:0],2'b00}:value;
			value =Cnt[0]?{value[14:0],1'b0}:value;
		end
		2'b10:begin
			value =Cnt[3]?{{8{In[15]}},In[15:8]}:In;
			value =Cnt[2]?{{4{value[15]}},value[15:4]}:value;
			value =Cnt[1]?{{2{value[15]}},value[15:2]}:value;
			value =Cnt[0]?{{1{value[15]}},value[15:1]}:value;
		end
		2'b11:begin
			value =Cnt[3]?{8'b00000000,In[15:8]}:In;
			value =Cnt[2]?{4'b0000,value[15:4]}:value;
			value =Cnt[1]?{2'b00,value[15:2]}:value;
			value =Cnt[0]?{1'b0,value[15:1]}:value;
		end
		default: begin
	        	$display("Error");
	        end
	endcase
end

assign Out=value;
endmodule

