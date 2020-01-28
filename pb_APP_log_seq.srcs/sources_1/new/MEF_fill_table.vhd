library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Library work;
use work.table_of_48.all;

entity MEF_fill_table is
Port (
    i_clk: in std_logic;
    i_reset: in std_logic;
    i_en: in std_logic;
    i_ech: in std_logic_vector (23 downto 0);
    i_compteur: in std_logic_vector (7 downto 0);
    i_table: in table_valeurs (47 downto 0);
    o_cpt_reset: out std_logic;
    o_table_modified: out table_valeurs (47 downto 0);
    o_compare_start: out std_logic
 );
end MEF_fill_table;

architecture Behavioral of MEF_fill_table is
   type fsm_cI2S_etats is (
         sta_init,
         sta_putNext,
         sta_output
         );
    signal fsm_EtatCourant, fsm_prochainEtat : fsm_cI2S_etats;
    signal tableau: table_valeurs (47 downto 0) := (others => (others => '0'));
    signal position: integer := 0; 

begin
    position <= to_integer(unsigned(i_compteur));

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
                tableau <= i_table;
            if i_en = '1' then
                fsm_prochainEtat <= sta_putNext;
            else 
                fsm_prochainEtat <= sta_init;
            end if;
            when sta_putNext =>
            if i_compteur < "00101111" then  --
               tableau (47 - position) <= tableau (46 - position);
                fsm_prochainEtat <= sta_putNext;
            elsif i_compteur = "00101111" then
                tableau (0) <= i_ech;
                fsm_prochainEtat <= sta_output;
            end if;
            
            when sta_output =>
                fsm_prochainEtat <= sta_init;
            end case;
    end process;

    sortie: process(fsm_EtatCourant)
    begin
        case fsm_EtatCourant is
            when sta_init =>
                o_cpt_reset <= '1';
                o_compare_start <= '0';
                o_table_modified <= tableau;
                
            when sta_putNext =>
                o_cpt_reset <= '0';
                o_compare_start <= '0';
                
            when sta_output =>
                o_cpt_reset <= '0';
                o_table_modified <= tableau;
                o_compare_start <= '1';
        end case;
    end process;
end Behavioral;
