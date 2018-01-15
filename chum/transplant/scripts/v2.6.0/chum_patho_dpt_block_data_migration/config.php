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

$files_path = "/ATiM/atim-oncology-axis/DataMigration/BlockCreation/data/";

$files_path = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.6.0/chum_patho_dpt_block_data_migration/2017-05-09 1er batch prostate/");
$excel_file_names_prostate_1 = array(
    utf8_decode("Copie de 98-99-2002-3-4-5-2006 SL_Prostate_ Archive-DJ_nl_revised.xls") => array('worksheets' => array(utf8_decode('PROSTATE SL 98-99-2002-3-4-5-6 '))),
    utf8_decode("Copie de 1993 Prostate total_Regroupement Trie etc.xls") => array('worksheets' => array(utf8_decode('regroupé DORIS'))),
    utf8_decode("Copie de 1994 Prostate total_Regroupement Trie-Diamic DJ_nl_revised.xls") => array('worksheets' => array(utf8_decode('Regroupé'))),
    utf8_decode("Copie de 1995 Prostate total_Regroupement Trie_Diamic DJ_ATIM_nl_revised.xls") => array('worksheets' => array(utf8_decode('1995 Groupé Doris_VERIF RENÉE'))),
    utf8_decode("Copie de 1996 ND_PROSTATE_Diamic_Atim_nl_revised.xls") => array('worksheets' => array(utf8_decode('ÉNUMÉRATION +LOCALISATION'))),
    utf8_decode("Copie de 1996-2006 Cas a retrouver selon etc.xls") => array('worksheets' => array(utf8_decode('Feuil1'))),
    utf8_decode("Copie de 1997 ND_PROSTATE_Diamic_REVISE Renee_Atim_nl_revised.xls") => array('worksheets' => array(utf8_decode('Feuil1'))),
    utf8_decode("Copie de 1997 Prostate total _Regroupement_Verifie_ATIM_nl_revised.xls") => array('worksheets' => array(utf8_decode('1997 Prostate groupé ATiM'))),
    utf8_decode("Copie de 1998 ND_PROSTATE_pour ATiM_nl_revised.xls") => array('worksheets' => array(utf8_decode('Feuil1')))
);

$files_path = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.6.0/chum_patho_dpt_block_data_migration/2017-06-09 2ieme batch/");
$excel_file_names_prostate_2 = array(
    utf8_decode("1989-90-91-92 Prostate total_Regroupement Trié ATIM_DJ.xls") => array('worksheets' => array(utf8_decode('1989-90-91-92_Regroup PROSTATE'))),
    utf8_decode("1996 Prostate Regroupement_DIAMIC_ARCHIVÉ.xls") => array('worksheets' => array(utf8_decode('1996 Prostate groupé Renée'))),
    utf8_decode("1998 Prostate total_Regroupement_Vérifié_DJ_ARCHIVÉ.xls") => array('worksheets' => array(utf8_decode('1998 GROUPÉ_RENÉE'))),
    utf8_decode("1999 Prostate total_Regroupement_ VÉRIFIÉ_ARCHIVÉ.xls") => array('worksheets' => array(utf8_decode('1999 GROUPÉ RENÉE'))),
    utf8_decode("2001 Prostate total_Regroupement_ Vérifié_DJ-Archivé.xls") => array('worksheets' => array(utf8_decode('2001 Prostate ND (N=123)'))),
    utf8_decode("2003 Prostate total_Regroupement_Archivé DJ.xls") => array('worksheets' => array(utf8_decode('2003 regroup PROSTATE_Renée'))),
    utf8_decode("2004 Prostate total_Regroupement_ Diamic_ATIM.xls") => array('worksheets' => array(utf8_decode('2004 groupé Renée')))
);

