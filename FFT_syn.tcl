#script per generare la gatelist

analyze -format vhdl -library work src/workpack.vhd

analyze -format vhdl -library work {src/bank.vhd src/mem.vhd src/memory.vhd src/indices_gen.vhd src/addgen.vhd src/input_switching.vhd src/output_switching.vhd src/rx_2_ref.vhd src/rx_2.vhd src/MUX.vhd src/mul_ROM.vhd src/mul.vhd src/PEA.vhd src/PEB.vhd src/PEC.vhd src/MUX_3.vhd src/MUX_4.vhd src/MUX_5.vhd src/ab_switching.vhd src/bc_switching.vhd src/delay.vhd src/BU.vhd src/cascading.vhd src/CU.vhd src/ROM.vhd src/right_shifter.vhd src/theta_gen.vhd src/pipe_cordic.vhd src/preprocessing.vhd src/sel_func.vhd src/xy_cell.vhd src/w_ROM.vhd src/w_cell.vhd src/scale_ROM.vhd src/scale_i.vhd src/scale_factor.vhd src/cordic.vhd src/tfmul.vhd src/twiddle.vhd src/counter.vhd src/address_generator.vhd src/FFT_proc.vhd}

elaborate FFT

set_driving_cell  -lib_cell GTECH_BUF data_in

create_clock -name "CLK" -period 4000 -waveform {2000 4000} {CLK}

current_design 
uniquify

compile -exact_map
