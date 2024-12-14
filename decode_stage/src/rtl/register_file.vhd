library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
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
end register_file;

architecture register_file_arch of register_file is

    constant NUM_REGISTERS : integer := 8;
    constant DATA_WIDTH    : integer := 16;

    type register_file_type is array (0 to NUM_REGISTERS - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal register_file : register_file_type;

begin

    writing_data_process : process( clk, reset )
    begin
        if reset = '1' then
            reset_loop : for i in 0 to NUM_REGISTERS - 1 loop
                register_file(i) <= (others => '0');
            end loop ; -- reset_loop
        elsif rising_edge(clk) then
            if reg_write = '1' then
                register_file(to_integer(unsigned(write_addr))) <= write_data;
            end if ;
        end if ;
    end process ; -- writing_data_process

    read_data1 <= register_file(to_integer(unsigned(read_addr1)));
    read_data2 <= register_file(to_integer(unsigned(read_addr2)));

end register_file_arch ; -- register_file_arch