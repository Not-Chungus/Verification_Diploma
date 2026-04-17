onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -subitemconfig {/vending_machine_top/v_if/clk {-color White -height 15}} /vending_machine_top/dut/vending_mc_sva_instance/Quarter_dispense_assert
add wave -noupdate /vending_machine_top/dut/vending_mc_sva_instance/Quarter_no_change_assert
add wave -noupdate /vending_machine_top/dut/vending_mc_sva_instance/Dollar_assert
add wave -noupdate /vending_machine_top/dut/cs
add wave -noupdate /vending_machine_top/dut/ns
add wave -noupdate /vending_machine_top/v_if/D_in
add wave -noupdate /vending_machine_top/v_if/change
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {223 ns} 0}
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
WaveRestoreZoom {200 ns} {379 ns}
