<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "qbcf";
$db_charset		= "utf8";

$is_server = false;

if($is_server) $db_pwd			= "am3-y-4606";
if($is_server) $db_schema		= "atimqbcf";

$migration_user_id = 1;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$files_path = "C:\_NicolasLuc\Server\www\qbcf_181029\Patho review/";
if($is_server) $files_path = "/ATiM/atim-qbcf/dataImporter/180528/patho review/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	array('number_possible_punchs_14082018_3.xls', $mac_xls_offset)
);




?>