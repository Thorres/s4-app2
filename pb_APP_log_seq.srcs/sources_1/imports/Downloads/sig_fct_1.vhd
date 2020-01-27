---------------------------------------------------------------------------------------------
--    sig_fct_1.vhd   (temporaire)
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--    Université de Sherbrooke - Département de GEGI
--
--    Version         : 5.0
--    Nomenclature    : inspiree de la nomenclature 0.2 GRAMS
--    Date            : 29 janvier 2019
--    Auteur(s)       : 
--    Technologie     : ZYNQ 7000 Zybo Z7-10 (xc7z010clg400-1) 
--    Outils          : vivado 2018.2 64 bits
--
---------------------------------------------------------------------------------------------
--  Description 
--  fonction temporaire, aucun calcul
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------
--   À FAIRE:
--   Voir le guide de la problématique
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE ieee.numeric_std.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------
entity sig_fct_1 is
    Port (  
    i_ech       : in   std_logic_vector (23 downto 0);
    o_ech_fct   : out  std_logic_vector (23 downto 0)                                    
    );
end sig_fct_1;

---------------------------------------------------------------------------------------------

architecture Behavioral of sig_fct_1 is

---------------------------------------------------------------------------------
-- Signaux
----------------------------------------------------------------------------------
    signal d_ech             : std_logic_vector (23 downto 0);   -- 
    signal d_ech_fct         : std_logic_vector (23 downto 0);   --   
    signal d_ech_u24         : unsigned (23 downto 0);      --  
    
---------------------------------------------------------------------------------------------
--    Description comportementale
---------------------------------------------------------------------------------------------
begin 
    -- simple transfert...
    d_ech_u24   <=  unsigned (i_ech);
    o_ech_fct   <=  std_logic_vector(d_ech_u24);    
        
    d_ech_fct <= "001000000000000000000000";   --0.25 en binaire (0.01000000000000000000000) 
                
    process(i_ech) is
    begin
    
        if (i_ech(23) = '1') then --Si l'entrée est nég, valeur absolue
        
            d_ech_u24 <= unsigned(not i_ech +1);      
        else
            d_ech_u24 <= unsigned(i_ech);   --prend la valeur de l'entrée si elle est positive 
        end if; 
        
        --met le unsigned dans un std_logic_vector        
        d_ech <= std_logic_vector(d_ech_u24);
        
        -- output = i_ech  SI  abs(i_ech < d_ech_fct)    ou d_ech_fct = 0.25
        if (d_ech < d_ech_fct) then
        
            o_ech_fct <= i_ech;
            
        else    --output = (signe de l'entrée)0.25
            
            if (i_ech(23) = '1') then   --si entrée négative, output = négatif en C2 (équivalence)
                
               d_ech_fct <= std_logic_vector(unsigned(not d_ech_fct +1));
                   
            end if;
            --si entrée positive, output = entrée
            o_ech_fct <= d_ech_fct; 
            
        end if; 
    end process;
end Behavioral;
