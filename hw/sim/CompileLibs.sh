#!/bin/bash

source ./include.sh

#modelsim_path="c:/modeltech64_10.5g/win64"

quartus_sim_lib="${QUARTUS_ROOTDIR}/eda/sim_lib"

here="$(dirname $(readlink -f "$0"))"

libs="$here/libs"
vrl_lib_path="$here/libs/vrl"
vhd_lib_path="$here/libs/vhd"


does_dir_exist $QUARTUS_ROOTDIR
does_dir_exist $quartus_sim_lib

cp $MODELSIM ./

does_file_exist ./modelsim.ini
if [ $? -ne 0 ]; then exit; fi

echo -e "Launching modelsim now!"

vsim -c -do "set quartus_sim_lib $quartus_sim_lib; set libs $libs; set vrl_lib_path $vrl_lib_path; set vhd_lib_path $vhd_lib_path; do CompileAlteraSimLibs.do clean"
vsim -c -do "set quartus_sim_lib $quartus_sim_lib; set libs $libs; set vrl_lib_path $vrl_lib_path; set vhd_lib_path $vhd_lib_path; do CompileAlteraSimLibs.do altera_vrl"
vsim -c -do "set quartus_sim_lib $quartus_sim_lib; set libs $libs; set vrl_lib_path $vrl_lib_path; set vhd_lib_path $vhd_lib_path; do CompileAlteraSimLibs.do altera_vhd"
vsim -c -do "set quartus_sim_lib $quartus_sim_lib; set libs $libs; set vrl_lib_path $vrl_lib_path; set vhd_lib_path $vhd_lib_path; do CompileAlteraSimLibs.do cycloneive"
vsim -c -do "set quartus_sim_lib $quartus_sim_lib; set libs $libs; set vrl_lib_path $vrl_lib_path; set vhd_lib_path $vhd_lib_path; do CompileAlteraSimLibs.do cyclonev"

exit 0
