LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Stack_tb IS
END Stack_tb;

ARCHITECTURE Behavioral OF Stack_tb IS
    -- Component declaration for the Stack
    COMPONENT Stack
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            stack_write : IN STD_LOGIC;
            stack_add : IN STD_LOGIC;
            stack_pointer : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to connect to the Stack component
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL stack_write : STD_LOGIC := '0';
    SIGNAL stack_add : STD_LOGIC := '0';
    SIGNAL stack_pointer : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Stack component
    uut : Stack
    PORT MAP(
        clk => clk,
        reset => reset,
        stack_write => stack_write,
        stack_add => stack_add,
        stack_pointer => stack_pointer
    );

    -- Clock generation process
    clk_process : PROCESS
    BEGIN
        clk <= '1';
        WAIT FOR clk_period / 2;
        clk <= '0';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Test Case 1: Reset the stack and check the initial value (should be 0x0FFF)
        reset <= '1'; -- Activate reset
        WAIT FOR clk_period;
        ASSERT stack_pointer = X"0FFF"
        REPORT "Test Case 1 Failed: Initial stack pointer value is incorrect"
            SEVERITY ERROR;
        reset <= '0'; -- Deactivate reset

        -- Test Case 2: Push operation (stack_add = '1', stack_write = '1')
        stack_add <= '1'; -- Push operation
        stack_write <= '1'; -- Enable writing to the stack pointer
        WAIT FOR clk_period; -- Wait for one clock cycle
        ASSERT stack_pointer = X"0FFF"
        REPORT "Test Case 2 Failed: Stack pointer not incremented correctly"
            SEVERITY ERROR;

        -- Test Case 3: Push again (stack pointer should be 0x1000 -> 0x1001)
        WAIT FOR clk_period;
        ASSERT stack_pointer = X"0FFE"
        REPORT "Test Case 4 Failed: Stack pointer not incremented correctly"
            SEVERITY ERROR;

        WAIT FOR clk_period;
        ASSERT stack_pointer = X"0FFD"
        REPORT "Test Case 5 Failed: Stack pointer not incremented correctly"
            SEVERITY ERROR;

        WAIT FOR clk_period;
        ASSERT stack_pointer = X"0FFC"
        REPORT "Test Case 6 Failed: Stack pointer not incremented correctly"
            SEVERITY ERROR;

        -- Test Case 4: Pop operation (stack_add = '0', stack_write = '1')
        stack_add <= '0'; -- Pop operation
        WAIT FOR clk_period; -- Wait for one clock cycle
        ASSERT stack_pointer = X"0FFC"
        REPORT "Test Case 4 Failed: Stack pointer not decremented correctly"
            SEVERITY ERROR;

        -- Test Case 5: Pop again (stack pointer should be 0x1000 -> 0x0FFF)
        WAIT FOR clk_period;
        ASSERT stack_pointer = X"0FFD"
        REPORT "Test Case 5 Failed: Stack pointer not decremented correctly"
            SEVERITY ERROR;

        -- Test Case 6: No change in stack pointer when stack_write = '0'
        stack_add <= '0'; -- Push operation
        stack_write <= '0'; -- Disable writing to the stack pointer
        WAIT FOR clk_period; -- Wait for one clock cycle
        ASSERT stack_pointer = X"0FFD"
        REPORT "Test CASE 6 Failed : Stack pointer should NOT change when stack_write = '0'"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;

END Behavioral;