<?php 


/*
 
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

*/


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

$files_path = "C:/_NicolasLuc/Server/www/tfri_cpcbn_import_tmp/IN/Migration Feb 2019/";
//$files_path = "/ATiM/atim-tfri/dataUpdate/cpcbn/UpdateClinicalData/data/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
//	'VO_20181217-Klotz-AS-TFRI-CPCBN-clinicaldataV4_nl_revised.xls' => $windows_xls_offset,
//  'VO_CHUM AS TFRI-CPCBN-clinical data.V4_nl_revised.xls' => $windows_xls_offset,
//    'VO_CHUM-update2017-clinical data.V4_nl_revised.xls' => $mac_xls_offset,
//    'VO_CHUQTFRI-CPCBN.V4 update 2017natrevised_nl_revised.xls' => $windows_xls_offset,
//        'VO_Manitoba TFRI_CPCBN-clinical date 2017update natreviewed_nl_revised.xls' => $windows_xls_offset,
//        'VO_MUHC.TFRI-CPCBN-clinical data.V4-Aprikian-natreviewed_nl_rewied.xls' => $windows_xls_offset,
//    'VO_TFRI-CPCBN-clinical data.V4-Gleave2017 update-natreviewed_nl_reviewed.xls' => $windows_xls_offset
    
    
    'VO_TFRI-CPCBN-clinical data.V4updatedUHN, natrevised_nl_reviewed.xls' => $windows_xls_offset
    
);

?>