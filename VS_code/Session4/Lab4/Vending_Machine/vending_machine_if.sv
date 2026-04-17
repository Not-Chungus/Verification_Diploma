////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
interface vending_machine_if(clk);
// 1. Add the parameters (WAIT = 0, Q_25 = 1, Q_50 =2)
parameter WAIT = 2'b00, Q_25 = 2'b01, Q_50 =2'b10;
// 2. Add the clock as an input port
input bit clk;
// 3. Add the internal signals of the interface
logic Q_in, D_in, rstn, dispense, change;
// 4. Add the modports
modport DUT (input clk, Q_in, D_in, rstn,
            output dispense, change);

modport TEST (input clk,dispense, change,
            output  Q_in, D_in, rstn);

modport MONITOR (input clk, Q_in, D_in, rstn, dispense, change);


endinterface 