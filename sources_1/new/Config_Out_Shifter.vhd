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
           config_clk_en : in STD_LOGIC;
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
    signal clk_delayed : std_logic := '0';
    signal clk_delay_count_1 : integer := 0;
    signal clk_delay_count_0 : integer := 0;
    signal config_clk_rising_flag : std_logic := '0';
    signal config_clk_falling_flag : std_logic := '0';
--    signal config_clk_en_delayed : std_logic := '0';
    constant DELAY_250 : integer := 500000;
    signal clk_div_counter : integer := 0;
    signal config_clk_delayed  : STD_LOGIC := '0';
    
    signal uart_tx_start_sig: STD_LOGIC := '0';
    signal uart_tx_start_sig_d : std_logic := '0';
    signal uart_tx_start_pulse: STD_LOGIC := '0';
    constant CLK_DIV : integer := 500000;
begin
    
    config_clk_gen_process: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                clk_div_counter <= 0;
                config_clk_delayed <= '0';
                
            else
                if config_clk_en = '1' then
                    if clk_div_counter = (CLK_DIV - 1) then
                        config_clk_delayed <= '1';
                        clk_div_counter <= 0;
                        
                    else
                        clk_div_counter <= clk_div_counter + 1;
                        config_clk_delayed <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    process(clk, config_clk_delayed, shift_reg, reset, uart_tx_start_pulse, uart_tx_data_sig)
    begin
        uart_tx_data_sig <= uart_tx_data_sig;
        if reset = '1' then
            -- Reset the shift register
            shift_reg <= (others => '0');
            shift_counter <= 0;
            uart_tx_start_sig <= '0';
            uart_tx_data_sig <= (others => '0');
        else
            if rising_edge(clk) then
                if config_clk_delayed = '1' then
                    shift_reg <= data_back & shift_reg(55 downto 1);  -- Shift and load new byte
                    shift_counter <= shift_counter + 1;
                    if shift_counter = 7 then
                        shift_counter <= 0;
                        uart_tx_start_sig <= '1';
                    else 
                        uart_tx_start_sig <= '0';    
                    end if;
                end if;
                if uart_tx_start_pulse = '1' then
                    uart_tx_data_sig <= shift_reg(7 downto 0);         
                end if;     
           end if; 
        end if; 
    end process;

    pulse_start: process(clk, uart_tx_start_sig)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                uart_tx_start_sig_d <= '0';
                uart_tx_start_pulse <= '0';
            else
                -- Capture the delayed version of uart_tx_start_sig
                uart_tx_start_sig_d <= uart_tx_start_sig;

                -- Generate pulse when uart_tx_start_sig rises from '0' to '1'
                if uart_tx_start_sig = '1' and uart_tx_start_sig_d = '0' then
                    uart_tx_start_pulse <= '1';
                else
                    uart_tx_start_pulse <= '0';
                end if;
            end if;
        end if;

    end process;

    -- Output the last bit of the shift register
    uart_tx_data <= uart_tx_data_sig;
    uart_tx_start <= uart_tx_start_pulse;
end Behavioral;
