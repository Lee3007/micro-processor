library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk: in std_logic;
        endereco: in unsigned(15 downto 0); --65536 end de mem
        dado: out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    
    type mem is array (0 to 65535) of unsigned (15 downto 0);

    constant conteudo_rom : mem := (
        0 => X"0001",
        1 => X"1000",
        2 => X"0000",
        3 => X"0000",
        4 => X"1000",
        5 => X"0002",
        6 => X"F003",
        7 => X"0002",
        8 => X"0002",
        9 => X"0000",
        10 => X"0000",
    others => (others=>'0'));

    begin
        process(clk)
        begin
            if(rising_edge(clk)) then
                dado <= conteudo_rom(to_integer(endereco));
            end if;
        end process;

end architecture;