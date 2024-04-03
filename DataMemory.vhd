library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

entity DataMemory is
    Port ( clk: in std_logic;
           en: in std_logic;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end DataMemory;

architecture Behavioral of DataMemory is

type memorie is array (0 to 31) of STD_LOGIC_VECTOR (15 downto 0);
 
signal ram: memorie :=(
x"0002",
x"0002",
x"0001",
x"0002",
x"0002",
x"0002",--

x"0002",
x"0003",
x"0001",
x"0006",
x"000B",
x"0004",--

x"0000",
x"0000",
others => x"0000");
 
 
 
begin
 
process(clk)
begin
 
    if rising_edge(clk) then
         if MemWrite = '1' and en='1' then
           ram(conv_integer(ALURes(5 downto 0)))<=RD2; 
         end if;
    end if;
end process;
 
MemData<=ram(conv_integer(ALURes(5 downto 0)));
ALUResOut<=ALURes;


end Behavioral;
