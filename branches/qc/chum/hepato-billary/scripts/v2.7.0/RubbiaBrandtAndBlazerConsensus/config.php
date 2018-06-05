<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "chumhepato";

$isserver = false;
if($isserver) {
    $db_pwd			= "xxxx";
    $db_schema		= "xxx";
}

$db_charset		= "utf8";

$migration_user_id = 9;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$excel_files_paths = "C:/_NicolasLuc/Server/www/chum_hepato/scripts/v2.7.0/RubbiaBrandtAndBlazerConsensus/";
if($isserver) $excel_files_paths = "/ATiM/atim-kidney-transplant/Test/scripts/v2.7.0/initial_sample_data_migration/";

$excel_file_names = array(
   'Database for TRG scoring March 2018_pour Nicolas_final.xls'
);

?>