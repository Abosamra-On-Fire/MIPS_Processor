LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY reg_tb IS
END reg_tb;

ARCHITECTURE Behavioral OF reg_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT reg
        GENERIC (
            SIZE : INTEGER := 128
        );
        PORT (
            clk : IN STD_LOGIC;
            Data_in : IN STD_LOGIC_VECTOR (SIZE - 1 DOWNTO 0);
            en : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            Data_out : OUT STD_LOGIC_VECTOR (SIZE - 1 DOWNTO 0);
            flage_flush : IN STD_LOGIC
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL Data_in : STD_LOGIC_VECTOR (127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL en : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL Data_out : STD_LOGIC_VECTOR (127 DOWNTO 0);
    SIGNAL flage_flush : STD_LOGIC := '0';

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut_reg : reg
    GENERIC MAP(
        SIZE => 128
    )
    PORT MAP(
        clk => clk,
        Data_in => Data_in,
        en => en,
        rst => rst,
        Data_out => Data_out,
        flage_flush => flage_flush
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
    stim_proc : PROCESS
    BEGIN
        -- Test Case 1: Reset the register
        rst <= '1';
        WAIT FOR clk_period;
        rst <= '0';
        WAIT FOR clk_period;
        ASSERT (Data_out = X"00000000000000000000000000000000")
        REPORT "Test Case 1 Failed: Register was not reset correctly"
            SEVERITY ERROR;

        -- Test Case 2: Load data into the register
        Data_in <= X"1234567890ABCDEF1234567890ABCDEF";
        en <= '1';
        WAIT FOR clk_period;
        ASSERT (Data_out = X"1234567890ABCDEF1234567890ABCDEF")
        REPORT "Test Case 2 Failed: Data was not loaded into the register correctly"
            SEVERITY ERROR;

        -- Test Case 3: Flush the register
        flage_flush <= '1';
        WAIT FOR clk_period;
        flage_flush <= '0';
        ASSERT (Data_out = X"00000000000000000000000000000000")
        REPORT "Test Case 3 Failed: Register was not flushed correctly"
            SEVERITY ERROR;

        -- Test Case 4: Hold data in the register
        Data_in <= X"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        en <= '0';
        WAIT FOR clk_period;
        ASSERT (Data_out = X"00000000000000000000000000000000")
        REPORT "Test Case 4 Failed: Data was not held in the register correctly"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;

END Behavioral;