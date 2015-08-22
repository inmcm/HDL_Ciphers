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
-- Create Date:   20:24:37 02/25/2010
-- Design Name:   
-- Module Name:   C:/PROJECTS/AES_CORE/TestBenches/ShiftRows_TB.vhd
-- Project Name:  AES_CORE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ShiftRows
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
 
ENTITY ShiftRows_TB IS
END ShiftRows_TB;
 
ARCHITECTURE behavior OF ShiftRows_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ShiftRows
    PORT(
         ShiftRows_In : IN  std_logic_vector(127 downto 0);
         ShiftRows_Out : OUT  std_logic_vector(127 downto 0);
         Sys_Clk : IN  std_logic;
         RST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ShiftRows_In : std_logic_vector(127 downto 0) := (others => '0');
   signal Sys_Clk : std_logic := '0';
   signal RST : std_logic := '0';

 	--Outputs
   signal ShiftRows_Out : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant Sys_Clk_period : time := 10 ns;
 
	SIGNAL CORRECT_OUTPUT : std_logic_vector(127 downto 0) := (others => '0');
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ShiftRows PORT MAP (
          ShiftRows_In => ShiftRows_In,
          ShiftRows_Out => ShiftRows_Out,
          Sys_Clk => Sys_Clk,
          RST => RST
        );

   -- Clock process definitions
   Sys_Clk_process :process
   begin
		Sys_Clk <= '0';
		wait for Sys_Clk_period/2;
		Sys_Clk <= '1';
		wait for Sys_Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for Sys_Clk_period*10;
		ShiftRows_In 	<= X"d42711aee0bf98f1b8b45de51e415230";
		CORRECT_OUTPUT <= X"d4bf5d30e0b452aeb84111f11e2798e5";
		wait for 20 ns;
		ShiftRows_In 	<= X"49ded28945db96f17f39871a7702533b";
		CORRECT_OUTPUT <= X"49db873b453953897f02d2f177de961a";		
      wait;
   end process;

END;
