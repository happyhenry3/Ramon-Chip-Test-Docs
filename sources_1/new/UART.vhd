----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/20/2024 08:25:34 PM
-- Design Name: 
-- Module Name: UART - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity UART is
    Port (
        clk_100M    : in  STD_LOGIC;  -- 100MHz clock
        reset       : in  STD_LOGIC;  -- Asynchronous reset
        rx          : in  STD_LOGIC;  -- UART receive line (from PC)
        tx          : out STD_LOGIC;  -- UART transmit line (to PC)
        rx_data     : out STD_LOGIC_VECTOR(7 downto 0); -- Received data byte
        rx_ready    : out STD_LOGIC;  -- Data ready flag
--        tx_data     : in  STD_LOGIC_VECTOR(7 downto 0); -- Data to send
        tx_start    : in  STD_LOGIC;  -- Start transmission flag
        tx_busy     : out STD_LOGIC   -- Transmitter busy flag
    );
end UART;

architecture Behavioral of UART is

    -- Baud rate generator constants
    constant CLK_FREQ : integer := 100000000;  -- 100MHz clock frequency
    constant BAUD_RATE : integer := 9600;      -- Baud rate
    constant BAUD_TICKS : integer := CLK_FREQ / BAUD_RATE;

    -- Transmitter signals
    signal tx_reg       : STD_LOGIC := '1';  -- Transmitter register (idle high)
    signal tx_tick_count: integer := 0;      -- Counter for baud ticks
    signal tx_bit_count : integer := 0;      -- Counter for transmitted bits
    signal tx_active    : STD_LOGIC := '0';  -- Transmitter active flag
    signal tx_shift_reg : STD_LOGIC_VECTOR(9 downto 0) := "0000000000";  -- Shift register for start, data, stop bits
    signal tx_data : STD_LOGIC_VECTOR(7 downto 0) := "00000000"; --Temporary signal that links directly to rx_data
    
    signal tx_start_rx_ready_sig : STD_LOGIC := '0';

    -- Receiver signals
    signal rx_tick_count: integer := 0;      -- Counter for baud ticks
    signal rx_bit_count : integer := 0;      -- Counter for received bits
    signal rx_sample_count : integer := 0;   -- Counter for mid-bit sampling
    signal rx_shift_reg : STD_LOGIC_VECTOR(9 downto 0) := "0000000000";  -- Shift register for start, data, stop bits
    signal rx_active    : STD_LOGIC := '0';  -- Receiver active flag
    signal rx_sample_flag : STD_LOGIC := '0';

begin

    -- UART Transmitter process
    tx_process: process(clk_100M)
    begin
        if rising_edge(clk_100M) then
            if reset = '1' then
                tx_reg <= '1';
                tx_tick_count <= 0;
                tx_bit_count <= 0;
                tx_active <= '0';
                tx_busy <= '0';
            else
                if tx_active = '0' then
                    if tx_start_rx_ready_sig = '1' then  -- Start transmission
                        tx_active <= '1';
                        tx_shift_reg <= '1' & tx_data & '0';  -- Start bit, 8 data bits, stop bit
                        tx_bit_count <= 0;
                        tx_tick_count <= 0;
                        tx_busy <= '1';
                    end if;
                else
                    if tx_tick_count < (BAUD_TICKS - 1) then
                        tx_tick_count <= tx_tick_count + 1;
                    else
                        tx_tick_count <= 0;
                        tx_reg <= tx_shift_reg(0);  -- Transmit LSB
                        tx_shift_reg <= '1' & tx_shift_reg(9 downto 1);  -- Shift right
                        if tx_bit_count = 9 then
                            tx_active <= '0';
                            tx_busy <= '0';
                        else
                            tx_bit_count <= tx_bit_count + 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;

    tx <= tx_reg;

    -- UART Receiver process
    rx_process: process(clk_100M)
    begin
        if rising_edge(clk_100M) then
            if reset = '1' then
                rx_ready <= '0';
                tx_start_rx_ready_sig <= '0';
                rx_active <= '0';
                rx_bit_count <= 0;
                rx_tick_count <= 0;
                rx_sample_count <= 0;
            else
                if rx_tick_count < (BAUD_TICKS - 1) then
                        rx_tick_count <= rx_tick_count + 1;
                else     
                    rx_tick_count <= 0;
                     if rx_sample_flag = '1' then
                            rx_data <= rx_shift_reg(8 downto 1);  -- Extract data byte
--                            rx_ready <= '1';
                            tx_start_rx_ready_sig <= '1';--replace this with upper line after working
                            rx_sample_flag <= '0';
                            tx_data <= rx_shift_reg(8 downto 1); --Temporary signal that links tx_data directly to rx_data, remove later
                        else
--                            rx_ready <= '0';
                            tx_start_rx_ready_sig <= '0';--replace this with upper line after working
                        end if;
                    if rx_active = '0' then
                        if rx = '0' then  -- Detect start bit
                            rx_active <= '1';
                            rx_tick_count <= 0;
                            rx_bit_count <= 1;
                            rx_shift_reg <= rx & rx_shift_reg(9 downto 1); 
                        end if;
                    else -- rx_active = '1'
                                                              
                           
                            rx_shift_reg <= rx & rx_shift_reg(9 downto 1);  -- Shift in received bit
                            if rx_bit_count = 9 then  -- Stop bit received
--                                rx_data <= rx_shift_reg(8 downto 1);  -- Extract data byte
                                rx_sample_flag <= '1';
--                                rx_ready <= '1';
                                rx_active <= '0';
                                rx_bit_count <= 0;
                            else
                                
                                rx_bit_count <= rx_bit_count + 1;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
    end process;

end Behavioral;

