# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 2
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/vivado/projects/Final-CPU/Final-CPU.cache/wt [current_project]
set_property parent.project_path D:/vivado/projects/Final-CPU/Final-CPU.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo d:/vivado/projects/Final-CPU/Final-CPU.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files D:/0-Programmingformelon/RISCV/full_sort_text.coe
add_files D:/0-Programmingformelon/RISCV/full_sort_data.coe
add_files D:/0-Programmingformelon/RISCV/is_test_text.coe
add_files D:/0-Programmingformelon/RISCV/is_test_data.coe
read_verilog -library xil_defaultlib {
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/ALU.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/BALU.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/Branch_CRTL.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/CalculateUnit.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/Control.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/DATA_MOVE.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/DEBUG.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/DM_UNIT.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/DPE.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/Data_MEM.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/Debouncer.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/EX_MEM_REG.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/FAST_DIV.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/FAST_MUL.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/Forwarding_Hazard.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/ID_EX_REG.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/IF_ID_REG.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/IM_UNIT.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/Instruction_MEM.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/MEM_WB_REG.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/MUX2.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/MUX4.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/MUX8.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/MemoryMap.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/MulDiv_Unit.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/PC.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/PDU_v2.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/Pipeline_CPU.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/Pipline_CTRL.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/REG.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/REG_FILE_I.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/SEG_OUT.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/SR_MUX_CTRL.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/Signextend.v
  D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/new/topmodule.v
}
read_ip -quiet D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/ip/mult_gen_0/mult_gen_0.xci
set_property used_in_implementation false [get_files -all d:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/ip/mult_gen_0/mult_gen_0_ooc.xdc]

read_ip -quiet D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/ip/is_mem/is_mem.xci
set_property used_in_implementation false [get_files -all d:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/ip/is_mem/is_mem_ooc.xdc]

read_ip -quiet D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/ip/data_mem/data_mem.xci
set_property used_in_implementation false [get_files -all d:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/ip/data_mem/data_mem_ooc.xdc]

read_ip -quiet D:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/ip/div_gen_0/div_gen_0.xci
set_property used_in_implementation false [get_files -all d:/vivado/projects/Final-CPU/Final-CPU.srcs/sources_1/ip/div_gen_0/div_gen_0_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc D:/vivado/projects/Final-CPU/Final-CPU.srcs/constrs_1/new/constrains.xdc
set_property used_in_implementation false [get_files D:/vivado/projects/Final-CPU/Final-CPU.srcs/constrs_1/new/constrains.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top topmodule -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef topmodule.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file topmodule_utilization_synth.rpt -pb topmodule_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
