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
-- Create Date:   20:43:03 02/25/2010
-- Design Name:   
-- Module Name:   C:/PROJECTS/AES_CORE/TestBenches/AddRoundKey_TB.vhd
-- Project Name:  AES_CORE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AddRoundKey
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
 
ENTITY AddRoundKey_TB IS
END AddRoundKey_TB;
 
ARCHITECTURE behavior OF AddRoundKey_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AddRoundKey
    PORT(
         Data_IN : IN  std_logic_vector(127 downto 0);
         Key_IN : IN  std_logic_vector(127 downto 0);
         Data_OUT : OUT  std_logic_vector(127 downto 0);
         SYS_CLK : IN  std_logic;
         RST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Data_IN : std_logic_vector(127 downto 0) := (others => '0');
   signal Key_IN : std_logic_vector(127 downto 0) := (others => '0');
   signal SYS_CLK : std_logic := '0';
   signal RST : std_logic := '0';

 	--Outputs
   signal Data_OUT : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant SYS_CLK_period : time := 10 ns;
 
	SIGNAL CORRECT_OUTPUT : std_logic_vector(127 downto 0) := (others => '0');
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AddRoundKey PORT MAP (
          Data_IN => Data_IN,
          Key_IN => Key_IN,
          Data_OUT => Data_OUT,
          SYS_CLK => SYS_CLK,
          RST => RST
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
		wait for SYS_CLK_period*10;
		Data_IN 			<= X"3243f6a8885a308d313198a2e0370734";
		Key_IN			<= X"2b7e151628aed2a6abf7158809cf4f3c";
		CORRECT_OUTPUT <= X"193de3bea0f4e22b9ac68d2ae9f84808";
		wait for 20 ns;
		Data_IN 			<= X"00112233445566778899aabbccddeeff";
		Key_IN			<= X"000102030405060708090a0b0c0d0e0f";
		CORRECT_OUTPUT <= X"00102030405060708090a0b0c0d0e0f0";
      wait;
   end process;

END;
