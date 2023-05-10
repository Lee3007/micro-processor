library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end entity;

architecture uc_tb_a of uc_tb is

    component uc is
        port (
            data_in: in unsigned(15 downto 0); 
            clk: in std_logic;
            data_out: out unsigned(15 downto 0)
        );
    end component;
    
    signal clk: std_logic;
    signal data_in_s, data_out_s: unsigned(15 downto 0);

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin

        uut: uc port map(
            clk => clk,
            data_in => data_in_s,
            data_out => data_out_s
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

        process
        begin
            data_in_s <= X"0000";
            wait for 200 ns;
            data_in_s <= X"1011";
            wait;
        end process;

end architecture;

--  ghdl -a uc.vhd && ghdl -e uc && ghdl -a uc_tb.vhd && ghdl -e uc_tb && ghdl -r uc_tb --wave=uc_tb.ghw && gtkwave uc_tb.ghw