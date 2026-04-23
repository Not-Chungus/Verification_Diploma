module counter_top();
// 1. Generate the clock
bit clk;
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end
localparam WIDTH = 4;
// 2. instantiate the interface, and pass the clock
counter_if #(WIDTH) c_if(clk);
// 3. instantiate the tb, DUT, monitor, and pass the interface
counter_wrapper dut (c_if);
//vending_machine_monitor monitor (v_if);
Counter_tb #(.WIDTH(WIDTH)) tb (c_if);
// 4. bind the SVA module to the design, and pass the interface
bind counter_wrapper counter_sva counter_sva_instance (c_if);

endmodule
