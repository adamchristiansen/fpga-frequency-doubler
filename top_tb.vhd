library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;

entity top_tb is
end;

architecture behavioral of top_tb is

signal clk: std_logic := '0';
signal double_en: std_logic := '0';
signal enable_n: std_logic := '1';
signal led: std_logic_vector(3 downto 0) := (others => '0');
signal x: std_logic := '0';
signal y: std_logic := 'X';

begin

clk <= not clk after 5ns;
double_en <= '1' after 2000ns;
enable_n <= '0' after 500ns;
x <= not x after 205ns;

dut: entity work.top
port map (
  clk => clk,
  double_en => double_en,
  led => led,
  x => x,
  y => y
);

end;
