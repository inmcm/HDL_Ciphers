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
-- Create Date:   21:22:33 02/17/2010
-- Design Name:   
-- Module Name:   C:/PROJECTS/AES_CORE/TestBenches/AES_128_ENCRYPY_TB.vhd
-- Project Name:  AES_CORE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AES_128_ENCRYPT
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
 
ENTITY AES_128_ENCRYPY_TB IS
END AES_128_ENCRYPY_TB;
 
ARCHITECTURE behavior OF AES_128_ENCRYPY_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AES_128_ENCRYPT
    PORT(
         SYS_CLK : IN  std_logic;
         RST : IN  std_logic;
         PLAINTEXT_IN : IN  std_logic_vector(127 downto 0);
         KEY_IN : IN  std_logic_vector(127 downto 0);
         START : IN  std_logic;
         KEY_LOAD : IN  std_logic;
         NEAR_DONE : OUT  std_logic;
         DONE : OUT  std_logic;
         BUSY : OUT  std_logic;
         CIPHERTEXT_OUT : OUT  std_logic_vector(127 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal SYS_CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal PLAINTEXT_IN : std_logic_vector(127 downto 0) := (others => '0');
   signal KEY_IN : std_logic_vector(127 downto 0) := (others => '0');
   signal START : std_logic := '0';
   signal KEY_LOAD : std_logic := '0';

 	--Outputs
   signal NEAR_DONE : std_logic;
   signal DONE : std_logic;
   signal BUSY : std_logic;
   signal CIPHERTEXT_OUT : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant SYS_CLK_period : time := 8 ns;
	
	SIGNAL CORRECT_OUTPUT : std_logic_vector(127 downto 0) := (others => '0');
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AES_128_ENCRYPT PORT MAP (
          SYS_CLK => SYS_CLK,
          RST => RST,
          PLAINTEXT_IN => PLAINTEXT_IN,
          KEY_IN => KEY_IN,
          START => START,
          KEY_LOAD => KEY_LOAD,
          NEAR_DONE => NEAR_DONE,
          DONE => DONE,
          BUSY => BUSY,
          CIPHERTEXT_OUT => CIPHERTEXT_OUT
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
		KEY_IN <= X"2b7e151628aed2a6abf7158809cf4f3c";
		KEY_LOAD <= '1';
		wait for SYS_CLK_period;
		KEY_LOAD <= '0';
		wait for SYS_CLK_period;
		wait for SYS_CLK_period;
		PLAINTEXT_IN 	<= X"3243f6a8885a308d313198a2e0370734";
		CORRECT_OUTPUT <= X"3925841d02dc09fbdc118597196a0b32";
		START <= '1';
		wait for SYS_CLK_period;
		START <= '0';
		wait for SYS_CLK_period*45;
		KEY_IN <= X"000102030405060708090A0B0C0D0E0F";
		KEY_LOAD <= '1';
		wait for SYS_CLK_period;
		KEY_LOAD <= '0';
		PLAINTEXT_IN 	<= X"00112233445566778899AABBCCDDEEFF";
		CORRECT_OUTPUT <= X"69c4e0d86a7b0430d8cdb78070b4c55a";	
		START <= '1';
		
		wait for SYS_CLK_period;
		START <= '0';
		wait for SYS_CLK_period*45;
		KEY_IN <= X"00000000000000000000000000000000";
		KEY_LOAD <= '1';
		wait for SYS_CLK_period;
		KEY_LOAD <= '0';
		PLAINTEXT_IN 	<= X"f34481ec3cc627bacd5dc3fb08f273e6";
		CORRECT_OUTPUT <= X"0336763e966d92595a567cc9ce537f5e";	
		START <= '1';
		
		wait for SYS_CLK_period;
		START <= '0';
		wait for SYS_CLK_period*45;
		KEY_IN <= X"10a58869d74be5a374cf867cfb473859";
		KEY_LOAD <= '1';
		wait for SYS_CLK_period;
		KEY_LOAD <= '0';
		PLAINTEXT_IN 	<= X"00000000000000000000000000000000";
		CORRECT_OUTPUT <= X"6d251e6944b051e04eaa6fb4dbf78465";	
		START <= '1';
		
		wait for SYS_CLK_period;
		START <= '0';
		wait for SYS_CLK_period*45;
		KEY_IN <= X"f0000000000000000000000000000000";
		KEY_LOAD <= '1';
		wait for SYS_CLK_period;
		KEY_LOAD <= '0';
		PLAINTEXT_IN 	<= X"00000000000000000000000000000000";
		CORRECT_OUTPUT <= X"970014d634e2b7650777e8e84d03ccd8";	
		START <= '1';
		
		wait for SYS_CLK_period;
		START <= '0';
		wait for SYS_CLK_period*45;
		KEY_IN <= X"00000000000000000000000000000000";
		KEY_LOAD <= '1';
		wait for SYS_CLK_period;
		KEY_LOAD <= '0';
		PLAINTEXT_IN 	<= X"00000000000000000000000000000000";
		CORRECT_OUTPUT <= X"66e94bd4ef8a2c3b884cfa59ca342b2e";
		START <= '1';
		
		wait for SYS_CLK_period;    ---Examples of Continuous Loading
		START <= '0';
		wait for SYS_CLK_period*5;
		KEY_IN <= X"E8E9EAEBEDEEEFF0F2F3F4F5F7F8F9FA";
		KEY_LOAD <= '1';
		PLAINTEXT_IN 	<= X"014BAF2278A69D331D5180103643E99A";	
		START <= '1';
		wait for SYS_CLK_period*40;
		CORRECT_OUTPUT <= X"6743C3D1519AB4F2CD9A78AB09A511BD";
		wait for SYS_CLK_period*5;
		KEY_IN <= X"08090A0B0D0E0F10121314151718191A";
		PLAINTEXT_IN 	<= X"5601d73909781b936e58ee7427e3559d";
		wait for SYS_CLK_period*40;
		CORRECT_OUTPUT <= X"00000000000000000000000000000000";
		
		
		wait;
   end process;

END;
