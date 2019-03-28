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
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.cache/wt [current_project]
set_property parent.project_path C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_cache_permissions disable [current_project]
read_verilog -library xil_defaultlib {
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/imports/new/VOICE_CAPTURER.v
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/imports/new/VGA_DISPLAY.v
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/imports/new/Draw_Waveform.v
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/imports/new/Draw_Background.v
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/imports/new/Voice_Scope_TOP.v
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/new/clk_div.v
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/new/TestWave_Gen.v
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/new/Volume_Indicator.v
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/new/seven_seg_display.v
}
read_vhdl -library xil_defaultlib {
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/imports/new/VGA_CONTROL.vhd
  C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/sources_1/imports/new/CLK_108M.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/constrs_1/imports/new/Basys3_Master.xdc
set_property used_in_implementation false [get_files C:/Users/patwa/Desktop/EE2026_Project/Audio_Viz_Project_Template/Audio_Viz_Project_Template.srcs/constrs_1/imports/new/Basys3_Master.xdc]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top Voice_Scope_TOP -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Voice_Scope_TOP.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Voice_Scope_TOP_utilization_synth.rpt -pb Voice_Scope_TOP_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
