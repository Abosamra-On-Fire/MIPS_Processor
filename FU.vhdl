LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY FU IS
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
END FU;

ARCHITECTURE Behavioral OF FU IS
BEGIN
    PROCESS (R1, R2 , ex_reg_write, mem_reg_write, ex_rd, mem_rd)
    BEGIN
        -- Forwarding for A
        IF (ex_reg_write = '1' AND ex_rd = R1) THEN
            a <= "01"; -- Forward from EX stage
        ELSIF (mem_reg_write = '1' AND mem_rd = R1 AND NOT (ex_reg_write = '1' AND ex_rd = R1)) THEN
            a <= "10"; -- Forward from MEM stage
        ELSE
            a <= "00"; -- No forwarding
        END IF;

        -- Forwarding for B
        IF (ex_reg_write = '1' AND ex_rd = R2) THEN
            b <= "01"; -- Forward from EX stage
        ELSIF (mem_reg_write = '1' AND mem_rd = R2 AND NOT (ex_reg_write = '1' AND ex_rd = R2)) THEN
            b <= "10"; -- Forward from MEM stage
        ELSE
            b <= "00"; -- No forwarding
        END IF;
    END PROCESS;
END Behavioral;