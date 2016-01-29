<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "atimtfricpcbn";
$db_charset		= "utf8";

$migration_user_id = 1;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$files_path = "C:/_NicolasLuc/Server/www/tfri_cpcbn/data/";
$files_path = "/ATiM/atim-tfri/dataUpdate/cpcbn/UpdateClinicalData/data/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	'fleshnerupdate2015_nl_revised.xls' => $windows_xls_offset,
	'HDQupdate2015_nl_revised.xls' => $mac_xls_offset,
	'klotzbatch1_update2015_nl_revised.xls' => $windows_xls_offset,
	'manitobaASupdate2015_nl_revised.xls' => $windows_xls_offset,	
	'mcgill_update2015_nl_revised.xls' => $windows_xls_offset,
	'VPCupdate2015_nl_revised.xls' => $mac_xls_offset
);

?>