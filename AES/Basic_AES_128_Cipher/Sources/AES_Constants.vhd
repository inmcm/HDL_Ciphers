--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package AES_CONSTANTS is

  
	type ARRAY_256 is ARRAY (0 to 255) of STD_LOGIC_VECTOR(7 downto 0); ----256 Byte Array
	type ARRAY_16  is ARRAY (0 to 15) of  STD_LOGIC_VECTOR(7 downto 0); ----Byte Level Organization for a 128 bit field
	type ARRAY4x32 is ARRAY (0 to 3) of  STD_LOGIC_VECTOR(31	downto 0);  ----Word Level Organization for a 128 bit field
	constant SBOX : ARRAY_256 :=	(X"63",X"7c",X"77",X"7b",X"f2",X"6b",X"6f",X"c5",X"30",X"01",X"67",X"2b",X"fe",X"d7",X"ab",X"76",
											X"ca",X"82",X"c9",X"7d",X"fa",X"59",X"47",X"f0",X"ad",X"d4",X"a2",X"af",X"9c",X"a4",X"72",X"c0",
											X"b7",X"fd",X"93",X"26",X"36",X"3f",X"f7",X"cc",X"34",X"a5",X"e5",X"f1",X"71",X"d8",X"31",X"15",
											X"04",X"c7",X"23",X"c3",X"18",X"96",X"05",X"9a",X"07",X"12",X"80",X"e2",X"eb",X"27",X"b2",X"75",
											X"09",X"83",X"2c",X"1a",X"1b",X"6e",X"5a",X"a0",X"52",X"3b",X"d6",X"b3",X"29",X"e3",X"2f",X"84",
											X"53",X"d1",X"00",X"ed",X"20",X"fc",X"b1",X"5b",X"6a",X"cb",X"be",X"39",X"4a",X"4c",X"58",X"cf",
											X"d0",X"ef",X"aa",X"fb",X"43",X"4d",X"33",X"85",X"45",X"f9",X"02",X"7f",X"50",X"3c",X"9f",X"a8",
											X"51",X"a3",X"40",X"8f",X"92",X"9d",X"38",X"f5",X"bc",X"b6",X"da",X"21",X"10",X"ff",X"f3",X"d2",
											X"cd",X"0c",X"13",X"ec",X"5f",X"97",X"44",X"17",X"c4",X"a7",X"7e",X"3d",X"64",X"5d",X"19",X"73",
											X"60",X"81",X"4f",X"dc",X"22",X"2a",X"90",X"88",X"46",X"ee",X"b8",X"14",X"de",X"5e",X"0b",X"db",
											X"e0",X"32",X"3a",X"0a",X"49",X"06",X"24",X"5c",X"c2",X"d3",X"ac",X"62",X"91",X"95",X"e4",X"79",
											X"e7",X"c8",X"37",X"6d",X"8d",X"d5",X"4e",X"a9",X"6c",X"56",X"f4",X"ea",X"65",X"7a",X"ae",X"08",
											X"ba",X"78",X"25",X"2e",X"1c",X"a6",X"b4",X"c6",X"e8",X"dd",X"74",X"1f",X"4b",X"bd",X"8b",X"8a",
											X"70",X"3e",X"b5",X"66",X"48",X"03",X"f6",X"0e",X"61",X"35",X"57",X"b9",X"86",X"c1",X"1d",X"9e",
											X"e1",X"f8",X"98",X"11",X"69",X"d9",X"8e",X"94",X"9b",X"1e",X"87",X"e9",X"ce",X"55",X"28",X"df",
											X"8c",X"a1",X"89",X"0d",X"bf",X"e6",X"42",X"68",X"41",X"99",X"2d",X"0f",X"b0",X"54",X"bb",X"16");
	constant INV_SBOX : ARRAY_256 := (X"52",X"09",X"6a",X"d5",X"30",X"36",X"a5",X"38",X"bf",X"40",X"a3",X"9e",X"81",X"f3",X"d7",X"fb",
												X"7c",X"e3",X"39",X"82",X"9b",X"2f",X"ff",X"87",X"34",X"8e",X"43",X"44",X"c4",X"de",X"e9",X"cb",
												X"54",X"7b",X"94",X"32",X"a6",X"c2",X"23",X"3d",X"ee",X"4c",X"95",X"0b",X"42",X"fa",X"c3",X"4e",
												X"08",X"2e",X"a1",X"66",X"28",X"d9",X"24",X"b2",X"76",X"5b",X"a2",X"49",X"6d",X"8b",X"d1",X"25",
												X"72",X"f8",X"f6",X"64",X"86",X"68",X"98",X"16",X"d4",X"a4",X"5c",X"cc",X"5d",X"65",X"b6",X"92",
												X"6c",X"70",X"48",X"50",X"fd",X"ed",X"b9",X"da",X"5e",X"15",X"46",X"57",X"a7",X"8d",X"9d",X"84",
												X"90",X"d8",X"ab",X"00",X"8c",X"bc",X"d3",X"0a",X"f7",X"e4",X"58",X"05",X"b8",X"b3",X"45",X"06",
												X"d0",X"2c",X"1e",X"8f",X"ca",X"3f",X"0f",X"02",X"c1",X"af",X"bd",X"03",X"01",X"13",X"8a",X"6b",
												X"3a",X"91",X"11",X"41",X"4f",X"67",X"dc",X"ea",X"97",X"f2",X"cf",X"ce",X"f0",X"b4",X"e6",X"73",
												X"96",X"ac",X"74",X"22",X"e7",X"ad",X"35",X"85",X"e2",X"f9",X"37",X"e8",X"1c",X"75",X"df",X"6e",
												X"47",X"f1",X"1a",X"71",X"1d",X"29",X"c5",X"89",X"6f",X"b7",X"62",X"0e",X"aa",X"18",X"be",X"1b",
												X"fc",X"56",X"3e",X"4b",X"c6",X"d2",X"79",X"20",X"9a",X"db",X"c0",X"fe",X"78",X"cd",X"5a",X"f4",
												X"1f",X"dd",X"a8",X"33",X"88",X"07",X"c7",X"31",X"b1",X"12",X"10",X"59",X"27",X"80",X"ec",X"5f",
												X"60",X"51",X"7f",X"a9",X"19",X"b5",X"4a",X"0d",X"2d",X"e5",X"7a",X"9f",X"93",X"c9",X"9c",X"ef",
												X"a0",X"e0",X"3b",X"4d",X"ae",X"2a",X"f5",X"b0",X"c8",X"eb",X"bb",X"3c",X"83",X"53",X"99",X"61",
												X"17",X"2b",X"04",X"7e",X"ba",X"77",X"d6",X"26",X"e1",X"69",X"14",X"63",X"55",X"21",X"0c",X"7d");

	constant rcon : ARRAY_16 :=  (X"01",X"02",X"04",X"08",X"10",X"20",X"40",X"80",X"1b",X"36",X"6c",X"d8",X"ab",X"4d",X"9a",X"2f"); -----Rotation Constants for Key Scheduling
 

end AES_CONSTANTS;

