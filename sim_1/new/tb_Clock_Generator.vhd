----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2024 06:41:09 PM
-- Design Name: 
-- Module Name: tb_Clock_Generator - Behavioral
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

entity tb_Clock_Generator is
--  Port ( );
end tb_Clock_Generator;

architecture Behavioral of tb_Clock_Generator is

    signal clk_in: STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal clk_config : STD_LOGIC;
    signal config_load   : STD_LOGIC;
    signal config_stream_out : STD_LOGIC;
    
        -- Clock period for 100MHz clock (10ns)
    constant clk_period : time := 10 ns;

begin


    -- Instantiate the Unit Under Test (UUT)
    UUT: entity work.Clock_Generator
    Port map (
        clk_in     => clk_in,
        reset      => reset,
        clk_config => clk_config,
        config_load   => config_load,
        config_stream_out => config_stream_out
    );

    -- Clock generation process: 100MHz clock (period = 10ns)
    clk_process : process
    begin
        clk_in <= '0';
        wait for clk_period / 2;
        clk_in <= '1';
        wait for clk_period / 2;
    end process;

    -- Test process: Apply reset, observe clock and step outputs
    stimulus_process: process
    begin
        -- Apply reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        -- Wait for some time to observe the 500kHz clock and step function
        wait for 100 us;  -- Simulate for 100 microseconds
        
        -- End the simulation
        wait;
    end process;


end Behavioral;
