-- megafunction wizard: %LPM_CONSTANT%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: lpm_constant 

-- ============================================================
-- File Name: constant.vhd
-- Megafunction Name(s):
-- 			lpm_constant
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 6.0 Build 202 06/20/2006 SP 1 SJ Web Edition
-- ************************************************************


--Copyright (C) 1991-2006 Altera Corporation
--Your use of Altera Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Altera Program License 
--Subscription Agreement, Altera MegaCore Function License 
--Agreement, or other applicable license agreement, including, 
--without limitation, that your use is for the sole purpose of 
--programming logic devices manufactured by Altera and sold by 
--Altera or its authorized distributors.  Please refer to the 
--applicable agreement for further details.


--lpm_constant CBX_AUTO_BLACKBOX="ON" ENABLE_RUNTIME_MOD="YES" INSTANCE_NAME="data" LPM_CVALUE=0 LPM_WIDTH=32 result
--VERSION_BEGIN 6.0 cbx_lpm_constant 2006:01:26:12:27:46:SJ cbx_mgl 2006:05:17:10:06:16:SJ  VERSION_END

--synthesis_resources = sld_mod_ram_rom 1 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  constant_lpm_constant_jja IS 
	 PORT 
	 ( 
		 result	:	OUT  STD_LOGIC_VECTOR (31 DOWNTO 0)
	 ); 
 END constant_lpm_constant_jja;

 ARCHITECTURE RTL OF constant_lpm_constant_jja IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL  wire_mgl_prim1_data_write	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 COMPONENT  sld_mod_ram_rom
	 GENERIC 
	 (
		CVALUE	:	STD_LOGIC_VECTOR(31 DOWNTO 0);
		IS_DATA_IN_RAM	:	NATURAL;
		IS_READABLE	:	NATURAL;
		NODE_NAME	:	NATURAL;
		NUMWORDS	:	NATURAL;
		SHIFT_COUNT_BITS	:	NATURAL;
		WIDTH_WORD	:	NATURAL;
		WIDTHAD	:	NATURAL
	 );
	 PORT
	 ( 
		data_write	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	 ); 
	 END COMPONENT;
 BEGIN

	result <= wire_mgl_prim1_data_write;
	mgl_prim1 :  sld_mod_ram_rom
	  GENERIC MAP (
		CVALUE => "00000000000000000000000000000000",
		IS_DATA_IN_RAM => 0,
		IS_READABLE => 0,
		NODE_NAME => 1684108385,
		NUMWORDS => 1,
		SHIFT_COUNT_BITS => 6,
		WIDTH_WORD => 32,
		WIDTHAD => 1
	  )
	  PORT MAP ( 
		data_write => wire_mgl_prim1_data_write
	  );

 END RTL; --constant_lpm_constant_jja
--VALID FILE


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY constant IS
	PORT
	(
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END constant;


ARCHITECTURE RTL OF constant IS

	ATTRIBUTE synthesis_clearbox: boolean;
	ATTRIBUTE synthesis_clearbox OF RTL: ARCHITECTURE IS TRUE;
	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (31 DOWNTO 0);



	COMPONENT constant_lpm_constant_jja
	PORT (
			result	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	result    <= sub_wire0(31 DOWNTO 0);

	constant_lpm_constant_jja_component : constant_lpm_constant_jja
	PORT MAP (
		result => sub_wire0
	);



END RTL;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "1"
-- Retrieval info: PRIVATE: JTAG_ID STRING "data"
-- Retrieval info: PRIVATE: Radix NUMERIC "16"
-- Retrieval info: PRIVATE: Value NUMERIC "0"
-- Retrieval info: PRIVATE: WIZMAN_OVERRIDE_CBX_GEN_MODE STRING "ON"
-- Retrieval info: PRIVATE: nBit NUMERIC "32"
-- Retrieval info: CONSTANT: LPM_CVALUE NUMERIC "0"
-- Retrieval info: CONSTANT: LPM_HINT STRING "ENABLE_RUNTIME_MOD=YES, INSTANCE_NAME=data"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_CONSTANT"
-- Retrieval info: CONSTANT: LPM_WIDTH NUMERIC "32"
-- Retrieval info: USED_PORT: result 0 0 32 0 OUTPUT NODEFVAL result[31..0]
-- Retrieval info: CONNECT: result 0 0 32 0 @result 0 0 32 0
-- Retrieval info: LIBRARY: lpm lpm.lpm_components.all
-- Retrieval info: GEN_FILE: TYPE_NORMAL constant.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL constant.inc FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL constant.cmp FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL constant.bsf FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL constant_inst.vhd TRUE
