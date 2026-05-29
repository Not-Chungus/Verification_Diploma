module FIFO_top();
// 1. Generate the clock
bit clk;
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// 2. instantiate the interface, and pass the clock
FIFO_if f_if(clk);

// 3. instantiate the tb, DUT, monitor, and pass the interface
FIFO dut (f_if);

FIFO_tb tb (f_if);

FIFO_monitor monitor (f_if);

endmodule
