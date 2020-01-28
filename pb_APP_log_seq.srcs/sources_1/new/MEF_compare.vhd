----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2020 12:37:16 PM
-- Design Name: 
-- Module Name: MEF_fill_table - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
Library work;
use work.table_of_48.all;

entity MEF_compare is
Port (
    i_clk: in std_logic;
    i_en: in std_logic;
    i_reset: in std_logic;
    i_compteur : in std_logic_vector (7 downto 0);
    i_table: in table_valeurs (47 downto 0);
    o_cpt_reset: out std_logic;
    o_biggest: out std_logic_vector (23 downto 0);
    o_output: out std_logic
);
end MEF_compare;

architecture Behavioral of MEF_compare is
   type fsm_cI2S_etats is (
         sta_init,
         sta_compare,
         sta_output
         );
   signal fsm_EtatCourant, fsm_prochainEtat : fsm_cI2S_etats;
   signal tableau: table_valeurs (47 downto 0) := (others => (others => '0'));
   signal current_biggest: std_logic_vector (23 downto 0);
   signal biggest: std_logic_vector (23 downto 0) := (others => '0');
begin
   -- Assignation du prochain état
    process(i_clk, i_reset)
    begin
       if (i_reset ='1') then
             fsm_EtatCourant <= sta_init;
       else
       if rising_edge(i_clk) then
             fsm_EtatCourant <= fsm_prochainEtat;
       end if;
       end if;
    end process;


    transition: process(i_clk, fsm_EtatCourant, i_table)
    begin
        case fsm_EtatCourant is
            when sta_init =>
            if i_en = '1' then
                fsm_prochainEtat <= sta_compare;
            else 
                fsm_prochainEtat <= sta_init;
            end if;
            when sta_compare =>
            if i_compteur < "00110000" then  --
                if current_biggest(22 downto 0) < tableau (to_integer(unsigned(i_compteur)))(22 downto 0) then
                    current_biggest <= tableau (to_integer(unsigned(i_compteur)));
                end if;
                fsm_prochainEtat <= sta_compare;
            else
                fsm_prochainEtat <=sta_output;
            end if;
            
            when sta_output =>
                biggest <= current_biggest;
                fsm_prochainEtat <= sta_init;
            end case;
    end process;

    sortie: process(fsm_EtatCourant)
    begin
        case fsm_EtatCourant is
            when sta_init =>
                tableau <= i_table;
                o_output <= '0';
                o_cpt_reset <= '1';
                
            when sta_compare =>
                o_output <= '0';
                o_cpt_reset <= '0';
                o_biggest <= biggest; 
            when sta_output =>
                o_output <= '1';
                o_cpt_reset <= '0';
                o_biggest <= biggest;
        end case;
    end process;
-- tableau <= i_table;
end Behavioral;
