#vlib work
vlog -sv -f ../../VS_code/Session6/Assignment6/src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
#add wave /top/ALSU_if/*
coverage save work.ucdb -onexit
do wave.do
run -all

vcover report work.ucdb -details -all -output code_cvr.txt