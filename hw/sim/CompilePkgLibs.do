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


set verFileName_libName {
  {inet_stack_pkg.sv																  pkgs}
  {interface_pkg.sv																  pkgs} }

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

if {$argc > 0} {
  if { $1 == "clean" } {
				proc compile_vrl_lib $vhd_lib_path $quartus_sim_lib $cycloneV_vhdFileName_libName
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
