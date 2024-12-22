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
        VARIABLE var : STD_LOGIC_VECTOR(15 DOWNTO 0); -- Stack pointer register
    BEGIN
        IF reset = '1' THEN
            -- Reset the stack pointer to a default value (e.g., 0xFF for an empty stack)
            sp_reg <= X"0FFF"; -- Example starting value for the pointer
            stack_pointer <= sp_reg; -- Output the initial stack pointer value
        ELSIF rising_edge(clk) THEN
            var := sp_reg;
            IF stack_write = '1' THEN

                IF stack_add = '1' THEN
                    -- Push operation: Increment the stack pointer
                    stack_pointer <= var;
                    var := STD_LOGIC_VECTOR(unsigned(var) - 1);

                ELSE
                    -- Pop operation: Decrement the stack pointer

                    var := STD_LOGIC_VECTOR(unsigned(var) + 1);
                    stack_pointer <= var;
                END IF;
                sp_reg <= var;
                -- Push operation: Increment the stack pointer
            ELSE
                stack_pointer <= var;
                sp_reg <= var;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;