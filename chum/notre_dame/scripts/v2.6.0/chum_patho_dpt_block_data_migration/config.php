<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "";
$db_charset		= "utf8";

$migration_user_id = 9;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$files_path = "/ATiM/atim-oncology-axis/DataMigration/BlockCreation/data/";
//$files_path = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.6.0/chum_patho_dpt_block_data_migration/20170109 - Prostate/Prostate révisé à migrer/");

$is_test_process = false;

/* Banks:
 *   Breast/Sein
 *   Ovarian/Ovaire
 *   Prostate
 *   Head&Neck/Tête&cou
 *   Kidney/Rein
 *   Gynecologic/Gynécologique
 *   Autopsy/Autopsie
 */
$excel_file_names = array(
	//utf8_decode("98-99-2002-3-4-5-2006 SL_Prostate_ Archive-DJ_nl_revised.xls") => array('bank' => 'Prostate', 'worksheets' => array('PROSTATE SL 98-99-2002-3-4-5-6 ')),
	//utf8_decode("1994 Prostate total_Regroupement Trie-Diamic DJ_nl_revised.xls") => array('bank' => 'Prostate', 'worksheets' => array(utf8_decode('Regroupé')))
	//utf8_decode("1995 Prostate total_Regroupement Trie_Diamic DJ_ATIM_nl_revised.xls") => array('bank' => 'Prostate', 'worksheets' => array(utf8_decode('1995 Groupé Doris_VERIF RENÉE'))),
	//utf8_decode("1996 ND_PROSTATE_Diamic_Atim_nl_revised.xls") => array('bank' => 'Prostate', 'worksheets' => array(utf8_decode('ÉNUMÉRATION +LOCALISATION'))),
	//utf8_decode("1997 ND_PROSTATE_Diamic_REVISE Renee_Atim_nl_revised.xls") => array('bank' => 'Prostate', 'worksheets' => array('Feuil1')),
	//utf8_decode("1997 Prostate total _Regroupement_Verifie_ATIM_nl_revised.xls") => array('bank' => 'Prostate', 'worksheets' => array(utf8_decode('1997 Prostate groupé ATiM'))),
	//utf8_decode("1998 ND_PROSTATE_pour ATiM_nl_revised.xls") => array('bank' => 'Prostate', 'worksheets' => array('Feuil1'))
	//utf8_decode("1993 Prostate total_Regroupement Trie etc.xls") => array('bank' => 'Prostate', 'worksheets' => array(utf8_decode('regroupé DORIS')))
	//utf8_decode("1996-2006 Cas a retrouver selon etc.xls") => array('bank' => 'Prostate', 'worksheets' => array('Feuil1'))
);	

?>