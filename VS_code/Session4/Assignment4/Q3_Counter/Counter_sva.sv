module counter_sva(counter_if.DUT c_if);

//rst_n;
//load_n;
//up_down;
//ce;
//[WIDTH-1:0] data_load;
//[WIDTH-1:0] count_out;
//max_count;
//zero;

property p_load;  //load has priority over enable
    @(posedge c_if.clk) disable iff (!c_if.rst_n)
    (!c_if.load_n) |=> (c_if.count_out == $past(c_if.data_load));
endproperty

property p_no_load;
    @(posedge c_if.clk) disable iff (!c_if.rst_n)
    (c_if.load_n && ~c_if.ce) |=> (c_if.count_out == $past(c_if.count_out));
endproperty

property p_counting_up;
    @(posedge c_if.clk) disable iff (!c_if.rst_n)
    (c_if.load_n && c_if.ce && c_if.up_down) |=> (c_if.count_out == $past(c_if.count_out) + 1'b1);
endproperty

property p_counting_down;
    @(posedge c_if.clk) disable iff (!c_if.rst_n)
    (c_if.load_n && c_if.ce && !c_if.up_down) |=> (c_if.count_out == $past(c_if.count_out) - 1'b1);
endproperty

property p_max;
    @(posedge c_if.clk) disable iff (!c_if.rst_n)
    (c_if.count_out == {c_if.WIDTH{1'b1}}) |-> (c_if.max_count);
endproperty

property p_zero;
    @(posedge c_if.clk) disable iff (!c_if.rst_n)
    (c_if.count_out == {c_if.WIDTH{1'b0}}) |-> (c_if.zero);
endproperty



a_Load: assert property (p_load);
a_Load_cover: cover property (p_load);

a_no_Load: assert property (p_no_load);
a_no_load_cover: cover property (p_no_load);

a_counting_up: assert property (p_counting_up);
a_counting_up_cover: cover property (p_counting_up);

a_counting_down: assert property (p_counting_down);
a_counting_down_cover: cover property (p_counting_down);

a_max: assert property (p_max);
a_max_cover: cover property (p_max);

a_zero: assert property (p_zero);
a_zero_cover: cover property (p_zero);



always_comb begin 
if(!c_if.rst_n) 
    a_reset: assert final(c_if.count_out == 0);  
end


endmodule

