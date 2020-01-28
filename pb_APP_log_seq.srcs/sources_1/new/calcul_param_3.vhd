library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs
USE ieee.numeric_std.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

package table_of_48 is 
    type table_valeurs is array (natural range <>) of std_logic_vector(23 downto 0);
end package;

package body table_of_48 is
end package body;
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs
USE ieee.numeric_std.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;
Library work;
use work.table_of_48.all;

entity calcul_param_3 is
    Port (
    i_bclk    : in   std_logic;   -- bit clock
    i_reset   : in   std_logic;
    i_en      : in   std_logic;   -- un echantillon present
    i_lrc     : in   std_logic;   
    i_ech     : in   std_logic_vector (23 downto 0);
    o_param   : out  std_logic_vector (7 downto 0)                                     
    );
end calcul_param_3;


architecture Behavioral of calcul_param_3 is

component MEF_compare is
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
end component;

component MEF_fill_table is
Port (
    i_clk: in std_logic;
    i_reset: in std_logic;
    i_ech: in std_logic_vector (23 downto 0);
    i_en: in std_logic;
    i_compteur: in std_logic_vector (7 downto 0);
    i_table: in table_valeurs (47 downto 0);
    o_cpt_reset: out std_logic;
    o_table_modified: out table_valeurs (47 downto 0);
    o_compare_start: out std_logic
 );
end component;

component compteur_nbits 
generic (nbits : integer := 8);
   port ( 
          clk             : in    std_logic; 
          i_en            : in    std_logic; 
          reset           : in    std_logic; 
          o_val_cpt       : out   std_logic_vector (nbits-1 downto 0)
          );
end component;
---------------------------------------------------------------------------------
-- Signaux
---------------------------------------------------------------------------------- 
signal tab_ou_fill: table_valeurs (47 downto 0) := (others => (others => '0'));
signal compteur_compare, compteur_fill: std_logic_vector (7 downto 0) := "00000000";
signal maximum: std_logic_vector (23 downto 0) := (others => '0');
signal test_output: std_logic_vector (23 downto 0):= (others => '0');
signal compare_cpt_reset, fill_cpt_reset, output_authorized, enable_MEF_fill, compare_authorized: std_logic := '0';
---------------------------------------------------------------------------------------------
--    Description comportementale
---------------------------------------------------------------------------------------------
begin
inst_MEF_fill_table: MEF_fill_table
port map(
    i_clk => i_bclk,
    i_reset => i_reset,
    i_ech => i_ech,
    i_en => i_en,
    i_compteur => compteur_fill,
    i_table => tab_ou_fill,
    o_cpt_reset => fill_cpt_reset,
    o_table_modified => tab_ou_fill,
    o_compare_start => compare_authorized
);

inst_MEF_compare: MEF_compare
port map(
    i_clk => i_bclk,
    i_en => compare_authorized,
    i_reset => i_reset,
    i_compteur => compteur_compare,
    i_table => tab_ou_fill,
    o_cpt_reset => compare_cpt_reset,
    o_biggest => maximum,
    o_output => output_authorized
);

isnt_compteur_compare: compteur_nbits
generic map (nbits => 8)
port map(
      clk => i_bclk,
      i_en => '1',
      reset => compare_cpt_reset,
      o_val_cpt => compteur_compare
);

isnt_compteur_fill: compteur_nbits
generic map (nbits => 8)
port map(
      clk => i_bclk,
      i_en => '1',
      reset => fill_cpt_reset,
      o_val_cpt => compteur_fill
);

    process(output_authorized, i_bclk)
    begin
       if output_authorized = '1' and rising_edge(i_bclk) then
        --process(i_bclk)
       -- begin
        --if rising_edge(i_bclk) then
            o_param <= maximum(22 downto 15);
       -- end if;
      --  end process;
            test_output <= maximum;
        end if;
    end process;

end Behavioral;
