----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/24/2020 11:11:29 AM
-- Design Name: 
-- Module Name: MEF_btn - Behavioral
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

entity MEF_btn is
    Port ( i_clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_str_btn : in STD_LOGIC_VECTOR (3 downto 0);
           o_selection : out STD_LOGIC_VECTOR (1 downto 0));
end MEF_btn;

architecture Behavioral of MEF_btn is
   type btn_etat is (
         sta_00,
         sta_01,
         sta_10,
         sta_11
         );
       
   signal fsm_EtatCourant, fsm_prochainEtat : btn_etat;
begin
    process(i_clk, i_reset)
    begin
       if (i_reset ='1') then
             fsm_EtatCourant <= sta_00;
       else
       if rising_edge(i_clk) then
             fsm_EtatCourant <= fsm_prochainEtat;
       end if;
       end if;
    end process;
    
transitions: process(fsm_EtatCourant)
begin
   case fsm_EtatCourant is
        when sta_00 =>
            if(i_str_btn(0) = '1') then
                fsm_prochainEtat <= sta_01;
            else
                fsm_prochainEtat <= sta_00;
            end if;
        when sta_01 =>
            if(i_str_btn(0)= '1') then
                fsm_prochainEtat <= sta_10;
            else
                fsm_prochainEtat <= sta_01;
            end if;
        when sta_10 =>
            if(i_str_btn(0) = '1') then
                fsm_prochainEtat <= sta_11;
            else
                fsm_prochainEtat <= sta_10;
            end if;
        when sta_11 =>
            if(i_str_btn(0) = '1') then
                fsm_prochainEtat <= sta_00;
            else
                fsm_prochainEtat <= sta_11;
            end if;
     end case;
  end process;
  
sortie: process(fsm_EtatCourant)
  begin
  
   case fsm_EtatCourant is
        when sta_00 =>
            o_selection <= "00";
        when sta_01 =>
            o_selection <= "01";
        when sta_10 =>
            o_selection <= "10";
        when sta_11 =>
            o_selection <= "11";
    end case;
end process;
end Behavioral;
