module ALSU_sva #(
    parameter string INPUT_PRIORITY = "A",
    parameter string FULL_ADDER     = "ON"
)(
    ALSU_if ALSU_if
);

  default clocking cb @(posedge ALSU_if.clk); endclocking

  // =========================
  // Reset checks
  // =========================
  property p_reset_out_zero;
    @(posedge ALSU_if.clk)
      ALSU_if.rst |-> (ALSU_if.out === 6'sd0);
  endproperty

  property p_reset_leds_zero;
    @(posedge ALSU_if.clk)
      ALSU_if.rst |-> (ALSU_if.leds === 16'h0000);
  endproperty

  // =========================
  // Bypass checks
  // =========================
  property p_bypass_A_and_B_priority_A;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      $past(ALSU_if.bypass_A,2) && $past(ALSU_if.bypass_B,2) &&
      (INPUT_PRIORITY == "A")
      |-> (ALSU_if.out === {{3{$past(ALSU_if.A[2],2)}}, $past(ALSU_if.A,2)});
  endproperty

  property p_bypass_A_and_B_priority_B;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      $past(ALSU_if.bypass_A,2) && $past(ALSU_if.bypass_B,2) &&
      (INPUT_PRIORITY == "B")
      |-> (ALSU_if.out === {{3{$past(ALSU_if.B[2],2)}}, $past(ALSU_if.B,2)});
  endproperty

  property p_bypass_A_only;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      $past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2)
      |-> (ALSU_if.out === {{3{$past(ALSU_if.A[2],2)}}, $past(ALSU_if.A,2)});
  endproperty

  property p_bypass_B_only;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && $past(ALSU_if.bypass_B,2)
      |-> (ALSU_if.out === {{3{$past(ALSU_if.B[2],2)}}, $past(ALSU_if.B,2)});
  endproperty

  // =========================
  // Invalid cases
  // =========================
  property p_invalid_out_zero;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      (
        (($past(ALSU_if.red_op_A,2) || $past(ALSU_if.red_op_B,2)) &&
         ($past(ALSU_if.opcode[1],2) || $past(ALSU_if.opcode[2],2)))
        ||
        ($past(ALSU_if.opcode[1],2) && $past(ALSU_if.opcode[2],2))
      )
      |-> (ALSU_if.out === 6'sd0);
  endproperty

  property p_invalid_leds_toggle;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      (
        (($past(ALSU_if.red_op_A,2) || $past(ALSU_if.red_op_B,2)) &&
         ($past(ALSU_if.opcode[1],2) || $past(ALSU_if.opcode[2],2)))
        ||
        ($past(ALSU_if.opcode[1],2) && $past(ALSU_if.opcode[2],2))
      )
      |-> (ALSU_if.leds === ~$past(ALSU_if.leds,1));
  endproperty

  property p_valid_leds_zero;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !(
        (($past(ALSU_if.red_op_A,2) || $past(ALSU_if.red_op_B,2)) &&
         ($past(ALSU_if.opcode[1],2) || $past(ALSU_if.opcode[2],2)))
        ||
        ($past(ALSU_if.opcode[1],2) && $past(ALSU_if.opcode[2],2))
      )
      |-> (ALSU_if.leds === 16'h0000);
  endproperty

  // =========================
  // OR operation
  // =========================
  property p_or_redA_redB_priority_A;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h0) &&
      $past(ALSU_if.red_op_A,2) && $past(ALSU_if.red_op_B,2) &&
      (INPUT_PRIORITY == "A")
      |-> (ALSU_if.out === $signed({5'b0, |$past(ALSU_if.A,2)}));
  endproperty

  property p_or_redA_redB_priority_B;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h0) &&
      $past(ALSU_if.red_op_A,2) && $past(ALSU_if.red_op_B,2) &&
      (INPUT_PRIORITY == "B")
      |-> (ALSU_if.out === $signed({5'b0, |$past(ALSU_if.B,2)}));
  endproperty

  property p_or_redA_only;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h0) &&
      $past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2)
      |-> (ALSU_if.out === $signed({5'b0, |$past(ALSU_if.A,2)}));
  endproperty

  property p_or_redB_only;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h0) &&
      !$past(ALSU_if.red_op_A,2) && $past(ALSU_if.red_op_B,2)
      |-> (ALSU_if.out === $signed({5'b0, |$past(ALSU_if.B,2)}));
  endproperty

  property p_or_normal;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h0) &&
      !$past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2)
      |-> (ALSU_if.out ===
            {{3{($past(ALSU_if.A[2],2) | $past(ALSU_if.B[2],2))}},
             ($past(ALSU_if.A,2) | $past(ALSU_if.B,2))});
  endproperty

  // =========================
  // XOR operation
  // =========================
  property p_xor_redA_redB_priority_A;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h1) &&
      $past(ALSU_if.red_op_A,2) && $past(ALSU_if.red_op_B,2) &&
      (INPUT_PRIORITY == "A")
      |-> (ALSU_if.out === $signed({5'b0, ^$past(ALSU_if.A,2)}));
  endproperty

  property p_xor_redA_redB_priority_B;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h1) &&
      $past(ALSU_if.red_op_A,2) && $past(ALSU_if.red_op_B,2) &&
      (INPUT_PRIORITY == "B")
      |-> (ALSU_if.out === $signed({5'b0, ^$past(ALSU_if.B,2)}));
  endproperty

  property p_xor_redA_only;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h1) &&
      $past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2)
      |-> (ALSU_if.out === $signed({5'b0, ^$past(ALSU_if.A,2)}));
  endproperty

  property p_xor_redB_only;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h1) &&
      !$past(ALSU_if.red_op_A,2) && $past(ALSU_if.red_op_B,2)
      |-> (ALSU_if.out === $signed({5'b0, ^$past(ALSU_if.B,2)}));
  endproperty

  property p_xor_normal;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h1) &&
      !$past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2)
      |-> (ALSU_if.out ===
            {{3{($past(ALSU_if.A[2],2) ^ $past(ALSU_if.B[2],2))}},
             ($past(ALSU_if.A,2) ^ $past(ALSU_if.B,2))});
  endproperty

  // =========================
  // ADD
  // =========================
  property p_add_full_adder_on;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      !$past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h2) &&
      (FULL_ADDER == "ON")
      |-> (ALSU_if.out ===
            ($signed($past(ALSU_if.A,2)) +
             $signed($past(ALSU_if.B,2)) +
             {5'b0, $past(ALSU_if.cin,2)}));
  endproperty

  property p_add_full_adder_off;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      !$past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h2) &&
      (FULL_ADDER != "ON")
      |-> (ALSU_if.out ===
            ($signed({{3{$past(ALSU_if.A[2],2)}}, $past(ALSU_if.A,2)}) +
             $signed({{3{$past(ALSU_if.B[2],2)}}, $past(ALSU_if.B,2)})));
  endproperty

  // =========================
  // MULT
  // =========================
  property p_mult;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      !$past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h3)
      |-> (ALSU_if.out === ($past(ALSU_if.A,2) * $past(ALSU_if.B,2)));
  endproperty

  // =========================
  // SHIFT
  // =========================
  property p_shift_left;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      !$past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h4) &&
      $past(ALSU_if.direction,2)
      |-> (ALSU_if.out === {$past(ALSU_if.out[4:0],1), $past(ALSU_if.serial_in,2)});
  endproperty

  property p_shift_right;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      !$past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h4) &&
      !$past(ALSU_if.direction,2)
      |-> (ALSU_if.out === {$past(ALSU_if.serial_in,2), $past(ALSU_if.out[5:1],1)});
  endproperty

  // =========================
  // ROTATE
  // =========================
  property p_rotate_left;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      !$past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h5) &&
      $past(ALSU_if.direction,2)
      |-> (ALSU_if.out === {$past(ALSU_if.out[4:0],1), $past(ALSU_if.out[5],1)});
  endproperty

  property p_rotate_right;
    @(posedge ALSU_if.clk)
      disable iff (ALSU_if.rst)
      !$past(ALSU_if.rst,1) && !$past(ALSU_if.rst,2) &&
      !$past(ALSU_if.bypass_A,2) && !$past(ALSU_if.bypass_B,2) &&
      !$past(ALSU_if.red_op_A,2) && !$past(ALSU_if.red_op_B,2) &&
      ($past(ALSU_if.opcode,2) == 3'h5) &&
      !$past(ALSU_if.direction,2)
      |-> (ALSU_if.out === {$past(ALSU_if.out[0],1), $past(ALSU_if.out[5:1],1)});
  endproperty

  assert property (p_reset_out_zero)            else $error("RESET out failed");
  assert property (p_reset_leds_zero)           else $error("RESET leds failed");

  assert property (p_bypass_A_and_B_priority_A) else $error("Bypass A&B priority A failed");
  assert property (p_bypass_A_and_B_priority_B) else $error("Bypass A&B priority B failed");
  assert property (p_bypass_A_only)             else $error("Bypass A failed");
  assert property (p_bypass_B_only)             else $error("Bypass B failed");

  assert property (p_invalid_out_zero)          else $error("Invalid out failed");
  assert property (p_invalid_leds_toggle)       else $error("Invalid leds toggle failed");
  assert property (p_valid_leds_zero)           else $error("Valid leds zero failed");

  assert property (p_or_redA_redB_priority_A)   else $error("OR reduction A priority failed");
  assert property (p_or_redA_redB_priority_B)   else $error("OR reduction B priority failed");
  assert property (p_or_redA_only)              else $error("OR red_op_A failed");
  assert property (p_or_redB_only)              else $error("OR red_op_B failed");
  assert property (p_or_normal)                 else $error("OR normal failed");

  assert property (p_xor_redA_redB_priority_A)  else $error("XOR reduction A priority failed");
  assert property (p_xor_redA_redB_priority_B)  else $error("XOR reduction B priority failed");
  assert property (p_xor_redA_only)             else $error("XOR red_op_A failed");
  assert property (p_xor_redB_only)             else $error("XOR red_op_B failed");
  assert property (p_xor_normal)                else $error("XOR normal failed");

  assert property (p_add_full_adder_on)         else $error("ADD full adder ON failed");
  assert property (p_add_full_adder_off)        else $error("ADD full adder OFF failed");
  assert property (p_mult)                      else $error("MULT failed");

  assert property (p_shift_left)                else $error("SHIFT left failed");
  assert property (p_shift_right)               else $error("SHIFT right failed");
  assert property (p_rotate_left)               else $error("ROTATE left failed");
  assert property (p_rotate_right)              else $error("ROTATE right failed");

endmodule