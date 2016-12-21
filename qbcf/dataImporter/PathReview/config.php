<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "qbcf";
$db_charset		= "utf8";

$migration_user_id = 1;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$files_path = "C:/_NicolasLuc/Server/www/qbcf/data/20161221/Patho/";
//$files_path = "/ATiM/atim-tfri/dataUpdate/cpcbn/UpdateClinicalData/data/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	array('161208_161020_patho _CHUM_BOX1_position1-100.xls', $mac_xls_offset),
	array('161208_161020_patho _CHUM_BOX2_position1-100.xls', $mac_xls_offset),
	array('161208_161020_patho _CHUM_BOX3_position1-100.xls', $mac_xls_offset),
	array('161208_161020_patho _CHUM_BOX4_position1-100.xls', $mac_xls_offset),
	array('161208_161020_patho _CHUM_BOX5_position1-96_DONE_VO.xls', $mac_xls_offset),
	array('161208_161020_patho _CHUM_BOX6_position1-74.xls', $mac_xls_offset),
	array('161208_161020_patho _CHUQ_BOX1_position1-96.xls', $mac_xls_offset),
	array('161208_161020_patho _CHUQ_BOX2_position1-78.xls', $mac_xls_offset),
	array('161208_161020_patho_MUHC_BOX1_position1-79.xls', $mac_xls_offset)
);

?>