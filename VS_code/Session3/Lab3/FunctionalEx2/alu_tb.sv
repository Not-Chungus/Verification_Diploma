import testing_pkg::*;
module ALU_tb;

byte operand1, operand2;
reg clk, rst;
opcode_e opcode;
byte out;

    Transaction tr = new();



initial begin  // Create the clock (2ns period)
    clk = 0; 
    forever begin
        #5 clk = ~clk;
        tr.clk = clk;
    end
end


alu_seq uut (operand1, operand2, clk, rst, opcode, out);

initial begin
    rst = 0;
    @(negedge clk);
    rst = 1;
    @(negedge clk);
    rst = 0;
    $display("===================================================TestBench Start===================================================");

    //Test Series 2: Randomization loop
    repeat(32) begin  //take care when repeating for sequential testbenches 
        assert(tr.randomize());                // as we check and stimulate after 1 tick

        @(negedge clk);
        operand1 = tr.operand1;
        operand2 = tr.operand2;
        opcode = opcode_e'(tr.opcode);


    end

    $stop();
end


endmodule