library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Timing_Reference is
	port(
		clk: in std_logic;
		clk_xHz: out std_logic
	);
end Timing_Reference;

architecture freq_div of Timing_Reference is
	signal count: integer := 1;
	signal tmp: std_logic := '0';

	
begin

	process(clk)
	begin
		if(clk'event and clk = '1') then
			count <= count+1;
			if(count = 50000/2) then
				tmp <= NOT tmp;
				count <= 1;
				end if;
			end if;
			clk_xHz <= tmp;
		end process;

end freq_div;