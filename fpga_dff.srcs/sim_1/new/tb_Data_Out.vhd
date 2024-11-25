----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2024/11/14 12:22:17
-- Design Name: 
-- Module Name: tb_Data_Out - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_Data_Out IS
END tb_Data_Out;

ARCHITECTURE behavior OF tb_Data_Out IS

    -- Component declaration for the Data_Out entity
    COMPONENT Data_Out
        PORT(
            clk         : IN  STD_LOGIC;
            resetn      : IN  STD_LOGIC;
            button_in   : IN  STD_LOGIC;
            read_enable : OUT STD_LOGIC;
            data_clk    : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk         : STD_LOGIC := '0';
    SIGNAL resetn      : STD_LOGIC := '1';
    SIGNAL button_in   : STD_LOGIC := '0';
    SIGNAL read_enable : STD_LOGIC;
    SIGNAL data_clk    : STD_LOGIC;

    CONSTANT clk_period : time := 10 ns; 

BEGIN

    -- Instantiate the Data_Out component
    uut: Data_Out
        PORT MAP (
            clk         => clk,
            resetn      => resetn,
            button_in   => button_in,
            read_enable => read_enable,
            data_clk    => data_clk
        );

    -- Clock generation process
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Apply reset
        resetn <= '0';
        WAIT FOR 100 ns;
        resetn <= '1';
        WAIT FOR 100 ns;

        -- Test 1: Button press
        button_in <= '1';    -- Button pressed
        WAIT FOR 250 ms;       -- Hold button for a sufficient period
        button_in <= '0';    -- Button released

      
        -- End simulation after some delay
        WAIT FOR 200 ms;
        
        -- Test 1: Button press
        button_in <= '1';    -- Button pressed
        WAIT FOR 100 ms;       -- Hold button for a sufficient period
        button_in <= '0';    -- Button released
        
        WAIT;
    END PROCESS;

END behavior;

