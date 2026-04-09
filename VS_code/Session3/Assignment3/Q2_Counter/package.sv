package class_pkg;

    class RandomControl #(parameter WIDTH = 4);;
        
        parameter MAX = {WIDTH{1'b1}};
        logic up_down;
        logic [WIDTH-1:0] count_out;
        logic [WIDTH-1:0] data_load;
        bit clk;

        rand logic rst_n, load_n, ce;
        



    //constraints===========================================
        constraint Reset { //off for 90% of the time
            rst_n dist {1:/90 , 0:/10};
            }
        constraint Load { //on for 70% of the time
            load_n dist {0:/70 , 1:/30};
            }
        constraint Enable { //on for 70% of the time
            ce dist {1:/70 , 0:/30};
            }

    //Coverpoints and bins===========================================
        
        covergroup CovPort @(posedge clk);
            Data_Load_cp: coverpoint data_load iff(rst_n && !load_n)
            {
                bins all_load_bins[] = {[0:$]};
            }

            counting_up_cp: coverpoint count_out iff(rst_n && ce && up_down)
            {
                bins all_count_up_bins[] = {[0:$]};
            }

            counting_up_of_cp: coverpoint count_out iff(rst_n && ce && up_down)
            {
                bins OF_max_to_zero = (MAX => 0);
            }

            counting_down_cp: coverpoint count_out iff(rst_n && ce && !up_down)
            {
                bins all_count_down_bins[] = {[0:$]};
            }

            counting_down_of_cp: coverpoint count_out iff(rst_n && ce && !up_down)
            {
                bins OF_zero_to_max = (0 => MAX);
            }

        endgroup

        function new();
            CovPort = new();
        endfunction

    endclass


endpackage
