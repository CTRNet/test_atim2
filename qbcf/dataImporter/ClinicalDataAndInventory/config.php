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

$files_path = "C:/_NicolasLuc/Server/www/qbcf/data/";
//$files_path = "/ATiM/atim-tfri/dataUpdate/cpcbn/UpdateClinicalData/data/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
//	array('CHUM', '160704_clinical data-V4.2_batch 2_CHUM_76-189 (114).xls', $windows_xls_offset),
	array('CHUM', 'test.xls', $windows_xls_offset),
	array('sssQBCF', '160525_QBCF-clinical data-V4.1_file150322_batch1_patientes 1-75 (75).xls', $windows_xls_offset),
	array('sssQBCF', '160707_QBCF-clinical data-V4.2_CHUQ-V4.2 20160706_patientes 1-173 (173).xls', $windows_xls_offset)
);

//-- EXCEL TO ATIM VALUE ---------------------------------------------------------------------------------------------------------------------------

$excel_to_atim_values = array(
	'participants.vital_status' => array(
		'unknown' => 'unknown',
		'alive' => 'alive',
		'deceased' => 'deceased',
		'died from breast cancer' => 'deceased from breast cancer',
		'Died from other cause' => 'deceased from other cause',
		'Died from unknown cause (lost to f/u)' => 'deceased from unknown cause')
);

?>