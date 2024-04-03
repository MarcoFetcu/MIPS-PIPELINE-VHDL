library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;


entity ControlUnit is
    Port ( Instr : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is

begin

process(Instr)
begin
    if Instr="000" then
     --R type, reg 
           RegDst<='1';
           ExtOp<='0';
           ALUSrc<='0';
           Branch<='0';
           Jump<='0';
           ALUOp<="000";
           MemWrite<='0';
           MemtoReg<='0';
           RegWrite<='1';
     elsif Instr="001" then
     --I type,ADDI, + 
           RegDst<='0';
           ExtOp<='1';
           ALUSrc<='1';
           Branch<='0';
           Jump<='0';
           ALUOp<="001";
           MemWrite<='0';
           MemtoReg<='0';
           RegWrite<='1';
     elsif Instr="010" then
     --I type,LW, + 
           RegDst<='0';
           ExtOp<='1';
           ALUSrc<='1';
           Branch<='0';
           Jump<='0';
           ALUOp<="010";
           MemWrite<='0';
           MemtoReg<='1';
           RegWrite<='1';
     elsif Instr="011" then
     --I type,SW, + 
           RegDst<='0';
           ExtOp<='1';
           ALUSrc<='1';
           Branch<='0';
           Jump<='0';
           ALUOp<="011";
           MemWrite<='1';
           MemtoReg<='0';
           RegWrite<='0';
     elsif Instr="100" then
     --I type,BEQ, - 
           RegDst<='0';
           ExtOp<='1';
           ALUSrc<='0';
           Branch<='1';
           Jump<='0';
           ALUOp<="100";
           MemWrite<='0';
           MemtoReg<='0';
           RegWrite<='0';
     elsif Instr="101" then
     --I type,BNE, -
           RegDst<='0';
           ExtOp<='1';
           ALUSrc<='0';
           Branch<='1';
           Jump<='0';
           ALUOp<="101";
           MemWrite<='0';
           MemtoReg<='0';
           RegWrite<='0';
     elsif Instr="110" then
      --I type,BG, -
           RegDst<='0';
           ExtOp<='1';
           ALUSrc<='0';
           Branch<='1';
           Jump<='0';
           ALUOp<="110";
           MemWrite<='0';
           MemtoReg<='0';
           RegWrite<='0';
     elsif Instr="111" then
     --J type
           RegDst<='0';
           ExtOp<='0';
           ALUSrc<='0';
           Branch<='0';
           Jump<='1';
           ALUOp<="111";
           MemWrite<='0';
           MemtoReg<='0';
           RegWrite<='0';
      end if;
end process;


end Behavioral;
