
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY Branch IS
    PORT (

        branch_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        conditional_branch : IN STD_LOGIC;
        flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        branch_flage : OUT STD_LOGIC

    );
END Branch;

ARCHITECTURE rtl OF Branch IS

    -- branch_flag <= flags(to_integer(unsigned(branch_sel))) AND conditional_branch;

BEGIN
    PROCESS (branch_sel, conditional_branch, flags)
    BEGIN
        IF conditional_branch = '1' AND branch_sel /= "11" THEN
            branch_flage <= flags(to_integer(unsigned(branch_sel)));
        ELSE
            branch_flage <= '0';
        END IF;
    END PROCESS;
END ARCHITECTURE;