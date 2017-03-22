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

$files_path = "C:/_NicolasLuc/Server/www/tfri_cpcbn/data/";
//$files_path = "/ATiM/atim-tfri/dataUpdate/cpcbn/blockCreation/data/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	array('VO_AS CHUM blocks_nl_revised.xls', 'CHUM-Saad #1', $windows_xls_offset, 'Feuil1'),
	array('VO_161124_ATiM_Manitoba_migration ID_nl_revised.xls', 'Manitoba-Drachenberg #8', $windows_xls_offset, 'with additional ID')
);

?>