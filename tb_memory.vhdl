library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_memory is
end;

architecture hibrida of tb_memory is
    constant addr_width : natural := 16;
    constant data_width : natural := 8;
    signal clock, data_read, data_write : std_logic;
    signal data_addr : std_logic_vector(addr_width-1 downto 0);
    signal data_in : std_logic_vector((data_width*2)-1 downto 0);
    signal data_out : std_logic_vector((data_width*4)-1 downto 0);
begin
    mem :   entity work.memory(behavioral)
            generic map (addr_width => addr_width, data_width => data_width)
            port map (clock => clock, data_read => data_read, data_write => data_write, data_addr => data_addr, data_in => data_in, data_out => data_out);
        
    estimulo_checagem : process is
        type colunas_tabela_verdade is record
            clock, data_read, data_write : std_logic;
            data_addr : std_logic_vector(addr_width-1 downto 0);
            data_in : std_logic_vector((data_width*2)-1 downto 0);
            data_out : std_logic_vector((data_width*4)-1 downto 0);
        end record;

        type vetor_tabela_verdade is array (0 to 19) of colunas_tabela_verdade;

        -- Implement more test cases
        constant tabela_verdade : vetor_tabela_verdade := (
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

    begin
        for i in tabela_verdade'range loop
            clock <=  tabela_verdade(i).clock;
            data_read <= tabela_verdade(i).data_read;
            data_write <= tabela_verdade(i).data_write;
            data_addr <= tabela_verdade(i).data_addr;
            data_in <= tabela_verdade(i).data_in;

            wait for 1 ns;

            assert data_out = tabela_verdade(i).data_out report "ERROR: Wrong data_out value at teste case: " & integer'image(i);
            
        end loop; 

        report "The end of tests" ;

        wait;
    end process estimulo_checagem;
end;