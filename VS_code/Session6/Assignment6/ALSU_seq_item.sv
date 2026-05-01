package ALSU_seq_item_pkg;
import enum_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALSU_seq_item extends uvm_sequence_item;
  `uvm_object_utils(ALSU_seq_item)

  rand logic rst, red_op_A, red_op_B, bypass_A, bypass_B, cin, direction, serial_in;
  rand opcode_e opcode;
  rand logic signed [2:0] A, B;

  logic [15:0] leds;
  logic signed [5:0] out;

  rand opcode_e my_opcodes[6]; 

  function new(string name = "ALSU_seq_item");
    super.new(name);
  endfunction


  function string convert2string();
    return $sformatf("%s\n rst = %b| red_op_A = %b | red_op_B = %b | bypass_A = %b | bypass_B = %b \n cin = %b | direction = %b | serial_in = %b \n opcode = %s | A = 0b%b (%d) | B = 0b%b (%d) \n out = 0b%b (%d) | leds = 0x%h" ,
    super.convert2string() ,rst, red_op_A, red_op_B, bypass_A, bypass_B, cin, direction, serial_in, opcode.name, A, $signed(A), B, $signed(B), out ,out, leds);

  endfunction

  function string convert2string_stimulus();
    return $sformatf("%s\n rst = %b| red_op_A = %b | red_op_B = %b | bypass_A = %b | bypass_B = %b \n cin = %b | direction = %b | serial_in = %b \n opcode = %s | A = 0b%b (%d) | B = 0b%b (%d)" ,
    super.convert2string(), rst, red_op_A, red_op_B, bypass_A, bypass_B, cin, direction, serial_in, opcode.name, A, $signed(A), B, $signed(B));

  endfunction

  //Constraints=====================================================
  constraint Reset { //off for 90% of the time
      rst dist {0:/90 , 1:/10};
  }

  constraint Input { //MAXs and Zero 80% of the time for ADD and MULT
      if((opcode == ADD) || (opcode == MULT)){
          A dist {MAXPOS:=40,
              MAXNEG:=40,
              ZERO:=40,
              [-3:-1], [1:2] := 15};
          B dist {MAXPOS:=40,
              MAXNEG:=40,
              ZERO:=40,
              [-3:-1], [1:2] := 15}; //15/135
      }
  }
  
  constraint Bypass { //off for 90% of the time
      bypass_A dist {0:/90 , 1:/10};
      bypass_B dist {0:/90 , 1:/10};
  }

  constraint Valdity { //Invalid for 10% of the time
      opcode dist {INVALID_6:/10,INVALID_7:/10,
                  [OR:ROTATE]:/80};
      if(opcode inside {OR, XOR}){
          red_op_A dist{0:/50 , 1:/50};  //both red high is unlikely?
          if(red_op_A){
              red_op_B dist{0:/80 , 1:/20};
          }
      }
  }

  constraint Reduction_Operations {       //selected has one bit set (
      if(opcode inside {OR, XOR}){  //unslected has all low
          if(red_op_A){
              A dist { 4:=80, 1:=80, 2:=80, [-3:0]:=20, 3:=20 };
              B == 3'b000;
          }
          else if(red_op_B){
              B dist { 4:=80, 1:=80, 2:=80, [-3:0]:=20, 3:=20 };
              A == 3'b000;
          }
      }                  
  }

  constraint opcode_rand_array {//"constraint 8"
      unique {my_opcodes};
      foreach(my_opcodes[i]){
          my_opcodes[i] inside {[OR:ROTATE]};
      }

  }


endclass
endpackage
/*
input clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input [2:0] opcode;
input signed [2:0] A, B;

output reg [15:0] leds;
output reg signed [5:0] out;
*/