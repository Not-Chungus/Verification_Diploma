import testing_pkg::*;
module ALU_tb;

//DUT signals
byte operand1, operand2;
reg clk, rst;
opcode_e opcode;
byte out;

//bins group instantiation
    Transaction tr = new();

//Golden model expected signals
byte expected_out;

integer error_count;
integer correct_count;

initial begin  // Create the clock (10ns period)
    clk = 0; 
    forever begin
        #5 clk = ~clk;
        tr.clk = clk;
    end
end


alu_seq uut (operand1, operand2, clk, rst, opcode, out);

initial begin
    error_count = 0;
    correct_count = 0;
    $display("===================================================TestBench Start===================================================");
    //1.Directed reset
    assert_reset_check;

    //2. Randomization loop
    repeat(32) begin  //take care when repeating for sequential testbenches 
        assert(tr.randomize());                // as we check and stimulate after 1 tick

        operand1 = tr.operand1;
        operand2 = tr.operand2;
        opcode = opcode_e'(tr.opcode);

        @(negedge clk);
        compute_expected;
        check_against_expected;
    end

    //3. Opcode transition
    repeat(5) begin //5 times that operands fixed
        operand1 = tr.operand1;
        operand2 = tr.operand2;

        repeat(10) begin //10 transitons of opcode
            opcode = opcode_e'(tr.opcode);
            @(negedge clk);
            compute_expected;
            check_against_expected;
        end
    end

    //4.one last reset
    assert_reset_check;
    $display("%t: At end of test error count is %0d and correct count = %0d", $time, error_count, correct_count);
    $display("====================================================TestBench End====================================================");
    $stop();
end

//===========================TASKS=====================================
task assert_reset_check;
    @(negedge clk)
    rst = 1;
    @(negedge clk);
    if (out !== 0) begin
        error_count = error_count + 1;
        $display("Error Reseting");
    end
    else
        correct_count = correct_count + 1;
    rst = 0;
endtask


task check_against_expected;
@(negedge clk);
if (out !== expected_out) begin
    error_count = error_count + 1;
    $display("%t: Error: For operand1=%0d, operand2=%0d, out should equal %0d but is %0d", 
         $time, operand1, operand2, expected_out, out);
end
else
    correct_count = correct_count + 1;
endtask

task compute_expected;   //Golden Model
    if (opcode == ADD) expected_out = operand1 + operand2;
    else if (opcode == SUB) expected_out = operand1 - operand2;
    else if (opcode == MULT) expected_out = operand1 * operand2;
    else if (opcode == DIV) expected_out = operand1 / operand2;
    else expected_out = 8'b00;
  
endtask


endmodule