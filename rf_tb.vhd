LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY register_file_tb IS
END register_file_tb;

ARCHITECTURE Behavioral OF register_file_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT register_file
        GENERIC (
            NUM_REGISTERS : INTEGER := 8;
            DATA_WIDTH : INTEGER := 16
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            reg_write : IN STD_LOGIC;
            write_addr : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            write_data : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
            read_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            read_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            read_data1 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
            read_data2 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for inputs and outputs
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL reg_write : STD_LOGIC := '0';
    SIGNAL write_addr : STD_LOGIC_VECTOR (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL write_data : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_addr1 : STD_LOGIC_VECTOR (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_addr2 : STD_LOGIC_VECTOR (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_data1 : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL read_data2 : STD_LOGIC_VECTOR (15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut_register_file : register_file
    GENERIC MAP(
        NUM_REGISTERS => 8,
        DATA_WIDTH => 16
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        reg_write => reg_write,
        write_addr => write_addr,
        write_data => write_data,
        read_addr1 => read_addr1,
        read_addr2 => read_addr2,
        read_data1 => read_data1,
        read_data2 => read_data2
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
        -- Test Case 1: Reset the register file
        reset <= '1';
        WAIT FOR clk_period;
        reset <= '0';
        WAIT FOR clk_period;
        ASSERT (read_data1 = X"0000" AND read_data2 = X"0000")
        REPORT "Test Case 1 Failed: Register file was not reset correctly"
            SEVERITY ERROR;

        -- Test Case 2: Write to register 1 and read back
        write_addr <= "001";
        write_data <= X"1234";
        reg_write <= '1';
        WAIT FOR clk_period;
        reg_write <= '0';
        read_addr1 <= "001";
        WAIT FOR clk_period;
        ASSERT (read_data1 = X"1234")
        REPORT "Test Case 2 Failed: Data was not written to register 1 correctly"
            SEVERITY ERROR;

        -- Test Case 3: Write to register 2 and read back
        write_addr <= "010";
        write_data <= X"5678";
        reg_write <= '1';
        WAIT FOR clk_period;
        reg_write <= '0';
        read_addr2 <= "010";
        WAIT FOR clk_period;
        ASSERT (read_data2 = X"5678")
        REPORT "Test Case 3 Failed: Data was not written to register 2 correctly"
            SEVERITY ERROR;

        -- Add more test cases as needed

        WAIT;
    END PROCESS;

END Behavioral;