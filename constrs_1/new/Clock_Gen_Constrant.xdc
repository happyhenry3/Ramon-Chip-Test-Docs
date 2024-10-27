## Clock signal (100MHz clock from the onboard oscillator)
set_property PACKAGE_PIN E3 [get_ports clk_in]
set_property IOSTANDARD LVCMOS33 [get_ports clk_in]
create_clock -add -name sys_clk_pin -period 10.000 [get_ports clk_in]
