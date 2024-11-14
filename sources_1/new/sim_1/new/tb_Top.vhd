----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2024 02:13:25 PM
-- Design Name: 
-- Module Name: tb_Top - Behavioral
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

entity tb_Top is
--  Port ( );
end tb_Top;

architecture Behavioral of tb_Top is


    signal clk_100M: STD_LOGIC := '0';
    signal resetn : STD_LOGIC := '0';
    signal config_clk : STD_LOGIC := '0';
    signal config_data   : STD_LOGIC := '0';
    signal config_data_back : STD_LOGIC := '0';
    signal uart_rx : STD_LOGIC := '0';
    signal uart_tx : STD_LOGIC := '0';
    signal tdc_data_back : STD_LOGIC := '0';
--    signal config_data_out: std_logic := '0';
--    signal config_data_check: STD_LOGIC := '0';
    signal config_load : STD_LOGIC := '0';
    signal tdc_input : STD_LOGIC := '0';
    signal tdc_reset : STD_LOGIC := '0';
    signal read_enable : STD_LOGIC := '0';
    signal data_clk : STD_LOGIC := '0';
    signal test_fpga_sw7 : STD_LOGIC := '0';
    signal test_fpga_led7 :  STD_LOGIC;
    signal test_fpga_buttonc : STD_LOGIC := '0';
    signal test_fpga_led6: STD_LOGIC;
    
        -- Clock period for 100MHz clock (10ns)
    constant clk_period : time := 10 ns;

component Top
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
               
               test_fpga_sw7 : in STD_LOGIC;
               test_fpga_led7 : out STD_LOGIC;
               test_fpga_buttonc : in STD_LOGIC;
               test_fpga_led6: out STD_LOGIC);
end component;

begin


    -- Instantiate the Unit Under Test (UUT)
--    UUT: entity work.Stream_Generator
--    Port map (
--        clk_in     => clk_100M,
--        reset      => reset,
--        clk_config => config_clk,
--        config_load   => config_load,
--        config_stream_out => config_data
--    );

--    UUT_TDC_Control: entity work.TDC_Control
--    Port map(
--        clk_in     => clk_100M,           -- 100MHz input clock from board
--        reset      => reset,            -- Reset signal
--        tdc_input => tdc_input,
--        tdc_reset => tdc_reset
--    );

--    UUT_Serial_Out: entity work.Serial_Out
--    Port map(
--        clk_in => clk_100M,
--        reset => reset,
--        read_enable => read_enable,
--        data_clk => data_clk
--    );
    
--    Chip: entity work.Chip
--    Port map(
--        tdc_config_load_in => config_load,
--        tdc_config_data_out => config_data_out,
--        tdc_config_clk_in => config_clk,
--        tdc_config_data_in => config_data_in,
--        tdc_input => tdc_input,
--        tdc_reset => tdc_reset,
--        read_enable => read_enable,
--        tdc_data_clk_in => data_clk
        
--    );
    
   uut_top : entity work.Top
        Port map (
            clk_100M          => clk_100M,         -- Connect 100 MHz clock
            resetn            => resetn,           -- Active-low reset
            config_data_back  => config_data_back, -- Config data back signal
            tdc_data_back     => tdc_data_back,    -- TDC data back signal
            uart_rx           => uart_rx,          -- UART receive
            uart_tx           => uart_tx,          -- UART transmit
            config_load       => config_load,      -- Config load signal
            config_clk        => config_clk,       -- Config clock signal
            config_data       => config_data,      -- Config data signal
            tdc_input         => tdc_input,        -- TDC input signal
            tdc_reset         => tdc_reset,        -- TDC reset signal
            read_enable       => read_enable,      -- Read enable signal
            data_clk          => data_clk        -- Data clock signal
--            test_fpga_sw7     => test_fpga_sw7,    -- FPGA switch 7 input
--            test_fpga_led7    => test_fpga_led7,   -- FPGA LED 7 output
--            test_fpga_buttonc => test_fpga_buttonc,-- FPGA button center input
--            test_fpga_led6    => test_fpga_led6    -- FPGA LED 6 output
        );

    -- Clock generation process: 100MHz clock (period = 10ns)
    clk_process : process
    begin
        clk_100M <= '0';
        wait for clk_period / 2;
        clk_100M <= '1';
        wait for clk_period / 2;
    end process;


    fpga_test_process : process
    begin
        wait for 50 ms;
        test_fpga_sw7 <= '1';
        wait for 50 ms;
        test_fpga_buttonc <= '1';
        wait for 50 ms;
        test_fpga_sw7 <= '0';
        wait for 20ms;
        test_fpga_buttonc <= '0';
        wait for 80 ms;
        test_fpga_sw7 <= '1';
        wait for 100ms;
    end process;        
    -- Test process: Apply reset, observe clock and step outputs
    stimulus_process: process
    begin
        -- Apply reset
        wait for 100 ms;
        resetn <= '1';
        wait for 100 ms;
        resetn <= '0';
        
        -- Wait for some time to observe the 500kHz clock and step function
        wait for 1000 ms;  -- Simulate for 100 microseconds
        
        -- End the simulation
        wait;
    end process;


end Behavioral;