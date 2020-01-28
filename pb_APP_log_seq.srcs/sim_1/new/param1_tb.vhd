----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2020 02:55:10 PM
-- Design Name: 
-- Module Name: param1_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity param1_tb is
end param1_tb;

architecture Behavioral of param1_tb is
component calcul_param_1 is
    Port (
    i_bclk    : in   std_logic; -- bit clock (I2S)
    i_reset   : in   std_logic;
    i_en      : in   std_logic; -- un echantillon present a l'entrée
    i_lrc     : in   std_logic; -- signal horloge echantilonnage gauche-droite (I2S)
    i_ech     : in   std_logic_vector (23 downto 0); -- echantillon en entrée
    o_param   : out  std_logic_vector (7 downto 0)   -- paramètre calculé
    );
end component;
signal d_ech: std_logic_vector (23 downto 0);
signal d_reset, d_bclk, d_lrc: std_logic;
signal d_param: std_logic_vector (7 downto 0);
signal d_ac_lrc, d_ac_bclk: std_logic;

constant period: time := 20.8us;
constant periods3: time := 62.4 us;
constant c_lrc_Period       : time :=  20.8 us;  -- 48 KHz
constant c_bclk_Period       : time := 325.49 ns;  -- 3 MHz

begin

inst_calcul_param_1: calcul_param_1
PORT MAP(
    i_bclk => d_bclk,
    i_reset => d_reset,
    i_lrc => d_lrc,
    i_en => '1',
    i_ech => d_ech,
    o_param => d_param
);
  sim_lrc:  process
  begin
     d_ac_lrc <= '1';  -- init
     loop
        wait for c_lrc_Period / 2;
        d_ac_lrc <= not d_ac_lrc; 
     end loop;
  end process;
d_lrc <= d_ac_lrc;

  sim_bclk:  process
  begin
     d_ac_bclk <= '1';  -- init
     loop
        wait for c_bclk_Period / 2;
        d_ac_bclk <= not d_ac_bclk; 
     end loop;
  end process;
d_bclk <= d_ac_bclk;

tb: process
begin
        d_reset <= '1';
        d_ech <= "100000000000000000000001";
    wait for 10ns;
        d_reset <= '0';
        d_ech <= "100000000000000000000001";
    wait for period;
        d_ech <= "000000000000000000000001";
    wait for periods3;
        d_ech <= "100000000000000000000001";
    wait for periods3;
            d_ech <= "000000000000000000000001";
    wait;
end process;

end Behavioral;
