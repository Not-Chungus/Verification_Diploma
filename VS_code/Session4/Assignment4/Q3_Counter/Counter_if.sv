interface counter_if #(parameter WIDTH = 4)(clk);
// 2. Add the clock as an input port
input bit clk;
// 3. Add the internal signals of the interface
logic rst_n;
logic load_n;
logic up_down;
logic ce;
logic [WIDTH-1:0] data_load;

logic [WIDTH-1:0] count_out;
logic max_count;
logic zero;
// 4. Add the modports
modport DUT (input clk, rst_n, load_n, up_down,ce, data_load,
            output count_out, max_count,zero);

modport TEST (input clk,count_out, max_count, zero,
            output rst_n, load_n, up_down, ce, data_load);

//modport MONITOR (input clk, Q_in, D_in, rstn, dispense, change);


endinterface 