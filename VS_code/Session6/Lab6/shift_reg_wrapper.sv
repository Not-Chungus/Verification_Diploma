module shift_reg_wrapper(shift_reg_if s_if);

    shift_reg dut (
        .clk(s_if.clk),
        .reset(s_if.reset),
        .serial_in(s_if.serial_in),
        .direction(s_if.direction),
        .mode(s_if.mode),
        .datain(s_if.datain),
        .dataout(s_if.dataout)
    );


endmodule


