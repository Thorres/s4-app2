---------------------------------------------------------------------------------------------
--    calcul_param_2.vhd   (temporaire)
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--    Université de Sherbrooke - Département de GEGI
--
--    Version         : 5.0
--    Nomenclature    : inspiree de la nomenclature 0.2 GRAMS
--    Date            : 16 janvier 2020
--    Auteur(s)       : 
--    Technologie     : ZYNQ 7000 Zybo Z7-10 (xc7z010clg400-1) 
--    Outils          : vivado 2019.1 64 bits
--
---------------------------------------------------------------------------------------------
--    Description (sur une carte Zybo)
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------
-- À FAIRE: 
-- Voir le guide de la problématique
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs
USE ieee.numeric_std.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
entity calcul_param_2 is
    Port (
    i_bclk    : in   std_logic;   -- bit clock
    i_reset   : in   std_logic;
    i_en      : in   std_logic;   -- un echantillon present
    i_lrc     : in   std_logic;   
    i_ech     : in   std_logic_vector (23 downto 0);
    o_param   : out  std_logic_vector (7 downto 0)                                     
    );
end calcul_param_2;
architecture Behavioral of calcul_param_2 is

component reg_24b is
  Port ( 
    i_clk       : in std_logic;
    i_reset     : in std_logic;
    i_en        : in std_logic;
    i_dat       : in std_logic_vector(23 downto 0);
    o_dat       : out  std_logic_vector(23 downto 0)
);
end component;

---------------------------------------------------------------------------------
-- Signaux
----------------------------------------------------------------------------------
    signal d_calcul : std_logic_vector (28 downto 0);
    signal d_out_registre : std_logic_vector (23 downto 0);
    signal d_result_alpha : std_logic_vector(28 downto 0);
    signal shift1, shift2, shift3, shift4, shift5: std_logic_vector(28 downto 0);
---------------------------------------------------------------------------------------------
--    Description comportementale
---------------------------------------------------------------------------------------------
begin 
-- Bit shifts
    shift1 <= "00000" & d_out_registre;
    shift2 <= "0000" & d_out_registre& "0";
    shift3 <= "000" & d_out_registre & "00";
    shift4 <= "00" & d_out_registre & "000";
    shift5 <= "0" & d_out_registre & "0000";
    
-- Assignations
    d_result_alpha <= shift1 + shift2 + shift3 + shift4 + shift5;
    d_calcul <= d_result_alpha + (i_ech&"00000");
    o_param <= d_calcul(28 downto 21);
    
-- Instanciation
    inst_reg : reg_24b
    Port Map(
    i_clk => i_bclk,
    i_reset => i_reset,
    i_en => i_en,
    i_dat => d_calcul(28 downto 5),
    o_dat => d_out_registre
    );
end Behavioral;