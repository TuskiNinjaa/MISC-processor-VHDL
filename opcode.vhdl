library ieee;
use ieee.std_logic_1164.all;

package opcode is
    constant data_width : natural := 8;
    constant type_hlt : std_logic_vector(data_width-1 downto 0) := x"00";
    constant type_in : std_logic_vector(data_width-1 downto 0) := x"10";
    constant type_out : std_logic_vector(data_width-1 downto 0) := x"20";

    constant type_slt : std_logic_vector(data_width-1 downto 0) := x"B0";
    constant type_shl : std_logic_vector(data_width-1 downto 0) := x"C0";
    constant type_shr : std_logic_vector(data_width-1 downto 0) := x"D0";
    constant type_jeq : std_logic_vector(data_width-1 downto 0) := x"E0";
    constant type_jmp : std_logic_vector(data_width-1 downto 0) := x"F0";
end package opcode;