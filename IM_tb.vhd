LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY IM_tb IS
END IM_tb;

ARCHITECTURE Behavioral OF IM_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT IM
        PORT (
            clk : IN STD_LOGIC;
            location : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            reset : IN STD_LOGIC;
            instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL location : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut_IM : IM
    PORT MAP(
        clk => clk,
        location => location,
        reset => reset,
        instruction => instruction
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
        -- Test Case 1: Reset the instruction memory
        reset <= '1';
        WAIT FOR clk_period;
        reset <= '0';
        WAIT FOR clk_period;
        ASSERT (instruction = X"0000")
        REPORT "Test Case 1 Failed: Instruction memory was not reset correctly"
            SEVERITY ERROR;

        -- Test Case 2: Read instruction from location 0
        location <= "000000000000";
        WAIT FOR clk_period;
        ASSERT (instruction = X"0000") -- Replace with the expected value from IM.txt
        REPORT "Test Case 2 Failed: Instruction at location 0 was not read correctly"
            SEVERITY ERROR;

        -- Test Case 3: Read instruction from location 1
        location <= "000000000001";
        WAIT FOR clk_period;
        ASSERT (instruction = X"4344") -- Replace with the expected value from IM.txt
        REPORT "Test Case 3 Failed: Instruction at location 1 was not read correctly"
            SEVERITY ERROR;

        -- Add more test cases as needed

        WAIT;
    END PROCESS;

END Behavioral;