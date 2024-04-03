library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;


entity InstructionDecode is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (12 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           rdd : in STD_LOGIC_VECTOR (2 downto 0);
           rt : out STD_LOGIC_VECTOR (2 downto 0);
           rd : out STD_LOGIC_VECTOR (2 downto 0));
end InstructionDecode;

architecture Behavioral of InstructionDecode is

signal semn: std_logic;
signal sWA: std_logic_vector(2 downto 0);
signal sExt: std_logic_vector(15 downto 0):=x"0000";


component REG is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;
           en : in STD_LOGIC;
           clk : in STD_LOGIC);
           
end component;

begin



RF: REG port map(Instr(12 downto 10), Instr(9 downto 7),RD1,RD2,rdd,WD,RegWrite,en,clk);

process(ExtOp)
begin

if ExtOp='0' then
    sExt<="000000000"&Instr(6 downto 0);
else
    semn<=Instr(6);
    if semn='0' then
        sExt<="000000000"&Instr(6 downto 0);
    else
        sExt<="111111111"&Instr(6 downto 0);
    end if;
end if;
end process;


ExtImm<=sExt;
func<=Instr(2 downto 0);
sa<=Instr(3);
rt<=Instr(9 downto 7);
rd<=Instr(6 downto 4);

end Behavioral;
