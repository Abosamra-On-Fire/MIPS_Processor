library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity CPU is
    port (
        clk, reset,pc : in std_logic;                    
        alu_out : out std_logic_vector(15 downto 0);                
        carry : out std_logic;
        negative : out STD_LOGIC;
        zero : out STD_LOGIC            
);
end CPU;

architecture Behavioral of CPU is

    -- CU signals
    signal instr : std_logic_vector(15 downto 0);
    signal signals : std_logic_vector(24 downto 0);
    signal rd1 : std_logic_vector(15 downto 0);
    signal rd2 : std_logic_vector(15 downto 0);
    

    -- declarations
    component IM is
        port (
            clk      : in std_logic;
            -- load     : in std_logic; 
            -- program  : in std_logic_vector(10*16-1 downto 0); 
            pc  : in std_logic_vector(15 downto 0); 
            reset: in std_logic;
            instruction : out std_logic_vector(15 downto 0) 
        );
        end component IM;

    component CU is
        port (
            clk     : in std_logic;                      
            reset   : in std_logic;                      
            opcode  : in std_logic_vector(4 downto 0);  
            signals : out std_logic_vector(24 downto 0)   
        );
    
    end component CU;

    component register_file is
        port (
            clk        : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            reg_write  : in  STD_LOGIC;
            
            write_addr : in  STD_LOGIC_VECTOR(2 downto 0);
            write_data : in  STD_LOGIC_VECTOR(15 downto 0);
            read_addr1 : in  STD_LOGIC_VECTOR(2 downto 0);
            read_addr2 : in  STD_LOGIC_VECTOR(2 downto 0);
            
            read_data1 : out STD_LOGIC_VECTOR(15 downto 0);
            read_data2 : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component register_file;

    component ALU is
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            OP : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            carry : OUT STD_LOGIC;
            negative : OUT STD_LOGIC;
            zero : OUT STD_LOGIC
        );
    end component ALU;

    begin

    instruction_mem : IM 
    port map (
        clk         => clk,
        pc          => (others => '0'),
        reset       => reset,
        instruction => instr           
    );

    control_unit : CU 
        port map (
            clk     => clk,
            reset   => reset,
            opcode  => instr(15 downto 11), 
            signals => signals             
        );



    rf : register_file 
        port map(
            clk        => clk,
            reset      => reset,
            reg_write  => signals(17),
        
            write_addr => instr(10 downto 8),
            write_data => (others => '0'), 
            read_addr1 => instr(7 downto 5),
            read_addr2 => instr(4 downto 2),
        
            read_data1 => rd1,
            read_data2 => rd2
    );        
    

    alu_inst : ALU 
        port map(
            clk => clk,
            reset => reset,
            OP => signals(13 downto 11),
            A => rd1,
            B => rd2,
            result =>alu_out,
            carry => carry,
            negative =>negative,
            zero =>zero
        );

    


    end Behavioral;