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
--
-- Create Date:    18:24:24 02/10/2010 
-- Design Name: 
-- Module Name:    AES_128 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: ISE 11.1
-- Description: AES Forward cipher with 128 bit key. Encrypts one 128-bit block of plaintext at a time. Load key on KEY_IN with KEY_LOAD
--              Load Data and start encryption with START. BUSY shows core is encrypting. NEAR_DONE shows core is one cycle from completion.
--					 DONE shows that core is finished cipher and valid ciphertext data is present on CIPHERTEXT_OUT.
--					 Input to Output latency is 41 clock cycles.
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

entity AES_128_ENCRYPT is
    Port ( 	SYS_CLK,RST : in STD_LOGIC;
				PLAINTEXT_IN : in  STD_LOGIC_VECTOR (127 downto 0);
				KEY_IN : in  STD_LOGIC_VECTOR (127 downto 0);
				START : in  STD_LOGIC;
				KEY_LOAD : in  STD_LOGIC;
				NEAR_DONE : out  STD_LOGIC;
				DONE : out  STD_LOGIC;
				BUSY : out  STD_LOGIC;
 				CIPHERTEXT_OUT : out  STD_LOGIC_VECTOR (127 downto 0));
end AES_128_ENCRYPT;

architecture Behavioral of AES_128_ENCRYPT is

----Sub Components Definitions
COMPONENT Key_Schedule_128
	PORT(
		SYS_CLK : IN std_logic;
		RST : IN std_logic;
		KEY_128 : IN std_logic_vector(127 downto 0);
		LOAD_KEY : IN std_logic;
		EXP_KEY : IN std_logic;          
		PAR_KEY : OUT std_logic_vector(127 downto 0)
		);
	END COMPONENT;

COMPONENT SubBytes
	PORT(
		SubBytes_IN : IN std_logic_vector(127 downto 0);
		SYS_CLK : IN std_logic;
		RST : IN std_logic;          
		SubBytes_OUT : OUT std_logic_vector(127 downto 0)
		);
	END COMPONENT;

COMPONENT ShiftRows
	PORT(
		ShiftRows_In : IN std_logic_vector(127 downto 0);
		Sys_Clk : IN std_logic;
		RST : IN std_logic;          
		ShiftRows_Out : OUT std_logic_vector(127 downto 0)
		);
	END COMPONENT;

COMPONENT MixColumns
	PORT(
		SYS_CLK : IN std_logic;
		RST : IN std_logic;
		DATA_IN : IN std_logic_vector(127 downto 0);          
		DATA_OUT : OUT std_logic_vector(127 downto 0)
		);
	END COMPONENT;

COMPONENT AddRoundKey
	PORT(
		Data_IN : IN std_logic_vector(127 downto 0);
		Key_IN : IN std_logic_vector(127 downto 0);
		SYS_CLK : IN std_logic;
		RST : IN std_logic;          
		Data_OUT : OUT std_logic_vector(127 downto 0)
		);
	END COMPONENT;
----End Sub Components Definitions

type state is (RESET_1,RESET_2,IDLE,PROCESSING);  
signal pr_state,nx_state : state ;

SIGNAL RST_BUF : STD_LOGIC := '0';
SIGNAL BUSY_BUF : STD_LOGIC := '0';
SIGNAL PLAINTEXT_BUFFER : STD_LOGIC_VECTOR(127 downto 0) := (OTHERS => '0');

SIGNAL OPN_COUNT : STD_LOGIC_VECTOR(1 downto 0) := "00";
SIGNAL RND_COUNT : STD_LOGIC_VECTOR(3 downto 0) := "0000";
SIGNAL RND_MUX_CNTRL  : STD_LOGIC_VECTOR(1 downto 0) := "00";
 
