----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2024 10:59:19 AM
-- Design Name: 
-- Module Name: tb_UART - Behavioral
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

entity tb_UART is
    -- No ports for the testbench entity
end tb_UART;

architecture Behavioral of tb_UART is

    -- Component declaration of UART
    component UART is
        Port (
            clk_100M         : in  STD_LOGIC;  -- 100MHz clock
            reset       : in  STD_LOGIC;  -- Asynchronous reset
            rx          : in  STD_LOGIC;  -- UART receive line (from PC)
            tx          : out STD_LOGIC;  -- UART transmit line (to PC)
            rx_data     : out STD_LOGIC_VECTOR(7 downto 0); -- Received data byte
            rx_ready    : out STD_LOGIC;  -- Data ready flag
            tx_data     : in  STD_LOGIC_VECTOR(7 downto 0); -- Data to send
            tx_start    : in  STD_LOGIC;  -- Start transmission flag
            tx_busy     : out STD_LOGIC   -- Transmitter busy flag
        );
    end component;

    -- Internal signals
    signal clk_tb      : STD_LOGIC := '0';      -- Testbench clock
    signal reset   : STD_LOGIC := '0';      -- Testbench reset
--    signal rx_tb       : STD_LOGIC := '1';      -- UART RX signal (idle high)
--    signal tx_tb       : STD_LOGIC;             -- UART TX signal
    signal uart_rx            : std_logic := '1';
    signal uart_tx            : std_logic := '1';
    signal rx_data_tb  : STD_LOGIC_VECTOR(7 downto 0);  -- Received data
    signal rx_ready_tb : STD_LOGIC;             -- Data ready flag
    signal tx_data_tb  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); -- Data to send
    signal tx_start_tb : STD_LOGIC := '0';      -- Start transmission flag
    signal tx_busy_tb  : STD_LOGIC;             -- Transmitter busy flag

    -- Constants
    constant CLK_PERIOD : time := 10 ns;  -- 100 MHz clock period
    constant CLK_FREQ : integer := 100000000;  -- 100MHz clock frequency
    constant BAUD_RATE : integer := 9600;      -- Baud rate
    constant BAUD_TICKS : integer := CLK_FREQ / BAUD_RATE;
    constant baud_period : time := 104.167 us;
    type uart_data_array is array (0 to 6) of STD_LOGIC_VECTOR(7 downto 0);
    constant uart_data : uart_data_array := (x"48", x"65", x"6c", x"6c", x"6f", x"57", x"6f"); --"HelloWo"
begin

    -- Instantiate the UART component
    uut_UART: UART
        port map(
            clk_100M         => clk_tb,
            reset       => reset,
            rx          => uart_rx,
            tx          => uart_tx,
            rx_data     => rx_data_tb,
            rx_ready    => rx_ready_tb,
            tx_data     => tx_data_tb,
--            tx_start    => tx_start_tb,
            tx_start => rx_ready_tb,
            tx_busy     => tx_busy_tb
        );

    -- Clock generation process
    clk_process : process
    begin
        while True loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process to apply reset and test the DUT
    stimulus_process: process
    begin
        wait for 20 us;
        -- Initial reset
        reset <= '1';
        wait for 20 us;  -- Hold reset for 100 ns

        -- Release reset
        reset <= '0';

        -- Wait for some time to observe behavior
        wait for 2 ms;
        -- Start sending the UART data (the string "Hello" in ASCII)
        -- ASCII values for "Hello" are: 'H' = 0x48, 'e' = 0x65, 'l' = 0x6C, 'l' = 0x6C, 'o' = 0x6F
        for j in 0 to 6 loop
            -- Start bit
            uart_rx <= '0';
            wait for baud_period;

            -- Sending 8 data bits for each character in "Hello"
            for i in 0 to 7 loop
                uart_rx <= uart_data(j)(i);
                wait for baud_period;
            end loop;

            -- Stop bit
            uart_rx <= '1';
            wait for baud_period * 5;
        end loop;

        -- Check if tx_busy_test remains high after "Hello" transmission
        wait for clk_period * 100;

        -- Start sending the UART data (the string "Hello" in ASCII)
        -- ASCII values for "Hello" are: 'H' = 0x48, 'e' = 0x65, 'l' = 0x6C, 'l' = 0x6C, 'o' = 0x6F
        wait for 20 ms;
        for n in 0 to 6 loop
            -- Start bit
            uart_rx <= '0';
            wait for baud_period;

            -- Sending 8 data bits for each character in "Hello"
            for m in 0 to 7 loop
                uart_rx <= uart_data(n)(m);
                wait for baud_period;
            end loop;

            -- Stop bit
            uart_rx <= '1';
            wait for baud_period * 5;
        end loop;

        -- End of the testbench
        wait;
    end process stimulus_process;

