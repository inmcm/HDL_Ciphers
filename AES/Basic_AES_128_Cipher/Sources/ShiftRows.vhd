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
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:42:21 02/09/2010 
-- Design Name: 
-- Module Name:    ShiftRows - Behavioral 
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

entity ShiftRows is
    Port ( ShiftRows_In : in  STD_LOGIC_VECTOR (127 downto 0);
           ShiftRows_Out : out  STD_LOGIC_VECTOR (127 downto 0);
           Sys_Clk,RST : in  STD_LOGIC);
end ShiftRows;

architecture Behavioral of ShiftRows is

begin
SHIFT_ROWS_MIXING : PROCESS(SYS_CLK)
begin
	IF (SYS_CLK'event AND SYS_CLK ='1') then
		IF RST = '1' then
			ShiftRows_Out <= (OTHERS => '0');
		ELSE	
			ShiftRows_Out <= 	ShiftRows_In(127 downto 120) 	&
									ShiftRows_In(87 downto 80)		&
									ShiftRows_In(47 downto 40)		&
									ShiftRows_In(7 downto 0)		&
									
									ShiftRows_In(95 downto 88)		&
									ShiftRows_In(55 downto 48)		&
									ShiftRows_In(15 downto 8)		&
									ShiftRows_In(103 downto 96)	&

									ShiftRows_In(63 downto 56)		&
									ShiftRows_In(23 downto 16)		&
									ShiftRows_In(111 downto 104)	&
									ShiftRows_In(71 downto 64)		&
									
									ShiftRows_In(31 downto 24)		&
									ShiftRows_In(119 downto 112)	&
									ShiftRows_In(79 downto 72)		&
									ShiftRows_In(39 downto 32)		;
		END IF;							
	END IF;
END PROCESS;	

end Behavioral;

