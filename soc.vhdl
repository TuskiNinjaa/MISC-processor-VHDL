LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.ALL;

ENTITY soc IS
    GENERIC (
        firmware_filename : STRING := "firmware.bin"
    );
    PORT (
        clock : IN STD_LOGIC; -- Clock signal
        started : IN STD_LOGIC -- Start execution when '1'
    );
END ENTITY;

ARCHITECTURE structural OF soc IS
    -- constants
    CONSTANT addr_width : NATURAL := 16;
    CONSTANT data_width : NATURAL := 8;

    -- firmware
    FILE firmware : text OPEN read_mode IS firmware_filename;

    -- IMEM signals
    SIGNAL imem_data_read, imem_data_write : STD_LOGIC := '0';
    SIGNAL imem_data_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL imem_data_in : STD_LOGIC_VECTOR((data_width * 2) - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL imem_data_out : STD_LOGIC_VECTOR((data_width * 4) - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL final_instruction_pointer : NATURAL := 0;

    -- DMEM signals
    SIGNAL dmem_data_read, dmem_data_write : STD_LOGIC := '0';
    SIGNAL dmem_data_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dmem_data_in : STD_LOGIC_VECTOR((data_width * 2) - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL dmem_data_out : STD_LOGIC_VECTOR((data_width * 4) - 1 DOWNTO 0) := (OTHERS => '0');

    -- CODEC signals
    SIGNAL codec_interrupt : STD_LOGIC := '0';
    SIGNAL codec_read_signal : STD_LOGIC := '0';
    SIGNAL codec_write_signal : STD_LOGIC := '0';
    SIGNAL codec_valid : STD_LOGIC := '0';
    SIGNAL codec_data_in : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL codec_data_out : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');

    -- CPU signals
    SIGNAL instruction_in : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL instruction_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL halt : STD_LOGIC := '1';

BEGIN

    PROCESS (clock, started, imem_data_out, instruction_addr) -- process to fill IMEM
        VARIABLE text_line : line;
        VARIABLE c : CHARACTER;
    BEGIN
        IF NOT endfile(firmware) AND clock'event AND clock = '1' THEN
            readline(firmware, text_line);
            FOR i IN 0 TO data_width - 1 LOOP
                read(text_line, c);
                IF c = '0' THEN
                    imem_data_in(data_width - 1 - i) <= '0';
                ELSE
                    imem_data_in(data_width - 1 - i) <= '1';
                END IF;
            END LOOP;

            imem_data_read <= '0';
            imem_data_write <= '1';
            imem_data_addr <= STD_LOGIC_VECTOR(to_unsigned(final_instruction_pointer, addr_width));
            final_instruction_pointer <= final_instruction_pointer + 1;
        END IF;

        IF started = '1' THEN
            imem_data_read <= '1';
            imem_data_write <= '0';
            instruction_in <= imem_data_out(data_width - 1 DOWNTO 0);
            imem_data_addr <= instruction_addr;
            halt <= '0';
        ELSE
            halt <= '1';
        END IF;
    END PROCESS;

    imem : ENTITY work.memory(behavioral)
        GENERIC MAP(
            addr_width => addr_width,
            data_width => data_width
        )
        PORT MAP
        (
            clock => clock,
            data_read => imem_data_read,
            data_write => imem_data_write,
            data_addr => imem_data_addr,
            data_in => imem_data_in,
            data_out => imem_data_out
        );

    dmem : ENTITY work.memory(behavioral)
        GENERIC MAP(
            addr_width => addr_width,
            data_width => data_width
        )
        PORT MAP(
            clock => clock,
            data_read => dmem_data_read,
            data_write => dmem_data_write,
            data_addr => dmem_data_addr,
            data_in => dmem_data_in,
            data_out => dmem_data_out
        );

    codec : ENTITY work.codec(behavioral)
        PORT MAP(
            interrupt => codec_interrupt,
            read_signal => codec_read_signal,
            write_signal => codec_write_signal,
            valid => codec_valid,
            codec_data_in => codec_data_in,
            codec_data_out => codec_data_out
        );

    cpu : ENTITY work.cpu(behavioral)
        GENERIC MAP(
            addr_width => addr_width,
            data_width => data_width
        )
        PORT MAP(
            clock => clock,
            halt => halt,
            instruction_in => instruction_in,
            instruction_addr => instruction_addr,
            mem_data_read => dmem_data_read,
            mem_data_write => dmem_data_write,
            mem_data_addr => dmem_data_addr,
            mem_data_in => dmem_data_in,
            mem_data_out => dmem_data_out,
            codec_interrupt => codec_interrupt,
            codec_read => codec_read_signal,
            codec_write => codec_write_signal,
            codec_valid => codec_valid,
            codec_data_out => codec_data_out,
            codec_data_in => codec_data_in
        );

END ARCHITECTURE;