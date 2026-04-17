vlib work
vlog -sv ../../../VS_code/Session4/Lab4/Vending_Machine/* +cover -covercells
vsim -voptargs=+acc vending_machine_top -cover
#add wave *
coverage save vending_machine_top.ucdb -onexit
do wave.do
run -all

vcover report RAM_tb.ucdb -details -all -output code_cvr.txt
#-sv_seed random -l sim.log   //at end of vsim