LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY WB IS
    PORT (
        alu : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        mem_reg : IN STD_LOGIC;
        write_back : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)

    );
END WB;

ARCHITECTURE Behavioral OF WB IS
BEGIN
    PROCESS (alu, data, mem_reg)
    BEGIN
        IF (mem_reg = '1') THEN
            write_back <= data;
            ELSE
            write_back <= alu;
        END IF;
    END PROCESS;
END Behavioral;