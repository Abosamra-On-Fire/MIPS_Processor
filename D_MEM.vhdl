LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY D_MEM IS
    GENERIC (
        SIZE : INTEGER := 4096
    );
    PORT (
        Data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        stack : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        alu : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        add_sel : IN STD_LOGIC;
        mem_write : IN STD_LOGIC;
        mem_read : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        Data_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END D_MEM;

ARCHITECTURE Behavioral OF D_MEM IS
    TYPE memory_array IS ARRAY (0 TO MEM_SIZE - 1) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memory : memory_array := (OTHERS => (OTHERS => '0'));
BEGIN
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (mem_write = '1') THEN
                IF (add_sel = '1')
                    memory(to_integer(unsigned(stack))) <= Data;
                ELSE
                    memory(to_integer(unsigned(alu))) <= Data;
                END IF;
            END IF;
            IF (mem_read = '1') THEN
                IF (add_sel = '1')
                    Data_out <= memory(to_integer(unsigned(stack)));
                ELSE
                    Data_out <= memory(to_integer(unsigned(alu)));
                END IF;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;