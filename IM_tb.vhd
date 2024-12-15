library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- For `unsigned` and `to_integer` conversions

entity IM_tb is
    -- No ports for a testbench
end IM_tb;

architecture Behavioral of IM_tb is
    -- Signals for the DUT
    signal clk         : std_logic := '0';
    signal load        : std_logic := '0';
    signal program     : std_logic_vector(10*16-1 downto 0) := (others => '0');
    signal pc          : std_logic_vector(15 downto 0) := (others => '0');
    signal instruction : std_logic_vector(15 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the DUT (IM)
    uut: entity work.IM
        port map (
            clk         => clk,
            load        => load,
            program     => program,
            pc          => pc,
            instruction => instruction
        );

    -- Clock generation
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus_process: process
        variable test_program : std_logic_vector(10*16-1 downto 0);
        variable i            : integer;
    begin
        -- Initialize the program memory
        for i in 0 to 9 loop
            test_program((i+1)*16-1 downto i*16) := std_logic_vector(to_unsigned(i, 16));
        end loop;

        -- Load the program into instruction memory
        load <= '1';
        program <= test_program;
        wait for clk_period;

        load <= '0';
        wait for clk_period;

        for i in 0 to 9 loop
            pc <= std_logic_vector(to_unsigned(i, 16)); -- Set program counter
            wait for clk_period;
            assert instruction = std_logic_vector(to_unsigned(i, 16))
            report "Instruction mismatch at PC=" & integer'image(i)
            severity error;
        end loop;
        wait;
    end process;

end Behavioral;
