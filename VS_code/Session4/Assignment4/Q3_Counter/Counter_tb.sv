import class_pkg::*;
module Counter_tb #(parameter WIDTH = 4) (counter_if.TEST c_if);


RandomControl #(.WIDTH(WIDTH)) cntrl = new();


initial begin
    if (!(WIDTH inside {4,6,8})) begin
        $error("Invalid WIDTH=%0d. Allowed values are 4, 6, or 8", WIDTH);
        $fatal;
    end
end


initial begin
    $display("===================================================TestBench Start===================================================");
    assert_reset();
    //Test Series 2: Randomization loop
    repeat(1000) begin  //take care when repeating for sequential testbenches 
        assert(cntrl.randomize());                // as we check and stimulate after 1 tick
    //use obejct's values
        c_if.rst_n = cntrl.rst_n;
        c_if.load_n = cntrl.load_n;
        c_if.data_load = cntrl.data_load;
        c_if.up_down = cntrl.up_down;
        c_if.ce = cntrl.ce;
        
        @(negedge c_if.clk);
        cntrl.count_out = c_if.count_out;
        cntrl.CovPort.sample();
        #1;
    end
    $display("====================================================TestBench End====================================================");
    $stop;

end



/*
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
*/

/*
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
*/

task assert_reset;
    //@(negedge clk)
    c_if.rst_n = 0;
    @(negedge c_if.clk);
    /*if (count_out !== 0) begin
        error_count = error_count + 1;
        $display("Error Reseting");
    end
    else
        correct_count = correct_count + 1;
    //@(negedge clk);*/
    c_if.rst_n = 1;
endtask



endmodule