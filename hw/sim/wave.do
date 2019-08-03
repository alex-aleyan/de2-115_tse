config wave -signalnamewidth 2

set hierarchical_path_to_dut "/tse_controller_tb/dut_1"
source "./wave_source.do"

force -deposit avalon_st_bus.Ready_xSO \
  1 0  ns, \
  0 311 ns, \
  1 331 ns


force -deposit start \
  0 0  ns, \
  0 71 ns, \
  0 91 ns, \
  1 191 ns, \
  0 211 ns, \
  1 451 ns, \
  0 471 ns, \
  1 811 ns, \
  0 831 ns, \
  1 2011 ns, \
  0 2031 ns
                    
force -deposit avalon_mm_bus.waitrequest_xSI \
  0 0 ns, \
  1 231 ns, \
  0 291 ns, \
  1 331 ns, \
  0 351 ns, \
  1 751 ns, \
  0 791 ns
                           

run $halt_at ns
#run 1000000000 ns

   
#RUN command; Runs the simulation:
# run 2000
  
