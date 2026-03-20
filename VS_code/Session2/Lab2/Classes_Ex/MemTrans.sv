import pkg::*;


module testing;


    initial begin
        MemTrans mem1, mem2;

        mem1 = new(.address(4'd2));
        mem2 = new(.address(4'd4), .data_in(8'd3));

        $display("For mem1:");
        mem1.print();

        $display("For mem2:");
        mem2.print();
    end




endmodule