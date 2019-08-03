# cd C:/Users/sashaleyan/Documents/Villanova/01_ADVANCE_FPGA_DESIGN_ECE8455/Project/test_18_using_tse_controller_syn/sim
# cd D:/D_DRIVE/Villanova/01_ece_8455_advanced_fpga/project/dynamometer/02_dyno_ver/sim/

quit -sim

# vmap altera ./libs/altera
# vmap altera ./libs/vhdl_libs/altera_lnsim
# vmap altera ./libs/vhdl_libs/altera_mf
# vmap altera ./libs/vhdl_libs/cycloneive
# vmap altera ./libs/vhdl_libs/lpm
# vmap altera ./libs/vhdl_libs/sgate 

# can take on these values: 1,10,100 ns,us,ms,s
set time_scale 1ns

# can take on these values: 1,10,100 ns,us,ms,s
set time_precision 1ns

# Set to 20 ns (50 MHz clock)
set clock_period 20

# Set to 20 ns (50 MHz clock)
set halt_at 2500

# See tse_controller.sv -> "`ifdef" and "disable"
set simulation 1
set compile_type 0

vlib work
vlib pkgs
vlib tse
vmap work ./work

#VLOG - Verilog Compile command; Compiles the Verilog files:
vlog -work work ./../src/pkgs/inet_stack_pkg.sv
vlog -work work ./../src/pkgs/interface_pkg.sv
vlog -work work ./../src/tse/tse_controller.sv

vlog -timescale ${time_scale}/${time_precision} \
     -work work \
	 +define+_CLOCK_PERIOD=$clock_period \
	 +define+_HALT=$halt_at \
	 +define+_SIMULATION=$simulation \
	 +define+_COMPILE_TYPE=$compile_type \
	 ./tse_controller_tb.sv


#VSIM - VHDL Simulate command; 
#-novopt turns off optimization that might remove signals
#Launches the simulation of the compiled test bench script:
vsim -novopt work.tse_controller_tb

source wave.do

# config wave -signalnamewidth 2
# 
# add wave -position inserpoint -radix hex \
# sim:/tse_controller_tb/clock \
# sim:/tse_controller_tb/start \
# sim:/tse_controller_tb/reset_n_xR \
# sim:/tse_controller_tb/dut_1/Clock_xCI \
# sim:/tse_controller_tb/dut_1/Send_Packet_xSI \
# sim:/tse_controller_tb/dut_1/Reset_xSI \
# sim:/tse_controller_tb/dut_1/Adc_xDI \
# sim:/tse_controller_tb/dut_1/Speed_Sensor_xDI \
# sim:/tse_controller_tb/dut_1/Counter_xD \
# sim:/tse_controller_tb/dut_1/next_state \
# sim:/tse_controller_tb/dut_1/Avalon_MM_Master/* \
# sim:/tse_controller_tb/dut_1/Source_Data_xD \
# sim:/tse_controller_tb/dut_1/Avalon_ST_Source/* \
# sim:/tse_controller_tb/dut_1/Ip_Total_Len \
# sim:/tse_controller_tb/dut_1/ip_hdr1 \
# sim:/tse_controller_tb/dut_1/ip_hdr3 \
# sim:/tse_controller_tb/dut_1/ip_hdr2 \
# sim:/tse_controller_tb/dut_1/ip_hdr5 \
# sim:/tse_controller_tb/dut_1/ip_hdr4 \
# sim:/tse_controller_tb/dut_1/ip_hdr7 \
# sim:/tse_controller_tb/dut_1/ip_hdr6 \
# sim:/tse_controller_tb/dut_1/chksum_01_xD \
# sim:/tse_controller_tb/dut_1/chksum_02_xD \
# sim:/tse_controller_tb/dut_1/chksum_03_xD \
# sim:/tse_controller_tb/dut_1/chksum_04_xD \
# sim:/tse_controller_tb/dut_1/chksum_11_xD \
# sim:/tse_controller_tb/dut_1/chksum_12_xD \
# sim:/tse_controller_tb/dut_1/chksum_21_xD \
# sim:/tse_controller_tb/dut_1/chksum_31_xD \
# sim:/tse_controller_tb/dut_1/chksum_41_xD \
# sim:/tse_controller_tb/dut_1/chksum_xD \
# sim:/tse_controller_tb/dut_1/b1 \
# sim:/tse_controller_tb/dut_1/b2 \
# sim:/tse_controller_tb/dut_1/b3 \
# sim:/tse_controller_tb/dut_1/c1 \
# sim:/tse_controller_tb/dut_1/c2 \
# sim:/tse_controller_tb/dut_1/c3 \
# sim:/tse_controller_tb/sum_func_arg1 \
# sim:/tse_controller_tb/sum_func_arg2 \
# sim:/tse_controller_tb/sum_func_arg3 \
# sim:/tse_controller_tb/sum_func_return
# 
# 
# # sim:/tse_controller_tb/dut_1/Tx_Ready_xSI \
# # sim:/tse_controller_tb/dut_1/Tx_Error_xSO \
# # sim:/tse_controller_tb/dut_1/Tx_Valid_xSO \
# # sim:/tse_controller_tb/dut_1/Tx_Sop_xSO \
# # sim:/tse_controller_tb/dut_1/Tx_Eop_xSO \
# # sim:/tse_controller_tb/dut_1/Tx_Empty_xSO \
# # sim:/tse_controller_tb/dut_1/Tx_Data_xD \
# # sim:/tse_controller_tb/dut_1/Tx_Data_xDO \
# 
# # # set write_enable high for 10 ns @ 20 ns:
# # force -deposit reset \
# #   1 0   ns, \
# #   0 151 ns, \
# #   1 171 ns
# 
# force -deposit avalon_st_bus.Ready_xSO \
#   1 0  ns, \
#   0 311 ns, \
#   1 331 ns
# 
# 
# force -deposit start \
#   0 0  ns, \
#   0 71 ns, \
#   0 91 ns, \
#   1 191 ns, \
#   0 211 ns, \
#   1 451 ns, \
#   0 471 ns, \
#   1 811 ns, \
#   0 831 ns, \
#   1 2011 ns, \
#   0 2031 ns
#                     
# force -deposit avalon_mm_bus.waitrequest_xSI \
#   0 0 ns, \
#   1 231 ns, \
#   0 291 ns, \
#   1 331 ns, \
#   0 351 ns, \
#   1 751 ns, \
#   0 791 ns
#                            
# 
# run $halt_at ns
# #run 1000000000 ns
# 
#    
# #RUN command; Runs the simulation:
# # run 2000
#   