SIGNAL KEY_BUF : STD_LOGIC_VECTOR(127 downto 0) := (OTHERS => '0');
SIGNAL SubBytes_IN_BUF : STD_LOGIC_VECTOR(127 downto 0) := (OTHERS => '0');
SIGNAL SubBytes_OUT_BUF : STD_LOGIC_VECTOR(127 downto 0) := (OTHERS => '0');
SIGNAL ShiftRows_IN_BUF : STD_LOGIC_VECTOR(127 downto 0) := (OTHERS => '0');
SIGNAL ShiftRows_OUT_BUF : STD_LOGIC_VECTOR(127 downto 0) := (OTHERS => '0');
SIGNAL MixColumns_IN_BUF : STD_LOGIC_VECTOR(127 downto 0) := (OTHERS => '0');
SIGNAL MixColumns_OUT_BUF : STD_LOGIC_VECTOR(127 downto 0) := (OTHERS => '0');
SIGNAL AddRoundKey_IN_BUF : STD_LOGIC_VECTOR(127 downto 0) := (OTHERS => '0');
SIGNAL AddRoundKey_OUT_BUF : STD_LOGIC_VECTOR(127 downto 0) := (OTHERS => '0');

begin

--Instantiate Sub-Components
INST_Key_Schedule_128: Key_Schedule_128 PORT MAP(
		SYS_CLK => SYS_CLK,
		RST => RST_BUF,
		KEY_128 => KEY_IN,
		PAR_KEY => KEY_BUF,
		LOAD_KEY => KEY_LOAD,
		EXP_KEY => BUSY_BUF
	);
	
INST_SubBytes: SubBytes PORT MAP(
		SubBytes_IN => SubBytes_IN_BUF,
		SubBytes_OUT => SubBytes_OUT_BUF,
		SYS_CLK => SYS_CLK,
		RST => RST_BUF
	);

INST_ShiftRows: ShiftRows PORT MAP(
		ShiftRows_In => ShiftRows_IN_BUF,
		ShiftRows_Out => ShiftRows_OUT_BUF,
		Sys_Clk => SYS_CLK,
		RST => RST_BUF
	);	

INST_MixColumns: MixColumns PORT MAP(
		SYS_CLK => SYS_CLK,
		RST => RST_BUF,
		DATA_IN => MixColumns_IN_BUF,
		DATA_OUT => MixColumns_OUT_BUF 
	);

INST_AddRoundKey: AddRoundKey PORT MAP(
		Data_IN => AddRoundKey_IN_BUF,
		Key_IN => KEY_BUF,
		Data_OUT => AddRoundKey_OUT_BUF,
		SYS_CLK => SYS_CLK,
		RST => RST_BUF
	);
-----END Component Instatiation

STATE_MACHINE_HEAD : PROCESS (SYS_CLK) ----State Machine Master Control
begin
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (RST = '1') then
			pr_state <= RESET_1;
		ELSE
			pr_state <= nx_state;
		END IF;
	END IF;
END PROCESS;

STATE_MACHINE_BODY : PROCESS (START,OPN_COUNT,RND_COUNT, pr_state) ---State Machine State Definitions
begin
	CASE pr_state is
		
		WHEN RESET_1 =>  --Master Reset State
			RST_BUF <= '1';
			BUSY_BUF  <= '0';
			nx_state <= RESET_2;

		WHEN RESET_2 =>  --Extra Reset State to prevent reset glitching
			RST_BUF <= '1';
			BUSY_BUF  <= '0';
			nx_state <= IDLE;

		WHEN IDLE =>   --Waiting for Key Load or Data/Start assertion
			RST_BUF <= '0';
			BUSY_BUF  <= '0';
			IF (START = '1') then
				nx_state <= PROCESSING;
			ELSE
				nx_state <= IDLE;
			END IF;	
				
		WHEN PROCESSING =>   --Enable step/round counters
			RST_BUF <= '0';
			BUSY_BUF  <= '1';
			IF (OPN_COUNT = "11" AND  RND_COUNT = X"A") then
				nx_state <= IDLE;
			ELSE
				nx_state <= PROCESSING;
			END IF;
	END CASE;
END PROCESS;	
				

OPERATIONS_COUNTER : PROCESS (SYS_CLK)  ----Counts through each step and each round of cipher sequence, affects data path mux and state machine
begin	
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (PR_STATE = RESET_1 OR PR_STATE = RESET_2 OR PR_STATE = IDLE) then
			OPN_COUNT <= "11";   --Step Counter Starts on 3 to correspond to AddRoundKey step at very start of cipher
			RND_COUNT <= "0000";
		ELSE
			OPN_COUNT <= OPN_COUNT + 1;   ---Always increment when processing
			IF OPN_COUNT = "11" then     ---Increment at the last step of a round
				RND_COUNT <= RND_COUNT + 1;
			END IF;
		END IF;
	END IF;
