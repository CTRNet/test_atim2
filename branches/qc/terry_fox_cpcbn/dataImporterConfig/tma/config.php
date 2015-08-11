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

$files_path = "C:/_Perso/Server/tfri_cpcbn/data/";

$excel_files = array(
	array('150602_TMA_layout_ATiM_AA-1-2-3_05-08-2015_CC.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150602_TMA_layout_ATiM_AA-4-6-Repunch-test_05-08-2015_CC.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150602_TMA_layout_ATiM_FS4-5-Test-Repunch_05-08-2015_CC.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150602_TMA_layout_ATiM_LL1-2-3_05-08-2015_CC.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150602_TMA_layout_ATiM_MG-1-2-3_05-08-2015_CC.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150602_TMA_layout_ATiM_MG-4-6-TEAM-test-repunch-testrepunch_CC_05-08-2015_CC.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150602_TMA_layout_ATiM_MG-5_05-08-2015_CC.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150616_TMA_layout_ATiM_NF-1-2_MODOFICATION CORE LOCATION_05-08-2015_CC.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150618_TMA_layout_ATiM_FS1-2-3_05-08-2015_CC_nl_mod.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150618_TMA_layout_ATiM_LL-5_CC_05-08-2015.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150618_TMA_layout_ATiM_LL-6-7-Test-Repunch_CC_05-08-2015_CC.xls', 'Core', '2015-05-01', 'd', '05-2015'),
	array('150618_TMA_layout_ATiM_NF-4-5_CC_05-08-2015_CC.xls', 'Core', '2015-05-01', 'd', '05-2015')		
);

//-- TMA TO REMOVE ---------------------------------------------------------------------------------------------------------------------------

$tma_name_to_remove = array(
	'CHUM-FS-1',
	'CHUM-FS-2',
	'CHUM-FS-3',
	'CHUM-FS-4',
	'CHUM-FS-5',
	'CHUM-FS-Repunch',
	'CHUM-FS-Test',
	'CHUQ-LL-1',
	'CHUQ-LL-2',
	'CHUQ-LL-3',
	'CHUQ-LL-5',
	'CHUQ-LL-6',
	'CHUQ-LL-7',
	'CHUQ-LL-Repunch',
	'CHUQ-LL-Test',
	'MUHC-AA-1',
	'MUHC-AA-2',
	'MUHC-AA-3',
	'MUHC-AA-4',
	'MUHC-AA-6',
	'MUHC-AA-Repunch',
	'MUHC-AA-Test',
	'TEAM-testTMA-Repunch',
	'UHN-NF-1',
	'UHN-NF-2',
	'UHN-NF-4',
	'UHN-NF-5',
	'VPC-MG-1',
	'VPC-MG-2',
	'VPC-MG-3-Test2',
	'VPC-MG-4-Test',
	'VPC-MG-5',
	'VPC-MG-6',
	'VPC-Repunch',
	'VPC-Test-Repunch'	
);

?>