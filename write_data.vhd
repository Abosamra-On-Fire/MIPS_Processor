LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Write_Data IS
    PORT (
        flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        rs1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        data_to_mem : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Write_Data;

ARCHITECTURE rtl OF Write_Data IS
BEGIN
    PROCESS (flags, rs1, pc, data_to_mem)
    BEGIN
        IF data_to_mem = "00" THEN
            -- convert flags to (15 DOWNTO 3)
            data_out <= (15 DOWNTO 3 => '0') & flags;
        ELSIF data_to_mem = "01" THEN
            data_out <= pc;
        ELSIF data_to_mem = "10" THEN
            data_out <= rs1;
        ELSE
            data_out <= (OTHERS => '0');
        END IF;
    END PROCESS;
END rtl;