library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity codec is
    port (
        interrupt: in std_logic; -- Interrupt signal
        read_signal: in std_logic; -- Read signal
        write_signal: in std_logic; -- Write signal
        valid: out std_logic; -- Valid signal
        -- Byte written to codec
        codec_data_in : in std_logic_vector(7 downto 0);
        -- Byte read from codec
        codec_data_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behavioral of codec is
begin

    -- process (interrupt)
    -- begin
    --     if interrupt = '1' then
    --         if read_signal = '1' and write_signal = '0' then -- opcode IN
                
    --         elsif read_signal = '0' and write_signal = '1' then -- opcode OUT

    --     end if;

    --     valid <= '1';
    -- end process;

end architecture;