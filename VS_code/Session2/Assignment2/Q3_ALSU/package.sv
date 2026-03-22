package class_pkg;

    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";

    typedef enum reg [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    localparam MAXPOS = 3, ZERO = 0, MAXNEG = -4;


    class RandomControl;
        rand logic rst,red_op_A, red_op_B, bypass_A, bypass_B, cin, direction, serial_in;
        rand logic [2:0] opcode;
        rand logic signed [2:0] A, B;

        constraint Reset { //off for 90% of the time
            rst dist {0:/90 , 1:/10};
        }

        constraint Inputs { //MAXs and Zero 80% of the time for ADD and MULT
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

        constraint Reduction_Operations {       //selected has one bit set 
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

    endclass


endpackage
