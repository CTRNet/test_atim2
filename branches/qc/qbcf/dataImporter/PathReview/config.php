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

$files_path = "C:/_NicolasLuc/Server/www/qbcf/data/test/";
//$files_path = "/ATiM/atim-tfri/dataUpdate/cpcbn/UpdateClinicalData/data/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	array('161020_patho _CHUM_BOX1_position1-100.xls', $mac_xls_offset)//,
//	array('QBCF', '160525_QBCF-clinical data-V4.1_file150322_batch1_patientes 1-75 (75) - NL_revised.xls', $mac_xls_offset),
//	array('CHUQ', '160707_QBCF-clinical data-V4.2_CHUQ-V4.2 20160706_patientes 1-173 (173) - NL_revised.xls', $windows_xls_offset)
);

?>