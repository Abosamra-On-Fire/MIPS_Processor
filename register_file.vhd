LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY register_file IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        reg_write : IN STD_LOGIC;

        write_addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_addr1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_addr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        read_data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END register_file;

ARCHITECTURE register_file_arch OF register_file IS

    CONSTANT NUM_REGISTERS : INTEGER := 8;
    CONSTANT DATA_WIDTH : INTEGER := 16;

    TYPE register_file_type IS ARRAY (0 TO NUM_REGISTERS - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

    -- NOTE: this was the original initialization
    -- SIGNAL register_file : register_file_type := (OTHERS => (OTHERS => '0'));

    -- alternative initialization
    -- if you need this, make sure to comment out the original initialization
    -- and the reset loop in the writing_data_process
    SIGNAL register_file : register_file_type := (
        0 => X"FFFF", -- Initialize register 0
        1 => X"FFFF", -- Initialize register 1
        2 => X"0010", -- Initialize register 2
        3 => "0000000000000011", -- Initialize register 3
        4 => "0000000000000100", -- Initialize register 4
        5 => "0000000000000101", -- Initialize register 5
        6 => "0000000000000110", -- Initialize register 6
        7 => "0000000000000111" -- Initialize register 7
    );
    SIGNAL read1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read2 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

BEGIN
    writing_data_process : PROCESS (clk, reset)

    BEGIN
        IF reset = '1' THEN
            -- NOTE: uncomment this if you want to reset all registers to 0 (original initialization)
            -- reset_loop : FOR i IN 0 TO NUM_REGISTERS - 1 LOOP
            --     register_file(i) <= (OTHERS => '0');
            -- END LOOP; -- reset_loop

        ELSIF rising_edge(clk) THEN
            IF reg_write = '1' THEN
                register_file(to_integer(unsigned(write_addr))) <= write_data;
            END IF;
            read1 <= register_file(to_integer(unsigned(read_addr1)));
            read2 <= register_file(to_integer(unsigned(read_addr2)));

        END IF;

    END PROCESS; -- writing_data_process

    read_data1 <= read1;
    read_data2 <= read2;

END register_file_arch; -- register_file_arch