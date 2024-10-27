----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/22/2024 11:00:50 PM
-- Design Name: 
-- Module Name: Config_Out_Shifter - Behavioral
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

entity Config_Out_Shifter is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           data_back : in STD_LOGIC;
           uart_tx_data : out STD_LOGIC_VECTOR (7 downto 0);
           uart_tx_start : out STD_LOGIC);
end Config_Out_Shifter;

architecture Behavioral of Config_Out_Shifter is

   -- Internal signal to represent the 56-bit shift register
    signal shift_reg : std_logic_vector(55 downto 0) := (others => '0');
    signal uart_tx_data_sig : std_logic_vector(7 downto 0);
    signal shift_counter : integer := 0;
    
begin

    -- Shift register process: shifts data every time UART indicates a new byte has arrived (uart_ready = '1')
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reset the shift register
                shift_reg <= (others => '0');
                shift_counter <= 0;
                uart_tx_start <= '0';
            else
                shift_reg <= data_back & shift_reg(55 downto 1);  -- Shift and load new byte
                shift_counter <= shift_counter + 1;
                if shift_counter = 8 then
                    shift_counter <= 1;
                    uart_tx_data_sig <= shift_reg (7 downto 0);
                    uart_tx_start <= '1';
                else 
                    uart_tx_start <= '0';    
                end if;
            end if;
        end if; 
    end process;

    -- Output the last bit of the shift register
    uart_tx_data <= uart_tx_data_sig;

end Behavioral;
