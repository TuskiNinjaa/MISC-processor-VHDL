LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_memory IS
END;

ARCHITECTURE hibrida OF tb_memory IS
    CONSTANT addr_width : NATURAL := 16;
    CONSTANT data_width : NATURAL := 8;
    SIGNAL clock, data_read, data_write : STD_LOGIC;
    SIGNAL data_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0);
    SIGNAL data_in : STD_LOGIC_VECTOR((data_width * 2) - 1 DOWNTO 0);
    SIGNAL data_out : STD_LOGIC_VECTOR((data_width * 4) - 1 DOWNTO 0);
BEGIN
    mem : ENTITY work.memory(behavioral)
        GENERIC MAP(addr_width => addr_width, data_width => data_width)
        PORT MAP(clock => clock, data_read => data_read, data_write => data_write, data_addr => data_addr, data_in => data_in, data_out => data_out);

    estimulo_checagem : PROCESS IS
        TYPE colunas_tabela_verdade IS RECORD
            clock, data_read, data_write : STD_LOGIC;
            data_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0);
            data_in : STD_LOGIC_VECTOR((data_width * 2) - 1 DOWNTO 0);
            data_out : STD_LOGIC_VECTOR((data_width * 4) - 1 DOWNTO 0);
        END RECORD;

        TYPE vetor_tabela_verdade IS ARRAY (0 TO 19) OF colunas_tabela_verdade;

        -- Implement more test cases
        CONSTANT tabela_verdade : vetor_tabela_verdade := (
        ('0', '0', '1', x"0010", x"1234", x"00000000"),
            ('1', '0', '1', x"0010", x"1234", x"00000000"),
            ('0', '1', '0', x"0010", x"0000", x"00001234"),
            ('1', '1', '0', x"0010", x"0000", x"00001234"),
            ('0', '1', '0', x"000F", x"0000", x"00123400"),
            ('1', '1', '0', x"000F", x"0000", x"00123400"),
            ('0', '1', '0', x"000E", x"0000", x"12340000"),
            ('1', '1', '0', x"000E", x"0000", x"12340000"),
            ('0', '0', '1', x"000E", x"5566", x"00000000"),
            ('1', '0', '1', x"000E", x"5566", x"00000000"),
            ('0', '1', '0', x"000E", x"0000", x"12345566"),
            ('1', '1', '0', x"000E", x"0000", x"12345566"),
            ('0', '0', '1', x"FFFE", x"5824", x"00000000"),
            ('1', '0', '1', x"FFFE", x"5824", x"00000000"),
            ('0', '1', '0', x"FFFC", x"0000", x"58240000"),
            ('1', '1', '0', x"FFFC", x"0000", x"58240000"),
            ('0', '0', '1', x"0000", x"7895", x"00000000"),
            ('1', '0', '1', x"0000", x"7895", x"00000000"),
            ('0', '1', '0', x"0000", x"0000", x"00007895"),
            ('1', '1', '0', x"0000", x"0000", x"00007895")
        );

    BEGIN
        FOR i IN tabela_verdade'RANGE LOOP
            clock <= tabela_verdade(i).clock;
            data_read <= tabela_verdade(i).data_read;
            data_write <= tabela_verdade(i).data_write;
            data_addr <= tabela_verdade(i).data_addr;
            data_in <= tabela_verdade(i).data_in;

            WAIT FOR 1 ns;

            ASSERT data_out = tabela_verdade(i).data_out REPORT "ERROR: Wrong data_out value at teste case: " & INTEGER'image(i);

        END LOOP;

        REPORT "The end of tests";

        WAIT;
    END PROCESS estimulo_checagem;
END;