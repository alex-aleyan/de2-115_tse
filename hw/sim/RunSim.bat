%echo off
Title "Launching the TSE Simulation:"

echo.
echo **************************************************************
echo Configure the windows environment here:
echo **************************************************************

set path_to_modelsim=c:\modeltech64_10.5g\win64
call :doesFileExist %path_to_modelsim%

set path=%path_to_modelsim%;%PATH%
set QUARTUS_VERSION=16.1
	   
set QUARTUS_ROOTDIR=C:\intelFPGA\16.1\quartus
IF EXIST %QUARTUS_ROOTDIR% ( echo QUARTUS_ROOTDIR=%QUARTUS_ROOTDIR% ) ^
  ELSE ( echo Missing %QUARTUS_ROOTDIR% & pause & Exit /b)

echo.
echo **************************************************************
echo Opening Modelsim with All Debug features enabled ...
echo **************************************************************

where modelsim
  if %ERRORLEVEL% neq 0 (
    echo modelsim wasn't found ) ^
  else (
    echo Launching simulation using this command: start modelsim -do sim.do
    start modelsim -do sim.do)


set /p MESSAGE=Hit ENTER to finish...


:doesFileExist
  IF EXIST %~1 ( echo Found %~1 ) ^
  ELSE ( echo Can NOT find %~1 & pause & cmd /c exit -1073741510)
  EXIT /B 0