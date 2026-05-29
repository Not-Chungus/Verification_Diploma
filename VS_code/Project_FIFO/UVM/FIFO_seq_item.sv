package FIFO_seq_item_pkg;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class FIFO_seq_item extends uvm_sequence_item;
  `uvm_object_utils(FIFO_seq_item)

  rand logic [FIFO_WIDTH-1:0] data_in;
  rand logic rst_n, wr_en, rd_en;

  logic [FIFO_WIDTH-1:0] data_out;    
  logic wr_ack, overflow;
  logic full, empty, almostfull, almostempty, underflow;

  integer RD_EN_ON_DIST, WR_EN_ON_DIST;

  function new(string name = "FIFO_seq_item", int WR_EN_ON_DIST = 70, int RD_EN_ON_DIST = 30);
    super.new(name);

    this.WR_EN_ON_DIST = WR_EN_ON_DIST;
    this.RD_EN_ON_DIST = RD_EN_ON_DIST;
  endfunction


  function string convert2string();
    return $sformatf("%s data_in = 0b%b| rst_n = 0b%b | wr_en = 0b%b | rd_en = 0b%b | data_out = 0b%b" ,
    super.convert2string() ,data_in, rst_n, wr_en, rd_en, data_out);

  endfunction

  function string convert2string_stimulus();
    return $sformatf("rst_n = 0b%b | wr_en = 0b%b | rd_en = 0b%b | data_out = 0b%b | wr_ack = 0b%b | overflow = 0b%b | full = 0b%b | empty = 0b%b | almostfull = 0b%b | almostempty = 0b%b | underflow = 0b%b",
    rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);

  endfunction

  //Constraints=====================================================
  constraint Reset { //off for 90% of the time
      rst_n dist {1:/90 , 0:/10};
      }
  constraint Write_en { //on for 70% of the time
      wr_en dist {1:/WR_EN_ON_DIST , 0:/(100-WR_EN_ON_DIST)};
      }
  constraint Read_en { //on for 30% of the time
      rd_en dist {1:/RD_EN_ON_DIST , 0:/(100-RD_EN_ON_DIST)};
      }


endclass
endpackage