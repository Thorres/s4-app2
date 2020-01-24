@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.1 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Fri Jan 24 12:07:36 -0500 2020
REM SW Build 2552052 on Fri May 24 14:49:42 MDT 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
echo "xsim circuit_tr_signal_behav -key {Behavioral:sim_1:Functional:circuit_tr_signal} -tclbatch circuit_tr_signal.tcl -log simulate.log"
call xsim  circuit_tr_signal_behav -key {Behavioral:sim_1:Functional:circuit_tr_signal} -tclbatch circuit_tr_signal.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
