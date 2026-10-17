" Vim syntax file
" Language: Synopsys Design Constraints (SDC) / Xilinx Design Constraints (XDC) / UPF
" Maintainer: IC EDA Tools
" Latest Revision: 2026

if exists("b:current_syntax")
  finish
endif

" Inherit standard Tcl syntax
runtime! syntax/tcl.vim
unlet! b:current_syntax

" SDC Clock Commands
syn keyword sdcClock create_clock create_generated_clock set_clock_latency
syn keyword sdcClock set_clock_uncertainty set_clock_transition set_clock_groups
syn keyword sdcClock set_propagated_clock set_clock_sense

" SDC I/O & Environment Commands
syn keyword sdcIO set_input_delay set_output_delay set_input_transition
syn keyword sdcIO set_driving_cell set_drive set_load set_fanout_load
syn keyword sdcIO set_port_fanout_number set_wire_load_model set_wire_load_mode
syn keyword sdcIO set_operating_conditions set_min_library

" SDC Timing Exceptions
syn keyword sdcException set_false_path set_multicycle_path set_max_delay
syn keyword sdcException set_min_delay set_disable_timing set_case_analysis
syn keyword sdcException set_data_check

" SDC DRC / Limits
syn keyword sdcDRC set_max_transition set_max_capacitance set_max_fanout
syn keyword sdcDRC set_min_capacitance set_max_area set_max_dynamic_power
syn keyword sdcDRC set_max_leakage_power

" SDC Object Query & Collections
syn keyword sdcCollection get_ports get_pins get_cells get_nets get_clocks
syn keyword sdcCollection get_lib_cells get_lib_pins get_designs get_libs
syn keyword sdcCollection all_inputs all_outputs all_clocks all_registers
syn keyword sdcCollection current_design current_instance
syn keyword sdcCollection sizeof_collection add_to_collection remove_from_collection
syn keyword sdcCollection index_collection copy_collection foreach_in_collection
syn keyword sdcCollection filter_collection sort_collection query_objects

" Xilinx XDC / Physical Constraints Extensions
syn keyword sdcXDC set_property get_property reset_property create_pblock
syn keyword sdcXDC add_cells_to_pblock resize_pblock set_package_pin

" UPF (Unified Power Format) Low Power Extensions
syn keyword sdcUPF create_power_domain create_supply_port create_supply_net
syn keyword sdcUPF connect_supply_net set_domain_supply_net create_power_switch
syn keyword sdcUPF set_isolation set_retention set_level_shifter map_power_switch

" SDC / EDA Switches & Options (e.g. -from, -to, -through, -clock, -group)
syn match sdcOption display '\s\zs-\(from\|to\|through\|rise_from\|fall_from\|rise_to\|fall_to\|rise_through\|fall_through\|clock\|rise_clock\|fall_clock\|group\|asynchronous\|physically_exclusive\|logically_exclusive\|period\|waveform\|name\|add\|source\|master_clock\|divide_by\|multiply_by\|duty_cycle\|invert\|early\|late\|rise\|fall\|max\|min\|setup\|hold\|clock_fall\|reference_pin\|include_latency\|hierarchical\|quiet\|filter\|of_objects\)\>'

" Highlight Linking
hi def link sdcClock        Statement
hi def link sdcIO           Function
hi def link sdcException    Keyword
hi def link sdcDRC          Type
hi def link sdcCollection   PreProc
hi def link sdcXDC          Special
hi def link sdcUPF          SpecialComment
hi def link sdcOption       Identifier

let b:current_syntax = "sdc"
