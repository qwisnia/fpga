SetActiveLib -work
do "$dsn\src\aes_compile.do" 
comp -include "$dsn\src\TestBench\aes_TB.vhd" 
asim +access +r TESTBENCH_FOR_aes 
wave 
wave -noreg clk
wave -noreg n_reset
wave -noreg data_in
wave -noreg key_in
wave -noreg data_out
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\aes_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_aes 
