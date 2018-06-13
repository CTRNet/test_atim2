<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "chumtransplant";

$isserver = false;
if($isserver) {
    $db_pwd			= "am3-y-4606";
    $db_schema		= "";
}

$db_charset		= "utf8";

$migration_user_id = 9;

//-- EXCEL FILE NAMES ---------------------------------------------------------------------------------------------------------------------------

$excel_files_paths = "C:/_NicolasLuc/Server/www/chum_transplant/scripts/v2.7.0/initial_sample_data_migration/";
if($isserver) $excel_files_paths = "/ATiM/atim-kidney-transplant/Test/scripts/v2.7.0/initial_sample_data_migration/";

$excel_file_names = array(
    //Step1
    'main' => 'CRCHUM - biorepository - Box Position.xls',
    'participants' => 'Pour Nicolas - Liste patients BD migration ATiM.xls',
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
    'slides' => array('Transpl. Rein_Lames 2014.xls'),
    //Step3
    'aliquot_uses' => array('Degel et retrait de la BDD.xls') 
);

?>