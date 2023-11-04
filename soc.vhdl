library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity soc is
    generic (
        firmware_filename: string := "firmware.bin"
    );
    port (
        clock: in std_logic; -- Clock signal
        started: in std_logic -- Start execution when '1'
    );
end entity;

architecture structural of soc is
    -- accessing firmware
    file firmware : text open read_mode is firmware_filename;

    -- constants
    constant addr_width : natural := 16;
    constant data_width : natural := 8;

    -- signals
    signal imem_data_read, imem_data_write : std_logic := '0';
    signal imem_data_addr : std_logic_vector(addr_width-1 downto 0) := (others => '0');
    signal imem_data_in : std_logic_vector((data_width*2)-1 downto 0);
    signal imem_data_out : std_logic_vector((data_width*4)-1 downto 0);
    signal instruction_pointer, final_instruction_pointer : natural := 0;

begin
    imem : entity work.memory(behavioral)
        generic map (
            addr_width => addr_width,
            data_width => data_width
        )
        port map (
            clock => clock,
            data_read => imem_data_read,
            data_write => imem_data_write,
            data_addr => imem_data_addr,
            data_in => imem_data_in,
            data_out => imem_data_out
        );

    process (clock)
        -- procedure to fill IMEM
        procedure fill_instruction_memory is
            constant mnemonic_size : integer := 7;
            variable text_line : line;
            variable text_char : character;
            variable text_word : string(1 to mnemonic_size) := (others => ' ');
            variable text_number : integer;
            variable i : integer range 1 to mnemonic_size := 1;

        begin
            if not endfile(firmware) and clock='1' then
                readline(firmware, text_line);
                while text_line'length > 0 and text_char /= ' ' loop
                    read(text_line, text_char);
                    text_word(i) := text_char;
                    i := i + 1;
                end loop;
                
                case text_word is
                    when "HLT    " =>
                        imem_data_in <= x"AAAA";
                    when "IN     " =>
                        imem_data_in <= x"0100";
                    when "OUT    " =>
                        imem_data_in <= x"0200";
                    when "PUSHIP " =>
                        imem_data_in <= x"0300";
                    when "PUSH   " =>
                        read(text_line, text_number);
                        imem_data_in <= x"04" & std_logic_vector(to_signed(text_number, data_width));
                    when "DROP   " =>
                        imem_data_in <= x"0500";
                    when "DUP    " =>
                        imem_data_in <= x"0600";
                    when "ADD    " =>
                        imem_data_in <= x"0800";
                    when "SUB    " =>
                        imem_data_in <= x"0900";
                    when "NAND   " =>
                        imem_data_in <= x"0A00";
                    when "SLT    " =>
                        imem_data_in <= x"0B00";
                    when "SHL    " =>
                        imem_data_in <= x"0C00";
                    when "SHR    " =>
                        imem_data_in <= x"0D00";
                    when "JEQ    " =>
                        imem_data_in <= x"0E00";
                    when "JMP    " =>
                        imem_data_in <= x"0F00";
                    when others =>
                        imem_data_in <= x"0700";
                end case;
                
                imem_data_read <= '0';
                imem_data_write <= '1';
                imem_data_addr <= std_logic_vector(to_unsigned(final_instruction_pointer, addr_width));
                final_instruction_pointer <= final_instruction_pointer + 2;
            end if;
        end procedure;

    begin
        fill_instruction_memory;
    end process;

end architecture;