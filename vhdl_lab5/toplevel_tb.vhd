library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel_tb is
end entity;

architecture toplevel_tb_a of toplevel_tb is

    component pc is
        port (
            clk: in std_logic;
            override: in std_logic;
            write_enable: in std_logic;
            pc_in_n: in unsigned(15 downto 0); 
            pc_in_j: in unsigned(15 downto 0); 
            pc_out: out unsigned(15 downto 0)
        );
    end component;
    
    component uc is
        port (
            clk: in std_logic;
            rst: in std_logic;
            pc_wr_en: out std_logic;
            pc_out: in unsigned(15 downto 0) := X"0000";
            instruction_in: in unsigned(15 downto 0);
            pc_override: out std_logic;
            pc_in_n: out unsigned(15 downto 0); 
            pc_in_j: out unsigned(15 downto 0)
        );
    end component;

    component rom is
        port (
            clk: in std_logic;
            endereco: in unsigned(6 downto 0);
            dado: out unsigned(15 downto 0)
        );
    end component;
    
    signal clk_s, pc_wr_en_s, override_s, rst_s: std_logic;
    signal pc_in_n_s, pc_in_j_s, pc_out_s, instruction_in_s: unsigned(15 downto 0);

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin

        uut1: pc port map(
            clk => clk_s,
            write_enable => pc_wr_en_s,
            override => override_s,
            pc_in_n => pc_in_n_s,
            pc_in_j => pc_in_j_s,
            pc_out => pc_out_s
        );

        uut2: uc port map(
            clk => clk_s,
            rst => rst_s,
            pc_wr_en => pc_wr_en_s,
            pc_out => pc_out_s,
            instruction_in => instruction_in_s,
            pc_override => override_s,
            pc_in_n => pc_in_n_s,
            pc_in_j => pc_in_j_s
        );

        uut3: rom port map(
            endereco => pc_out_s,
            dado => instruction_in_s
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


-- ghdl -a pc.vhd && ghdl -e pc
-- ghdl -a rom.vhd && ghdl -e rom
-- ghdl -a uc.vhd && ghdl -e uc
-- ghdl -a toplevel_tb.vhd && ghdl -e toplevel_tb
-- ghdl -r toplevel_tb --wave=toplevel_tb.ghw && gtkwave toplevel_tb.ghw
