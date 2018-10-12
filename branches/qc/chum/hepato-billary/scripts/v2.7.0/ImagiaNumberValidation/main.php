<?php

//First Line of any main.php file
require_once __DIR__.'/system.php';

$is_test_import_process = false;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $is_test_import_process = true;   
    } else {
        die('ERR ARG : '.$argv[1].' (should be test)');
    }
}

// ==============================================================================================================
// Open Excel File
// ==============================================================================================================

if (($handle = fopen($csv_files_paths.$csv_file_name, "r")) === FALSE) {
    die('ERR Wrong CSV file - '.$csv_files_paths.$csv_file_name);
}

// Get heraders
$csvHeaders = fgetcsv($handle, 1000, ";");

// ==============================================================================================================
// Reade Excel File
// ==============================================================================================================

$hospitalMiscIdentifierControlIds = $atim_controls['misc_identifier_controls']['saint_luc_hospital_nbr']['id'];
$ramqMiscIdentifierControlIds = $atim_controls['misc_identifier_controls']['health_insurance_card']['id'];
$studyMiscIdentifierControlIds = $atim_controls['misc_identifier_controls']['study number']['id'];

$studyIdIvado = getSelectQueryResult("SELECT id, title FROM study_summaries WHERE title IN ('IVADO')");
$studyIdIvado = $studyIdIvado[0]['id'];
$studyIdImagia = getSelectQueryResult("SELECT id, title FROM study_summaries WHERE title IN ('IMAGIA')");
$studyIdImagia = $studyIdImagia[0]['id'];

// ==============================================================================================================
// Get ATiM data
// ==============================================================================================================

$atimImagiaIvadoNbrFromBankNbrs = array();

$query = "SELECT
    Participant.id AS participant_id,
    Participant.participant_identifier,
    Ramq.identifier_value AS ramq,
    Hosp.identifier_value AS sl_hospital_numbers,
    Ivado.identifier_value AS ivado_numbers,
    Imagia.identifier_value AS imagia_numbers
    FROM participants Participant
    LEFT JOIN misc_identifiers Ramq ON Ramq.deleted <> 1 AND Ramq.participant_id = Participant.id AND Ramq.misc_identifier_control_id = $ramqMiscIdentifierControlIds
    LEFT JOIN misc_identifiers Hosp ON Hosp.deleted <> 1 AND Hosp.participant_id = Participant.id AND Hosp.misc_identifier_control_id = $hospitalMiscIdentifierControlIds
    LEFT JOIN misc_identifiers Ivado ON Ivado.deleted <> 1 AND Ivado.participant_id = Participant.id AND Ivado.misc_identifier_control_id = $studyMiscIdentifierControlIds AND Ivado.study_summary_id = $studyIdIvado
    LEFT JOIN misc_identifiers Imagia ON Imagia.deleted <> 1 AND Imagia.participant_id = Participant.id AND Imagia.misc_identifier_control_id = $studyMiscIdentifierControlIds AND Imagia.study_summary_id = $studyIdImagia
    WHERE Participant.deleted <> 1
    AND Participant.id IN (
        SELECT participant_id FROM misc_identifiers WHERE deleted <> 1 AND Ivado.misc_identifier_control_id = $studyMiscIdentifierControlIds AND Ivado.study_summary_id IN ($studyIdImagia, $studyIdIvado)
    );";
$atimPatientData = array();
$ivadoUniqueCheck = array();
$imagiaUniqueCheck = array();
foreach(getSelectQueryResult($query) as $tmpNewPatient) {
    if(isset($atimPatientData[$tmpNewPatient['participant_identifier']])) {
        // On ivado & imagia nbr per patient
        pr($tmpNewPatient);
        pr($atimPatientData);
        die('ERR 848848738');
    }
    if(strlen($tmpNewPatient['ivado_numbers']) && isset($ivadoUniqueCheck[$tmpNewPatient['ivado_numbers']])) {
        // ivado nbr unique
        $errorMsg['ivado_numbers duplicated into ATim'][] = 'See ivado_numbers nbr ' . $tmpNewPatient['ivado_numbers'] . 
            ' assigned to bank#'.$imagiaUniqueCheck[$tmpNewPatient['ivado_numbers']]['participant_identifier'].' & bank#'.$tmpNewPatient['participant_identifier'].
            ' (participant_id '.$imagiaUniqueCheck[$tmpNewPatient['ivado_numbers']]['participant_id'].' & '.$tmpNewPatient['participant_id'].').';
    }
    if(strlen($tmpNewPatient['imagia_numbers']) && isset($imagiaUniqueCheck[$tmpNewPatient['imagia_numbers']])) {
        // imagia nbr unique
        $errorMsg['imagia_numbers duplicated into ATim'][] = 'See imagia_numbers  nbr ' . $tmpNewPatient['imagia_numbers'] . 
            ' assigned to bank#'.$imagiaUniqueCheck[$tmpNewPatient['imagia_numbers']]['participant_identifier'].' & bank#'.$tmpNewPatient['participant_identifier'].
            ' (participant_id '.$imagiaUniqueCheck[$tmpNewPatient['imagia_numbers']]['participant_id'].' & '.$tmpNewPatient['participant_id'].').';
    }
    $atimPatientData[$tmpNewPatient['participant_identifier']] = $tmpNewPatient;
    $atimPatientData[$tmpNewPatient['participant_identifier']]['found_into_csv'] = false;
    $ivadoUniqueCheck[$tmpNewPatient['ivado_numbers']] = $tmpNewPatient;
    $imagiaUniqueCheck[$tmpNewPatient['imagia_numbers']] = $tmpNewPatient;
    //Check ivado vs Imagia
    if(strlen($tmpNewPatient['imagia_numbers'])) {
       if($tmpNewPatient['imagia_numbers'] != $tmpNewPatient['ivado_numbers']) {
            // if imagia nbr, ivado = imagia nbr
            pr($tmpNewPatient);
            die('ERR 34343 7');
       }
    }
}

