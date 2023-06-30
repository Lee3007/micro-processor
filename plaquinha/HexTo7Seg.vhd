Library ieee;
use ieee.std_logic_1164.all;

entity HexTo7Seg is
    port(
        H: in std_logic_vector(0 to 3);
        Q: out std_logic_vector(0 to 6)
    );
end HexTo7Seg;
    
architecture Hex_to_7seg_arch of HexTo7Seg is
    begin
        Q(6) <= (NOT H(0) AND NOT H(1) AND NOT H(2) AND H(3)) OR (NOT H(0) AND H(1) AND NOT H(2) AND NOT H(3)) OR (H(0) AND H(1) AND NOT H(2) AND H(3)) OR (H(0) AND NOT H(1) AND H(2) AND H(3));
        Q(5) <= (H(0) AND H(2) AND H(3)) OR (H(1) AND H(2) AND NOT H(3)) OR (H(0) AND H(1) AND NOT H(3)) OR (NOT H(0) AND H(1) AND NOT H(2) AND H(3));
        Q(4) <= (H(0) AND H(1) AND H(2)) OR (H(0) AND H(1) AND NOT H(3)) OR (NOT H(0) AND NOT H(1) AND H(2) AND NOT H(3));
        Q(3) <= (H(1) AND H(2) AND H(3)) OR (NOT H(0) AND H(1) AND NOT H(2) AND NOT H(3)) OR (H(0) AND H(1) AND H(2) AND H(3)) OR (NOT H(0) AND NOT H(1) AND NOT H(2) AND H(3)) OR (H(0) AND NOT H(1) AND H(2) AND NOT H(3));
        Q(2) <= (NOT H(0) AND H(3)) OR (NOT H(1) AND NOT H(2) AND H(3)) OR (NOT H(0) AND H(1) AND NOT H(2));
        Q(1) <= (H(0) AND H(1) AND NOT H(2) AND H(3)) OR (NOT H(0) AND NOT H(1) AND H(2)) OR (NOT H(0) AND NOT H(1) AND H(3)) OR (NOT H(0) AND H(2) AND H(3));
        Q(0) <= (NOT H(0) AND NOT H(1) AND NOT H(2)) OR (NOT H(0) AND H(1) AND H(2) AND H(3)) OR (H(0) AND H(1) AND NOT H(2) AND NOT H(3));

end Hex_to_7seg_arch;