$files_path = utf8_decode("C:/_NicolasLuc/Server/www/chum_onco_axis/scripts/v2.6.0/chum_patho_dpt_block_data_migration/2017-08-03 3ieme batch prostate/");
$excel_file_names_prostate_3 = array(
//    utf8_decode("1999ND_PROSTATE_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('Feuil1'))),
//    utf8_decode("2000 ND_PROSTATE.DIAMIC DJ_ARCHIVÉ.xls") => array('worksheets' => array(utf8_decode('Feuil1'))),
//    utf8_decode("2001 ND_PROSTATE_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('2001 (N=123)'))),
//    utf8_decode("2002 ND_PROSTATE + Regroupement-Atim_DJ.xls") => array('worksheets' => array(utf8_decode('2002 Prostate Regroupement_RB'))),
//    utf8_decode("2003 ND_PROSTATE_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('2003 (N=116)'))),
//    utf8_decode("2004ND_PROSTATE_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('2004 (N=87)'))),
//    utf8_decode("2005 ND_PROSTATE_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('2005 (N=80)'))),
//    utf8_decode("2006 ND_PROSTATE_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('2006 (N=81)'))),
//    utf8_decode("2007 SL_Prostate_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('PROSTATE SL 2007 (n=236)'))),
//    utf8_decode("2007_2014 ND_PROSTATE - Atim_DJ.xls") => array('worksheets' => array(utf8_decode('PROSTATE ND 2010 à 2014 (N=4)'))),
//    utf8_decode("2008 SL_Prostate_ DJ_Atim.xls") => array('worksheets' => array(utf8_decode('PROSTATE SL 2008 (N=227)'))),
//    utf8_decode("2009 SL_Prostate_DJ_Atim.xls") => array('worksheets' => array(utf8_decode('2009 SL Prostate (N=244)'))),
//   utf8_decode("2010 SL Prostate DJ-Atim.xls") => array('worksheets' => array(utf8_decode('2010 SL_Prostate (N=253)'))),
//    utf8_decode("2011 SL Prostate -Vérifié-DJ-Atim.xls") => array('worksheets' => array(utf8_decode('2011 SL_Prostate (N=247)'))),
//    utf8_decode("2012 SL Prostate Vérifié-DJ-Atim.xls") => array('worksheets' => array(utf8_decode('2012 SL_Prostate (N=95)'))),
//   utf8_decode("2013 SL Prostate_DJ_Atim.xls") => array('worksheets' => array(utf8_decode('2013 SL_Prostate (N=76)'))),
//   utf8_decode("2014 SL Prostate _DJ_Atim.xls") => array('worksheets' => array(utf8_decode('2014 SL_Prostate (N=181)'))),
//   utf8_decode("2015 SL Prostate 2ième partie_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('2015 SL_Prostate (N=85)'))),
//  utf8_decode("2015 SL Prostate _DJ_Atim.xls") => array('worksheets' => array(utf8_decode('2015 SL_Prostate (N=85)'))),
//    utf8_decode("Biopsies de prostate_TMA CPCBN_ Archivé_ DJ.xls") => array('worksheets' => array(utf8_decode('Inventaire RB'))),
//    utf8_decode("DX autre que Prostate _ND_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('DX autre que Prostate_ND (=154)'))),
//    utf8_decode("DX autre que Prostate_HD (N=35) _ATIM_DJ.xls") => array('worksheets' => array(utf8_decode('DX autre que Prostate_HD (N=35)'))),
//    utf8_decode("DX autre que Prostate_SL (N=74) - Atim- DJ.xls") => array('worksheets' => array(utf8_decode('DX autre que Prostate_SL (N=74)'))),
//    utf8_decode("Nouveau recrutement PROSTATE_HDM_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('nouveau rap_HDM'))),
//    utf8_decode("Nouveau recrutement PROSTATE_ND_2016-08-16 Atim-DJ.xls") => array('worksheets' => array(utf8_decode('nouveau rap_ND'))),
//    utf8_decode("Nouveau recrutement PROSTATE_SL_2016-08-16 Atim-DJ.xls") => array('worksheets' => array(utf8_decode('nouveau rap_SL'))),
//    utf8_decode("PROSTATE HD+ND_années variees_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('PROSTATE HD (N=23)'))),
//    utf8_decode("PROSTATE METAMARK biopsies_NATHALIE_ATIM_DJ.xls") => array('worksheets' => array(utf8_decode('Feuil1'))),
    utf8_decode("prostate missing _Oct19_Atim_DJ.xls") => array('worksheets' => array(utf8_decode('Prostate missing Oct26 (2)'))),
    );

$excel_file_names = $excel_file_names_prostate_3;

?>