library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity PWM_tb is
end entity PWM_tb;

architecture test of PWM_tb is
  signal clk  : std_logic := '0';
  signal rst  : std_logic := '0';
  signal o_led: std_logic := '0';
    component PWM
        Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           o_led : out STD_LOGIC
         );
    end component;  
begin

-- Clock process definitions
clk_gen: process
 begin
    clk <= '0';
    wait for 10ns;
    clk <= '1';
    wait for 10ns;
 end process;
  
  -- Instantiate the design under test
  dut: PWM
    Port map( 
           i_clk => clk,
           i_rst => rst,
           o_led => o_led
         );
    
  -- Generate the test stimulus
  stimulus:
  process begin
      rst <= '0';
      wait for 6 ns;
      rst <= '1';

    -- Testing complete
    wait;
  end process stimulus;
  
end architecture test;