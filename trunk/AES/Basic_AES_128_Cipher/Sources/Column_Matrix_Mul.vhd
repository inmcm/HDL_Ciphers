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
-- Create Date:    21:12:59 02/03/2010 
-- Design Name: 
-- Module Name:    MixedColumns - Behavioral 
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

entity Column_Matrix_Mul is
    Port ( SYS_CLK,RST : in  STD_LOGIC;
           COLUMN_IN : in  STD_LOGIC_VECTOR (31 downto 0);
           COLUMN_OUT : out  STD_LOGIC_VECTOR (31 downto 0));
end Column_Matrix_Mul;

architecture Behavioral of Column_Matrix_Mul is
SIGNAL a0 	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL a0x2 : STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL a0x3 : STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL a1	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL a1x2	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL a1x3	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL a2	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL a2x2	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL a2x3	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL a3	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL a3x2	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');	
SIGNAL a3x3	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');

SIGNAL r0	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL r1	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL r2	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');
SIGNAL r3	: STD_LOGIC_VECTOR(7 downto 0) := (OTHERS => '0');

begin

--Input Column Breakdown
a0 <= COLUMN_IN(31 downto 24);
a1 <= COLUMN_IN(23 downto 16);
a2 <= COLUMN_IN(15 downto 8);
a3 <= COLUMN_IN(7 downto 0);

--Galois Field Multiplications
GaloisXTwo : PROCESS (a0,a1,a2,a3) ---Multiply by 2 in the Galois Field is done with a left shift and a conditional XOR with X"1B" if the MSB is 1
begin
	IF (a0(7) = '1') then    ---Each byte  is it's own conditin
		a0x2 <=(a0(6 downto 0) & '0') XOR X"1B";
	ELSE
		a0x2 <= a0(6 downto 0) & '0';
	END IF;
	
	IF (a1(7) = '1') then
		a1x2 <=(a1(6 downto 0) & '0') XOR X"1B";
	ELSE
		a1x2 <= a1(6 downto 0) & '0';
	END IF;
	
	IF (a2(7) = '1') then
		a2x2 <=(a2(6 downto 0) & '0') XOR X"1B";
	ELSE
		a2x2 <= a2(6 downto 0) & '0';
	END IF;
	
	IF (a3(7) = '1') then
		a3x2 <=(a3(6 downto 0) & '0') XOR X"1B";
	ELSE
		a3x2 <= a3(6 downto 0) & '0';
	END IF;
END PROCESS;	
	
	
--Multiply by 3: Multiply by 3 is done by first doing the Multiply by 2 and then XOR with (equivalent to adding) the original value
a0x3 <= a0x2 XOR a0;
a1x3 <= a1x2 XOR a1;
a2x3 <= a2x2 XOR a2;
a3x3 <= a3x2 XOR a3;


--MixColumns Function
MixColumns : process (SYS_CLK)
begin
	IF (SYS_CLK'event and SYS_CLK = '1') then
		IF RST = '1' then 
			r0 <= X"00";
			r1 <= X"00";
			r2 <= X"00";
			r3 <= X"00";
		ELSE	
			r0 <= a0x2 XOR a1x3 XOR a2 XOR a3; ----Final Sum of products for the matix operation
			r1 <= a1x2 XOR a2x3 XOR a3 XOR a0;
			r2 <= a2x2 XOR a3x3 XOR a0 XOR a1;
			r3 <= a3x2 XOR a0x3 XOR a1 XOR a2;
		END IF;	
	END IF;
END PROCESS;	


----Assemble Output Column
COLUMN_OUT <= r0 & r1 & r2 & r3;


end Behavioral;

