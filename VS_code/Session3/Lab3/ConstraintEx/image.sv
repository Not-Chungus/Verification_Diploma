import my_pkg::*;
module testing_screen_class;


    initial begin
        screen screen_obj;
        screen_obj = new;

        assert(screen_obj.randomize());

        screen_obj.print_screen();

        $stop;

    end

endmodule