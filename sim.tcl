create_project -force -part  xc7s50csga324-1 ip_tb ip_tb

read_verilog -sv [ glob ./hdl/*/*.sv ]
# read_verilog  [ glob ./hdl/*/*.v ]
#read_mem [ glob ./data/*.mem ]
read_verilog -sv [ glob ./sim/*.sv ]

read_ip ./ip/fir_compiler_0/fir_compiler_0.xci
generate_target all [get_ips]
synth_ip [get_ips]

set_property top microphones_tb [get_fileset sim_1]
launch_simulation
restart
open_vcd microphones.vcd
log_vcd *
run -all
flush_vcd
close_vcd
