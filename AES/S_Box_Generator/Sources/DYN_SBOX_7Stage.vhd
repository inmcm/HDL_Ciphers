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
-- Create Date:    22:52:11 03/19/2010 
-- Design Name: 
-- Module Name:    DYN_SBOX_7STAGE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Dynamic generation of Rjindael S-Box values from byte input.
--				Design based on combinational logic presented in http://www.xess.com/projects/Rijndael_SBox.pdf
--				This module is highly pipelined with 7 seperate stages including the output latch. 	
--				Interal pipeline registers are named based on their stage (STAGEX_Y).
--				SBox Value for is available 7 clock cycles after input
--
-- Dependencies: GALOIS_MUL2_4.vhd: Galois multiplier module (used as component istead of a function to make it simpler to understand the pipelining)
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


entity DYN_SBOX_7STAGE is
    Port ( SYS_CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           BYTE_IN : in  STD_LOGIC_VECTOR (7 downto 0);
           SUB_BYTE_OUT : out  STD_LOGIC_VECTOR (7 downto 0));
end DYN_SBOX_7STAGE;

architecture Behavioral of DYN_SBOX_7STAGE is
---Pipeline Registers: Named by the by stage number and register number, all registers within a stage are in parallel
SIGNAL STAGE1_1 : STD_LOGIC_VECTOR(3 downto 0) := X"0"; 
SIGNAL STAGE1_2 : STD_LOGIC_VECTOR(3 downto 0) := X"0";	
SIGNAL STAGE1_3 : STD_LOGIC_VECTOR(3 downto 0) := X"0";	

SIGNAL STAGE2_1 : STD_LOGIC_VECTOR(3 downto 0) := X"0";			
SIGNAL STAGE2_2 : STD_LOGIC_VECTOR(3 downto 0) := X"0";			
SIGNAL STAGE2_3 : STD_LOGIC_VECTOR(3 downto 0) := X"0"; 

SIGNAL STAGE3_1 : STD_LOGIC_VECTOR(3 downto 0) := X"0";			
SIGNAL STAGE3_2 : STD_LOGIC_VECTOR(3 downto 0) := X"0";				
SIGNAL STAGE3_3 : STD_LOGIC_VECTOR(3 downto 0) := X"0";			
SIGNAL STAGE3_4 : STD_LOGIC_VECTOR(3 downto 0) := X"0";		

SIGNAL STAGE4_1 : STD_LOGIC_VECTOR(3 downto 0) := X"0";			
SIGNAL STAGE4_2 : STD_LOGIC_VECTOR(3 downto 0) := X"0";			
SIGNAL STAGE4_3 : STD_LOGIC_VECTOR(3 downto 0) := X"0";		

SIGNAL STAGE5_1 : STD_LOGIC_VECTOR(3 downto 0) := X"0"; 	
SIGNAL STAGE5_2 : STD_LOGIC_VECTOR(3 downto 0) := X"0";			



	

SIGNAL OUTPUT_LATCH : STD_LOGIC_VECTOR(7 downto 0) := X"00";


