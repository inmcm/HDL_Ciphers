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
-- Create Date:   23:09:36 03/19/2010
-- Design Name:   
-- Module Name:   C:/PROJECTS/AES_CORE/TestBenches/DYN_SBOX_PIPE_TB.vhd
-- Project Name:  AES_CORE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DYN_SBOX_PIPE
-- 
-- Dependencies: Testbench for 7 Stage Pipeline Design
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
 
ENTITY DYN_SBOX_PIPE2_TB IS
END DYN_SBOX_PIPE2_TB;
 
ARCHITECTURE behavior OF DYN_SBOX_PIPE2_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DYN_SBOX_7STAGE
    PORT(
         SYS_CLK : IN  std_logic;
         RST : IN  std_logic;
         BYTE_IN : IN  std_logic_vector(7 downto 0);
         SUB_BYTE_OUT : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal SYS_CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal BYTE_IN : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal SUB_BYTE_OUT : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant SYS_CLK_period : time := 10 ns;
	
	signal CORRECT_OUTPUT :  std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DYN_SBOX_7STAGE PORT MAP (
          SYS_CLK => SYS_CLK,
          RST => RST,
          BYTE_IN => BYTE_IN,
          SUB_BYTE_OUT => SUB_BYTE_OUT
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
		CORRECT_OUTPUT <= X"63";
      wait for 120 ns;	
		BYTE_IN <= X"04";
		CORRECT_OUTPUT <= X"F2";
		wait for 120 ns;	
		BYTE_IN <= X"0f";
		CORRECT_OUTPUT <= X"76";
		wait for 120 ns;	
		BYTE_IN <= X"01";
		CORRECT_OUTPUT <= X"7c";
		wait for 120 ns;	
		BYTE_IN <= X"FF";
		CORRECT_OUTPUT <= X"16";
		wait for 120 ns;	
		BYTE_IN <= X"77";
		CORRECT_OUTPUT <= X"F5";
		wait for 120 ns;	
		BYTE_IN <= X"CB";
		CORRECT_OUTPUT <= X"1F";
		wait for 120 ns;
		
		BYTE_IN <= X"10";   -----Several Values in rapid succesion to test pipelineing
		CORRECT_OUTPUT <= X"00";
		wait for 10 ns;
		BYTE_IN <= X"20";
		wait for 10 ns;
		BYTE_IN <= X"30";
		wait for 10 ns;
		BYTE_IN <= X"40";
		wait for 10 ns;
		BYTE_IN <= X"50";
		wait for 10 ns;
		BYTE_IN <= X"60";
		wait for 10 ns;
		BYTE_IN <= X"70";
		wait for 5 ns;
		CORRECT_OUTPUT <= X"CA";
		wait for 5 ns;
		BYTE_IN <= X"80";
		wait for 5 ns;
		CORRECT_OUTPUT <= X"b7";
		wait for 5 ns;
		BYTE_IN <= X"90";		
		wait for 5 ns;
		CORRECT_OUTPUT <= X"04";
		wait for 5 ns;
		BYTE_IN <= X"A0";		
		wait for 5 ns;
		CORRECT_OUTPUT <= X"09";
		wait for 5 ns;
		BYTE_IN <= X"B0";
		wait for 5 ns;
		CORRECT_OUTPUT <= X"53";
		wait for 5 ns;
		BYTE_IN <= X"C0";
		wait for 5 ns;
		CORRECT_OUTPUT <= X"D0";
		wait for 5 ns;
		BYTE_IN <= X"D0";
		wait for 5 ns;
		CORRECT_OUTPUT <= X"51";
		wait for 5 ns;
		BYTE_IN <= X"E0";
		wait for 5 ns;
		CORRECT_OUTPUT <= X"CD";
		wait for 5 ns;
		BYTE_IN <= X"F0";
		wait for 5 ns;
		CORRECT_OUTPUT <= X"60";
		wait for 10 ns;
		CORRECT_OUTPUT <= X"E0";
		wait for 10 ns;
		CORRECT_OUTPUT <= X"E7";
		wait for 10 ns;
		CORRECT_OUTPUT <= X"BA";
		wait for 10 ns;
		CORRECT_OUTPUT <= X"70";
		wait for 10 ns;
		CORRECT_OUTPUT <= X"E1";
		wait for 10 ns;
		CORRECT_OUTPUT <= X"8C";
		wait for 10 ns;
		WAIT;
   end process;
END;
