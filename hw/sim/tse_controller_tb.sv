//Alex Aleyan

`ifndef _CLOCK_PERIOD
  `define _CLOCK_PERIOD 5
`endif
`ifndef _HALT
  `define _HALT 2500
`endif

`ifndef _FSM_COUNTER_SPAN
  `define _FSM_COUNTER_SPAN 25000000
`endif
`ifndef _FSM_WAIT_TO_INIT
  `define _FSM_WAIT_TO_INIT 50
`endif
`ifndef _FSM_WAIT_SEND_AGAIN
  `define _FSM_WAIT_SEND_AGAIN 50000000
`endif

`ifndef _SIMULATION
  `define _SIMULATION 1
`endif

`ifndef _COMPILE_TYPE
  localparam _COMPILE_TYPE = 0;
`else
  localparam _COMPILE_TYPE = 1;
`endif

//`include "./../hdl/inet_stack_pkg.sv"
//`include "./../src/pkgs/interface_pkg.sv"

module tse_controller_tb; 

IAvalonST #(
    .DATA_WIDTH(32)
  )
  avalon_st_bus ( /*no ports*/ );


IAvalonMM #(
    .ADDRESS_WIDTH(8),
    .DATA_WIDTH(32)
  )
  avalon_mm_bus( /* no ports */ );

assign avalon_mm_bus.readdata_xSI = '0;
//assign avalon_st_bus.Ready_xSO = '0;

//IAvalonST.Master #(.TSE_TX_ST_DATA_WIDTH(32)) ready();
//reg clock, start,ready,reset_n_xR,waitrequest; // always unsigned!
reg clock, start,reset_n_xR,waitrequest; // always unsigned!
reg [7:0] data;
reg [4:0] address;

wire Write_xS; // always unsigned!
wire [7:0] Data_xD, DataIn_xD;
wire [4:0] Address_xD;



initial
begin
  clock = 'b0;
  
  // forever #(`_CLOCK_PERIOD/2) clock = ~clock;
  
  #(`_HALT) $stop; // $finish can be used instead of $stop to close modelsim completely when logging data to a file.
end



always begin
  #(`_CLOCK_PERIOD/2) clock = ~clock;
end


logic [511:0] write_data_512 [5];// = 'habcd_ef00;
localparam BRIDGE_DATA_WIDTH = 32;
logic [3:0] nibble;

initial
begin
  #1   reset_n_xR = 'b1;
  #150 reset_n_xR = 'b0;
  #20  reset_n_xR = 'b1;
  
  #50;
  for(int j=0;j<5;j=j+1) begin
    for(int i=0;i<16;i=i+1) begin 
      write_data_512[j][i*BRIDGE_DATA_WIDTH+:BRIDGE_DATA_WIDTH] = 'hadd00000 + i + (j*16);
      $display("Time: %t; set write_data_512[%d][%d %d] %x", $time, j, i*BRIDGE_DATA_WIDTH+32-1, i*BRIDGE_DATA_WIDTH, write_data_512[j][i*BRIDGE_DATA_WIDTH+:BRIDGE_DATA_WIDTH]);
    end
  end
end



