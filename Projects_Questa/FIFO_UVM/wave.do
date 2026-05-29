onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -itemcolor White /top/F_if/clk
add wave -noupdate /top/F_if/data_in
add wave -noupdate /top/F_if/rst_n
add wave -noupdate /top/F_if/wr_en
add wave -noupdate /top/F_if/rd_en
add wave -noupdate /top/F_if/data_out
add wave -noupdate /top/F_if/wr_ack
add wave -noupdate /top/F_if/overflow
add wave -noupdate /top/F_if/full
add wave -noupdate /top/F_if/empty
add wave -noupdate /top/F_if/almostfull
add wave -noupdate /top/F_if/almostempty
add wave -noupdate /top/F_if/underflow
add wave -noupdate -expand /top/dut/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1099 ns} 0}
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
WaveRestoreZoom {923 ns} {1210 ns}
