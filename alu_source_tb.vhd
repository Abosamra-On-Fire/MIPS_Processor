LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU_Source_tb IS
END ALU_Source_tb;

ARCHITECTURE Behavioral OF ALU_Source_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT ALU_Source
        PORT (
            op1_forward : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            op2_forward : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            alu_source1 : IN STD_LOGIC;
            alu_source2 : IN STD_LOGIC;
            op1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            op2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL op1_forward : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL op2_forward : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL imm : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL alu_source1 : STD_LOGIC;
    SIGNAL alu_source2 : STD_LOGIC;
    SIGNAL op1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL op2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut_ALU_Source : ALU_Source
    PORT MAP(
        op1_forward => op1_forward,
        op2_forward => op2_forward,
        imm => imm,
        alu_source1 => alu_source1,
        alu_source2 => alu_source2,
        op1 => op1,
        op2 => op2
    );

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Test Case 1: alu_source1 = '0', alu_source2 = '0'
        op1_forward <= X"1234";
        op2_forward <= X"5678";
        imm <= X"9ABC";
        alu_source1 <= '0';
        alu_source2 <= '0';
        WAIT FOR clk_period;
        ASSERT (op1 = X"1234" AND op2 = X"5678")
        REPORT "Test Case 1 Failed: op1 or op2 incorrect"
            SEVERITY ERROR;

        -- Test Case 2: alu_source1 = '1', alu_source2 = '0'
        alu_source1 <= '1';
        alu_source2 <= '0';
        WAIT FOR clk_period;
        ASSERT (op1 = X"5678" AND op2 = X"5678")
        REPORT "Test Case 2 Failed: op1 or op2 incorrect"
            SEVERITY ERROR;

        -- Test Case 3: alu_source1 = '0', alu_source2 = '1'
        alu_source1 <= '0';
        alu_source2 <= '1';
        WAIT FOR clk_period;
        ASSERT (op1 = X"1234" AND op2 = X"9ABC")
        REPORT "Test Case 3 Failed: op1 or op2 incorrect"
            SEVERITY ERROR;

        -- Test Case 4: alu_source1 = '1', alu_source2 = '1'
        alu_source1 <= '1';
        alu_source2 <= '1';
        WAIT FOR clk_period;
        ASSERT (op1 = X"5678" AND op2 = X"9ABC")
        REPORT "Test Case 4 Failed: op1 or op2 incorrect"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;

END Behavioral;