-----Calculation Signals (Named for the operation they represent)
SIGNAL ISOMORPH_MAP : STD_LOGIC_VECTOR(7 downto 0) := X"00";   ----Isomorph Mapping
SIGNAL INV_ISOMORPH_MAP : STD_LOGIC_VECTOR(7 downto 0) := X"00";  ---Inverse Isomorph Mapping
SIGNAL COMP_FIELD_1 : STD_LOGIC_VECTOR(3 downto 0) := X"0";  ---Upper Nibble of Isomorph mapping output
SIGNAL COMP_FIELD_2 : STD_LOGIC_VECTOR(3 downto 0) := X"0";  ---Lower Nibble of Isomorph mapping output
SIGNAL GALOIS_ADD_1	: STD_LOGIC_VECTOR(3 downto 0) := X"0";  ---First Galois Addition
SIGNAL GALOIS_ADD_2 : STD_LOGIC_VECTOR(3 downto 0) := X"0"; ---Second Galois Addition
SIGNAL GALOIS_MUL_1	: STD_LOGIC_VECTOR(3 downto 0) := X"0"; --First Galois Multiplication
SIGNAL GALOIS_MUL_2	: STD_LOGIC_VECTOR(3 downto 0) := X"0"; --Second Galois Multiplication
SIGNAL GALOIS_MUL_3	: STD_LOGIC_VECTOR(3 downto 0) := X"0"; ---Third Galois Multiplication 
SIGNAL GALOIS_MUL_LMBDA : STD_LOGIC_VECTOR(3 downto 0) := X"0";  ---Galois Multiplication by Lambda
SIGNAL GALOIS_SQUARE : STD_LOGIC_VECTOR(3 downto 0) := X"0";  ---Squaring a Number in the Galois field
SIGNAL GALOIS_MUL_INV	: STD_LOGIC_VECTOR(3 downto 0) := X"0"; ---Multiplicative Inverse in the Galois field
SIGNAL GMUL_CONCAT	 : STD_LOGIC_VECTOR(7 downto 0) := X"00";  ---Buffer for Concatination of Muliply Results
SIGNAL MULINV_OUT  	 : STD_LOGIC_VECTOR(7 downto 0) := X"00"; ---Final Output Signal for enitre Multiplicative Inverse Op
SIGNAL AFFINE_TRANS : STD_LOGIC_VECTOR(7 downto 0) := X"00";  ---Output of Affine Transformation
--SIGNAL INV_ISOMORPH_AFFINE_TRANS : STD_LOGIC_VECTOR(7 downto 0) := X"00";

COMPONENT GALOIS_MUL2_4 --Moved into a seperate process to make the pipelining more straight forward
	PORT(
		SYS_CLK : IN std_logic;
		RST : IN std_logic;
		A_IN : IN std_logic_vector(3 downto 0); ---Non-buffered inputs
		B_IN : IN std_logic_vector(3 downto 0);          
		C_OUT : OUT std_logic_vector(3 downto 0)  ---Buffered output appears 2 cycles later
		);
	END COMPONENT;
	
begin

Inst_GALOIS_MUL2_4_1: GALOIS_MUL2_4 PORT MAP(
		SYS_CLK => SYS_CLK,
		RST => RST,
		A_IN => STAGE1_3,		
		B_IN => STAGE1_2,			
		C_OUT => GALOIS_MUL_1
	);


Inst_GALOIS_MUL2_4_2: GALOIS_MUL2_4 PORT MAP(
		SYS_CLK => SYS_CLK,
		RST => RST,
		A_IN => STAGE4_1,	
		B_IN => STAGE4_2, 	
		C_OUT => GALOIS_MUL_2
	);
		
Inst_GALOIS_MUL2_4_3: GALOIS_MUL2_4 PORT MAP(
		SYS_CLK => SYS_CLK,
		RST => RST,
		A_IN => STAGE4_2,	
		B_IN => STAGE4_3,	
		C_OUT => GALOIS_MUL_3
	);	


