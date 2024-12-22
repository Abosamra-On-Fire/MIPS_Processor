LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY ALU_Source IS
    PORT (
        op1_forward : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        op2_forward : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        alu_source1 : IN STD_LOGIC;
	        alu_source2 : in STD_LOGIC;
        op1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        op2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ALU_Source;

ARCHITECTURE rtl OF ALU_Source IS

BEGIN
    PROCESS (alu_source1, op1_forward, op2_forward)
    BEGIN
        IF alu_source1 = '0' THEN
            op1 <= op1_forward;
        ELSE
            op1 <= op2_forward;

        END IF;
    END PROCESS;

    PROCESS (alu_source2, op2_forward, imm)
    BEGIN
        IF alu_source2 = '0' THEN
            op2 <= op2_forward;
        ELSE
            op2 <= imm;
        END IF;
    END PROCESS;

END ARCHITECTURE;