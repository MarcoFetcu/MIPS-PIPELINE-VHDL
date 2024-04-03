library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
USE ieee.std_logic_unsigned.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
   Port (
   clk : in  STD_LOGIC;
   inn: in STD_LOGIC;
   en: out  STD_LOGIC);    
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component InstructionFetch is
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
end component;

component InstructionDecode is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (12 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
          --RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           rdd : in STD_LOGIC_VECTOR (2 downto 0);
           rt : out STD_LOGIC_VECTOR (2 downto 0);
           rd : out STD_LOGIC_VECTOR (2 downto 0));
end component;


component ControlUnit is
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
end component;

component InstructionExecute is
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
end component;

component DataMemory is
    Port ( clk: in std_logic;
           en: in std_logic;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;

signal en: STD_LOGIC;
signal rst: STD_LOGIC;
signal RegWrite: STD_LOGIC;
signal RegDst: STD_LOGIC;
signal ExtOp: STD_LOGIC;
signal sa: STD_LOGIC;
signal Jump: STD_LOGIC;
signal ALUSrc: STD_LOGIC;
signal Branch: STD_LOGIC;
signal MemWrite: STD_LOGIC;
signal MemtoReg: STD_LOGIC;
signal Zero: STD_LOGIC;
signal PCSrc: STD_LOGIC;


signal do: STD_LOGIC_VECTOR (15 downto 0);
signal Instr: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal NextInstr: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal RD1: STD_LOGIC_VECTOR (15 downto 0);
signal RD2: STD_LOGIC_VECTOR (15 downto 0);
signal Ext_Imm: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal Ext_func: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal Ext_sa: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal BranchAdress: STD_LOGIC_VECTOR (15 downto 0);
signal BranchAdress2: STD_LOGIC_VECTOR (15 downto 0);
signal JumpAdress: STD_LOGIC_VECTOR (15 downto 0);
signal ALURes: STD_LOGIC_VECTOR (15 downto 0);
signal ALUResOut: STD_LOGIC_VECTOR (15 downto 0);
signal MemData: STD_LOGIC_VECTOR (15 downto 0);
signal WD: STD_LOGIC_VECTOR (15 downto 0);
signal func: STD_LOGIC_VECTOR (2 downto 0);
signal ALUOp: STD_LOGIC_VECTOR (2 downto 0);
--IF/ID
signal IF_ID_Instr: STD_LOGIC_VECTOR (15 downto 0);
signal IF_ID_NextInstr: STD_LOGIC_VECTOR (15 downto 0);
--ID/EX
signal ID_EX_NextInstr: STD_LOGIC_VECTOR (15 downto 0);
signal ID_EX_RD1: STD_LOGIC_VECTOR (15 downto 0);
signal ID_EX_RD2: STD_LOGIC_VECTOR (15 downto 0);
signal ID_EX_Ext_Imm: STD_LOGIC_VECTOR (15 downto 0);

signal ID_EX_func: STD_LOGIC_VECTOR (2 downto 0);
signal ID_EX_rt: STD_LOGIC_VECTOR (2 downto 0);
signal ID_EX_rd: STD_LOGIC_VECTOR (2 downto 0);
signal ID_EX_ALUOp: STD_LOGIC_VECTOR (2 downto 0);


signal rt: STD_LOGIC_VECTOR (2 downto 0);
signal rd: STD_LOGIC_VECTOR (2 downto 0);
signal rWA: STD_LOGIC_VECTOR (2 downto 0);

signal ID_EX_sa: STD_LOGIC;
signal ID_EX_RegWrite: STD_LOGIC;
signal ID_EX_RegDst: STD_LOGIC;
signal ID_EX_ALUSrc: STD_LOGIC;
signal ID_EX_Branch: STD_LOGIC;
signal ID_EX_MemWrite: STD_LOGIC;
signal ID_EX_MemtoReg: STD_LOGIC;
--EX/MEM
signal EX_MEM_BranchAdress: STD_LOGIC_VECTOR (15 downto 0);
signal EX_MEM_RD2: STD_LOGIC_VECTOR (15 downto 0);
signal EX_MEM_ALURes: STD_LOGIC_VECTOR (15 downto 0);

signal EX_MEM_RD: STD_LOGIC_VECTOR (2 downto 0);

signal EX_MEM_zero: STD_LOGIC;
signal EX_MEM_RegWrite: STD_LOGIC;
signal EX_MEM_Branch: STD_LOGIC;
signal EX_MEM_MemWrite: STD_LOGIC;
signal EX_MEM_MemtoReg: STD_LOGIC;
--MEM/WB
signal MEM_WB_MemData: STD_LOGIC_VECTOR (15 downto 0);
signal MEM_WB_ALURes: STD_LOGIC_VECTOR (15 downto 0);

signal MEM_WB_RD: STD_LOGIC_VECTOR (2 downto 0);

signal MEM_WB_RegWrite: STD_LOGIC;
signal MEM_WB_MemtoReg: STD_LOGIC;



begin
et1: MPG port map(clk,btn(0),en);
et2: MPG port map(clk,btn(1),rst);
    
IFetch: InstructionFetch port map(clk,EX_MEM_BranchAdress,JumpAdress,Jump,PCSrc,en,rst,Instr,NextInstr);
--scot regdst si il mut in ex
IDecode: InstructionDecode port map(clk,en,IF_ID_Instr(12 downto 0),WD,MEM_WB_RegWrite,ExtOp,RD1,RD2,Ext_Imm,func,sa,MEM_WB_RD,rt,rd) ;
UControl: ControlUnit port map(IF_ID_Instr(15 downto 13),RegDst,ExtOp,ALUSrc,Branch,Jump,ALUOp,MemWrite,MemtoReg,RegWrite); 

IExecute: InstructionExecute port map(ID_EX_NextInstr,ID_EX_RD1,ID_EX_RD2,ID_EX_Ext_Imm,ID_EX_func,ID_EX_sa,ID_EX_ALUSrc,ID_EX_ALUOp,BranchAdress,ALURes,Zero,ID_EX_RegDst,ID_EX_rt,ID_EX_rd,rWA);         
MData: DataMemory port map(clk,en,EX_MEM_ALURes,EX_MEM_RD2,EX_MEM_MemWrite,MemData,ALUResOut);

--Suma: DataMemory port map(clk,'0',"0000000000001100",x"0000",'0',sum,nimic);
--Maxim: DataMemory port map(clk,'0',"0000000000001101",x"0000",'0',max,nimic);

--sum<=RD1+RD2;
--Ext_func(2 downto 0)<=func;
--Ext_sa(0)<=sa;


--WriteBack
with MEM_WB_MemtoReg select
WD<= MEM_WB_MemData when '1',
     MEM_WB_ALURes when '0',
     (others =>'X') when others;
     
--Branch control     
PCSrc<= EX_MEM_Zero and  EX_MEM_Branch;

--Jump adress
JumpAdress<=IF_ID_NextInstr(15 downto 13) & IF_ID_Instr(12 downto 0);

process(clk)
begin
if rising_edge(clk)then
if en='1' then
--IF_ID
IF_ID_NextInstr<=NextInstr;
IF_ID_Instr<= Instr;
--ID_EX
ID_EX_NextInstr <= IF_ID_NextInstr;
ID_EX_RD1 <= RD1;
ID_EX_RD2<= RD2;
ID_EX_Ext_Imm<= Ext_Imm;
ID_EX_sa<= sa;
ID_EX_func <= func;
ID_EX_rt <= rt;
ID_EX_rd <= rd;
ID_EX_MemtoReg <= MemtoReg;
ID_EX_RegWrite<= RegWrite;
ID_EX_MemWrite<= MemWrite;
ID_EX_Branch <= Branch;
ID_EX_ALUSrc <= ALUSrc;
ID_EX_ALUOp <= ALUOp;
ID_EX_RegDst<= RegDst;
--EX_MEM
EX_MEM_BranchAdress <= BranchAdress;
EX_MEM_Zero <= Zero;
EX_MEM_ALURes<= ALURes;
EX_MEM_RD2<= ID_EX_RD2;
EX_MEM_rd<= rWA;
EX_MEM_MemtoReg <= ID_EX_MemtoReg;
EX_MEM_RegWrite <= ID_EX_RegWrite;
EX_MEM_MemWrite<= ID_EX_MemWrite;
EX_MEM_Branch<= ID_EX_Branch;
--MEM_WB
MEM_WB_MemData <= MemData;
MEM_WB_ALURes <= ALUResOut;
MEM_WB_rd <= EX_MEM_rd;
MEM_WB_MemtoReg<= EX_MEM_MemtoReg;
MEM_WB_RegWrite<= EX_MEM_RegWrite;
end if;
end if;
end process;



with sw(7 downto 5) select
    do<=    Instr when "000",
            NextInstr when "001",
            ID_EX_RD1 when "010",
            ID_EX_RD2 when "011",
            ID_EX_Ext_Imm when "100",
            ALURes when "101",
            MemData when "110",
            WD when "111",
            (others=>'X') when others;
            
            
et4: SSD port map(clk,do,an,cat);


led(10 downto 0)<=ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;


end Behavioral;

