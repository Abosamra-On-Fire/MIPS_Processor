LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY FU_tb IS
END FU_tb;

ARCHITECTURE Behavioral OF FU_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT FU
        PORT (
            R1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            R2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            ex_reg_write : IN STD_LOGIC;
            mem_reg_write : IN STD_LOGIC;
            ex_rd : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            mem_rd : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            a : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
            b : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL R1 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL R2 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL ex_reg_write : STD_LOGIC;
    SIGNAL mem_reg_write : STD_LOGIC;
    SIGNAL ex_rd : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL mem_rd : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL a : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL b : STD_LOGIC_VECTOR (1 DOWNTO 0);

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut_FU : FU
    PORT MAP(
        R1 => R1,
        R2 => R2,
        ex_reg_write => ex_reg_write,
        mem_reg_write => mem_reg_write,
        ex_rd => ex_rd,
        mem_rd => mem_rd,
        a => a,
        b => b
    );

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Test Case 1: No forwarding
        R1 <= "001";
        R2 <= "010";
        ex_reg_write <= '0';
        mem_reg_write <= '0';
        ex_rd <= "011";
        mem_rd <= "100";
        WAIT FOR 10 ns;
        ASSERT (a = "00" AND b = "00")
        REPORT "Test Case 1 Failed: No forwarding"
            SEVERITY ERROR;

        -- Test Case 2: Forward from EX stage to R1
        ex_reg_write <= '1';
        ex_rd <= "001";
        WAIT FOR 10 ns;
        ASSERT (a = "01" AND b = "00")
        REPORT "Test Case 2 Failed: Forward from EX stage to R1"
            SEVERITY ERROR;

        -- Test Case 3: Forward from MEM stage to R1
        ex_reg_write <= '0';
        mem_reg_write <= '1';
        mem_rd <= "001";
        WAIT FOR 10 ns;
        ASSERT (a = "10" AND b = "00")
        REPORT "Test Case 3 Failed: Forward from MEM stage to R1"
            SEVERITY ERROR;

        -- Test Case 4: Forward from EX stage to R2
        mem_reg_write <= '0';
        ex_reg_write <= '1';
        ex_rd <= "010";
        WAIT FOR 10 ns;
        ASSERT (a = "00" AND b = "01")
        REPORT "Test Case 4 Failed: Forward from EX stage to R2"
            SEVERITY ERROR;

        -- Test Case 5: Forward from MEM stage to R2
        ex_reg_write <= '0';
        mem_reg_write <= '1';
        mem_rd <= "010";
        WAIT FOR 10 ns;
        ASSERT (a = "00" AND b = "10")
        REPORT "Test Case 5 Failed: Forward from MEM stage to R2"
            SEVERITY ERROR;

        -- Test Case 6: Forward from EX stage to both R1 and R2
        ex_reg_write <= '1';
        ex_rd <= "001";
        R2 <= "001";
        WAIT FOR 10 ns;
        ASSERT (a = "01" AND b = "01")
        REPORT "Test Case 6 Failed: Forward from EX stage to both R1 and R2"
            SEVERITY ERROR;

        -- Test Case 7: Forward from MEM stage to both R1 and R2
        ex_reg_write <= '0';
        mem_reg_write <= '1';
        mem_rd <= "001";
        WAIT FOR 10 ns;
        ASSERT (a = "10" AND b = "10")
        REPORT "Test Case 7 Failed: Forward from MEM stage to both R1 and R2"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;

END Behavioral;