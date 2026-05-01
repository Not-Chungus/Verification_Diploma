module ALSU_golden_wrapper(ALSU_if ALSUif);

    ALSU_golden dut (
        .clk(ALSUif.clk), .cin(ALSUif.cin), .rst(ALSUif.rst),
        .red_op_A(ALSUif.red_op_A), .red_op_B(ALSUif.red_op_B),
        .bypass_A(ALSUif.bypass_A), .bypass_B(ALSUif.bypass_B),
        .direction(ALSUif.direction), .serial_in(ALSUif.serial_in),
        .opcode(ALSUif.opcode),
        .A(ALSUif.A), .B(ALSUif.B),
        
        .leds(ALSUif.leds), .out(ALSUif.out)
    );


endmodule


