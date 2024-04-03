library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
USE ieee.std_logic_unsigned.all;


entity REG is
    Port ( ra1 : in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           wen : in STD_LOGIC;         
           en : in STD_LOGIC;         
           clk : in STD_LOGIC);
end REG;

architecture Behavioral of REG is

type memorie is array (0 to 7) of std_logic_vector(15 downto 0);

signal mem : memorie := (
x"0000",
x"0000",
x"0000",
x"0000",
x"0000",
x"0000",
x"0000",
others => x"0000");


begin

process(clk)
begin
if falling_edge(clk) then
if en = '1' then
if wen = '1' then
mem(conv_integer(wa)) <= wd;
end if;
end if;
end if;
end process;
rd1 <= mem(conv_integer(ra1));
rd2 <= mem(conv_integer(ra2));


end Behavioral;
