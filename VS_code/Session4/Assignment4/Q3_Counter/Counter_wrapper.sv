module counter_wrapper(counter_if.DUT c_if);

    counter dut (
        .clk(c_if.clk),
        .rst_n(c_if.rst_n),
        .load_n(c_if.load_n),
        .ce(c_if.ce),
        .up_down(c_if.up_down),
        .data_load(c_if.data_load),
        .count_out(c_if.count_out),
        .max_count(c_if.max_count),
        .zero(c_if.zero)
    );


endmodule