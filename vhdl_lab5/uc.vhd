library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port (
        clk: in std_logic;
        rst: in std_logic;
        pc_out: in unsigned(7 downto 0);
        instruction_in: in unsigned(15 downto 0);
        pc_wr_en: out std_logic;
        inst_reg_wr_en: out std_logic;
        banco_regs_wr_en: out std_logic;
        pc_override: out std_logic;
        pc_in_n: out unsigned(7 downto 0); 
        pc_in_j: out unsigned(7 downto 0);
        sel_out_a: out unsigned(2 downto 0);
        sel_out_b: out unsigned(2 downto 0);
        sel_write: out unsigned(2 downto 0);
        imm_in: out unsigned(7 downto 0);
        reg_or_imm: out std_logic
        sel_op: out unsigned(1 downto 0);
    );
end entity;

architecture a_uc of uc is
    
    component state_machine is
        port (
            clk, rst: in std_logic;
            state: out unsigned(1 downto 0)
        );
    end component;
    
    signal state_s: unsigned(1 downto 0);
    signal opcode_s: unsigned(4 downto 0);

    begin
        uut1: state_machine port map(
            clk => clk,
            rst => rst,
            state => state_s
        );

        opcode <= instruction_in(15 downto 11);

        case opcode is
        when "00000" =>     --NOP
            case state_s is
            when "01"       --DECODE
                inst_reg_wr_en <= '0';
                pc_wr_en <= '0';
                banco_regs_wr_en <= '0';
                pc_override <= '0';
                sel_out_a <= "000";
                sel_out_b <= "000";
                sel_write <= "000";
                imm_in <= X"00";
                reg_or_imm <= '0';
                sel_op <= "00";
            when "10"       --EXECUTE
                inst_reg_wr_en <= '0';
                pc_wr_en <= '0';
                banco_regs_wr_en <= '0';
                pc_override <= '0';
                sel_out_a <= "000";
                sel_out_b <= "000";
                sel_write <= "000";
                imm_in <= X"00";
                reg_or_imm <= '0';
                sel_op <= "00";
            when "00" =>    --FETCH
                inst_reg_wr_en <= '1';
                pc_wr_en <= '1';
                banco_regs_wr_en <= '0';
                pc_override <= '0';
                sel_out_a <= "000";
                sel_out_b <= "000";
                sel_write <= "000";
                imm_in <= X"00";
                reg_or_imm <= '0';
                sel_op <= "00";

        when "00001" =>     --MOV REG REG
            case state_s is
            when "01"       --DECODE
                inst_reg_wr_en <= '0';
                pc_wr_en <= '0';
                banco_regs_wr_en <= '0';
                pc_override <= '0';
                sel_out_a <= instruction_in(7 downto 5);
                sel_out_b <= "000";
                sel_write <= "000";
                imm_in <= X"00";
                reg_or_imm <= '0';
                sel_op <= "00"; --selecting addition
            when "10"       --EXECUTE
                inst_reg_wr_en <= '0';
                pc_wr_en <= '0';
                banco_regs_wr_en <= '1';
                pc_override <= '0';
                sel_out_a <= "000";
                sel_out_b <= "000";
                sel_write <= instruction_in(10 downto 8);   --sel reg dst
                imm_in <= X"00";
                reg_or_imm <= '1';  --adding with 0
                sel_op <= "00";
            when "00" =>    --FETCH
                inst_reg_wr_en <= '1';
                pc_wr_en <= '1';
                banco_regs_wr_en <= '0';
                pc_override <= '0';
                sel_out_a <= "000";
                sel_out_b <= "000";
                sel_write <= "000";
                imm_in <= X"00";
                reg_or_imm <= '0';
                sel_op <= "00";
                
        when "00010" =>     --MOV REG IMM
            case state_s is
            when "01"       --DECODE
                inst_reg_wr_en <= '0';
                pc_wr_en <= '0';
                banco_regs_wr_en <= '0';
                pc_override <= '0';
                sel_out_a <= "000";
                sel_out_b <= "000";
                sel_write <= "000";
                imm_in <= X"00";
                reg_or_imm <= '0';
                sel_op <= "00"; --selecting addition
            when "10"       --EXECUTE
                inst_reg_wr_en <= '0';
                pc_wr_en <= '0';
                banco_regs_wr_en <= '1';
                pc_override <= '0';
                sel_out_a <= "000";
                sel_out_b <= "000";
                sel_write <= instruction_in(10 downto 8);   --sel reg dst
                imm_in <= instruction_in(7 downto 0);
                reg_or_imm <= '1';  --adding with 0
                sel_op <= "00";
            when "00" =>    --FETCH
                inst_reg_wr_en <= '1';
                pc_wr_en <= '1';
                banco_regs_wr_en <= '0';
                pc_override <= '0';
                sel_out_a <= "000";
                sel_out_b <= "000";
                sel_write <= "000";
                imm_in <= X"00";
                reg_or_imm <= '0';
                sel_op <= "00";









        pc_in_n <= pc_out + 1;
        pc_in_j <= (instruction_in(7 downto 0)); --accessing only half od ROM

        -- NOP                      0000 0000 0000 0000

        -- MOV REGDST REG              0000 1RRR RRR? ????
        -- MOV REGDST IMM              0001 0RRR IIII IIII
        
        -- MOV A IMM                0001 1??? IIII IIII
        -- MOV A REG                0010 0RRR ???? ????

        -- ADD A REG                0010 1RRR ???? ????
        -- ADD A IMM                0011 0??? IIII IIII

        -- SUBB A REG               0011 1RRR ???? ????
        -- SUBB A IMM               0100 0??? IIII IIII

        -- JUMP IMM                 0100 1??? IIII IIII


end architecture;
