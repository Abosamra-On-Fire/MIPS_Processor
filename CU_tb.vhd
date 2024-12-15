library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU_tb is
-- No ports for testbench
end CU_tb;

architecture Behavioral of CU_tb is
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal opcode  : std_logic_vector(4 downto 0) := (others => '0');
    signal signals : std_logic_vector(24 downto 0);
    
    constant clk_period : time := 10 ns;
begin
    uut: entity work.CU
        port map (
            clk     => clk,
            reset   => reset,
            opcode  => opcode,
            signals => signals
        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimulus_process: process
    begin
        reset <= '1';
        wait for clk_period;
        reset <= '0';

        opcode <= "00001";
        wait for clk_period;

        opcode <= "00011";
        wait for clk_period;

        opcode <= "00100";
        wait for clk_period;

        opcode <= "01000";
        wait for clk_period;

        opcode <= "10101";
        wait for clk_period;

        reset <= '1';
        wait for clk_period;
        reset <= '0';

        -- End simulation
        wait;
    end process;
end Behavioral;
