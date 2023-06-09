library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

        -- NOP                      0000 0000 0000 0000

        -- MOV REGDST, A             0000 1RRR ???? ????
        -- MOV REGDST, IMM           0001 0RRR IIII IIII
        
        -- MOV A, IMM                0001 1??? IIII IIII
        -- MOV A, REG                0010 0RRR ???? ????

        -- ADD A, REG                0010 1RRR ???? ????
        -- ADD A, IMM                0011 0??? IIII IIII

        -- SUBB A, REG               0011 1RRR ???? ????
        -- SUBB A, IMM               0100 0??? IIII IIII

        -- JUMP, IMM                 0100 1??? IIII IIII

        -- JC                       0101 0??? IIII IIII
        -- JNC                      0101 1??? IIII IIII
        -- JZ                       0110 0??? IIII IIII
        -- JNZ                      0110 1??? IIII IIII

        -- MOVX @REG, A             0111 0RRR ???? ????  ESCREVE NA RAM(@REG) <= A
        -- MOVX A, @REG             0111 1RRR ???? ????  LÊ DA RAM(@REG) => A 

entity rom is
    port (
        endereco: in unsigned(7 downto 0);
        dado: out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    
    type mem is array (0 to 255) of unsigned (15 downto 0);

    constant conteudo_rom : mem := (
        -- Preenche com 1 a 100 a memória
        0 =>  B"00011_000_01100100",    -- MOV A, 100
        1 =>  B"00001_001_00000000",    -- MOV REG1, A
        2 =>  B"01110_001_00000000",    -- MOVX @REG1, A
        3 =>  B"01000_000_00000001",    -- SUBB A, 1
        4 =>  B"01101_000_11111101",    -- JNZ -3
        
        -- Inicializa variáveis 
        5 =>  B"00010_001_00000010",    -- MOV REG1, 2
        6 =>  B"00010_010_00000010",    -- MOV REG2, 2
        
        -- Deleta os múltiplos
        7 =>  B"00100_001_00000000",    -- MOV A, REG1
        8 =>  B"00101_010_00000000",    -- ADD A, REG2 
        9 =>  B"00001_001_00000000",    -- MOV REG1, A
        10 => B"00011_000_00000000",    -- MOV A, 0
        11 => B"01110_001_00000000",    -- MOVX @REG1, A
        12 => B"00100_001_00000000",    -- MOV A, REG1 
        13 => B"01000_000_01100100",    -- SUBB A, 100
        14 => B"01010_000_11111001",    -- JC -7

        -- Pega o próximo múltiplo para remover (não pode ser um já removido)
        15 => B"00100_010_00000000",    -- MOV A, REG2
        16 => B"00110_000_00000001",    -- ADD A, 1
        17 => B"00001_010_00000000",    -- MOV R2, A
        18 => B"01111_010_00000000",    -- MOVX A, @REG2
        19 => B"00110_000_00000000",    -- ADD A, 0
        20 => B"01100_000_11111011",    -- JZ -5

        -- Verifica se já passou de ceil( sqrt(100) )
        21 => B"00001_001_00000000",    -- MOV REG1, A
        22 => B"01000_000_00001010",    -- SUBB A, 10
        23 => B"01010_000_11110000",    -- JC -16
        
    others => (others=>'0'));
    
    begin
        dado <= conteudo_rom(to_integer(endereco));
        
end architecture;

--  rm work-obj93.cf
--  ghdl -a reg_16bits.vhd && ghdl -e reg_16bits 
--  ghdl -a banco_regs.vhd && ghdl -e banco_regs 
--  ghdl -a pc.vhd && ghdl -e pc
--  ghdl -a state_machine.vhd && ghdl -e state_machine 
--  ghdl -a uc.vhd && ghdl -e uc 
--  ghdl -a ula.vhd && ghdl -e ula 
--  ghdl -a rom.vhd && ghdl -e rom 
--  ghdl -a ram.vhd && ghdl -e ram 
--  ghdl -a toplevel.vhd && ghdl -e toplevel 
--  ghdl -a toplevel_tb.vhd && ghdl -e toplevel_tb 
--  ghdl -r toplevel_tb --wave=toplevel_tb.ghw && gtkwave toplevel_tb.ghw

-- rm work-obj93.cf && ghdl -a reg_16bits.vhd && ghdl -e reg_16bits && ghdl -a banco_regs.vhd && ghdl -e banco_regs && ghdl -a pc.vhd && ghdl -e pc && ghdl -a state_machine.vhd && ghdl -e state_machine && ghdl -a uc.vhd && ghdl -e uc && ghdl -a ula.vhd && ghdl -e ula && ghdl -a rom.vhd && ghdl -e rom && ghdl -a ram.vhd && ghdl -e ram && ghdl -a toplevel.vhd && ghdl -e toplevel && ghdl -a toplevel_tb.vhd && ghdl -e toplevel_tb && ghdl -r toplevel_tb --wave=toplevel_tb.ghw && gtkwave toplevel_tb.ghw