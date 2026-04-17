import class_pkg::*;
module RAM_tb;

localparam TESTS = 100;


reg clk, write, read;
reg [7:0] data_in;
reg [15:0] address;
wire [7:0] data_out;

my_mem uut (.*);

integer correct_count = 0;
integer error_count = 0;

//Class and Objects
RandomControl cntrl = new();

//clk========================================
initial begin
    clk = 0; 
    forever begin
        #5 clk = ~clk;
        cntrl.clk = clk;
    end
end

integer i;

initial begin
    
    $display("===================================================TestBench Start===================================================");

    stimulus_gen(); //stimulii are generated
    golden_model(); //golden model expected calculated

    write = 1; read = 0;   //writing data on DUT
   
    for(i = 0 ; i < TESTS ; i++) begin
        @(negedge clk);
        address = cntrl.addresses_array[i];
        data_in = cntrl.data_to_write_array[i];

    end
    @(negedge clk); //wait for last write


    write = 0; read = 1;              //reading from DUT    

    for(i = 0 ; i < TESTS ; i++) begin 
        address = cntrl.addresses_array[i];
        @(negedge clk);
        check9Bits();
        cntrl.data_read_queue[i] = data_out; //saving DUT memory
    end

    $display("--------- Final Data Read Queue Contents --------"); //Completion and Reporting
    
    //check if elements remain in the queue
    while (cntrl.data_read_queue.size() > 0) begin
        logic [7:0] temp_data;
        temp_data = cntrl.data_read_queue.pop_front(); 
        
        $display("Popped Data: %h", temp_data);
    end
    

    $display("%t: At end of test error count is %0d and correct count = %0d", $time, error_count, correct_count);
    $display("====================================================TestBench End====================================================");
    $stop;

end

task stimulus_gen;

    cntrl.addresses_array = new[TESTS];
    cntrl.data_to_write_array = new[TESTS];
    //integer i;
    for(i=0 ; i < TESTS ; i++) begin
        assert(cntrl.randomize());
        cntrl.addresses_array[i] = cntrl.random_address;
        cntrl.data_to_write_array[i] = cntrl.random_data_to_write;
    end

endtask


task golden_model;

    //integer i;
    for(i=0 ; i < TESTS ; i++) begin  //loop to populate the expected read data assoc
        cntrl.data_read_expect_assoc[cntrl.addresses_array[i]] = cntrl.data_to_write_array[i];
        //copying the data write exactly is golden behaviour
    end

endtask


task check9Bits ();

    if(data_out  === cntrl.data_read_expect_assoc[address])
    correct_count = correct_count + 1;
    else
    error_count = error_count + 1;
   
    if (data_out  !== cntrl.data_read_expect_assoc[address]) begin
        $display("========================================================================");
        $display("Error: write = %b | read = %b" , write, read);
        $display("address = %b |  data_in = %b" , address , data_in);
        $display("Expected out = %d | Actual = %d", cntrl.data_read_expect_assoc[address], data_out);
    end

endtask


endmodule