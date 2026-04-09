#vlib work
vlog -sv ../../../VS_code/Session3/Assignment3/Q1_ALU/* +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save ALU_tb.ucdb -onexit
#do wave.do          
run -all

vcover report ALU_tb.ucdb -details -all -output code_cvr.txt


