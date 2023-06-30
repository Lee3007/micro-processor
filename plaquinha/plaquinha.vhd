library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity plaquinha is

	port(
		clk, rst: in std_logic;
	
		reg_out_TEST: out std_logic_vector(15 downto 0);
		reg_out2_TEST: out std_logic_vector(15 downto 0)
	);

end plaquinha;

architecture arq_plaq of plaquinha is

	component toplevel is
		 port (
			  clock: in std_logic;
			  rst: in std_logic;

			  reg_a: out unsigned(15 downto 0);
			  reg_b: out unsigned(15 downto 0)

		 );
	end component;

	signal a, b: unsigned(15 downto 0);
	
begin

	up: toplevel port map(
			clock => clk,
			rst => rst,

			reg_a => a,
			reg_b => b
	);
	
	reg_out_TEST <= std_logic_vector(a);
	reg_out2_TEST <= std_logic_vector(b);

end architecture;