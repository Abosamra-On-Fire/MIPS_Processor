LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU_Forward_tb IS
END ALU_Forward_tb;

ARCHITECTURE Behavioral OF ALU_Forward_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT ALU_Forward
        PORT (
            r1, r2, r1_forward_mem, r2_forward_mem, r1_forward_wb, r2_forward_wb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            op1, op2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            r1_out, r2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL r1, r2, r1_forward_mem, r2_forward_mem, r1_forward_wb, r2_forward_wb : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL op1, op2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL r1_out, r2_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut_ALU_Forward : ALU_Forward
    PORT MAP(
        r1 => r1,
        r2 => r2,
        r1_forward_mem => r1_forward_mem,
        r2_forward_mem => r2_forward_mem,
        r1_forward_wb => r1_forward_wb,
        r2_forward_wb => r2_forward_wb,
        op1 => op1,
        op2 => op2,
        r1_out => r1_out,
        r2_out => r2_out
    );

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Test Case 1: op1 = "00", op2 = "00"
        r1 <= X"1234";
        r2 <= X"5678";
        r1_forward_mem <= X"0000";
        r2_forward_mem <= X"0000";
        r1_forward_wb <= X"0000";
        r2_forward_wb <= X"0000";
        op1 <= "00";
        op2 <= "00";
        WAIT FOR clk_period;
        ASSERT (r1_out = X"1234" AND r2_out = X"5678")
        REPORT "Test Case 1 Failed: r1_out or r2_out incorrect"
            SEVERITY ERROR;

        -- Test Case 2: op1 = "01", op2 = "01"
        r1 <= X"0000";
        r2 <= X"0000";
        r1_forward_mem <= X"1234";
        r2_forward_mem <= X"5678";
        r1_forward_wb <= X"0000";
        r2_forward_wb <= X"0000";
        op1 <= "01";
        op2 <= "01";
        WAIT FOR clk_period;
        ASSERT (r1_out = X"1234" AND r2_out = X"5678")
        REPORT "Test Case 2 Failed: r1_out or r2_out incorrect"
            SEVERITY ERROR;

        -- Test Case 3: op1 = "10", op2 = "10"
        r1 <= X"0000";
        r2 <= X"0000";
        r1_forward_mem <= X"0000";
        r2_forward_mem <= X"0000";
        r1_forward_wb <= X"1234";
        r2_forward_wb <= X"5678";
        op1 <= "10";
        op2 <= "10";
        WAIT FOR clk_period;
        ASSERT (r1_out = X"1234" AND r2_out = X"5678")
        REPORT "Test Case 3 Failed: r1_out or r2_out incorrect"
            SEVERITY ERROR;

        -- Test Case 4: op1 = "11", op2 = "11" (default case)
        r1 <= X"0000";
        r2 <= X"0000";
        r1_forward_mem <= X"0000";
        r2_forward_mem <= X"0000";
        r1_forward_wb <= X"1234";
        r2_forward_wb <= X"5678";
        op1 <= "01";
        op2 <= "10";
        WAIT FOR clk_period;
        ASSERT (r1_out = X"0000" AND r2_out = X"5678")
        REPORT "Test Case 4 Failed: r1_out or r2_out incorrect"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;

END Behavioral;