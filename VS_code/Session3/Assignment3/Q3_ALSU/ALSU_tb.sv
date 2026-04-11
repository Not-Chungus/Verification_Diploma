import class_pkg::*;
module ALSU_tb;


reg clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
opcode_e opcode;
reg signed [2:0] A, B;

wire [15:0] leds;
wire signed [5:0] out;


reg signed [5:0] expected_out;
reg [15:0] expected_leds;


ALSU #(
    .INPUT_PRIORITY(INPUT_PRIORITY),
    .FULL_ADDER(FULL_ADDER)
    ) uut (.*);
ALSU_golden #(
    .INPUT_PRIORITY(INPUT_PRIORITY),
    .FULL_ADDER(FULL_ADDER)
    ) golden (.out(expected_out),.leds(expected_leds),.*);


integer correct_count = 0;
integer error_count = 0;

//clk========================================
initial begin
    clk = 0; 
    forever begin
        #5 clk = ~clk;
        cntrl.clk = clk;
    end
end

//Sampling for Bins==========================
always @(posedge clk)
    myport.sample();
always @(posedge rst or posedge bypass_A or posedge bypass_B)
    myport.stop();
//event for .start??


initial begin
    RandomControl cntrl;
    cntrl = new;
    CovPort myport;
    correct_count = 0; error_count = 0;
    expected_out = 0; expected_leds = 0;
    $display("===================================================TestBench Start===================================================");


    //Test Series 1: Assert reset
    assert_reset();

    //Test Series 2: Randomization loop
    repeat(1000) begin  //take care when repeating for sequential testbenches 
        assert(cntrl.randomize());                // as we check and stimulate after 1 tick
    //use obejct's values
        A = cntrl.A;
        B = cntrl.B;
        opcode = opcode_e'(cntrl.opcode);

        cin = cntrl.cin; rst = cntrl.rst ;
        red_op_A = cntrl.red_op_A; red_op_B = cntrl.red_op_B; 
        bypass_A = cntrl.bypass_A; bypass_B = cntrl.bypass_B;
        direction= cntrl.direction; serial_in = cntrl.serial_in;
    
    //wait for two clock cycles
        @(negedge clk);
        @(negedge clk);


        check_result();
        #1;

    end

    //Test Series 3: Assert reset again
    assert_reset();


    $display("%t: At end of test error count is %0d and correct count = %0d", $time, error_count, correct_count);
    $display("====================================================TestBench End====================================================");
    $stop;

end



task check_result;

    if((out  == expected_out) && (leds == expected_leds))
    correct_count = correct_count + 1;
    else
    error_count = error_count + 1;
   
    if (out  !== expected_out) begin
        $display("========================================================================");
        $display("Error: opcode = %s | bypass_A = %b | bypass_B = %b | red_op_A = %b | red_op_B = %b | cin = %b" , opcode.name, bypass_A,bypass_B,red_op_A, red_op_B,cin);
        $display("direction = %b | serial_in = %b" , direction,serial_in);
        $display("A: %d | B: %d", A, B);
        $display("Expected out = %d | Actual = %d", out, expected_out);
    end

    if (leds  !== expected_leds) begin
        $display("========================================================================");
        $display("Error: opcode = %s | bypass_A = %b | bypass_B = %b | red_op_A = %b | red_op_B = %b | cin = %b" , opcode.name, bypass_A,bypass_B,red_op_A, red_op_B,cin);
        $display("direction = %b | serial_in = %b" , direction,serial_in);
        $display("A: %d | B: %d", A, B);
        $display("Expected leds = %d | Actual = %d", leds, expected_leds);
    end

endtask






task assert_reset;
    @(negedge clk);
    rst = 1;
    @(negedge clk);
    @(negedge clk);
    if (expected_out !== 0) begin
        error_count = error_count + 1;
        $display("Error Reseting");
    end
    else
        correct_count = correct_count + 1;
    @(negedge clk);
    rst = 0;
endtask



endmodule