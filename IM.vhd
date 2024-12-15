library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity IM is
    port (
        clk      : in std_logic;
        load     : in std_logic; 
        program  : in std_logic_vector(10*16-1 downto 0); 
        pc  : in std_logic_vector(15 downto 0); 
        instruction : out std_logic_vector(15 downto 0) 
    );
end IM;

architecture Behavioral of IM is
    type memory_array is array (0 to 9) of std_logic_vector(15 downto 0);
    signal instruction_memory : memory_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if load = '1' then
                for i in 0 to 9 loop
                    instruction_memory(i) <= program((i+1)*16-1 downto i*16);
                end loop;
            else
                instruction <= instruction_memory(to_integer(unsigned(pc(11 downto 0))));
            end if;
        end if;
    end process;

end Behavioral;
