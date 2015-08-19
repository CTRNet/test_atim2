<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "icm";
$db_charset		= "utf8";

$migration_user_id = 9;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$files_path = "C:/_Perso/Server/icm/data/";

$excel_files = array(
	array('TMA_Layout_TFInterneCHUM_05-08-2015_CC_short_test.xls', 'Sheet1')		
);

//-- TMA TO REMOVE ---------------------------------------------------------------------------------------------------------------------------

$tma_short_label_to_remove = array();

?>