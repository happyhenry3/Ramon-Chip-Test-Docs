----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2024 06:46:18 PM
-- Design Name: 
-- Module Name: Config_In_Shifter - Behavioral
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

entity Config_In_Shifter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           uart_rx_data : in STD_LOGIC_VECTOR(7 downto 0);
           uart_rx_ready : in STD_LOGIC;
           last_bit_out : out STD_LOGIC);
end Config_In_Shifter;

architecture Behavioral of Config_In_Shifter is

   -- Internal signal to represent the 56-bit shift register
    signal shift_reg : std_logic_vector(55 downto 0) := (others => '0');
begin

    -- Shift register process: shifts data every time UART indicates a new byte has arrived (uart_ready = '1')
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reset the shift register
                shift_reg <= (others => '0');
            else
                if uart_rx_ready = '1' then
                    -- Shift the existing register left by 8 bits, and load the new byte into the lower 8 bits
                    shift_reg(55 downto 48) <= uart_rx_data;  -- Shift and load new byte
                end if;
                shift_reg <= '0' & shift_reg(55 downto 1);
            end if;
        end if;
    end process;

    -- Output the last bit of the shift register
    last_bit_out <= shift_reg(0);

end Behavioral;
