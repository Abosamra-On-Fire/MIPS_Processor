LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PC_tb IS
END PC_tb;

ARCHITECTURE Behavioral OF PC_tb IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT PC_UNIT
        PORT (
            clk       : IN STD_LOGIC;
            reset     : IN STD_LOGIC;
            pc_select : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to connect to the UUT
    SIGNAL clk_tb       : STD_LOGIC := '0';
    SIGNAL reset_tb     : STD_LOGIC := '0';
    SIGNAL pc_select_tb : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL pc_tb        : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period constant
    CONSTANT clk_period : TIME := 10 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: PC_UNIT
        PORT MAP (
            clk       => clk_tb,
            reset     => reset_tb,
            pc_select => pc_select_tb,
            pc        => pc_tb
        );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        clk_tb <= '0';
        WAIT FOR clk_period / 2;
        clk_tb <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Test Case 1: Reset the PC
        reset_tb <= '1';
        WAIT FOR clk_period;
        reset_tb <= '0';
        WAIT FOR clk_period;

        -- Test Case 2: Increment PC
        pc_select_tb <= "000"; -- Enable increment
        WAIT FOR 5 * clk_period; -- Observe PC incrementing for 5 clock cycles

        -- Test Case 3: Hold PC
        pc_select_tb <= "001"; -- Disable increment
        WAIT FOR 3 * clk_period; -- Observe PC holding the current value

        -- Test Case 4: Reset again
        reset_tb <= '1';
        WAIT FOR clk_period;
        reset_tb <= '0';

        -- Test Case 5: Increment PC again
        pc_select_tb <= "000";
        WAIT FOR 5 * clk_period;

        -- Stop the simulation
        WAIT;
    END PROCESS;
END Behavioral;
