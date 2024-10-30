----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2024 01:15:25 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity Top is
    Port ( clk_100M : in STD_LOGIC;
           resetn : in STD_LOGIC;
           config_data_back : in STD_LOGIC;
           tdc_data_back : in STD_LOGIC;
           uart_rx: in STD_LOGIC;
           uart_tx: out STD_LOGIC;
--           config_data_out: in STD_LOGIC;
           config_load : out STD_LOGIC;
           config_clk : out STD_LOGIC;
           config_data : out STD_LOGIC;
--           config_data_check : out STD_LOGIC;
           tdc_input : out STD_LOGIC;
           tdc_reset : out STD_LOGIC;
           read_enable : out STD_LOGIC;
           data_clk : out STD_LOGIC;
           rx_ready_test: out STD_LOGIC);
           
--           test_fpga_sw7 : in STD_LOGIC;
--           test_fpga_led7 : out STD_LOGIC;
--           test_fpga_buttonc : in STD_LOGIC;
--           test_fpga_led6: out STD_LOGIC;
--           tx_busy_test: out STD_LOGIC);
end Top;

architecture Behavioral of Top is

    signal reset : STD_LOGIC;
    signal config_clk_sig : STD_LOGIC;
    signal config_data_in_sig : STD_LOGIC;
    signal config_load_sig : STD_LOGIC;
    signal config_hard_stream_sig : STD_LOGIC;
    
    signal config_clk_en_sig : STD_LOGIC;
    
    signal tdc_input_sig : STD_LOGIC;
    signal tdc_reset_sig : STD_LOGIC;  
    signal read_enable_sig : STD_LOGIC;
    signal data_clk_sig : STD_LOGIC;  
    
    signal uart_rx_sig : STD_LOGIC;
    signal uart_tx_sig : STD_LOGIC;
    signal uart_rx_data_sig : STD_LOGIC_VECTOR(7 downto 0);
    signal uart_tx_data_sig : STD_LOGIC_VECTOR(7 downto 0);
    signal uart_rx_ready_sig : STD_LOGIC;
    signal uart_tx_start_sig : STD_LOGIC;
    signal uart_tx_busy_sig : STD_LOGIC;
     

begin

    reset <= not resetn;
--    test_fpga_led7 <= test_fpga_sw7;
--    test_fpga_led6 <= test_fpga_buttonc;
    UART: entity work.UART
    Port map (
        clk_100M => clk_100M,  -- 100MHz clock
        reset => reset, -- Asynchronous reset
        rx => uart_rx,  -- UART receive line (from PC)
        tx => uart_tx,  -- UART transmit line (to PC)
        rx_data => uart_rx_data_sig, -- Received data byte
        rx_ready => uart_rx_ready_sig,  -- Data ready flag
        tx_data => uart_tx_data_sig, -- Data to send
        tx_start => uart_tx_start_sig,  -- Start transmission flag
        tx_busy => uart_tx_busy_sig  -- Transmitter busy flag
    );
    
    keep_on_process: process(clk_100M, reset)
        begin
            if rising_edge(clk_100M) then
                if reset = '1' then
                    rx_ready_test <= '0';
                else 
                    if uart_rx_ready_sig = '1' then   
                        rx_ready_test <= '1';
                    end if;
                end if;
            end if;
        end process;

    Config_In_Shifter: entity work.Config_In_Shifter
    Port map (
        clk => clk_100M,
        reset => reset,
        uart_rx_data => uart_rx_data_sig,
        uart_rx_ready => uart_rx_ready_sig,
        last_bit_out => config_data,
        config_clk => config_clk_sig,
        config_clk_en => config_clk_en_sig
    );
    
    Config_Out_Shifter: entity work.Config_Out_Shifter
    Port map (
        clk => clk_100M,
        config_clk_en => config_clk_en_sig,
        reset => reset,
        data_back => config_data_back,
        uart_tx_data => uart_tx_data_sig,
        uart_tx_start => uart_tx_start_sig
    );
    
    -- Instantiate the clock generator module
    Stream_Generator: entity work.Stream_Generator
    Port map (
        clk_in     => clk_100M,           -- 100MHz input clock from board
        reset      => reset,            -- Reset signal
--        clk_config => config_clk_sig,   -- Internal signal for 20kHz clock
        config_load   => config_load_sig,      -- Internal signal for step output
        config_stream_out => config_hard_stream_sig
    );

    -- Output assignments
    config_clk <= config_clk_sig;
    config_load   <= config_load_sig;
--    config_data <= config_data_in_sig;
    
    TDC_Control: entity work.TDC_Control
    Port map(
        clk_in     => clk_100M,           -- 100MHz input clock from board
        reset      => reset,            -- Reset signal
        tdc_input => tdc_input_sig,
        tdc_reset => tdc_reset_sig
    );
    
    tdc_input <= tdc_input_sig;
    tdc_reset <= tdc_reset_sig; 
    
    Serial_Out: entity work.Serial_Out
    Port map(
        clk_in => clk_100M,
        reset => reset,
        read_enable => read_enable_sig,
        data_clk => data_clk_sig
    );
    read_enable <= read_enable_sig;
    data_clk <= data_clk_sig;
    
--    Chip: entity work.Chip
--    Port map(
--        tdc_config_load_in => config_load_sig,
--        tdc_config_data_out => config_data_out_sig,
--        tdc_config_clk_in => config_clk_sig,
--        tdc_config_data_in => config_data_in_sig,
--        tdc_input => tdc_input_sig,
--        tdc_reset => tdc_reset_sig,
--        read_enable => read_enable_sig,
--        tdc_data_clk_in => data_clk_sig
        
--    );
--    config_data_out_sig <= config_data_out;
--    config_data_check <= config_data_check_sig;

end Behavioral;
