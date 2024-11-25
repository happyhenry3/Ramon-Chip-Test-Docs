----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2024/11/14 01:38:09
-- Design Name: 
-- Module Name: Data_Out - Behavioral
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

entity Data_Out is
    Port ( clk : in STD_LOGIC;
           resetn : in STD_LOGIC;
           button_in : in STD_LOGIC;
           read_enable : out STD_LOGIC;
           data_clk : out STD_LOGIC);
end Data_Out;

architecture Behavioral of Data_Out is
    
    signal state: STD_LOGIC := '0';
    signal done: STD_LOGIC := '0'; 
    signal clk_div_counter: integer := 0;
    signal data_clk_counter: integer := 0;
    signal data_clk_reg: STD_LOGIC := '0';
    constant CLK_DIV : integer := 250000;
    
begin

    state_process: process(clk, resetn, button_in)
    begin
        if resetn = '0' then
            state <= '0';
        else 
            if rising_edge(clk) then
                if button_in = '1' then
                    state <= '1';              
                else 
                    if done = '1' then
                        state <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    gen_process: process(clk, resetn, state)
    begin
        if rising_edge(clk) then
            if resetn = '0' then
                done <= '0';
            else
                if state = '1' then
                    if data_clk_counter = 84 then
    --                    read_enable <= '0';
                        data_clk_reg <= '0';
                        data_clk_counter <= 0;
                        done <= '1';
                    else 
                        if clk_div_counter = (CLK_DIV - 1) then
                            data_clk_reg <= not data_clk_reg;
                            clk_div_counter <= 0;
                            data_clk_counter <= data_clk_counter + 1;
                        else
                            clk_div_counter <= clk_div_counter + 1;
                        end if;
                    end if;
                    if data_clk_counter >= 2 and data_clk_counter < 84 then
                        read_enable <= '1';
                    else 
                        read_enable <= '0';
                    end if;
                else 
                    -- Reset counters and outputs when state is idle
                    data_clk_counter <= 0;
                    clk_div_counter <= 0;
                    read_enable <= '0';
                    data_clk_reg <= '0';
                    done <= '0';
               end if;
           end if;
       end if;
    end process;

    data_clk <= data_clk_reg;

end Behavioral;
