LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CPU IS
    PORT (
        clk, reset : IN STD_LOGIC;
        out_port_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

    );
END CPU;

ARCHITECTURE Behavioral OF CPU IS

    -- CU signals
    SIGNAL pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL instr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL signals : STD_LOGIC_VECTOR(28 DOWNTO 0);
    SIGNAL rd1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rd2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL alu_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL carry : STD_LOGIC;
    SIGNAL negative : STD_LOGIC;
    SIGNAL zero : STD_LOGIC;
    SIGNAL branch : STD_LOGIC;
    SIGNAL stack : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL flush : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL exception_flage : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL mem_data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mem_address : STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- Pipeline registers using the reg module
    SIGNAL IF_ID_IN : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IF_ID_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ID_EX_IN : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL ID_EX_OUT : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL EX_MEM_IN : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL EX_MEM_OUT : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL MEM_WB_IN : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL MEM_WB_OUT : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- reg component for pipeline registers
    COMPONENT reg IS
        GENERIC (
            SIZE : INTEGER := 128
        );
        PORT (
            clk : IN STD_LOGIC;
            Data_in : IN STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0);
            en : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            Data_out : OUT STD_LOGIC_VECTOR(SIZE - 1 DOWNTO 0)
        );
    END COMPONENT reg;

    -- declarations
    COMPONENT IM IS
        PORT (
            clk : IN STD_LOGIC;
            location : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            reset : IN STD_LOGIC;
            instruction : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT IM;

    COMPONENT CU IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            opcode : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            signals : OUT STD_LOGIC_VECTOR(28 DOWNTO 0);

            branch : IN STD_LOGIC;
            stack : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            flush : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            exception_flage : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            mem_address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        );
    END COMPONENT CU;

    COMPONENT PC_UNIT IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            signals : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            epc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rd1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Index : IN STD_LOGIC;
            Rsrc1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            WB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            pc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT PC_UNIT;

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

    COMPONENT EX IS
        PORT (
            R1, R2, R1_FORWARD_MEM, R2_FORWARD_MEM, R1_FORWARD_WB, R2_FORWARD_WB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            OP1, OP2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Alu_Source1, Alu_Source2 : IN STD_LOGIC;
            Alu_control : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            conditional_branch : IN STD_LOGIC;
            branch_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            alu_enable : IN STD_LOGIC;
            out_port_signal : IN STD_LOGIC;
            stack_write : IN STD_LOGIC;
            stack_add : IN STD_LOGIC;

            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            branch_out : OUT STD_LOGIC;
            out_port_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_to_mem : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_to_mem_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            stack_pointer : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT EX;
    COMPONENT D_MEM IS
        GENERIC (
            SIZE : INTEGER := 4096
        );
        PORT (
            Data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            Address : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            mem_write : IN STD_LOGIC;
            mem_read : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            Data_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    pc_inst : PC_UNIT
    PORT MAP(
        clk => clk,
        reset => reset,
        signals => signals(24 DOWNTO 22),
        pc => pc
    );
    IF_ID_IN(15 DOWNTO 0) <= pc;

    instruction_mem : IM
    PORT MAP(
        clk => clk,
        location => pc(11 DOWNTO 0),
        reset => reset,
        instruction => instr
    );
    IF_ID_IN(31 DOWNTO 16) <= instr;
    IF_ID_reg : reg
    GENERIC MAP(
        SIZE => 32
    )
    PORT MAP(
        clk => clk,
        Data_in => IF_ID_IN,
        en => '1',
        rst => reset,
        Data_out => IF_ID_OUT,
        flage_flush => flush(0)
    );

    control_unit : CU
    PORT MAP(
        clk => clk,
        reset => reset,
        opcode => IF_ID_OUT(31 DOWNTO 27),
        signals => signals,

        branch => branch, ----------------
        stack => stack, ---------------
        flush => flush,
        exception_flage => exception_flage,
        mem_address => mem_address
    );
    rf : register_file
    PORT MAP(
        clk => clk,
        reset => reset,
        reg_write => MEM_WB_OUT(0), --should take from wb

        write_addr => MEM_WB_OUT(19 DOWNTO 17),
        write_data => MEM_WB_OUT(16 DOWNTO 1), --should take from wb
        read_addr1 => IF_ID_OUT(23 DOWNTO 21),
        read_addr2 => IF_ID_OUT(20 DOWNTO 18),

        read_data1 => rd1,
        read_data2 => rd2
    );
    ID_EX_IN(70 DOWNTO 46) <= signals; -- 70 to 46 == 24 - 0
    ID_EX_IN(127 DOWNTO 112) <= rd1;
    ID_EX_IN(111 DOWNTO 96) <= rd2;
    ID_EX_IN(95 DOWNTO 80) <= IF_ID_OUT(15 DOWNTO 0); --pc
    ID_EX_IN(79 DOWNTO 77) <= IF_ID_OUT(26 DOWNTO 24); --rd add
    ID_EX_IN(76 DOWNTO 74) <= IF_ID_OUT(23 DOWNTO 21); -- r1 add
    ID_EX_IN(73 DOWNTO 71) <= IF_ID_OUT(20 DOWNTO 18); -- r2 add
    -- ID/EX Register (pipeline register between ID and EX stages)
    ID_EX_reg : reg
    GENERIC MAP(
        SIZE => 128
    )
    PORT MAP(
        clk => clk,
        Data_in => ID_EX_IN,
        en => '1',
        rst => reset,
        Data_out => ID_EX_OUT,
        flage_flush => flush(1)
    );

    ex_inst : EX
    PORT MAP(
        R1 => rd1,
        R2 => rd2,
        R1_FORWARD_MEM => (OTHERS => '0'),
        R2_FORWARD_MEM => (OTHERS => '0'),
        R1_FORWARD_WB => (OTHERS => '0'),
        R2_FORWARD_WB => (OTHERS => '0'),
        OP1 => ID_EX_OUT(76 DOWNTO 75),
        OP2 => ID_EX_OUT(74 DOWNTO 73),

        PC => ID_EX_OUT(95 DOWNTO 80),

        Alu_Source1 => signals(6),
        Alu_Source2 => signals(7),
        Alu_control => signals(13 DOWNTO 11),

        conditional_branch => signals(3),

        branch_sel => signals(5 DOWNTO 4),

        alu_enable => signals(26),

        out_port_signal => signals(9),
        stack_write => signals(14),
        stack_add => signals(10),
        clk => clk,
        reset => reset,
        imm => IF_ID_OUT(31 DOWNTO 16),
        Alu_out => alu_out,
        branch_out => branch,
        out_port_data => out_port_data,

        data_to_mem => signals(2 DOWNTO 1),

        data_to_mem_out => mem_data_out,
        stack_pointer => stack
    );

    EX_MEM_IN(63 DOWNTO 48) <= alu_out;
    EX_MEM_IN(47) <= ID_EX_OUT(64); --mem to reg
    EX_MEM_IN(46) <= ID_EX_OUT(63); --write reg
    EX_MEM_IN(45) <= ID_EX_OUT(62);--mem read
    EX_MEM_IN(44) <= ID_EX_OUT(61); --mem write
    EX_MEM_IN(43) <= ID_EX_OUT(54); --wb add set
    EX_MEM_IN(42 DOWNTO 40) <= ID_EX_OUT(79 DOWNTO 77); --wb add set

    -- EX/MEM Register (pipeline register between EX and MEM stages)
    EX_MEM_reg : reg
    GENERIC MAP(
        SIZE => 64
    )
    PORT MAP(
        clk => clk,
        Data_in => EX_MEM_IN,
        en => '1', -- Enable the register to load data
        rst => reset,
        Data_out => EX_MEM_OUT,
        flage_flush => OPEN
    );
    ------------------------------------------
    ---------------------DM------------------
    -----------------------------------------
    MEM_WB_IN(0) <= EX_MEM_OUT(46); --write reg
    MEM_WB_IN(16 DOWNTO 1) <= EX_MEM_OUT(63 DOWNTO 48);--alu out
    MEM_WB_IN(19 DOWNTO 17) <= EX_MEM_OUT(42 DOWNTO 40);
    MEM_WB_reg : reg
    GENERIC MAP(
        SIZE => 64
    )
    PORT MAP(
        clk => clk,
        Data_in => MEM_WB_IN,
        en => '1', -- Enable the register to load data
        rst => reset,
        Data_out => MEM_WB_OUT,
        flage_flush => OPEN
    );

    -- Output connections

END Behavioral;