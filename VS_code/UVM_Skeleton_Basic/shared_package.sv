package shared_pkg;

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;


    class Test_variables;
        static integer correct_count = 0;
        static integer error_count = 0;
        static bit test_finished = 0;

        static event driving_done_by_tb;
        static event dut_is_done;
    endclass

endpackage



