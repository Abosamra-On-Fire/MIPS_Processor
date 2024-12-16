LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
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
    TYPE memory_array IS ARRAY (0 TO 4) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL instruction_memory : memory_array := (
        "0100001000000100",
        "0001000000000000",
        "0001100100100000",
        "0011101101000000",
        "0101010001000000"
    );

BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            instruction <= (OTHERS => '0');

        ELSE
            IF rising_edge(clk) THEN
                -- if load = '1' then
                -- for i in 0 to 1 loop
                --     instruction_memory(i) <= program((i+1)*16-1 downto i*16);
                -- end loop;
                -- else
                instruction <= instruction_memory(to_integer(unsigned(location)));
            END IF;
        END IF;
    END PROCESS;

END Behavioral;