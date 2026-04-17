#vlib work
vlog -sv ../../../VS_code/Session3/Assignment3/Q4_RAM/* +cover -covercells
vsim -voptargs=+acc work.RAM_tb -cover
#add wave *
coverage save RAM_tb.ucdb -onexit
do wave.do          
run -all

vcover report RAM_tb.ucdb -details -all -output code_cvr.txt


