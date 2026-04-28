#vlib work
vlog -sv -f ../../../VS_code/Session5/Assignment5/Part_2/src_files.list 
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
#add wave /top/ALSU_if/*
do wave.do
run -all