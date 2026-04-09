package my_pkg;

    parameter HEIGHT = 10;
    parameter WIDTH = 20;
    parameter PERCENT_WHITE = 20;

    typedef enum bit {BLACK, WHITE} colors_t;


    class screen;
        rand colors_t Grid_arr [HEIGHT][WIDTH];

        constraint colors_c {
            foreach (Grid_arr[i,j]){ //curly in constraint blocks
                Grid_arr[i][j] dist {WHITE:=PERCENT_WHITE , BLACK:=(100-PERCENT_WHITE)};
            }
            }

        function void print_screen();
            foreach (Grid_arr[i]) begin //and begin in functions fsr
                foreach (Grid_arr[,j]) begin
                    $write("|%s", this.Grid_arr[i][j].name());
                end
                $display("|");
            end
        endfunction

    endclass


endpackage