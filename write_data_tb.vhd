LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Write_Data_tb IS
END Write_Data_tb;

ARCHITECTURE Behavioral OF Write_Data_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT Write_Data
        PORT (
            flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            rs1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_to_mem : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL rs1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL data_to_mem : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut_Write_Data : Write_Data
    PORT MAP(
        flags => flags,
        rs1 => rs1,
        pc => pc,
        data_to_mem => data_to_mem,
        data_out => data_out
    );

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Test Case 1: Write flags to data_out
        flags <= "101";
        rs1 <= X"1234";
        pc <= X"5678";
        data_to_mem <= "00";
        WAIT FOR clk_period;
        ASSERT (data_out = X"0005")
        REPORT "Test Case 1 Failed: flags were not written correctly"
            SEVERITY ERROR;

        -- Test Case 2: Write pc to data_out
        flags <= "000";
        rs1 <= X"1234";
        pc <= X"5678";
        data_to_mem <= "01";
        WAIT FOR clk_period;
        ASSERT (data_out = X"5678")
        REPORT "Test Case 2 Failed: pc was not written correctly"
            SEVERITY ERROR;

        -- Test Case 3: Write rs1 to data_out
        flags <= "000";
        rs1 <= X"1234";
        pc <= X"5678";
        data_to_mem <= "10";
        WAIT FOR clk_period;
        ASSERT (data_out = X"1234")
        REPORT "Test Case 3 Failed: rs1 was not written correctly"
            SEVERITY ERROR;

        -- Test Case 4: Default case (data_to_mem = "11")
        flags <= "000";
        rs1 <= X"1234";
        pc <= X"5678";
        data_to_mem <= "11";
        WAIT FOR clk_period;
        ASSERT (data_out = X"0000")
        REPORT "Test Case 4 Failed: default case did not produce correct result"
            SEVERITY ERROR;

        WAIT;
    END PROCESS;

END Behavioral;