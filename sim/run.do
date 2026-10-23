expr {srand([clock microseconds])}
set seed [expr {int(rand() * 2147483647)}]

file mkdir sim/logs
set f [open sim/logs/seeds.txt a]
puts $f "$seed [clock format [clock seconds] -format {%Y-%m-%d %H:%M:%S}]"
close $f


vlib work

vlog -cover bcst ../rtl/apb_slave.sv
vlog -cover bcst ../tb/apb_if.sv
vlog -cover bcst ../tb/apb_pkg.sv
vlog -cover bcst ../tb/apb_tb_top.sv

vsim -c -l sim/logs/run_$seed.log -sv_seed $seed -coverage work.apb_tb_top -do "run -all; coverage report -cvg -details; quit"
