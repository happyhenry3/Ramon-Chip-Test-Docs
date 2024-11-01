----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2024 12:17:19 PM
-- Design Name: 
-- Module Name: Chip - Behavioral
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

entity Chip is
    Port ( 
--           resetn : in STD_LOGIC;
--           tdc_input : in STD_LOGIC;
--           tdc_reset : in STD_LOGIC;
--           read_enable : in STD_LOGIC;
--           tdc_data_clk_in : in STD_LOGIC;
--           tdc_config_load_in : in STD_LOGIC;
           tdc_config_clk_in : in STD_LOGIC;
           tdc_config_data_in : in STD_LOGIC;
--           ro_out : out STD_LOGIC;
--           tdc_data_out : out STD_LOGIC;
           tdc_config_data_out : out STD_LOGIC);
end Chip;


architecture Structural of Chip is
    signal shift_data_in_sig: STD_LOGIC;
    signal shift_data_out_sig: STD_LOGIC;
    signal shift_clk_in_sig: STD_LOGIC;
begin
    
    -- Instantiate the config block (Shift_Register_Array)
    config_block_inst: entity work.Config_Block
        port map (
--            resetn => resetn,
            shift_clk_in    => shift_clk_in_sig,     -- Clock input for the config block
--            shift_load_in   => tdc_config_load_in,    -- Load input for the config block
            shift_data_in   => shift_data_in_sig,    -- Data input for the config block
            shift_data_next  => shift_data_out_sig    -- Data output from the config block
        );
    shift_data_in_sig <= tdc_config_data_in;
    shift_clk_in_sig <= tdc_config_clk_in;  
    tdc_config_data_out <= shift_data_out_sig;   
end Structural;

