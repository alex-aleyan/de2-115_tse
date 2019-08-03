@echo off
rem setlocal enableextensions enabledelayedexpansion

Title "Compiling the Libraries:"

rem SET_GLOBAL_VARS
  echo.
  echo ***************************************************************************
  echo Configure the windows environment here:
  echo ***************************************************************************
  
  set path_to_modelsim=c:\modeltech64_10.5g\win64
  call :doesFileExist %path_to_modelsim%
  set path=%path_to_modelsim%;%PATH%
  
  set QUARTUS_VERSION=16.1
  	   
  set QUARTUS_ROOTDIR=C:\intelFPGA\16.1\quartus
  call :doesFileExist %QUARTUS_ROOTDIR%

  
rem SET_MODELSIM_VARS
  echo. & echo.
  echo ***************************************************************************
  echo Set all the ModelSim variables here:
  echo ***************************************************************************
  
  set quartus_sim_lib=C:/intelFPGA/16.1/quartus/eda/sim_lib
  set libs=./libs
  set vrl_lib_path=./libs/vrl
  set vhd_lib_path=./libs/vhd
  echo.
  
:MENU
  echo.
  echo ***************************************************************************
  echo MENU:
  echo ***************************************************************************
  echo Select Device: & echo.
  echo     0: Clean up All Libs
  echo     1: Compile Altera VHDL Libraries (Removes All Libs as well)
  echo     2: Compile Altera Verilog Libraries (Removes All Libs as well)
  echo     3: Compile Altera Cyclone(IVe^&V) Libraries (Removes All Libs as well)
  echo     A: Compile All (Removes All Libs as well)
rem hidden option used for debug/learning:
rem echo     T: TEST
  echo     Q: Quit
  echo ***************************************************************************
  echo ***************************************************************************
  
  SET /P menu_choice=Type 0, 1, 2, 3, A, T, Q then press ENTER:
  
  IF %menu_choice%==0 GOTO CLEANUP_LIBS
  IF %menu_choice%==1 GOTO COMPILE_VHDL
  IF %menu_choice%==2 GOTO COMPILE_VERILOG
  IF %menu_choice%==3 GOTO COMPILE_CYCLONE
  IF %menu_choice%==A GOTO COMPILE_ALL
  IF %menu_choice%==T GOTO TEST
  IF %menu_choice%==Q GOTO END
  

:CLEANUP_LIBS
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do clean"
  
  GOTO :MENU

:COMPILE_VHDL
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do clean"
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do altera_vhd"
  
  GOTO :MENU

:COMPILE_VERILOG
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do clean"
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do altera_vrl"
  
  GOTO :MENU

:COMPILE_CYCLONE
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do clean"
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do altera_vhd"
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do cycloneive"
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do cyclonev"
  
  GOTO :MENU

:COMPILE_ALL
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do clean"
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do altera_vrl"
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do altera_vhd"
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do cycloneive"
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do cyclonev"
  
  GOTO :MENU

:TEST
  vsim -c -do "set quartus_sim_lib %quartus_sim_lib%; set libs %libs%; set vrl_lib_path %vrl_lib_path%; set vhd_lib_path %vhd_lib_path%; do CompileAlteraSimLibs.do test"
  GOTO :MENU

:doesFileExist
  IF EXIST %~1 ( echo Found %~1 ) ^
  ELSE ( echo Can NOT find %~1 & pause & cmd /c exit -1073741510)
  EXIT /B 0
 
:END
rem  set /p MESSAGE=Hit ENTER to finish...

:EOF