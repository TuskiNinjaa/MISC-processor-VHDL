LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY work;
USE work.opcode.ALL;

ENTITY tb_soc IS
END;

ARCHITECTURE hibrida OF tb_soc IS
    CONSTANT addr_width : NATURAL := 16;
    CONSTANT data_width : NATURAL := 8;
    CONSTANT firmware_filename : STRING := "bin/firmware.bin";
    CONSTANT quantity_instruction : INTEGER := 30;
    SIGNAL clock, started : STD_LOGIC := '0';
BEGIN
    soc : ENTITY work.soc(structural)
        GENERIC MAP(firmware_filename => firmware_filename)
        PORT MAP(clock => clock, started => started);

    tester : PROCESS IS
        -- All signals were confirmed via GTKWAVE, because SOC does not have output signals
    BEGIN
        -- Loading IMEM
        started <= '0';

        FOR i IN 1 TO quantity_instruction LOOP
            clock <= NOT clock;
            WAIT FOR 1 ns;
            clock <= NOT clock;
            WAIT FOR 1 ns;
        END LOOP;

        -- 1 cycle to turn CPU on
        started <= '1';

        clock <= NOT clock;
        WAIT FOR 1 ns;
        clock <= NOT clock;
        WAIT FOR 1 ns;

        -- Staring execution (3 clock cycles for 1 instruction)
        FOR i IN 1 TO 3 * (quantity_instruction) LOOP
            clock <= NOT clock;
            WAIT FOR 1 ns;
            clock <= NOT clock;
            WAIT FOR 1 ns;
        END LOOP;

        -- Adding extra cycles
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
        clock <= NOT clock;
        WAIT FOR 1 ns;

        REPORT "The end of tests";

        WAIT;
    END PROCESS tester;
END;