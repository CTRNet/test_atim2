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

$files_path = "C:/_NicolasLuc/Server/www/tfri_cpcbn/dataImporterConfig/coreRevision/";

//array(file_name, worksheet, date_of_revision, extension_of_headers("Dx PathRev1","NotesReview1","TMA Grade X+Y")
$excel_files = array(
	array('FULL_2eREVISION.xls', 'Feuil1'),
    array('TEST_2eREVISION.xls', 'Feuil1')
);


?>