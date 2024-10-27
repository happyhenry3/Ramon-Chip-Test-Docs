----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2024 10:34:51 PM
-- Design Name: 
-- Module Name: tb_Toptop - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Toptop_tb is
end Toptop_tb;

architecture Behavioral of Toptop_tb is

    -- Signals to connect to the DUT (Device Under Test)
    signal clk_100M           : std_logic := '0';  -- 100 MHz clock
    signal reset              : std_logic := '0';  -- Reset signal
    signal uart_rx            : std_logic := '0';
    signal tdc_data_out       : std_logic := '0';
    signal config_data_out  : std_logic;         -- Output signal

    -- Clock period constant for 100 MHz
    constant CLK_PERIOD       : time := 10 ns;

begin

    -- Instantiate the DUT (Toptop)
    DUT: entity work.Toptop
        Port map (
            clk_100M          => clk_100M,
            reset             => reset,
            uart_rx           => uart_rx,
            tdc_data_out      => tdc_data_out,
            config_data_out => config_data_out
        );

    -- Clock process to generate a 100 MHz clock
    clk_process : process
    begin
        clk_100M <= '0';
        wait for CLK_PERIOD/2;
        clk_100M <= '1';
        wait for CLK_PERIOD/2;
    end process clk_process;

    -- Stimulus process to apply reset and test the DUT
    stimulus_process: process
    begin
        -- Initial reset
        reset <= '1';
        wait for 100 ns;  -- Hold reset for 100 ns

        -- Release reset
        reset <= '0';

        -- Wait for some time to observe behavior
        wait for 1 us;

        -- End of the testbench
        wait;
    end process stimulus_process;

end Behavioral;

