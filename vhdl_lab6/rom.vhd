library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

        -- NOP                      0000 0000 0000 0000

        -- MOV REGDST A             0000 1RRR ???? ????
        -- MOV REGDST IMM           0001 0RRR IIII IIII
        
        -- MOV A IMM                0001 1??? IIII IIII
        -- MOV A REG                0010 0RRR ???? ????

        -- ADD A REG                0010 1RRR ???? ????
        -- ADD A IMM                0011 0??? IIII IIII

        -- SUBB A REG               0011 1RRR ???? ????
        -- SUBB A IMM               0100 0??? IIII IIII

        -- JUMP IMM                 0100 1??? IIII IIII

        -- JC                       0101 0??? IIII IIII
        -- JNC                      0101 1??? IIII IIII
        -- JZ                       0110 0??? IIII IIII
        -- JNZ                      0110 1??? IIII IIII

entity rom is
    port (
        endereco: in unsigned(7 downto 0);
        dado: out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    
    type mem is array (0 to 127) of unsigned (15 downto 0);

    constant conteudo_rom : mem := (
        0 => B"00010_011_00000101", -- mov r3, 5
        1 => B"00010_100_00001000", -- mov r4, 8
        2 => B"00011_000_00000000", -- move a, 0
        3 => B"00101_011_00000000", -- add a, r3
        4 => B"00101_100_00000000", -- add a, r4
        5 => B"00001_101_00000000", -- mov r5, a
        6 => B"01000_000_00000001", -- sub a, 1
        7 => B"00001_101_00000000", -- mov r5, a
        8 => B"01001_000_00010100", -- ajmp 20
        9 =>  X"0000",
        10 => X"0000",
        11 => X"0000",
        12 => X"0000",
        13 => X"0000",
        14 => X"0000",
        15 => X"0000",
        16 => X"0000",
        17 => X"0000",
        18 => X"0000",
        19 => X"0000",
        20 => B"00100_101_00000000", -- mov a, r5 
        21 => B"00001_011_00000000", -- mov r3, a
        22 => B"01001_000_00000010", -- ajmp 2
        23 => X"0000",
        24 => X"0000",
        25 => X"0000",
        
    others => (others=>'0'));
    
    begin
        dado <= conteudo_rom(to_integer(endereco));
        
end architecture;

--  ghdl -a reg_16bits.vhd && ghdl -e reg_16bits 
--  ghdl -a banco_regs.vhd && ghdl -e banco_regs 
--  ghdl -a pc.vhd && ghdl -e pc
--  ghdl -a state_machine.vhd && ghdl -e state_machine 
--  ghdl -a uc.vhd && ghdl -e uc 
--  ghdl -a ula.vhd && ghdl -e ula 
--  ghdl -a rom.vhd && ghdl -e rom 
--  ghdl -a toplevel.vhd && ghdl -e toplevel 
--  ghdl -a toplevel_tb.vhd && ghdl -e toplevel_tb 
--  ghdl -r toplevel_tb --wave=toplevel_tb.ghw && gtkwave toplevel_tb.ghw

-- ghdl -a reg_16bits.vhd && ghdl -e reg_16bits && ghdl -a banco_regs.vhd && ghdl -e banco_regs && ghdl -a pc.vhd && ghdl -e pc && ghdl -a state_machine.vhd && ghdl -e state_machine && ghdl -a uc.vhd && ghdl -e uc && ghdl -a ula.vhd && ghdl -e ula && ghdl -a rom.vhd && ghdl -e rom && ghdl -a toplevel.vhd && ghdl -e toplevel  && ghdl -a toplevel_tb.vhd && ghdl -e toplevel_tb  && ghdl -r toplevel_tb --wave=toplevel_tb.ghw && gtkwave toplevel_tb.ghw