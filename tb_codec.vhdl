library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_codec is
end;

architecture hibrida of tb_codec is
    signal interrupt, read_signal, write_signal, valid : std_logic;
    signal codec_data_in, codec_data_out : std_logic_vector(7 downto 0);

begin
    cod : entity work.codec(behavioral)
        port map (interrupt => interrupt, read_signal => read_signal, write_signal => write_signal, valid => valid, codec_data_in => codec_data_in, codec_data_out => codec_data_out);
        
    estimulo_checagem : process is
        type colunas_tabela_verdade is record
            interrupt, read_signal, write_signal, valid : std_logic;
            codec_data_in, codec_data_out : std_logic_vector(7 downto 0);
        end record;

        type vetor_tabela_verdade is array (0 to 31) of colunas_tabela_verdade;

        -- Implement more test cases
        constant tabela_verdade : vetor_tabela_verdade := (
            ('0', '0', '1', '0', x"AB", x"00"), -- WRITE wait
            ('1', '0', '1', '1', x"AB", x"00"), -- WRITE start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '1', x"00", x"0C"), -- READ start
            ('0', '0', '1', '0', x"FF", x"00"), -- WRITE wait
            ('1', '0', '1', '1', x"FF", x"00"), -- WRITE start
            ('0', '1', '0', '0', x"00", x"00"), -- READ wait
            ('1', '1', '0', '1', x"00", x"0B"), -- READ start
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

    begin

        for i in tabela_verdade'range loop
            interrupt <= tabela_verdade(i).interrupt;
            read_signal <= tabela_verdade(i).read_signal;
            write_signal <= tabela_verdade(i).write_signal;
            codec_data_in <= tabela_verdade(i).codec_data_in;

            wait for 1 ns;

            assert valid = tabela_verdade(i).valid report "ERROR: Wrong 'valid' value at teste case: " & integer'image(i);
            assert codec_data_out = tabela_verdade(i).codec_data_out report "ERROR: Wrong 'codec_data_out' value at teste case: " & integer'image(i);
            
        end loop; 

        report "The end of tests" ;

        wait;
    end process estimulo_checagem;
end;