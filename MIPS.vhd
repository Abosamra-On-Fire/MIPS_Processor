library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity MIPS is
    port (
        clk, reset : in std_logic;                    
        pc_out     : out std_logic_vector(15 downto 0) 
    );
end MIPS;

architecture Behavioral of MIPS is
    signal pc_current : std_logic_vector(15 downto 0); 
    signal pc_next    : std_logic_vector(15 downto 0); 
    signal instr      : std_logic_vector(15 downto 0); 
    signal signals    : std_logic_vector(24 downto 0); 

begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_current <= (others => '0');
        elsif rising_edge(clk) then
            pc_current <= pc_next; 
        end if;
    end process;

    IM: entity work.IM 
        port map (
            clk         => clk,
            load        => '0',           
            program     => (others => '0'), 
            pc          => pc_current,     
            instruction => instr           
        );

    control: entity work.CU
        port map (
            clk     => clk,
            reset   => reset,
            opcode  => instr(15 downto 13), 
            signals => signals             
        );

    process(signals,pc_current)
    begin
        if signals(24 downto 22) = "000" then
            pc_next <= std_logic_vector(unsigned(pc_current) + 2); 
        else
            pc_next <= pc_current;  
        end if;
    end process;

    pc_out <= pc_current;

end Behavioral;
