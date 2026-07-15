////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package FIFO_agent_pkg;
import uvm_pkg::*;
import FIFO_cfg_pkg::*;
import FIFO_seq_item_pkg::*;
import FIFO_drv_pkg::*;
import FIFO_sqr_pkg::*;
import FIFO_monitor_pkg::*;
`include "uvm_macros.svh"

//1.
class FIFO_agent extends uvm_agent;
  // Example 1 (Done for you)
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(FIFO_agent) //2.

  FIFO_config FIFO_cfg;

  FIFO_driver driver;
  FIFO_sqr sqr;
  FIFO_monitor monitor;

  uvm_analysis_port #(FIFO_seq_item) agt_ap;

  //3.
  function new(string name = "FIFO_agent", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  // Example 2
  // Build the driver in the build phase

  //4.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(FIFO_config)::get(this, "", "CFG", FIFO_cfg))   
      `uvm_fatal("build_phase", "Can't get Interface from database!!!");
    
    driver = FIFO_driver::type_id::create("driver", this);
    sqr = FIFO_sqr::type_id::create("sqr", this);
    monitor = FIFO_monitor::type_id::create("monitor", this);
    agt_ap = new("agt_ap", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    driver.FIFO_vif = FIFO_cfg.FIFO_vif;
    monitor.FIFO_vif = FIFO_cfg.FIFO_vif;

    monitor.mon_ap.connect(agt_ap);
    driver.seq_item_port.connect(sqr.seq_item_export);
  endfunction




endclass
endpackage




