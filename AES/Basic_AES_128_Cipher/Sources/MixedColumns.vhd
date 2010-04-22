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
-- Description:  Instait
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

entity MixColumns is
    Port ( SYS_CLK,RST : in  STD_LOGIC;
           DATA_IN : in  STD_LOGIC_VECTOR (127 downto 0);
           DATA_OUT : out  STD_LOGIC_VECTOR (127 downto 0));
end MixColumns;

architecture Behavioral of MixColumns is
COMPONENT Column_Matrix_Mul
	PORT(
		SYS_CLK : IN std_logic;
		RST : IN std_logic;
		COLUMN_IN : IN std_logic_vector(31 downto 0);          
		COLUMN_OUT : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

begin

	Column_Matrix_Mul_0: Column_Matrix_Mul PORT MAP(
		SYS_CLK => SYS_CLK,
		RST => RST,
		COLUMN_IN => DATA_IN(127 downto 96),
		COLUMN_OUT => DATA_OUT(127 downto 96)
	);
	
	Column_Matrix_Mul_1 : Column_Matrix_Mul PORT MAP(
		SYS_CLK => SYS_CLK,
		RST => RST,
		COLUMN_IN => DATA_IN(95 downto 64),
		COLUMN_OUT => DATA_OUT(95 downto 64)
	);
	
	Column_Matrix_Mul_2: Column_Matrix_Mul PORT MAP(
		SYS_CLK => SYS_CLK,
		RST => RST,
		COLUMN_IN => DATA_IN(63 downto 32),
		COLUMN_OUT => DATA_OUT(63 downto 32)
	);
	
	Column_Matrix_Mul_3: Column_Matrix_Mul PORT MAP(
		SYS_CLK => SYS_CLK,
		RST => RST,
		COLUMN_IN => DATA_IN(31 downto 0),
		COLUMN_OUT => DATA_OUT(31 downto 0)
	);

end Behavioral;

