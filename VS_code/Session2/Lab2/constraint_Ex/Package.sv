package class_pkg;

    class Exercise2;
        logic [7:0] data_in;
        logic [3:0] address;

        function new (logic [3:0] address = 4'h0,logic [7:0] data_in = 8'h0);
            this.address = address;
            this.data_in = data_in;

        endfunction

        function void print();
            $display("Address: %h || Data: %h" , this.address, this.data_in);
        endfunction

    endclass








endpackage