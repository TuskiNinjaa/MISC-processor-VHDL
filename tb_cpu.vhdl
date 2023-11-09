library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cpu is
end;

architecture hibrida of tb_cpu is
    constant addr_width : natural := 16;
    constant data_width : natural := 8;

    signal clock : std_logic := '0';
    signal halt : std_logic;
    signal instruction_in : std_logic_vector(data_width-1 downto 0);
    signal instruction_addr: std_logic_vector(addr_width-1 downto 0);
    signal dmem_data_read : std_logic;
    signal dmem_data_write: std_logic;
    signal dmem_data_addr : std_logic_vector(addr_width-1 downto 0);
    signal dmem_data_in : std_logic_vector((data_width*2)-1 downto 0);
    signal dmem_data_out : std_logic_vector((data_width*4)-1 downto 0);
    signal codec_interrupt: std_logic;
    signal codec_read : std_logic;
    signal codec_write : std_logic;
    signal codec_valid : std_logic;
    signal codec_data_out : std_logic_vector(7 downto 0);
    signal codec_data_in : std_logic_vector(7 downto 0);
begin
    estimulo_checagem : process is
        type colunas_tabela_verdade is record
            halt : std_logic;
            instruction_in : std_logic_vector(data_width-1 downto 0);
            instruction_addr: std_logic_vector(addr_width-1 downto 0); -- assert
            dmem_data_read : std_logic; -- assert
            dmem_data_write: std_logic; -- assert
            dmem_data_addr : std_logic_vector(addr_width-1 downto 0); -- assert
            dmem_data_in : std_logic_vector((data_width*2)-1 downto 0); -- assert
            dmem_data_out : std_logic_vector((data_width*4)-1 downto 0);
            codec_interrupt: std_logic; -- assert
            codec_read : std_logic; -- assert
            codec_write : std_logic; -- assert
            codec_valid : std_logic;
            codec_data_out : std_logic_vector(7 downto 0);
            codec_data_in : std_logic_vector(7 downto 0); -- assert
        end record;

        type vetor_tabela_verdade is array (0 to 1) of colunas_tabela_verdade;

        -- Implement more test cases
        constant tabela_verdade : vetor_tabela_verdade := (
            (
                '0', x"10", x"0000", -- IN
                '0', '1', x"0000", x"000C", x"00000000", -- Write DMEM
                '1', '1', '0', '1', x"0C", x"00" -- Read CODEC
            )
            ,(
                '0', x"10", x"0001", -- IN
                '0', '1', x"0001", x"00F3", x"00000000", -- Write DMEM
                '1', '1', '0', '1', x"F3", x"00"-- Read CODEC
            )
            -- ,(
            --     '0', x"20", x"0002", -- OUT
            --     '1', '0', x"0001", x"0000", x"000000F3", -- Read DMEM
            --     '1', '0', '1', '1', x"00", x"F3" -- Write CODEC
            -- ),(
            --     '0', x"20", x"0003", -- OUT
            --     '1', '0', x"0000", x"0000", x"0000000C", -- Read DMEM
            --     '1', '0', '1', '1', x"00", x"0C" -- Write CODEC
            -- )
        );

    begin
        for i in 0 to tabela_verdade'length-1 loop
            halt <= tabela_verdade(i).halt;
            instruction_in <= tabela_verdade(i).instruction_in;

            clock <= '1';
            wait for 1 ns;

            -- dmem_data_out <= tabela_verdade(i).dmem_data_out;
            -- codec_valid <= tabela_verdade(i).codec_valid;
            -- codec_data_out <= tabela_verdade(i).codec_data_out;
            
            -- assert instruction_addr = tabela_verdade(i).instruction_addr report "ERROR: instruction_addr. Line: " & integer'image(i);
            -- assert dmem_data_read = tabela_verdade(i).dmem_data_read report "ERROR: dmem_data_read. Line: " & integer'image(i);
            -- assert dmem_data_write = tabela_verdade(i).dmem_data_write report "ERROR: dmem_data_write. Line: " & integer'image(i);
            -- assert dmem_data_addr = tabela_verdade(i).dmem_data_addr report "ERROR: dmem_data_addr. Line: " & integer'image(i);
            -- assert codec_interrupt = tabela_verdade(i).codec_interrupt report "ERROR: codec_interrupt. Line: " & integer'image(i);
            -- assert codec_read = tabela_verdade(i).codec_read report "ERROR: codec_read. Line: " & integer'image(i);
            -- assert codec_write = tabela_verdade(i).codec_write report "ERROR: codec_write. Line: " & integer'image(i);

            clock <= not clock;
            wait for 1 ns;

            -- assert dmem_data_in = tabela_verdade(i).dmem_data_in report "ERROR: dmem_data_in. Line: " & integer'image(i);
            -- assert codec_data_in = tabela_verdade(i).codec_data_in report "ERROR: codec_data_in. Line: " & integer'image(i);

        end loop; 

        report "The end of tests" ;

        wait;
    end process estimulo_checagem;

    cpu : entity work.cpu(behavioral)
        generic map (addr_width => addr_width, data_width => data_width)
        port map (
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
        
    dmem : entity work.memory(behavioral)
        generic map (
            addr_width => addr_width,
            data_width => data_width
        )
        port map (
            clock => clock,
            data_read => dmem_data_read,
            data_write => dmem_data_write,
            data_addr => dmem_data_addr,
            data_in => dmem_data_in,
            data_out => dmem_data_out
        );
        
    codec : entity work.codec(behavioral)
        port map (
            interrupt => codec_interrupt,
            read_signal => codec_read,
            write_signal => codec_write,
            valid => codec_valid,
            codec_data_in => codec_data_in,
            codec_data_out  => codec_data_out
        );

end;