@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Mon Jan 27 21:28:12 -0500 2020
REM SW Build 2552052 on Fri May 24 14:49:42 MDT 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto 9e309ee496cc4929b5da1201b0d6cad1 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot simul_module_sig_tb_behav xil_defaultlib.simul_module_sig_tb -log elaborate.log"
call xelab  -wto 9e309ee496cc4929b5da1201b0d6cad1 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot simul_module_sig_tb_behav xil_defaultlib.simul_module_sig_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
