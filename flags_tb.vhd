LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Flag_Register_tb IS
    -- Testbench does not have any ports
END Flag_Register_tb;

ARCHITECTURE Behavioral OF Flag_Register_tb IS
    -- Component declaration for the Flag Register
    COMPONENT Flags
        PORT (
            clk : IN STD_LOGIC; -- Clock signal
            reset : IN STD_LOGIC; -- Reset signal
            load : IN STD_LOGIC; -- Load signal to update flags
            Carry_in : IN STD_LOGIC; -- Input Carry flag
            Zero_in : IN STD_LOGIC; -- Input Zero flag
            Negative_in : IN STD_LOGIC; -- Input Negative flag
            Carry_out : OUT STD_LOGIC; -- Output Carry flag
            Zero_out : OUT STD_LOGIC; -- Output Zero flag
            Negative_out : OUT STD_LOGIC; -- Output Negative flag
            flags_arr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) -- Output flags
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL load : STD_LOGIC := '0';
    SIGNAL Carry_in, Zero_in, Negative_in : STD_LOGIC := '0';
    SIGNAL Carry_out, Zero_out, Negative_out : STD_LOGIC;
    SIGNAL flags_arr : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Flag_Register component
    uut_Flag_Register : Flags
    PORT MAP(
        clk => clk,
        reset => reset,
        load => load,
        Carry_in => Carry_in,
        Zero_in => Zero_in,
        Negative_in => Negative_in,
        Carry_out => Carry_out,
        Zero_out => Zero_out,
        Negative_out => Negative_out,
        flags_arr => flags_arr
    );

    -- Clock generation
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
        -- Test Case 1: Reset the Flag Register
        reset <= '1'; -- Activate reset
        WAIT FOR clk_period;
        reset <= '0'; -- Deactivate reset
        ASSERT (Carry_out = '0' AND Zero_out = '0' AND Negative_out = '0')
        REPORT "Test Case 1 Failed: Reset did not clear flags"
            SEVERITY ERROR;
        WAIT FOR clk_period;

        -- Test Case 2: Load new flag values
        load <= '1'; -- Enable loading
        Carry_in <= '1';
        Zero_in <= '0';
        Negative_in <= '1';
        WAIT FOR clk_period;
        load <= '0'; -- Disable loading
        ASSERT (Carry_out = '1' AND Zero_out = '0' AND Negative_out = '1')
        REPORT "Test Case 2 Failed: Flags did not load correctly"
            SEVERITY ERROR;

        -- Test Case 3: Verify flags vector output
        ASSERT (flags_arr = "101") -- Carry = 1, Zero = 0, Negative = 1
        REPORT "Test Case 3 Failed: Flags vector did not match expected value"
            SEVERITY ERROR;

        -- Test Case 4: Test loading all zero flags
        load <= '1'; -- Enable loading
        Carry_in <= '0';
        Zero_in <= '1';
        Negative_in <= '0';
        WAIT FOR clk_period;
        load <= '0'; -- Disable loading
        ASSERT (Carry_out = '0' AND Zero_out = '1' AND Negative_out = '0')
        REPORT "Test Case 4 Failed: Flags did not load correctly"
            SEVERITY ERROR;

        -- Test Case 5: Test loading all flags to zero and then assert condition
        load <= '1'; -- Enable loading
        Carry_in <= '0';
        Zero_in <= '0';
        Negative_in <= '0';
        WAIT FOR clk_period;
        load <= '0'; -- Disable loading
        ASSERT (Carry_out = '0' AND Zero_out = '0' AND Negative_out = '0')
        REPORT "Test Case 5 Failed: All flags should be zero"
            SEVERITY ERROR;

        -- Test Case 6: Test flags when only negative flag is set
        load <= '1'; -- Enable loading
        Carry_in <= '0';
        Zero_in <= '0';
        Negative_in <= '1';
        WAIT FOR clk_period;
        load <= '0'; -- Disable loading
        ASSERT (Carry_out = '0' AND Zero_out = '0' AND Negative_out = '1')
        REPORT "Test Case 6 Failed: Only negative flag should be set"
            SEVERITY ERROR;

        -- End of simulation
        WAIT;
    END PROCESS;

END Behavioral;