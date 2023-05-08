library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture rom_tb_a of rom_tb is

    component rom is
        port (
            clk: in std_logic;
            endereco: in unsigned(15 downto 0); --65536 end de mem
            dado: out unsigned(15 downto 0)
        );
    end component;
    
    signal clk: std_logic;
    signal endereco, dado: unsigned(15 downto 0);

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin

        uut: rom port map(
            clk => clk,
            endereco => endereco,
            dado => dado
        );

        sim_time_proc: process
        begin
            wait for 10 us;
            finished <= '1';
            wait;
        end process sim_time_proc;

        clk_proc: process
        begin
            while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
            end loop;
            wait;
        end process clk_proc;

        process begin
            wait for 200 ns;
            endereco <= X"0006";
            wait for 200 ns;
            endereco <= X"0007";
            wait for 200 ns;
            endereco <= X"0001";
            wait;
        end process;

end architecture;

--  ghdl -a rom.vhdl && ghdl -e rom && ghdl -a rom_tb.vhdl && ghdl -e rom_tb && ghdl -r rom_tb --wave=rom_tb.ghw && gtkwave rom_tb.ghw