<?php 

$migration_process_version = 'v0.1';

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "tfricoeur";
$db_charset		= "utf8";

$excel_files_paths = 'C:\_NicolasLuc\Server\www\tfri_coeur\TmpData\2017-10-05\2017-08-00/';
$migration_user_id = 2;

// $file_xls_offset Serial number $windows_xls_offset = 36526 & $mac_xls_offset = 35064 (Use for excel date parsing)
$windows_xls_offset = 36526;
$mac_xls_offset = 35064;
$bank_excel_files = array(
//     array(
// 	    'bank' => 'McGill',
// 		'file' => 'COEUR-Dec2016-McGill2016_nl_revised.xls',
// 		'worksheets' => array('data', 'treatment'),
// 		'file_xls_offset' => $windows_xls_offset,
// 		'parser_function' => 'General'
// 	),
//     array(
//         'bank' => 'MOBP',
//         'file' => 'COEUR-MOBP-master2016 updated 2017_nl_revised.xls',
//         'worksheets' => array('data', 'Sheet2'),
//         'file_xls_offset' => $windows_xls_offset,
//         'parser_function' => 'General'
//     ),
//     array(
//         'bank' => 'OHRI',
//         'file' => 'COEUR-OHRI-master2016 corrected_nl_revised.xls',
//         'worksheets' => array('data', 'treatment'),
//         'file_xls_offset' => $windows_xls_offset,
//         'parser_function' => 'General'
//     ),
    array(
        'bank' => 'OTB',
        'file' => 'COEUR-OTB-full clinical data report2017.xls',
        'worksheets' => array('Patients', 'Treatment'),
        'file_xls_offset' => $windows_xls_offset,
        'parser_function' => 'Otb'
    )
);
