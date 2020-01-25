----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2020 12:17:16 PM
-- Design Name: 
-- Module Name: mefparam1 - Behavioral
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

entity mefparam1 is
 Port (
    i_bclk    : in   std_logic; -- bit clock (I2S)
    i_reset   : in   std_logic;
    i_lrc     : in   std_logic; -- signal horloge echantilonnage gauche-droite (I2S)
    i_ech     : in   std_logic_vector (23 downto 0); -- echantillon en entrée
    o_output   : out  std_logic;   -- paramètre calculé
    o_cpt_bits_reset: out std_logic     
    );
end mefparam1;

architecture Behavioral of mefparam1 is

-- définition de la MEF de contrôle
   type fsm_param1_etats is (
         sta_output,
         sta_MSB0,
         sta_init,
         sta_check30
         );
         
   signal fsm_EtatCourant_param, fsm_prochainEtat_param : fsm_param1_etats;
   signal local_authorization, d_mef_reset: std_logic;
component MEFCount3 is
Port (    
    i_bclk    : in   std_logic; -- bit clock (I2S)
    i_reset   : in   std_logic;
    i_ech     : in   std_logic_vector (23 downto 0); -- echantillon en entrée
    o_authorize   : out  std_logic   
    );
end component;

begin
    inst_MEFCount3: MEFCount3
        port map(
            i_bclk => i_bclk,
            i_reset => d_mef_reset,
            i_ech => i_ech,
            o_authorize => local_authorization
        );

   -- Assignation du prochain état
    process(i_bclk, i_reset)
    begin
       if (i_reset ='1') then
             fsm_EtatCourant_param <= sta_init;
       else
       if rising_edge(i_bclk) then
             fsm_EtatCourant_param <= fsm_prochainEtat_param;
       end if;
       end if;
    end process;

-- conditions de transitions
transitions: process(i_lrc , fsm_EtatCourant_param, local_authorization)
begin
    if(i_lrc = '0') then                                -- a verifier
        case fsm_EtatCourant_param is
            when sta_output =>
            if(i_ech(23) = '0') then
                fsm_prochainEtat_param <= sta_MSB0; 
            else
                fsm_prochainEtat_param <= sta_init;
            end if;
                ------------------------------------------  
            when sta_MSB0 =>
            if(i_ech(23) = '0') then
                fsm_prochainEtat_param <= sta_MSB0; 
            else
                fsm_prochainEtat_param <= sta_init;
            end if;   
                ------------------------------------------  
            when sta_init =>
            if(i_ech(23) = '0') then
                fsm_prochainEtat_param <= sta_check30; 
            else
                fsm_prochainEtat_param <= sta_init;
            end if;  
                ------------------------------------------  
            when sta_check30 =>
            if(local_authorization = '0') then
                fsm_prochainEtat_param <= sta_check30;
            else
                fsm_prochainEtat_param <= sta_output;
            end if;
       end case;
    end if;
end process;

sortie: process(fsm_EtatCourant_param)
    begin
        case fsm_EtatCourant_param is
            when sta_init =>
                d_mef_reset <= '0';
                o_output <= '0';
                o_cpt_bits_reset <= '0';
            when sta_check30 => 
                d_mef_reset <= '0';
                o_output <= '0';
                o_cpt_bits_reset <= '0';
            when sta_output => 
                d_mef_reset <= '0';
                o_output <= '1';
                o_cpt_bits_reset <= '1'; -- Was at 1
            when sta_MSB0 =>
                d_mef_reset <= '0';
                o_output <= '0';
                o_cpt_bits_reset <= '0';
        end case;
    end process;
end Behavioral;