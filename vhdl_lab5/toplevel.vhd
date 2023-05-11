library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is
    port (
        clock: in std_logic;
        rst: in std_logic;
        state: out unsigned(1 downto 0);
        pc_out: out unsigned(7 downto 0);
        instruction: out unsigned(15 downto 0);
        reg_a: out unsigned(15 downto 0);
        reg_b: out unsigned(15 downto 0);
        result: out unsigned(15 downto 0);
        zero, carry: out std_logic
    );
end entity;

architecture a_toplevel of toplevel is

    component rom is
        port (
            endereco: in unsigned(7 downto 0);
            dado: out unsigned(15 downto 0)
        );
    end component;
    
    component reg_16bits is
        port(
            reg_in: in unsigned(15 downto 0);
            rst: in std_logic;
            clk: in std_logic;
            write_enable: in std_logic;
            reg_out: out unsigned (15 downto 0)
        );
    end component;
    
    component pc is
        port (
            override: in std_logic;
            pc_in_n: in unsigned(7 downto 0); 
            pc_in_j: in unsigned(7 downto 0); 
            clk: in std_logic;
            write_enable: in std_logic := '1';
            pc_out: out unsigned(7 downto 0)
        );
    end component;
    
    component uc is
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
            reg_or_imm: out std_logic;
            sel_op: out unsigned(1 downto 0)
        );
    end component;
    
    component banco_regs is
        port(
            out_sel_a: in unsigned(2 downto 0);
            out_sel_b: in unsigned(2 downto 0);
            write_sel: in unsigned(2 downto 0);
            data_in: in unsigned(15 downto 0);
            out_a: out unsigned(15 downto 0);
            out_b: out unsigned(15 downto 0);
            clk: in std_logic;
            rst: in std_logic;
            write_enable: in std_logic
        );
    end component;
    
    component ula is
        port (
            x, y        : in unsigned(15 downto 0);
            sel_op      : in unsigned(1 downto 0);
            result      : out unsigned(15 downto 0);
            zero, carry : out std_logic := '0'
        );
    end component;

    signal instruction_to_reg_s, instruction_to_uc_s, reg_out_a_s, reg_out_b_s, ula_result_s, ula_in_y_s: unsigned(15 downto 0);
    signal pc_in_n_s, pc_in_j_s, pc_out_s, imm_in_s: unsigned(7 downto 0);
    signal sel_out_a_s, sel_out_b_s, sel_write_s: unsigned(2 downto 0);
    signal sel_op_s: unsigned(1 downto 0);
    signal instr_reg_wr_en_s, pc_wr_en_s, banco_regs_wr_en_s, override_s, reg_or_imm_s: std_logic;

    begin

        ula_in_y_s <= reg_out_b_s when reg_or_imm_s = '0'
        else ( X"00" & imm_in_s);

        romuut: rom port map(
            endereco => pc_out_s,
            dado => instruction_to_reg_s
        );

        instruction_registeruut: reg_16bits port map(
            reg_in => instruction_to_reg_s,
            rst => rst,
            clk => clock,
            write_enable => instr_reg_wr_en_s,
            reg_out => instruction_to_uc_s
        );

        pcuut: pc port map(
            clk => clock,
            write_enable => pc_wr_en_s,
            override => override_s,
            pc_in_n => pc_in_n_s,
            pc_in_j => pc_in_j_s,
            pc_out => pc_out_s
        );

        ucuut: uc port map(
            clk => clock,
            rst => rst,
            pc_out => pc_out_s,
            instruction_in => instruction_to_uc_s,
            pc_wr_en => pc_wr_en_s,
            inst_reg_wr_en => instr_reg_wr_en_s,
            banco_regs_wr_en => banco_regs_wr_en_s,
            pc_override => override_s,
            pc_in_n => pc_in_j_s,
            pc_in_j => pc_in_j_s,
            sel_out_a => sel_out_a_s,
            sel_out_b => sel_out_b_s,
            sel_write => sel_write_s,
            imm_in => imm_in_s,
            reg_or_imm => reg_or_imm_s,
            sel_op => sel_op_s
        );

        ulauut: ula port map(
            x => reg_out_a_s,
            y => ula_in_y_s,
            result => ula_result_s,
            sel_op => sel_op_s,
            zero => zero,
            carry => carry
        );

        bancouut: banco_regs port map(
            out_sel_a => sel_out_a_s,
            out_sel_b => sel_out_b_s,
            write_sel => sel_write_s,
            data_in => ula_result_s,
            out_a => reg_out_a_s,
            out_b => reg_out_b_s,
            clk => clock,
            rst => rst,
            write_enable => banco_regs_wr_en_s
        );


end architecture;

