LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Flags IS
    PORT (
        clk : IN STD_LOGIC; -- Clock signal
        reset : IN STD_LOGIC; -- Reset signal
        load : IN STD_LOGIC; -- Load signal to update flags
        Carry_in : IN STD_LOGIC; -- Input Carry flag
        Zero_in : IN STD_LOGIC; -- Input Zero flag
        Negative_in : IN STD_LOGIC; -- Input Negative flag
        Carry_out : OUT STD_LOGIC; -- Output Carry flag
        Zero_out : OUT STD_LOGIC; -- Output Zero flag
        Negative_out : OUT STD_LOGIC; -- Output Negative flag
        flags_arr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) -- Output flags
    );
END Flags;

ARCHITECTURE Behavioral OF Flags IS
    SIGNAL Carry_reg, Zero_reg, Negative_reg : STD_LOGIC := '0';
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            -- Reset all flags to 0
            Carry_reg <= '0';
            Zero_reg <= '0';
            Negative_reg <= '0';
        ELSIF rising_edge(clk) THEN
            IF load = '1' THEN
                -- Load new flag values
                Carry_reg <= Carry_in;
                Zero_reg <= Zero_in;
                Negative_reg <= Negative_in;
            END IF;
        END IF;
    END PROCESS;

    -- Assign outputs
    Carry_out <= Carry_reg;
    Zero_out <= Zero_reg;
    Negative_out <= Negative_reg;
    flags_arr <= Carry_reg & Zero_reg & Negative_reg;

END Behavioral;