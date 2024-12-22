
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY ALU_Forward IS
    PORT (
        r1, r2, r1_forward_mem, r2_forward_mem, r1_forward_wb, r2_forward_wb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        op1, op2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        r1_out, r2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ALU_Forward;

ARCHITECTURE rtl OF ALU_Forward IS

BEGIN
    PROCESS (op1, r1, r1_forward_mem, r1_forward_wb)
    BEGIN
        IF op1 = "00" THEN
            r1_out <= r1;
        ELSIF op1 = "01" THEN
            r1_out <= r1_forward_mem;
        ELSE
            r1_out <= r1_forward_wb;
        END IF;
    END PROCESS;

    PROCESS (op2, r2, r2_forward_mem, r2_forward_wb)
    BEGIN
        IF op2 = "00" THEN
            r2_out <= r2;
        ELSIF op2 = "01" THEN
            r2_out <= r2_forward_mem;
        ELSE
            r2_out <= r2_forward_wb;
        END IF;
    END PROCESS;

END ARCHITECTURE;