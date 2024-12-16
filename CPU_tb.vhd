LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CPU_tb IS
END CPU_tb;

ARCHITECTURE behavior OF CPU_tb IS

    COMPONENT CPU IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);    
            carry : OUT STD_LOGIC;
            negative : OUT STD_LOGIC;
            zero : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL alu_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL carry : STD_LOGIC;
    SIGNAL negative : STD_LOGIC;
    SIGNAL zero : STD_LOGIC;

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    uut: CPU
        PORT MAP (
            clk => clk,
            reset => reset,
            alu_out => alu_out,
            carry => carry,
            negative => negative,
            zero => zero
        );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    stimulus: PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        
        WAIT FOR 50 ns;

        WAIT;
    END PROCESS;

END behavior;
