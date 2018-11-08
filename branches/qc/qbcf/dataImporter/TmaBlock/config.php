<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "qbcf";
$db_charset		= "utf8";


$db_pwd			= "";
$db_schema		= "qbcf";

$migration_user_id = 1;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$files_path = "C:\_NicolasLuc\Server\www\qbcf\dataImporter\TmaBlock/";
//$files_path = "/ATiM/atim-qbcf/dataImporter/data/TMA construction/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	array('MAP_OPT_ATiM_2018-10-10_nl_rev.xls', 'Feuil1'),
	array('TMADiscovery_map_ATiM_formigration_CC_181010_nl_rev.xls', 'Discovery A'),
	array('TMADiscovery_map_ATiM_formigration_CC_181010_nl_rev.xls', 'Discovery B'),
	array('TMADiscovery_map_ATiM_formigration_CC_181010_nl_rev.xls', 'Discovery C'),
);

$excel_files_names_control_annotation = array(
    array('MAP_OPT_ATiM_2018-10-10_nl_rev - Control Sample Annotation.xls', 'Feuil1')
);

?>