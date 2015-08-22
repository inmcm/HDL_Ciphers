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
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:00:04 03/20/2010 
-- Design Name: 
-- Module Name:    GALOIS_MUL2_4 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GALOIS_MUL2_4 is
    Port ( SYS_CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           A_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           B_IN : in  STD_LOGIC_VECTOR (3 downto 0);
           C_OUT : out  STD_LOGIC_VECTOR (3 downto 0));
end GALOIS_MUL2_4;

architecture Behavioral of GALOIS_MUL2_4 is
SIGNAL CRUMB_1 		: STD_LOGIC_VECTOR(1 downto 0); ---CRUMBS are two bit vectors. Get it? bit, nibble, byte and CRUMB!! HAHA!!
SIGNAL CRUMB_2 		: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL CRUMB_3 		: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL CRUMB_4 		: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL GAL2_ADD_1 	: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL GAL2_ADD_2 	: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL GAL2_ADD_3 	: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL GAL2_ADD_4 	: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL GAL2_MUL_1 	: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL GAL2_MUL_2 	: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL GAL2_MUL_3 	: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL GAL2_MUL_PHI 	: STD_LOGIC_VECTOR(1 downto 0);



SIGNAL PLREG1	: STD_LOGIC_VECTOR(1 downto 0) := "00";
SIGNAL PLREG2	: STD_LOGIC_VECTOR(1 downto 0) := "00";
SIGNAL PLREG3	: STD_LOGIC_VECTOR(1 downto 0) := "00";

begin
-----Pipeling Happens after the Multiply Array
PIPE_LINE_REG : PROCESS(SYS_CLK)
begin
	IF (SYS_CLK'event and SYS_CLK = '1') then
		IF (RST = '1') then
			PLREG1 <= "00";
			PLREG2 <= "00";
			PLREG3 <= "00";
		ELSE
			PLREG1 <= GAL2_MUL_1;
			PLREG2 <= GAL2_MUL_2;
			PLREG3 <= GAL2_MUL_3;
		END IF;
	END IF;
END PROCESS;	

-----Stage 1 Calculations
CRUMB_1 <= A_IN(3 downto 2);
CRUMB_2 <= A_IN(1 downto 0);
CRUMB_3 <= B_IN(3 downto 2);
CRUMB_4 <= B_IN(1 downto 0); 
GAL2_ADD_1 	<= CRUMB_1 XOR CRUMB_2;
GAL2_ADD_2 	<= CRUMB_3 XOR CRUMB_4;
GAL2_MUL_1 	<= ((CRUMB_1(1) AND CRUMB_3(1)) XOR (CRUMB_1(0) AND CRUMB_3(1)) XOR (CRUMB_1(1) AND CRUMB_3(0))) &
					((CRUMB_1(1) AND CRUMB_3(1)) XOR (CRUMB_1(0) AND CRUMB_3(0)));
GAL2_MUL_2 	<= ((GAL2_ADD_1(1) AND GAL2_ADD_2(1)) XOR (GAL2_ADD_1(0) AND GAL2_ADD_2(1)) XOR (GAL2_ADD_1(1) AND GAL2_ADD_2(0))) &
					((GAL2_ADD_1(1) AND GAL2_ADD_2(1)) XOR (GAL2_ADD_1(0) AND GAL2_ADD_2(0)));
GAL2_MUL_3 	<=((CRUMB_2(1) AND CRUMB_4(1)) XOR (CRUMB_2(0) AND CRUMB_4(1)) XOR (CRUMB_2(1) AND CRUMB_4(0))) &
					((CRUMB_2(1) AND CRUMB_4(1)) XOR (CRUMB_2(0) AND CRUMB_4(0)));

--------Stage 2 Calculations

GAL2_MUL_PHI  <= (PLREG1(1) XOR PLREG1(0)) & PLREG1(1); 
GAL2_ADD_3 	<= PLREG2 XOR PLREG3;
GAL2_ADD_4 	<= PLREG3 XOR GAL2_MUL_PHI;
C_OUT  <=  GAL2_ADD_3 & GAL2_ADD_4; 

end Behavioral;

