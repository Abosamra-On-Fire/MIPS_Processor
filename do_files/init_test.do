vsim -gui -l /dev/null work.cpu

# TOP MODULE SIGNALS
add wave -position insertpoint  \
sim:/cpu/clk \
sim:/cpu/reset \
sim:/cpu/pc \
sim:/cpu/instr \
sim:/cpu/signals \
sim:/cpu/rd1 \
sim:/cpu/rd2 \
sim:/cpu/alu_out \
sim:/cpu/carry \
sim:/cpu/negative \
sim:/cpu/zero 

# ALU SIGNALS
add wave -position insertpoint  \
sim:/cpu/alu_inst/OP \
sim:/cpu/alu_inst/A \
sim:/cpu/alu_inst/B \
sim:/cpu/alu_inst/result

# REGISTER FILE SIGNALS
add wave -position insertpoint  \
sim:/cpu/rf/read_addr1 \
sim:/cpu/rf/read_addr2 \
sim:/cpu/rf/read_data1 \
sim:/cpu/rf/read_data2 \
sim:/cpu/rf/register_file

force -freeze sim:/cpu/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/cpu/reset 1 0

run 100 ps

force -freeze sim:/cpu/reset 0 0

run 100 ps

# forcing the two read addresses of register_file
# to check if read_data1 and read_data2 are correct

# check regs 0 and 1
force -freeze sim:/cpu/rf/read_addr1 000 0
force -freeze sim:/cpu/rf/read_addr2 001 0
run 100 ps

# check regs 2 and 3
force -freeze sim:/cpu/rf/read_addr1 010 0
force -freeze sim:/cpu/rf/read_addr2 011 0
run 100 ps

# check regs 4 and 5
force -freeze sim:/cpu/rf/read_addr1 100 0
force -freeze sim:/cpu/rf/read_addr2 101 0
run 100 ps

# check regs 6 and 7
force -freeze sim:/cpu/rf/read_addr1 110 0
force -freeze sim:/cpu/rf/read_addr2 111 0
run 100 ps

wave zoom full