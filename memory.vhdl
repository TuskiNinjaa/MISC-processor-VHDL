LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY memory IS
    GENERIC (
        addr_width : NATURAL := 16; -- Memory Address Width (in bits)
        data_width : NATURAL := 8 -- Data Width (in bits)
    );
    PORT (
        clock : IN STD_LOGIC; -- Clock signal; Write on Falling-Edge
        data_read : IN STD_LOGIC; -- When '1', read data from memory
        data_write : IN STD_LOGIC; -- When '1', write data to memory
        -- Data address given to memory
        data_addr : IN STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0);
        -- Data sent to memory when data_read = '1' and data_write = '0'
        data_in : IN STD_LOGIC_VECTOR((data_width * 2) - 1 DOWNTO 0);
        -- Data sent from memory when data_read = '0' and data_write = '1'
        data_out : OUT STD_LOGIC_VECTOR((data_width * 4) - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE behavioral OF memory IS
    SUBTYPE data_word IS STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    TYPE data_memory IS ARRAY (0 TO (2 ** addr_width) - 1) OF data_word;
    SIGNAL ram : data_memory := (OTHERS => (OTHERS => '0'));
    SIGNAL output : STD_LOGIC_VECTOR((data_width * 4) - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN

    -- Edge-triggered random access memory
    PROCESS (clock)
        VARIABLE index : INTEGER RANGE 0 TO (2 ** addr_width) - 1;
    BEGIN
        IF clock'event AND clock = '0' THEN
            index := to_integer(unsigned(data_addr));

            IF data_read = '1' AND data_write = '0' THEN
                output <= ram(index + 3) & ram(index + 2) & ram(index + 1) & ram(index);
            ELSIF data_read = '0' AND data_write = '1' THEN
                ram(index) <= data_in(data_width - 1 DOWNTO 0);
                ram(index + 1) <= data_in(2 * data_width - 1 DOWNTO data_width);
                output <= STD_LOGIC_VECTOR(to_unsigned(0, data_width * 4));
            END IF;

        END IF;

    END PROCESS;

    data_out <= output;

END ARCHITECTURE;