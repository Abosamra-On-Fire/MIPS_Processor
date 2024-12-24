LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY sign_extender IS
  PORT (
    input_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    output_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END sign_extender;

ARCHITECTURE sign_extender_arch OF sign_extender IS
BEGIN
  output_data <= x"0000" & input_data WHEN input_data(15) = '0' ELSE
  x"FFFF" & input_data;
END sign_extender_arch; -- sign_extender_arch