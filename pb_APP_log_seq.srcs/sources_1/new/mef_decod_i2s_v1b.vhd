---------------------------------------------------------------------------------------------
-- circuit mef_decod_i2s_v1b.vhd                   Version mise en oeuvre avec des compteurs
---------------------------------------------------------------------------------------------
-- Université de Sherbrooke - Département de GEGI
-- Version         : 1.0
-- Nomenclature    : 0.8 GRAMS
-- Date            : 7 mai 2019
-- Auteur(s)       : Daniel Dalle
-- Technologies    : FPGA Zynq (carte ZYBO Z7-10 ZYBO Z7-20)
--
-- Outils          : vivado 2019.1
---------------------------------------------------------------------------------------------
-- Description:
-- MEF pour decodeur I2S version 1b
-- La MEF est substituee par un compteur
--
-- notes
-- frequences (peuvent varier un peu selon les contraintes de mise en oeuvre)
-- i_lrc        ~ 48.    KHz    (~ 20.8    us)
-- d_ac_mclk,   ~ 12.288 MHz    (~ 80,715  ns) (non utilisee dans le codeur)
-- i_bclk       ~ 3,10   MHz    (~ 322,857 ns) freq mclk/4
-- La durée d'une période reclrc est de 64,5 périodes de bclk ...
--
-- Revision  
-- Revision 14 mai 2019 (version ..._v1b) composants dans entités et fichiers distincts
---------------------------------------------------------------------------------------------
-- À faire :
--
--
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs

entity mef_decod_i2s_v1b is
   Port ( 
   i_bclk      : in std_logic;
   i_reset     : in    std_logic; 
   i_lrc       : in std_logic;
   i_cpt_bits  : in std_logic_vector(6 downto 0);
 --  
   o_bit_enable     : out std_logic ;  --
   o_load_left      : out std_logic ;  --
   o_load_right     : out std_logic ;  --
   o_str_dat        : out std_logic ;  --  
   o_cpt_bit_reset  : out std_logic   -- 
   
);
end mef_decod_i2s_v1b;

architecture Behavioral of mef_decod_i2s_v1b is

-- définition de la MEF de contrôle
   type fsm_cI2S_etats is (
         sta_init,
         sta_registre,
         sta_load_left,
         sta_load_right,
         sta_wait_left,
         sta_wait_right,
         sta_str_data
         );
   signal fsm_EtatCourant, fsm_prochainEtat : fsm_cI2S_etats;
    
begin
   -- Assignation du prochain état
    process(i_bclk, i_reset)
    begin
       if (i_reset ='1') then
             fsm_EtatCourant <= sta_init;
       else
       if rising_edge(i_bclk) then
             fsm_EtatCourant <= fsm_prochainEtat;
       end if;
       end if;
    end process;

-- conditions de transitions
transitions: process(i_lrc , fsm_EtatCourant, i_cpt_bits)
begin
   case fsm_EtatCourant is
        when sta_init =>
            fsm_prochainEtat <= sta_registre;
        when sta_registre =>
            if(i_cpt_bits = "00011000") then
                if(i_lrc = '0') then
                    fsm_prochainEtat <= sta_load_left;
                else
                    fsm_prochainEtat <= sta_load_right;
                end if;
            else
                fsm_prochainEtat <= sta_registre;
            end if;
         when sta_load_left =>
            fsm_prochainEtat <= sta_wait_left;
         when sta_load_right =>
            fsm_prochainEtat <= sta_str_data;
         when sta_str_data => 
            fsm_prochainEtat <= sta_wait_right;
         when sta_wait_left =>
            if i_lrc = '1' then
                fsm_prochainEtat <= sta_init;
            else
                fsm_prochainEtat <= sta_wait_left;
            end if;
         when sta_wait_right =>
            if i_lrc = '0' then
                fsm_prochainEtat <= sta_init;
            else
                fsm_prochainEtat <= sta_wait_right;
            end if;
     end case;
  end process;
  

  -- relations de sorties pour le contrôle du registre et du compteur
  sortie: process(fsm_EtatCourant, i_lrc )
  begin
  
   case fsm_EtatCourant is
        when sta_init =>
            o_cpt_bit_reset    <= '1';
            o_bit_enable     <= '0';
            o_load_left      <= '0';
            o_load_right     <= '0';
            o_str_dat <= '0';
       when sta_registre=>
             o_cpt_bit_reset    <= '0';
             o_bit_enable     <= '1';
             o_load_left      <= '0';
             o_load_right     <= '0';
             o_str_dat <= '0';
        when sta_load_left=>
            o_cpt_bit_reset    <= '0';
            o_bit_enable     <= '0';
            o_load_left      <= '1';
            o_load_right     <= '0';
            o_str_dat <= '0';
        when sta_load_right=>
            o_cpt_bit_reset    <= '0';
            o_bit_enable     <= '0';
            o_load_left      <= '0';
            o_load_right     <= '1';
            o_str_dat <= '0';
        when sta_str_data=>
            o_cpt_bit_reset    <= '0';
            o_bit_enable     <= '0';
            o_load_left      <= '0';
            o_load_right     <= '0';
            o_str_dat <= '1';
        when sta_wait_left =>
            o_cpt_bit_reset    <= '0';
            o_bit_enable     <= '0';
            o_load_left      <= '0';
            o_load_right     <= '0';
            o_str_dat <= '0';
        when sta_wait_right =>
            o_cpt_bit_reset    <= '0';
            o_bit_enable     <= '0';
            o_load_left      <= '0';
            o_load_right     <= '0';
            o_str_dat <= '0';
    end case;
  end process;
end Behavioral;