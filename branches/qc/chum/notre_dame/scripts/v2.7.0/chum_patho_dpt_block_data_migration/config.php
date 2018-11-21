<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "chumoncoaxis";

$db_charset		= "utf8";

$migration_user_id = 9;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$files_path_1 = "/ATiM/atim-oncology-axis/DataMigration/BlockCreationTest/2017-09-11 1er batch ovaire/";
$files_path_1 = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.7.0/chum_patho_dpt_block_data_migration/Listes pretes Sein HD/");
$excel_file_names_1 = array(
//    utf8_decode("1996 Sein HD_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//    utf8_decode("1997 Sein HD_Atim_DJ.xls") => array('worksheets' => array('Blocks')),,
//    utf8_decode("1998 Sein HD_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//    utf8_decode("1999 Sein HD_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//    utf8_decode("2000 Sein Hotel-Dieu_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//  utf8_decode("2001 Sein Hotel-Dieu_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
    utf8_decode("2002 Sein Hotel-Dieu_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
);



    
$files_path = $files_path_1;
$excel_file_names = $excel_file_names_1;

?>