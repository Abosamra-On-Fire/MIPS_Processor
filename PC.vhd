LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY PC_UNIT IS
    PORT (
        clk       : IN STD_LOGIC;
        reset     : IN STD_LOGIC;
        pc_select : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END PC_UNIT;

ARCHITECTURE Behavioral OF PC_UNIT IS
    SIGNAL pc_internal       : STD_LOGIC_VECTOR(15 DOWNTO 0); -- Internal signal for PC
    SIGNAL pc_select_delayed : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Delayed pc_select
BEGIN
    process(clk, reset)
    begin 
        if reset = '1' then
            pc_internal <= (others => '0'); -- Reset PC to 0
            pc_select_delayed <= (others => '1'); -- Reset delayed pc_select
        elsif rising_edge(clk) then
            -- Update PC based on the delayed pc_select value
            case pc_select_delayed is
                when "000" =>
                    pc_internal <= std_logic_vector(unsigned(pc_internal) + 1); -- Increment PC
                when others =>
                    pc_internal <= pc_internal; -- Hold current PC value
            end case;

            -- Delay pc_select by one cycle
            pc_select_delayed <= pc_select;
        end if;
    end process;

    pc <= pc_internal; -- Assign internal PC signal to output port

END Behavioral;
