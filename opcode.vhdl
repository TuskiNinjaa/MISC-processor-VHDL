library ieee;
use ieee.std_logic_1164.all;

package opcode is
    constant data_width : natural := 8;
    constant type_hlt : std_logic_vector(data_width-1 downto 0) := x"00";
    constant type_in : std_logic_vector(data_width-1 downto 0) := x"10";
    constant type_out : std_logic_vector(data_width-1 downto 0) := x"20";
end package opcode;