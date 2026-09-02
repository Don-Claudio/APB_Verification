vlib work

vlog ../rtl/apb_slave.sv
vlog ../tb/apb_if.sv
vlog ../tb/apb_pkg.sv
vlog ../tb/apb_tb_top.sv

vsim -c -sv_seed random work.apb_tb_top -do "run -all; quit"
