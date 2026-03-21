#vlib work
vlog -sv ../../../VS_code/Session2/Assignment2/Q1_Dynamic_Array/Dynamic_array.sv +cover -covercells
vsim -voptargs=+acc work.testing_dynamic_arrays -cover
#add wave *
#coverage save DSP_tb.ucdb -onexit
#do wave.do          
run -all

#vcover report DSP_tb.ucdb -details -all -output code_cvr.txt