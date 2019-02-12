<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "tfricoeur";
$db_charset		= "utf8";

$excel_files_paths = 'C:\_NicolasLuc\Server\www\tfri_coeur\dataImporterConfig\BlockDataMigration/';

$is_serveur = false;
if($is_serveur) {
    $db_pwd			= "am3-y-4606";
    $db_schema		= "atimtfricoeurtest";
    $excel_files_paths = "/ATiM/atim-tfri-coeur/Test/dataImporterConfig/BlockDataMigration/";
}
$migration_user_id = 2;

// $file_xls_offset Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064 (Use for excel date parsing)
$windows_xls_offset = 36526;
$mac_xls_offset = 35064;
$bank_excel_files = array(
    'file' => 'inventaire FFPE (2018-11-27)_nl_revised_20190211.xls'
);
