library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is
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
end;

architecture arch_banco_regs of banco_regs is

    component reg_16bits is
        port(
            reg_in: in unsigned(15 downto 0);
            rst: in std_logic;
            clk: in std_logic;
            write_enable: in std_logic;
            reg_out: out unsigned (15 downto 0)
        );
    end component;

    type output_array is array (7 downto 0) of unsigned(15 downto 0);

    signal out_signal_a, out_signal_b: unsigned(15 downto 0);
    signal write_enables: std_logic_vector(7 downto 0);
    signal out_buses: output_array;

    begin
        reg_0: reg_16bits port map(
            reg_in => X"0000",
            rst => rst,
            clk => clk,
            write_enable => write_enables(0),
            reg_out => out_buses(0)
        );

        gen_regs: for i in 1 to 7 generate
            reg_i: reg_16bits port map(
                reg_in => data_in,
                rst => rst,
                clk => clk,
                write_enable => write_enables(i),
                reg_out => out_buses(i)
            ); --do reg => do banco
        end generate gen_regs;

        process(clk, rst)
        begin

            if(rst = '1') then
                out_signal_a <= X"0000";
                out_signal_b <= X"0000";
            else
                if(rising_edge(clk)) then
                    out_signal_a <= out_buses(to_integer(out_sel_a));
                    out_signal_b <= out_buses(to_integer(out_sel_b));
                end if;
            end if;

        end process;

        gen_write_enables: for i in 0 to 7 generate
            write_enables(i) <= write_enable when to_integer(write_sel) = i else '0';
        end generate gen_write_enables;

        out_a <= out_signal_a;
        out_b <= out_signal_b;

end architecture;