LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY out_port IS
    PORT (
        data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_port_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_port_signal : IN STD_LOGIC

    );
END out_port;

ARCHITECTURE rtl OF out_port IS
BEGIN
    PROCESS (data, out_port_signal)
    BEGIN
        IF out_port_signal = '1' THEN
            out_port_data <= data;
        ELSE
            out_port_data <= (OTHERS => '0');
        END IF;
    END PROCESS;
END rtl;