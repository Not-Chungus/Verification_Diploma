package Transaction_pkg;

    class FIFO_Transaction #(parameter FIFO_WIDTH = 16);
        
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;

        logic [FIFO_WIDTH-1:0] data_out;    
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        integer RD_EN_ON_DIST, WR_EN_ON_DIST;

        function new(input WR_EN_ON_DIST = 70, input RD_EN_ON_DIST = 30);
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            
        endfunction



    //constraints===========================================
        constraint Reset { //off for 90% of the time
            rst_n dist {1:/90 , 0:/10};
            }
        constraint Write_en { //on for 70% of the time
            wr_en dist {1:/WR_EN_ON_DIST , 0:/(100-WR_EN_ON_DIST)};
            }
        constraint Read_en { //on for 30% of the time
            rd_en dist {1:/RD_EN_ON_DIST , 0:/(100-RD_EN_ON_DIST)};
            }

    endclass


endpackage
