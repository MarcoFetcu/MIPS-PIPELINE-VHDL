library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

entity InstructionExecute is
    Port ( NextInstruction : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           BranchAdress : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC;
           RegDst : in STD_LOGIC;
           rt : in STD_LOGIC_VECTOR (2 downto 0);
           rd : in STD_LOGIC_VECTOR (2 downto 0);
           rWA : out STD_LOGIC_VECTOR (2 downto 0));
           
end InstructionExecute;

architecture Behavioral of InstructionExecute is

signal sRD2 : STD_LOGIC_VECTOR (15 downto 0);
signal sExt_Imm : STD_LOGIC_VECTOR (15 downto 0);

signal ALUCtrl : STD_LOGIC_VECTOR (2 downto 0);
signal sWA : STD_LOGIC_VECTOR (2 downto 0);
signal sALURes : STD_LOGIC_VECTOR (15 downto 0);
signal sBA : STD_LOGIC_VECTOR (15 downto 0);
begin

process(ALUSrc)
begin
if ALUSrc='0' then 
sRD2<=RD2;
else
sRD2<=Ext_Imm;
end if;
end process;

process(RegDst)
begin
if RegDst='0' then
sWA<=rt;
else
sWA<=rd;
end if;
end process;



process(ALUOp,func)
begin

case ALUOp is
when "000" =>
    case func is
    when "000"=>ALUCtrl<="000"; --add
    when "001"=>ALUCtrl<="001"; --sub
    when "010"=>ALUCtrl<="010"; --sll
    when "011"=>ALUCtrl<="011"; --srl
    when "100"=>ALUCtrl<="100"; --and
    when "101"=>ALUCtrl<="101"; --or
    when "110"=>ALUCtrl<="110"; --xor
    when "111"=>ALUCtrl<="111"; --addu
    when others=>ALUCtrl<=(others=>'X');
    end case;
  when "001"=>ALUCtrl<="000"; --  addi
  when "010"=>ALUCtrl<="001"; --  lw
  when "011"=>ALUCtrl<="010"; --  sw 
  when "100"=>ALUCtrl<="011"; -- beq
  when "101"=>ALUCtrl<="100"; -- bne
  when "110"=>ALUCtrl<="101"; -- bg
  when "111"=>ALUCtrl<="110"; -- jump
  when others=> ALUCtrl<=(others=>'X');
  end case;

end process;



process(ALUOp,ALUCtrl)
begin

if ALUOp="000" then
    if ALUCtrl="000" then
         sALURes<=RD1+sRD2;
    elsif ALUCtrl="001" then
         sALURes<=RD1-sRD2;
    elsif ALUCtrl="010" then
        if sa='1' then
         sALURes(15 downto 1)<=RD1(14 downto 0);
         sALURes(0)<='0';
         end if;
    elsif ALUCtrl="011" then
        if sa='1' then
         sALURes(14 downto 0)<=RD1(15 downto 1);
         sALURes(15)<='0';
         end if;   
    elsif ALUCtrl="100" then     
         sALURes<=RD1 and sRD2;  
    elsif ALUCtrl="101" then     
         sALURes<=RD1 or sRD2; 
     elsif ALUCtrl="110" then     
         sALURes<=RD1 xor sRD2; 
     elsif ALUCtrl="111" then
         sALURes<=RD1+sRD2; 
     end if;
else
     if ALUCtrl="000" then
         sALURes<=RD1+sRD2;--addi
    elsif ALUCtrl="001" then
         sALURes<=RD1+sRD2;--lw
    elsif ALUCtrl="010" then
        sALURes<=RD1+sRD2;--sw
    elsif ALUCtrl="011" then
        if RD1=sRD2 then
        sALURes<=x"0000";
           --sBA<=NextInstruction+sRD2;
           else
           sALURes<=x"0001";
           
        end if;
        --beq
    elsif ALUCtrl="100" then     
         if RD1/=sRD2 then
        sALURes<=x"0000";
           --sBA<=NextInstruction+sRD2;
           else
           sALURes<=x"0001";
        end if; 
        --bne
    elsif ALUCtrl="101" then     
           if RD1>sRD2 then
         sALURes<=x"0000";
           --sBA<=NextInstruction+sRD2;
           else
           sALURes<=x"0001";
        end if;  
        --bg
    
   
              
     end if;
end if;
end process;


process(sALURes)
begin
if sALURes=x"0000" then 
Zero<='1';
else
Zero<='0';
end if;
end process;

ALURes<=sALURes;
rWA<=sWA;
BranchAdress<=NextInstruction+Ext_Imm;


end Behavioral;
