package ALSU_drv_pkg;
import uvm_pkg::*;
import ALSU_cfg_pkg::*;
`include "uvm_macros.svh"


class ALSU_driver extends uvm_driver;
  `uvm_component_utils(ALSU_driver)

  ALSU_config ALSU_cfg;
  virtual ALSU_if ALSU_vif;
  

  function new(string name = "ALSU_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(ALSU_config)::get(this, "", "CFG", ALSU_cfg)) begin
      `uvm_fatal("build_phase", "Unable to get configuration object")
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ALSU_vif = ALSU_cfg.ALSU_vif;
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    //@(negedge ALSU_vif.clk);
    
    ALSU_vif.cin = 0;
    ALSU_vif.rst = 1;
    ALSU_vif.red_op_A = 0;
    ALSU_vif.red_op_B = 0;
    ALSU_vif.bypass_A = 0;
    ALSU_vif.bypass_B = 0;
    ALSU_vif.direction = 0;
    ALSU_vif.serial_in = 0;
    ALSU_vif.opcode = 0;
    ALSU_vif.A = 0;
    ALSU_vif.B = 0;


    @(negedge ALSU_vif.clk);
    ALSU_vif.rst = 0;

    forever begin
      @(negedge ALSU_vif.clk);
      ALSU_vif.cin = $random;
      ALSU_vif.rst = $random;
      ALSU_vif.red_op_A = $random;
      ALSU_vif.red_op_B = $random;
      ALSU_vif.bypass_A = $random;
      ALSU_vif.bypass_B = $random;
      ALSU_vif.direction = $random;
      ALSU_vif.serial_in = $random;
      ALSU_vif.opcode = $random;
      ALSU_vif.A = $random;
      ALSU_vif.B = $random;
    end
  endtask

endclass
endpackage