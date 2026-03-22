onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 25 -expand -group Control /ALSU_tb/cin
add wave -noupdate -height 25 -expand -group Control /ALSU_tb/rst
add wave -noupdate -height 25 -expand -group Control /ALSU_tb/red_op_B
add wave -noupdate -height 25 -expand -group Control /ALSU_tb/bypass_A
add wave -noupdate -height 25 -expand -group Control /ALSU_tb/red_op_A
add wave -noupdate -height 25 -expand -group Control /ALSU_tb/bypass_B
add wave -noupdate -height 25 -expand -group Control /ALSU_tb/direction
add wave -noupdate -height 25 -expand -group Control /ALSU_tb/serial_in
add wave -noupdate -color Goldenrod /ALSU_tb/opcode
add wave -noupdate -color White /ALSU_tb/clk
add wave -noupdate -height 25 -expand -group Inputs -color Yellow -radix binary /ALSU_tb/A
add wave -noupdate -height 25 -expand -group Inputs -color Yellow -radix binary /ALSU_tb/B
add wave -noupdate -height 25 -expand -group Ouputs -color Blue /ALSU_tb/leds
add wave -noupdate -height 25 -expand -group Ouputs -color Blue -radix binary /ALSU_tb/out
add wave -noupdate /ALSU_tb/expected_out
add wave -noupdate /ALSU_tb/expected_leds
add wave -noupdate -radix decimal /ALSU_tb/correct_count
add wave -noupdate -radix decimal /ALSU_tb/error_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7568 ns} 0}
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
WaveRestoreZoom {7543 ns} {7784 ns}
