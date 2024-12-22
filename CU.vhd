LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CU IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        signals : OUT STD_LOGIC_VECTOR(24 DOWNTO 0)
    );
END CU;

ARCHITECTURE Behavioral OF CU IS
BEGIN
    PROCESS (clk, reset, opcode)
    BEGIN
        IF reset = '1' THEN
            signals <= (OTHERS => '0');
        ELSE
            signals <= (OTHERS => '0');
            CASE opcode IS
                WHEN "00001" =>
                    signals(0) <= '1';
                    signals(24 DOWNTO 22) <= "111";
                WHEN "00011" =>
                    signals(17) <= '1';
                WHEN "00100" =>
                    signals(13) <= '1';
                    signals(17) <= '1';
                WHEN "00101" =>
                    signals(9) <= '1';
                WHEN "00110" =>
                    signals(17) <= '1';
                    signals(1) <= '1';
                WHEN "00111" =>
                    signals(17) <= '1';
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
                    signals(2) <= '1';
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
                    signals(0) <= '1';
                    signals(24 DOWNTO 22) <= "011";
                WHEN "10101" =>
                    signals(0) <= '1';
                    signals(2) <= '1';
                    signals(8) <= '1';
                    signals(15 DOWNTO 14) <= "11";
                    signals(24 DOWNTO 22) <= "011";
                WHEN "10110" =>
                    signals(0) <= '1';
                    signals(10) <= '1';
                    signals(18 DOWNTO 14) <= "10101";
                    signals(24 DOWNTO 22) <= "010";
                WHEN "10111" =>
                    signals(0) <= '1';
                    signals(2) <= '1';
                    signals(8) <= '1';
                    signals(15 DOWNTO 14) <= "11";
                    signals(24 DOWNTO 22) <= "110";
                WHEN "11000" =>
                    signals(0) <= '1';
                    signals(10) <= '1';
                    signals(18 DOWNTO 14) <= "10101";
                    signals(24 DOWNTO 22) <= "010";
                WHEN "11001" =>
                    signals(0) <= '1';
                    signals(24 DOWNTO 19) <= "111111";
                WHEN OTHERS =>
                    signals <= (OTHERS => '0');
            END CASE;
        END IF;
    END PROCESS;
END Behavioral;