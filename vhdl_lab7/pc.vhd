library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port (
        pc_sel: in unsigned(1 downto 0);
        pc_in_n: in unsigned(7 downto 0); 
        pc_in_j: in unsigned(7 downto 0); 
        pc_in_b: in unsigned(7 downto 0); 
        clk: in std_logic;
        rst: in std_logic;
        write_enable: in std_logic := '1';
        pc_out: out unsigned(7 downto 0) := X"00"
    );
end entity;

architecture a_pc of pc is

    signal pc_in_s: unsigned(7 downto 0);
    signal pc_out_s: unsigned(7 downto 0) := X"00";

    begin
        process(clk, rst, write_enable)
        begin

            if(rst = '1') then
                pc_out_s <= X"00";
            elsif(rising_edge(clk) and write_enable = '1') then
                pc_out_s <= pc_in_s;
            end if;

        end process;
        
        
        pc_in_s <= pc_in_j when pc_sel = "01" else 
                   pc_in_b when pc_sel = "10" else
                   pc_in_n;

        pc_out <= pc_out_s;
            
end architecture;
