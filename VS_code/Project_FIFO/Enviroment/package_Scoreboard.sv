package Scoreboard_pkg;

import Transaction_pkg::*;
import shared_pkg::*;

    class FIFO_Scoreboard #(parameter FIFO_WIDTH = 16, parameter FIFO_DEPTH = 8);//need to override with if.FIFO_Width when calling
        

        logic [FIFO_WIDTH-1:0] data_out_ref;
        FIFO_Transaction #(.FIFO_WIDTH(FIFO_WIDTH)) full_ref;

        logic [FIFO_WIDTH-1:0] fifo_mem_q[$];



        function automatic void check_data(input FIFO_Transaction #(.FIFO_WIDTH(FIFO_WIDTH)) F_txn);
            
            full_ref = new();
            reference_model(F_txn);


            if(something_is_wrong(F_txn)) begin
                Test_variables::error_count ++;
                $display({$sformatf("Error @ %0t: \n", $time),
                $sformatf("Stimulii: wr_en=%b, rd_en=%b, data_in=0x%0h, rst_n=%b\n", F_txn.wr_en, F_txn.rd_en, F_txn.data_in, F_txn.rst_n),
                $sformatf("Expected: data_out=0x%0h | full=%b | empty=%b | wr_ack=%b | overflow=%b | underflow=%b | almostfull=%b | almostempty=%b\n", data_out_ref, full_ref.full, full_ref.empty, full_ref.wr_ack, full_ref.overflow, full_ref.underflow, full_ref.almostfull, full_ref.almostempty),
                $sformatf("Actual:   data_out=0x%0h | full=%b | empty=%b | wr_ack=%b | overflow=%b | underflow=%b | almostfull=%b | almostempty=%b\n", F_txn.data_out, F_txn.full, F_txn.empty, F_txn.wr_ack, F_txn.overflow, F_txn.underflow, F_txn.almostfull, F_txn.almostempty),
                $sformatf("================================================================================")}
                );


            end else begin
                Test_variables::correct_count ++;
            end

        endfunction


        function automatic void reference_model(input FIFO_Transaction #(.FIFO_WIDTH(FIFO_WIDTH)) F_txn);
            // Default pulse-like sequential outputs every cycle
            full_ref.wr_ack     = 0;
            full_ref.overflow   = 0;
            full_ref.underflow  = 0;

            if (!F_txn.rst_n) begin
                fifo_mem_q.delete();
                data_out_ref         = {FIFO_WIDTH{1'b0}};

                full_ref.full        = 0;
                full_ref.empty       = 1;
                full_ref.almostfull  = 0;
                full_ref.almostempty = 0;
                full_ref.wr_ack      = 0;
                full_ref.overflow    = 0;
                full_ref.underflow   = 0;

                full_ref.data_out =  data_out_ref;
            end
            else begin
                // Operation handling
                // -------------------------
                case ({F_txn.wr_en, F_txn.rd_en})

                    2'b10: begin
                        // Write only
                        if (fifo_mem_q.size() < FIFO_DEPTH) begin
                            fifo_mem_q.push_back(F_txn.data_in);
                            full_ref.wr_ack = 1;
                        end
                        else begin
                            full_ref.overflow = 1;
                        end
                    end

                    2'b01: begin
                        // Read only
                        if (fifo_mem_q.size() > 0) begin
                            data_out_ref = fifo_mem_q.pop_front();
                        end
                        else begin
                            full_ref.underflow = 1;
                        end
                    end

                    2'b11: begin
                        // Both write and read enabled
                        if (fifo_mem_q.size() == 0) begin
                            // Spec note: when empty, only writing takes place
                            fifo_mem_q.push_back(F_txn.data_in);
                            full_ref.wr_ack = 1;
                        end
                        else if (fifo_mem_q.size() == FIFO_DEPTH) begin
                            // Spec note: when full, only reading takes place
                            data_out_ref = fifo_mem_q.pop_front();
                        end
                        else begin
                            // Normal simultaneous read + write
                            data_out_ref = fifo_mem_q.pop_front();
                            fifo_mem_q.push_back(F_txn.data_in);
                            full_ref.wr_ack = 1;
                        end
                    end

                    default: begin
                        // No operation
                    end

                endcase

                // -------------------------
                // Combinational flag generation from resulting occupancy
                // -------------------------
                full_ref.full        = (fifo_mem_q.size() == FIFO_DEPTH);
                full_ref.empty       = (fifo_mem_q.size() == 0);
                full_ref.almostfull  = (fifo_mem_q.size() == FIFO_DEPTH-1);
                full_ref.almostempty = (fifo_mem_q.size() == 1);

                // Optional if your transaction object has data_out
                full_ref.data_out    = data_out_ref;
            end

        endfunction

        

        function new();
            full_ref = new();
            data_out_ref = {FIFO_WIDTH{1'b0}};
        endfunction


        function automatic bit something_is_wrong(input FIFO_Transaction #(.FIFO_WIDTH(FIFO_WIDTH)) F_txn);
            return (
            F_txn.wr_ack      !== full_ref.wr_ack     ||
            F_txn.overflow    !== full_ref.overflow   ||
            F_txn.full        !== full_ref.full       ||
            F_txn.empty       !== full_ref.empty      ||
            F_txn.underflow   !== full_ref.underflow  ||
            F_txn.almostfull  !== full_ref.almostfull ||
            F_txn.almostempty !== full_ref.almostempty||
            F_txn.data_out    !== data_out_ref
            );
        endfunction

    endclass



endpackage
