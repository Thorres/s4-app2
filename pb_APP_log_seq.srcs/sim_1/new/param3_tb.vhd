----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2020 08:02:42 PM
-- Design Name: 
-- Module Name: param3_tb - Behavioral
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
Library work;
use work.table_of_48.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity param3_tb is
end param3_tb;

architecture Behavioral of param3_tb is
component calcul_param_3 is
    Port (
    i_bclk    : in   std_logic;   -- bit clock
    i_reset   : in   std_logic;
    i_en      : in   std_logic;   -- un echantillon present
    i_lrc     : in   std_logic;   
    i_ech     : in   std_logic_vector (23 downto 0);
    o_param   : out  std_logic_vector (7 downto 0)                                     
    );
end component;
signal d_ac_mclk, d_bclk: std_logic;
signal d_reset, d_en, d_cpt_reset, d_compare_start, d_lrc: std_logic;
signal d_ech: std_logic_vector (23 downto 0);

constant period: time := 550ns;
constant c_mclk_Period       : time :=  10 ns;  -- 12.288 MHz
signal d_table : table_valeurs (47 downto 0) := (   
 -- forme d'un sinus 
 -- chaque cycle a 48 echantillons
 -- la table suivante contient 1 cycle, compléter au besoin 
 x"000000",
 x"0C866D",
 x"18D609",
 x"24B8F4",
 x"2FFB28",
 x"3A6B60",
 x"43DBED",
 x"4C237E",
 x"531DD9",
 x"58AC72",
 x"5CB6F8",
 x"5F2BBC",
 x"5FFFFE",
 x"5F301C",
 x"5CBFA5",
 x"58B946",
 x"532E9C",
 x"4C37E7",
 x"43F3A1",
 x"3A85F9",
 x"301832",
 x"24D7EE",
 x"18F66D",
 x"0CA7AC",
 x"002189",
 x"F39AD4",
 x"E74A5D",
 x"DB660A",
 x"D021E7",
 x"C5AF40",
 x"BC3BD0",
 x"B3F0F4",
 x"ACF2F5",
 x"A7606D",
 x"A351C0",
 x"A0D8B0",
 x"A0000E",
 x"A0CB8F",
 x"A337B9",
 x"A739F1",
 x"ACC0AC",
 x"B3B3BA",
 x"BBF4B2",
 x"C55F75",
 x"CFCACB",
 x"DB091C",
 x"E6E933",
 x"F33716"
);
begin

inst_calcul_param_3: calcul_param_3
port map (
    i_bclk    => d_bclk,
    i_reset   => d_reset,
    i_en      => d_en,
    i_lrc     => d_lrc,
    i_ech     => d_ech
);

  sim_mclk:  process
  begin
     d_ac_mclk <= '1';  -- init
     loop
        wait for c_mclk_Period / 2;
        d_ac_mclk <= not d_ac_mclk; 
     end loop;
  end process;

d_bclk <= d_ac_mclk;


tb: process
begin
        d_reset <= '1';
        d_en <= '1';
        d_ech <= "000001111100000111110000";
        wait for 10ns;
        d_reset <= '0';
        d_en <= '0';
        d_ech <= "000001111100000111110000";
        wait for period;
        d_en <= '1';
        d_ech <= "000001111100000111111111";
        wait for period;
        d_en <= '1';
        d_ech <= "001101111100000111111111";
        wait;
end process;
end Behavioral;
