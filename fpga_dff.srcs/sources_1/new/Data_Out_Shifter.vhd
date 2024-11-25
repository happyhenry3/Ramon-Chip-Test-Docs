----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2024/11/16 13:05:57
-- Design Name: 
-- Module Name: Data_Out_Shifter - Behavioral
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

entity Data_Out_Shifter is
    Port ( 
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tdc_data_back : in STD_LOGIC;
           tdc_data_clk : in STD_LOGIC;
           uart_tx_start : out STD_LOGIC;
           uart_tx_data : out STD_LOGIC_VECTOR(7 downto 0)
           );
end Data_Out_Shifter;

architecture Behavioral of Data_Out_Shifter is

    signal shift_reg : std_logic_vector(41 downto 0) := (others => '0');
    signal uart_tx_data_sig : std_logic_vector(7 downto 0);
    signal shift_counter : integer := 0;
    signal bit_counter : integer := 0;
    signal clear_flag : STD_LOGIC := '0';

    signal uart_tx_start_sig: STD_LOGIC := '0';
    signal uart_tx_start_sig_d : std_logic := '0';
    signal uart_tx_start_pulse: STD_LOGIC := '0';

begin
    process(clk, tdc_data_clk, shift_reg, reset, uart_tx_start_pulse, uart_tx_data_sig, clear_flag)
    begin
        uart_tx_data_sig <= uart_tx_data_sig;
        if reset = '1' then
            -- Reset the shift register
            shift_reg <= (others => '0');
            shift_counter <= 0;
--            bit_counter <= 0;
--            clear_flag <= '0';
            uart_tx_start_sig <= '0';
            uart_tx_data_sig <= (others => '0');
        else
            if rising_edge(clk) then

                if uart_tx_start_pulse = '1' then
                    uart_tx_data_sig <= shift_reg(0) & shift_reg(1) & shift_reg(2) & shift_reg(3) & 
                    shift_reg(4) & shift_reg(5) & shift_reg(6) & shift_reg(7);    
                end if;  
--                if clear_flag = '1' then
--                   shift_reg <= (others => '0');
--                end if;
            end if;
            if rising_edge(tdc_data_clk) then
                shift_reg <= tdc_data_back & shift_reg(41 downto 1);  -- Shift and load new byte
                shift_counter <= shift_counter + 1;
--                bit_counter <= bit_counter + 1;
                if shift_counter = 7 then
                    shift_counter <= 0;
                    uart_tx_start_sig <= '1';
                else 
                    uart_tx_start_sig <= '0';    
                end if;
--                if bit_counter = 42 then
--                    bit_counter <= 0;
--                    clear_flag <= '1';
--                else
--                    clear_flag <= '0';
--                end if;
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
