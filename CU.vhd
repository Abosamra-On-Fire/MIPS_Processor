library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU is
    port (
        clk     : in std_logic;                      
        reset   : in std_logic;                      
        opcode  : in std_logic_vector(4 downto 0);  
        signals : out std_logic_vector(24 downto 0)   
    );
end CU;

architecture Behavioral of CU is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            signals <= (others => '0'); 
        elsif rising_edge(clk) then
            signals <= (others => '0'); 
            case opcode is
                when "00001" =>
                    signals(0) <= '1';
                    signals(24 downto 22) <= "111";
                when "00011" =>
                    signals(17) <= '1';
                when "00100" =>
                    signals(13) <= '1';
                    signals(17) <= '1';
                when "00101" =>
                    signals(9) <= '1';
                when "00110" =>
                    signals(17) <= '1';
                    signals(1) <= '1';
                when "00111" =>
                    signals(17) <= '1';
                when "01000" =>
                    signals(13 downto 11) <= "010";
                    signals(17) <= '1';
                when "01001" =>
                    signals(13 downto 11) <= "011";
                    signals(17) <= '1';
                when "01010" =>
                    signals(13 downto 11) <= "100";
                    signals(17) <= '1';
                when "01011" =>
                    signals(13 downto 11) <= "010";
                    signals(17) <= '1';
                when "01100" =>
                    signals(15 downto 14) <= "11";
                    signals(2) <= '1';
                    signals(8) <= '1';
                when "01101" =>
                    signals(18 downto 16) <= "111";
                    signals(14) <= '1';
                    signals(10) <= '1';
                when "01110" =>
                    signals(17) <= '1';
                when "01111" =>
                    signals(18 downto 16) <= "111";
                    signals(13 downto 11) <= "010";
                    signals(7) <= '1';
                when "10000" =>
                    signals(15) <= '1';
                    signals(13 downto 11) <= "010";
                    signals(7 downto 6) <= "11";
                when "10001" =>
                    signals(5 downto 3) <= "100";
                when "10010" =>
                    signals(5 downto 3) <= "101";
                when "10011" =>
                    signals(5 downto 3) <= "110";
                when "10100" =>
                    signals(0) <= '1';
                    signals(24 downto 22) <= "011";
                when "10101" =>
                    signals(0) <= '1';
                    signals(2) <= '1';
                    signals(8) <= '1';
                    signals(15 downto 14) <= "11";
                    signals(24 downto 22) <= "011";
                when "10110" =>
                    signals(0) <= '1';
                    signals(10) <= '1';
                    signals(18 downto 14) <= "10101";
                    signals(24 downto 22) <= "010";
                when "10111" =>
                    signals(0) <= '1';
                    signals(2) <= '1';
                    signals(8) <= '1';
                    signals(15 downto 14) <= "11";
                    signals(24 downto 22) <= "110";
                when "11000" =>
                    signals(0) <= '1';
                    signals(10) <= '1';
                    signals(18 downto 14) <= "10101";
                    signals(24 downto 22) <= "010";
                when "11001" =>
                    signals(0) <= '1';
                    signals(24 downto 19) <= "111111";
                when others =>
                    signals <= (others => '0'); 
            end case;
        end if;
    end process;
end Behavioral;
