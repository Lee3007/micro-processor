library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end;

architecture arch_top_level_tb of top_level_tb is

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

    component ula is
        port (
            x, y        : in unsigned(15 downto 0);
            sel_op      : in unsigned(1 downto 0);
            result      : out unsigned(15 downto 0);
            zero, carry : out std_logic
        );
    end component;

    signal out_sel_a, out_sel_b, write_sel: unsigned(2 downto 0) := "000";
    signal data_in, out_a, out_b: unsigned(15 downto 0) := X"0000";
    signal clk, rst, write_enable: std_logic := '0';

    signal sel_op: unsigned(1 downto 0) := "00";
    signal zero, carry: std_logic;

    signal ula_out: unsigned(15 downto 0) := X"0000";

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    signal DEBUG : unsigned(15 downto 0);

begin

    uut1: banco_regs port map(
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

    uut2: ula port map(
        x => out_a,
        y => out_b,
        result => ula_out,
        sel_op => sel_op,
        zero => zero,
        carry => carry
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
        wait for 2 us; -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
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

    process
    begin
        --esperando o rst
        wait for period_time*2;
        wait for 50 ns;
        
        -- $1 <= 0f0f
        wait for 5 ns;
        write_enable <= '1';
        write_sel <= "001";
        data_in <= X"0F0F";
        wait for 95 ns;
        
        -- $2 <= 0001
        wait for 5 ns;
        write_sel <= "010";
        data_in <= X"0001";
        wait for 95 ns;
        
        -- $3 <= $1 + $2 <= 0f10 
        wait for 5 ns;
        sel_op <= "00";
        out_sel_a <= "001";
        out_sel_b <= "010";
        write_sel <= "011";
        wait for 95 ns;
        
        wait for 5 ns;
        data_in <= ula_out;
        wait for 95 ns;
        
        wait for 5 ns;
        write_enable <= '0';
        out_sel_a <= "011";
        wait for 95 ns;


        -- $4 <= 2
        wait for 5 ns;
        write_enable <= '1';
        write_sel <= "100";
        data_in <= X"0002";
        wait for 95 ns;
                
        -- $1 <= $3 - $4
        wait for 5 ns;
        sel_op <= "01";
        out_sel_a <= "011";
        out_sel_b <= "100";
        write_sel <= "001";
        wait for 95 ns;
        
        wait for 5 ns;
        data_in <= ula_out;
        wait for 95 ns;
        
        wait for 5 ns;
        write_enable <= '0';
        out_sel_a <= "001";
        wait for 95 ns;

        -- $1 = 0f0e
        -- $2 = 0001
        -- $3 = 0f10
        -- $4 = 0002

        
        -- $5 <= $4 * $3 = 0002 * 0f10
        wait for 5 ns;
        write_enable <= '1';
        sel_op <= "10";
        out_sel_a <= "100";
        out_sel_b <= "011";
        write_sel <= "101";
        wait for 95 ns;
        
        wait for 5 ns;
        data_in <= ula_out;
        wait for 95 ns;
        
        wait for 5 ns;
        write_enable <= '0';
        out_sel_a <= "101";
        wait for 95 ns;
        
        -- $1 = 0f0e
        -- $2 = 0001
        -- $3 = 0f10
        -- $4 = 0002
        
        wait for 5 ns;
        sel_op <= "11";
        out_sel_a <= "010";
        out_sel_b <= "011";
        wait for 95 ns;
        --ula out: $2 < $3        
        
        wait;
    end process;

end architecture;