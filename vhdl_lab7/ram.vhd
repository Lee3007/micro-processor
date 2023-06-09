library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port(
        clk : in std_logic;
        wr_en : in std_logic;
        rst : in std_logic;
        address : in unsigned(7 downto 0);
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_ram of ram is
    
    type mem is array (0 to 255) of unsigned(15 downto 0);
    signal conteudo_ram : mem;
    
    begin
        process(clk, rst)
        begin
            if rst = '1' then
                for i in conteudo_ram'range loop
                    conteudo_ram(i) <= X"0000";
                end loop;
                -- conteudo_ram(255 downto 0) <= X"0000";
            elsif rising_edge(clk) then
                if wr_en='1' then
                    conteudo_ram(to_integer(address)) <= data_in;
                end if;
            end if;

        end process;

        data_out <= conteudo_ram(to_integer(address));
end architecture;