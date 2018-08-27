<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "chumtransplant";

$isserver = true;
if($isserver) {
    $db_pwd			= "am3-y-4606";
    $db_schema		= "atimkidneytransplanttest";
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


Attention les formats des boites sont à intervertir.

Dans la premiere analyse
A1 B1 C1 D1 ...
A2 B2 C2 ...
A3 B3 ...
A4 ...

Or cela devrait être
A1 A2 A3 A4 ...
B1 B2 B3 ...
C1 C2 ...
D1 ...




