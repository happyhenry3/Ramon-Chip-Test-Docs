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
    Port ( clk : in STD_LOGIC; --100MHz clock
           reset : in STD_LOGIC;
           uart_rx_data : in STD_LOGIC_VECTOR(7 downto 0);
           uart_rx_ready : in STD_LOGIC;
           last_bit_out : out STD_LOGIC; -- last bit of shift register to output to chip
           config_clk: out STD_LOGIC; -- slowed down to 4kHz
           config_clk_en: out STD_LOGIC); -- enable config_clk for transmission to chip
end Config_In_Shifter;

architecture Behavioral of Config_In_Shifter is

   -- Internal signal to represent the 56-bit shift register
    signal shift_reg : std_logic_vector(55 downto 0) := (others => '0');
--    signal config_clk : std_logic := '0';
    signal config_clk_en_sig, config_clk_en_next : std_logic := '0';
    signal load_position, load_position_next : integer range 0 to 7; -- To track load position for 8-bit chunks
    signal shift_count, shift_count_next : integer range 0 to 56 := 0; -- To count bits shifted out
    
    signal clk_div_counter_square, clk_div_counter_pulse : integer := 0;
    signal config_clk_reg : STD_LOGIC;
--    signal config_clk_reg_prev : STD_LOGIC;
    signal config_clk_edge : STD_LOGIC;
    constant CLK_DIV : integer := 250000;
--    CONSTANT uart_rx_data_hard : STD_LOGIC_VECTOR(55 downto 0) := "01001001011001010110110001101100011011110101011101101111";
    
begin

    config_clk_gen_process: process(clk, reset)
    begin
            if reset = '1' then
                clk_div_counter_square <= 0;
                clk_div_counter_pulse <= 0;
                config_clk_reg <= '0';   
--                config_clk_reg_prev <= '0';      
--                config_clk_edge <= '0';  
            else
                 if rising_edge(clk) then
                    if config_clk_en_sig = '1' then
                        if clk_div_counter_square = (CLK_DIV - 1) then
                            config_clk_reg <= not config_clk_reg;
                            clk_div_counter_square <= 0;
                        else
                            clk_div_counter_square <= clk_div_counter_square + 1;
                        end if;
                        if clk_div_counter_pulse = (CLK_DIV*2 - 1) then
                            config_clk_edge <= '1';                          
                            clk_div_counter_pulse <= 0;                           
                        else
                            clk_div_counter_pulse <= clk_div_counter_pulse + 1;
                            config_clk_edge <= '0';
                        end if;
                    end if;                
                end if;
            end if;
    end process;
    config_clk <= config_clk_reg;
    config_clk_en <= config_clk_en_sig;
    -- Process to load data into the shift register
    process(clk, uart_rx_ready, uart_rx_data, shift_reg, load_position, reset, config_clk_edge)
    begin
        if reset = '1' then
            -- Reset the shift register and load position
            shift_reg <= (others => '0');
            last_bit_out <= '0';
        else 
            if rising_edge(clk) then
                if uart_rx_ready = '1' then
                    -- Load data into the appropriate 8-bit section of the shift register
                    shift_reg(((load_position + 1) * 8 - 1) downto (load_position * 8)) <= uart_rx_data(7 downto 0);
    --                shift_reg(((load_position + 1) * 8 - 1) downto (load_position * 8)) <= uart_rx_data_hard(((load_position + 1) * 8 - 1) downto (load_position * 8));
                end if;           
                if config_clk_edge = '1' then
                     -- Shift out 1 bit at a time from the shift register
                    shift_reg <= '0' & shift_reg(55 downto 1);
                    last_bit_out <= shift_reg(0);    
                end if;
            end if;
        end if;
    end process;
    
    
    load_shift_seq: process(clk, reset) --Sequential process to update the load position and shift counters
    begin
        if reset = '1' then
            load_position <= 0;
            shift_count <= 0;
        else
            if rising_edge(clk) then
                load_position <= load_position_next;
                shift_count <= shift_count_next;
            end if;
        end if;
    end process;
    
    load_shift_comb: process(load_position, shift_count, uart_rx_ready, config_clk_edge, reset)
    begin 
        load_position_next <= load_position;
        shift_count_next <= shift_count;
        if uart_rx_ready = '1' then
            load_position_next <= load_position + 1; --Update position in shift reg to load
        end if;
        if config_clk_edge = '1' then
            shift_count_next <= shift_count + 1;    -- Count number of bits shifted into chip
        end if;
        if load_position = 7 then
            load_position_next <= 0;     --when all bits populated, reset position
        else 
            if shift_count = 56 then
                shift_count_next <= 0;       -- When everything shifted into chip, reset counter   
            end if;    
        end if; 
    end process;  
    
    config_clk_en_seq: process(reset, clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                config_clk_en_sig <= '0';
            else config_clk_en_sig <= config_clk_en_next;  -- update enable signal for config clock
            end if;
        end if; 
    end process;
    
    config_clk_en_comb: process(load_position, config_clk_en_sig, shift_count)
    begin
        config_clk_en_next <= config_clk_en_sig;
        if load_position = 7 then
            config_clk_en_next <= '1';      -- enable config clock for shifting in after all bits are loaded
        else 
            if shift_count = 56 then        -- disable config clock after all bits are shifted into the chip
                config_clk_en_next <= '0';
            end if;    
        end if;
    end process;
end Behavioral;
