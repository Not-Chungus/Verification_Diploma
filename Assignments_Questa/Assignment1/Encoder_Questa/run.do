#vlib work
vlog -sv ../../../VS_code/Session1/Assignment1/Priority_encoder/priority_enc.v ../../../VS_code/Session1/Assignment1/Priority_encoder/Priority_enc_tb.sv +cover -covercells
vsim -voptargs=+acc work.priority_enc_tb -cover
add wave *
coverage save priority_enc_tb.ucdb -onexit
#do wave.do          
run -all




vcover report priority_enc_tb.ucdb -details -all -output code_cvr.txt