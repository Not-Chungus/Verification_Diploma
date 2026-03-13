#vlib work
vlog -sv ../../VS_code/Session1/Lab1/adder.v ../../VS_code/Session1/Lab1/adder__tb.sv +cover -covercells
vsim -voptargs=+acc work.adder_tb -cover
add wave *
coverage save adder_tb.ucdb -onexit          
run -all




#vcover report adder_tb.ucdb -details -annotate -all -output code_cvr.txt