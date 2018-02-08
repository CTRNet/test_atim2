<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "xxxxx";



$db_charset		= "utf8";

$migration_user_id = 9;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$files_path_2 = "/ATiM/atim-oncology-axis/DataMigration/BlockCreation/2017-09-11 2eme batch ovaire/";
//$files_path_2 = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.6.0/chum_patho_dpt_block_data_migration/data/2017-09-11 2eme batch ovaire/");
$excel_file_names_2 = array(
    utf8_decode("Ovaire 2000_ND_Cas O et P-Atim-MM.xls") => array('worksheets' => array('Blocks')),
    utf8_decode("OVAIRE 2001_ND_Biopsies et Chirurgies_Cas P Atim_DJ-MM.xls") => array('worksheets' => array('Blocks')),
    utf8_decode("OVAIRE 2002_ND_Biopsies et Chirurgies_Atim_DJ-MM.xls") => array('worksheets' => array('Blocks')),
    utf8_decode("OVAIRE 2003_ND_Atim_DJ-MM.xls") => array('worksheets' => array('Blocks'))
    );   

// $files_path_3 = "/ATiM/atim-oncology-axis/DataMigration/BlockCreationTestOvary/data/2017-09-11 3eme batch ovaire/";
// //$files_path_3 = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.6.0/chum_patho_dpt_block_data_migration/data/2017-09-11 3eme batch ovaire/");
// $excel_file_names_3 = array(    
//     utf8_decode("OVAIRE 2004 _ND_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("OVAIRE 2005_ND_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("OVAIRE 2006_ND_ATIM_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("OVAIRE 2007_ND_Biopsies et Chirurgies_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("OVAIRE 2008_ND_Biopsies et Chirurgies_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("OVAIRE 2009_ND_Biopsies et Chirurgies_Atim_DJ.xls") => array('worksheets' => array('Blocks'))
// );
    
// $files_path_4 = "/ATiM/atim-oncology-axis/DataMigration/BlockCreationTestOvary/data/2017-09-11 4eme batch ovaire/";
// //$files_path_4 = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.6.0/chum_patho_dpt_block_data_migration/data/2017-09-11 4eme batch ovaire/");
// $excel_file_names_4 = array(
//     utf8_decode("OVAIRE 2010_ND_Biopsies et Chirurgies_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("OVAIRE 2011_ND_Biopsies et Chirurgies-Atim _DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("OVAIRE 2012_ND_Biopsies et Chirurgies-ATIM_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("OVAIRE 2013_ND_Biopsies et Chirurgies_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("Ovaire 2014_ND_liste imprimee_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("Ovaire 2015_ND_Atim_ DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("Ovaire ND-projet FANCI Hubert ND_Atim DJ_.xls") => array('worksheets' => array('Blocks'))
// );

// $files_path_5 = "/ATiM/atim-oncology-axis/DataMigration/BlockCreationTestOvary/data/2017-09-11 5ieme batch prostate/";
// //$files_path_5 = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.6.0/chum_patho_dpt_block_data_migration/data/2017-09-11 5ieme batch prostate/");
// $excel_file_names_5 = array(
//     utf8_decode("2000 Prostate total_Regroupement trie_Atim_DJ.xls") => array('worksheets' => array('Blocks'))
//     );


// $files_path_6 = "/ATiM/atim-oncology-axis/DataMigration/BlockCreationTestOvary/data/2017-09-15 5ieme batch ovaire/";
// //$files_path_6 = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.6.0/chum_patho_dpt_block_data_migration/data/2017-09-15 5ieme batch ovaire/");
// $excel_file_names_6 = array(
//     utf8_decode("OVAIRE 1996-1999 ND_Cas O_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("OVAIRE 2000_ND_Cas O_Atim_DJ.xls") => array('worksheets' => array('Blocks')),
//     utf8_decode("OVAIRE 2001_ND_Cas O_Atim_DJ.xls") => array('worksheets' => array('Blocks'))
//     );
    

$files_path_7 = "/ATiM/atim-oncology-axis/DataMigration/BlockCreationTestOvary/data/ORL/";
//$files_path_7 = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.6.0/chum_patho_dpt_block_data_migration/data/ORL/");
$excel_file_names_7 = array(
    utf8_decode("biobanque ORL_ATiM.xls") => array('worksheets' => array(utf8_decode('Blocs rapatriés')))
    );

    
$files_path = $files_path_2;
$excel_file_names = $excel_file_names_2;

?>