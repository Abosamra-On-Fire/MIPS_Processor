LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Stack IS
    PORT (
        clk : IN STD_LOGIC; -- Clock signal
        reset : IN STD_LOGIC; -- Reset signal
        stack_write : IN STD_LOGIC; -- Write enable to store updated SP
        stack_add : IN STD_LOGIC; -- Increment (push) or Decrement (pop)
        stack_pointer : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- Output the current pointer value
    );
END Stack;

ARCHITECTURE Behavioral OF Stack IS
    SIGNAL sp_reg : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0FFF"; -- Stack pointer register
BEGIN

    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            -- Reset the stack pointer to a default value (e.g., 0xFF for an empty stack)
            sp_reg <= X"0FFF"; -- Example starting value for the pointer
            stack_pointer <= sp_reg; -- Output the initial stack pointer value
        ELSIF rising_edge(clk) THEN
            IF stack_write = '1' THEN

                IF stack_add = '1' THEN
                    -- Push operation: Increment the stack pointer
                    stack_pointer <= sp_reg;
                    sp_reg <= STD_LOGIC_VECTOR(unsigned(sp_reg) - 1);

                ELSE
                    -- Pop operation: Decrement the stack pointer

                    stack_pointer <= STD_LOGIC_VECTOR(unsigned(sp_reg) + 1);
                    sp_reg <= STD_LOGIC_VECTOR(unsigned(sp_reg) + 1);
                END IF;
                -- Push operation: Increment the stack pointer
            ELSE
                stack_pointer <= sp_reg;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;