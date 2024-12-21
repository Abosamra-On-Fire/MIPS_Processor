LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity reg is
    generic (
        SIZE : integer := 128
    );
    port(
        clk : in STD_LOGIC;
        Data_in : in STD_LOGIC_VECTOR (SIZE-1 downto 0);
        en : in STD_LOGIC;
        rst : in std_logic;
        Data_out : out STD_LOGIC_VECTOR (SIZE-1 downto 0)
    );
end reg;

architecture Behavioral of reg is
    signal memory_array : std_logic_vector(SIZE-1 downto 0) := (others => '0');
    begin
        process(clk,rst,en)
        begin
            if rst = '1' then
                memory_array <= (others => '0');
            elsif en = '1' then
                if (rising_edge(clk)) then
                    memory_array <= Data_in;
                end if;
            end if;
            Data_out <= memory_array;
        end process;
end Behavioral;