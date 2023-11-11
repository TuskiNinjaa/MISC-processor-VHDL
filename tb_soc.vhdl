LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_soc IS
END;

ARCHITECTURE hibrida OF tb_soc IS
    CONSTANT firmware_filename : STRING := "bin/firmware.bin";
    CONSTANT quantity_instruction : INTEGER := 30;
    SIGNAL clock, started : STD_LOGIC := '0';
BEGIN
    soc : ENTITY work.soc(structural)
        GENERIC MAP(firmware_filename => firmware_filename)
        PORT MAP(clock => clock, started => started);

    estimulo_checagem : PROCESS IS

    BEGIN
        FOR i IN 1 TO quantity_instruction LOOP
            clock <= '1';
            WAIT FOR 1 ns;
            clock <= NOT clock;
            WAIT FOR 1 ns;
        END LOOP;

        REPORT "The end of tests";

        WAIT;
    END PROCESS estimulo_checagem;
END;