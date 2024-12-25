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
        zero : OUT STD_LOGIC;
        en : IN STD_LOGIC;
        flags_arr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) -- Output flags
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS
    SIGNAL temp : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL car : STD_LOGIC := '0';
    SIGNAL neg : STD_LOGIC := '0';
    SIGNAL zer : STD_LOGIC := '0';
    SIGNAL ones : STD_LOGIC := '1';

BEGIN

    PROCESS (clk, reset)
        VARIABLE temp_negative : STD_LOGIC := '0';
        VARIABLE temp_zero : STD_LOGIC := '0';
        VARIABLE temp_carry : STD_LOGIC := '0';
        VARIABLE full_sum : UNSIGNED(16 DOWNTO 0); -- For addition carry
        VARIABLE full_diff : SIGNED(16 DOWNTO 0); -- For subtraction borrow
        VARIABLE temp_result : STD_LOGIC_VECTOR(15 DOWNTO 0);

    BEGIN
        IF reset = '1' THEN
            temp_result := (OTHERS => '0');
            temp_carry := '0';
            temp_negative := '0';
            temp_zero := '0';
        ELSIF rising_edge(clk) THEN
            temp_carry := car;
            temp_negative := neg;
            temp_zero := zer;
            temp_result := temp;
            IF en = '1' AND ones = '1' THEN
                CASE OP IS
                    WHEN "000" => -- NOT
                        temp_result := NOT A;

                        REPORT "NOT: " & INTEGER'image(to_integer(unsigned(temp_result)));
                        temp_carry := '0';

                    WHEN "001" => -- INC
                        full_sum := ('0' & unsigned(A)) + 1;
                        temp_result := STD_LOGIC_VECTOR(full_sum(15 DOWNTO 0));
                        REPORT "INC: " & INTEGER'image(to_integer(unsigned(temp_result)));
                        temp_carry := full_sum(16);

                    WHEN "010" => -- ADD    
                        full_sum := ('0' & unsigned(A)) + ('0' & unsigned(B));
                        REPORT "full_sum: " & INTEGER'image(to_integer(unsigned(full_sum)));
                        temp_result := STD_LOGIC_VECTOR(full_sum(15 DOWNTO 0));
                        temp_carry := full_sum(16);

                    WHEN "011" => -- SUB
                        full_diff := SIGNED(('0' & A)) - SIGNED(('0' & B));
                        REPORT "full_diff: " & INTEGER'image(to_integer(unsigned(full_diff)));
                        temp_result := STD_LOGIC_VECTOR(full_diff(15 DOWNTO 0));
                        temp_carry := '0'; -- Borrow flag can be added if required.

                    WHEN "100" => -- AND
                        temp_result := A AND B;
                        REPORT "AND: " & INTEGER'image(to_integer(unsigned(temp_result)));
                        temp_carry := '0';

                    WHEN "101" => -- OP1
                        temp_result := A;
                        REPORT "OP1: " & INTEGER'image(to_integer(unsigned(temp_result)));
                        temp_carry := '0';

                    WHEN "110" => -- OP2
                        temp_result := B;
                        REPORT "OP2: " & INTEGER'image(to_integer(unsigned(temp_result)));
                        temp_carry := '0';

                    WHEN "111" => -- SetC
                        REPORT "SetC: " & INTEGER'image(to_integer(unsigned(temp_result)));
                        temp_carry := '1';

                    WHEN OTHERS =>
                        REPORT "NO OPERATION: " & INTEGER'image(to_integer(unsigned(temp_result)));

                        temp_carry := '0';
                END CASE;
                temp <= temp_result;

                -- Update flags
                temp_negative := temp_result(15);
                IF unsigned(temp_result) = 0 THEN
                    temp_zero := '1';
                ELSE
                    temp_zero := '0';
                END IF;

                car <= temp_carry;
                neg <= temp_negative;
                zer <= temp_zero;
                ones <= '0';

            ELSE
                ones <= '1';
            END IF;
        END IF;
    END PROCESS;

    carry <= car;
    zero <= zer;
    negative <= neg;
    result <= temp;
    flags_arr <= car & neg & zer;
    -- Assign output signals
END Behavioral;