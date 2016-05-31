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
//$files_path = "/ATiM/atim-tfri/dataUpdate/cpcbn/UpdateClinicalData/data/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	array('160506_AS Manitoba_ATiM_revised_20160531.xls', 'Manitoba-Drachenberg #8', $windows_xls_offset, 'Feuil1'),
	array('160516_AS_Sunnybrook_ATiM Inventory_revised_20160531.xls', 'Sunnybrook-Klotz #7', $windows_xls_offset, '160126_AS_Inventory_review.csv')
);

?>