#vlib work
vlog -sv ../../../VS_code/Session2/Assignment2/Q2_Counter/* +cover -covercells
vsim -voptargs=+acc work.Counter_tb -cover
add wave *
coverage save Counter_tb.ucdb -onexit
do wave.do          
run -all

vcover report Counter_tb.ucdb -details -all -output code_cvr.txt