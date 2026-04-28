////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package ALSU_env_pkg;
import uvm_pkg::*;
import ALSU_drv_pkg::*;
`include "uvm_macros.svh"

//1.
class ALSU_env extends uvm_env;
  `uvm_component_utils(ALSU_env) //2.


  ALSU_driver driver;

  //3.
  function new(string name = "shift_reg_env", uvm_component parent = null);
    super.new(name,parent);
  endfunction


  //4.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = ALSU_driver::type_id::create("driver", this);

  endfunction
  



endclass
endpackage




