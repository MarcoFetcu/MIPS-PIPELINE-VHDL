library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;


entity InstructionFetch is
 Port ( 
           Clk : in STD_LOGIC;
           BranchAdress : in STD_LOGIC_VECTOR (15 downto 0);
           JumpAdress : in STD_LOGIC_VECTOR (15 downto 0);
           Jump : in STD_LOGIC;
           PcSrc : in STD_LOGIC;
           Enable : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Instruction : out STD_LOGIC_VECTOR (15 downto 0);
           NextInstruction : out STD_LOGIC_VECTOR (15 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is

type Memorie is array (0 to 255) of std_logic_vector(15 downto 0);
signal ROM: Memorie := (

B"000_000_000_001_0_000", --X"0010" --ADD $1,$0,$0 --1
B"001_000_010_0000110", --X"2106" --ADDI $2,$0,6  --2
B"000_000_000_011_0_000", --X"0030" --ADD $3,$0,$0 --3
B"000_000_000_100_0_000", --X"0040" --ADD $4,$0,$0  --4
B"100_001_010_0001011", --X"850B" --BEQ $1,$2,11  --5 
B"000_000_000_000_0_000", --NoOp --6
B"000_000_000_000_0_000", --NoOp --7
B"000_000_000_000_0_000", --NoOp --8
B"010_011_101_0000000", --X"4E80" --LW $5,0($3)  --9
B"000_000_000_000_0_000", --NoOp --10
B"000_000_000_000_0_000", --NoOp --11
B"000_100_101_100_0_000", --X"12C0" --ADD $4,$4,$5  --12
B"001_011_011_0000001", --X"2D81" --ADDI $3,$3,1  --13
B"001_001_001_0000001", --X"2481" --ADDI $1,$1,1  --14
B"111_0000000000100",  --X"E004" -- J 4  --15
B"000_000_000_000_0_000", --NoOp --16
B"011_000_100_0001100", --X"620C" -- SW $4,12($0)  --17

B"000_000_000_001_0_000", --X"0010" --ADD $1,$0,$0 --18
B"001_000_010_0000110", --X"2106" --ADDI $2,$0,6  --19
B"001_000_011_0000110", --X"2186" --ADDI $3,$0,6  --20
B"000_000_000_110_0_000", --X"0060" --ADD $6,$0,$0  --21
B"100_001_010_0001111", --X"850F" --BEQ $1,$2,15  --22 
B"000_000_000_000_0_000", --NoOp --23
B"000_000_000_000_0_000", --NoOp --24
B"000_000_000_000_0_000", --NoOp --25
B"010_011_101_0000000", --X"4E80" --LW $5,0($3)  --26
B"000_000_000_000_0_000", --NoOp --27
B"000_000_000_000_0_000", --NoOp --28
B"110_110_101_0000100", --X"DA84" --BG $6,$5,4  --29 
B"000_000_000_000_0_000", --NoOp --30
B"000_000_000_000_0_000", --NoOp --31
B"000_000_000_000_0_000", --NoOp --32
B"000_101_000_110_0_000", --X"1460" --ADD $6,$5,$0 --33
B"001_011_011_0000001", --X"2D81" --ADDI $3,$3,1  --34
B"001_001_001_0000001", --X"2481" --ADDI $1,$1,1  --35
B"111_0000000010101",  --X"E015" -- J 21  --36
B"000_000_000_000_0_000", --NoOp --37
B"011_000_110_0001101", --X"630D" -- SW $6,13($0)  --38

B"010_000_010_0001100", --X"410C" --LW $2,Adr(12)  --39
B"010_000_011_0001101", --X"418d" --LW $3,Adr(13)  --40
B"000_000_000_000_0_000", --NoOp --41
B"000_000_000_000_0_000", --NoOp --42
B"000_010_011_000_0_001", --X"0981" --SUB $0,$2,$3 --43
B"000_000_000_000_0_000", --NoOp --44
B"000_000_000_000_0_000", --NoOp --45




others => x"0000");

signal PC: std_logic_vector(15 downto 0) := (others=> '0');

begin

process(clk,Reset,Enable,PcSrc,Jump)

begin

if rising_edge(clk) then 

 if Reset='1' then
    PC<=x"0000";
 else
     if Enable='1' then
             if Jump='1' then 
                PC<=JumpAdress;
             else
                    if PcSrc='1' then 
                        PC<=BranchAdress;
                    else
                         PC<=PC+1;
                    end if;
             end if;
        end if;
    end if;
end if;
end process;

Instruction<=ROM(conv_integer(PC));
NextInstruction<=PC+1;

end Behavioral;
