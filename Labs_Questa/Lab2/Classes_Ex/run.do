#vlib work
vlog -sv ../../../VS_code/Session2/Lab2/Classes_Ex/MemTrans.sv ../../../VS_code/Session2/Lab2/Classes_Ex/Packege.sv +cover -covercells
vsim -voptargs=+acc work.testing -cover
#add wave *
#coverage save DSP_tb.ucdb -onexit
#do wave.do          
run -all

#vcover report DSP_tb.ucdb -details -all -output code_cvr.txt