module priority_enc_tb;

reg clk, rst;
reg [3:0] D;

wire [1:0] Y;
wire valid;

integer error_count;
integer correct_count;

priority_enc uut ( // Instantiate the Unit Under Test (UUT)
    .clk(clk),
    .rst(rst),
    .D(D),
    .Y(Y),
    .valid(valid)
);


initial begin  // Create the clock (2ns period)
    clk = 0; 
    forever
        #5 clk = ~clk;
end

initial begin
    integer i;

    $display("===================================================TestBench Start===================================================");
    error_count = 0;
    correct_count = 0;
    D = 4'b0000;
    rst = 0;
    
    // Test 1: Reset Behavior
    assert_reset(D);

  
    for (i = 0; i < 16; i = i + 1) begin
        D = i;
        check_result(D);
    end

    D = 4'b0000;
    check_result(D);  //to toggle H-L D[3] for coverage

    assert_reset(D);

    

    $display("%t: At end of test error count is %0d and correct count = %0d", $time, error_count, correct_count);
    $display("====================================================TestBench End====================================================");
    $stop;
end

// Task to check Y and valid bit
task check_result (input [3:0] D);
    
    @(negedge clk);
    if (Y !== Y_expected(D) || valid !== valid_expected(D)) begin
        error_count = error_count + 1;
        $display("%t: Error: For D= %b, Y should be %0d (got %0d) and valid should be %b (got %b)", 
                 $time, D, Y_expected(D), Y, valid_expected(D), valid);
    end
    else
        correct_count = correct_count + 1;
endtask

function valid_expected (input [3:0] D_val);

    if(D_val == 4'b0000)
        return 1'b0;
    else
        return 1'b1; 

endfunction

function [1:0] Y_expected (input [3:0] Din); //Golden Model

    if(rst)
        return 2'b00;
    else begin
        if(Din[0] == 1)
            return 2'b11;
        else if(Din[1] == 1)
            return 2'b10;
        else if(Din[2] == 1)
            return 2'b01;
        else if(Din[3] == 1)
            return 2'b00;
        else
            return 2'b00;  //as we made the dont care result in design, so they can go along
    end
endfunction

task assert_reset(input [3:0] D);
    @(negedge clk)
    rst = 1;
    check_result(D); //Y should equal to 0 regardless of D
    @(negedge clk)
    rst = 0;
endtask

endmodule