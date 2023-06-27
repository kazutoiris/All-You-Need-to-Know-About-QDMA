create_project proj -part xcvu13p-fhgb2104-2-i -in_memory
create_ip -name qdma -vendor xilinx.com -library ip -module_name qdma_0
set_property -dict [list \
  CONFIG.SRIOV_CAP_ENABLE {true} \
  CONFIG.tl_pf_enable_reg {4} \
] [get_ips qdma_0]
open_example_project [get_ips qdma_0] -in_process -force
add_files "pcie.xdc"
synth_ip [ get_ips * ] -quiet
synth_design -quiet
place_design -quiet
route_design -quiet
write_bitstream -force qdma.bit
open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
current_hw_device [get_hw_devices xcvu13p_0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcvu13p_0] 0]
set_property PROGRAM.FILE {qdma.bit} [get_hw_devices xcvu13p_0]
program_hw_devices [get_hw_devices xcvu13p_0]
