----------------------------------------------------------------------------------
--Copyright 2011 Michael Calvin McCoy (calvin.mccoy@gmail.com). All rights reserved.
--
--Redistribution and use in source and binary forms, with or without modification, are
--permitted provided that the following conditions are met:
--
--   1. Redistributions of source code must retain the above copyright notice, this list of
--      conditions and the following disclaimer.
--
--   2. Redistributions in binary form must reproduce the above copyright notice, this list
--      of conditions and the following disclaimer in the documentation and/or other materials
--      provided with the distribution.
--
--THIS SOFTWARE IS PROVIDED BY Michael Calvin McCoy ``AS IS'' AND ANY EXPRESS OR IMPLIED
--WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
--FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Michael Calvin McCoy OR
--CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
--SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
--ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
--NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
--ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
--The views and conclusions contained in the software and documentation are those of the
--authors and should not be interpreted as representing official policies, either expressed
--or implied, of Michael Calvin McCoy.
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:23:39 09/18/2010
-- Design Name:   
-- Module Name:   C:/Users/INMCM/Docs/Projects_Code/TRIVIUM/TRIVIUM_CORE_TB.vhd
-- Project Name:  TRIVIUM
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TRIVIUM_CORE
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TRIVIUM_CORE_TB IS
END TRIVIUM_CORE_TB;
 
ARCHITECTURE behavior OF TRIVIUM_CORE_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TRIVIUM_CORE
    PORT(
         SYS_CLK : IN  std_logic;
         CNTRL : IN std_logic_vector(1 downto 0);
         KEY : IN  std_logic_vector(79 downto 0);
         IV : IN  std_logic_vector(79 downto 0);
         KEY_OUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SYS_CLK : std_logic := '0';
   signal CNTRL : std_logic_vector(1 downto 0) := "00";
   signal KEY : std_logic_vector(79 downto 0) := (others => '0');
   signal IV : std_logic_vector(79 downto 0) := (others => '0');

 	--Outputs
   signal KEY_OUT : std_logic;

   -- Clock period definitions
   constant SYS_CLK_period : time := 20 ns;
	
	signal result : std_logic_vector(127 downto 0) := (OTHERS => '0');
	signal cycle_cnt : std_logic_vector(16 downto 0) := (OTHERS => '0');
	signal correct_output : std_logic_vector(127 downto 0) := (OTHERS => '0');
	
function littler_endian (b: std_logic_vector(127 downto 0)) return std_logic_vector is
variable result : std_logic_vector(127 downto 0);
begin
	for i in 0 to 15 loop
		result(((i*8)+7) downto (i*8)) := b(i*8) &
														 b((i*8) + 1) &
														 b((i*8) + 2) &
														 b((i*8) + 3) &
														 b((i*8) + 4) &
														 b((i*8) + 5) &
														 b((i*8) + 6) &
														 b((i*8) + 7);

       end loop;
       return result;
   end;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TRIVIUM_CORE PORT MAP (
          SYS_CLK => SYS_CLK,
          CNTRL => CNTRL,
          KEY => KEY,
          IV => IV,
          KEY_OUT => KEY_OUT
        );

   -- Clock process definitions
   SYS_CLK_process :process
   begin
		SYS_CLK <= '0';
		wait for SYS_CLK_period/2;
		SYS_CLK <= '1';
		wait for SYS_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		KEY <= X"0F62B5085BAE0154A7FA";
		IV  <= X"288FF65DC42B92F960C7";
		CNTRL <= "10";
      wait for SYS_CLK_period;
		CNTRL <= "11";
		wait for SYS_CLK_period*1152;
		CNTRL <= "01";
		wait for SYS_CLK_period*127;
		wait for SYS_CLK_period/2;
		correct_output <= littler_endian(X"A4386C6D7624983FEA8DBE7314E5FE1F");
		wait for SYS_CLK_period;
		correct_output <= X"00000000000000000000000000000000";
		wait for SYS_CLK_period*127;
		correct_output <= littler_endian(X"9D102004C2CEC99AC3BFBF003A66433F");
		wait for SYS_CLK_period;
		correct_output <= X"00000000000000000000000000000000";
		wait for SYS_CLK_period*127;
		correct_output <= littler_endian(X"3089A98FAD8512C49D7AABC0639F90C5");
		wait for SYS_CLK_period;
		correct_output <= X"00000000000000000000000000000000";
		
		
      -- insert stimulus here 

      wait;
   end process;

	---Result Shift Register
	res_shift_reg : process
	begin
		wait for 110 ns;	
		loop
		result <= result(126 downto 0) & KEY_OUT;
		cycle_cnt <=  cycle_cnt + 1;
		wait for SYS_CLK_period;
		end loop;

	END PROCESS;	

END;
