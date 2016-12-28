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

$files_path = "C:/_NicolasLuc/Server/www/qbcf/data/20161221/clinical data/";
//$files_path = "/ATiM/atim-tfri/dataUpdate/cpcbn/UpdateClinicalData/data/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	array('CHUM', '161014QBCF-clinical data-V4.2batch 2_CHUM76-189(114)_VOedit2_Natreviewed_2_drug0k.xls', $mac_xls_offset),
	array('CHUM', '161124_161124_161014QBCF-clinical data-V4.1_CHUMpatientes 1-75(75)_VOedit2_Natreviewed_drugok.xls', $mac_xls_offset),
	array('CHUM', '161124_QBCF-clinical data-V4.2CHUMjuil 190-271(82)_VOedit2_Natreviewed_2_drugok.xls', $mac_xls_offset),
	array('CHUM', '161124_QBCF-clinical data-V4.2sept2016CHUM 272-358(87)_VOedit2_Natreviewed_2_drugok.xls', $mac_xls_offset),
	array('CHUQ', '161206_QBCF-clinical dataCHUQ-V4.2(2)(nobreastFU)_VOedit3_Natreviewed_2_drugok.xls', $windows_xls_offset)
	);
?>