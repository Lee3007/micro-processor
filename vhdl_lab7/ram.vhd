library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port(
        clk : in std_logic;
        wr_en : in std_logic;
        rst : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado_in : in unsigned(15 downto 0);
        dado_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_ram of ram is
    
    type mem is array (0 to 127) of unsigned(15 downto 0);
    signal conteudo_ram : mem;
    
    begin
        process(clk, rst)
        begin
            if rst = '1' then
                conteudo_ram(127 downto 0) <= X"0000";
            elsif rising_edge(clk) then
                if wr_en='1' then
                    conteudo_ram(to_integer(endereco)) <= dado_in;
                end if;
            end if;

        end process;

        dado_out <= conteudo_ram(to_integer(endereco));
end architecture;