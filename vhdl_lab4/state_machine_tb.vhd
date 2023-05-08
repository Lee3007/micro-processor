library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine_tb is
end entity;

architecture state_machine_tb_a of state_machine_tb is

    component state_machine is
        port (
            clk: in std_logic;
            rst: in std_logic;
            state: out std_logic
        );
    end component;
    
    signal clk, rst, state: std_logic;

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin

        uut: state_machine port map(
            clk => clk,
            state => state,
            rst => rst
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
            rst <= '1';
            wait for 200 ns;
            rst <= '0';
            wait;
        end process;

end architecture;

--  ghdl -a state_machine.vhd && ghdl -e state_machine && ghdl -a state_machine_tb.vhd && ghdl -e state_machine_tb && ghdl -r state_machine_tb --wave=state_machine_tb.ghw && gtkwave state_machine_tb.ghw