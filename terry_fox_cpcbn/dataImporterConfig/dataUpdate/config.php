<?php 

//=================================================================================================================
// CLINICAL DATA UPDATE SCRIPT
//		Both fro active surveillance and radical prostatectomy project
//=================================================================================================================

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

$files_path = "C:/_NicolasLuc/Server/www/tfri_cpcbn/data/todo/";
//$files_path = "/ATiM/atim-tfri/dataUpdate/cpcbn/UpdateClinicalData/data/";

// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	'V0_2016-11-25_151020_UHNRT_Update of patients RNA_DNA_For Veronique_nl_revised.xls' => $mac_xls_offset,
	'VO_HDQupdate2016_nl_revised.xls' => $windows_xls_offset,
	'VO_klotz batch3-2016_nl_revised.xls' => $windows_xls_offset,
	'VO_klotzbatch1-2016_nl_revised.xls' => $windows_xls_offset,
	'VO_klotzbatch2-2016_nl_revised.xls' => $windows_xls_offset,
	'VO_manitobaASupdate20128Nov16_nl_revised.xls' => $windows_xls_offset,
	'VO_mcgill update 2016_nl_revised.xls' => $windows_xls_offset,
	'VO_update fleshner2016_nl_revised.xls' => $windows_xls_offset,
	'VO_VPCupdate2016_nl_revised.xls' => $mac_xls_offset,
);

?>