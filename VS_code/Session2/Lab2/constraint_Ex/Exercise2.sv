import pkg::*;


module testing_rand_dist;


    initial begin
        Exercise2 memt1, memt2;

        mem1 = new(.address(4'd2));
        mem2 = new(.address(4'd4), .data_in(8'd3));

        $display("For mem1t:");
        memt1.print();

        $display("For mem2t:");
        memt2.print();
    end




endmodule