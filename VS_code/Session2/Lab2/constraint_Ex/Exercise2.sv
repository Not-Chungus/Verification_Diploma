//v1
/*
import class_pkg::*;
module testing_rand_dist;


    initial begin
        Exercise2 memt;
        memt = new;

        repeat(20) begin
            assert(memt.randomize());
            $display("For memt:");
            memt.print();
            #10;
        end

        $stop;

    end

endmodule
*/

//v2

import class_pkg::*;
module testing_rand_dist;


    initial begin
        Exercise2 memt;
        memt = new;

        repeat(10000) begin
            assert(memt.randomize());
            memt.count();
            #10;
        end

        memt.categories_print();

        $stop;

    end

endmodule
