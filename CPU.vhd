LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CPU IS
    PORT (
        clk, reset, pc : IN STD_LOGIC;
        alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        carry : OUT STD_LOGIC;
        negative : OUT STD_LOGIC;
        zero : OUT STD_LOGIC
    );
END CPU;

ARCHITECTURE Behavioral OF CPU IS

    -- CU signals
    SIGNAL instr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL signals : STD_LOGIC_VECTOR(24 DOWNTO 0);
    SIGNAL rd1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rd2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- declarations
    COMPONENT IM IS
        PORT (
            clk : IN STD_LOGIC;
            -- load     : in std_logic; 
            -- program  : in std_logic_vector(10*16-1 downto 0); 
            pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            reset : IN STD_LOGIC;
            instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT IM;

    COMPONENT CU IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            signals : OUT STD_LOGIC_VECTOR(24 DOWNTO 0)
        );

    END COMPONENT CU;

    COMPONENT register_file IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            reg_write : IN STD_LOGIC;

            write_addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            read_addr1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            read_addr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            read_data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            read_data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT register_file;

    COMPONENT ALU IS
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
    END COMPONENT ALU;

BEGIN

    instruction_mem : IM
    PORT MAP(
        clk => clk,
        pc => (OTHERS => '0'),
        reset => reset,
        instruction => instr
    );

    control_unit : CU
    PORT MAP(
        clk => clk,
        reset => reset,
        opcode => instr(15 DOWNTO 11),
        signals => signals
    );

    rf : register_file
    PORT MAP(
        clk => clk,
        reset => reset,
        reg_write => signals(17),

        write_addr => instr(10 DOWNTO 8),
        write_data => (OTHERS => '0'),
        read_addr1 => instr(7 DOWNTO 5),
        read_addr2 => instr(4 DOWNTO 2),

        read_data1 => rd1,
        read_data2 => rd2
    );
    alu_inst : ALU
    PORT MAP(
        clk => clk,
        reset => reset,
        OP => signals(13 DOWNTO 11),
        A => rd1,
        B => rd2,
        result => alu_out,
        carry => carry,
        negative => negative,
        zero => zero
    );
END Behavioral;