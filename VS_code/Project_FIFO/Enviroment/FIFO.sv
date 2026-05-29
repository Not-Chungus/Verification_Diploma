////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////

module FIFO(FIFO_if.DUT F_if);


localparam max_fifo_addr = $clog2(F_if.FIFO_DEPTH);

reg [F_if.FIFO_WIDTH-1:0] mem [F_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;


//Writing logic
always @(posedge F_if.clk or negedge F_if.rst_n) begin 
	if (!F_if.rst_n) begin
		wr_ptr <= 0;
		F_if.wr_ack <= 0;
		F_if.overflow <= 0;
	end	
	else if (F_if.wr_en && (count < F_if.FIFO_DEPTH)) begin
		mem[wr_ptr] <= F_if.data_in;
		F_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		F_if.overflow <= 0;
	end else begin 
		F_if.wr_ack <= 0;
		wr_ptr <= wr_ptr; 
		if (F_if.wr_en && (count == F_if.FIFO_DEPTH) && !F_if.rd_en)
			F_if.overflow <= 1;
		else
			F_if.overflow <= 0;
	end
end

//Reading logic
always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		rd_ptr <= 0;
		F_if.data_out <= 0;
		F_if.underflow <= 0;
	end
	else if (F_if.rd_en && count != 0) begin
		F_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		F_if.underflow <= 0;
	end else begin 
		if (F_if.rd_en && count == 0 && !F_if.wr_en)
			F_if.underflow <= 1;
		else
			F_if.underflow <= 0;
	end
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({F_if.wr_en, F_if.rd_en} == 2'b10) && !F_if.full) 
			count <= count + 1;
		else if ( ({F_if.wr_en, F_if.rd_en} == 2'b01) && !F_if.empty)
			count <= count - 1;
		else if ({F_if.wr_en, F_if.rd_en} == 2'b11) begin
			if (F_if.empty == 1) //Writing if empty
				count <= count + 1;
			if (F_if.full == 1) //Reading if full
				count <= count - 1; 
			//no race since FIFO cant be full and empty at the same time
		end
	end
end

assign F_if.full = (count == F_if.FIFO_DEPTH)? 1 : 0;
assign F_if.empty = (count == 0)? 1 : 0;
assign F_if.almostfull = (count == F_if.FIFO_DEPTH-1)? 1 : 0;
assign F_if.almostempty = (count == 1)? 1 : 0;


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//END OF DESIGN -- ASSERTIONS -------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------




property p_wr_ack_1;  //(sequential)-----------
    @(posedge F_if.clk) disable iff (!F_if.rst_n)
    (F_if.wr_en && !F_if.full) |=> (F_if.wr_ack == 1);
endproperty

property p_wr_ack_2;  
    @(posedge F_if.clk) disable iff (!F_if.rst_n)
    (F_if.wr_en && F_if.full) |=> (F_if.wr_ack == 0);
endproperty

property p_rd_ptr_wrap;
    @(posedge F_if.clk) disable iff (!F_if.rst_n)
	(F_if.rd_en &&
     !F_if.empty &&
     !(F_if.wr_en && F_if.empty) &&
     (rd_ptr == F_if.FIFO_DEPTH-1))
    
	|=> (rd_ptr == 0);
endproperty

property p_wr_ptr_wrap;
    @(posedge F_if.clk) disable iff (!F_if.rst_n)
    (F_if.wr_en &&
     !F_if.full &&
     !(F_if.rd_en && F_if.full) &&
     (wr_ptr == F_if.FIFO_DEPTH-1))
    
	|=> (wr_ptr == 0);
endproperty

property p_wr_ptr_threshold;
	@(posedge F_if.clk) disable iff (!F_if.rst_n)
    wr_ptr < F_if.FIFO_DEPTH;
endproperty

property p_rd_ptr_threshold;
	@(posedge F_if.clk) disable iff (!F_if.rst_n)
    rd_ptr < F_if.FIFO_DEPTH;
endproperty

property p_overflow;
    @(posedge F_if.clk) disable iff (!F_if.rst_n)
    (F_if.wr_en && F_if.full && !F_if.rd_en) |=> (F_if.overflow == 1);
endproperty

property p_underflow;
    @(posedge F_if.clk) disable iff (!F_if.rst_n)
    (F_if.rd_en && F_if.empty && !F_if.wr_en) |=> (F_if.underflow == 1);
endproperty


//combinational properties--------------------------------------

property p_count_range;
  @(posedge F_if.clk) disable iff (!F_if.rst_n)
    (count >= 0) && (count <= F_if.FIFO_DEPTH);
endproperty

property p_full;
    @(posedge F_if.clk) disable iff (!F_if.rst_n)
    (F_if.full) |-> (count == F_if.FIFO_DEPTH);
endproperty

property p_empty;
    @(posedge F_if.clk) disable iff (!F_if.rst_n)
    (F_if.empty) |-> (count == 0);
endproperty

property p_almost_full;
    @(posedge F_if.clk) disable iff (!F_if.rst_n)
    (F_if.almostfull) |-> (count == (F_if.FIFO_DEPTH - 1));
endproperty

property p_almost_empty;
    @(posedge F_if.clk) disable iff (!F_if.rst_n)
    (F_if.almostempty) |-> (count == 1);
endproperty





a_wr_ack_1: assert property (p_wr_ack_1);
a_wr_ack_1_cover: cover property (p_wr_ack_1);

a_wr_ack_2: assert property (p_wr_ack_2);
a_wr_ack_2_cover: cover property (p_wr_ack_2);

a_rd_ptr_wrap: assert property (p_rd_ptr_wrap);
a_rd_ptr_wrap_cover: cover property (p_rd_ptr_wrap);

a_wr_ptr_wrap: assert property (p_wr_ptr_wrap);
a_wr_ptr_wrap_cover: cover property (p_wr_ptr_wrap);

a_overflow: assert property (p_overflow);
a_overflow_cover: cover property (p_overflow);

a_underflow: assert property (p_underflow);
a_underflow_cover: cover property (p_underflow);

a_full: assert property (p_full);
a_full_cover: cover property (p_full);

a_empty: assert property (p_empty);
a_empty_cover: cover property (p_empty);

a_almost_full: assert property (p_almost_full);
a_almost_full_cover: cover property (p_almost_full);

a_almost_empty: assert property (p_almost_empty);
a_almost_empty_cover: cover property (p_almost_empty);

a_wr_ptr_threshold: assert property (p_wr_ptr_threshold);
a_wr_ptr_threshold_cover: cover property (p_wr_ptr_threshold);

a_rd_ptr_threshold: assert property (p_rd_ptr_threshold);
a_rd_ptr_threshold_cover: cover property (p_rd_ptr_threshold);

a_count_range : assert property (p_count_range);
a_count_range_cover : cover property (p_count_range);


//a.reset immediate assertion for asynchronous behavior
always_comb begin 
if(!F_if.rst_n) begin
    a_reset: assert final(count == 0);
	a_rd_ptr_reset: assert final(rd_ptr == 0);
	a_wr_ptr_reset: assert final(wr_ptr == 0); 
	a_wr_ack_reset: assert final(F_if.wr_ack == 0);
	a_empty_reset: assert final(F_if.empty == 1);
	a_full_reset: assert final(F_if.full == 0);
	a_almostfull_reset: assert final(F_if.almostfull == 0);
	a_almostempty_reset: assert final(F_if.almostempty == 0);
	a_overflow_reset: assert final(F_if.overflow == 0);
	a_underflow_reset: assert final(F_if.underflow == 0);
	a_data_out_reset: assert final(F_if.data_out == 0);
	end
end


endmodule