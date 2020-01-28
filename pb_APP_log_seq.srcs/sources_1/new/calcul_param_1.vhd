
---------------------------------------------------------------------------------------------
--    calcul_param_1.vhd   (temporaire)
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--    Universit� de Sherbrooke - D�partement de GEGI
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
-- � FAIRE: 
-- Voir le guide de la probl�matique
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
entity calcul_param_1 is
    Port (
    i_bclk    : in   std_logic; -- bit clock (I2S)
    i_reset   : in   std_logic;
    i_en      : in   std_logic; -- un echantillon present a l'entr�e
    i_lrc     : in   std_logic; -- signal horloge echantilonnage gauche-droite (I2S)
    i_ech     : in   std_logic_vector (23 downto 0); -- echantillon en entr�e
    o_param   : out  std_logic_vector (7 downto 0)   -- param�tre calcul�
    );
end calcul_param_1;

----------------------------------------------------------------------------------

architecture Behavioral of calcul_param_1 is
component compteur_nbits 
generic (nbits : integer := 8);
   port ( clk             : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
          );
end component;

component mefparam1 is
 Port (
        i_bclk    : in   std_logic; -- bit clock (I2S)
        i_reset   : in   std_logic;
        i_lrc     : in   std_logic; -- signal horloge echantilonnage gauche-droite (I2S)
        i_ech     : in   std_logic_vector (23 downto 0); -- echantillon en entr�e
        o_output   : out  std_logic;   -- param�tre calcul�
        o_cpt_bits_reset: out std_logic
     );
end component;
---------------------------------------------------------------------------------
-- Signaux
----------------------------------------------------------------------------------
    signal d_cpt_bits: std_logic_vector (7 downto 0) := "00000000";
    signal d_cpt_bits_reset, d_output: std_logic := '0';
---------------------------------------------------------------------------------------------
--    Description comportementale
---------------------------------------------------------------------------------------------
begin 
    inst_cpt : compteur_nbits
    generic map (nbits => 8)
    port  map
     (
          clk        => i_lrc,
          i_en        => '1',     -- compteur toujours actif
          reset       => d_cpt_bits_reset,
          o_val_cpt   => d_cpt_bits
      );

    inst_mefparam1:  mefparam1
    Port map (
        i_bclk    => i_bclk,
        i_reset   => i_reset,
        i_lrc     => i_lrc,
        i_ech     => i_ech,
        o_output => d_output,
        o_cpt_bits_reset => d_cpt_bits_reset
     );
    process(d_output, i_bclk)
    begin
    if d_output = '1' then
        o_param <= d_cpt_bits + 1;    -- temporaire ...
    end if;
    end process;


end Behavioral;
