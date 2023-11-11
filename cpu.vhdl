LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY work;
USE work.opcode.ALL;

ENTITY cpu IS
    GENERIC (
        addr_width : NATURAL := 16; -- Memory Address Width (in bits)
        data_width : NATURAL := 8 -- Data Width (in bits)
    );
    PORT (
        clock : IN STD_LOGIC; -- Clock signal
        halt : IN STD_LOGIC; -- Halt processor execution when '1'
        ---- Begin Memory Signals ---
        -- Instruction byte received from memory
        instruction_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        -- Instruction address given to memory
        instruction_addr : OUT STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0);
        mem_data_read : OUT STD_LOGIC; -- When '1', read data from memory
        mem_data_write : OUT STD_LOGIC; -- When '1', write data to memory
        -- Data address given to memory
        mem_data_addr : OUT STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0);
        -- Data sent from memory when data_read = '1' and data_write = '0'
        mem_data_in : OUT STD_LOGIC_VECTOR((data_width * 2) - 1 DOWNTO 0);
        -- Data sent to memory when data_read = '0' and data_write = '1'
        mem_data_out : IN STD_LOGIC_VECTOR((data_width * 4) - 1 DOWNTO 0);
        ---- End Memory Signals ---
        ---- Begin Codec Signals ---
        codec_interrupt : OUT STD_LOGIC; -- Interrupt signal
        codec_read : OUT STD_LOGIC; -- Read signal
        codec_write : OUT STD_LOGIC; -- Write signal
        codec_valid : IN STD_LOGIC; -- Valid signal
        -- Byte written to codec
        codec_data_out : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- Byte read from codec
        codec_data_in : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        ---- End Codec Signals ---
    );
END ENTITY;

ARCHITECTURE behavioral OF cpu IS
    -- Implementar maquina de estados para CPU a fim de evitar conflito de instruções. Não da para executar tudo em apenas uma instrução. (fetch, decode, read, execute, write)
    SIGNAL stack_pointer, instruction_pointer : NATURAL := 0;

    TYPE state IS (fetch, decode_load, execute_store, halted);
    SIGNAL current_state, upcoming_state : state := halted;

    SIGNAL temp_mem_data_read : STD_LOGIC := '0';
    SIGNAL temp_mem_data_write : STD_LOGIC := '0';
    SIGNAL temp_mem_data_addr : STD_LOGIC_VECTOR(addr_width - 1 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, addr_width));
    SIGNAL temp_mem_data_in : STD_LOGIC_VECTOR((data_width * 2) - 1 DOWNTO 0) := STD_LOGIC_VECTOR(to_unsigned(0, 2 * data_width));

    SIGNAL temp_codec_interrupt : STD_LOGIC := '0';
    SIGNAL temp_codec_read : STD_LOGIC := '0';
    SIGNAL temp_codec_write : STD_LOGIC := '0';
    SIGNAL temp_codec_data_in : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
BEGIN
    PROCESS (clock) -- Synchronizing state machine
    BEGIN
        IF clock'event AND clock = '1' THEN
            current_state <= upcoming_state;
        END IF;
    END PROCESS;

    PROCESS (current_state, halt) -- State machine
    BEGIN
        CASE current_state IS
            WHEN fetch =>
                IF halt = '1' THEN
                    -- Go to halted state
                    upcoming_state <= halted;

                ELSE
                    -- Get instruction from IMEM
                    temp_codec_interrupt <= '0';
                    instruction_addr <= STD_LOGIC_VECTOR(to_unsigned(instruction_pointer, addr_width));
                    upcoming_state <= decode_load;

                END IF;

            WHEN decode_load =>
                upcoming_state <= execute_store;

                IF halt = '1' OR is_equal(instruction_in, type_hlt) THEN
                    -- Go to halted state
                    upcoming_state <= halted;

                ELSIF is_equal(instruction_in, type_in) THEN
                    -- Read from CODEC
                    temp_codec_interrupt <= '1';
                    temp_codec_read <= '1';
                    temp_codec_write <= '0';

                ELSE
                    -- Load from DMEM
                    temp_mem_data_read <= '1';
                    temp_mem_data_write <= '0';
                    temp_mem_data_addr <= STD_LOGIC_VECTOR(to_unsigned(stack_pointer - 1, addr_width));
                    stack_pointer <= stack_pointer - 1;

                END IF;

            WHEN execute_store =>
                upcoming_state <= fetch;

                IF halt = '1' THEN
                    -- Go to halted state
                    upcoming_state <= halted;

                ELSIF is_equal(instruction_in, type_in) THEN
                    IF codec_valid = '1' THEN
                        temp_mem_data_read <= '0';
                        temp_mem_data_write <= '1';
                        temp_mem_data_addr <= STD_LOGIC_VECTOR(to_unsigned(stack_pointer, addr_width));
                        temp_mem_data_in(data_width - 1 DOWNTO 0) <= codec_data_out;
                        stack_pointer <= stack_pointer + 1;
                    END IF;

                    instruction_pointer <= instruction_pointer + 1;

                ELSIF is_equal(instruction_in, type_out) THEN
                    temp_codec_interrupt <= '1';
                    temp_codec_read <= '0';
                    temp_codec_write <= '1';
                    temp_codec_data_in <= mem_data_out(data_width - 1 DOWNTO 0);

                    instruction_pointer <= instruction_pointer + 1;

                END IF;

            WHEN halted =>
                IF halt = '0' THEN
                    upcoming_state <= fetch;
                END IF;

        END CASE;
    END PROCESS;

    mem_data_read <= temp_mem_data_read;
    mem_data_write <= temp_mem_data_write;
    mem_data_addr <= temp_mem_data_addr;
    mem_data_in <= temp_mem_data_in;

    codec_interrupt <= temp_codec_interrupt;
    codec_read <= temp_codec_read;
    codec_write <= temp_codec_write;
    codec_data_in <= temp_codec_data_in;

END ARCHITECTURE;