`ifdef _SIMULATION

  reg [15:0] adc_driver, speed_sensor_driver;
  integer ran_seed;
  initial ran_seed = 1;
  always @(posedge dut_1.Clock_xCI)
  begin
    adc_driver          <= $random(ran_seed);
    speed_sensor_driver <= $random(ran_seed+1);
  end


  
  reg [31:0] tse_fd1, tse_fd2;
  
  initial
  begin

    // Open the file to log the data:
    tse_fd1 = $fopen("tse_tx_avalon_st.log") | 1;        // tse_fd1 = 32'h2 (bit 1 is set)
    tse_fd2 = $fopen("tse_tx_avalon_mm.log") | 1;        // tse_fd1 = 32'h4 (bit 2 is set)
  
    // Write some initial title information into the file:
    #0 $fdisplay(tse_fd1, "TSE Transmit Interface (Avalon-ST) %m @%t", $time); // write to file1.log
    #0 $fdisplay(tse_fd2, "TSE Control Interface (Avalon-MM) %m @%t", $time); // write to file1.log
    
    // Close the file once the simulation is halted:
    #(`_HALT-100) $fclose(tse_fd1|tse_fd2);
    #(`_HALT-100) $display("\n\nThis display message is schedule at the same time the the last strobe but displayed before the strobe!");
    #(`_HALT-100) $strobe("Simulatiopn finished!!!"); // strobe always executes last when occurs at the same time with other display tasks!
  
  end
  
  
  
  //        // TSE Controller's Streaming Interface used to write the transmit data into the TSE module:
  //        always @(posedge dut_1.Clock_xCI)
  //        begin
  //          if (dut_1.Tx_Valid_xSO == 1'b1)
  //          begin
  //          $display("\n\nSTART OF MESSAGE:");
  //            $fdisplay(tse_fd1 , "Triggered dut_1's Avalon-ST (ETH TX) @%t ", $time);
  //            $fdisplay(tse_fd1 , "dut_1.Tx_Data_xDO: %h",  dut_1.Tx_Data_xDO);              // write to file1.log and file2.log
  //            $fdisplay(tse_fd1 , "dut_1.Tx_Sop_xSO: %h",   dut_1.Tx_Sop_xSO);
  //            $fdisplay(tse_fd1 , "dut_1.Tx_Eop_xSO: %h",   dut_1.Tx_Eop_xSO);
  //            $fdisplay(tse_fd1 , "dut_1.Tx_Valid_xSO: %h", dut_1.Tx_Valid_xSO);
  //            $fdisplay(tse_fd1 , "dut_1.Tx_Error_xSO: %h", dut_1.Tx_Error_xSO);
  //            $fdisplay(tse_fd1 , "dut_1.Tx_Empty_xSO: %h", dut_1.Tx_Empty_xSO);
  //            $strobe("END OF MESSAGE"); // strobe always executes last when occurs at the same time with other display tasks
  //          end
  //        end
  
  //        // TSE Controller's Memmory Mapped Interface used to configure the TSE and PHY:
  //        always @(posedge dut_1.Tse_Control_write_xSO)
  //        begin
  //          $fdisplay(tse_fd2 , "Triggered dut_1's Avalon-MM (TSE CONTROL) @%t ", $time);
  //          $fdisplay(tse_fd2 , "dut_2.Tse_Control_address_xDO: %h",     dut_1.Tse_Control_address_xDO);              // write to file1.log and file2.log
  //          $fdisplay(tse_fd2 , "dut_2.Tse_Control_readdata_xSI: %h",    dut_1.Tse_Control_readdata_xSI);
  //          $fdisplay(tse_fd2 , "dut_2.Tse_Control_read_xSO: %h",        dut_1.Tse_Control_read_xSO);
  //          $fdisplay(tse_fd2 , "dut_2.Tse_Control_writedata_xDO: %h",   dut_1.Tse_Control_writedata_xDO);
  //          $fdisplay(tse_fd2 , "dut_2.Tse_Control_write_xSO: %h",       dut_1.Tse_Control_write_xSO);
  //          $fdisplay(tse_fd2 , "dut_2.Tse_Control_waitrequest_xSI: %h", dut_1.Tse_Control_waitrequest_xSI);
  //        end

  
  // INITIALIZE MEMORY FROM FILE:
  reg [7:0] memory[0:7];
  integer i;
  
  initial
  begin
    $readmemb("init_memory.dat", memory);
    for (i=0; i < 8; i = i + 1) $display("Memory [%0d] = %b", i, memory[i]);
  end
  
  
  // VALUE CHANGE DUMP (VCD) FILE:
  initial 
  begin
    $dumpon;
    $dumpall; // create a check point
    $dumpfile("vcd_file.dmp");
    $dumpvars; // no args means dump all signals in the design
    $dumpvars(1, dut_1);
    $dumpvars(2, tse_controller_tb.dut_1);
    #(`_HALT-100) $dumpoff;
  end
    
