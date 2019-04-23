--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: MK,JH
-- Date: 2019-04-09 17:00:01
-- Design: reg
-- Description: shift register
--------------------------------------------------------------------------------
-- TODO: 
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for reg level
--------------------------------------------------------------------------------
entity reg is
	 generic (
			  N_BIT : integer        			-- default number of bits
	 );
    port (
        data_i : in std_logic;			 	-- input data
        clk_i   : in std_logic;				-- input clock
		  rst_i : in std_logic;				 	-- reset '0' active, '1' inactive
													
		  data_o : out std_logic_vector(N_BIT-1 downto 0)	-- output data
    ) ;
end reg;

--------------------------------------------------------------------------------
-- Architecture declaration for reg level
--------------------------------------------------------------------------------
architecture Behavioral of reg is
	signal internal_bits : std_logic_vector(N_BIT-1 downto 0) := (others => '0');
	
begin
    clock: process(clk_i)
		begin
			if rising_edge(clk_i) then
				if rst_i = '0' then           							-- synchronous reset
					 internal_bits <= (others => '0');					-- all bits set to '0'
				else
					for N in 1 to (N_BIT-1) loop							
								internal_bits(0) <= data_i;				-- input data from feedback
								internal_bits(N) <= internal_bits(N-1);-- shifting bits
					
					end loop;
				end if;
			end if;		
    end process clock;
	
	
	 data_o <= internal_bits;												-- output from shift register
	 
end Behavioral;
