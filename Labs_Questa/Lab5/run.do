#vlib work
vlog -sv -f ../../VS_code/Session5/Lab5/src_files.list 
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
#add wave /top/shift_if/*
do wave.do
run -all