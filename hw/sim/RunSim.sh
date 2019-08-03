#!/bin/bash

source include.sh

launch_modelsim="vsim -do run.do"

is_exec_in_path vsim

echo -e "Launching modelsim: $launch_modelsim"

eval $launch_modelsim

exit 0
