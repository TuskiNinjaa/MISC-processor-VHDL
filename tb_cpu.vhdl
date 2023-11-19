LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.opcode.ALL;

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
    tester : PROCESS IS
        TYPE colunas_tabela_verdade IS RECORD
            halt : STD_LOGIC;
            instruction_in : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
            instruction_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0); -- assert
            dmem_data_read : STD_LOGIC; -- assert
            dmem_data_write : STD_LOGIC; -- assert
            dmem_data_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0); -- assert
            dmem_data_in : STD_LOGIC_VECTOR((data_width * 2) - 1 DOWNTO 0); -- assert
            codec_interrupt : STD_LOGIC; -- assert
            codec_read : STD_LOGIC; -- assert
            codec_write : STD_LOGIC; -- assert
            codec_data_in : STD_LOGIC_VECTOR(7 DOWNTO 0); -- assert
        END RECORD;

        TYPE vetor_tabela_verdade IS ARRAY (0 TO 29) OF colunas_tabela_verdade;

        -- Implement more test cases
        CONSTANT tabela_verdade : vetor_tabela_verdade := (
        (
            '0', b"00000000", x"0000", -- HLT
            '0', '0', x"0000", x"0000",
            '0', '0', '0', x"00"
            )
            , (
            '0', b"00010000", x"0001", -- IN
            '0', '1', x"0000", x"000C",
            '1', '1', '0', x"00"
            )
            , (
            '0', b"00100000", x"0002", -- OUT
            '1', '0', x"0000", x"000C",
            '1', '0', '1', x"0C"
            )
            , (
            '0', b"00110000", x"0003", -- PUSHIP
            '0', '1', x"0000", x"0003",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01001000", x"0004", -- PUSH -8
            '0', '1', x"0001", x"00F8",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01001001", x"0005", -- PUSH -7
            '0', '1', x"0002", x"00F9",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01001010", x"0006", -- PUSH -6
            '0', '1', x"0003", x"00FA",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01001011", x"0007", -- PUSH -5
            '0', '1', x"0004", x"00FB",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01001100", x"0008", -- PUSH -4
            '0', '1', x"0005", x"00FC",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01001101", x"0009", -- PUSH -3
            '0', '1', x"0006", x"00FD",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01001110", x"000A", -- PUSH -2
            '0', '1', x"0007", x"00FE",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01001111", x"000B", -- PUSH -1
            '0', '1', x"0008", x"00FF",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01000000", x"000C", -- PUSH 0
            '0', '1', x"0009", x"0000",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01000001", x"000D", -- PUSH 1
            '0', '1', x"000A", x"0001",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01000010", x"000E", -- PUSH 2
            '0', '1', x"000B", x"0002",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01000011", x"000F", -- PUSH 3
            '0', '1', x"000C", x"0003",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01000100", x"0010", -- PUSH 4
            '0', '1', x"000D", x"0004",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01000101", x"0011", -- PUSH 5
            '0', '1', x"000E", x"0005",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01000110", x"0012", -- PUSH 6
            '0', '1', x"000F", x"0006",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01000111", x"0013", -- PUSH 7
            '0', '1', x"0010", x"0007",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01010000", x"0014", -- DROP
            '1', '0', x"0010", x"0007",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"01100000", x"0015", -- DUP
            '0', '1', x"000F", x"0606",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"10000000", x"0016", -- ADD
            '0', '1', x"000F", x"000C",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"10010000", x"0017", -- SUB
            '0', '1', x"000E", x"0007",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"10100000", x"0018", -- NAND
            '0', '1', x"000D", x"00FB",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"10110000", x"0019", -- SLT
            '0', '1', x"000C", x"0001",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"11000000", x"001A", -- SHL
            '0', '1', x"000B", x"0004",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"11010000", x"001B", -- SHR
            '0', '1', x"000A", x"0002",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"11100000", x"001C", -- JEQ
            '1', '0', x"0007", x"0002",
            '0', '0', '1', x"0C"
            )
            , (
            '0', b"11110000", x"001D", -- JMP
            '1', '0', x"0005", x"0002",
            '0', '0', '1', x"0C"
            )
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

            IF is_equal(tabela_verdade(i).instruction_in, type_hlt) THEN
                clock <= NOT clock;
                WAIT FOR 1 ns;
                clock <= NOT clock;
                WAIT FOR 1 ns;
            END IF;

            ASSERT instruction_addr = tabela_verdade(i).instruction_addr REPORT "ERROR: instruction_addr. Line: " & INTEGER'image(i);
            ASSERT dmem_data_read = tabela_verdade(i).dmem_data_read REPORT "ERROR: dmem_data_read. Line: " & INTEGER'image(i);
            ASSERT dmem_data_write = tabela_verdade(i).dmem_data_write REPORT "ERROR: dmem_data_write. Line: " & INTEGER'image(i);
            ASSERT dmem_data_addr = tabela_verdade(i).dmem_data_addr REPORT "ERROR: dmem_data_addr. Line: " & INTEGER'image(i);
            ASSERT dmem_data_in = tabela_verdade(i).dmem_data_in REPORT "ERROR: dmem_data_in. Line: " & INTEGER'image(i);
            ASSERT codec_interrupt = tabela_verdade(i).codec_interrupt REPORT "ERROR: codec_interrupt. Line: " & INTEGER'image(i);
            ASSERT codec_read = tabela_verdade(i).codec_read REPORT "ERROR: codec_read. Line: " & INTEGER'image(i);
            ASSERT codec_write = tabela_verdade(i).codec_write REPORT "ERROR: codec_write. Line: " & INTEGER'image(i);
            ASSERT codec_data_in = tabela_verdade(i).codec_data_in REPORT "ERROR: codec_data_in. Line: " & INTEGER'image(i);

        END LOOP;

        REPORT "The end of tests";

        WAIT;
    END PROCESS tester;

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