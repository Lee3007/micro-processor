library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end entity;

architecture pc_tb_a of pc_tb is

    component pc is
        port (
            override: in std_logic;
            pc_in_n: in unsigned(15 downto 0); 
            pc_in_j: in unsigned(15 downto 0); 
            clk: in std_logic;
            write_enable: in std_logic;
            pc_out: out unsigned(15 downto 0)
        );
    end component;
    
    signal clk_s, write_enable_s, override_s: std_logic;
    signal pc_in_n_s, pc_in_j_s, pc_out_s: unsigned(15 downto 0) := X"0000";

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin

        uut: pc port map(
            override => override_s,
            write_enable => write_enable_s,
            clk => clk_s,
            pc_in_n => pc_in_n_s,
            pc_in_j => pc_in_j_s
            pc_out => pc_out_s
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
            clk_s <= '0';
            wait for period_time/2;
            clk_s <= '1';
            wait for period_time/2;
            end loop;
            wait;
        end process clk_proc;

        process
        begin

            wait;
        end process;

end architecture;

--  ghdl -a pc.vhd && ghdl -e pc && ghdl -a pc_tb.vhd && ghdl -e pc_tb && ghdl -r pc_tb --wave=pc_tb.ghw && gtkwave pc_tb.ghw