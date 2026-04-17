onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RAM_tb/clk
add wave -noupdate /RAM_tb/write
add wave -noupdate /RAM_tb/read
add wave -noupdate /RAM_tb/address
add wave -noupdate /RAM_tb/data_in
add wave -noupdate /RAM_tb/data_out
add wave -noupdate -expand /RAM_tb/cntrl
add wave -noupdate -group {New Group} /RAM_tb/correct_count
add wave -noupdate -group {New Group} /RAM_tb/error_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25 ns} 0}
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
WaveRestoreZoom {0 ns} {266 ns}
