--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: MK,JH
-- Date: 2019-04-10 13:00:22
-- Design: ZV
-- Description: feedback
--------------------------------------------------------------------------------
-- TODO: 
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for ZV level
--------------------------------------------------------------------------------
entity ZV is
	 generic (
				  N_BIT : integer         						-- default number of bits
		 );
    port(
          X_i: in std_logic_vector(N_BIT-1 downto 0);	-- input data vector
			 Y_o : out std_logic									-- output data bit
    );
end ZV;

--------------------------------------------------------------------------------
-- Architecture declaration for ZV level
--------------------------------------------------------------------------------
architecture Behavioral of ZV is

begin
																-- feedback, source http://www.elektrorevue.cz/clanky/04020/index.html
   Y_o <= (X_i(N_BIT-1) xnor X_i(N_BIT-2)) when (N_BIT = 3 or N_BIT = 4 or N_BIT = 6 or N_BIT = 7 or N_BIT = 15)	  -- for 3,4 6,7,15 bits
	else (X_i(N_BIT-1) xnor X_i(N_BIT-3)) when (N_BIT = 5 or N_BIT = 11)                                             -- for 5 ,11 bits
	else (X_i(8) xnor X_i(4)) when (N_BIT = 9)																							  -- for 9 bits
	else (X_i(9) xnor X_i(6)) when (N_BIT = 10)																							  -- for 10 bits
	else ((X_i(7) xnor X_i(5)) xnor (X_i(4) xnor X_i(3)) ) when (N_BIT = 8)														  -- for 8 bits
	else ((X_i(11) xnor X_i(5)) xnor (X_i(3) xnor X_i(0)) ) when (N_BIT = 12)													  -- for 12 bits
	else ((X_i(12) xnor X_i(3)) xnor (X_i(2) xnor X_i(0)) ) when (N_BIT = 13)													  -- for 13 bits
	else ((X_i(13) xnor X_i(4)) xnor (X_i(2) xnor X_i(0)) ) when (N_BIT = 14)													  -- for 14 bits
	else ((X_i(15) xnor X_i(14)) xnor (X_i(12) xnor X_i(3)) ) when (N_BIT = 16);												  -- for 16 bits
	
end Behavioral;
