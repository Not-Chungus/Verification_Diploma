onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ALSU_tb/clk
add wave -noupdate /ALSU_tb/cin
add wave -noupdate /ALSU_tb/rst
add wave -noupdate /ALSU_tb/red_op_A
add wave -noupdate /ALSU_tb/red_op_B
add wave -noupdate /ALSU_tb/bypass_A
add wave -noupdate /ALSU_tb/bypass_B
add wave -noupdate /ALSU_tb/direction
add wave -noupdate /ALSU_tb/serial_in
add wave -noupdate /ALSU_tb/opcode
add wave -noupdate /ALSU_tb/A
add wave -noupdate /ALSU_tb/B
add wave -noupdate /ALSU_tb/leds
add wave -noupdate /ALSU_tb/out
add wave -noupdate /ALSU_tb/expected_out
add wave -noupdate /ALSU_tb/expected_leds
add wave -noupdate /ALSU_tb/correct_count
add wave -noupdate /ALSU_tb/error_count
add wave -noupdate /ALSU_tb/cntrl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {211 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {2308 ns}
