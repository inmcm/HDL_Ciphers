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
-- Create Date:   19:07:09 01/23/2011
-- Design Name:   
-- Module Name:   C:/Users/INMCM/Docs/Projects_Code/TRIVIUM/Trivium_Generator_TB.vhd
-- Project Name:  TRIVIUM
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Trivium_Generator
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Trivium_Generator_TB IS
END Trivium_Generator_TB;
 
ARCHITECTURE behavior OF Trivium_Generator_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Trivium_Generator
    PORT(
         SYS_CLK : IN  std_logic;
         RST : IN  std_logic;
         PLAINTEXT_IN : IN  std_logic_vector(7 downto 0);
         CIPHERTEXT_OUT : OUT  std_logic_vector(7 downto 0);
         IV_INPUT : IN  std_logic_vector(79 downto 0);
         PLNTXT_EN : IN  std_logic;
         CPHRTXT_RDY : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal SYS_CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal PLAINTEXT_IN : std_logic_vector(7 downto 0) := (others => '0');
   signal IV_INPUT : std_logic_vector(79 downto 0) := X"288FF65DC42B92F960C7";
   signal PLNTXT_EN : std_logic := '0';

 	--Outputs
   signal CIPHERTEXT_OUT : std_logic_vector(7 downto 0);
   signal CPHRTXT_RDY : std_logic;

   -- Clock period definitions
   constant SYS_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Trivium_Generator PORT MAP (
          SYS_CLK => SYS_CLK,
          RST => RST,
          PLAINTEXT_IN => PLAINTEXT_IN,
          CIPHERTEXT_OUT => CIPHERTEXT_OUT,
          IV_INPUT => IV_INPUT,
          PLNTXT_EN => PLNTXT_EN,
          CPHRTXT_RDY => CPHRTXT_RDY
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
		PLNTXT_EN <= '1';

      wait;
   end process;

END;
