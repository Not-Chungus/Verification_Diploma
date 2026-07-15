module FIFO_sva(FIFO_if.DUT F_if);



  property p_overflow;
      @(posedge F_if.clk) disable iff (!F_if.rst_n)
      (F_if.wr_en && F_if.full && !F_if.rd_en) |=> (F_if.overflow == 1);
  endproperty

  property p_underflow;
      @(posedge F_if.clk) disable iff (!F_if.rst_n)
      (F_if.rd_en && F_if.empty && !F_if.wr_en) |=> (F_if.underflow == 1);
  endproperty


  //combinational properties--------------------------------------






a_overflow: assert property (p_overflow);
a_overflow_cover: cover property (p_overflow);

a_underflow: assert property (p_underflow);
a_underflow_cover: cover property (p_underflow);






//a.reset immediate assertion for asynchronous behavior
always_comb begin 
if(!F_if.rst_n) begin
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