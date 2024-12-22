LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY out_port_tb IS
END out_port_tb;

ARCHITECTURE Behavioral OF out_port_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT out_port
        PORT (
            data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_port_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_port_signal : IN STD_LOGIC
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_port_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL out_port_signal : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut_out_port : out_port
    PORT MAP(
        data => data,
        out_port_data => out_port_data,
        out_port_signal => out_port_signal
    );

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Test Case 1: out_port_signal = '1', data should be passed to out_port
        data <= X"1234";
        out_port_signal <= '1';
        WAIT FOR clk_period;
        ASSERT (out_port_data = X"1234")
        REPORT "Test Case 1 Failed: out_port did not match data when out_port_signal is '1'"
            SEVERITY ERROR;

        -- Test Case 2: out_port_signal = '0', out_port should be all zeros
        data <= X"5678";
        out_port_signal <= '0';
        WAIT FOR clk_period;
        ASSERT (out_port_data = X"0000")
        REPORT "Test Case 2 Failed: out_port was not all zeros when out_port_signal is '0'"
            SEVERITY ERROR;

        -- Test Case 3: out_port_signal = '1', data should be passed to out_port
        data <= X"ABCD";
        out_port_signal <= '1';
        WAIT FOR clk_period;
        ASSERT (out_port_data = X"ABCD")
        REPORT "Test Case 3 Failed: out_port did not match data when out_port_signal is '1'"
            SEVERITY ERROR;

        -- Test Case 4: out_port_signal = '0', out_port should be all zeros
        data <= X"EF01";
        out_port_signal <= '0';
        WAIT FOR clk_period;
        ASSERT (out_port_data = X"0000")
        REPORT "Test Case 4 Failed: out_port was not all zeros when out_port_signal is '0'"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;

END Behavioral;