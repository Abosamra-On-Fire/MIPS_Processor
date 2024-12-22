LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY EX_tb IS
END EX_tb;

ARCHITECTURE Behavioral OF EX_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT EX
        PORT (
            R1, R2, R1_FORWARD_MEM, R2_FORWARD_MEM, R1_FORWARD_WB, R2_FORWARD_WB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            OP1, OP2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Alu_Source1, Alu_Source2 : IN STD_LOGIC;
            Alu_control : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            conditional_branch : IN STD_LOGIC;
            branch_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            alu_enable : IN STD_LOGIC;

            out_port_signal : IN STD_LOGIC;
            stack_write : IN STD_LOGIC;
            stack_add : IN STD_LOGIC;

            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            branch_out : OUT STD_LOGIC;
            out_port_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_to_mem : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_to_mem_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            stack_pointer : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL R1, R2, R1_FORWARD_MEM, R2_FORWARD_MEM, R1_FORWARD_WB, R2_FORWARD_WB : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL OP1, OP2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Alu_Source1, Alu_Source2 : STD_LOGIC;
    SIGNAL Alu_control : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL conditional_branch : STD_LOGIC;
    SIGNAL branch_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL alu_enable : STD_LOGIC;

    SIGNAL out_port_signal : STD_LOGIC;
    SIGNAL stack_write : STD_LOGIC;
    SIGNAL stack_add : STD_LOGIC;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL imm : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Alu_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL branch_out : STD_LOGIC;
    SIGNAL out_port_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL data_to_mem : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL data_to_mem_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL stack_pointer : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut_EX : EX
    PORT MAP(
        R1 => R1,
        R2 => R2,
        R1_FORWARD_MEM => R1_FORWARD_MEM,
        R2_FORWARD_MEM => R2_FORWARD_MEM,
        R1_FORWARD_WB => R1_FORWARD_WB,
        R2_FORWARD_WB => R2_FORWARD_WB,
        OP1 => OP1,
        OP2 => OP2,
        PC => PC,
        Alu_Source1 => Alu_Source1,
        Alu_Source2 => Alu_Source2,
        Alu_control => Alu_control,

        conditional_branch => conditional_branch,
        branch_sel => branch_sel,
        alu_enable => alu_enable,
        out_port_signal => out_port_signal,
        stack_write => stack_write,
        stack_add => stack_add,
        clk => clk,
        reset => reset,
        imm => imm,
        Alu_out => Alu_out,
        branch_out => branch_out,
        out_port_data => out_port_data,
        data_to_mem => data_to_mem,
        data_to_mem_out => data_to_mem_out,
        stack_pointer => stack_pointer
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
        -- Test Case 1: Reset the EX module
        R1 <= X"0001";
        R2 <= X"0002";
        R1_FORWARD_MEM <= X"0003";
        R2_FORWARD_MEM <= X"0004";
        R1_FORWARD_WB <= X"0005";
        R2_FORWARD_WB <= X"0006";
        OP1 <= "00";
        OP2 <= "00";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "010"; -- Assuming "010" is the ADD operation
        conditional_branch <= '0';
        branch_sel <= "00";
        alu_enable <= '0';
        out_port_signal <= '0';
        stack_write <= '0';
        stack_add <= '0';
        imm <= X"0005";
        data_to_mem <= "00";
        reset <= '1';
        WAIT FOR clk_period;

        reset <= '0';
        -- Test Case 2: ADD 
        R1 <= X"0001";
        R2 <= X"0002";
        R1_FORWARD_MEM <= X"0003";
        R2_FORWARD_MEM <= X"0004";
        R1_FORWARD_WB <= X"0005";
        R2_FORWARD_WB <= X"0006";
        OP1 <= "00";
        OP2 <= "00";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "010"; -- Assuming "010" is the ADD operation

        conditional_branch <= '0';
        branch_sel <= "00";
        alu_enable <= '1';
        out_port_signal <= '0';
        stack_write <= '0';
        stack_add <= '0';
        imm <= X"0005";
        data_to_mem <= "00";

        WAIT FOR clk_period;
        -- WAIT FOR clk_period/2;
        ASSERT (Alu_out = X"0003" AND branch_out = '0' AND out_port_data = X"0000" AND stack_pointer = X"0FFF")
        REPORT "Test Case 2 Failed: ADD operation did not produce correct result"
            SEVERITY ERROR;

        -- Test Case 3: ADD with forward

        R1 <= X"0001";
        R2 <= X"0002";
        R1_FORWARD_MEM <= X"0003";
        R2_FORWARD_MEM <= X"0004";
        R1_FORWARD_WB <= X"0005";
        R2_FORWARD_WB <= X"0006";
        OP1 <= "01";
        OP2 <= "01";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "010"; -- Assuming "010" is the ADD operation
        conditional_branch <= '0';
        branch_sel <= "00";
        alu_enable <= '1';
        out_port_signal <= '0';
        stack_write <= '0';
        stack_add <= '0';
        imm <= X"0005";
        data_to_mem <= "00";

        WAIT FOR clk_period;
        ASSERT (Alu_out = X"0007" AND branch_out = '0' AND out_port_data = X"0000" AND stack_pointer = X"0FFF")
        REPORT "Test Case 2 Failed: ADD operation did not produce correct result"
            SEVERITY ERROR;
        R1 <= X"0001";
        R2 <= X"0002";
        R1_FORWARD_MEM <= X"0003";
        R2_FORWARD_MEM <= X"0004";
        R1_FORWARD_WB <= X"0005";
        R2_FORWARD_WB <= X"0006";
        OP1 <= "10";
        OP2 <= "10";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "010"; -- Assuming "010" is the ADD operation
        conditional_branch <= '0';
        branch_sel <= "00";
        alu_enable <= '1';
        out_port_signal <= '0';
        stack_write <= '0';
        stack_add <= '0';
        imm <= X"0005";
        data_to_mem <= "00";

        WAIT FOR clk_period;
        ASSERT (Alu_out = X"000B" AND branch_out = '0' AND out_port_data = X"0000" AND stack_pointer = X"0FFF")
        REPORT "Test Case 2 Failed: ADD operation did not produce correct result"
            SEVERITY ERROR;

        R1 <= X"0001";
        R2 <= X"0002";
        R1_FORWARD_MEM <= X"0003";
        R2_FORWARD_MEM <= X"0004";
        R1_FORWARD_WB <= X"0005";
        R2_FORWARD_WB <= X"0006";
        OP1 <= "01";
        OP2 <= "10";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "010"; -- Assuming "010" is the ADD operation
        conditional_branch <= '0';
        branch_sel <= "00";
        alu_enable <= '1';
        out_port_signal <= '0';
        stack_write <= '0';
        stack_add <= '0';
        imm <= X"0005";
        data_to_mem <= "00";

        WAIT FOR clk_period;
        ASSERT (Alu_out = X"0009" AND branch_out = '0' AND out_port_data = X"0000" AND stack_pointer = X"0FFF")
        REPORT "Test Case 2 Failed: ADD operation did not produce correct result"
            SEVERITY ERROR;

        -- test stack write

        R1 <= X"0001";
        R2 <= X"0002";
        R1_FORWARD_MEM <= X"0003";
        R2_FORWARD_MEM <= X"0004";
        R1_FORWARD_WB <= X"0005";
        R2_FORWARD_WB <= X"0006";
        OP1 <= "01";
        OP2 <= "01";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "010"; -- Assuming "010" is the ADD operation
        conditional_branch <= '0';
        branch_sel <= "00";
        alu_enable <= '0';
        out_port_signal <= '0';
        stack_write <= '1';
        stack_add <= '1';
        imm <= X"0005";
        data_to_mem <= "00";

        WAIT FOR clk_period;
        ASSERT (Alu_out = X"0009" AND branch_out = '0' AND out_port_data = X"0000" AND stack_pointer = X"0FFF")
        REPORT "Test Case 2 Failed: ADD operation did not produce correct result"
            SEVERITY ERROR;

        -- test stack write

        R1 <= X"0001";
        R2 <= X"0002";
        R1_FORWARD_MEM <= X"0003";
        R2_FORWARD_MEM <= X"0004";
        R1_FORWARD_WB <= X"0005";
        R2_FORWARD_WB <= X"0006";
        OP1 <= "01";
        OP2 <= "01";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "010"; -- Assuming "010" is the ADD operation
        conditional_branch <= '0';
        branch_sel <= "00";
        alu_enable <= '0';
        out_port_signal <= '0';
        stack_write <= '1';
        stack_add <= '1';
        imm <= X"0005";
        data_to_mem <= "00";

        WAIT FOR clk_period;
        ASSERT (Alu_out = X"0009" AND branch_out = '0' AND out_port_data = X"0000" AND stack_pointer = X"0FFE")
        REPORT "Test Case 2 Failed: ADD operation did not produce correct result"
            SEVERITY ERROR;

        R1 <= X"0001";
        R2 <= X"0002";
        R1_FORWARD_MEM <= X"0003";
        R2_FORWARD_MEM <= X"0004";
        R1_FORWARD_WB <= X"0005";
        R2_FORWARD_WB <= X"0006";
        OP1 <= "01";
        OP2 <= "01";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "010"; -- Assuming "010" is the ADD operation
        conditional_branch <= '0';
        branch_sel <= "00";
        alu_enable <= '0';
        out_port_signal <= '0';
        stack_write <= '1';
        stack_add <= '0';
        imm <= X"0005";
        data_to_mem <= "00";

        WAIT FOR clk_period;
        ASSERT (Alu_out = X"0009" AND branch_out = '0' AND out_port_data = X"0000" AND stack_pointer = X"0FFE")
        REPORT "Test Case 2 Failed: ADD operation did not produce correct result"
            SEVERITY ERROR;

        -- Test Case 4: sub 
        R1 <= X"0002";
        R2 <= X"0001";
        R1_FORWARD_MEM <= X"0004";
        R2_FORWARD_MEM <= X"0005";
        R1_FORWARD_WB <= X"0001";
        R2_FORWARD_WB <= X"0008";
        OP1 <= "01";
        OP2 <= "00";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "011"; -- Assuming "010" is the ADD operation
        conditional_branch <= '0';
        branch_sel <= "00";
        alu_enable <= '1';
        out_port_signal <= '0';
        stack_write <= '0';
        stack_add <= '0';
        imm <= X"0005";
        data_to_mem <= "00";
        WAIT FOR clk_period;
        ASSERT (Alu_out = X"0003" AND branch_out = '0' AND out_port_data = X"0000" AND stack_pointer = X"0FFE")
        REPORT "Test Case 2 Failed: ADD operation did not produce correct result"
            SEVERITY ERROR;

        R1 <= X"0002";
        R2 <= X"0001";
        R1_FORWARD_MEM <= X"0004";
        R2_FORWARD_MEM <= X"0005";
        R1_FORWARD_WB <= X"0001";
        R2_FORWARD_WB <= X"0008";
        OP1 <= "10";
        OP2 <= "00";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "011"; -- Assuming "010" is the ADD operation
        conditional_branch <= '0';
        branch_sel <= "00";
        alu_enable <= '1';
        out_port_signal <= '0';
        stack_write <= '0';
        stack_add <= '0';
        imm <= X"0005";
        data_to_mem <= "00";
        WAIT FOR clk_period;
        ASSERT (Alu_out = X"0000" AND branch_out = '0' AND out_port_data = X"0000" AND stack_pointer = X"0FFE")
        REPORT "Test Case 2 Failed: ADD operation did not produce correct result"
            SEVERITY ERROR;

        R1 <= X"0002";
        R2 <= X"0001";
        R1_FORWARD_MEM <= X"0004";
        R2_FORWARD_MEM <= X"0005";
        R1_FORWARD_WB <= X"0001";
        R2_FORWARD_WB <= X"0008";
        OP1 <= "10";
        OP2 <= "00";
        PC <= X"0001";
        Alu_Source1 <= '0';
        Alu_Source2 <= '0';
        Alu_control <= "011"; -- Assuming "010" is the ADD operation
        conditional_branch <= '1';
        branch_sel <= "00";
        alu_enable <= '0';
        out_port_signal <= '0';
        stack_write <= '0';
        stack_add <= '0';
        imm <= X"0005";
        data_to_mem <= "00";
        WAIT FOR clk_period;
        ASSERT (Alu_out = X"0000" AND branch_out = '1' AND out_port_data = X"0000" AND stack_pointer = X"0FFE")
        REPORT "Test Case 2 Failed: ADD operation did not produce correct result"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;

    

END Behavioral;