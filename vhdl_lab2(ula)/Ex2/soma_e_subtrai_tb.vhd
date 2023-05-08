library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soma_e_subtrai_tb is
end;

architecture a_soma_e_subtrai_tb of soma_e_subtrai_tb is
    component soma_e_subtrai
    port (
         x, y  : in unsigned(7 downto 0);
         soma, subt : out unsigned(7 downto 0)
    );
    end component;

    signal x, y, soma, subt : unsigned(7 downto 0);

    begin

        uut : soma_e_subtrai port map(
            x => x,
            y => y,
            soma => soma,
            subt => subt
        );

        process begin
            x <= "00000100";
            y <= "00000001";
            wait for 50 ns;
            wait;
        end process;

end architecture;