---Pipeline Registers
Registers : Process(sys_clk,rst)
begin
	IF (SYS_CLK'event and SYS_CLK = '1') then
		IF (RST = '1') then
			STAGE1_1 <= X"0"; 
			STAGE1_2 <= X"0";
			STAGE1_3 <= X"0";
			
			STAGE2_1 <= X"0";   
			STAGE2_2 <= X"0";
			STAGE2_3 <= X"0";
			
			STAGE3_1 <= X"0";   
			STAGE3_2 <= X"0";
			STAGE3_3 <= X"0";
			STAGE3_4 <= X"0";
			
			STAGE4_1 <= X"0";  
			STAGE4_2 <= X"0";
			STAGE4_3 <= X"0";
			
			STAGE5_1 <= X"0";  
			STAGE5_2 <= X"0";	
			
			OUTPUT_LATCH <= X"00";
		ELSE
			STAGE1_1 <= COMP_FIELD_1;
			STAGE1_2 <= GALOIS_ADD_1;
			STAGE1_3 <= COMP_FIELD_2;
		
			STAGE2_1 <= STAGE1_1;			
			STAGE2_2 <= GALOIS_SQUARE;
			STAGE2_3 <= STAGE1_2;		
		
			STAGE3_1 <= STAGE2_1;	
			STAGE3_2 <= GALOIS_MUL_LMBDA;
			STAGE3_3 <= GALOIS_MUL_1;
			STAGE3_4 <= STAGE2_3;	
			
			STAGE4_1 <= STAGE3_1;		
			STAGE4_2 <= GALOIS_MUL_INV;
			STAGE4_3 <= STAGE3_4; 		

			STAGE5_1 <= GALOIS_MUL_2; 
			STAGE5_2 <= GALOIS_MUL_3;
			--OUTPUT_LATCH <= INV_ISOMORPH_AFFINE_TRANS;
			OUTPUT_LATCH <= AFFINE_TRANS;
		END IF;
	END IF;
END PROCESS;	









----Asynchronous Transforms ----Feed into pipeline registers




ISOMORPH_MAP <= 	(BYTE_IN(7) XOR BYTE_IN(5)) &
						(BYTE_IN(7) XOR BYTE_IN(6) XOR BYTE_IN(4) XOR BYTE_IN(3) XOR BYTE_IN(2) XOR BYTE_IN(1)) &
						(BYTE_IN(7) XOR BYTE_IN(5) XOR BYTE_IN(3) XOR BYTE_IN(2)) &
						(BYTE_IN(7) XOR BYTE_IN(5) XOR BYTE_IN(3) XOR BYTE_IN(2) XOR BYTE_IN(1)) &
						(BYTE_IN(7) XOR BYTE_IN(6) XOR BYTE_IN(2) XOR BYTE_IN(1)) &
						(BYTE_IN(7) XOR BYTE_IN(4) XOR BYTE_IN(3) XOR BYTE_IN(2) XOR BYTE_IN(1)) &
						(BYTE_IN(6) XOR BYTE_IN(4) XOR BYTE_IN(1)) &
						(BYTE_IN(6) XOR BYTE_IN(1) XOR BYTE_IN(0));
						
COMP_FIELD_1 	<= ISOMORPH_MAP(7 downto 4);
COMP_FIELD_2 	<= ISOMORPH_MAP(3 downto 0);
GALOIS_ADD_1 	<= COMP_FIELD_1 XOR COMP_FIELD_2;	

GALOIS_SQUARE 	<= STAGE1_1(3) &	
						(STAGE1_1(3) XOR STAGE1_1(2)) &
						(STAGE1_1(2) XOR STAGE1_1(1)) &
						(STAGE1_1(3) XOR STAGE1_1(1) XOR STAGE1_1(0));

GALOIS_MUL_LMBDA <= 	(STAGE2_2(2) XOR STAGE2_2(0)) &  	
							(STAGE2_2(3) XOR STAGE2_2(2) XOR STAGE2_2(1) XOR STAGE2_2(0)) &
							STAGE2_2(3) &
							STAGE2_2(2);


GALOIS_ADD_2 <= STAGE3_2 XOR STAGE3_3; 	

--GALOIS_MUL_INV <=  CRAZY SET OF BOOLEAN EQUATIONS, try this nice lookup table instead
MUL_INV_LOOKUP : PROCESS(GALOIS_ADD_2,GALOIS_MUL_INV)
begin
	case GALOIS_ADD_2 is
		when X"0" => GALOIS_MUL_INV <= X"0";
		when X"1" => GALOIS_MUL_INV <= X"1";
		when X"2" => GALOIS_MUL_INV <= X"3";
		when X"3" => GALOIS_MUL_INV <= X"2";
		when X"4" => GALOIS_MUL_INV <= X"F";
		when X"5" => GALOIS_MUL_INV <= X"C";
		when X"6" => GALOIS_MUL_INV <= X"9";
		when X"7" => GALOIS_MUL_INV <= X"B";
		when X"8" => GALOIS_MUL_INV <= X"A";
		when X"9" => GALOIS_MUL_INV <= X"6";
		when X"A" => GALOIS_MUL_INV <= X"8";
		when X"B" => GALOIS_MUL_INV <= X"7";
		when X"C" => GALOIS_MUL_INV <= X"5";
		when X"D" => GALOIS_MUL_INV <= X"E";
		when X"E" => GALOIS_MUL_INV <= X"D";
		when X"F" => GALOIS_MUL_INV <= X"4";
		when others => GALOIS_MUL_INV <= X"0";
	end case;
END PROCESS MUL_INV_LOOKUP;



GMUL_CONCAT <= STAGE5_1 & STAGE5_2; 	---Reform the byte before the inverse isomorph mapping

INV_ISOMORPH_MAP <=	(GMUL_CONCAT(7) XOR GMUL_CONCAT(6) XOR GMUL_CONCAT(5) XOR GMUL_CONCAT(1)) &
							(GMUL_CONCAT(6) XOR GMUL_CONCAT(2)) &
							(GMUL_CONCAT(6) XOR GMUL_CONCAT(5) XOR GMUL_CONCAT(1)) &
							(GMUL_CONCAT(6) XOR GMUL_CONCAT(5) XOR GMUL_CONCAT(4) XOR GMUL_CONCAT(2) XOR GMUL_CONCAT(1)) &
							(GMUL_CONCAT(5) XOR GMUL_CONCAT(4) XOR GMUL_CONCAT(3) XOR GMUL_CONCAT(2) XOR GMUL_CONCAT(1)) &
							(GMUL_CONCAT(7) XOR GMUL_CONCAT(4) XOR GMUL_CONCAT(3) XOR GMUL_CONCAT(2) XOR GMUL_CONCAT(1)) &
							(GMUL_CONCAT(5) XOR GMUL_CONCAT(4)) &
							(GMUL_CONCAT(6) XOR GMUL_CONCAT(5) XOR GMUL_CONCAT(4) XOR GMUL_CONCAT(2) XOR GMUL_CONCAT(0));

MULINV_OUT <= INV_ISOMORPH_MAP;

AFFINE_TRANS <= 	(MULINV_OUT(3) XOR MULINV_OUT(4) XOR MULINV_OUT(5) XOR MULINV_OUT(6) XOR MULINV_OUT(7) XOR '0') &
						(MULINV_OUT(2) XOR MULINV_OUT(3) XOR MULINV_OUT(4) XOR MULINV_OUT(5) XOR MULINV_OUT(6) XOR '1') &
						(MULINV_OUT(1) XOR MULINV_OUT(2) XOR MULINV_OUT(3) XOR MULINV_OUT(4) XOR MULINV_OUT(5) XOR '1') &
						(MULINV_OUT(0) XOR MULINV_OUT(1) XOR MULINV_OUT(2) XOR MULINV_OUT(3) XOR MULINV_OUT(4) XOR '0') &
						(MULINV_OUT(0) XOR MULINV_OUT(1) XOR MULINV_OUT(2) XOR MULINV_OUT(3) XOR MULINV_OUT(7) XOR '0') &
						(MULINV_OUT(0) XOR MULINV_OUT(1) XOR MULINV_OUT(2) XOR MULINV_OUT(6) XOR MULINV_OUT(7) XOR '0') &
						(MULINV_OUT(0) XOR MULINV_OUT(1) XOR MULINV_OUT(5) XOR MULINV_OUT(6) XOR MULINV_OUT(7) XOR '1') &
						(MULINV_OUT(0) XOR MULINV_OUT(4) XOR MULINV_OUT(5) XOR MULINV_OUT(6) XOR MULINV_OUT(7) XOR '1');
								

SUB_BYTE_OUT <= OUTPUT_LATCH;  --Acutal Output of Module
end Behavioral;