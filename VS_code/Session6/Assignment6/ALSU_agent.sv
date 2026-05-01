////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package ALSU_agent_pkg;
import uvm_pkg::*;
import ALSU_cfg_pkg::*;
import ALSU_seq_item_pkg::*;
import ALSU_drv_pkg::*;
import ALSU_sqr_pkg::*;
import ALSU_monitor_pkg::*;
`include "uvm_macros.svh"

//1.
class ALSU_agent extends uvm_agent;
  // Example 1 (Done for you)
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(ALSU_agent) //2.

  ALSU_config ALSU_cfg;

  ALSU_driver driver;
  ALSU_sqr sqr;
  ALSU_monitor monitor;

  uvm_analysis_port #(ALSU_seq_item) agt_ap;
  uvm_analysis_port #(ALSU_seq_item) agt_ap_golden;

  //3.
  function new(string name = "ALSU_agent", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  // Example 2
  // Build the driver in the build phase

  //4.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(ALSU_config)::get(this, "", "CFG", ALSU_cfg))   
      `uvm_fatal("build_phase", "Can't get Interface from database!!!");
    
    driver = ALSU_driver::type_id::create("driver", this);
    sqr = ALSU_sqr::type_id::create("sqr", this);
    monitor = ALSU_monitor::type_id::create("monitor", this);
    agt_ap = new("agt_ap", this);
    agt_ap_golden = new("agt_ap_golden", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    driver.ALSU_vif = ALSU_cfg.ALSU_vif;
    driver.ALSU_if_golden = ALSU_cfg.ALSU_if_golden;
    monitor.ALSU_vif = ALSU_cfg.ALSU_vif;
    monitor.ALSU_if_golden = ALSU_cfg.ALSU_if_golden;

    monitor.mon_ap.connect(agt_ap);
    monitor.mon_ap_golden.connect(agt_ap_golden);
    driver.seq_item_port.connect(sqr.seq_item_export);
  endfunction




endclass
endpackage




