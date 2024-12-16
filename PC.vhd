LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PC IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        pc_select : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        pc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END PC;

ARCHITECTURE Behavioral OF PC IS

process(clk,reset)
begin 
    if(reset='1') then
        pc <= (others=>'0');
    elsif(rising_edge(clk)) then
        if(pc_select='000') then
            pc <= pc+1;
        else
            pc <= pc;
        end if;
    end if;
end process;
END Behavioral;
