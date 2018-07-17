<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "tfricoeur";
$db_charset		= "utf8";

$excel_files_paths = 'C:\_NicolasLuc\Server\www\tfri_coeur\data\update 2017\Batch3/';

$is_serveur = true;
if($is_serveur) {
    $db_pwd			= "";
    $db_schema		= "";
    $excel_files_paths = "/ATiM/atim-tfri/dataUpdate/coeur/data/";
}
$migration_user_id = 2;

// $file_xls_offset Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064 (Use for excel date parsing)
$windows_xls_offset = 36526;
$mac_xls_offset = 35064;
$bank_excel_files = array(
//     array(
//         'bank' => 'CBCF',
//         'file' => 'COEUR_all_data_CBCF_CC.xls',
//         'worksheets' => array('Feuil1', ''),
//         'file_xls_offset' => $windows_xls_offset,
//         'parser_function' => 'General'
//     ),
//     array(
//         'bank' => 'CHUM',
//         'file' => 'COEUR_all_data_CHUM_CC_07052018.xls',
//         'worksheets' => array('DATA_CHUM', 'CA125_CHUM_2012'),
//         'file_xls_offset' => $windows_xls_offset,
//         'parser_function' => 'General'
//     ),
//     array(
//         'bank' => 'OVCARE',
//         'file' => 'COEUR_all_data_OVCARE_CC_revised_20180503.xls',
//         'worksheets' => array('Vancouver Data', 'Feuil1'),
//         'file_xls_offset' => $windows_xls_offset,
//         'parser_function' => 'General'
//     ),
//     array(
//         'bank' => 'UHN',
//         'file' => 'COEUR_all_data_UHN_CC_20180503.xls',
//         'worksheets' => array('Data UHN', 'UHN TXT CA125'),
//         'file_xls_offset' => $windows_xls_offset,
//         'parser_function' => 'General'
//     ),
//     array(
//         'bank' => 'OTB',
//         'file' => 'Masterlist-OTB-2017v2_CC_20180502.xls',
//         'worksheets' => array('Sheet1', ''),
//         'file_xls_offset' => $windows_xls_offset,
//         'parser_function' => 'Otb'
//     ),
//     array(
//         'bank' => 'CHUQ',
//         'file' => 'CHUQ-sent to Cecil(2017-09-28)_CC_case_to_update.xls',
//         'worksheets' => array('Sheet1', ''),
//         'file_xls_offset' => $windows_xls_offset,
//         'parser_function' => 'General'
//     )
);
