SetActiveLib -work
comp -include "$dsn\src\KeySchedule.vhd" 
comp -include "$dsn\src\TestBench\keyschedule_TB.vhd" 
asim +access +r TESTBENCH_FOR_keyschedule 
wave 
wave -noreg clk
wave -noreg n_reset
wave -noreg key_in
wave -noreg rcon_in
wave -noreg key_out
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\keyschedule_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_keyschedule 
