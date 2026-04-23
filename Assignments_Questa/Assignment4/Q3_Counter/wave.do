onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /counter_top/clk
add wave -noupdate -expand /counter_top/dut/counter_sva_instance/a_Load
add wave -noupdate /counter_top/dut/counter_sva_instance/a_no_Load
add wave -noupdate /counter_top/dut/counter_sva_instance/a_counting_up
add wave -noupdate /counter_top/dut/counter_sva_instance/a_counting_down
add wave -noupdate /counter_top/dut/counter_sva_instance/a_max
add wave -noupdate /counter_top/dut/counter_sva_instance/a_zero
add wave -noupdate /counter_top/dut/counter_sva_instance/a_reset
add wave -noupdate /counter_top/tb/#ublk#94953570#20/immed__21
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9092 ns} 0}
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
WaveRestoreZoom {9061 ns} {10061 ns}
