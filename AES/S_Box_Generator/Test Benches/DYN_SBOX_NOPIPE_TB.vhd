----------------------------------------------------------------------------------
--Copyright 2010 Michael Calvin McCoy (calvin.mccoy@gmail.com). All rights reserved.
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
-----------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:49:45 04/07/2010
-- Design Name:   
-- Module Name:   C:/PROJECTS/SBOX_GEN/DYN_SBOX_NOPIPE_TB.vhd
-- Project Name:  SBOX_GEN
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DYN_SBOX_NOPIPE
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
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY DYN_SBOX_NOPIPE_TB IS
END DYN_SBOX_NOPIPE_TB;
 
ARCHITECTURE behavior OF DYN_SBOX_NOPIPE_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DYN_SBOX_NOPIPE
    PORT(
         BYTE_IN : IN  std_logic_vector(7 downto 0);
         SUB_BYTE_OUT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal BYTE_IN : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal SUB_BYTE_OUT : std_logic_vector(7 downto 0);
	
	SIGNAL CORRECT_OUTPUT : std_logic_vector(7 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DYN_SBOX_NOPIPE PORT MAP (
          BYTE_IN => BYTE_IN,
          SUB_BYTE_OUT => SUB_BYTE_OUT
        );
 
 
   -- Stimulus process
   stim_proc: process
   begin
		CORRECT_OUTPUT <= X"63";
      wait for 10 ns;	
		BYTE_IN <= X"04";
		CORRECT_OUTPUT <= X"F2";
		wait for 10 ns;	
		BYTE_IN <= X"0f";
		CORRECT_OUTPUT <= X"76";
		wait for 10 ns;	
		BYTE_IN <= X"01";
		CORRECT_OUTPUT <= X"7c";
		wait for 10 ns;	
		BYTE_IN <= X"FF";
		CORRECT_OUTPUT <= X"16";
		wait for 10 ns;	
		BYTE_IN <= X"77";
		CORRECT_OUTPUT <= X"F5";
		wait for 10 ns;	
		BYTE_IN <= X"CB";
		CORRECT_OUTPUT <= X"1F";
		wait for 10 ns;
		WAIT;
   end process;
END;
