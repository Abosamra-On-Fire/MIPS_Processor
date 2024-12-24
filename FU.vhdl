LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY FU IS
    PORT (
        R1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        R2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        ex_r : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        mem_r : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        a : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        b : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
    );
END FU;

ARCHITECTURE Behavioral OF FU IS
BEGIN
    PROCESS (R1, R2, ex_r, mem_r)
    BEGIN
        IF (R1 = ex_r) THEN
            a <= "01";
        ELSIF (R1 = mem_r) THEN
            a <= "10";
        ELSE
            a <= "00";
        END IF;

        IF (R2 = ex_r) THEN
            b <= "01";
        ELSIF (R2 = mem_r) THEN
            b <= "10";
        ELSE
            b <= "00";
        END IF;
    END PROCESS;
END Behavioral;