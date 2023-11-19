LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_codec IS
END;

ARCHITECTURE hibrida OF tb_codec IS
    SIGNAL interrupt, read_signal, write_signal, valid : STD_LOGIC;
    SIGNAL codec_data_in, codec_data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    cod : ENTITY work.codec(behavioral)
        PORT MAP
            (interrupt => interrupt, read_signal => read_signal, write_signal => write_signal, valid => valid, codec_data_in => codec_data_in, codec_data_out => codec_data_out);

    estimulo_checagem : PROCESS IS
        TYPE colunas_tabela_verdade IS RECORD
            interrupt, read_signal, write_signal, valid : STD_LOGIC;
            codec_data_in, codec_data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
        END RECORD;

        TYPE vetor_tabela_verdade IS ARRAY (0 TO 31) OF colunas_tabela_verdade;

        -- Implement more test cases
        CONSTANT tabela_verdade : vetor_tabela_verdade := (
        ('0', '0', '1', '0', x"AB", x"00"), -- WRITE wait
            ('1', '0', '1', '1', x"AB", x"00"), -- WRITE start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '1', x"00", x"0C"), -- READ start
            ('0', '0', '1', '0', x"FF", x"00"), -- WRITE wait
            ('1', '0', '1', '1', x"FF", x"00"), -- WRITE start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '1', x"00", x"05"), -- READ start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '0', x"00", x"00"), -- READ start
            ('0', '0', '1', '0', x"00", x"00"), -- WRITE wait
            ('1', '0', '1', '1', x"00", x"00"), -- WRITE start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '1', x"00", x"1F"), -- READ start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '1', x"00", x"29"), -- READ start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '1', x"00", x"CD"), -- READ start
            ('0', '0', '1', '0', x"27", x"00"), -- WRITE wait
            ('1', '0', '1', '1', x"27", x"00"), -- WRITE start
            ('0', '0', '1', '0', x"11", x"00"), -- WRITE wait
            ('1', '0', '1', '1', x"11", x"00"), -- WRITE start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '1', x"00", x"7F"), -- READ start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '1', x"00", x"80"), -- READ start
            ('0', '0', '1', '0', x"7F", x"00"), -- WRITE wait
            ('1', '0', '1', '1', x"7F", x"00"), -- WRITE start
            ('0', '0', '1', '0', x"80", x"00"), -- WRITE wait
            ('1', '0', '1', '1', x"80", x"00"), -- WRITE start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '0', x"00", x"00") -- READ start
        );

    BEGIN

        FOR i IN tabela_verdade'RANGE LOOP
            interrupt <= tabela_verdade(i).interrupt;
            read_signal <= tabela_verdade(i).read_signal;
            write_signal <= tabela_verdade(i).write_signal;
            codec_data_in <= tabela_verdade(i).codec_data_in;

            WAIT FOR 1 ns;

            ASSERT valid = tabela_verdade(i).valid REPORT "ERROR: Wrong 'valid' value at teste case: " & INTEGER'image(i);
            ASSERT codec_data_out = tabela_verdade(i).codec_data_out REPORT "ERROR: Wrong 'codec_data_out' value at teste case: " & INTEGER'image(i);

        END LOOP;

        REPORT "The end of tests";

        WAIT;
    END PROCESS estimulo_checagem;
END;