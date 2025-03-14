vlib work
vlog tb2.v
vsim tb  +testcase=full_write_read
#add wave -position insertpoint sim:/tb/dut/*
do wave.do
run -all
