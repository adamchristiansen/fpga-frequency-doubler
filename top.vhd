library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;

--- The top module of the design.
---
--- # Ports
---
--- * clk: 100 MHz clock.
--- * double_en: Enable frequency doubling.
--- * enable_n: Active low enable.
--- * led: The status LEDs.
--- * x: The input signal.
--- * y: The doubled output signal.
entity top is
port (
  clk: in std_logic;
  double_en: in std_logic;
  enable_n: in std_logic;
  led: out std_logic_vector(3 downto 0);
  x: in std_logic;
  y: out std_logic
);
end;

architecture behavioral of top is

-- Metastability Enhancement
signal x_m0: std_logic := '0';
signal x_m: std_logic := '0';

-- Edge Detection
signal x_prev: std_logic := '0';
signal rise: std_logic := '0';

-- Count Period
signal x_period_count: integer := 0;
signal x_period: integer := 0;
signal x_period_change: std_logic := '0';

-- Double Frequency
signal double_count: integer := 0;
signal flip_period: integer := 0;
signal y_double: std_logic := '0';

-- Output Signal
signal y_out: std_logic := '0';

begin

-------------------------------------------------------------------------------
-- Metastability Enhancement
-------------------------------------------------------------------------------

meta_p: process (clk)
begin
  if rising_edge(clk) then
    x_m0 <= x;
    x_m  <= x_m0;
  end if;
end process;

-------------------------------------------------------------------------------
-- Edge Detection
-------------------------------------------------------------------------------

edge_p: process (clk)
begin
  if rising_edge(clk) then
    x_prev <= x_m;
  end if;
end process;

rise <= (not x_prev) and x_m;

-------------------------------------------------------------------------------
-- Count Period
-------------------------------------------------------------------------------

counter_p: process (clk)
begin
  if rising_edge(clk) then
    if rise = '1' then
      x_period_count  <= 1;
      x_period        <= x_period_count;
      x_period_change <= '1';
    else
      x_period_count  <= x_period_count + 1;
      x_period_change <= '0';
    end if;
  end if;
end process;

-------------------------------------------------------------------------------
-- Double Frequency
-------------------------------------------------------------------------------

double_p: process (clk)
begin
  if rising_edge(clk) then
    if x_period_change = '1' then
      double_count <= 0;
      flip_period  <= x_period / 4;
      y_double     <= '1';
    elsif double_count < flip_period - 1 then
      double_count <= double_count + 1;
    else
      double_count <= 0;
      y_double     <= not y_double;
    end if;
  end if;
end process;

-------------------------------------------------------------------------------
-- Output Signal
-------------------------------------------------------------------------------

y_out <= (not enable_n) and ((double_en and y_double) or ((not double_en) and x));
y     <= y_out;

-------------------------------------------------------------------------------
-- LEDs
-------------------------------------------------------------------------------

led(0) <= not enable_n;
led(1) <= double_en;
led(2) <= x;
led(3) <= y_out;

end;
