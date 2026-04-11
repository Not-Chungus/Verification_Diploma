#vlib work
vlog -sv ../../../VS_code/Session3/Assignment3/Q3_ALSU/* +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover
add wave *
coverage save ALSU_tb.ucdb -onexit
#do wave.do          
run -all

vcover report ALSU_tb.ucdb -details -all -output code_cvr.txt


