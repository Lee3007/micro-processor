library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel_tb is
end entity;

architecture toplevel_tb_a of toplevel_tb is
    
    component toplevel is
        port (
            clock: in std_logic;
            rst: in std_logic;
            state: out unsigned(1 downto 0);
            pc_out: out unsigned(7 downto 0);
            instruction: out unsigned(15 downto 0);
            reg_a: out unsigned(15 downto 0);
            reg_b: out unsigned(15 downto 0);
            result: out unsigned(15 downto 0);
            zero, carry: out std_logic
        );
    end component;

    signal clk_s, rst_s, zero_s, carry_s: std_logic;
    signal state_s: unsigned(1 downto 0);
    signal pc_s: unsigned(7 downto 0);
    signal instruction_s, reg_a_s, reg_b_s, result_s: unsigned(15 downto 0);

    constant period_time : time := 10 ns;
    signal finished : std_logic := '0';

    begin

        topleveluut: toplevel port map(
            clock => clk_s,
            rst => rst_s,
            state => state_s,
            pc_out => pc_s,
            instruction => instruction_s,
            reg_a => reg_a_s,
            reg_b => reg_b_s,
            result => result_s,
            zero => zero_s,
            carry => carry_s
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
            rst_s <= '1';
            wait for 50 ns;
            rst_s <= '0';

            wait;
        end process;

end architecture;
