module FIFO_tb(FIFO_if.TEST F_if);


import shared_pkg::*;

import Transaction_pkg::*;
import Coverage_pkg::*;
import Scoreboard_pkg::*;


    FIFO_Transaction #(.FIFO_WIDTH(F_if.FIFO_WIDTH)) F_txn = new();


    initial begin
        Test_variables::error_count = 0;
        Test_variables::correct_count = 0;
        Test_variables::test_finished = 0;

        // Initialze transaction object
        F_txn.rst_n = 1;
        F_txn.wr_en = 0;
        F_txn.rd_en = 0;
        F_txn.data_in = '0;
        drive_FIFO_if_with_txn_stimulii();
        
        

        //Test Series 1: Reset
        assert_reset();


        //Test Series 2: Random Stimulii with write more probable than read
        repeat(10000) begin
            //@(negedge F_if.clk);
            #1; //wait for monitor to be done before driving the if and change it
            F_txn.RD_EN_ON_DIST = 30;
            F_txn.WR_EN_ON_DIST = 70;
            assert(F_txn.randomize()) else $fatal("Randomization failed");
            drive_FIFO_if_with_txn_stimulii();

            @(negedge F_if.clk);
            -> Test_variables::driving_done_by_tb; //trigger event for monitor

        end

        //Test Series 3: Random Stimulii with read more probable than write
        repeat(10000) begin
            //@(negedge F_if.clk);
            #1;
            F_txn.RD_EN_ON_DIST = 70;
            F_txn.WR_EN_ON_DIST = 30;
            assert(F_txn.randomize()) else $fatal("Randomization failed");
            drive_FIFO_if_with_txn_stimulii();

            @(negedge F_if.clk);
            -> Test_variables::driving_done_by_tb; //trigger event for monitor
        end


        Test_variables::test_finished = 1;

    end

    function automatic void drive_FIFO_if_with_txn_stimulii();
        F_if.rst_n = F_txn.rst_n;
        F_if.wr_en = F_txn.wr_en;
        F_if.rd_en = F_txn.rd_en;
        F_if.data_in = F_txn.data_in;

    endfunction

    task automatic assert_reset();
        F_txn.rst_n = 0;
        drive_FIFO_if_with_txn_stimulii();
        #1;
        -> Test_variables::driving_done_by_tb;
        F_txn.rst_n = 1;
        drive_FIFO_if_with_txn_stimulii();
    endtask


endmodule