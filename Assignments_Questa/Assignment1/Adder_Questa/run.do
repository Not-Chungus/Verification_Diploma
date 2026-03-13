#vlib work
vlog -sv ../../../VS_code/Session1/Assignment1/Adder/adder.v ../../../VS_code/Session1/Assignment1/Adder/adder__tb.sv +cover -covercells
vsim -voptargs=+acc work.adder_tb -cover
add wave *
coverage save adder_tb.ucdb -onexit -du a1
do wave.do          
run -all




vcover report adder_tb.ucdb -details -all -output code_cvr.txt