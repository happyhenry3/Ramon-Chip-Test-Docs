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
--           tdc_data_back : in STD_LOGIC;
           uart_rx: in STD_LOGIC;
           uart_tx: out STD_LOGIC;
--           config_data_out: in STD_LOGIC;
           config_load_inv : out STD_LOGIC;
           config_clk_inv : out STD_LOGIC;
           config_data_inv : out STD_LOGIC;
--           config_data_check : out STD_LOGIC;
           tdc_input_switch : in STD_LOGIC;
           tdc_input_inv : out STD_LOGIC;
           tdc_data_out_button : in STD_LOGIC;
--           tdc_reset : out STD_LOGIC;
           read_enable_inv : out STD_LOGIC;
           data_clk_inv : out STD_LOGIC;
           tdc_data_back : in STD_LOGIC;
           sel_uart_tx: in STD_LOGIC;
           rx_data_test: out STD_LOGIC_VECTOR(7 downto 0));
           
end Top;

architecture Behavioral of Top is

    signal reset : STD_LOGIC;
    signal config_clk_sig : STD_LOGIC;
    signal config_data_sig : STD_LOGIC;
    signal config_load_sig : STD_LOGIC;
     
    signal config_clk_en_sig : STD_LOGIC;
    
    signal tdc_input_sig : STD_LOGIC;
    signal tdc_input_switch_sync : STD_LOGIC;
    signal tdc_reset_sig : STD_LOGIC;  
    signal read_enable_sig : STD_LOGIC;
    signal data_clk_sig : STD_LOGIC;  
    signal tdc_data_out_button_sync : STD_LOGIC;
    signal tdc_data_out_button_sig : STD_LOGIC;
    signal sel_uart_tx_sync, sel_uart_tx_sig : STD_LOGIC;
    signal uart_rx_sig : STD_LOGIC;
    signal uart_tx_sig : STD_LOGIC;
    signal uart_rx_data_sig : STD_LOGIC_VECTOR(7 downto 0);
    signal uart_tx_config_data_sig : STD_LOGIC_VECTOR(7 downto 0);
    signal uart_tx_config_start_sig : STD_LOGIC;
    signal uart_tx_tdc_data_sig: STD_LOGIC_VECTOR(7 downto 0);
    signal uart_tx_tdc_start_sig : STD_LOGIC;
    signal uart_tx_selected_data_sig : STD_LOGIC_VECTOR(7 downto 0);
    signal uart_tx_selected_start_sig : STD_LOGIC;
    signal uart_rx_ready_sig : STD_LOGIC;
    signal uart_tx_busy_sig : STD_LOGIC;
    signal uart_rx_data_test_sig: STD_LOGIC;

    signal uart_rx_sync: STD_LOGIC;
    signal config_data_back_sync: STD_LOGIC;
    signal config_data_back_inv: STD_LOGIC;
    signal tdc_data_back_sync: STD_LOGIC;
    signal tdc_data_back_inv: STD_LOGIC;
    
