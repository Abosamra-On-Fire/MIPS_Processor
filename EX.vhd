LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY EX IS
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
END EX;
ARCHITECTURE rtl OF EX IS

    SIGNAL R1_OUT_FORWARD, R2_OUT_FORWARD, OP1_in, OP2_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL BRANCH_ARRAY : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL carry, negative, zero : STD_LOGIC;

    COMPONENT ALU_Forward
        PORT (
            r1, r2, r1_forward_mem, r2_forward_mem, r1_forward_wb, r2_forward_wb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            op1, op2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            r1_out, r2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ALU_Source
        PORT (
            op1_forward : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            op2_forward : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            alu_source1 : IN STD_LOGIC;
            alu_source2 : IN STD_LOGIC;
            op1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            op2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

        );
    END COMPONENT;

    COMPONENT Branch
        PORT (

            branch_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            conditional_branch : IN STD_LOGIC;
            flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            branch_flage : OUT STD_LOGIC

        );
    END COMPONENT;

    COMPONENT out_port
        PORT (
            data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_port_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_port_signal : IN STD_LOGIC

        );
    END COMPONENT;

    COMPONENT ALU
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            OP : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            carry : OUT STD_LOGIC;
            negative : OUT STD_LOGIC;
            zero : OUT STD_LOGIC;
            en : IN STD_LOGIC;
            flags_arr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) -- Output flags
        );
    END COMPONENT;

    COMPONENT Stack
        PORT (
            clk : IN STD_LOGIC; -- Clock signal
            reset : IN STD_LOGIC; -- Reset signal
            stack_write : IN STD_LOGIC; -- Write enable to store updated SP
            stack_add : IN STD_LOGIC; -- Increment (push) or Decrement (pop)
            stack_pointer : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- Output the current pointer value
        );
    END COMPONENT;
    COMPONENT Write_Data IS
        PORT (
            flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            rs1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_to_mem : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    ALU_FORWARD_ex : ALU_Forward PORT MAP(
        r1 => R1,
        r2 => R2,
        r1_forward_mem => R1_FORWARD_MEM,
        r2_forward_mem => R2_FORWARD_MEM,
        r1_forward_wb => R1_FORWARD_WB,
        r2_forward_wb => R2_FORWARD_WB,
        op1 => OP1,
        op2 => OP2,
        r1_out => R1_OUT_FORWARD,
        r2_out => R2_OUT_FORWARD
    );

    ALU_SOURCE_ex : ALU_Source PORT MAP(
        op1_forward => R1_OUT_FORWARD,
        op2_forward => R2_OUT_FORWARD,
        imm => imm,
        alu_source1 => Alu_Source1,
        alu_source2 => Alu_Source2,
        op1 => OP1_in,
        op2 => OP2_in
    );

    ALU_ex : ALU PORT MAP(
        clk => clk,
        reset => reset,
        OP => Alu_control,
        A => OP1_in,
        B => OP2_in,
        result => Alu_out,
        carry => carry,
        negative => negative,
        zero => zero,
        en => alu_enable,
        flags_arr => BRANCH_ARRAY
    );

    BRANCH_ex : Branch PORT MAP(
        branch_sel => branch_sel,
        conditional_branch => conditional_branch,
        flags => BRANCH_ARRAY,
        branch_flage => branch_out
    );

    OUT_PORT_ex : out_port PORT MAP(
        data => R1_OUT_FORWARD,
        out_port_data => out_port_data,
        out_port_signal => out_port_signal
    );

    STACK_ex : Stack PORT MAP(
        clk => clk,
        reset => reset,
        stack_write => stack_write,
        stack_add => stack_add,
        stack_pointer => stack_pointer
    );

    Write_Data_ex : Write_Data PORT MAP(
        flags => BRANCH_ARRAY,
        rs1 => R1_OUT_FORWARD,
        pc => PC,
        data_to_mem => data_to_mem,
        data_out => data_to_mem_out
    );
END ARCHITECTURE;