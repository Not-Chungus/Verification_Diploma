package shift_reg_cfg_pkg;
import uvm_pkg::*;
//`include "uvm_macros.svh"

class shift_config extends uvm_env;
  `uvm_object_utils(shift_config)

  virtual shift_reg_if shift_vif;

  function new(string name = "shift_config");
    super.new(name,parent);
  endfunction

endclass
endpackage