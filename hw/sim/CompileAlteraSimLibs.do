#DO NOT USE WITH MODELSIM-ALTERA VERSION OR MODELSIM-ALTERA Web Edition
#This file contains the commands to create libraries and compile the library file into those libraries.

# 1)  Make sure to set quartus_sim_lib variable to c:/altera/VER_NUMBER/quartus/eda/sim_lib
#  set quartus_sim_lib C:/intelFPGA/16.1/quartus/eda/sim_lib
#  set libs             ./libs
#  set vrl_lib_path     ./libs/vrl
#  set vhd_lib_path     ./libs/vhd

# 2)  To compile basic Altera libraries: do ./vhdl_library-setup.tcl 
#       Example: do ./vhdl_library-setup.tcl

#                    do CompileAlteraSimLibs.do clean"
#                    do CompileAlteraSimLibs.do altera_vrl
#                    do CompileAlteraSimLibs.do altera_vhd
#                    do CompileAlteraSimLibs.do cycloneive
#                    do CompileAlteraSimLibs.do cyclonev"

# 3)  To compile basic Altera and Device Specific Libraries: do ./vhdl_library-setup.tcl device_name
#       Example: do ./vhdl_library-setup.tcl stratixv
#       Example: do ./vhdl_library-setup.tcl cyclonev

set vhdFileName_vhdLibName {
  {altera_syn_attributes.vhd          altera                    }
  {altera_standard_functions.vhd      altera                    }
  {alt_dspbuilder_package.vhd         altera                    }
  {altera_europa_support_lib.vhd      altera                    }
  {altera_primitives_components.vhd   altera                    }
  {altera_primitives.vhd              altera                    }
  {220pack.vhd                        lpm                       }
  {220model.vhd                       lpm                       }
  {sgate_pack.vhd                     sgate                     }
  {sgate.vhd                          sgate                     }
  {altera_mf_components.vhd           altera_mf                 }
  {altera_mf.vhd                      altera_mf                 }
  {altera_lnsim_components.vhd        altera_lnsim              }
  {alt_dspbuilder_package.vhd         alt_dspbuilder            }
  {altera_europa_support_lib.vhd      altera_europa_support_lib } }



set verFileName_libName {
  {altera_primitives.v                altera_ver       }
  {220model.v                         lpm_ver          }
  {sgate.v                            sgate_ver        }
  {altera_mf.v                        altera_mf_ver    }
  {altera_lnsim.sv                    altera_lnsim_ver }     
  {mentor/altera_lnsim_for_vhdl.sv    altera_lnsim     } } 
  
  
set cycloneive_vhdFileName_libName {
  {cycloneive_atoms.vhd               cycloneive}
  {cycloneive_components.vhd          cycloneive} }  

  
  
set cycloneV_vhdFileName_libName {
  {cyclonev_atoms.vhd                 cyclonev}
  {cyclonev_components.vhd            cyclonev}
  {cyclonev_hssi_components.vhd       cyclonev}
  {cyclonev_hssi_atoms.vhd            cyclonev} }



proc pause {{message "Hit Enter to continue..."}} {
    puts -nonewline $message
    flush stdout
    gets stdin }

	
proc clean_lib {lib_path} {
    puts "Checking if $lib_path directory already exists; remove if exists"
    if { [file exists "$lib_path"] == 1 } { 
	  puts "$lib_path exists; removing directory: $lib_path  "
	  file delete -force "$lib_path" }
    puts "Checking if $lib_path is missing; make $lib_path if missing."
    if { [file exists "$lib_path"] == 0 } { 
      puts "$lib_path is missing; making $lib_path directory..."
      file mkdir $lib_path } }



