library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Top_tb is
end Top_tb;

architecture Behavioral of Top_tb is

    -- Clock period for 100MHz clock
    constant clk_period : time := 10 ns;

    -- Baud rate period for 9600 bps
    constant baud_period : time := 104.167 us;

    -- Component signals
    signal clk_100M : STD_LOGIC := '0';
    signal resetn : STD_LOGIC := '1';
    signal config_data_back : STD_LOGIC := '0';
    signal tdc_data_back : STD_LOGIC := '0';
    signal uart_rx : STD_LOGIC := '1';
    signal uart_tx : STD_LOGIC;
    signal config_load : STD_LOGIC;
    signal config_clk : STD_LOGIC;
    signal config_data : STD_LOGIC;
    signal tdc_input_switch : STD_LOGIC;
    signal tdc_data_out_button : STD_LOGIC;
    signal tdc_input : STD_LOGIC;
    signal tdc_reset : STD_LOGIC;
    signal read_enable_inv : STD_LOGIC;
    signal data_clk_inv : STD_LOGIC;
    signal test_fpga_sw7 : STD_LOGIC := '0';
    signal test_fpga_led7 : STD_LOGIC;
    signal test_fpga_buttonc : STD_LOGIC := '0';
    signal test_fpga_led6 : STD_LOGIC;
    signal tx_busy_test : STD_LOGIC;

    -- Characters in "Hello" in ASCII
    type uart_data_array is array (0 to 6) of STD_LOGIC_VECTOR(7 downto 0);
    constant uart_data : uart_data_array := (x"49", x"65", x"6c", x"6c", x"6f", x"57", x"6f");
    constant config_clk_period : time := 5 ms; --500 us
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.Top
        Port map (
            clk_100M => clk_100M,
            resetn => resetn,
            config_data_back => config_data_back,
--            tdc_data_back => tdc_data_back,
            uart_rx => uart_rx,
            uart_tx => uart_tx,
            config_load_inv => config_load,
            config_clk_inv => config_clk,
            config_data_inv => config_data,
            tdc_input_switch => tdc_input_switch,
            tdc_input_inv => tdc_input_switch,
            tdc_data_out_button => tdc_data_out_button,
--           tdc_reset : out STD_LOGIC;
            read_enable_inv => read_enable_inv,
            data_clk_inv => data_clk_inv
--            tdc_reset => tdc_reset,
--            read_enable => read_enable,
--            data_clk => data_clk
--            test_fpga_sw7 => test_fpga_sw7,
--            test_fpga_led7 => test_fpga_led7,
--            test_fpga_buttonc => test_fpga_buttonc,
--            test_fpga_led6 => test_fpga_led6,
--            tx_busy_test => tx_busy_test
        );

    -- Clock generation
    clk_process: process
    begin
        clk_100M <= '0';
        wait for clk_period / 2;
        clk_100M <= '1';
        wait for clk_period / 2;
    end process;

    -- Test stimulus process
    stimulus_process: process
    begin
        -- Reset the system
        resetn <= '0';
        wait for 20 us;
        resetn <= '1';
        wait for 2 ms;

        -- Start sending the UART data (the string "Hello" in ASCII)
        -- ASCII values for "Hello" are: 'H' = 0x48, 'e' = 0x65, 'l' = 0x6C, 'l' = 0x6C, 'o' = 0x6F
        for m in 0 to 6 loop
            wait for baud_period;
            -- Start bit
            uart_rx <= '0';
            wait for baud_period;

            -- Sending 8 data bits for each character in "Hello"
            for n in 0 to 7 loop
                uart_rx <= uart_data(m)(n);
                wait for baud_period;
            end loop;

            -- Stop bit
            uart_rx <= '1';
            
        end loop;

        -- Check if tx_busy_test remains high after "Hello" transmission
--        wait for clk_period * 100;
--        wait for config_clk_period;
        wait for 52 us;
        for j in 0 to 6 loop
            -- Sending 8 data bits for each character in "Hello"
            for i in 0 to 7 loop
                config_data_back <= not uart_data(j)(i);
                wait for config_clk_period;
            end loop;

        end loop;
--        assert (tx_busy_test = '1')
--        report "tx_busy_test did not remain high after transmission."
--        severity failure;

        -- End simulation
        wait;
    end process;

end Behavioral;

