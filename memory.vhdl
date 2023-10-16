library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    generic (
        addr_width: natural := 16; -- Memory Address Width (in bits)
        data_width: natural := 8 -- Data Width (in bits)
    );
    port (
        clock: in std_logic; -- Clock signal; Write on Falling-Edge
        data_read : in std_logic; -- When '1', read data from memory
        data_write: in std_logic; -- When '1', write data to memory
        -- Data address given to memory
        data_addr : in std_logic_vector(addr_width-1 downto 0);
        -- Data sent to memory when data_read = '1' and data_write = '0'
        data_in : in std_logic_vector((data_width*2)-1 downto 0);
        -- Data sent from memory when data_read = '0' and data_write = '1'
        data_out : out std_logic_vector((data_width*4)-1 downto 0)
    );
end entity;

architecture behavioral of memory is
    subtype data_word is std_logic_vector(data_width-1 downto 0);
    type data_memory is array (0 to (2**addr_width)-1) of data_word;
    signal ram : data_memory := (others => (others => '0'));
begin

    -- Edge-triggered random access memory
    process (clock)
    begin
        
        if clock = '0' then
            if data_read = '1' and data_write = '0' then
                data_out <= ram(to_integer(unsigned(data_addr))+3) & ram(to_integer(unsigned(data_addr))+2) & ram(to_integer(unsigned(data_addr))+1) & ram(to_integer(unsigned(data_addr)));
            elsif data_read = '0' and data_write = '1' then
                ram(to_integer(unsigned(data_addr))) <= data_in(data_width-1 downto 0);
                ram(to_integer(unsigned(data_addr))+1) <= data_in(2*data_width-1 downto data_width);
            end if; 

        else
            data_out <= std_logic_vector(to_unsigned(0, data_width*4));

        end if;
        
    end process;

end architecture;