--    -- Test procedure
--    rx_process : process
--    begin
--        -- Reset the UART
--        reset_tb <= '1';
--        wait for 100 us;
--        reset_tb <= '0';
--        wait for 100 us;

----        -- Transmit a byte (0x55) via UART
----        tx_data_tb <= "01010101";  -- Data to be transmitted
----        tx_start_tb <= '1';  -- Start transmission
----        wait for 20 us;  -- Wait for one clock cycle
----        tx_start_tb <= '0';  -- Deassert tx_start

----        -- Wait for the transmission to finish
----        wait until tx_busy_tb = '0';
----        wait for 100 ns;

----        -- Transmit a byte (0x6C) via UART
----        tx_data_tb <= "01101100";  -- Data to be transmitted
----        tx_start_tb <= '1';  -- Start transmission
----        wait for 20 us;  -- Wait for one clock cycle
----        tx_start_tb <= '0';  -- Deassert tx_start

----        -- Wait for the transmission to finish
----        wait until tx_busy_tb = '0';
----        wait for 100 ns;
        
----                -- Transmit a byte (0x94) via UART
----        tx_data_tb <= "10010100";  -- Data to be transmitted
----        tx_start_tb <= '1';  -- Start transmission
----        wait for 20 us;  -- Wait for one clock cycle
----        tx_start_tb <= '0';  -- Deassert tx_start

----        -- Wait for the transmission to finish
----        wait until tx_busy_tb = '0';
----        wait for 100 ns;

--        -- Simulate receiving a bytes (0xB5, 0x6C) (10110101,01101100) from UART by manually driving rx_tb
--        -- Format for 8N1: Start bit (0), 8 data bits, Stop bit (1)
--        rx_tb <= '0';  -- Start bit
--        wait for BAUD_TICKS * CLK_PERIOD;  -- Baud period (assuming 9600 baud rate)

--        -- Send data bits (LSB first)
----        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Start_bit
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 0
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 1
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 2
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 3
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 4
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 5
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 6
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 7
--        -- Stop bit
--        rx_tb <= '1';  
--        wait for BAUD_TICKS * CLK_PERIOD * 3;
        


--        rx_tb <= '0';  -- Start bit
--        wait for BAUD_TICKS * CLK_PERIOD;  -- Baud period (assuming 9600 baud rate)
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 0
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 1
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 2
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 3
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 4
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 5
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 6
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 7
--        -- Stop bit
--        rx_tb <= '1';  
--        wait for BAUD_TICKS * CLK_PERIOD * 3;



--        rx_tb <= '0';  -- Start bit
--        wait for BAUD_TICKS * CLK_PERIOD;  -- Baud period (assuming 9600 baud rate)
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 0
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 1
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 2
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 3
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 4
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 5
--        rx_tb <= '0'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 6
--        rx_tb <= '1'; wait for BAUD_TICKS * CLK_PERIOD;  -- Data bit 7
--        -- Stop bit
--        rx_tb <= '1';  
--        wait for BAUD_TICKS * CLK_PERIOD * 3;


--        -- Wait for the receiver to indicate the data is ready
--        wait until rx_ready_tb = '1';

--        -- Check the received data (expected value: 0xA5)
----        assert rx_data_tb = "10110101"
----        report "Test failed: Received data does not match expected value" severity failure;

--        -- End simulation
--        wait;
--    end process;
    
--    tx_process : process
--    begin
--        wait for 1300 us;
--        tx_start_tb <= '1';  -- Start transmission
--        wait for 20 us;  -- Wait for one clock cycle
--        tx_start_tb <= '0';  -- Deassert tx_start
--        wait for BAUD_TICKS * CLK_PERIOD * 10;
--        tx_start_tb <= '1';  -- Start transmission
--        wait for 20 us;  -- Wait for one clock cycle
--        tx_start_tb <= '0';  -- Deassert tx_start
--        wait for BAUD_TICKS * CLK_PERIOD * 10;
--        tx_start_tb <= '1';  -- Start transmission
--        wait for 20 us;  -- Wait for one clock cycle
--        tx_start_tb <= '0';  -- Deassert tx_start
--        wait;
--    end process;
end Behavioral;

