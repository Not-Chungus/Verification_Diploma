package enum_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum {RIGHT, LEFT} direction_e;
typedef enum {SHIFT, ROTATE} mode_e;

endpackage
/*
input clk, reset, serial_in, direction, mode;
input [5:0] datain;
output reg [5:0] dataout;*/