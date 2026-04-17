////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_monitor(vending_machine_if.MONITOR v_if);
// 1. Add the modport above
// 2. Add the monitor statement in an initial block
    initial begin
        $monitor("clk = %b | rstn = %b | Din = %b | Qin = %b  ||| Dispense = %b | Change = %b",v_if.clk , v_if.rstn,v_if.D_in, v_if.Q_in, v_if.dispense, v_if.change);

    end

endmodule