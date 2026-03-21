
package class_pkg;

    class RandomControl;
        rand logic rst_n, load_n, ce;

        constraint Reset { //off for 90% of the time
            rst_n dist {1:/90 , 0:/10};
            }
        constraint Load { //on for 70% of the time
            load_n dist {0:/70 , 1:/30};
            }
        constraint Enable { //on for 70% of the time
            ce dist {1:/70 , 0:/30};
            }

    endclass


endpackage
