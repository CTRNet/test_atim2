<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "chumkidneytransplant";

$isserver = true;
if($isserver) {
    $db_user 		= "kidneytransplant";
    $db_pwd			= "";
    $db_schema		= "atimkidneytransplantprod";
}

$db_charset		= "utf8";

$migration_user_id = 9;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$excel_files_paths = "C:/_NicolasLuc/Server/www/chum_kidney_transplant/scripts/v2.7.0/initial_sample_data_migration/";
if($isserver) $excel_files_paths = "/ATiM/atim-kidney-transplant/Prod/scripts/v2.7.0/initial_sample_data_migration/";

$excel_file_names = array(
    //Step1
    'main' => 'Nelson_CRCHUM-specimens-2018-08-24_reformated-and-corrected_stp3 for migration.csv',
    'participants' => 'Pour Nicolas - Liste patients BD migration ATiM_20180827_revised.xls',
    'comments' => 'Nelson_CRCHUM-collectionEventComments-2018-08-24 for migration.xls',
    //Step2
    'blocks' => array(
        'Transpl. Rein_2011_HD.xls',
        'Transpl. Rein_2012_HD.xls',
        'Transpl. Rein_2013_HD.xls',
        'Transpl. Rein_2013_ND.xls',
        'Transpl. Rein_2013_SL.xls',
        'Transpl. Rein_2014 _SL.xls',
        'Transpl. Rein_2014_HD.xls',
        'Transpl. Rein_2014_ND.xls'),
    'slides' => array(
        'Transpl. Rein_ Lames 2011.xls',
        'Transpl. Rein_ Lames 2012.xls',
        'Transpl. Rein_ Lames 2013.xls',
        'Transpl. Rein_ Lames 2014 HD.xls',
        'Transpl. Rein_Lames 2014.xls'),
    //Step3
    'aliquot_uses' => array('Degel et retrait de la BDD.xls') 
);

?>