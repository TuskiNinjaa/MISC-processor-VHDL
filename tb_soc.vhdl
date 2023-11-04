library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_soc is
end;

architecture hibrida of tb_soc is
    constant firmware_filename : string := "firmware.bin";
    constant quantity_instruction : integer := 15;
    signal clock, started : std_logic;
begin
    soc : entity work.soc(structural)
        generic map (firmware_filename => firmware_filename)
        port map (clock => clock, started => started);

    estimulo_checagem : process is
        
    begin
        for i in 1 to quantity_instruction loop
            clock <= '1';
            wait for 1 ns;
            clock <= not clock;
            wait for 1 ns;
        end loop; 

        report "The end of tests" ;

        wait;
    end process estimulo_checagem;
end;