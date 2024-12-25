LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY IM IS
    PORT (
        clk : IN STD_LOGIC;
        -- load     : in std_logic; 
        -- program  : in std_logic_vector(10*16-1 downto 0); 
        location : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        reset : IN STD_LOGIC;
        instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END IM;

ARCHITECTURE Behavioral OF IM IS
    TYPE memory_array IS ARRAY (0 TO 10) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    IMPURE FUNCTION init_ram_bin RETURN memory_array IS
        FILE text_file : text OPEN read_mode IS "IM.txt";
        VARIABLE text_line : line;
        VARIABLE ram_content : memory_array;
        VARIABLE bv : bit_vector(ram_content(0)'RANGE);
        VARIABLE i : INTEGER := 0;
    BEGIN
        WHILE NOT endfile(text_file) LOOP
            readline(text_file, text_line);
            read(text_line, bv);
            ram_content(i) := to_stdlogicvector(bv);
            i := i + 1;
        END LOOP;
        RETURN ram_content;
    END FUNCTION;
    SIGNAL instruction_memory : memory_array := init_ram_bin;

BEGIN
    PROCESS (clk, reset, location)
    BEGIN
        IF reset = '1' THEN
            instruction <= (OTHERS => '0');
            ELSE
            instruction <= instruction_memory(to_integer(unsigned(location)));
        END IF;
    END PROCESS;

END Behavioral;