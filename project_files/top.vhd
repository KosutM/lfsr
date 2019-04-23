--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: MK, JH
-- Date: 2019-04-18 08:51
-- Design: top
-- Description: Implementation of generator preudo-random number sequence (c)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 
--------------------------------------------------------------------------------
-- Entity declaration for top level
--------------------------------------------------------------------------------
entity top is
    generic (
			  N_BIT : integer :=16;        			-- default number of bits, multiplication of 4 bits (max 16)
			  prescaler_bits: integer := 16			-- number of prescaler bits, sets speed of shifting
	 );
	 port (
        btn_i : in std_logic_vector(0 downto 0); 			--input btn Coolrunner-II board   
		  --cpld_sw_i : in std_logic_vector(2 downto 0);     
 
        clk_i : in std_logic;   									-- use jumpers and select clock
       
		 -- Global output signals at Coolrunner-II board
		  disp_digit_o : out std_logic_vector(3 downto 0);	-- 1 of 4 digit
		  disp_sseg_o : out std_logic_vector(6 downto 0);	-- segments
		  cpld_led_o : out std_logic_vector(15 downto 0)	-- output LEDs CPLD-board
     
    );
end top;

--------------------------------------------------------------------------------
-- Architecture declaration for top level
--------------------------------------------------------------------------------
architecture Behavioral of top is
	--signal N_BITs : integer;
   --signal switch_value : integer;
	signal inter_data : std_logic_vector(N_BIT-1 downto 0);						-- internal register data
	signal disp_data : std_logic_vector(15 downto 0) := (others => '0');		-- internal display data
	signal xnor_out_bit : std_logic := '1';											-- output bit from feedback
   signal clk_prescaler : std_logic_vector(prescaler_bits-1 downto 0);		-- output signal from binary counter

		  
begin
--		switch_value <=    4 when (cpld_sw_i(0)='0' and cpld_sw_i(1)='0' and cpld_sw_i(2)='0')
--					 else 	 8 when (cpld_sw_i(0)='1' and cpld_sw_i(1)='0' and cpld_sw_i(2)='0') 
--					 else 	12 when (cpld_sw_i(0)='1' and cpld_sw_i(1)='1' and cpld_sw_i(2)='0')
--				    else 	16 when (cpld_sw_i(0)='1' and cpld_sw_i(1)='1' and cpld_sw_i(2)='1');
--		
		
		R: entity work.reg							-- N_bit shift register
		 generic map (
			N_BIT => N_BIT --switch_value--                 		-- set number of bits in register entity
        )
		port map(
			data_i => xnor_out_bit,							-- output bit of XNOR feedback as input data
			clk_i => clk_prescaler(prescaler_bits-1),	-- input prescaled clock
			rst_i => btn_i(0),								-- reset
			data_o => inter_data								-- output parallel data
		);
-------------------------------------------------------------------------------------------------------
		ZV : entity work.ZV									-- XNOR feedback
		generic map (
			N_BIT =>N_BIT   --switch_value--          -- set number of bits in feedback entity
        )
		port map(
			X_i => inter_data,								-- input data
			Y_o => xnor_out_bit								-- output bit
		);
--------------------------------------------------------------------------------------------------------
		CNT: entity work.bin_cnt							--prescaler of clock
		generic map (
			N_BIT => prescaler_bits         		
        )
		port map(
			clk_i => clk_i,									-- internal clock (10kHz, 100kHz, 1MHz)
			rst_n_i => '1',									-- inactive reset
			bin_cnt_o => clk_prescaler						-- output vector
		);
--------------------------------------------------------------------------------------------------------	
		DISP_MUX: entity work.disp_mux					-- multiplex for 7-segment display
		port map(
			data3_i => disp_data(15 downto 12),			-- input data 
			data2_i => disp_data(11 downto 8),
			data1_i => disp_data(7 downto 4),
			data0_i => disp_data(3 downto 0),
			clk_i => clk_i,									-- internal clock (10kHz, 100kHz, 1MHz)

			an_o => disp_digit_o,							-- common anodes
			sseg_o =>  disp_sseg_o							-- segments
		);
-------------------------------------------------------------------------------------------------------
		cpld_led_o <= inter_data when (N_BIT = 16)										-- shift register parallel outputs to LEDs , filled into 16bit vector
					else "0000" & inter_data when (N_BIT = 12)					
					else "00000000" & inter_data when (N_BIT = 8)
					else "000000000000" & inter_data when (N_BIT = 4);					
		
		-- setting MSB left, LSB right
		disp_data(15 downto 12) <= ("0000" or inter_data(15 downto 12)) when(N_BIT = 16) else "0000";													-- 4rd display 
		disp_data(11 downto 8) <= ("0000" or inter_data(11 downto 8)) when (N_BIT = 12 or N_BIT = 16) else "0000";									-- 3rd display
		disp_data(7 downto 4) <= ("0000" or inter_data(7 downto 4)) when (N_BIT = 8  or N_BIT = 12 or N_BIT = 16) else "0000";					-- 2nd display
		disp_data(3 downto 0) <= ("0000" or inter_data(3 downto 0)) when (N_BIT = 4 or N_BIT = 8 or N_BIT = 12 or N_BIT = 16) else "0000";	-- 1st display
				
	 		
end Behavioral;