# setting up the project
set script_dir [file dirname [info script]]
set rtl_dir    ${script_dir}/rtl
set lib_dir    ${script_dir}/../lib
set bd_dir     ${script_dir}/bd
set constr_dir ${script_dir}/constr
set data_dir   ${script_dir}/data

# update files generated by other rules
# mk.tcl in board directories will pass the $brd variable to this file
exec >@stdout 2>@stderr make -C $script_dir BOARD=$brd


# Set IP repository paths
set obj [get_filesets sources_1]
set_property "ip_repo_paths" "[file normalize "${lib_dir}/dmi"]" $obj
# Rebuild user ip_repo's index before adding any source files
update_ip_catalog -rebuild

# lib src files
add_files -norecurse -fileset sources_1 "[file normalize "${lib_dir}/include/axi.vh"]"
add_files -norecurse -fileset sources_1 "[file normalize "${lib_dir}/include/dmi.vh"]"
set_property is_global_include true [get_files "[file normalize "${lib_dir}/include/axi.vh"]"]
set_property is_global_include true [get_files "[file normalize "${lib_dir}/include/dmi.vh"]"]

# Add files for rocketchip
add_files -norecurse -fileset sources_1 "[file normalize "${rtl_dir}/rocket/rocketchip_board_${brd}.v"]"
add_files -norecurse -fileset sources_1 "[file normalize "${rtl_dir}/rocket/rocketchip_top.v"]"

# Block Designs
source ${bd_dir}/pardcore.tcl
save_bd_design
close_bd_design $design_name
set_property synth_checkpoint_mode Hierarchical [get_files *${design_name}.bd]
