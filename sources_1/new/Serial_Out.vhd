----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2024 07:52:19 PM
-- Design Name: 
-- Module Name: Serial_Out - Behavioral
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

entity Serial_Out is
    Port ( clk_in : in STD_LOGIC;
           reset : in STD_LOGIC;
           read_enable : out STD_LOGIC;
           data_clk : out STD_LOGIC);
end Serial_Out;

architecture Behavioral of Serial_Out is

    signal clk_div_counter : integer := 0;
    signal clk_data_reg  : STD_LOGIC := '1';
    signal read_enable_counter : integer := 0;
    constant CLK_DIV : integer := 5000;  -- 1kHz Clock should flip once every 100 100MHz cycles (period = CLK_DIV*0.01us*2)
    constant READ_ENABLE_DELAY : integer := 100*CLK_DIV;
    signal step_done          : STD_LOGIC := '0';
begin
    -- Clock divider process to generate 500kHz clock
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                clk_div_counter <= 0;
                clk_data_reg <= '1';
            else
                if clk_div_counter = (CLK_DIV - 1) then
                    clk_data_reg <= not clk_data_reg;  -- Toggle 200kHz clock
                    clk_div_counter <= 0;
                else
                    clk_div_counter <= clk_div_counter + 1;
                end if;
            end if;
        end if;
    end process;
    data_clk <= clk_data_reg;
    
    -- Step function generation process
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                read_enable_counter <= 0;
                step_done <= '0';
                read_enable <= '0';
            else
                if step_done = '0' then
                    if read_enable_counter = (READ_ENABLE_DELAY - 1) then
                        step_done <= '1';
                        read_enable <= '1';  -- Change to 1.1V (logic high)
                    else
                        read_enable_counter <= read_enable_counter + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
end Behavioral;
