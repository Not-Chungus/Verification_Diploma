#vlib work
vlog -sv -f ../../VS_code/Project_FIFO/Enviroment/src_files.list +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover
#add wave /top/ALSU_if/*
coverage save FIFO_top.ucdb -onexit
do wave.do          
run -all

vcover report FIFO_top.ucdb -details -all -output code_cvr.txt
#-sv_seed random -l sim.log   //at end of vsim

