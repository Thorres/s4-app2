----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2020 12:12:55 PM
-- Design Name: 
-- Module Name: MEFCount3 - Behavioral
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

entity MEFCount3 is
Port (    
    i_bclk    : in   std_logic; -- bit clock (I2S)
    i_reset   : in   std_logic;
    i_ech     : in   std_logic_vector (23 downto 0); -- echantillon en entrée
    o_authorize   : out  std_logic   
    );
end MEFCount3;

architecture Behavioral of MEFCount3 is
-- définition de la MEF de contrôle
   type fsm_cI2S_etats is (
         sta_init,
         sta_2,
         sta_3
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
    
    transition: process(i_ech, fsm_EtatCourant, i_bclk)
    begin
        case fsm_EtatCourant is
            when sta_init =>
            if(i_ech(23) = '0') then
                fsm_prochainEtat <= sta_2;
            else
                fsm_prochainEtat <= sta_init;
            end if;
            
            when sta_2 =>
            if(i_ech(23) = '0') then
                fsm_prochainEtat <= sta_3;
            else
                fsm_prochainEtat <= sta_init;
            end if;
                           
            when sta_3 =>
            if(i_ech(23) = '0') then
                fsm_prochainEtat <= sta_init;
            else
                fsm_prochainEtat <= sta_init; 
            end if;
            end case;
    end process;

    sortie: process(fsm_EtatCourant)
    begin
        case fsm_EtatCourant is
            when sta_init => o_authorize <= '0';
            when sta_2 => o_authorize <= '0';
            when sta_3 => o_authorize <= '1';
        end case;
    end process;
end Behavioral;
