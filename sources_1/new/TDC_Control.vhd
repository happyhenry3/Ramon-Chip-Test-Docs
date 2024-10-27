----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2024 03:02:21 PM
-- Design Name: 
-- Module Name: TDC_Control - Behavioral
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

entity TDC_Control is
    Port ( clk_in : in STD_LOGIC;
           reset : in STD_LOGIC;
           tdc_input : out STD_LOGIC;
           tdc_reset : out STD_LOGIC
           
           );
end TDC_Control;

architecture Behavioral of TDC_Control is

    signal tdc_input_reg : STD_LOGIC := '0';
    signal tdc_reset_reg : STD_LOGIC := '0';
    signal input_delay_counter : integer := 0;
    signal reset_delay_counter : integer := 0;
    signal input_delay_done    : STD_LOGIC := '0';
    signal reset_delay_done    : STD_LOGIC := '0';
    -- Parameters for step function
    constant INPUT_DELAY : integer := 18;  -- 120us delay
    constant RESET_DELAY : integer := 14; -- 4 clk_config cycles
    constant CLK_DIV : integer := 1000000;

begin
    -- INPUT STEP generation process
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                input_delay_counter <= 0;
                input_delay_done <= '0';
                tdc_input_reg <= '0';
            else
                if input_delay_done = '0' then
                    if input_delay_counter = (INPUT_DELAY*CLK_DIV - 1) then
                        input_delay_done <= '1';
                        tdc_input_reg <= '1';  -- Change to 1.1V (logic high)
                    else
                        input_delay_counter <= input_delay_counter + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- RESET STEP generation process
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                reset_delay_counter <= 0;
                reset_delay_done <= '0';
                tdc_reset_reg <= '1';
            else
                if reset_delay_done = '0' then
                    if reset_delay_counter = (RESET_DELAY*CLK_DIV - 1) then
                        reset_delay_done <= '1';
                        tdc_reset_reg <= '0';  -- Change to 0V (logic low)
                    else
                        reset_delay_counter <= reset_delay_counter + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    tdc_input <= tdc_input_reg;
    tdc_reset <= tdc_reset_reg;
    
end Behavioral;
