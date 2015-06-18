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

$files_path = "C:/_Perso/Server/tfri_cpcbn/data/";

$excel_files = array(
//		array('150616_TMA_layout_ATiM_NF-1-2_MODOFICATION CORE LOCATION.xls', 'Core', '2015-05-01', 'd', '05-2015'),
		array('Optimisation_CPCBN_(2013-06-06)_03062015_CCVO.xls', 'TMA Layout ', '2015-05-01', 'd', '05-2015'),
		
);

//-- TMA TO REMOVE ---------------------------------------------------------------------------------------------------------------------------

$tma_name_to_remove = array(

	'UHN-NF-1',
	'UHN-NF-2',
	'ERR TMA',
	'OPT_TMA_1',
	'OPT_TMA_2',
	'OPT_TMA_3'
);

?>