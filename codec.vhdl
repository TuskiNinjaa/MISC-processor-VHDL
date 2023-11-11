LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

ENTITY codec IS
    PORT (
        interrupt : IN STD_LOGIC; -- Interrupt signal
        read_signal : IN STD_LOGIC; -- Read signal
        write_signal : IN STD_LOGIC; -- Write signal
        valid : OUT STD_LOGIC; -- Valid signal
        -- Byte written to codec
        codec_data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- Byte read from codec
        codec_data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral OF codec IS
    FILE file_input : text OPEN read_mode IS "bin/input.bin";
    FILE file_output : text OPEN write_mode IS "bin/output.bin";
BEGIN

    PROCESS (interrupt)
        VARIABLE text_line : line;
        VARIABLE text_number : INTEGER;
    BEGIN
        valid <= '0';
        codec_data_out <= STD_LOGIC_VECTOR(to_unsigned(0, 8));
        text_line := NULL;

        IF interrupt = '1' THEN
            IF read_signal = '1' AND write_signal = '0' AND NOT endfile(file_input) THEN
                -- opcode IN
                readline(file_input, text_line);
                IF text_line'length > 0 THEN
                    read(text_line, text_number);
                    codec_data_out <= STD_LOGIC_VECTOR(to_signed(text_number, 8));
                    valid <= '1';
                END IF;

            ELSIF read_signal = '0' AND write_signal = '1' THEN
                -- opcode OUT
                write(text_line, to_integer(signed(codec_data_in)));
                writeline(file_output, text_line);
                valid <= '1';

            END IF;

        END IF;
    END PROCESS;

END ARCHITECTURE;