puts "\033\[32mCreate project...\033\[0m"
create_project -part xcvu13p-fhgb2104-2-i -in_memory -quiet
create_ip -name qdma -vendor xilinx.com -library ip -module_name qdma_0 -quiet
set_property -dict [list \
  CONFIG.SRIOV_CAP_ENABLE {true} \
  CONFIG.tl_pf_enable_reg {4} \
] [get_ips qdma_0] -quiet
puts "\033\[32mOpen example project...\033\[0m"
open_example_project [get_ips qdma_0] -in_process -force -quiet
add_files "constraint.xdc" -quiet
add_files "pcie.xdc" -quiet
puts "\033\[32mSynth & place & route & write bitstream...\033\[0m"
synth_ip [ get_ips * ] -quiet
synth_design -quiet
place_design -quiet
route_design -quiet
write_bitstream qdma.bit -force -quiet
puts "\033\[32mProgram...\033\[0m"
open_hw_manager -quiet
connect_hw_server -allow_non_jtag -quiet
open_hw_target -quiet
current_hw_device [get_hw_devices xcvu13p_0] -quiet
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcvu13p_0] 0] -quiet
set_property PROGRAM.FILE {qdma.bit} [get_hw_devices xcvu13p_0] -quiet
program_hw_devices [get_hw_devices xcvu13p_0] -quiet
puts "\033\[32mFinish!\033\[0m"
exit
