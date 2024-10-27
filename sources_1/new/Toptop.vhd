----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2024 04:25:13 PM
-- Design Name: 
-- Module Name: Toptop - Behavioral
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

entity Toptop is
    Port ( clk_100M : in STD_LOGIC;
           reset : in STD_LOGIC;
           uart_rx : in STD_LOGIC;
           config_data_out : out STD_LOGIC;
           tdc_data_out : out STD_LOGIC);
end Toptop;

architecture Structural of Toptop is

    -- Internal signals for the `Top` entity connections
    signal config_load_sig  : STD_LOGIC;
    signal config_clk_sig   : STD_LOGIC;
    signal config_data_sig  : STD_LOGIC;
    signal config_data_out_sig : STD_LOGIC;
--    signal config_data_check_sig : STD_LOGIC;
    signal tdc_input_sig    : STD_LOGIC;
    signal tdc_reset_sig    : STD_LOGIC;
    signal read_enable_sig  : STD_LOGIC;
    signal data_clk_sig     : STD_LOGIC;
    
    signal ro_out_sig       : STD_LOGIC;
    signal tdc_data_out_sig : STD_LOGIC;
--    signal chip_config_data_out_sig : STD_LOGIC;
begin

    -- Instantiate the `Top` module
    Top: entity work.Top
        Port map (
            clk_100M          => clk_100M,          -- 100MHz clock input
            reset             => reset,     
            config_data_back  => config_data_out_sig,
            tdc_data_back     => tdc_data_out_sig,        -- Reset signal
            uart_rx => uart_rx,
--            config_data_out   => config_data_out_sig,   -- Configuration data out input
            config_load       => config_load_sig,   -- Internal load signal
            config_clk        => config_clk_sig,    -- Internal clock signal
            config_data       => config_data_sig,   -- Configuration data signal
--            config_data_check => config_data_check_sig, -- Configuration data check output
            tdc_input         => tdc_input_sig,     -- TDC input signal
            tdc_reset         => tdc_reset_sig,     -- TDC reset signal
            read_enable       => read_enable_sig,   -- Read enable signal
            data_clk          => data_clk_sig       -- Data clock signal
        );
        
    Chip: entity work.Chip
        Port map (
            tdc_input            => tdc_input_sig,         -- Input from Top
            tdc_reset            => tdc_reset_sig,         -- Reset from Top
            read_enable          => read_enable_sig,       -- Read enable from Top
            tdc_data_clk_in      => data_clk_sig,          -- Data clock from Top
            tdc_config_load_in   => config_load_sig,       -- Config load signal from Top
            tdc_config_clk_in    => config_clk_sig,        -- Config clock signal from Top
            tdc_config_data_in   => config_data_sig,       -- Config data signal from Top
            ro_out               => ro_out_sig,            -- RO output (internal signal)
            tdc_data_out         => tdc_data_out_sig,      -- TDC data output (internal signal)
            tdc_config_data_out  => config_data_out_sig  -- Config data output (internal signal)
        );
        
        config_data_out <= config_data_out_sig;
        tdc_data_out <= tdc_data_out_sig;
        
        
end Structural;
