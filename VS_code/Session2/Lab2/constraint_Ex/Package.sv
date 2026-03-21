/*
package class_pkg;

    class Exercise2;
        rand logic [7:0] data_in;
        rand logic [3:0] address;

        constraint address_val {
            address dist {0:/10 , [1:14]:/80, 15:/10};
            }
        constraint data_val {
            data_in == 8'd5;
            }

        function new (logic [3:0] address = 4'd0,logic [7:0] data_in = 8'h0);
            this.address = address;
            this.data_in = data_in;

        endfunction

        function void print();
            $display("Address: %h || Data: %h" , this.address, this.data_in);
        endfunction

    endclass


endpackage
*/

//v2

package class_pkg;

    class Exercise2;
        rand logic [7:0] data_in;
        rand logic [3:0] address;
        
        integer category1,category2,category3;

        constraint address_val {
            address dist {0:/10 , [1:14]:/80, 15:/10};
            }
        constraint data_val {
            data_in == 8'd5;
            }

        function new (
            logic [3:0] address = 4'd0,
            logic [7:0] data_in = 8'h0,
            integer category1 = 0,
            integer category2 = 0,
            integer category3 = 0
            );
            this.address = address;
            this.data_in = data_in;
            this.category1 = category1;
            this.category2 = category2;
            this.category3 = category3;

        endfunction

        function void print();
            $display("Address: %h || Data: %h" , this.address, this.data_in);
        endfunction

        function void categories_print();
            $display("Cat1: %d | Cat2: %d | Cat3: %d" , this.category1, this.category2,this.category3);
        endfunction

        function void count();
            if(this.address == 4'd0)
                this.category1 = this.category1 + 1;
            else if(this.address > 4'd0 && this.address < 4'd15)
                this.category2 = this.category2 + 1;
            else
                this.category3 = this.category3 + 1;
        endfunction

    endclass


endpackage
