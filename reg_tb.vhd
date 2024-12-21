LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tb_reg IS
END tb_reg;

ARCHITECTURE behavior OF tb_reg IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT reg
        GENERIC (
            SIZE : integer := 128
        );
        PORT (
            clk : in STD_LOGIC;
            Data_in : in STD_LOGIC_VECTOR (SIZE-1 downto 0);
            en : in STD_LOGIC;
            rst : in STD_LOGIC;
            Data_out : out STD_LOGIC_VECTOR (SIZE-1 downto 0)
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk_tb : STD_LOGIC := '0';
    SIGNAL rst_tb : STD_LOGIC := '0';
    SIGNAL en_tb : STD_LOGIC := '0';
    SIGNAL Data_in_tb : STD_LOGIC_VECTOR (127 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Data_out_tb : STD_LOGIC_VECTOR (127 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : time := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: reg
        PORT MAP (
            clk => clk_tb,
            Data_in => Data_in_tb,
            en => en_tb,
            rst => rst_tb,
            Data_out => Data_out_tb
        );

    -- Clock generation process
    clk_process : PROCESS
    BEGIN
        clk_tb <= '0';
        WAIT FOR clk_period / 2;
        clk_tb <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Test case 1: Reset the register
        rst_tb <= '1';  -- Apply reset
        WAIT FOR clk_period;
        rst_tb <= '0';  -- Deassert reset
        WAIT FOR clk_period;

        -- Test case 2: Write data when enable is '1'
        en_tb <= '1';  -- Enable the register
        Data_in_tb <= (OTHERS => '1');  -- Set input data to all '1's
        WAIT FOR clk_period;
        -- assert (Data_out_tb = (OTHERS => '1')) REPORT "Error: Data not written correctly when en is '1'" SEVERITY error;
        
        -- Test case 3: Disable register and verify that data is held
        en_tb <= '0';  -- Disable the register
        Data_in_tb <= (OTHERS => '0');  -- Change input data to all '0's (should not be written)
        -- WAIT FOR clk_period;
        -- assert (Data_out_tb = (OTHERS => '1')) REPORT "Error: Data changed when en is '0'" SEVERITY error;
        
        -- Test case 4: Apply a new data with enable '1'
        en_tb <= '1';  -- Enable the register
        Data_in_tb <= (OTHERS => '0');  -- Set input data to all '0's
        WAIT FOR clk_period;
        -- assert (Data_out_tb = (OTHERS => '0')) REPORT "Error: Data not written correctly when en is '1'" SEVERITY error;

        -- End of test
        WAIT;
    END PROCESS;
END behavior;
