----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2024/10/28 12:02:52
-- Design Name: 
-- Module Name: tb_Config_Shift_In - Behavioral
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

entity Config_In_Shifter_tb is
end Config_In_Shifter_tb;

architecture Behavioral of Config_In_Shifter_tb is

    -- Constants for clock period
    constant clk_period : time := 10 ns;
--    constant baud_period : time := 96 us;

    -- Component signals
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal uart_rx_data : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal uart_rx_ready : STD_LOGIC := '0';
    signal last_bit_out : STD_LOGIC;
    signal config_clk: STD_LOGIC := '0';

    -- Test data to be shifted into the register
    type test_data_array is array (0 to 6) of STD_LOGIC_VECTOR(7 downto 0);
    constant test_data : test_data_array := (
        x"A5", -- Test byte 1
        x"3C", -- Test byte 2
        x"FF", -- Test byte 3
        x"1E", -- Test byte 4
        x"88", -- Test byte 5
        x"AA", -- Test byte 6
        x"55"  -- Test byte 7
    );

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.Config_In_Shifter
        Port map (
            clk => clk,
            reset => reset,
            uart_rx_data => uart_rx_data,
            uart_rx_ready => uart_rx_ready,
            last_bit_out => last_bit_out,
            config_clk => config_clk
        );

    -- Clock generation process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Test stimulus process
    stimulus_process: process
    begin
        -- Initialize and reset the shift register
        reset <= '1';
        wait for clk_period * 9600 * 2;
        reset <= '0';
        wait for clk_period * 9600 * 2;

        -- Loop through each byte in the test data array
        for i in 0 to 6 loop
            uart_rx_data <= test_data(i);   -- Load test data byte
            uart_rx_ready <= '1';           -- Simulate data ready signal
            wait for clk_period * 9600;            -- Wait for 1 clock cycle
            uart_rx_ready <= '0';           -- Clear ready signal
            wait for clk_period * 9600 * 8;        -- Allow time for shifting
        end loop;

        -- Check last_bit_out behavior after all data is shifted in
        wait for clk_period * 9600 * 20;

        -- Stop simulation
        wait;
    end process;

end Behavioral;
