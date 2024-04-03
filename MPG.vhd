library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
USE ieee.std_logic_unsigned.all;



entity MPG is
   Port (
   clk : in  STD_LOGIC;
   inn: in STD_LOGIC;
   en: out  STD_LOGIC);    
end entity;

architecture Behavioral of MPG is
signal cnt : std_logic_vector(31 downto 0) :=x"00000000";
signal n1 : std_logic;
signal n2 : std_logic;
signal n3 : std_logic;

begin

process(clk)

begin

if rising_edge(clk) then
 cnt <= cnt + 1; 
 end if;
 
end process;


process (clk)
begin 
if rising_edge(clk) then
 if cnt(15 downto 0) = "1111111111111111" then 
 n1 <= inn;
 end if;
  end if;
  end process;
  
  process (clk)
  begin
  if rising_edge(clk) then
   n2 <=n1;
   n3 <= n2;
   end if;
   end process;
   
   en <= n2 AND (not n3);


end Behavioral;