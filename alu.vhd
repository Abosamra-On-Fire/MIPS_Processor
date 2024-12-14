LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        OP : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        carry : OUT STD_LOGIC;
        negative : OUT STD_LOGIC;
        zero : OUT STD_LOGIC
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS
    SIGNAL temp_result : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL temp_carry : STD_LOGIC := '0';
    SIGNAL temp_negative : STD_LOGIC := '0';
    SIGNAL temp_zero : STD_LOGIC := '1';
BEGIN

    PROCESS (clk, reset)
        VARIABLE full_sum : UNSIGNED(16 DOWNTO 0); -- For addition carry
        VARIABLE full_diff : SIGNED(16 DOWNTO 0); -- For subtraction borrow
    BEGIN
        IF reset = '1' THEN
            temp_result <= (OTHERS => '0');
            temp_carry <= '0';
            temp_negative <= '0';
            temp_zero <= '1';
        ELSIF rising_edge(clk) THEN
            CASE OP IS
                WHEN "000" => -- NOT
                    temp_result <= NOT A;
                    temp_carry <= '0';

                WHEN "001" => -- INC
                    full_sum := ('0' & unsigned(A)) + 1;
                    temp_result <= STD_LOGIC_VECTOR(full_sum(15 DOWNTO 0));
                    temp_carry <= full_sum(16);

                WHEN "010" => -- ADD
                    full_sum := ('0' & unsigned(A)) + ('0' & unsigned(B));
                    temp_result <= STD_LOGIC_VECTOR(full_sum(15 DOWNTO 0));
                    temp_carry <= full_sum(16);

                WHEN "011" => -- SUB
                    full_diff := SIGNED(('0' & A)) - SIGNED(('0' & B));
                    temp_result <= STD_LOGIC_VECTOR(full_diff(15 DOWNTO 0));
                    temp_carry <= '0'; -- Borrow flag can be added if required.

                WHEN "100" => -- AND
                    temp_result <= A AND B;
                    temp_carry <= '0';

                WHEN "101" => -- OP1
                    temp_result <= A;
                    temp_carry <= '0';

                WHEN "110" => -- OP2
                    temp_result <= B;
                    temp_carry <= '0';

                WHEN "111" => -- SetC
                    temp_result <= (OTHERS => '0');
                    temp_carry <= '1';

                WHEN OTHERS =>
                    temp_result <= (OTHERS => '0');
                    temp_carry <= '0';
            END CASE;

            -- Update flags
            temp_negative <= temp_result(15);
            IF unsigned(temp_result) = 0 THEN
                temp_zero <= '1';
            ELSE
                temp_zero <= '0';
            END IF;
        END IF;
    END PROCESS;

    -- Assign output signals
    result <= temp_result;
    carry <= temp_carry;
    zero <= temp_zero;
    negative <= temp_negative;
END Behavioral;