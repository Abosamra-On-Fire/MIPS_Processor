LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Branch_tb IS
END Branch_tb;

ARCHITECTURE Behavioral OF Branch_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT Branch
        PORT (
            branch_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            conditional_branch : IN STD_LOGIC;
            flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            branch_flage : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL branch_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL conditional_branch : STD_LOGIC;
    SIGNAL flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL branch_flage : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut_Branch : Branch
    PORT MAP(
        branch_sel => branch_sel,
        conditional_branch => conditional_branch,
        flags => flags,
        branch_flage => branch_flage
    );

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Test Case 1: Conditional branch is '0', branch_flage should be '0'
        branch_sel <= "00";
        conditional_branch <= '0';
        flags <= "101";
        WAIT FOR clk_period;
        ASSERT (branch_flage = '0')
        REPORT "Test Case 1 Failed: branch_flage should be '0' when conditional_branch is '0'"
            SEVERITY ERROR;

        -- Test Case 2: Conditional branch is '1', branch_sel = "00", flags = "101"
        branch_sel <= "00";
        conditional_branch <= '1';
        flags <= "101";
        WAIT FOR clk_period;
        ASSERT (branch_flage = '1')
        REPORT "Test Case 2 Failed: branch_flage should be '1' when branch_sel = '00' and flags = '101'"
            SEVERITY ERROR;

        -- Test Case 3: Conditional branch is '1', branch_sel = "01", flags = "101"
        branch_sel <= "01";
        conditional_branch <= '1';
        flags <= "101";
        WAIT FOR clk_period;
        ASSERT (branch_flage = '0')
        REPORT "Test Case 3 Failed: branch_flage should be '0' when branch_sel = '01' and flags = '101'"
            SEVERITY ERROR;

        -- Test Case 4: Conditional branch is '1', branch_sel = "10", flags = "101"
        branch_sel <= "10";
        conditional_branch <= '1';
        flags <= "101";
        WAIT FOR clk_period;
        ASSERT (branch_flage = '1')
        REPORT "Test Case 4 Failed: branch_flage should be '1' when branch_sel = '10' and flags = '101'"
            SEVERITY ERROR;

        -- Test Case 5: Conditional branch is '1', branch_sel = "11", flags = "101"
        branch_sel <= "01";
        conditional_branch <= '1';
        flags <= "101";
        WAIT FOR clk_period;
        ASSERT (branch_flage = '0')
        REPORT "Test Case 5 Failed: branch_flage should be '0' when branch_sel = '11' and flags = '101'"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;

END Behavioral;