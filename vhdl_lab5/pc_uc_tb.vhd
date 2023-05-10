library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_uc_tb is
end entity;

architecture pc_uc_tb_a of pc_uc_tb is

    component proto_uc is
        port (
            data_in: in unsigned(15 downto 0); 
            clk: in std_logic;
            data_out: out unsigned(15 downto 0)
        );
    end component;

    component pc is
        port (
            data_in: in unsigned(15 downto 0); 
            clk: in std_logic;
            write_enable: in std_logic := '1';
            data_out: out unsigned(15 downto 0)
        );
    end component;

    signal clk_s, write_enable_s: std_logic;
    signal data_in_s, data_out_s: unsigned(15 downto 0);

    constant period_time : time := 100 ns;
    signal finished : std_logic := '0';

    begin

        uut: pc port map(
            write_enable => write_enable_s,
            clk => clk_s,
            data_in => data_in_s,
            data_out => data_out_s
        );

        uut2: proto_uc port map(
            clk => clk_s,
            data_in => data_out_s,
            data_out => data_in_s
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

            write_enable_s <= '1';
            
            wait;
        end process;

end architecture;

--  ghdl -a pc_uc.vhd && ghdl -e pc_uc && ghdl -a pc_uc_tb.vhd && ghdl -e pc_uc_tb && ghdl -r pc_uc_tb --wave=pc_uc_tb.ghw && gtkwave pc_uc_tb.ghw


--  ghdl -a pc_uc_tb.vhd && ghdl -e pc_uc_tb && ghdl -r pc_uc_tb --wave=pc_uc_tb.ghw && gtkwave pc_uc_tb.ghw