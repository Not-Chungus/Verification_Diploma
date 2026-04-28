onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/ALSUif/clk
add wave -noupdate /top/ALSUif/cin
add wave -noupdate /top/ALSUif/rst
add wave -noupdate /top/ALSUif/red_op_A
add wave -noupdate /top/ALSUif/red_op_B
add wave -noupdate /top/ALSUif/bypass_A
add wave -noupdate /top/ALSUif/bypass_B
add wave -noupdate /top/ALSUif/direction
add wave -noupdate /top/ALSUif/serial_in
add wave -noupdate /top/ALSUif/opcode
add wave -noupdate /top/ALSUif/A
add wave -noupdate /top/ALSUif/B
add wave -noupdate /top/ALSUif/leds
add wave -noupdate /top/ALSUif/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {228 ns} 0}
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
WaveRestoreZoom {0 ns} {1 us}
