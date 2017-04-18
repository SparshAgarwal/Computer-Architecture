/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output reg [15:0] DataOut;
   output reg Done;
   output reg Stall;
   output CacheHit;
   output err;
   
   reg [4:0] nextState;
   wire [4:0] currState;
   dff curr_State[4:0] (.q(currState), .d(nextState), .clk(clk), .rst(rst));
   
   wire dirty, valid, hit, miss, mem_stall;
   wire[15:0] cache_data_out, mem_data_out;
   wire[4:0] tag_out;
   wire[3:0] busy;
   reg comp, cache_write, mem_wr, mem_rd, enable, valid_in;
   reg [15:0] cache_data_in, mem_addr, mem_data_in;
   reg [7:0] index;
   reg [4:0] tag_in;
   reg [2:0] offset;
   
   wire cacheErr, memErr;
   reg controlErr;
   assign err = controlErr;
   assign CacheHit = hit;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter mem_type = 0;
   cache #(mem_type + 0) c0(// Outputs
                          .tag_out             	(tag_out),
                          .data_out            (cache_data_out),
                          .hit                  	(hit),
                          .dirty                	(dirty),
                          .valid                	(valid),
                          .err                  	(cacheErr),
                          // Inputs
                          .enable             	(enable),
                          .clk                  	(clk),
                          .rst                  	(rst),
                          .createdump        (createdump),
                          .tag_in                (tag_in),
                          .index                	(index),
                          .offset               	(offset),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                	(cache_write),
                          .valid_in             (valid_in));

   four_bank_mem mem(// Outputs
                     .data_out         (mem_data_out),
                     .stall             	(mem_stall),
                     .busy              	(busy), 
                     .err               	(memErr),
                     // Inputs
                     .clk               	(clk),
                     .rst               	(rst),
                     .createdump     (createdump),
                     .addr              	(mem_addr),
                     .data_in           (mem_data_in),
                     .wr                	(mem_wr),
                     .rd                	(mem_rd));

   
   assign miss = enable  & (~hit | ~valid); 
   
   //TODO: if inputs do not match is it an error or same state? 
   always@(*)begin case(currState)
	
		//IDLE
		5'h00: begin 
			enable = 1;
			$display(" *********************************in idle");
			enable = 1;
			comp = 1;
			cache_write = Wr ? 1 : 0; 
			index = (~Wr & ~Rd) ? 0 : Addr[10:3]; //[1:0] is to select word in a cache line
			tag_in = (~Wr & ~Rd) ? 0 : Addr[15:11];
			offset = (~Wr & ~Rd) ? 0 : {Addr[2:1], 1'b0};
			cache_data_in = Wr ? DataIn : 0; 
			valid_in = 0;
			mem_addr = 0; //not using memory yet
			mem_data_in = 0;
			mem_wr = 0;
			mem_rd = 0;
			DataOut = Rd ? (( hit & valid ) ? cache_data_out : 0) : 0;
			Done = (hit & valid) ? 1 : 0;
			Stall = (~Wr & ~Rd) ? 0 : ((hit & valid) ? 0 : 1);
			nextState = (miss & ~dirty) ? 5'h03 : ((miss & valid & dirty) ? 5'h0D : ((hit & valid) ? 5'h00 : 5'h00));
			$display(" valid = %d", valid);
			$display(" Done = %d", Done);
			$display(" miss = %d", miss);
			$display(" dirty = %d", dirty);
			$display(" hit = %d", hit);
			$display(" next state: %d",nextState);
			$display(" Write: %d",Wr);
			$display(" Read: %d",Rd);
			$display(" Stall: %d",Stall);
			$display(" Mem Stall: %d",mem_stall);
		end
		
		//MEMORY READ 1 
		5'h03: begin 
			$display(" in memory read 1 ");
			enable = 0;
			comp = 0;
			cache_write = 0; 
			index = 0;
			tag_in = 0;
			offset = 0;
			cache_data_in = 0; 
			valid_in = 0;
			mem_addr = {Addr[15:3], 3'b000};
			mem_data_in = 0; //not writing to memory
			mem_wr = 0;
			mem_rd = 1;
			DataOut = 0; //DataOut not set yet
			Done = 0;
			Stall = 1;
			nextState = 5'h06; 
			$display("next state: %d",nextState);
		end
		
		//MEMORY READ 2
		5'h06: begin 
			$display(" in memory read 2");
			enable = 0;
			comp = 0;
			cache_write = 0; 
			index = 0;
			tag_in = 0;
			offset = 0;
			cache_data_in = 0; 
			valid_in = 0;
			mem_addr = {Addr[15:3], 3'b010};
			mem_data_in = 0; 
			mem_wr = 0;
			mem_rd = 1;
			DataOut = 0; //DataOut not set yet
			Done = 0;
			Stall = 1;
			nextState = mem_stall ? 5'h06 : 5'h08;
			$display("next state: %d",nextState);
		end
	
		//MEMORY READ 3 and INSTALL CACHE 1
		5'h08: begin 
			$display(" in memory read 3/install cache 1");
			enable = 1;
			comp = 0;
			cache_write = 1; 
			index = Addr[10:3];
			tag_in = Addr[15:11];
			offset = 3'b000;
			cache_data_in = (Wr & (offset == {Addr[2:1], 1'b0})) ? DataIn : mem_data_out; 
			valid_in = 0;
			mem_addr = {Addr[15:3], 3'b100};
			mem_data_in = 0;
			mem_wr = 0;
			mem_rd = 1;
			DataOut = (Rd & (offset == {Addr[2:1], 1'b0})) ? mem_data_out : 0; 
			Done = 0;
			Stall = 1;
			nextState = mem_stall ? 5'h08 : 5'h0A;
			$display("next state: %d",nextState);
		end	
		
		//MEMORY READ 4 and INSTALL CACHE 2
		5'h0A: begin 
			$display(" in memory read 4/install cache 2");
			enable = 1;
			comp = 0;
			cache_write = 1; 
			index = Addr[10:3];
			tag_in = Addr[15:11];
			offset = 3'b010;
			cache_data_in = (Wr & (offset == {Addr[2:1], 1'b0})) ? DataIn : mem_data_out; 
			valid_in = 0;
			mem_addr = {Addr[15:3], 3'b110};
			mem_data_in = 0;
			mem_wr = 0;
			mem_rd = 1;
			DataOut = (Rd & (offset == {Addr[2:1], 1'b0})) ? mem_data_out : 0;
			Done = 0;
			Stall = 1;
			nextState = mem_stall ? 5'h0A : 5'h0B;
			$display("next state: %d",nextState);
		end

		//INSTALL CACHE 3 
		5'h0B: begin
			$display(" in install cache 3");
			enable = 1;
			comp = 0;
			cache_write = 1;
			index = Addr[10:3]; 
			tag_in = Addr[15:11];
			offset = 3'b100;
			cache_data_in = (Wr & (offset == {Addr[2:1], 1'b0})) ? DataIn : mem_data_out; 
			valid_in = 0;
			mem_addr = 0; 
			mem_data_in = 0;
			mem_wr = 0;
			mem_rd = 0;
			DataOut = (Rd & (offset == {Addr[2:1], 1'b0})) ? mem_data_out : 0;
			Done = 0;
			Stall = 1;
			nextState = mem_stall ? 5'h0B : 5'h0C; 
			$display("next state: %d",nextState);
		end 

		//INSTALL CACHE 4 
		5'h0C: begin
			$display(" ***********************in install cache 4");
			enable = 1;
			comp = 0;
			cache_write = 1;
			index = Addr[10:3]; 
			tag_in = Addr[15:11];
			offset = 3'b110;
			cache_data_in = (Wr & (offset == {Addr[2:1], 1'b0})) ? DataIn : mem_data_out; 
			valid_in = 1;
			mem_addr = 0; 
			mem_data_in = 0;
			mem_wr = 0;
			mem_rd = 0;
			DataOut = (Rd & (offset == {Addr[2:1], 1'b0})) ? mem_data_out : 0;
			Done = 1;
			Stall = 0;
			nextState = 5'h00; 
			$display("next state: %d",nextState);
			$display(" valid = %d", valid);
			$display(" miss = %d", miss);
			$display(" dirty = %d", dirty);
			$display(" hit = %d", hit);
			$display(" comp: %d" ,comp);
			$display(" Write: %d",Wr);
			$display(" Read: %d",Rd);
			$display(" Stall: %d",Stall);
			$display(" Mem Stall: %d",mem_stall);
			$display(" Valid_in: %d",valid_in);
		end 
		
		
		//PRE-MEMORY WRITEBACK/ACCESS READ 1 (miss, dirty, valid): read dirty data to writeback to memory in MEMORY WRITEBACK stage
		5'h0D: begin
			$display(" in prememory writeback/ access read 1 ");
			enable = 1;
			comp = 0;
			cache_write = 0; //not writing to cache
			index = Addr[10:3]; 
			tag_in = 0; //not used
			offset = 3'b000;
			cache_data_in = 0; //not using
			valid_in = 0;
			mem_addr = {tag_out, Addr[10:3], 3'b000};
			mem_data_in = cache_data_out;
			mem_wr = 1;
			mem_rd = 0;
			DataOut = 0; //DataOut not set yet
			Done = 0;
			Stall = 1;
			nextState = 5'h0E;
			$display("next state: %d",nextState);
		end
		
		//PRE-MEMORY WRITEBACK/ACCESS READ 2 (and WRITE 1)
		5'h0E: begin
			$display("in prememory writeback/ access read 2 ");
			enable = 1;
			comp = 0;
			cache_write = 0; //not writing to cache
			index = Addr[10:3]; 
			tag_in = 0; //not used
			offset = 3'b010;
			cache_data_in = 0; //not using
			valid_in = 0;
			mem_addr = {tag_out, Addr[10:3], 3'b010};
			mem_data_in = cache_data_out;
			mem_wr = 1;
			mem_rd = 0;
			DataOut = 0; //DataOut not set yet
			Done = 0;
			Stall = 1;
			nextState = mem_stall ? 5'h0E : 5'h0F;
			$display("next state: %d",nextState);
		end

		//PRE-MEMORY WRITEBACK/ACCESS READ 3 (and WRITE 1 and 2)
		5'h0F: begin
			$display("in prememory writeback/ access read 3 ");
			enable = 1;
			comp = 0;
			cache_write = 0; //not writing to cache
			index = Addr[10:3]; 
			tag_in = 0; //not used
			offset = 3'b100;
			cache_data_in = 0; //not using
			valid_in = 0;
			mem_addr = {tag_out, Addr[10:3], 3'b100};
			mem_data_in = cache_data_out;
			mem_wr = 1;
			mem_rd = 0;
			DataOut = 0; //DataOut not set yet
			Done = 0;
			Stall = 1;
			nextState = mem_stall ? 5'h0F : 5'h10;
			$display("next state: %d",nextState);
		end	

		//PRE-MEMORY WRITEBACK/ACCESS READ 4 (and WRITE 1, 2, 3)
		5'h10: begin
			$display("in prememory writeback/ access read 4 ");
			enable = 1;
			comp = 0;
			cache_write = 0; //not writing to cache
			index = Addr[10:3]; 
			tag_in = 0; //not used
			offset = 3'b110;
			cache_data_in = 0; //not using
			valid_in = 0;
			mem_addr = {tag_out, Addr[10:3], 3'b110};
			mem_data_in = cache_data_out;
			mem_wr = 1;
			mem_rd = 0;
			DataOut = 0; //DataOut not set yet
			Done = 0;
			Stall = 1;
			nextState = mem_stall ? 5'h10 : 5'h03;
			$display("next state: %d",nextState);
		end
		
		//ERROR
		5'h15: begin
			$display("in error");
			Done = 1;
			Stall = 0;
			if(Done && 1) begin
				$display(" done in error");
				end
			controlErr = 1;
			nextState = 5'h00;
			$display("next state: %d",nextState);
		end
		
		default: begin
			enable = 1;
			$display(" in default");
			enable = 1;
			comp = 1;
			cache_write = Wr ? 1 : 0; 
			index = (~Wr & ~Rd) ? 0 : Addr[10:3]; //[1:0] is to select word in a cache line
			tag_in = (~Wr & ~Rd) ? 0 : Addr[15:11];
			offset = (~Wr & ~Rd) ? 0 : {Addr[2:1], 1'b0};
			cache_data_in = Wr ? DataIn : 0; 
			valid_in = Wr ? 1 : 0;
			mem_addr = 0; //not using memory yet
			mem_data_in = 0;
			mem_wr = 0;
			mem_rd = 0;
			DataOut = Rd ? (( hit & valid ) ? cache_data_out : 0) : 0;
			Done = (hit & valid) ? 1 : 0;
			Stall = (~Wr & ~Rd) ? 0 : ((hit & valid) ? 0 : 1);
			nextState = (miss & ~dirty) ? 5'h03 : ((miss & valid & dirty) ? 5'h0D : ((hit & valid) ? 5'h00 : 5'h00));
			$display(" valid = %d", valid);
			$display(" Done = %d", Done);
			$display(" miss = %d", miss);
			$display(" dirty = %d", dirty);
			$display(" hit = %d", hit);
			$display(" next state: %d",nextState);
			$display(" Write: %d",Wr);
			$display(" Read: %d",Rd);
			$display(" Stall: %d",Stall);
			$display(" Mem Stall: %d",mem_stall);
			$display("next state: %d",nextState);	
		end
	
	endcase
	end

   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9: