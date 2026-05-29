onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color White /FIFO_top/f_if/clk
add wave -noupdate /FIFO_top/f_if/data_in
add wave -noupdate /FIFO_top/f_if/rst_n
add wave -noupdate /FIFO_top/f_if/wr_en
add wave -noupdate /FIFO_top/f_if/rd_en
add wave -noupdate /FIFO_top/f_if/data_out
add wave -noupdate /FIFO_top/f_if/wr_ack
add wave -noupdate /FIFO_top/f_if/overflow
add wave -noupdate /FIFO_top/f_if/full
add wave -noupdate /FIFO_top/f_if/empty
add wave -noupdate /FIFO_top/f_if/almostfull
add wave -noupdate /FIFO_top/f_if/almostempty
add wave -noupdate /FIFO_top/f_if/underflow
add wave -noupdate -expand -group {Internal signals} /FIFO_top/dut/mem
add wave -noupdate -expand -group {Internal signals} /FIFO_top/dut/wr_ptr
add wave -noupdate -expand -group {Internal signals} /FIFO_top/dut/rd_ptr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {922 ns} 0}
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
WaveRestoreZoom {890 ns} {966 ns}
