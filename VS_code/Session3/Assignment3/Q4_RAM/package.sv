package class_pkg;

    class RandomControl;
        logic [15:0] addresses_array[];  //dynamic to store random addresses
        logic [7:0] data_to_write_array[]; //corresponding data to write
        rand logic [15:0] random_address;
        rand logic [7:0] random_data_to_write;

        
        logic [7:0] data_read_expect_assoc[int]; //expected read (8 bits)
        logic [7:0] data_read_queue[$];  //actual read (8 bits)

        bit clk;

    //========================================CONSTRAINTS========================================


    //========================================COVER GROUPS========================================


    endclass


endpackage
