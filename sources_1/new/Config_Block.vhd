----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2024 12:53:55 PM
-- Design Name: 
-- Module Name: Config_Block - Behavioral
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

entity Config_Block is
    Port (
--        resetn : in std_logic;
        shift_clk_in    : in  std_logic;
--        shift_load_in   : in  std_logic;
        shift_data_in   : in  std_logic;
        shift_data_next  : out std_logic
    );
end Config_Block;

architecture Behavioral of Config_Block is
    -- Declare an array of signals to connect the config cells
    signal shift_data_signals : std_logic_vector(56 downto 0);
 -- Inter-cell signals for data, 56 cells need 57 data points
    signal shift_clk_signals  : std_logic_vector(55 downto 0); -- Clock signal for each cell
    signal shift_load_signals : std_logic_vector(55 downto 0); -- Load signal for each cell
begin

--    reset_process: process(resetn)
--    begin
--        if resetn = '0' then
--            shift_data_signals <= (others => '0');
--        end if;
--    end process;
    -- First cell input connection
    shift_data_signals(0) <= shift_data_in;
--    shift_clk_signals  <= (others => shift_clk_in);
--    shift_load_signals <= (others => shift_load_in);

    -- Last cell output connection
    shift_data_next <= shift_data_signals(56); -- Connect the last data signal to the output

    -- Generate loop for 56 config cells
    gen_shift_cells: for i in 0 to 55 generate
        config_cell_inst: entity work.Config_Cell
            port map (
                shift_clk       => shift_clk_in,       -- Clock input
--                shift_load      => shift_load_in,      -- Load input
                shift_data_prev => shift_data_signals(i),      -- Data input
                shift_data_next => shift_data_signals(i+1)     -- Data output
            );
    end generate;

    -- Generate clock and load signals for each cell, passing them down the chain
--    process(shift_clk_in, shift_load_in)
--    begin
--        for i in 0 to 54 loop
--            shift_clk_signals(i+1) <= shift_clk_signals(i);  -- Pass the clock signal down the chain
--            shift_load_signals(i+1) <= shift_load_signals(i); -- Pass the load signal down the chain
--        end loop;
--    end process;

end Behavioral;


