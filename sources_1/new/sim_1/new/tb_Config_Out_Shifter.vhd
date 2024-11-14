----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2024 12:04:19 AM
-- Design Name: 
-- Module Name: tb_Config_Out_Shifter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity tb_Config_Out_Shifter is
-- No ports are needed in the testbench entity
end tb_Config_Out_Shifter;

architecture Behavioral of tb_Config_Out_Shifter is

    -- Signals to connect to the DUT (device under test)
    signal clk_tb          : std_logic := '0';
    signal reset_tb        : std_logic := '0';
    signal data_back_tb    : std_logic := '0';
    signal uart_tx_data_tb : std_logic_vector(7 downto 0);
    signal uart_tx_start_tb: std_logic;

    -- Clock period definition (for example, a 100 MHz clock)
    constant CLK_PERIOD : time := 50 us;

    -- DUT (Device Under Test) instantiation
    component Config_Out_Shifter
        Port (
            clk           : in std_logic;
            reset         : in std_logic;
            data_back     : in std_logic;
            uart_tx_data  : out std_logic_vector(7 downto 0);
            uart_tx_start : out std_logic
        );
    end component;

begin

    -- Instantiate the DUT (Config_Out_Shifter)
    uut: Config_Out_Shifter
        port map (
            clk           => clk_tb,
            reset         => reset_tb,
            data_back     => data_back_tb,
            uart_tx_data  => uart_tx_data_tb,
            uart_tx_start => uart_tx_start_tb
        );

    -- Clock generation process: generates a 100 MHz clock signal
    clk_process : process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD / 2;
        clk_tb <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus process to test the behavior of the shift register
    stimulus_process : process
    begin
        -- Apply reset initially
        reset_tb <= '1';
        wait for 200 us;
        reset_tb <= '0';

        -- Start applying input data to the shift register
        -- Shift 1 bit at a time, then check the output after every 7 shifts
        
--        wait for 100 us;
        --0x35
        data_back_tb <= '1';  -- Shift in '1'
        wait for CLK_PERIOD;
        data_back_tb <= '0';  -- Shift in '0'
        wait for CLK_PERIOD;
        data_back_tb <= '1';  -- Shift in '1'
        wait for CLK_PERIOD;
        data_back_tb <= '0';  -- Shift in '0'
        wait for CLK_PERIOD;
        data_back_tb <= '1';  -- Shift in '1'
        wait for CLK_PERIOD;
        data_back_tb <= '1';  -- Shift in '1'
        wait for CLK_PERIOD;
        data_back_tb <= '0';  -- Shift in '0'
        wait for CLK_PERIOD;
        data_back_tb <= '0';  -- Shift in '0'
        wait for CLK_PERIOD;

        -- After 8 shifts, the UART should be ready to transmit the first byte
        -- The uart_tx_start signal should go high, and uart_tx_data should have the correct value
--        wait for 100 us;

        -- Continue shifting data
        -- 0xb3
        data_back_tb <= '1';  -- Shift in '1'
        wait for CLK_PERIOD;
        data_back_tb <= '1';  -- Shift in '1'
        wait for CLK_PERIOD;
        data_back_tb <= '0';  -- Shift in '0'
        wait for CLK_PERIOD;
        data_back_tb <= '0';  -- Shift in '0'
        wait for CLK_PERIOD;
        data_back_tb <= '1';  -- Shift in '1'
        wait for CLK_PERIOD;
        data_back_tb <= '1';  -- Shift in '1'
        wait for CLK_PERIOD;
        data_back_tb <= '0';  -- Shift in '0'
        wait for CLK_PERIOD;
        data_back_tb <= '1';  -- Shift in '1'
        wait for CLK_PERIOD;

        -- Second UART byte should be ready to transmit
        wait for 100 us;

        -- Add more shifts as needed for the test
        -- You can extend this pattern to observe how more bytes are transmitted.

        -- Finish simulation after observing enough cycles
        wait for 500 us;
        wait;
    end process;

end Behavioral;

