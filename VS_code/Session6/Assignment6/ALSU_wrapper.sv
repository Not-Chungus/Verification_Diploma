module ALSU_wrapper(ALSU_if ALSU_if);

    ALSU dut (
        .clk(ALSU_if.clk), .cin(ALSU_if.cin), .rst(ALSU_if.rst),
        .red_op_A(ALSU_if.red_op_A), .red_op_B(ALSU_if.red_op_B),
        .bypass_A(ALSU_if.bypass_A), .bypass_B(ALSU_if.bypass_B),
        .direction(ALSU_if.direction), .serial_in(ALSU_if.serial_in),
        .opcode(ALSU_if.opcode),
        .A(ALSU_if.A), .B(ALSU_if.B),
        
        .leds(ALSU_if.leds), .out(ALSU_if.out)
    );


endmodule


