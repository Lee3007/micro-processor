library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs_tb is
end;

architecture arch_banco_regs_tb of banco_regs_tb is

    component banco_regs is
        port(
            --selecionando regs
            out_sel_a: in unsigned(2 downto 0);
            out_sel_b: in unsigned(2 downto 0);
            write_sel: in unsigned(2 downto 0);
            
            --fluxo de dados
            data_in: in unsigned(15 downto 0);
            out_a: out unsigned(15 downto 0);
            out_b: out unsigned(15 downto 0);
            
            --controle
            clk: in std_logic;
            rst: in std_logic;
            write_enable: in std_logic
        );
    end component;

    signal out_sel_a, out_sel_b, write_sel: unsigned(2 downto 0) := "000";
    signal data_in, out_a, out_b: unsigned(15 downto 0) := X"0000";
    signal clk, rst, write_enable: std_logic := '0';

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

begin

    uut: banco_regs port map(
        out_sel_a => out_sel_a,
        out_sel_b => out_sel_b,
        write_sel => write_sel,
        data_in => data_in,
        out_a => out_a,
        out_b => out_b,
        clk => clk,
        rst => rst,
        write_enable => write_enable
    );

    reset_global: process
    begin
        rst <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us; -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
        clk <= '0';
        wait for period_time/2;
        clk <= '1';
        wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process -- sinais dos casos de teste
    begin
        wait for 200 ns;
        out_sel_a <= "001";
        out_sel_b <= "001";
        write_sel <= "010";
        write_enable <= '1';
        data_in <= X"1111";
        wait for 100 ns;
        out_sel_a <= "010";
        out_sel_b <= "010";
        write_sel <= "010";
        write_enable <= '0';
        data_in <= X"0000";
        wait for 100 ns;
        out_sel_a <= "000";
        out_sel_b <= "010";
        write_sel <= "010";
        write_enable <= '0';
        data_in <= X"0000";
        wait for 100 ns;
        wait;
    end process;

end architecture;