proc compile_vhdl_lib {sim_path_to_vhd_lib quartus_path_to_vhd_files libName_quartusFile} {
  set path_to_vhd_lib $sim_path_to_vhd_lib
  set path_to_vhd_files $quartus_path_to_vhd_files

  foreach elem $libName_quartusFile {
    #puts "$elem" 
	set vhd_altera_basic_lib [lindex $elem 0]
	set vhd_lib_name [lindex $elem 1]
    puts "+++++++++++++ Starting to compile $vhd_altera_basic_lib to $vhd_lib_name +++++++++++++"
	vlib $path_to_vhd_lib/$vhd_lib_name
    vmap $vhd_lib_name $path_to_vhd_lib/$vhd_lib_name
    vcom -work $path_to_vhd_lib/$vhd_lib_name -2002 $path_to_vhd_files/$vhd_altera_basic_lib
    puts "xxxxxxxxxxxxx Done compiling $vhd_altera_basic_lib to $vhd_lib_name xxxxxxxxxxxxx" 
  } 
}


proc compile_vrl_lib {sim_path_to_vrl_lib quartus_path_to_vrl_files libName_quartusFile} {
  set path_to_vrl_lib $sim_path_to_vrl_lib
  set path_to_vrl_files $quartus_path_to_vrl_files

  foreach elem $libName_quartusFile {
    #puts "$elem" 
	set vrl_altera_basic_lib [lindex $elem 0]
	set vrl_lib_name [lindex $elem 1]
    puts "+++++++++++++ Starting to compile $vrl_altera_basic_lib to $vrl_lib_name +++++++++++++"
	vlib $path_to_vrl_lib/$vrl_lib_name
    vmap $vrl_lib_name $path_to_vrl_lib/$vrl_lib_name
    vlog -work $path_to_vrl_lib/$vrl_lib_name ${path_to_vrl_files}/$vrl_altera_basic_lib
    puts "xxxxxxxxxxxxx Done compiling $vrl_altera_basic_lib to $vrl_lib_name xxxxxxxxxxxxx" 
  } 
}


proc test_proc {sim_path_to_vrl_lib quartus_path_to_vrl_files libName_quartusFile} {
  set path_to_vrl_lib $sim_path_to_vrl_lib
  set path_to_vrl_files $quartus_path_to_vrl_files

  foreach elem $libName_quartusFile {
    #puts "$elem" 
	set vrl_altera_basic_lib [lindex $elem 0]
	set vrl_lib_name [lindex $elem 1]
    puts "+++++++++++++ Starting to compile $vrl_altera_basic_lib to $vrl_lib_name +++++++++++++"
	vlib $path_to_vrl_lib/$vrl_lib_name
    vmap $vrl_lib_name $path_to_vrl_lib/$vrl_lib_name
    vlog -work $path_to_vrl_lib/$vrl_lib_name ${path_to_vrl_files}/$vrl_altera_basic_lib
    puts "xxxxxxxxxxxxx Done compiling $vrl_altera_basic_lib to $vrl_lib_name xxxxxxxxxxxxx" 
  } 
}
	

# pause	

# Clean All Current Libraries:
if {$argc > 0} {
  if { $1 == "clean" } {
    clean_lib $libs
	clean_lib $vrl_lib_path
	clean_lib $vhd_lib_path } }

# pause
  
# ALTERA VHDL Libraries:
if {$argc > 0} {
  if { $1 == "altera_vhd" } { 
    compile_vhdl_lib $vhd_lib_path $quartus_sim_lib $vhdFileName_vhdLibName } }

# pause

# ALTERA Verilog Libraries:
if {$argc > 0} {
  if { $1 == "altera_vrl" } {
	puts "verilog"
    compile_vrl_lib $vrl_lib_path $quartus_sim_lib $verFileName_libName	
  } 
}
	
# pause

# CYCLONE-IVe Libraries:
if {$argc > 0} {
  if { $1 == "cycloneive" } {
    compile_vhdl_lib $vhd_lib_path $quartus_sim_lib $cycloneive_vhdFileName_libName	
  } 
}

# pause

# CYCLONE-V Libraries:
if {$argc > 0} {
  if { $1 == "cyclonev" } {
    compile_vhdl_lib $vhd_lib_path $quartus_sim_lib $cycloneV_vhdFileName_libName 
  } 
}

# TEST YOU SCRIPTS HERE:
if {$argc > 0} {
  if { $1 == "test" } {
    test_proc $vrl_lib_path $quartus_sim_lib $verFileName_libName 
  } 
}
	
# pause

exit -force