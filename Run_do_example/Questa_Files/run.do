#vlib work

vlog ../Do_File_Demo_code/N_bit_HalfAdder.v ../Do_File_Demo_code/N_bit_ALU.v ../Do_File_Demo_code/N_bit_ALU_tb.v

vsim -voptargs=+acc work.N_bit_ALU_tb
add wave *
do wave.do
run -all
#quit -sim