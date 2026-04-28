#vlib work
vlog -sv ../../../VS_code/Session4/Assignment4/Q4_Config_Reg/* +cover -covercells
vsim -voptargs=+acc work.config_reg_tb 
add wave *
#do wave.do          
run -all


