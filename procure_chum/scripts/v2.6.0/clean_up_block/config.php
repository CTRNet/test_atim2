<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= '';
$procure_db_schema		= 'procurechum';
$chumoncoaxis_db_schema = 'chumoncoaxis';
$db_charset		= "utf8";

$migration_user_id = 9;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------


$files_path = "C:/_NicolasLuc/Server/www/procure_chum/data/";

if(false) {
	$files_path = "/ATiM/todelete/";
	$db_pwd			= "";
	$procure_db_schema		= "test_procure";
	$chumoncoaxis_db_schema = 'test_icm';
}

?>