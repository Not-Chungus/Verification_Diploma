module ALU_tb;



reg  clk,reset;
reg  [1:0] Opcode;	// The opcode
reg  signed [3:0] A;	// Input data A in 2's complement
reg  signed [3:0] B;	// Input data B in 2's complement

wire  signed [4:0] C; // ALU output in 2's complement
logic signed [4:0] expected_C;

integer error_count;
integer correct_count;

ALU_4_bit uut ( // Instantiate the Unit Under Test (UUT)
    .clk(clk),
    .reset(reset),
    .Opcode(Opcode),
    .A(A),
    .B(B),
    .C(C)
);


initial begin  // Create the clock (2ns period)
    clk = 0; 
    forever
        #5 clk = ~clk;
end

localparam MAXPOS = 7, ZERO = 0, MAXNEG = -8;
localparam 		    Add	           = 2'b00; // A + B
localparam 		    Sub	           = 2'b01; // A - B
localparam 		    Not_A	       = 2'b10; // ~A
localparam 		    ReductionOR_B  = 2'b11; // |B

initial begin
    A = 0;
    B = 0;
    error_count = 0;
    correct_count = 0;
    $display("===================================================TestBench Start===================================================");

    // Test 1: Reset Behavior
    assert_check;

    // Test 2: ADD Operation
    A = MAXNEG; B = MAXNEG; Opcode = Add; compute_expected;
    A = MAXPOS; B = MAXPOS; compute_expected;
    A = MAXPOS; B = MAXNEG; compute_expected;
    A = MAXNEG; B = MAXPOS; compute_expected;
    A = 0; B = MAXPOS; compute_expected;
    A = MAXNEG; B = 0; compute_expected;
    A = 0; B = MAXNEG; compute_expected;
    A = MAXPOS; B = 0; compute_expected;
    A = 0; B = 0; compute_expected;

    // Test 3: SUB Operation
    A = MAXNEG; B = MAXNEG; Opcode = Sub; compute_expected;
    A = MAXPOS; B = MAXPOS; compute_expected;
    A = MAXPOS; B = MAXNEG; compute_expected;
    A = MAXNEG; B = MAXPOS; compute_expected;
    A = 0; B = MAXPOS; compute_expected;
    A = MAXNEG; B = 0; compute_expected;
    A = 0; B = MAXNEG; compute_expected;
    A = MAXPOS; B = 0; compute_expected;
    A = 0; B = 0; compute_expected;

    // Test 4: ~A (Bitwise Inversion)
    repeat(10) begin
        Opcode = Not_A;
        A = $random;
        compute_expected;
    end

    // Test 4 (cont): |B (Reduction OR)
    Opcode = ReductionOR_B;
    repeat(10) begin
        B = $random;
        compute_expected;
    end

    // Test 5: All opcodes for fixed values
    A = 3;
    B = -2;
    Opcode = 2'b00; compute_expected;
    Opcode = 2'b01; compute_expected;
    Opcode = 2'b10; compute_expected;
    Opcode = 2'b11; compute_expected;

    // Test 6: Final check and wrap-up
    assert_check;
    $display("%t: At end of test error count is %0d and correct count = %0d", $time, error_count, correct_count);
    $display("====================================================TestBench End====================================================");
    $stop;
end

task compute_expected;
    if (Opcode == Add) expected_C = A + B;
    else if (Opcode == Sub) expected_C = A - B;
    else if (Opcode == Not_A) expected_C = ~A;
    else if (Opcode == ReductionOR_B) expected_C = |B;
    else expected_C = 5'b00;

    check_result;
endtask

task assert_check;
    @(negedge clk)
    reset = 1;
    @(negedge clk);
    if (C !== 0) begin
        error_count = error_count + 1;
        $display("Error Reseting");
    end
    else
        correct_count = correct_count + 1;
    reset = 0;
endtask

task check_result;
    @(negedge clk);
    if (C !== expected_C) begin
        error_count = error_count + 1;
        $display("%t: Error: For A=%0d, B=%0d, C should equal %0d but is %0d", 
                 $time, A, B, expected_C, C);
    end
    else
        correct_count = correct_count + 1;
endtask

endmodule