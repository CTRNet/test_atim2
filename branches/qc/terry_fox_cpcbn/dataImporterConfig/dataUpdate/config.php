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

$files_path = "C:/_Perso/Server/tfri_cpcbn/data/update2014/";
// Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064;
$excel_files_names = array(
	'UHN -RTupdate_nl_revised_20150227.xls' => $mac_xls_offset,
	'mcgill2014 update_nl_revised_20150227.xls' => $windows_xls_offset,
	'Nov-25-2014 VPC Update TFRI-CPCBN Ali-1_nl_revised_20150227.xls' => $mac_xls_offset,
	'TFRI-CPCBN-clinical dataV2(1)   UpDate  2015-01-14 -HDQ_nl_revised_20150227.xls' => $mac_xls_offset,
	'TMA3 mcgill update patient and Pathology sent_nl_revised_20150227.xls' => $mac_xls_offset,
	'update 2014fleshner_nl_revised_2015022.xls' => $windows_xls_offset
);

?>