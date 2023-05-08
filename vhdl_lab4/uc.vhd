library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port (
        clk: in std_logic;
        rst: in std_logic;
        pc_wr_en: out std_logic;
        pc_out: in unsigned(15 downto 0);
        instruction_in: in unsigned(15 downto 0);
        pc_override: out std_logic;
        pc_in_n: out unsigned(15 downto 0); 
        pc_in_j: out unsigned(15 downto 0)
    );
end entity;

architecture a_uc of uc is
    
    component state_machine is
        port (
            clk: in std_logic;
            rst: in std_logic;
            state: out std_logic
        );
    end component;
    signal state_s: std_logic;

    begin
        uut1: state_machine port map(
            clk => clk,
            rst => rst,
            state => state_s
        );

        pc_override <= '1' when instruction_in(15) = '1' else '0';
        pc_in_j <= ("0" & instruction_in(14 downto 0)); --accessing only half od ROM

        pc_wr_en <= state_s;
        pc_in_n <= pc_out + 1;

end architecture;
