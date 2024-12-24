LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU_tb IS
    -- Testbench entity does not have ports
END ALU_tb;

ARCHITECTURE Behavioral_Alu_Flage_tb OF ALU_tb IS
    -- Component declaration for the ALU
    COMPONENT ALU
        PORT (
            clk : IN STD_LOGIC; -- Clock signal
            reset : IN STD_LOGIC; -- Reset signal
            A : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- Input A (16 bits)
            B : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- Input B (16 bits)
            OP : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- Operation code (3 bits)
            Result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- ALU result (16 bits)
            Carry : OUT STD_LOGIC; -- Carry flag
            Zero : OUT STD_LOGIC; -- Zero flag
            Negative : OUT STD_LOGIC -- Negative flag
        );
    END COMPONENT;

    -- Signals for the ALU inputs and outputs
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL A : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL OP : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL Result : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Carry : STD_LOGIC;
    SIGNAL Zero : STD_LOGIC;
    SIGNAL Negative : STD_LOGIC;

    -- Clock generation process
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the ALU
    uut_ALU : ALU
    PORT MAP(
        clk => clk,
        reset => reset,
        A => A,
        B => B,
        OP => OP,
        Result => Result,
        Carry => Carry,
        Zero => Zero,
        Negative => Negative,

    );

    -- Clock generation
    clk_process : PROCESS
    BEGIN
        clk <= '1';
        WAIT FOR clk_period / 2;
        clk <= '0';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process to test ALU operations with assertions
    stimulus_process : PROCESS
    BEGIN
        -- Test case 1: Reset the ALU
        reset <= '1'; -- Apply reset
        WAIT FOR clk_period;
        ASSERT Result = X"0000" AND Carry = '0' AND Zero = '1' AND Negative = '0'
        REPORT "Test case 1 (Reset): FAILED"
            SEVERITY ERROR;
        reset <= '0'; -- Deactivate reset
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update

        -- Test case 2: NOT operation
        A <= X"FFFF"; -- A = 1111 1111 1111 1111
        OP <= "000"; -- OP = NOT
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"0000" AND Carry = '0' AND Zero = '1' AND Negative = '0'
        REPORT "Test case 2 (NOT): FAILED"
            SEVERITY ERROR;

        -- Test case 3: Increment operation
        A <= X"0001"; -- A = 0000 0000 0000 0001
        OP <= "001"; -- OP = INC
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"0002" AND Carry = '0' AND Zero = '0' AND Negative = '0'
        REPORT "Test case 3 (INC): FAILED"
            SEVERITY ERROR;

        -- Test case 4: ADD operation
        A <= X"000F"; -- A = 0000 0000 0000 1111
        B <= X"0001"; -- B = 0000 0000 0000 0001
        OP <= "010"; -- OP = ADD
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"0010" AND Carry = '0' AND Zero = '0' AND Negative = '0'
        REPORT "Test case 4 (ADD): FAILED"
            SEVERITY ERROR;

        -- Test case 5: SUB operation
        A <= X"0010"; -- A = 0000 0000 0001 0000
        B <= X"000F"; -- B = 0000 0000 0000 1111
        OP <= "011"; -- OP = SUB
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"0001" AND Carry = '0' AND Zero = '0' AND Negative = '0'
        REPORT "Test case 5 (SUB): FAILED"
            SEVERITY ERROR;

        -- Test case 6: AND operation
        A <= X"FFFF"; -- A = 1111 1111 1111 1111
        B <= X"0F0F"; -- B = 0000 1111 0000 1111
        OP <= "100"; -- OP = AND
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"0F0F" AND Carry = '0' AND Zero = '0' AND Negative = '0'
        REPORT "Test case 6 (AND): FAILED"
            SEVERITY ERROR;

        -- Test case 7: Pass A (OP1)
        A <= X"AAAA"; -- A = 1010 1010 1010 1010
        OP <= "101"; -- OP = OP1
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"AAAA" AND Carry = '0' AND Zero = '0' AND Negative = '1'
        REPORT "Test case 7 (OP1): FAILED"
            SEVERITY ERROR;

        -- Test case 8: Pass B (OP2)
        B <= X"5555"; -- B = 0101 0101 0101 0101
        OP <= "110"; -- OP = OP2
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"5555" AND Carry = '0' AND Zero = '0' AND Negative = '0'
        REPORT "Test case 8 (OP2): FAILED"
            SEVERITY ERROR;

        -- Test case 9: Set Carry
        OP <= "111"; -- OP = Set Carry
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Carry = '1'
        REPORT "Test case 9 (Set Carry): FAILED"
            SEVERITY ERROR;

        -- Test edge cases
        -- Increment max value
        A <= X"FFFF";
        OP <= "001";
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"0000" AND Carry = '1' AND Zero = '1' AND Negative = '0'
        REPORT "Increment max value failed 10" SEVERITY ERROR;

        -- Add max values
        A <= X"FFFF";
        B <= X"FFFF";
        OP <= "010";
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"FFFE" AND Carry = '1' AND Zero = '0' AND Negative = '1'
        REPORT "Add max values failed 11" SEVERITY ERROR;

        -- Subtract max values
        A <= X"FFFF";
        B <= X"FFFF";
        OP <= "011";
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"0000" AND Carry = '0' AND Zero = '1' AND Negative = '0'
        REPORT "Subtract max values failed 12" SEVERITY ERROR;

        -- Subtract zero from zero
        A <= X"0000";
        B <= X"0000";
        OP <= "011";
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"0000" AND Carry = '0' AND Zero = '1' AND Negative = '0'
        REPORT "Subtract zero from zero failed 13" SEVERITY ERROR;

        -- AND zero with zero
        A <= X"0000";
        B <= X"0000";
        OP <= "100";
        WAIT FOR clk_period;
        WAIT FOR clk_period; -- Wait an additional clock cycle for flags to update
        ASSERT Result = X"0000" AND Carry = '0' AND Zero = '1' AND Negative = '0'
        REPORT "AND zero with zero failed 14" SEVERITY ERROR;

        WAIT;
    END PROCESS;

END Behavioral_Alu_Flage_tb;