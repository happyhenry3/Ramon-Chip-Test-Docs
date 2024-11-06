----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2024 12:34:21 PM
-- Design Name: 
-- Module Name: Config_Cell - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Config_Cell is
    Port ( clk : in STD_LOGIC;
           shift_data_prev : in STD_LOGIC;
           shift_clk : in STD_LOGIC;
--           shift_load : in STD_LOGIC;
           shift_data_next : out STD_LOGIC);
end Config_Cell;

architecture Behavioral of Config_Cell is
    signal shift_data_next_sig: STD_LOGIC := '0';
--    signal config_clk_reg : STD_LOGIC;
    signal config_clk_reg_prev : STD_LOGIC;
    signal config_clk_edge : STD_LOGIC;
begin
-- First Flip-Flop (DFF)
    process(clk, shift_clk)
    begin
        if rising_edge(clk) then
            -- Detect rising edge
            if (shift_clk = '1' and config_clk_reg_prev = '0') then
                config_clk_edge <= '1';  -- Rising edge detected
            else
                config_clk_edge <= '0';
            end if;

            -- Update previous state of signal_in
            config_clk_reg_prev <= shift_clk;
        
            if config_clk_edge = '1' then
--                if shift_clk = '1' then
                    shift_data_next_sig <= shift_data_prev;  -- Data propagates from shift_data_prev to shift_data_next
--                end if;
            end if;
        end if;
    end process;
    -- Second Flip-Flop (DFF)
--    process(shift_load)
--    begin
--        if rising_edge(shift_load) then
--            data_out <= shift_data_next_sig;  -- Data propagates from shift_data_next to data_out
--        end if;
--    end process;

    shift_data_next <= shift_data_next_sig;

end Behavioral;
