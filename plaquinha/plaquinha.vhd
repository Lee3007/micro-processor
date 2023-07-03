library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity plaquinha is

	port(
		clk, rst: in std_logic;
		clk_sel: in std_logic;
		clk_btn: in std_logic;
	
		reg_out_TEST: out std_logic_vector(15 downto 0);
		reg_out2_TEST: out std_logic_vector(15 downto 0);
		
		reg_a_low_disp: out std_logic_vector(0 to 6);
		reg_a_high_disp: out std_logic_vector(0 to 6);
		reg_b_low_disp: out std_logic_vector(0 to 6);
		reg_b_high_disp: out std_logic_vector(0 to 6)
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
	
	component HexTo7Seg is
		 port(
			  H: in std_logic_vector(0 to 3);
			  Q: out std_logic_vector(0 to 6)
		 );
	end component;
	
	component Timing_Reference is
		port(
			clk: in std_logic;
			clk_xHz: out std_logic
		);
	end component;

	signal a, b: unsigned(15 downto 0);
	signal a_low_out, a_high_out: std_logic_vector(3 downto 0);
	signal b_low_out, b_high_out: std_logic_vector(3 downto 0);
	signal divided_clock: std_logic;
	signal selected_clock: std_logic;
	
begin

	up: toplevel port map(
			clock => selected_clock,
			rst => not rst,

			reg_a => a,
			reg_b => b
	);
	
	clock_divider: Timing_Reference port map(
		clk => clk,
		clk_xHz => divided_clock
	);
	
	reg_a_low_conv: HexTo7Seg port map(
		H => a_low_out,
		Q => reg_a_low_disp
	);
	reg_a_high_conv: HexTo7Seg port map(
		H => a_high_out,
		Q => reg_a_high_disp
	);
	reg_b_low_conv: HexTo7Seg port map(
		H => b_low_out,
		Q => reg_b_low_disp
	);
	reg_b_high_conv: HexTo7Seg port map(
		H => b_high_out,
		Q => reg_b_high_disp
	);
	
	
	a_low_out <= std_logic_vector(a(3 downto 0));
	a_high_out <= std_logic_vector(a(7 downto 4));
	
	b_low_out <= std_logic_vector(b(3 downto 0));
	b_high_out <= std_logic_vector(b(7 downto 4));
	
	selected_clock <= (clk and not clk_sel) or (not clk_btn and clk_sel);
	
	
	reg_out_TEST <= std_logic_vector(a);
	reg_out2_TEST <= std_logic_vector(b);

end architecture;