library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.opcode.all;

entity cpu is
    generic (
        addr_width: natural := 16; -- Memory Address Width (in bits)
        data_width: natural := 8 -- Data Width (in bits)
    );
    port (
        clock: in std_logic; -- Clock signal
        halt : in std_logic; -- Halt processor execution when '1'
        ---- Begin Memory Signals ---
        -- Instruction byte received from memory
        instruction_in : in std_logic_vector(data_width-1 downto 0);
        -- Instruction address given to memory
        instruction_addr: out std_logic_vector(addr_width-1 downto 0);
        mem_data_read : out std_logic; -- When '1', read data from memory
        mem_data_write: out std_logic; -- When '1', write data to memory
        -- Data address given to memory
        mem_data_addr : out std_logic_vector(addr_width-1 downto 0);
        -- Data sent from memory when data_read = '1' and data_write = '0'
        mem_data_in : out std_logic_vector((data_width*2)-1 downto 0);
        -- Data sent to memory when data_read = '0' and data_write = '1'
        mem_data_out : in std_logic_vector((data_width*4)-1 downto 0);
        ---- End Memory Signals ---
        ---- Begin Codec Signals ---
        codec_interrupt: out std_logic; -- Interrupt signal
        codec_read: out std_logic; -- Read signal
        codec_write: out std_logic; -- Write signal
        codec_valid: in std_logic; -- Valid signal
        -- Byte written to codec
        codec_data_out : in std_logic_vector(7 downto 0);
        -- Byte read from codec
        codec_data_in : out std_logic_vector(7 downto 0)
        ---- End Codec Signals ---
    );
end entity;

architecture behavioral of cpu is
    -- Implementar maquina de estados para CPU a fim de evitar conflito de instruções. Não da para executar tudo em apenas uma instrução
    signal stack_pointer, instruction_pointer : natural := 0;

    signal temp_mem_data_read : std_logic := '0';
    signal temp_mem_data_write: std_logic := '0';
    signal temp_mem_data_addr : std_logic_vector(addr_width-1 downto 0) := std_logic_vector(to_unsigned(0, addr_width));
    signal temp_mem_data_in : std_logic_vector((data_width*2)-1 downto 0):= std_logic_vector(to_unsigned(0, 2*data_width));
    -- signal temp_codec_interrupt: std_logic;
    -- signal temp_codec_read : std_logic;
    -- signal temp_codec_write : std_logic;
    -- signal temp_codec_data_in : std_logic_vector(7 downto 0);
begin
    process (clock)
    begin
        if halt /= '1' and clock'event and clock='1' then
            if instruction_in = type_hlt then
                report "HLT implementation";
            elsif instruction_in = type_in then
                codec_interrupt <= '1';
                codec_read <= '1';
                codec_write <= '0';
                codec_data_in <= std_logic_vector(to_unsigned(0, data_width));

                --if codec_valid = '1' then
                    temp_mem_data_read <= '0';
                    temp_mem_data_write <= '1';
                    temp_mem_data_addr <= std_logic_vector(to_unsigned(stack_pointer, addr_width));
                    temp_mem_data_in(data_width-1 downto 0) <= codec_data_out;
                    temp_mem_data_in(2*data_width-1 downto data_width) <= std_logic_vector(to_unsigned(0, data_width));

                    stack_pointer <= stack_pointer + 1;
                    codec_interrupt <= '0';
                --end if;

                instruction_pointer <= instruction_pointer + 1;
            elsif instruction_in = type_out then
                report "OUT implementation";
                -- mem_data_read <= '1';
                -- mem_data_write <= '0';
                -- mem_data_addr <= std_logic_vector(to_unsigned(stack_pointer-1, addr_width));
                -- mem_data_in <= std_logic_vector(to_unsigned(0, 2*data_width));

                -- codec_interrupt <= '1';
                -- codec_read <= '0';
                -- codec_write <= '1';
                -- codec_data_in <= mem_data_out(data_width-1 downto 0);

                -- stack_pointer <= stack_pointer - 1;
                -- instruction_pointer <= instruction_pointer + 1;

            elsif instruction_in = type_slt then
                report "SLT implementation";
            elsif instruction_in = type_shl then
                report "SHL implementation";
            elsif instruction_in = type_shr then
                report "SHR implementation";
            elsif instruction_in = type_jeq then
                report "JEQ implementation";
            elsif instruction_in = type_jmp then
                report "JMP implementation";
            else
                report "Others implementation";
            end if;

        -- elsif halt /= '1' and clock'event and clock='0' then
        --     if instruction_in = type_in then

        --         if codec_valid = '1' then
        --             temp_mem_data_read <= '0';
        --             temp_mem_data_write <= '1';
        --             temp_mem_data_addr <= std_logic_vector(to_unsigned(stack_pointer, addr_width));
        --             temp_mem_data_in(data_width-1 downto 0) <= codec_data_out;
        --             temp_mem_data_in(2*data_width-1 downto data_width) <= std_logic_vector(to_unsigned(0, data_width));

        --             stack_pointer <= stack_pointer + 1;
        --             codec_interrupt <= '0';
        --         end if;

        --         instruction_pointer <= instruction_pointer + 1;

        --     elsif instruction_in = type_out then
        --         report "OUT implementation";

        --     elsif instruction_in = type_slt then
        --         report "SLT implementation";
        --     elsif instruction_in = type_shl then
        --         report "SHL implementation";
        --     elsif instruction_in = type_shr then
        --         report "SHR implementation";
        --     elsif instruction_in = type_jeq then
        --         report "JEQ implementation";
        --     elsif instruction_in = type_jmp then
        --         report "JMP implementation";
        --     else
        --         report "Others implementation";
        --     end if;
        end if;

        instruction_addr <= std_logic_vector(to_unsigned(instruction_pointer, addr_width));
    end process;

    mem_data_read <= temp_mem_data_read;
    mem_data_write <= temp_mem_data_write;
    mem_data_addr <= temp_mem_data_addr;
    mem_data_in <= temp_mem_data_in;



end architecture;