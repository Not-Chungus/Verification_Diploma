import class_pkg::*;
module Counter_tb;


parameter WIDTH = 4;
reg clk;
reg rst_n;
reg load_n;
reg up_down;
reg ce;
reg [WIDTH-1:0] data_load;

wire [WIDTH-1:0] count_out;
wire max_count;
wire zero;
reg [WIDTH-1:0] expected_count_out;
reg expected_max_count;
reg expected_zero;

counter #(.WIDTH(WIDTH)) uut (.*);

initial begin
    if (!(WIDTH inside {4,6,8})) begin
        $error("Invalid WIDTH=%0d. Allowed values are 4, 6, or 8.", WIDTH);
        $fatal;
    end
end

integer correct_count = 0;
integer error_count = 0;

initial begin
    clk = 0; 
    forever
        #5 clk = ~clk;
end


initial begin
    RandomControl cntrl;
    cntrl = new;
    correct_count = 0; error_count = 0;
    expected_count_out = 0; expected_max_count = 0; expected_zero = 1;
    $display("===================================================TestBench Start===================================================");


    //Test Series 1: Assert reset
    assert_reset();

    //Test Series 2: Randomization loop
    repeat(1000) begin  //take care when repeating for sequential testbenches 
        assert(cntrl.randomize());                // as we check and stimulate after 1 tick
    //use obejct's values
        rst_n = cntrl.rst_n;
        load_n = cntrl.load_n;
        ce = cntrl.ce;
    //fill other inputs
        up_down = $random;
        data_load = $random;
        

        compute_expected(); //Golden model

        @(negedge clk);  //cant check at negedge, why???
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
   
    if ((count_out  !== expected_count_out) ||
        (max_count  !== expected_max_count) ||
        (zero       !== expected_zero)) begin
        error_count = error_count + 1;
        $display("========================================================================");
        $display("Error: rst_n = %b | load_n = %b | ce = %b | up_down = %b" , rst_n, load_n, ce,up_down);
        $display("Data Load = %d" , data_load);
        $display("Expected count = %d | Actual = %d", expected_count_out, count_out);
        $display("Expected max = %b | Actual = %b  || Expected zero = %b | Actual = %b ", expected_max_count, max_count, expected_zero, zero);
    end
    else
        correct_count = correct_count + 1;
endtask



task compute_expected; //Golden Model
    if (!rst_n)
        expected_count_out = {WIDTH{1'b0}};
    else if (!load_n)
        expected_count_out = data_load;
    else if (ce) begin
        if (up_down)
            expected_count_out = expected_count_out + 1'b1;
        else
            expected_count_out = expected_count_out - 1'b1;
    end
    else
        expected_count_out = expected_count_out; // hold value
    
    expected_max_count = (expected_count_out == {WIDTH{1'b1}});
    expected_zero      = (expected_count_out == {WIDTH{1'b0}});
    
endtask


task assert_reset;
    @(negedge clk)
    rst_n = 0;
    @(negedge clk);
    if (count_out !== 0) begin
        error_count = error_count + 1;
        $display("Error Reseting");
    end
    else
        correct_count = correct_count + 1;
    @(negedge clk);
    rst_n = 1;
endtask



endmodule