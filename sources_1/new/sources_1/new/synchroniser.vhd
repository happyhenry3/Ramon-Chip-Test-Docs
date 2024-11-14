----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2024/11/04 16:15:51
-- Design Name: 
-- Module Name: synchroniser - Behavioral
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
use IEEE.std_logic_1164.all;

entity synchroniser is
	port(
		clk : in std_logic;
		async_in : in std_logic;
		sync_out : out std_logic
	);
end synchroniser;

architecture behavioural of synchroniser is

	signal buffered_s : std_logic;

begin

	p_reg: process(clk)
	begin
		if rising_edge(clk) then
			buffered_s <= async_in;
			sync_out <= buffered_s;
		end if;
	end process;

end behavioural;
