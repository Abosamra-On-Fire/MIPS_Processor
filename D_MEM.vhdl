library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity D_MEM is
    generic (
        SIZE : integer := 4096 
    );
    Port ( 
    Data : in STD_LOGIC_VECTOR (15 downto 0);
    Address : in STD_LOGIC_VECTOR (15 downto 0);
    mem_write : in STD_LOGIC;
    mem_read : in STD_LOGIC;
    clk : in STD_LOGIC;
    Data_out : out STD_LOGIC_VECTOR (15 downto 0)
    );
end D_MEM;

architecture Behavioral of D_MEM is
    type memory_array is array (0 to MEM_SIZE-1) of std_logic_vector(31 downto 0);
    signal memory : memory_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (mem_write = '1') then
                memory(to_integer(unsigned(Address))) <= Data;
            end if;
            if (mem_read = '1') then
                Data_out <= memory(to_integer(unsigned(Address)));
            end if;
        end if;
    end process;
end Behavioral;