library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity CPU is
    port (
        clk, reset,pc : in std_logic;                    
    );
end CPU;

architecture Behavioral of CPU is
    signal instr std_logic_vector(15 downto 0);
    signal signals std_logic_vector(24 downto 0);
    IM: entity work.IM 
        port map (
            clk         => clk,
            pc          => pc,     
            instruction => instr           
        );

    control: entity work.CU
        port map (
            clk     => clk,
            reset   => reset,
            opcode  => instr(15 downto 13), 
            signals => signals             
        );


    component register_file is 
        port (
            clk        : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            reg_write  : in  STD_LOGIC;
            
            write_addr : in  STD_LOGIC_VECTOR(3 downto 0);
            write_data : in  STD_LOGIC_VECTOR(15 downto 0);
            read_addr1 : in  STD_LOGIC_VECTOR(3 downto 0);
            read_addr2 : in  STD_LOGIC_VECTOR(3 downto 0);
            
            read_data1 : out STD_LOGIC_VECTOR(15 downto 0);
            read_data2 : out STD_LOGIC_VECTOR(15 downto 0)
          );        
    end component register_file;

end Behavioral;