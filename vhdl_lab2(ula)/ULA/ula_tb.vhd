library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
    port (
        x, y        : in unsigned(15 downto 0);
        sel_op      : in unsigned(1 downto 0) := "00";
        result      : out unsigned(15 downto 0);
        zero, carry : out std_logic
    );
    end component;

    signal x, y, result : unsigned(15 downto 0) := "0000000000000000";
    signal sel_op : unsigned(1 downto 0) := "00";
    signal zero, carry : std_logic := '0';

    begin 
        uut: ula port map(
            x => x,
            y => y,
            sel_op => sel_op,
            result => result,
            zero => zero,
            carry => carry
        );

        process begin
            --Teste da soma
            sel_op <= "00";
            x <= X"0001";
            y <= X"0003";
            wait for 50 ns;
            sel_op <= "00";
            x <= X"FFFF";
            y <= X"0003";
            wait for 50 ns;
            sel_op <= "00";
            x <= X"00FF";
            y <= X"FFFF";
            wait for 50 ns;
            sel_op <= "00";
            x <= X"FFFF";
            y <= X"FFFF";
            wait for 50 ns;
            sel_op <= "00";
            x <= X"0000";
            y <= X"0000";
            wait for 50 ns;
            
            --Teste da subtração
            sel_op <= "01";
            x <= X"0001";
            y <= X"0003";
            wait for 50 ns;
            sel_op <= "01";
            x <= X"FFFF";
            y <= X"0003";
            wait for 50 ns;
            sel_op <= "01";
            x <= X"00FF";
            y <= X"FFFF";
            wait for 50 ns;
            sel_op <= "01";
            x <= X"FFFF";
            y <= X"FFFF";
            wait for 50 ns;
            sel_op <= "01";
            x <= X"0000";
            y <= X"0000";
            wait for 50 ns;
            
            --Teste da multiplicação
            sel_op <= "10";
            x <= X"0002";
            y <= X"0003";
            wait for 50 ns;
            sel_op <= "10";
            x <= X"FF00";
            y <= X"0003";
            wait for 50 ns;
            sel_op <= "10";
            x <= X"0003";
            y <= X"FF00";
            wait for 50 ns;
            sel_op <= "10";
            x <= X"FF00";
            y <= X"FF00";
            wait for 50 ns;
            sel_op <= "10";
            x <= X"0000";
            y <= X"0000";
            wait for 50 ns;

            --Teste do less_than
            sel_op <= "11";
            x <= X"0022";
            y <= X"0003";
            wait for 50 ns;
            sel_op <= "11";
            x <= X"0003";
            y <= X"0022";
            wait for 50 ns;
            sel_op <= "11";
            x <= X"0011";
            y <= X"0011";
            wait for 50 ns;
            sel_op <= "11";
            x <= X"0000";
            y <= X"0000";
            wait for 50 ns;

            wait;
        end process;

end architecture;