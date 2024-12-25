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
    SIGNAL curr_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL signals_delayed : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL latch : STD_LOGIC := '0';
    SIGNAL ex_latch : STD_LOGIC := '0';
    SIGNAL in_epc : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            pc_internal <= (OTHERS => '0'); -- Reset PC to 0
            signals_delayed <= (OTHERS => '0'); -- Reset delayed pc_select
            ELSIF rising_edge(clk) THEN
            curr_pc <= pc_internal;
            IF ex_latch = '1' THEN
                pc_internal <= in_epc;
                ex_latch <= '0';
                ELSE
                IF signals_delayed(1) = '1' THEN
                    pc_internal <= Rsrc1;
                    ELSIF signals_delayed(0) = '1' THEN
                    pc_internal <= WB;
                    ELSIF signals_delayed(4) = '1' THEN
                    pc_internal <= Rd1;
                    ELSIF signals_delayed(6 DOWNTO 5) = "10" THEN
                    ex_latch <= '1';
                    in_epc <= pc_ex;
                    pc_internal <= "0000000000000010";
                    ELSIF signals_delayed(6 DOWNTO 5) = "11" THEN
                    ex_latch <= '1';
                    in_epc <= pc_mem;
                    pc_internal <= "0000000000000011";
                    ELSIF signals_delayed(3) = '1' THEN
                    IF Index = '0' THEN
                        pc_internal <= "0000000000000110";
                        ELSIF Index = '1' THEN
                        pc_internal <= "0000000000001000";
                    END IF;
                    ELSIF signals_delayed(2) = '1' THEN
                    latch <= '1';
                    pc_internal <= pc_internal;
                    ELSIF latch = '1' THEN
                    pc_internal <= pc_internal;
                    ELSIF signals_delayed(7) = '1' THEN
                    latch <= '0';
                    pc_internal <= (OTHERS => '0');

                    ELSE
                    pc_internal <= STD_LOGIC_VECTOR(unsigned(pc_internal) + 1);
                END IF;
            END IF;
            signals_delayed <= signals;
        END IF;
    END PROCESS;
    pc <= curr_pc;
    epc <= in_epc;
END Behavioral;