#vlib work
vlog -sv ../../../VS_code/Session4/Assignment4/Q3_Counter/* +cover -covercells
vsim -voptargs=+acc work.counter_top -cover
#add wave *
coverage save counter_top.ucdb -onexit
do wave.do          
run -all

vcover report counter_top.ucdb -details -all -output code_cvr.txt
#-sv_seed random -l sim.log   //at end of vsim

