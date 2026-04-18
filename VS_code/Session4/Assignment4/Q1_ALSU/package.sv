package class_pkg;

    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";

    typedef enum reg [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    localparam MAXPOS = 3, ZERO = 0, MAXNEG = -4;


    class RandomControl;
        rand logic rst, red_op_A, red_op_B, bypass_A, bypass_B, cin, direction, serial_in;
        rand logic [2:0] opcode;
        rand logic signed [2:0] A, B;

        bit clk;
        rand opcode_e my_opcodes[6];

    //========================================CONSTRAINTS========================================
        constraint Reset { //off for 90% of the time
            rst dist {0:/90 , 1:/10};
        }

        constraint Input { //MAXs and Zero 80% of the time for ADD and MULT
            if((opcode == ADD) | (opcode == MULT)){
                A dist {MAXPOS:=40,
                    MAXNEG:=40,
                    ZERO:=40,
                    [-3:-1], [1:2] := 15};
                B dist {MAXPOS:=40,
                    MAXNEG:=40,
                    ZERO:=40,
                    [-3:-1], [1:2] := 15}; //15/135
            }
        }
        
        constraint Bypass { //off for 90% of the time
            bypass_A dist {0:/90 , 1:/10};
            bypass_B dist {0:/90 , 1:/10};
        }

        constraint Valdity { //Invalid for 10% of the time
            opcode dist {INVALID_6:/10,INVALID_7:/10,
                        [OR:ROTATE]:/80};
            if(opcode ==  (OR | XOR)){
                red_op_A dist{0:/50 , 1:/50};  //both red high is unlikely?
                if(red_op_A){
                    red_op_B dist{0:/80 , 1:/20};
                }
            }
        }

        constraint Reduction_Operations {       //selected has one bit set (
            if(opcode inside {OR, XOR}){  //unslected has all low
                if(red_op_A){
                    A dist { 4:=80, 1:=80, 2:=80, [-3:0]:=20, 3:=20 };
                    B == 3'b000;
                }
                else if(red_op_B){
                    B dist { 4:=80, 1:=80, 2:=80, [-3:0]:=20, 3:=20 };
                    A == 3'b000;
                }
            }                  
        }

        constraint opcode_rand_array {//"constraint 8"
            unique {my_opcodes};
            foreach(my_opcodes[i]){
                my_opcodes[i] inside {[OR:ROTATE]};
            }

        }

    //========================================COVER GROUPS========================================
    covergroup CovPort; //@(posedge clk)
        cin_cp: coverpoint cin iff(0){}
        direction_cp: coverpoint direction iff(0){}
        serial_in_cp: coverpoint serial_in iff(0){}
        red_op_A_cp: coverpoint red_op_A iff(0){}
        red_op_B_cp: coverpoint red_op_B iff(0){}
        
        
        
        A_cp: coverpoint A iff(1)
        {
            bins A_data_0 = {ZERO};
            bins A_data_max = {MAXPOS};
            bins A_data_min = {MAXNEG};
            bins A_data_default = default;
            bins A_data_walkingones[] = {3'b001,3'b010,3'b100} iff(red_op_A);
        }

        B_cp: coverpoint B iff(1)
        {
            bins B_data_0 = {ZERO};
            bins B_data_max = {MAXPOS};
            bins B_data_min = {MAXNEG};
            bins B_data_default = default;
            bins B_data_walkingones[] = {3'b001,3'b010,3'b100} iff(!red_op_A && red_op_B);
        }

        ALU_cp: coverpoint opcode iff(1) 
        {
            bins Bins_shift[] = {SHIFT,ROTATE};
            bins Bins_arith[] = {ADD, MULT};
            bins Bins_bitwise[] = {OR, XOR};
            illegal_bins Bins_invalid = {INVALID_6, INVALID_7};
            bins Bins_trans = (0 => 0 => 1 => 1 => 2 => 2 => 3 => 3 => 4 => 4 => 5 => 5);
            //the transition sequence is like this as we wait two cycles before changing
            //opcode in the testbench
        }
        //================Cross Coverage=====================
        
        //1.
        cross ALU_cp,A_cp{
            
            bins Arith_corners_A_1 = binsof(ALU_cp.Bins_arith) && 
                                    binsof(A_cp.A_data_0);
            bins Arith_corners_A_2 = binsof(ALU_cp.Bins_arith) && 
                                    binsof(A_cp.A_data_max);
            bins Arith_corners_A_3 = binsof(ALU_cp.Bins_arith) && 
                                    binsof(A_cp.A_data_min);
            option.cross_auto_bin_max = 0;
        }

        cross ALU_cp,B_cp{   
            bins Arith_corners_B_1 = binsof(ALU_cp.Bins_arith) && 
                                    binsof(B_cp.B_data_0);
            bins Arith_corners_B_2 = binsof(ALU_cp.Bins_arith) && 
                                    binsof(B_cp.B_data_max);
            bins Arith_corners_B_3 = binsof(ALU_cp.Bins_arith) && 
                                    binsof(B_cp.B_data_min);
            option.cross_auto_bin_max = 0;
        }

        //2.
        cross ALU_cp,cin_cp{
            bins Add_cin = binsof(ALU_cp.Bins_arith[0]) && 
                                    binsof(cin_cp);
            option.cross_auto_bin_max = 0;
        }

        //3.
        cross ALU_cp,direction_cp{
            bins Shifts_direction = binsof(ALU_cp.Bins_shift) && 
                                    binsof(direction_cp);
            option.cross_auto_bin_max = 0;
        }
        //4.
        cross ALU_cp,serial_in_cp{
            bins Shift_Sin = binsof(ALU_cp.Bins_shift[0]) && 
                                    binsof(serial_in_cp);
            option.cross_auto_bin_max = 0;
        }
        //5.
        cross ALU_cp,A_cp,red_op_A_cp,serial_in_cp
        {
            bins bitwise_red_A = binsof(ALU_cp.Bins_bitwise) && 
                                    binsof(serial_in_cp) && binsof(red_op_A_cp) intersect{1};
            option.cross_auto_bin_max = 0;
        }
        //6.
        cross ALU_cp,B_cp,red_op_B_cp,serial_in_cp
        {
            bins bitwise_red_B = binsof(ALU_cp.Bins_bitwise) && 
                                    binsof(serial_in_cp) && binsof(red_op_B_cp) intersect{1};
            option.cross_auto_bin_max = 0;
        }
        //7.
        cross ALU_cp,red_op_A_cp,red_op_B_cp
        {
            ignore_bins red_at_no_bitwise = binsof(ALU_cp.Bins_bitwise) && 
                                            binsof(red_op_A_cp) intersect{0} && 
                                            binsof(red_op_B_cp) intersect{0};
            //option.cross_auto_bin_max = 0;
        }



    endgroup






    function new();
        CovPort = new;
    endfunction


    endclass


endpackage
