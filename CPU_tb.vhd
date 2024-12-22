LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CPU_tb IS
END CPU_tb;

ARCHITECTURE behavior OF CPU_tb IS

    COMPONENT CPU IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    uut : CPU
    PORT MAP(
        clk => clk,
        reset => reset
    );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    stimulus : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';

        WAIT FOR 50 ns;

        WAIT;
    END PROCESS;

END behavior;