LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_cpu IS
END;

ARCHITECTURE hibrida OF tb_cpu IS
    CONSTANT addr_width : NATURAL := 16;
    CONSTANT data_width : NATURAL := 8;

    SIGNAL clock : STD_LOGIC := '0';
    SIGNAL halt : STD_LOGIC;
    SIGNAL instruction_in : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL instruction_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0);
    SIGNAL dmem_data_read : STD_LOGIC;
    SIGNAL dmem_data_write : STD_LOGIC;
    SIGNAL dmem_data_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0);
    SIGNAL dmem_data_in : STD_LOGIC_VECTOR((data_width * 2) - 1 DOWNTO 0);
    SIGNAL dmem_data_out : STD_LOGIC_VECTOR((data_width * 4) - 1 DOWNTO 0);
    SIGNAL codec_interrupt : STD_LOGIC;
    SIGNAL codec_read : STD_LOGIC;
    SIGNAL codec_write : STD_LOGIC;
    SIGNAL codec_valid : STD_LOGIC;
    SIGNAL codec_data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL codec_data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    estimulo_checagem : PROCESS IS
        TYPE colunas_tabela_verdade IS RECORD
            halt : STD_LOGIC;
            instruction_in : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            instruction_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0); -- assert
            dmem_data_read : STD_LOGIC; -- assert
            dmem_data_write : STD_LOGIC; -- assert
            dmem_data_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0); -- assert
            dmem_data_in : STD_LOGIC_VECTOR((data_width * 2) - 1 DOWNTO 0); -- assert
            dmem_data_out : STD_LOGIC_VECTOR((data_width * 4) - 1 DOWNTO 0);
            codec_interrupt : STD_LOGIC; -- assert
            codec_read : STD_LOGIC; -- assert
            codec_write : STD_LOGIC; -- assert
            codec_valid : STD_LOGIC;
            codec_data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
            codec_data_in : STD_LOGIC_VECTOR(7 DOWNTO 0); -- assert
        END RECORD;

        TYPE vetor_tabela_verdade IS ARRAY (0 TO 4) OF colunas_tabela_verdade;

        -- Implement more test cases
        CONSTANT tabela_verdade : vetor_tabela_verdade := (
        (
            '0', x"10", x"0000", -- IN
            '0', '1', x"0000", x"0000", x"00000000", -- Write DMEM
            '1', '1', '0', '1', x"00", x"00" -- Read CODEC
            )
            , (
            '0', x"00", x"0000", -- IN
            '0', '1', x"0000", x"0000", x"00000000",
            '1', '1', '0', '1', x"00", x"00"
            )
            , (
            '0', x"10", x"0000", -- IN
            '0', '1', x"0000", x"0000", x"00000000", -- Write DMEM
            '1', '1', '0', '1', x"00", x"00" -- Read CODEC
            )
            , (
            '0', x"10", x"0000", -- IN
            '0', '1', x"0000", x"0000", x"00000000",
            '1', '1', '0', '1', x"00", x"00"
            )
            , (
            '0', x"D0", x"0000",
            '1', '0', x"0000", x"0000", x"00000000", -- Read DMEM
            '1', '0', '1', '1', x"00", x"00" -- Write CODEC
            )
            -- , (
            -- '0', x"C0", x"0003", -- OUT
            -- '1', '0', x"0001", x"00F3", x"000000F3", -- Read DMEM
            -- '1', '0', '1', '1', x"00", x"F3" -- Write CODEC
            -- )
            -- , (
            -- '0', x"D0", x"0004", -- OUT
            -- '1', '0', x"0001", x"00F3", x"000000F3", -- Read DMEM
            -- '1', '0', '1', '1', x"00", x"F3" -- Write CODEC
            -- )
            -- , (
            -- '0', x"20", x"0005", -- OUT
            -- '1', '0', x"0001", x"00F3", x"000000F3", -- Read DMEM
            -- '1', '0', '1', '1', x"00", x"F3" -- Write CODEC
            -- )
            -- , (
            -- '0', x"20", x"0006", -- OUT
            -- '1', '0', x"0000", x"00F3", x"0000000C", -- Read DMEM
            -- '1', '0', '1', '1', x"00", x"0C" -- Write CODEC
            -- )
        );

    BEGIN
        halt <= '0';

        clock <= NOT clock;
        WAIT FOR 1 ns;
        clock <= NOT clock;
        WAIT FOR 1 ns;

        FOR i IN 0 TO tabela_verdade'length - 1 LOOP
            halt <= tabela_verdade(i).halt;

            clock <= NOT clock;
            WAIT FOR 1 ns;

            instruction_in <= tabela_verdade(i).instruction_in;

            clock <= NOT clock;
            WAIT FOR 1 ns;

            clock <= NOT clock;
            WAIT FOR 1 ns;
            clock <= NOT clock;
            WAIT FOR 1 ns;
            clock <= NOT clock;
            WAIT FOR 1 ns;
            clock <= NOT clock;
            WAIT FOR 1 ns;

            -- ASSERT instruction_addr = tabela_verdade(i).instruction_addr REPORT "ERROR: instruction_addr. Line: " & INTEGER'image(i);
            -- ASSERT dmem_data_read = tabela_verdade(i).dmem_data_read REPORT "ERROR: dmem_data_read. Line: " & INTEGER'image(i);
            -- ASSERT dmem_data_write = tabela_verdade(i).dmem_data_write REPORT "ERROR: dmem_data_write. Line: " & INTEGER'image(i);
            -- ASSERT dmem_data_addr = tabela_verdade(i).dmem_data_addr REPORT "ERROR: dmem_data_addr. Line: " & INTEGER'image(i);
            -- ASSERT codec_interrupt = tabela_verdade(i).codec_interrupt REPORT "ERROR: codec_interrupt. Line: " & INTEGER'image(i);
            -- ASSERT codec_read = tabela_verdade(i).codec_read REPORT "ERROR: codec_read. Line: " & INTEGER'image(i);
            -- ASSERT codec_write = tabela_verdade(i).codec_write REPORT "ERROR: codec_write. Line: " & INTEGER'image(i);
            -- ASSERT dmem_data_in = tabela_verdade(i).dmem_data_in REPORT "ERROR: dmem_data_in. Line: " & INTEGER'image(i);
            -- ASSERT codec_data_in = tabela_verdade(i).codec_data_in REPORT "ERROR: codec_data_in. Line: " & INTEGER'image(i);

        END LOOP;

        clock <= NOT clock;
        WAIT FOR 1 ns;
        clock <= NOT clock;
        WAIT FOR 1 ns;

        REPORT "The end of tests";

        WAIT;
    END PROCESS estimulo_checagem;

    cpu : ENTITY work.cpu(behavioral)
        GENERIC MAP(
            addr_width => addr_width,
            data_width => data_width
        )
        PORT MAP
        (
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
            codec_read => codec_read,
            codec_write => codec_write,
            codec_valid => codec_valid,
            codec_data_out => codec_data_out,
            codec_data_in => codec_data_in
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
            read_signal => codec_read,
            write_signal => codec_write,
            valid => codec_valid,
            codec_data_in => codec_data_in,
            codec_data_out => codec_data_out
        );

END;