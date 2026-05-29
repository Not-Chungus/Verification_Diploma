package Coverage_pkg;

import Transaction_pkg::*;


    class FIFO_Coverage #(parameter FIFO_WIDTH = 16);
        
        FIFO_Transaction #(.FIFO_WIDTH(FIFO_WIDTH)) F_cvg_txn;



    //Coverpoints and bins===========================================
        covergroup CovPort; //@(posedge clk)
        rst_cp: coverpoint F_cvg_txn.rst_n iff(1){}
        wr_en_cp: coverpoint F_cvg_txn.wr_en iff(1){}
        rd_en_cp: coverpoint F_cvg_txn.rd_en iff(1){}

        wr_ack_cp: coverpoint F_cvg_txn.wr_ack iff(1){}
        OF_cp: coverpoint F_cvg_txn.overflow iff(1){}
        UF_cp: coverpoint F_cvg_txn.underflow iff(1){}
        Full_cp: coverpoint F_cvg_txn.full iff(1){}
        Empty_cp: coverpoint F_cvg_txn.empty iff(1){}
        almost_full_cp: coverpoint F_cvg_txn.almostfull iff(1){}
        almost_empty_cp: coverpoint F_cvg_txn.almostempty iff(1){}

        
        //================Cross Coverage=====================
        
        //1.
        wr_rd_wr_ack: cross wr_en_cp, rd_en_cp, wr_ack_cp {
        ignore_bins impossible =
            binsof(wr_en_cp) intersect {0} &&
            binsof(wr_ack_cp) intersect {1};
}

        //2.
        wr_rd_OF: cross wr_en_cp, rd_en_cp, OF_cp {
        ignore_bins impossible =
            (binsof(wr_en_cp) intersect {0} &&
             binsof(OF_cp)    intersect {1})
            ||
            (binsof(wr_en_cp) intersect {1} &&
             binsof(rd_en_cp) intersect {1} &&
             binsof(OF_cp)    intersect {1});}

        //3.
        wr_rd_UF: cross wr_en_cp, rd_en_cp, UF_cp {
        ignore_bins impossible =
            (binsof(rd_en_cp) intersect {0} &&
             binsof(UF_cp)    intersect {1})
            ||
            (binsof(wr_en_cp) intersect {1} &&
             binsof(rd_en_cp) intersect {1} &&
             binsof(UF_cp)    intersect {1});}

        //4.
        wr_rd_Full: cross wr_en_cp, rd_en_cp, Full_cp {
        ignore_bins impossible =
            binsof(rd_en_cp) intersect {1} &&
            binsof(Full_cp)  intersect {1};
        }

        //5.
        wr_rd_Empty: cross wr_en_cp,rd_en_cp,Empty_cp{}

        //6.
        wr_rd_almost_full: cross wr_en_cp,rd_en_cp,almost_full_cp{}

        //7.
        wr_rd_almost_empty: cross wr_en_cp,rd_en_cp,almost_empty_cp{}
         
        endgroup


        function void sample_data(input FIFO_Transaction #(.FIFO_WIDTH(FIFO_WIDTH)) F_txn);
            F_cvg_txn = F_txn;
            CovPort.sample();

        endfunction

        
        function new();
            CovPort = new();
            F_cvg_txn = new();
        endfunction

    endclass


endpackage
