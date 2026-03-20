module DSP_tb;

reg  [17:0] A, B, D;
reg  [47:0] C;
reg clk, rst_n;

wire [47:0] P;


reg  [17:0] adder_out;
reg [47:0] mult_out, expected_P;

integer error_count;
integer correct_count;

DSP uut (.*);


initial begin  // Create the clock (2ns period)
    clk = 0; 
    forever
        #5 clk = ~clk;
end


initial begin
    A = 0;
    B = 0;
    C = 0;
    D = 0;
    rst_n = 1;
    error_count = 0;
    correct_count = 0;
    $display("===================================================TestBench Start===================================================");

    // Test 1: Reset Behavior
    assert_check;

    // Test 2: Loop of rand i/p(s)
    repeat(10000) begin
        A = $random();
        B = $random();
        C = $random();
        D = $random();

        compute_expected(); //Golden model

        check_result(); 

    end

    // Test 6: Final check and wrap-up
    assert_check;
    $display("%t: At end of test error count is %0d and correct count = %0d", $time, error_count, correct_count);
    $display("====================================================TestBench End====================================================");
    $stop;
end


task compute_expected; //Golden Model
    
    adder_out = B + D;  //dont need FFs the simulator simulates their delay
    mult_out = adder_out * A;  //because lines are executed sequentially in initial block
    expected_P = mult_out + C;

endtask

task assert_check;
    @(negedge clk)
    rst_n = 0;
    @(negedge clk);
    if (P !== 0) begin
        error_count = error_count + 1;
        $display("Error Reseting");
    end
    else
        correct_count = correct_count + 1;
    @(negedge clk)
    rst_n = 1;
endtask

task check_result;
    repeat(4) @(negedge clk); //Total latency is 4 cycles
    if (P !== expected_P) begin
        error_count = error_count + 1;
        $display("%t: Error: For A=%0h, B=%0h, C=%0h, D=%0h, P should equal %0h but is %0h", 
                 $time, A, B, C, D, expected_P, P);
    end
    else
        correct_count = correct_count + 1;
endtask

endmodule