----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2024 06:17:45 PM
-- Design Name: 
-- Module Name: Stream_Generator - Behavioral
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

entity Stream_Generator is
    Port ( clk_in : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_config : out STD_LOGIC;
           config_load : out STD_LOGIC;
           config_stream_out : out STD_LOGIC);
end Stream_Generator;

architecture Behavioral of Stream_Generator is

    signal clk_div_counter : integer := 0;
    signal clk_config_reg  : STD_LOGIC := '1';
    signal config_stream_out_reg : STD_LOGIC := '0';
    constant CLK_DIV : integer := 25000;  -- 2kHz Clock should flip once every 2500 100MHz cycles (period = CLK_DIV*0.01us*2)
    signal stream_delay_counter : integer := 0;
    signal load_delay_counter : integer := 0;
    signal step_done          : STD_LOGIC := '0';
--    signal delay_done         : STD_LOGIC := '0';
    -- Parameters for step function
    constant LOAD_IN_DELAY : integer := 120*CLK_DIV;  -- 120us delay
    constant DATA_IN_DELAY : integer := 4; -- 4 clk_config cycles
    constant CONFIG_STREAM_IN : std_logic_vector(55 downto 0) := "00001100001111000011111111000000101010000001101010100111";
    signal config_bit_counter: integer range 0 to 55 := 0;
-- UART port, make block to send/receive from UART
-- Uart - PC to FPGA
-- FSM, flags, 
-- create 56 shift regs on FPGA, connect to sheft reg on chip, run for 56 cycles
begin
    -- Clock divider process to generate 500kHz 20kHz clock
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                clk_div_counter <= 0;
                clk_config_reg <= '1';
            else
                if clk_div_counter = (CLK_DIV - 1) then
--                    clk_config_reg <= not clk_config_reg;  -- Toggle 200kHz clock
                    clk_config_reg <= '1';
                    clk_div_counter <= 0;
                    
                else
                    clk_div_counter <= clk_div_counter + 1;
                    clk_config_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Output the generated 20kHz clock
    clk_config <= clk_config_reg;

    -- Step function generation process
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if reset = '1' then
                load_delay_counter <= 0;
                step_done <= '0';
                config_load <= '0';
            else
                if step_done = '0' then
                    if load_delay_counter = (LOAD_IN_DELAY - 1) then
                        step_done <= '1';
                        config_load <= '1';  -- Change to 1.1V (logic high)
                    else
                        load_delay_counter <= load_delay_counter + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Config stream generation process
    process(clk_config_reg)
    begin
        if falling_edge(clk_config_reg) then
            if reset = '1' then
                config_bit_counter <= 0;
                config_stream_out_reg <= '0';
--                delay_done <= '0';
            else
                if stream_delay_counter = (DATA_IN_DELAY - 1) then          
--                        delay_done <= '1';          
                    config_stream_out_reg <= CONFIG_STREAM_IN(config_bit_counter);
                    if config_bit_counter = 55 then
                        config_bit_counter <= 0;
                    else
                        config_bit_counter <= config_bit_counter + 1;
                    end if;
                else
                    stream_delay_counter <= stream_delay_counter + 1;
                end if;
            end if;
        end if;
    end process;
          
    config_stream_out <= config_stream_out_reg;

end Behavioral;
