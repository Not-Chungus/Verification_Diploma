
package class_pkg;

    enum logic [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcodes_e;
    localparam MAXPOS = 3, ZERO = 0, MAXNEG = -4;


    class RandomControl;
        rand logic rst,red_op_A, red_op_B,bypass_A, bypass_B;
        rand logic [2:0] opcode;
        rand logic signed [2:0] A, B;

        constraint Reset { //off for 90% of the time
            rst dist {0:/90 , 1:/10};
        }

        constraint Inputs { //MAXs and Zero 80% of the time
            A dist {MAXPOS:=40,
                    MAXNEG:=40,
                    ZERO:=40,
                    [-3:-1], [1:2] := 15};
            B dist {MAXPOS:=40,
                    MAXNEG:=40,
                    ZERO:=40,
                    [-3:-1], [1:2] := 15}; //15/135
        }
        
        constraint Bypass { //off for 90% of the time
            bypass_A dist {0:/90 , 1:/10};
            bypass_B dist {0:/90 , 1:/10};
        }

        constraint Valdity { //Valid for 80% of the time
            opcode dist {INVALID_6:/10,INVALID_7:/10,
                        [OR:ROTATE]:/80};
            if(opcode == OR || opcode == XOR){
                red_op_A dist{0:/50 , 1:/50};  //both red high is unlikely?
                if(red_op_A){
                    red_op_B dist{0:/80 , 1:/20};
                }
            }
        }

        constraint Reduction_Operations {       //selected has one bit set 
            if(opcode == OR || opcode == XOR){  //unslected has all low
                if(red_op_A && INPUT_PRIORITY = "A")
            }                  
        }

    endclass


endpackage
