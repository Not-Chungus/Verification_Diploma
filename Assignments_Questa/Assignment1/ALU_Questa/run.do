#vlib work
vlog -sv ../../../VS_code/Session1/Assignment1/ALU/ALU.v ../../../VS_code/Session1/Assignment1/ALU/ALU_tb.sv +cover -covercells
vsim -voptargs=+acc work.ALU_tb -cover
add wave *
coverage save ALU_tb.ucdb -onexit
#do wave.do          
run -all






vcover report ALU_tb.ucdb -details -all -output code_cvr.txt