`endif



tse_controller #(
    //._SIMULATION(`_SIMULATION),
      ._COMPILE_TYPE(`_COMPILE_TYPE),
    /*parameter MTU_WIDTH          = 16,
      parameter SPEED_SENSOR_WIDTH = 16,
      parameter ADC_WIDTH          = 16,
      
      parameter TSE_TX_ST_DATA_WIDTH = 32,
      parameter TSE_CONTROL_MM_ADDRESS_WIDTH = 8,
      parameter TSE_CONTROL_MM_DATA_WIDTH = 32, */ 
    
      .FSM_COUNTER_SPAN(`_FSM_COUNTER_SPAN),       // parameter FSM_COUNTER_SPAN = 250000000,
      .FSM_WAIT_TO_INIT(`_FSM_WAIT_TO_INIT),       // parameter FSM_WAIT_TO_INIT = 5,
      .FSM_WAIT_SEND_AGAIN(`_FSM_WAIT_SEND_AGAIN)  // parameter FSM_WAIT_SEND_AGAIN = 5,
    
    /*parameter LINK_LAYER_BYTES = 16,
      parameter IP_LAYER_BYTES   = 20,
      parameter UDP_LAYER_BYTES  = 8,
      parameter DATA_LAYER_BYTES = 24 */
    ) 
  dut_1 (
      .Clock_xCI(clock),
      .Reset_xSI(reset_n_xR),
      .Send_Packet_xSI(start),
      
      .Mtu_xDI( 16'h06),          
      .Speed_Sensor_xDI(speed_sensor_driver),
      .Adc_xDI(adc_driver),         
      
      // Avalon-ST Master:
      .Avalon_ST_Source(avalon_st_bus.Source),
      
      // Avalon-MM Master:
      .Avalon_MM_Master(avalon_mm_bus.Master)
    
    );
    
    
    
`ifdef _SIMULATION

  localparam ARG_WIDTH=3;

  logic [ARG_WIDTH-1:0] sum_func_arg1, sum_func_arg2;
  logic  sum_func_arg3;
  logic [ARG_WIDTH-1:0] sum_func_return;

  function logic [ARG_WIDTH-1:0] sum_func(input  [ARG_WIDTH-1:0] a,b,
                                          output overflow);
    {overflow, sum_func} = {1'b0,a} + {1'b0,b}; // almost same as: return {1'b0,a} + {1'b0,b};
  endfunction


  initial
  begin
    #0 sum_func_arg1   <= 0;
    #30 $display("\nLOOP1: incrementing sum_func_arg2=%x",i);
    for(i=0;i<10;i=i+1) begin
      #20 sum_func_arg1 <= i;
    end
  end


  always_ff @ (posedge clock)
  begin : sum_func_always_block1
    sum_func_arg2   <= 'h1;
    sum_func_return <= sum_func(.a(sum_func_arg1),
                                .b(sum_func_arg2),
                                .overflow(sum_func_arg3));
  end 

`endif



`ifdef _SIMULATION
  
  logic [15:0] b1, b2, b3;
  /* NOTICE: 
      1. Everything inside a task is combinatorial logic as with blocking assignment (wires).
	  2. Registers behavior is not allowed within a task.
	  3. Declaration of wires or registers is not allowed within a task.  */
  task bitwise_oper;
    input [15:0] a, b;
    output [15:0] a1_xDO, a2_xDO, a3_xDO;
    begin
      a1_xDO = a & b;
  	  a2_xDO = a1_xDO;
  	  a3_xDO = a2_xDO;
    end
  endtask
  
  always_ff @ (posedge clock)
  begin
  
    begin : bitwise_oper_block1
      if (_COMPILE_TYPE) disable bitwise_oper_block1;
	  //$display("\n\nDisplaying on %m; using bitwise_oper within bitwise_oper_block1");
      bitwise_oper(
        // OUTPUTS:
          .a1_xDO(b1), 
          .a2_xDO(b2), 
          .a3_xDO(b3),
  	    // INPUTS
          .a(avalon_st_bus.Data_xDO[31:16]),
          .b(avalon_st_bus.Data_xDO[15:0])    );
    end
    
    begin : bitwise_oper_block2
      if (!_COMPILE_TYPE) disable bitwise_oper_block2;
	  //$display("\n\nDisplaying on %m; setting b1 thru b3 to Z within bitwise_oper_block2");
      b1 = 'bZ;
      b2 = 'bZ;
      b3 = 'bZ;
    end
    
  end
  
`else

  always_ff @ (posedge clock)
  begin
  
    begin : bitwise_oper_block1
      if (_COMPILE_TYPE) disable bitwise_oper_block1;
      b1 = '1;
      b2 = '1;
      b3 = '1;
    end
    
    begin : bitwise_oper_block2
	  if (!_COMPILE_TYPE) disable bitwise_oper_block2;
      b1 = '0;
      b2 = '0;
      b3 = '0;
    end
    
  end

`endif



`ifdef _SIMULATION

  logic [15:0] c1, c2, c3;
  // Direct task operates on REG vectors declared within the same module.
  task bitwise_oper_direct;
  begin
    c1 = avalon_st_bus.Data_xDO[31:16] & avalon_st_bus.Data_xDO[15:0];
    c2 = c1;
    c3 = c2;
  end
  endtask
  
  always_ff @ (posedge clock)
  begin
  
    begin : bitwise_oper_direct_block1
      if (_COMPILE_TYPE) disable bitwise_oper_direct_block1;
      bitwise_oper_direct;	
    end
    
    begin : bitwise_oper_direct_block2
      if (!_COMPILE_TYPE) disable bitwise_oper_direct_block2;
      c1 = 'bZ;
      c2 = 'bZ;
      c3 = 'bZ;
    end
    
  end
`else
  always_ff @ (posedge clock)
  begin
  
    begin : bitwise_oper_block1
      if (_COMPILE_TYPE) disable bitwise_oper_block1;
      c1 = '1;
      c2 = '1;
      c3 = '1;
    end
    
    begin : bitwise_oper_block2
      if (!_COMPILE_TYPE) disable bitwise_oper_block2;
      c1 = '0;
      c2 = '0;
      c3 = '0;
    end
    
  end
`endif

endmodule

