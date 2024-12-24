LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY reg IS
    GENERIC (
        SIZE : INTEGER := 128
    );
    PORT (
        clk : IN STD_LOGIC;
        Data_in : IN STD_LOGIC_VECTOR (SIZE - 1 DOWNTO 0);
        en : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Data_out : OUT STD_LOGIC_VECTOR (SIZE - 1 DOWNTO 0);
        flage_flush : IN STD_LOGIC
    );
END reg;

ARCHITECTURE Behavioral OF reg IS
    SIGNAL memory_array : STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk, rst, en)
    BEGIN
        IF rst = '1' THEN
            memory_array <= (OTHERS => '0');
        ELSIF en = '1' THEN
            IF (rising_edge(clk)) THEN
                IF flage_flush = '1' THEN
                    memory_array <= (OTHERS => '0');
                ELSE
                    memory_array <= Data_in;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    Data_out <= memory_array;

END Behavioral;