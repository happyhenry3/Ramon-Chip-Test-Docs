----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2024 12:53:38 AM
-- Design Name: 
-- Module Name: tb_Config_Block - Behavioral
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

entity tb_Config_Block is
    -- Testbench doesn't have any ports
end tb_Config_Block;

architecture Behavioral of tb_Config_Block is
    -- Component declaration for the Config_Block to be tested
    component Config_Block
        Port (
            shift_clk_in   : in  std_logic;
            shift_load_in  : in  std_logic;
            shift_data_in  : in  std_logic;
            shift_data_out : out std_logic
        );
    end component;

    -- Testbench signals
    signal shift_clk_in_tb    : std_logic := '0';
    signal shift_load_in_tb   : std_logic := '0';
    signal shift_data_in_tb   : std_logic := '0';
    signal shift_data_out_tb  : std_logic;

    constant clock_period : time := 50 us; -- 20kHz clock (50 us period)
    constant shift_data_sequence : std_logic_vector(15 downto 0) := "0001101010100111"; -- Input sequence

    -- A signal for driving the input data sequence
    signal bit_index : integer := 0;

begin

    -- Instantiate the Config_Block
    uut: Config_Block
        Port map (
            shift_clk_in   => shift_clk_in_tb,
            shift_load_in  => shift_load_in_tb,
            shift_data_in  => shift_data_in_tb,
            shift_data_out => shift_data_out_tb
        );

    -- Clock generation process
    clk_process : process
    begin
        while true loop
            shift_clk_in_tb <= '0';
            wait for clock_period / 2;
            shift_clk_in_tb <= '1';
            wait for clock_period / 2;
        end loop;
    end process;

    -- Process to load the sequence into the shift_data_in signal
    data_process : process
    begin
        wait for clock_period / 2;  -- Start at falling edge
        for bit_index in 0 to 15 loop
            shift_data_in_tb <= shift_data_sequence(bit_index); -- Apply each bit of the sequence
            wait until shift_clk_in_tb = '0';  -- Update at the falling edge of shift_clk_in
        end loop;
        
        -- After sending the sequence, hold the last value
        shift_data_in_tb <= shift_data_sequence(15);
        wait;
    end process;

    -- Load signal control (can be kept as '1' or toggled for different behavior)
    load_process : process
    begin
        -- Apply a load pulse at the beginning
        shift_load_in_tb <= '1';
        wait for clock_period * 10; -- Apply for a few clock cycles
        shift_load_in_tb <= '0';
        wait;
    end process;

end Behavioral;

