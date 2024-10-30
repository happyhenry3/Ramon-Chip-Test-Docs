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
    signal resetn              : std_logic := '1';  -- Reset signal
    signal uart_rx            : std_logic := '1';
    signal uart_tx            : std_logic := '1';
--    signal tdc_data_out       : std_logic := '0';
--    signal config_data_out  : std_logic;         -- Output signal

    -- Clock period constant for 100 MHz
    constant CLK_PERIOD       : time := 10 ns;
    constant baud_period : time := 104.167 us;
    type uart_data_array is array (0 to 6) of STD_LOGIC_VECTOR(7 downto 0);
    constant uart_data : uart_data_array := (x"48", x"65", x"6c", x"6c", x"6f", x"57", x"6f"); --"HelloWo"

begin

    -- Instantiate the DUT (Toptop)
    DUT: entity work.Toptop
        Port map (
            clk_100M          => clk_100M,
            resetn             => resetn,
            uart_rx           => uart_rx,
            uart_tx           => uart_tx
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
        wait for 20 us;
        -- Initial reset
        resetn <= '0';
        wait for 20 us;  -- Hold reset for 100 ns

        -- Release reset
        resetn <= '1';

        -- Wait for some time to observe behavior
        wait for 2 ms;
        -- Start sending the UART data (the string "Hello" in ASCII)
        -- ASCII values for "Hello" are: 'H' = 0x48, 'e' = 0x65, 'l' = 0x6C, 'l' = 0x6C, 'o' = 0x6F
        for j in 0 to 6 loop
            -- Start bit
            uart_rx <= '0';
            wait for baud_period;

            -- Sending 8 data bits for each character in "Hello"
            for i in 0 to 7 loop
                uart_rx <= uart_data(j)(i);
                wait for baud_period;
            end loop;

            -- Stop bit
            uart_rx <= '1';
            wait for baud_period;
        end loop;

        -- Check if tx_busy_test remains high after "Hello" transmission
        wait for clk_period * 100;

        -- Start sending the UART data (the string "Hello" in ASCII)
        -- ASCII values for "Hello" are: 'H' = 0x48, 'e' = 0x65, 'l' = 0x6C, 'l' = 0x6C, 'o' = 0x6F
        wait for 20 ms;
        for n in 0 to 6 loop
            -- Start bit
            uart_rx <= '0';
            wait for baud_period;

            -- Sending 8 data bits for each character in "Hello"
            for m in 0 to 7 loop
                uart_rx <= uart_data(n)(m);
                wait for baud_period;
            end loop;

            -- Stop bit
            uart_rx <= '1';
            wait for baud_period;
        end loop;

        -- End of the testbench
        wait;
    end process stimulus_process;

end Behavioral;

