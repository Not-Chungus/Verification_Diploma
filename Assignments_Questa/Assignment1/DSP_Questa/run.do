#vlib work
vlog -sv ../../../VS_code/Session1/Assignment1/DSP/DSP.v ../../../VS_code/Session1/Assignment1/DSP/DSP_tb.sv +cover -covercells
vsim -voptargs=+acc work.DSP_tb -cover
add wave *
coverage save DSP_tb.ucdb -onexit
#do wave.do          
run -all

vcover report DSP_tb.ucdb -details -all -output code_cvr.txt