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
        ex_reg_write : in STD_LOGIC;
        mem_reg_write : in STD_LOGIC;
       
        mem_rd : in STD_LOGIC_VECTOR (2 downto 0);
        a : out STD_LOGIC_VECTOR (1 downto 0);
        b : out STD_LOGIC_VECTOR (1 downto 0)
    );
end FU;

architecture Behavioral of FU is
begin
    process(R1, R2, ex_r, mem_r, ex_reg_write, mem_reg_write, ex_rd, mem_rd)
    begin
        -- Forwarding for A
        if (ex_reg_write = '1'  and ex_rd = R1) then
            a <= "01"; -- Forward from EX stage
        elsif (mem_reg_write = '1' and mem_rd = R1 and not (ex_reg_write = '1' and ex_rd = R1)) then
            a <= "10"; -- Forward from MEM stage
        else
            a <= "00"; -- No forwarding
        end if;

        -- Forwarding for B
        if (ex_reg_write = '1'  and ex_rd = R2) then
            b <= "01"; -- Forward from EX stage
        elsif (mem_reg_write = '1'  and mem_rd = R2 and not (ex_reg_write = '1' and ex_rd = R2)) then
            b <= "10"; -- Forward from MEM stage
        else
            b <= "00"; -- No forwarding
        end if;
    end process;
end Behavioral;