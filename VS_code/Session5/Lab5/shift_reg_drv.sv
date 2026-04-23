package shift_reg_drv_pkg;
import uvm_pkg::*;
import shift_reg_cfg_pkg::*;
`include "uvm_macros.svh"


class shift_driver extends uvm_driver;
  `uvm_component_utils(shift_driver)

  shift_config shift_cfg;
  virtual shift_reg_if shift_vif;
  

  function new(string name = "shift_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(shift_config)::get(this, "", "CFG", shift_cfg)) begin
      `uvm_fatal("build_phase", "Unable to get configuration object")
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    shift_vif = shift_cfg.shift_vif;
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    shift_vif.datain = 0;
    shift_vif.mode = 0;
    shift_vif.direction = 0;
    shift_vif.serial_in = 0;
    shift_vif.reset = 1;

    @(negedge shift_vif.clk);
    shift_vif.reset = 0;

    repeat(20) begin
      @(negedge shift_vif.clk);
      shift_vif.datain = $random;
      shift_vif.mode = $random;
      shift_vif.direction = $random;
      shift_vif.serial_in = $random;
    end
  endtask

endclass
endpackage