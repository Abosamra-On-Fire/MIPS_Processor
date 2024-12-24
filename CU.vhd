LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CU IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        signals : OUT STD_LOGIC_VECTOR(28 DOWNTO 0);
        branch : IN STD_LOGIC;
        stack : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        flush : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        exception_flage : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

        mem_address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    );
END CU;

ARCHITECTURE Behavioral OF CU IS
    SIGNAL exception : STD_LOGIC := '0';
    SIGNAL type_siganl : STD_LOGIC := '0'; -- 0 for stake, 1 for memory
    SIGNAL exception : STD_LOGIC := '0';
    SIGNAL type_siganl : STD_LOGIC := '0'; -- 0 for stake, 1 for memory
BEGIN
    PROCESS (clk, reset, opcode)
    BEGIN
        IF reset = '1' THEN
            signals <= (OTHERS => '0');
        ELSE
            exception_flage <= (OTHERS => '0');
            exception_flage <= (OTHERS => '0');
            signals <= (OTHERS => '0');
            IF (stack > X"0FFF") THEN -- stack exception
                exception <= '1';
                type_siganl <= '0';
            END IF;
            IF (mem_address > X"0FFF" | | mem_address < X"0000") THEN -- memory exception
                exception <= '1';
                type_siganl <= '1';
            END IF;
            IF (branch = '0' AND exception = '0') THEN

                CASE opcode IS
                    WHEN "00001" =>
                        signals(0) <= '1';
                        signals(24) <= "1";
                    WHEN "00011" =>
                        signals(17) <= '1';
                    WHEN "00100" =>
                        signals(13) <= '1';
                        signals(17) <= '1';
                    WHEN "00101" =>
                        signals(9) <= '1';
                    WHEN "00110" =>
                        signals(17) <= '1';
                        signals(25) <= '1';
                    WHEN "00111" =>
                        signals(17) <= '1';
                        signals(2 DOWNTO 1) <= "10";
                    WHEN "01000" =>
                        signals(13 DOWNTO 11) <= "010";
                        signals(17) <= '1';
                    WHEN "01001" =>
                        signals(13 DOWNTO 11) <= "011";
                        signals(17) <= '1';
                    WHEN "01010" =>
                        signals(13 DOWNTO 11) <= "100";
                        signals(17) <= '1';
                    WHEN "01011" =>
                        signals(13 DOWNTO 11) <= "010";
                        signals(17) <= '1';
                    WHEN "01100" =>
                        signals(15 DOWNTO 14) <= "11";
                        signals(2 DOWNTO 1) <= '01';
                        signals(8) <= '1';
                    WHEN "01101" =>
                        signals(18 DOWNTO 16) <= "111";
                        signals(14) <= '1';
                        signals(10) <= '1';
                    WHEN "01110" =>
                        signals(17) <= '1';
                    WHEN "01111" =>
                        signals(18 DOWNTO 16) <= "111";
                        signals(13 DOWNTO 11) <= "010";
                        signals(7) <= '1';
                    WHEN "10000" =>
                        signals(15) <= '1';
                        signals(13 DOWNTO 11) <= "010";
                        signals(7 DOWNTO 6) <= "11";
                    WHEN "10001" =>
                        signals(5 DOWNTO 3) <= "100";
                    WHEN "10010" =>
                        signals(5 DOWNTO 3) <= "101";
                    WHEN "10011" =>
                        signals(5 DOWNTO 3) <= "110";
                    WHEN "10100" =>
                        signals(22) <= '1';
                        signals(0) <= '1';
                    WHEN "10101" =>
                        signals(0) <= '1';
                        signals(2 DOWNTO 1) <= "01";
                        signals(8) <= '1';
                        signals(15 DOWNTO 14) <= "11";
                    WHEN "10110" =>
                        signals(27) <= '1';
                        signals(0) <= '1';
                        signals(10) <= '1';
                        signals(18 DOWNTO 14) <= "10101";
                    WHEN "10111" =>
                        signals(23) <= '1';
                        signals(0) <= '1';
                        signals(2 DOWNTO 1) <= '01';
                        signals(8) <= '1';
                        signals(15 DOWNTO 14) <= "11";
                    WHEN "11000" =>
                        signals(27) <= '1';
                        signals(0) <= '1';
                        signals(10) <= '1';
                        signals(18 DOWNTO 14) <= "10101";
                    WHEN "11001" =>
                        signals(0) <= '1';
                        signals(28) <= '1';
                        signals(21 DOWNTO 19) <= "111";
                    WHEN OTHERS =>
                        signals <= (OTHERS => '0');
                END CASE;

            ELSIF (branch = '1') THEN

                flush <= "1100";
            ELSIF (exception = '1') THEN
                IF (type_siganl = '0') THEN
                    flush <= "1100";
                    exception_flage <= "01";

                ELSE
                    flush <= "1110";
                    exception_flage <= "11";
                END IF;

            END IF;
        END IF;
    END PROCESS;
END Behavioral;