LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PC_UNIT IS
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
END PC_UNIT;

ARCHITECTURE Behavioral OF PC_UNIT IS
    SIGNAL pc_internal : STD_LOGIC_VECTOR(15 DOWNTO 0); -- Internal signal for PC
    SIGNAL pc_select_delayed : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Delayed pc_select
    SIGNAL pc_select : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
    PROCESS (signals)
    BEGIN
        IF signals(1) = '1' THEN
            pc_select <= "001";
        ELSIF signals(0) = '1' THEN
            pc_select <= "010";
        ELSIF signals(4) = '1' THEN
            pc_select <= "011";
        ELSIF signals(6 DOWNTO 5) = "10" THEN
            pc_select <= "100";
        ELSIF signals(6 DOWNTO 5) = "11" THEN
            pc_select <= "101";
        ELSIF signals(3) = '1' THEN
            pc_select <= "110";
        ELSIF signals(2) = '1' THEN
            pc_select <= "111";
        ELSIF signals(7) = '1' THEN
            pc_select <= "111";
        ELSE
            pc_select <= "000";
        END IF;
    END PROCESS;
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            pc_internal <= (OTHERS => '0'); -- Reset PC to 0
            pc_select_delayed <= (OTHERS => '1'); -- Reset delayed pc_select
        ELSIF rising_edge(clk) THEN
            -- Update PC based on the delayed pc_select value
            CASE pc_select_delayed IS
                WHEN "000" =>
                    pc_internal <= STD_LOGIC_VECTOR(unsigned(pc_internal) + 1); -- Increment PC
                WHEN "001" =>
                    pc_internal <= Rsrc1;
                WHEN "010" =>
                    pc_internal <= WB;
                WHEN "011" =>
                    pc_internal <= Rd1;
                WHEN "100" =>
                    pc_internal <= "0000000000000010";
                WHEN "101" =>
                    pc_internal <= "0000000000000011";
                WHEN "110" =>
                    IF Index = '0' THEN
                        pc_internal <= "0000000000000110";
                    ELSIF Index = '1' THEN
                        pc_internal <= "0000000000001000";
                    END IF;
                WHEN "111" =>
                    pc_internal <= pc_internal;
                WHEN OTHERS =>
                    pc_internal <= pc_internal;
            END CASE;

            -- Delay pc_select by one cycle
            pc_select_delayed <= pc_select;
        END IF;
    END PROCESS;

    pc <= pc_internal; -- Assign internal PC signal to output port

END Behavioral;