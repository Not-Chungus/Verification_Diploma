

module FIFO_monitor(FIFO_if.MONITOR F_if);

import shared_pkg::*;

import Transaction_pkg::*;
import Coverage_pkg::*;
import Scoreboard_pkg::*;


    FIFO_Transaction #(.FIFO_WIDTH(F_if.FIFO_WIDTH)) F_txn = new();
    FIFO_Coverage #(.FIFO_WIDTH(F_if.FIFO_WIDTH)) F_cov = new();
    FIFO_Scoreboard #(.FIFO_WIDTH(F_if.FIFO_WIDTH) 
    ,.FIFO_DEPTH(F_if.FIFO_DEPTH)) F_sb = new();


    initial begin
        forever begin
            if(Test_variables::test_finished) begin
                $display("Simulation finished with %0d errors and %0d correct ", Test_variables::error_count, Test_variables::correct_count);
                $stop;
            end

            @(Test_variables::driving_done_by_tb); //wait for event triggered by TB after driving stimulii
            assign_stimulii_FIFO_if_to_txn();

            assign_response_FIFO_if_to_txn();
            fork
                begin //Thread 1: Coverage collection
                    F_cov.sample_data(F_txn);
                end

                begin //Thread 2: Scoreboard checking
                    F_sb.check_data(F_txn);
                end

            join //wait for both threads

        end

    end


    function void assign_stimulii_FIFO_if_to_txn();
        F_txn.rst_n = F_if.rst_n;
        F_txn.wr_en = F_if.wr_en;
        F_txn.rd_en = F_if.rd_en;
        F_txn.data_in = F_if.data_in;

    endfunction


    function void assign_response_FIFO_if_to_txn();
        F_txn.data_out = F_if.data_out;
        F_txn.wr_ack = F_if.wr_ack;
        F_txn.overflow = F_if.overflow;
        F_txn.underflow = F_if.underflow;
        F_txn.full = F_if.full;
        F_txn.empty = F_if.empty;
        F_txn.almostfull = F_if.almostfull;
        F_txn.almostempty = F_if.almostempty;
    endfunction

endmodule