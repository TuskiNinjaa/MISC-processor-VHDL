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
    file file_input : text open read_mode is "input.txt";
    file file_output : text open write_mode is "output.txt";
begin

    process (interrupt)
        variable text_line : line;
        variable text_number : integer;
    begin
        valid <= '0';
        codec_data_out <= std_logic_vector(to_unsigned(0, 8));
        text_line := null;

        if interrupt = '1' then
            if read_signal = '1' and write_signal = '0' and not endfile(file_input) then -- opcode IN
                readline(file_input, text_line);

                if text_line'length > 0 then
                    read(text_line, text_number);
                    codec_data_out <= std_logic_vector(to_signed(text_number, 8));
                    valid <= '1';
                end if;
                
            elsif read_signal = '0' and write_signal = '1' then -- opcode OUT
                write(text_line, to_integer(signed(codec_data_in)));
                writeline(file_output, text_line);
                valid <= '1';
                
            end if;

        end if;
    end process;

end architecture;