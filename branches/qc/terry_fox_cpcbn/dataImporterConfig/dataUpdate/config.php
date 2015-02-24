<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "tfricpcbn";
$db_charset		= "utf8";

$migration_user_id = 1;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$files_path = "C:/_Perso/Server/tfri_cpcbn/data/update2014";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	'UHN -RTupdate.xls' => $mac_xls_offset
);

?>