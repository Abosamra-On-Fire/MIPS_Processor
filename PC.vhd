LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PC_UNIT IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        signals : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        pc_ex : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        pc_mem : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rd1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Index : IN STD_LOGIC;
        epc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rsrc1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        WB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        pc : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END PC_UNIT;

ARCHITECTURE Behavioral OF PC_UNIT IS
    SIGNAL pc_internal : STD_LOGIC_VECTOR(15 DOWNTO 0); -- Internal signal for PC
    SIGNAL latch : STD_LOGIC := '0';
    SIGNAL ex_latch : STD_LOGIC := '0';
    SIGNAL in_epc : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ss : STD_LOGIC := '1';

BEGIN
    PROCESS (clk, reset)
        VARIABLE CURR_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF reset = '1' THEN
            pc_internal <= (OTHERS => '0'); -- Reset PC to 0
            latch <= '0';
            ex_latch <= '0';
            in_epc <= (OTHERS => '0');
            CURR_PC := (OTHERS => '0');

            ELSIF rising_edge(clk) THEN
            CURR_PC := pc_internal;
            IF ex_latch = '1' THEN
                CURR_PC := STD_LOGIC_VECTOR(unsigned(in_epc) + 1);
                ex_latch <= '0';
                ELSE
                IF signals(2) = '1' THEN
                    latch <= '1';
                    CURR_PC := CURR_PC;

                    ELSIF signals(7) = '1' THEN
                    latch <= '0';
                    CURR_PC := (OTHERS => '0');
                    ELSIF latch = '1' THEN
                    CURR_PC := CURR_PC;

                    ELSIF signals(1) = '1' THEN
                    CURR_PC := Rsrc1;
                    ELSIF signals(0) = '1' THEN
                    CURR_PC := WB;
                    ELSIF signals(4) = '1' THEN
                    CURR_PC := Rd1;
                    ELSIF signals(6 DOWNTO 5) = "10" THEN
                    ex_latch <= '1';
                    in_epc <= pc_ex;
                    CURR_PC := "0000000000000010";
                    ELSIF signals(6 DOWNTO 5) = "11" THEN
                    ex_latch <= '1';
                    in_epc <= pc_mem;
                    CURR_PC := "0000000000000011";
                    ELSIF signals(3) = '1' THEN
                    IF Index = '0' THEN
                        CURR_PC := "0000000000000110";
                        ELSIF Index = '1' THEN
                        CURR_PC := "0000000000001000";
                    END IF;

                    ELSE
                    IF (ss = '0') THEN
                        CURR_PC := STD_LOGIC_VECTOR(unsigned(pc_internal) + 1);
                        ELSE
                        ss <= '0';
                    END IF;

                END IF;
            END IF;

            pc_internal <= CURR_PC;
        END IF;
    END PROCESS;
    epc <= in_epc;
    pc <= pc_internal;
END Behavioral;