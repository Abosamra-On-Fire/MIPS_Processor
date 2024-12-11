library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FU is
    Port (
    R1 : in STD_LOGIC_VECTOR (2 downto 0);
    R2 : in STD_LOGIC_VECTOR (2 downto 0);
    ex_r : in STD_LOGIC_VECTOR (2 downto 0);
    mem_r : in STD_LOGIC_VECTOR (2 downto 0);
    a : out STD_LOGIC_VECTOR (1 downto 0);
    b : out STD_LOGIC_VECTOR (1 downto 0);
)
end FU;

architecture Behavioral of FU is
begin
    process(R1, R2, ex_r, mem_r)
    begin
        if (R1 = ex_r) then
            a <= "10"; -- to select a = ex 
        elsif (R1 = mem_r) then
            a <= "01"; -- to select a = mem
        else
            a <= "00";    
        end if;

        if (R1 = ex_r) then
            b <= "10"; -- to select b = ex 
        elsif (R1 = mem_r) then
            b <= "01"; -- to select b = mem
        else
            b <= "00";    
        end if;
    end process;