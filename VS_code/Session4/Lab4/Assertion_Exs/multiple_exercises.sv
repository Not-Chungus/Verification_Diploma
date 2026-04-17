//- When signal_a rises, then starting next cycle, signal_b eventually shall fall
assert property (@(posedge clk) $rose(signal_a) |=> $fall(signal_b)[->1]);


//- When valid signal is high, then after 1 clk cycle, wr_ack should remain high until done is high
assert property (@(posedge clk) valid |=> (wr_ack throughout done[->1]));


//- When signal req rises, then after 1 clk cycle it is expected the ack eventually be high ,and after it gets high, it must go low the following clk cycle
assert property (@(posedge clk) $rose(req) |=> ((ack[->1]) ##1 (!ack) )   );