#vlib work
vlog -sv ../../../VS_code/Session3/Lab3/ConstraintEx/* +cover -covercells
vsim -voptargs=+acc work.testing_screen_class -cover
#add wave *
#coverage save Counter_tb.ucdb -onexit
#do wave.do          
run -all

#vcover report Counter_tb.ucdb -details -all -output code_cvr.txt