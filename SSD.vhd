library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end SSD;

architecture Behavioral of SSD is
signal digit : std_logic_vector(3 downto 0);
signal cnt: std_logic_vector(15 downto 0):= (others=> '0');
signal sel: std_logic_vector(1 downto 0);

begin


 process(clk)
begin
    if rising_edge(clk) then
        cnt <= cnt+1;
    end if;

end process;

sel<=cnt(15 downto 14);

process(sel,digits)
begin
    case sel is
        when "00"=> digit<= digits(3 downto 0);
        when "01"=> digit<= digits(7 downto 4);
        when "10"=> digit<= digits(11 downto 8);
        when "11"=> digit<= digits(15 downto 12);
        when others=> digit<= (others=> 'X');
    end case;
end process;

process(sel)
begin
    case sel is
        when "00"=> an<="1110";
        when "01"=> an<="1101";
        when "10"=> an<="1011";
        when "11"=> an<="0111";
        when others=> an<= (others=> 'X');
    end case;
end process;


process(digit)
 begin
 
    case digit is
        when "0000" =>cat<="1000000";
        when "0001" =>cat<="1111001";
        when "0010" =>cat<="0100100";
        when "0011" =>cat<="0110000";
        when "0100" =>cat<="0011001";
        when "0101" =>cat<="0010010";
        when "0110" =>cat<="0000010";
        when "0111" =>cat<="1111000";
        when "1000" =>cat<="0000000";
        when "1001" =>cat<="0010000";
        when "1010" =>cat<="0001000";
        when "1011" =>cat<="0000011";
        when "1100" =>cat<="1000110";
        when "1101" =>cat<="0100001";
        when "1110" =>cat<="0000110";
        when others =>cat<="0001110";
    end case;
end process;


end Behavioral;
