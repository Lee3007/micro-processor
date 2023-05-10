library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port (
        override: in std_logic;
        pc_in_n: in unsigned(15 downto 0); 
        pc_in_j: in unsigned(15 downto 0); 
        clk: in std_logic;
        write_enable: in std_logic := '1';
        pc_out: out unsigned(15 downto 0) := X"0000"
    );
end entity;

architecture a_pc of pc is

    signal pc_in_s: unsigned(15 downto 0);
    signal pc_out_s: unsigned(15 downto 0) := X"0000";

    begin
        process(clk, write_enable)
        begin
            if(rising_edge(clk) and write_enable = '1') then
                pc_out_s <= pc_in_s;
            end if;
        end process;
                
        pc_in_s <= pc_in_j when override = '1' else pc_in_n;
        pc_out <= pc_out_s;
            
end architecture;