begin

    reset <= not resetn;
    config_clk_inv <= not config_clk_sig;
    config_data_inv <= not config_data_sig;
    config_load_inv <= not config_load_sig;
    config_data_back_inv <= not config_data_back_sync;
    tdc_data_back_inv <= not tdc_data_back_sync;
    tdc_input_inv <= not tdc_input_sig;
    read_enable_inv <= not read_enable_sig;
    data_clk_inv <= not data_clk_sig;
    
    sync_sel_uart_tx: entity work.synchroniser
    Port map (
        clk => clk_100M,
        async_in => sel_uart_tx,
        sync_out => sel_uart_tx_sync
    );

    sel_uart_tx_debounce: entity work.debounce
    Port map (
        clk => clk_100M,
        reset_n => resetn,
        button => sel_uart_tx_sync,
        result => sel_uart_tx_sig
    );

    sync_uart_rx: entity work.synchroniser
    Port map (
        clk => clk_100M,
        async_in => uart_rx,
        sync_out => uart_rx_sync
    );

    sync_config_data_from_opto: entity work.synchroniser
    Port map (
        clk => clk_100M,
        async_in => config_data_back,
        sync_out => config_data_back_sync
    );

    sync_tdc_input: entity work.synchroniser
    Port map (
        clk => clk_100M,
        async_in => tdc_input_switch,
        sync_out => tdc_input_switch_sync
    );

    tdc_input_debounce: entity work.debounce
    Port map (
        clk => clk_100M,
        reset_n => resetn,
        button => tdc_input_switch_sync,
        result => tdc_input_sig
    );

    sync_tdc_out: entity work.synchroniser
    Port map (
        clk => clk_100M,
        async_in => tdc_data_out_button,
        sync_out => tdc_data_out_button_sync
    );
    
    tdc_data_out_debounce: entity work.debounce
    Port map (
        clk => clk_100M,
        reset_n => resetn,
        button => tdc_data_out_button_sync,
        result => tdc_data_out_button_sig
    );
    
    sync_tdc_data_back: entity work.synchroniser
    Port map (
        clk => clk_100M,
        async_in => tdc_data_back,
        sync_out => tdc_data_back_sync
    );

    UART: entity work.UART
    Port map (
        clk_100M => clk_100M,  -- 100MHz clock
        reset => reset, -- Asynchronous reset
        rx => uart_rx_sync,  -- UART receive line (from PC)
        tx => uart_tx,  -- UART transmit line (to PC)
        rx_data => uart_rx_data_sig, -- Received data byte
        rx_ready => uart_rx_ready_sig,  -- Data ready flag
        tx_data => uart_tx_selected_data_sig, -- Data to send
        tx_start => uart_tx_selected_start_sig,  -- Start transmission flag
        tx_busy => uart_tx_busy_sig  -- Transmitter busy flag
    );
    
--    sel_uart_tx_process: process(sel_uart_tx_sig, uart_tx_tdc_data_sig, uart_tx_tdc_start_sig, uart_tx_config_data_sig, uart_tx_config_start_sig)
--        begin
--            if sel_uart_tx_sig = '1' then
--                uart_tx_selected_data_sig <= uart_tx_tdc_data_sig;
--                uart_tx_selected_start_sig <= uart_tx_tdc_start_sig;
--            else
--                uart_tx_selected_data_sig <= uart_tx_config_data_sig;
--                uart_tx_selected_start_sig <= uart_tx_config_start_sig;
--            end if;
--        end process;
                
       uart_tx_selected_data_sig <= uart_tx_tdc_data_sig when sel_uart_tx_sig = '1' else uart_tx_config_data_sig;
       uart_tx_selected_start_sig <= uart_tx_tdc_start_sig when sel_uart_tx_sig = '1' else uart_tx_config_start_sig;

    
    keep_on_process: process(clk_100M, reset)
        begin
            if rising_edge(clk_100M) then
                if reset = '1' then
                    rx_data_test <= "00000000";
                else 
                    for i in 0 to 7 loop
                        if uart_rx_data_sig(i) = '1' then   
                            rx_data_test(i) <= '1';
                        end if;
                    end loop;    
                end if;
            end if;
        end process;

    Config_In_Shifter: entity work.Config_In_Shifter
    Port map (
        clk => clk_100M,
        reset => reset,
        uart_rx_data => uart_rx_data_sig,
        uart_rx_ready => uart_rx_ready_sig,
        last_bit_out => config_data_sig,
        config_clk => config_clk_sig,
        config_clk_en => config_clk_en_sig,
        config_load => config_load_sig
    );
    
    Config_Out_Shifter: entity work.Config_Out_Shifter
    Port map (
        clk => clk_100M,
        config_clk_en => config_clk_en_sig,
        reset => reset,
        data_back => config_data_back_inv,
        uart_tx_data => uart_tx_config_data_sig,
        uart_tx_start => uart_tx_config_start_sig
    );
    
   Data_Out: entity work.Data_Out
   Port map (
        clk => clk_100M,
        resetn => resetn,
        button_in => tdc_data_out_button_sig,
        read_enable => read_enable_sig,
        data_clk => data_clk_sig
   );
    
   Data_Out_Shifter: entity work.Data_Out_Shifter
   Port map (
        clk => clk_100M,
        reset => reset,
        tdc_data_back => tdc_data_back_inv,
        tdc_data_clk => data_clk_sig,
        uart_tx_start => uart_tx_tdc_start_sig,
        uart_tx_data => uart_tx_tdc_data_sig        
   );

end Behavioral;
