<?php 



//-------------------------------------------------------------------------------------------------------------
//Note on 2018-03-20 from N. Luc
Please note that the code has been updated considering following rules but not tested:
  - durg_id field has been moved from TreatmentExtendDetail to TreatmentExtendMaster
  - qc_tf_txd_biopsies_and_turps.type values 'Bx Dx', 'TURP Dx', 'Bx Dx TRUS-Guided' have 
      been replaced by 'Bx', 'TURP', 'Bx TRUS-Guided' and qc_tf_txd_biopsies_and_turps.type_specification = 'Dx'
  - qc_tf_txd_biopsies_and_turps.type value 'Bx CHUM' has been replaced by 'Bx' 
      AND qc_tf_txd_biopsies_and_turps.sent_to_chum = '1'
          
Please test code during next update.
//-------------------------------------------------------------------------------------------------------------




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