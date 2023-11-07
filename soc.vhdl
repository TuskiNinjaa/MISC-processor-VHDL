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
    signal imem_data_in : std_logic_vector((data_width*2)-1 downto 0) := (others => '0');
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

    process (clock)-- process to fill IMEM
        variable text_line : line;
        variable c : character;
    begin
        if not endfile(firmware) and clock'event and clock='1' then
            readline(firmware, text_line);
            for i in 0 to data_width-1 loop
                read(text_line, c);
                if c = '0' then
                    imem_data_in(data_width-1-i) <= '0';
                else
                    imem_data_in(data_width-1-i) <= '1';
                end if;
            end loop;
            
            imem_data_read <= '0';
            imem_data_write <= '1';
            imem_data_addr <= std_logic_vector(to_unsigned(final_instruction_pointer, addr_width));
            final_instruction_pointer <= final_instruction_pointer + 1;
        end if;
    end process;

end architecture;