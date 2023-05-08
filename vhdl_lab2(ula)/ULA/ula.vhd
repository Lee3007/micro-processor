library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Operações
--  Soma
--  Subtração
--  Multiplicação
--  Menor que
--  Igual a
--  Carry

entity ula is
    port (
        x, y        : in unsigned(15 downto 0) := "0000000000000000";
        sel_op      : in unsigned(1 downto 0) := "00";
        result      : out unsigned(15 downto 0) := "0000000000000000";
        zero, carry : out std_logic := '0'
    );
end entity;

architecture a_ula of ula is
    signal result_signal : unsigned(31 downto 0) := X"00000000";

    begin

        result_signal <= (X"0000" & x) + (X"0000" & y) when sel_op = "00" else
                  (X"0000" & x) - (X"0000" & y) when sel_op = "01" else
                  x*y when sel_op = "10" else
                  X"00000001" when sel_op = "11" and x < y else
                  X"00000000";

        zero <= '1' when result_signal(15 downto 0) = X"0000" else '0';
        result <= result_signal(15 downto 0);
        carry <= '0' when result_signal(31 downto 16) = X"0000" else '1';

end architecture;

