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
-- Create Date:    21:29:42 02/09/2010 
-- Design Name: 
-- Module Name:    SubBytes - Behavioral 
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
use work.AES_CONSTANTS.all;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SubBytes is
    Port ( SubBytes_IN : in  STD_LOGIC_VECTOR (127 downto 0);
           SubBytes_OUT : out  STD_LOGIC_VECTOR (127 downto 0);
           SYS_CLK,RST : in  STD_LOGIC);
end SubBytes;

architecture Behavioral of SubBytes is
SIGNAL SUB_BYTES_BUF : STD_LOGIC_VECTOR (127 downto 0) := (OTHERS => '0');
begin
SBOX_BYTE_SUBSTITUTION : PROCESS(SYS_CLK)
begin
	IF (SYS_CLK'event AND SYS_CLK ='1') then
		IF RST = '1' then
			SubBytes_OUT <= (OTHERS => '0');
		ELSE	
			SubBytes_OUT <= SUB_BYTES_BUF; 
		END IF;	
	END IF;
END PROCESS;	

SUB_ARRAY :  For i in 0 to 15 generate
      begin
			SUB_BYTES_BUF((((i+1)*8)-1) downto(i*8)) <= SBOX(conv_integer(SubBytes_IN((((i+1)*8)-1) downto(i*8)))); 
		end generate;

end Behavioral;

