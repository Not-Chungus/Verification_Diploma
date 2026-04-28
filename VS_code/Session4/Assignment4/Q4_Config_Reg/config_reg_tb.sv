module config_reg_tb;

typedef enum {adc0_reg, adc1_reg, temp_sensor0_reg, temp_sensor1_reg,
analog_test, digital_test, amp_gain, digital_config} address_e;

reg clk, reset, write;
reg [15:0] data_in;
address_e address;
wire [15:0] data_out;

config_reg uut (.*);

integer correct_count = 0;
integer error_count = 0;


//Arrays and initialization===============
logic [15:0] reset_assoc[string];
initial begin
  reset_assoc["adc0_reg"]          = 16'hFFFF;
  reset_assoc["adc1_reg"]          = 16'h0000;
  reset_assoc["temp_sensor0_reg"]  = 16'h0000;
  reset_assoc["temp_sensor1_reg"]  = 16'h0000;
  reset_assoc["analog_test"]       = 16'hABCD;
  reset_assoc["digital_test"]      = 16'h0000;
  reset_assoc["amp_gain"]          = 16'h0000;
  reset_assoc["digital_config"]    = 16'h0001;
end

logic [15:0] hot_ones[ ] = '{
16'h0001, 16'h0002, 16'h0004, 16'h0008,
16'h0010, 16'h0020, 16'h0040,16'h0080,
16'h0100, 16'h0200, 16'h0400, 16'h0800,
16'h1000, 16'h2000, 16'h4000, 16'h8000};


//clk========================================
initial begin
    clk = 0; 
    forever begin
        #5 clk = ~clk;
    end
end

integer i;
integer j;

initial begin
    
    $display("===================================================TestBench Start===================================================");
    write = 0; reset = 0; data_in = 16'h0000;
    
    reset_and_check_all();

    //Test series2: Hot ones writing
    write = 1;  //writing data on DUT
    @(negedge clk);
    address = address.first;
    for(i = 0 ; i < address.num ; i++) begin

        for (j = 0; j < hot_ones.size() ; j++)begin
            data_in = hot_ones[j];
            @(negedge clk);
            check_result();
        end

        address = address.next;
    end
    @(negedge clk);
    reset_and_check_all();
    @(negedge clk);
    //Test series 3: Random Writing
    write = 1;  //writing data on DUT
    @(negedge clk);
    address = address.first;
    for(i = 0 ; i < address.num ; i++) begin

        repeat(15) begin
            data_in = $random % 16'hFFFF;
            @(negedge clk);
            check_result();
        end

        address = address.next;
    end
    @(negedge clk);
    //Test series 4: All High Writing
    write = 1;  //writing data on DUT
    @(negedge clk);
    address = address.first;
    for(i = 0 ; i < address.num ; i++) begin

        repeat(1) begin
            data_in = 16'hFFFF;
            @(negedge clk);
            check_result();
        end

        address = address.next;
    end
    @(negedge clk);
    reset_and_check_all();

    $display("%t: At end of test error count is %0d and correct count = %0d", $time, error_count, correct_count);
    $display("====================================================TestBench End====================================================");
    $stop;

end



task reset_and_check_all;

    reset = 1; write = 0;
    @(negedge clk);
    reset = 0;
    address = address.first;

    for(i=0 ; i < address.num ; i++) begin
        if(data_out  === reset_assoc[address.name])
            correct_count = correct_count + 1;
        else begin
            error_count = error_count + 1;
            $display("=======Resetting ERROR===================================");
            $display("Error: write = %b" , write);
            $display("address = %s |  data_in = 0x%h" , address.name , data_in);
            $display("Expected out = 0x%h | Actual = 0x%h", reset_assoc[address.name], data_out);
            $display("Expected out = 0b%b | Actual = 0b%b", reset_assoc[address.name], data_out);
        end
        address = address.next;
        @(negedge clk);
        
    end

endtask


task check_result();
    
    if(data_out  === data_in)
        correct_count = correct_count + 1;
    else begin
        error_count = error_count + 1;

        $display("========================================================================");
        $display("Error: write = %b " , write);
        $display("address = %s |  data_in = %b" , address.name , data_in);
        $display("Expected out = 0x%h | Actual = 0x%h", data_in, data_out);
        $display("Expected out = 0b%b | Actual = 0b%b", data_in, data_out);
    end

endtask


endmodule