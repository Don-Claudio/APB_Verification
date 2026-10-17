vlib work

vlog -cover bcst ../rtl/apb_slave.sv
vlog -cover bcst ../tb/apb_if.sv
vlog -cover bcst ../tb/apb_pkg.sv
vlog -cover bcst ../tb/apb_tb_top.sv

vsim -c -sv_seed random -coverage work.apb_tb_top -do "run -all; coverage report -cvg -details; quit"
