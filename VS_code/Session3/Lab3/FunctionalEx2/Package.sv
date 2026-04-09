package testing_pkg;


    typedef enum {ADD, SUB, MULT, DIV} opcode_e;
    parameter MAX = 127;
    parameter MIN = -128;
    parameter ZERO = 0;


    class Transaction;
        rand opcode_e opcode;
        rand byte operand1;
        rand byte operand2;
        bit clk;

        covergroup CovPort @(posedge clk);
            opcode_cp: coverpoint opcode
            {
                bins add_or_sub = {ADD, SUB};
                bins add_then_sub = (ADD => SUB);
                illegal_bins no_DIV = {DIV};
            }

            operand1_cp: coverpoint operand1
            {
                bins Maximum = {MAX};
                bins Minimum = {MIN};
                bins Zero = {ZERO};
                bins others = default;
            }

            large_add_sub_cp: cross operand1_cp,opcode_cp
            {
                bins max_add_sub = binsof(opcode_cp.add_or_sub) && binsof(operand1_cp.Maximum);
                bins min_add_sub = binsof(opcode_cp.add_or_sub) && binsof(operand1_cp.Minimum);
                
                option.weight = 5;
                option.cross_auto_bin_max = 0;   
            }

        endgroup

        function new();
            CovPort = new();
        endfunction

    endclass


endpackage