END PROCESS;



CIPHER_TEXT_OUTPUT_REGISTER : PROCESS(SYS_CLK)   --Output Latch for ciphertext
begin
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (PR_STATE = RESET_1 OR PR_STATE = RESET_2) then
			CIPHERTEXT_OUT <= (OTHERS => '0');
		ELSIF (OPN_COUNT = "11" AND  RND_COUNT = X"A") then
			CIPHERTEXT_OUT <= AddRoundKey_OUT_BUF;
		END IF;
	END IF;
END PROCESS;

ENCRYPT_DONE_SIGNAL_LATCH : PROCESS(SYS_CLK) ----Single Pulse Signal when cipher is complete and output data is valid
begin
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (OPN_COUNT = "11" AND  RND_COUNT = X"A") then
			DONE <= '1';
		ELSE
			DONE <= '0';
		END IF;
	END IF;
END PROCESS;


NEARLY_DONE_SIGNAL_LATCH : PROCESS(SYS_CLK)   -----Single Pule Signal when cipher is one clock cycle from completion: possiible trigger for continous loading
begin
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (OPN_COUNT = "10" AND  RND_COUNT = X"A") then
			NEAR_DONE <= '1';
		ELSE
			NEAR_DONE <= '0';
		END IF;
	END IF;
END PROCESS;


DATA_PATH_MUX_CONTROL : PROCESS(SYS_CLK)    
begin
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (PR_STATE = RESET_1 OR PR_STATE = RESET_2 OR PR_STATE = IDLE) then
			RND_MUX_CNTRL <= "00";
		ELSIF (OPN_COUNT = "00" AND  RND_COUNT = X"1") then
			RND_MUX_CNTRL <= "01";
		ELSIF (OPN_COUNT = "11" AND  RND_COUNT = X"9") then
			RND_MUX_CNTRL <= "11";
		END IF;
	END IF;
END PROCESS;

PLAINTEXT_INPUT_REGISTER : PROCESS(SYS_CLK)
begin
	IF (SYS_CLK'event and SYS_CLK='1') then
		IF (RST = '1') then
			PLAINTEXT_BUFFER <= (OTHERS => '0');
		ELSIF (START = '1' AND PR_STATE = IDLE) then
			PLAINTEXT_BUFFER <= PLAINTEXT_IN;
		END IF;
	END IF;
END PROCESS;	
			
			
		

			
-----Async Signals-------------------			
			
DATA_PATH_MUTIPLEXER : PROCESS (RND_MUX_CNTRL,ShiftRows_OUT_BUF,MixColumns_OUT_BUF,PLAINTEXT_BUFFER)  ---Changes input to AddRoundKEy based on state of cipher
begin				
	CASE RND_MUX_CNTRL IS
		WHEN "00" =>
			AddRoundKey_IN_BUF 	<=	PLAINTEXT_BUFFER;
		WHEN "01" =>
			AddRoundKey_IN_BUF 	<= MixColumns_OUT_BUF;
		WHEN "11" =>
			AddRoundKey_IN_BUF 	<= ShiftRows_OUT_BUF;	
		when others =>
			AddRoundKey_IN_BUF 	<= MixColumns_OUT_BUF;

	END CASE;
END PROCESS;	
			
-----Set Core to Look BUSY during reset without actually asserting BUSY_BUF
BUSY_OUTPUT_MUX : PROCESS (BUSY_BUF,pr_state)
begin
	IF (PR_STATE = RESET_1 OR PR_STATE = RESET_2) then
		BUSY <= '1';
	ELSE	
		BUSY <= BUSY_BUF;
	END IF;
END PROCESS;

---Fixed Pipeline Connections
SubBytes_IN_BUF 	<= AddRoundKey_OUT_BUF; 
ShiftRows_IN_BUF 	<= SubBytes_OUT_BUF;
MixColumns_IN_BUF <= ShiftRows_OUT_BUF;

-----END Async Signals-------------------	
			
end Behavioral;

