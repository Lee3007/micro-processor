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
    signal result_signal : unsigned(16 downto 0) := B"0_0000_0000_0000_0000";

    begin

        result_signal <= ("0" & x) + ("0" & y) when sel_op = "00" else
                  ("0" & x) - ("0" & y) when sel_op = "01" else
                  "0" & y when sel_op = "10" else
                  "0" & X"0001" when sel_op = "11" and x < y else
                  "0" & X"0000";

        zero <= '1' when result_signal(15 downto 0) = X"0000" else '0';
        result <= result_signal(15 downto 0);
        carry <= not result_signal(16) when sel_op = "01"
        else result_signal(16);

end architecture;

