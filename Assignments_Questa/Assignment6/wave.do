onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/ALSU_if/clk
add wave -noupdate /top/ALSU_if/cin
add wave -noupdate /top/ALSU_if/rst
add wave -noupdate /top/ALSU_if/red_op_A
add wave -noupdate /top/ALSU_if/red_op_B
add wave -noupdate /top/ALSU_if/bypass_A
add wave -noupdate /top/ALSU_if/bypass_B
add wave -noupdate /top/ALSU_if/direction
add wave -noupdate /top/ALSU_if/serial_in
add wave -noupdate /top/ALSU_if/opcode
add wave -noupdate -radix decimal /top/ALSU_if/A
add wave -noupdate -radix decimal /top/ALSU_if/B
add wave -noupdate /top/ALSU_if/leds
add wave -noupdate -radix decimal /top/ALSU_if/out
add wave -noupdate /top/dut/dut/invalid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {108240 ns} 0}
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
WaveRestoreZoom {108164 ns} {108283 ns}
