#vlib work
vlog -sv ../../../VS_code/Session2/Lab2/constraint_Ex/Exercise2.sv ../../../VS_code/Session2/Lab2/constraint_Ex/Package.sv +cover -covercells
vsim -voptargs=+acc work.testing_rand_dist -cover
#add wave *
#coverage save DSP_tb.ucdb -onexit
#do wave.do          
run -all

#vcover report DSP_tb.ucdb -details -all -output code_cvr.txt