library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_16bits is
    port(
        reg_in: in unsigned(15 downto 0);
        rst: in std_logic;
        clk: in std_logic;
        write_enable: in std_logic;
        reg_out: out unsigned (15 downto 0)
    );
end;

architecture arch_reg_16bits of reg_16bits is
    signal data: unsigned(15 downto 0);
    
    begin
        process(clk, rst)
        begin
            
            if(rst = '1') then
                data <= X"0000";
            else
                if(write_enable = '1' and rising_edge(clk)) then
                    data <= reg_in;
                end if;
            end if;

        end process;
            
        reg_out <= data;
    
end architecture;