$bankNbrMissing = array();
$participantNotFoundIntoAtiM = array();
while (($newCsvLineData = fgetcsv($handle, 1000, ";")) !== FALSE) {
    $csvLindeData = array();
    foreach($newCsvLineData as $key => $csvValue) {
        $csvValue = trim($csvValue);
        $csvLindeData[$csvHeaders[$key]] = $csvValue;
    }
    $csvBankNbr = $csvLindeData['Bank Nbr'];
    $csvImagiaNbr = $csvLindeData['ID IMAGIA'];
    if($csvImagiaNbr == '.') $csvImagiaNbr = '';
    $csvSlNbr = $csvLindeData['CHUM St-Luc Hospital Number'];
    $csvRamq = $csvLindeData['RAMQ'];
    
    if(!isset($atimPatientData[$csvBankNbr])) {
        if(isset( $bankNbrMissing[$csvBankNbr])) die('ERR23423429');
        $bankNbrMissing[$csvBankNbr] = "See csv values Bank#$csvBankNbr, Imagia#$csvImagiaNbr.";
        $errorMsg['Excel participant not defined as IVADO participant into ATiM'][] = "See csv values Bank#$csvBankNbr, Imagia#$csvImagiaNbr.";
    } else {
        $atimPatientData[$csvBankNbr]['found_into_csv'] = true;
        if(!isset($atimPatientData[$csvBankNbr]['ivado_numbers'])) {
            die('ERR27ss343453');
        }
        
        if(trim($atimPatientData[$csvBankNbr]['ramq']) != trim($csvRamq)) {
            $errorMsg['excel ramq different than atim ramq'][] = "See excel ramq [$csvRamq] vs atim ramq [" . $atimPatientData[$csvBankNbr]['ramq'] .
                '] assigned to bank#'. $csvBankNbr.' (participant_id '.$atimPatientData[$csvBankNbr]['participant_id'].').';
        }
        if(trim($atimPatientData[$csvBankNbr]['sl_hospital_numbers']) != trim($csvSlNbr)) {
            $errorMsg['excel sl nbr different than atim sl nbr'][] = "See excel sl nbr [$csvSlNbr] vs atim sl nbr [" . $atimPatientData[$csvBankNbr]['sl_hospital_numbers'] .
                '] assigned to bank#'. $csvBankNbr.' (participant_id '.$atimPatientData[$csvBankNbr]['participant_id'].').';
        }
        if(strlen($csvImagiaNbr)) {
            if($atimPatientData[$csvBankNbr]['imagia_numbers'] != $csvImagiaNbr) {
                $errorMsg['excel imagia nbr different than atim imagia nbr'][] = "See excel imagia nbr [$csvImagiaNbr] vs atim imagia nbr [" . $atimPatientData[$csvBankNbr]['imagia_numbers'] .
                    '] assigned to bank#'. $csvBankNbr.' (participant_id '.$atimPatientData[$csvBankNbr]['participant_id'].').';
            
            }
        }
    }
}

foreach($atimPatientData as $tmpNewPatient) {
    if(!$tmpNewPatient['found_into_csv']) {
        $errorMsg['atim ivado participant not found into csv file'][] = "See bank#".$tmpNewPatient['participant_identifier']." (participant_id = ".$tmpNewPatient['participant_id'].").";
    }
}
$bankNbrMissingTmp = array_keys($bankNbrMissing);
$bankNbrMissingTmp = array_filter($bankNbrMissingTmp);
$bankNbrMissingStrg = implode(',',$bankNbrMissingTmp);
$query = "SELECT
    Participant.id AS participant_id,
    Participant.participant_identifier,
    Ivado.identifier_value AS ivado_numbers,
    Imagia.identifier_value AS imagia_numbers
    FROM participants Participant
    LEFT JOIN misc_identifiers Ivado ON Ivado.deleted <> 1 AND Ivado.participant_id = Participant.id AND Ivado.misc_identifier_control_id = $studyMiscIdentifierControlIds AND Ivado.study_summary_id = $studyIdIvado
    LEFT JOIN misc_identifiers Imagia ON Imagia.deleted <> 1 AND Imagia.participant_id = Participant.id AND Imagia.misc_identifier_control_id = $studyMiscIdentifierControlIds AND Imagia.study_summary_id = $studyIdImagia
    WHERE Participant.deleted <> 1
    AND Participant.participant_identifier IN ($bankNbrMissingStrg);";
foreach(getSelectQueryResult($query) as $tmpNewPatient) {
    if(strlen($tmpNewPatient['ivado_numbers']) || strlen($tmpNewPatient['imagia_numbers'])) {
        die('ERR2347823687236');
    }
    unset($bankNbrMissing[$tmpNewPatient['participant_identifier']]);
}
if($bankNbrMissing) {
    die('ERR327823678236');
}
pr($errorMsg);