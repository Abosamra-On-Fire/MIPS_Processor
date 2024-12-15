library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sign_extender is
  port (
    input_data : in  STD_LOGIC_VECTOR(15 downto 0);
    output_data: out STD_LOGIC_VECTOR(31 downto 0)
  );
end sign_extender;

architecture sign_extender_arch of sign_extender is
begin
    output_data <= x"0000" & input_data when input_data(15) = '0' else x"FFFF" & input_data;
end sign_extender_arch ; -- sign_extender_arch