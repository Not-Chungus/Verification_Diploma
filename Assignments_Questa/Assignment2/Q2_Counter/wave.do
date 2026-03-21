onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Counter_tb/clk
add wave -noupdate /Counter_tb/rst_n
add wave -noupdate /Counter_tb/load_n
add wave -noupdate /Counter_tb/up_down
add wave -noupdate /Counter_tb/ce
add wave -noupdate -radix unsigned /Counter_tb/data_load
add wave -noupdate -radix unsigned /Counter_tb/count_out
add wave -noupdate /Counter_tb/max_count
add wave -noupdate /Counter_tb/zero
add wave -noupdate /Counter_tb/expected_count_out
add wave -noupdate /Counter_tb/expected_max_count
add wave -noupdate /Counter_tb/expected_zero
add wave -noupdate -radix decimal /Counter_tb/correct_count
add wave -noupdate -radix decimal /Counter_tb/error_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {47 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 87
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
WaveRestoreZoom {0 ns} {267 ns}
