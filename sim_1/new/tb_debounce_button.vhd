----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2024/11/13 12:12:49
-- Design Name: 
-- Module Name: tb_debounce_button - Behavioral
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

ENTITY tb_debounce IS
END tb_debounce;

ARCHITECTURE behavior OF tb_debounce IS

  -- Component declaration for the debounce entity
  COMPONENT debounce
    GENERIC(
      clk_freq    : INTEGER := 100_000_000;
      stable_time : INTEGER := 10);
    PORT(
      clk     : IN  STD_LOGIC;
      reset_n : IN  STD_LOGIC;
      button  : IN  STD_LOGIC;
      result  : OUT STD_LOGIC);
  END COMPONENT;

  -- Testbench signals
  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL reset_n   : STD_LOGIC := '1';
  SIGNAL button    : STD_LOGIC := '0';
  SIGNAL result    : STD_LOGIC;

  CONSTANT clk_period : time := 10 ns; -- 50 MHz clock

BEGIN

  -- Instantiate the debounce component
  uut: debounce
    GENERIC MAP (
      clk_freq => 100_000_000,    -- 50 MHz clock frequency
      stable_time => 10          -- 10 ms debounce time
    )
    PORT MAP (
      clk     => clk,
      reset_n => reset_n,
      button  => button,
      result  => result
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
  stimulus : PROCESS
    VARIABLE wait_time : time := 10 ms;
  BEGIN
    -- Apply reset
    reset_n <= '0';
    WAIT FOR 100 ns;
    reset_n <= '1';
    WAIT FOR 100 ns;

    -- Test 1: Stable press and release with no bouncing
    button <= '1';
    WAIT FOR wait_time;  -- Stable press for debounce time
    button <= '0';
    WAIT FOR wait_time;  -- Stable release for debounce time

    -- Test 2: Quick bouncing before stable press
    button <= '1';
    WAIT FOR 1 ms;  -- Simulate a bounce
    button <= '0';
    WAIT FOR 1 ms;  -- Simulate a bounce
    button <= '1';
    WAIT FOR wait_time;  -- Now press is stable
    button <= '0';
    WAIT FOR wait_time;  -- Stable release

    -- Test 3: Random bouncing both before press and release
    button <= '1';
    WAIT FOR 1 ms; button <= '0';
    WAIT FOR 1 ms; button <= '1';
    WAIT FOR 1 ms; button <= '0';
    WAIT FOR 1 ms; button <= '1';
    WAIT FOR wait_time;  -- Stable press
    button <= '0';
    WAIT FOR 1 ms; button <= '1';
    WAIT FOR 1 ms; button <= '0';
    WAIT FOR 1 ms; button <= '1';
    WAIT FOR wait_time;  -- Stable release

    -- End simulation
    WAIT;
  END PROCESS;

END behavior;
