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
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:57:24 01/14/2011 
-- Design Name: 
-- Module Name:    Trivium_Generator - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Trivium_Generator is
	 Generic ( width : integer := 8 );
	 
    Port ( SYS_CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           PLAINTEXT_IN : in  STD_LOGIC_VECTOR ((width - 1) downto 0);
           CIPHERTEXT_OUT : out  STD_LOGIC_VECTOR ((width - 1) downto 0);
			  IV_INPUT : in  STD_LOGIC_VECTOR (79 downto 0);
           PLNTXT_EN : in  STD_LOGIC;
           CPHRTXT_RDY : out  STD_LOGIC);
end Trivium_Generator;

architecture Behavioral of Trivium_Generator is

------------------------------
---Trivium Core Definition----
------------------------------
COMPONENT TRIVIUM_CORE
	PORT(
		SYS_CLK : IN std_logic;
		CNTRL : IN std_logic_vector(1 downto 0);
		KEY : IN std_logic_vector(79 downto 0);
		IV : IN std_logic_vector(79 downto 0);          
		KEY_OUT : OUT std_logic
		);
	END COMPONENT;
	
--State Machine Signals--
type state is (RESET_1,RESET_2,LOAD_KEY_IV,INIT_CYCLES,OUTPUT_PRIME,OPERATIONAL);  
signal pr_state,nx_state : state ;

SIGNAL CORE_OUT : STD_LOGIC_VECTOR((width - 1) downto 0);
SIGNAL CORE_CNTRL : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL INIT_COUNTER : integer range 0 to 2047 := 0;


----System contstants
CONSTANT INIT_LIMIT : integer range 0 to 2047 := 1152; --Define the number of cycles to run the cores for till they are ready for real operation

TYPE ARRAY_32x80 is ARRAY (0 to 31) of STD_LOGIC_VECTOR(79 downto 0); ----32x80 bit Array
CONSTANT KEY_ARRAY : ARRAY_32x80 :=   (X"0F62B5085BAE0154A7FA",
													--X"233c0ce3541df86a6695",   ---Array of 32 80-bit keys ready to use
													X"9b36bc33af83d17be838",	---These keys were generated at random.org, so.....they are random
													X"52b9f96c72e101bce602",   ---Instainted cores will use them sequential up to 32 cores
													X"8ad8e295ec06031e8efb",   ---Unused keys will be dicarded during synthesis
													X"207c79ed60a3fc18ced0",
													X"3593832d8b33df0d2bbb",
													X"dbb5a27bec93c5ee5282",   ---You would want to keep this array secret :)
													X"689a5a8c8b761a35f19b",
													X"491d41213630a6ab3f6d",
													X"3c2cb7daf7412b6d26f9",
													X"6453a399ded33f1fb27b",
													X"4031370361101b945f4b",
													X"ab4495d448a01657bab2",
													X"762cf4d87983fc68d917",
													X"4364aa24e5f096d85c0f",
													X"5b2ef8e7efd2111e1fd3",
													X"1c16186c7e4d1c8a7e99",
													X"780ae0c21e75801b4b80",
													X"b39d0866ef5659277037",
													X"cc8d7a52c6763cfc3625",
													X"9c3e8ec827a095fd4b2a",
													X"18d1d473575f0eaafabe",
													X"6e2bb8cbda3aaf57e4eb",
													X"a97fc93e2d5faa9dbb5c",
													X"eab767180704cfa68a52",
													X"399d4a6529323de8c2b9",
													X"afeb8f32cc4dd5a9e5db",
													X"d69e0a21cc091c7a616f",
													X"a9230d0e46aa604d3bdb",
													X"a4c0f43d60dd7c3fba6c",
													X"a538c3c110243df3c833",
													X"87562c95c51c7579ed97");

	
begin

TRIV_CORE_GEN : for i in 0 to (width-1) generate ---Generate the correct number (set via width) of trivium cores, up to 32

Inst_TRIVIUM_CORE_X: TRIVIUM_CORE PORT MAP(
		SYS_CLK => SYS_CLK ,
		CNTRL => CORE_CNTRL,
		KEY => KEY_ARRAY(i),  ---Key values are sequentially assinged from KEY_ARRAY based on core #, 
		IV => IV_INPUT,
		KEY_OUT => CORE_OUT(i)
	);
end generate;	
	
STATE_MACHINE_HEAD : PROCESS (SYS_CLK) ----State Machine Master Control
begin
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (RST = '1') then   --Synchronous reset
			pr_state <= RESET_1;
		ELSE
			pr_state <= nx_state;
		END IF;
	END IF;
END PROCESS;

STATE_MACHINE_BODY : PROCESS (pr_state,INIT_COUNTER) ---State Machine State Definitions
begin
	CASE pr_state is
		
		WHEN RESET_1 =>  --Master Reset State
			nx_state <= RESET_2;

		WHEN RESET_2 =>  --Extra Reset State to prevent reset glitching
			nx_state <= LOAD_KEY_IV;

		WHEN LOAD_KEY_IV =>   --Load secret keys and IV into cores
			nx_state <= INIT_CYCLES;	
				
		WHEN INIT_CYCLES =>   --Enable cores to cycle thru four times for standard intialization period
			IF (INIT_COUNTER = (INIT_LIMIT - 1)) then
				nx_state <=  OUTPUT_PRIME;
			ELSE
				nx_state <=INIT_CYCLES;
			END IF;
		WHEN OUTPUT_PRIME =>
			nx_state <=  OPERATIONAL;

		WHEN OPERATIONAL =>
			nx_state <= OPERATIONAL;
			
	END CASE;
END PROCESS;	
				

CORE_CONTROL_REGISTER : PROCESS (SYS_CLK)
begin
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (PR_STATE = RESET_1 OR PR_STATE = RESET_2) then
			CORE_CNTRL <= "00";
		ELSIF (PR_STATE = LOAD_KEY_IV) then
			CORE_CNTRL <= "10";
		ELSIF (PR_STATE = INIT_CYCLES) then
			CORE_CNTRL <= "11";			
		ELSIF (PR_STATE = OUTPUT_PRIME) then
			CORE_CNTRL <= "01";
		ELSIF (PR_STATE = OPERATIONAL) then
			IF (PLNTXT_EN = '1') then
				CORE_CNTRL <= "01";
			ELSE
				CORE_CNTRL <= "00";
			END IF;	
		END IF;
	END IF;
END PROCESS;	
	


INITIALIZATION_COUNTER : PROCESS (SYS_CLK)  ----Counts cycles for init time, nominally 1152
begin	
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (PR_STATE = RESET_1 OR PR_STATE = RESET_2) then
			INIT_COUNTER <= 0;
		ELSIF (PR_STATE = INIT_CYCLES) then
			INIT_COUNTER <= INIT_COUNTER + 1;
		END IF;
	END IF;
END PROCESS;	
	
	
	
	
	
CIPHER_OUTPUT : PROCESS (SYS_CLK)  ----Controls cipher text ouput register and its status register	
begin
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (PR_STATE = RESET_1 OR PR_STATE = RESET_2) then	
			CIPHERTEXT_OUT <= (OTHERS => '0');
			CPHRTXT_RDY  	<= '0';
			
		ELSIF	 (PR_STATE = OPERATIONAL) then
			IF (PLNTXT_EN = '1') then
				CIPHERTEXT_OUT <= CORE_OUT XOR PLAINTEXT_IN; 	
				CPHRTXT_RDY  	<= '1';
			ELSE
				CPHRTXT_RDY  	<= '0';
			END IF;
		END IF;
	END IF;
END PROCESS;
	
	
	
	
	
	

end Behavioral;

