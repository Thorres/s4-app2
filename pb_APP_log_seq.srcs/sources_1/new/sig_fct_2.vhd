---------------------------------------------------------------------------------------------
--    sig_fct_2.vhd   (temporaire)
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
--    Description comportementale
---------------------------------------------------------------------------------------------
entity sig_fct_2 is
    Port (  
    i_ech       : in   std_logic_vector (23 downto 0);
    o_ech_fct   : out  std_logic_vector (23 downto 0)                                    
    );
end sig_fct_2;

---------------------------------------------------------------------------------------------

architecture Behavioral of sig_fct_2 is

---------------------------------------------------------------------------------------------
-- Signaux
---------------------------------------------------------------------------------------------
    signal d_ech             : std_logic_vector (23 downto 0);   -- 
    signal d_ech_fct         : std_logic_vector (23 downto 0);   --   
    signal d_ech_u24         : signed(23 downto 0);      --  
    
    signal adr               : std_logic_vector(7 downto 0); --vecteur d'adresse du tableau           
    signal vs                : std_logic_vector(23 downto 0); --0,25
    
    signal d_ech_u24_moinsVs : std_logic_vector(23 downto 0);
---------------------------------------------------------------------------------------------
-- 
type t_tab is array(0 to 94) of std_logic_vector(23 downto 0);  --Seminaire VHDL
constant tab : t_tab := (

    x"200000",
    x"21025A",
    x"2202A9",
    x"22FEFD",
    x"23F592",
    x"24E4E1",
    x"25CBAE",
    x"26A909",
    x"277C4F",
    x"28451F",
    x"290357",
    x"29B707",
    x"2A6065",
    x"2AFFC8",
    x"2B9598",
    x"2C2250",
    x"2CA66F",
    x"2D2279",
    x"2D96F0",
    x"2E0455",
    x"2E6B24",
    x"2ECBD1",
    x"2F26CD",
    x"2F7C7E",
    x"2FCD47",
    x"301981",
    x"306180",
    x"30A591",
    x"30E5FC",
    x"312302",
    x"315CDF",
    x"3193CC",
    x"31C7FB",
    x"31F99C",
    x"3228DB",
    x"3255DE",
    x"3280CC",
    x"32A9C5",
    x"32D0EA",
    x"32F658",
    x"331A29",
    x"333C76",
    x"335D56",
    x"337CDE",
    x"339B22",
    x"33B835",
    x"33D427",
    x"33EF08",
    x"3408E7",
    x"3421D2",
    x"3439D5",
    x"3450FD",
    x"346755",
    x"347CE7",
    x"3491BC",
    x"34A5DF",
    x"34B958",
    x"34CC2E",
    x"34DE6A",
    x"34F013",
    x"35012F",
    x"3511C4",
    x"3521D9",
    x"353173",
    x"354098",
    x"354F4C",
    x"355D94",
    x"356B75",
    x"3578F3",
    x"358612",
    x"3592D6",
    x"359F42",
    x"35AB5A",
    x"35B721",
    x"35C29A",
    x"35CDC8",
    x"35D8AE",
    x"35E34F",
    x"35EDAC",
    x"35F7C9",
    x"3601A8",
    x"360B4B",
    x"3614B3",
    x"361DE4",
    x"3626DF",
    x"362FA5",
    x"363839",
    x"36409C",
    x"3648D0",
    x"3658B0",
    x"36605F",
    x"3667E4",
    x"366F41",
    x"367677",
    x"367D88"
    );

begin 
    
    vs <= "001000000000000000000000";       --0,25 (premier bit significatif)

    -- simple transfert...
    d_ech_u24   <=  abs(signed(i_ech));

    d_ech_u24_moinsVs <= std_logic_vector(d_ech_u24 - signed(vs));
    
    adr <= d_ech_u24_moinsVs(23 downto 16); --Prendre les 8 MSB
    
    process(adr)
    begin
        
        if (d_ech_u24 < signed(vs)) then
            
            d_ech_fct <= i_ech;    --out = in
         
         else --sign(Vi) avec valeur (Vs + g(abs(Vi)-Vs))  
         
         d_ech_fct <=  tab(to_integer(unsigned(adr)));
         
             if(i_ech(23) = '1') then       --Regarde si l'entrée était négative, le signe de la sortie sera neg aussi
                d_ech_fct(23) <= '1';
             
             end if;
        end if; 
        --o_ech_fct <= tab(to_integer(unsigned(adr)));
    end process;
        o_ech_fct <= std_logic_vector(d_ech_fct);

end Behavioral;