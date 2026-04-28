////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package shift_reg_agent_pkg;
import uvm_pkg::*;
import shift_reg_cfg_pkg::*;
import shift_reg_seq_item_pkg::*;
import shift_reg_drv_pkg::*;
import shift_reg_sqr_pkg::*;
import shift_reg_monitor_pkg::*;
`include "uvm_macros.svh"

//1.
class shift_reg_agent extends uvm_agent;
  // Example 1 (Done for you)
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(shift_reg_agent) //2.

  shift_config shift_cfg;

  shift_driver driver;
  shift_reg_sqr sqr;
  shift_monitor monitor;

  uvm_analysis_port #(shift_reg_seq_item) agt_ap;

  //3.
  function new(string name = "shift_reg_agent", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  // Example 2
  // Build the driver in the build phase

  //4.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(shift_config)::get(this, "", "CFG", shift_cfg))   
      `uvm_fatal("build_phase", "Can't get Interface from database!!!");
    
    driver = shift_driver::type_id::create("driver", this);
    sqr = shift_reg_sqr::type_id::create("sqr", this);
    monitor = shift_monitor::type_id::create("monitor", this);
    agt_ap = new("agt_ap", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    driver.shift_vif = shift_cfg.shift_vif;
    monitor.shift_vif = shift_cfg.shift_vif;

    monitor.mon_ap.connect(agt_ap);
    driver.seq_item_port.connect(sqr.seq_item_export);
  endfunction




endclass
endpackage




