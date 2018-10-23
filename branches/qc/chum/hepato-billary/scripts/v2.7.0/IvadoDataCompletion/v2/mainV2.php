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
$csvHeaders = fgetcsv($handle, 1000, ",");
if(!validateHeaders($csvHeaders)) {
    die('ERR Wrong CSV file headers - '.$csv_files_paths.$csv_file_name);
}
    
// ==============================================================================================================
// Reade Excel File
// ==============================================================================================================

$hospitalMiscIdentifierControlIds = "'".
    $atim_controls['misc_identifier_controls']['hotel_dieu_hospital_nbr']['id']."','".
    $atim_controls['misc_identifier_controls']['notre_dame_hospital_nbr']['id']."','".
    $atim_controls['misc_identifier_controls']['saint_luc_hospital_nbr']['id']."'";
$ramqMiscIdentifierControlIds = "'".$atim_controls['misc_identifier_controls']['health_insurance_card']['id']."'";

global $messages;
$messages = array();
$atimImageCreationsUpdatesSummary = array();
$counter = array(
    'Number of csv rows' => 0,
    'Number of csv file participants' => 0,
    'Number of ATiM participants found' => 0,
    'Number of ATiM participants rejected (no RAMQ or Hospital number matching)' => 0,
    'Number of ATiM participants validated with confidence index equal to 1 (either RAMQ or Hospital number matching)' => 0,
    'Number of ATiM participants validated with confidence index equal to 2 (both RAMQ and Hospital number matching)' => 0,
    'Number of ATiM images found and updated (ACC_NUM associated to the ATiM image)' => 0,
    'Number of new images created into ATiM' => 0,
    'Number of ATiM images found but not updated (ACC_NUM already exists into ATIM)' => 0,
    'Number of csv images matching ATiM images on date but the image types association (csv to ATiM) does not exist (not defined by S. Turcotte)' => 0
);

global $csvImageTypeToAtiMImageType;
$csvImageTypeToAtiMImageType = array();
$atimParticipantNominalDataFromBankNbr = array();
$atimParticipantImagesDataFromParticipantId = array();

$import_date_for_summary = substr($import_date, 0, 10);

$csvLineNumber = 1;
$expectedHeaders = getExpectedHeaders();
$expectedHeaders = array_flip($expectedHeaders);
while (($newCsvLineData = fgetcsv($handle, 1000, ",")) !== FALSE) {
    $csvLineNumber++;
    $counter['Number of csv rows']++;
    $csvParticipantBankNumber = $newCsvLineData[$expectedHeaders['bank_number']];
    $csvFirstName = $newCsvLineData[$expectedHeaders['first_name']];                                    // Just considered by the script for message
    $csvLastName = $newCsvLineData[$expectedHeaders['last_name']];                                      // Just considered by the script for message
    $csvHospital = $newCsvLineData[$expectedHeaders['hospital']];
    $csvHospitalNbr = ($newCsvLineData[$expectedHeaders['dossier_if_matched']] == 'NA')? '' : $newCsvLineData[$expectedHeaders['dossier_if_matched']];    
                                                                                                        // Only hospital number matching the hospital number we shared with the data warehouse will be part of the csv file
    $csvRamq = ($newCsvLineData[$expectedHeaders['nam_if_matched']] == 'NA')? '' : $newCsvLineData[$expectedHeaders['nam_if_matched']];    
                                                                                                        // Only RAMQ matching the RAMQ we shared with the data warehouse  will be part of the csv file
    // $csvDateOfBirth = $newCsvLineData[$expectedHeaders['dob_if_matched']];                           // Only date of birth matching the date of birth we shared with the data warehouse  will be part of the csv file
    // $accessionid = $newCsvLineData[$expectedHeaders['accessionid']];                                 // Not considered by the script
    $csvEventDate = $newCsvLineData[$expectedHeaders['orderdtm']];
    $csvAccessNbr = $newCsvLineData[$expectedHeaders['examid']];
    $csvImageType = $newCsvLineData[$expectedHeaders['codes_examens']];
    
    // Build line description for message
    $tmpIdentifiers = array();
    if (!empty($csvRamq)) {
        $tmpIdentifiers[] = "RAMQ $csvRamq";
    }
    if (!empty($csvHospitalNbr)) {
        $tmpIdentifiers[] = "Hospital Nbr $csvHospitalNbr";
    }
    $participantDataForMessageStrg = "CSV participant {csv data : $csvFirstName $csvLastName [Bank#$csvParticipantBankNumber]" . (empty($tmpIdentifiers)? "" : " with " . implode(' & ', $tmpIdentifiers)) . " } on line $csvLineNumber";
    
    // Look for the ATiM participant
    // ---------------------------------------------------------------------------------------------------------
    if($newCsvLineData[$expectedHeaders['bank_number_name']] != 'onco - hepatopancreatobiliary') {
        $messages['ERROR']["Wrong participant bank number title ('onco - hepatopancreatobiliary' expected)! Csv data of the row won't be used to update ATiM data!"][] = $newCsvLineData[$expectedHeaders['bank_number_name']]  . " : See $participantDataForMessageStrg.";
        continue;
    }
    if(!$csvParticipantBankNumber) {
        $messages['ERROR']["The participant bank number is not recorded into the csv file! Csv data of the row won't be used to update ATiM data!"][] = "See $participantDataForMessageStrg.";
        continue;
    }
    if (!isset($atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber])) {
        $counter['Number of csv file participants']++;
        $query = "SELECT 
                Participant.id AS participant_id, 
                Participant.participant_identifier, 
                Participant.first_name, 
                Participant.last_name,
                Participant.date_of_birth,
                Ramq.identifier_value AS ramq,
                GROUP_CONCAT(Hosp.identifier_value SEPARATOR '&') AS hospital_numbers
            FROM participants Participant
            LEFT JOIN misc_identifiers Ramq ON Ramq.deleted <> 1 AND Ramq.participant_id = Participant.id AND Ramq.misc_identifier_control_id IN ($ramqMiscIdentifierControlIds)
            LEFT JOIN misc_identifiers Hosp ON Hosp.deleted <> 1 AND Hosp.participant_id = Participant.id AND Hosp.misc_identifier_control_id IN ($hospitalMiscIdentifierControlIds)
            WHERE Participant.deleted <> 1
            AND Participant.participant_identifier = '$csvParticipantBankNumber'
            GROUP BY  
                Participant.id, 
                Participant.participant_identifier, 
                Participant.first_name, 
                Participant.last_name,
                Participant.date_of_birth,
                Ramq.identifier_value";
        $atimPatientData = getSelectQueryResult($query);
        if(sizeof($atimPatientData) > 1) {
            pr($atimPatientData);
            die('ERRR#system#2342342342');
            exit;
        } else if(!$atimPatientData) {
            $atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber] = '-1';
            $messages['ERROR']["No ATiM participant can be selected with the csv participant bank number! Csv data of the row won't be used to update ATiM data!"][] = "See  $participantDataForMessageStrg (and other line(s)..).";
        } else {
            $counter['Number of ATiM participants found']++;
            $atimPatientData = array_shift($atimPatientData);
            $atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber] = $atimPatientData;  
            $atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber]['confidence_index'] = array();
        }        
    }
    
    // Define the confidence index for the ATiM participant selected
    // ---------------------------------------------------------------------------------------------------------
    $confidenceIndexKey = "$csvRamq#$csvHospitalNbr";
    if( $atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber] != '-1' && !array_key_exists($confidenceIndexKey, $atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber]['confidence_index'])) {
        $atimPatientData = $atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber];
        $participantId = $atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber]['participant_id'];
        $participantIdMsg = "(atim_participant_id = $participantId)";
        $confidenceIndex = 0;
        $matchOn = array();
        if($csvRamq && $csvRamq == $atimPatientData['ramq']) {
            $confidenceIndex++;
            $matchOn[] = 'RAMQ';
        }
        $atimHospitalNbr = explode('&', $atimPatientData['hospital_numbers']);
        if($csvHospitalNbr && in_array($csvHospitalNbr, $atimHospitalNbr)) {
            $confidenceIndex++;
            $matchOn[] = "$csvHospital hospital number";
        }
        if(sizeof($atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber]['confidence_index'])) {
            $messages['WARNING']["A same participant is linked to more than one RAMQ and hosiptal number into the csv file! Please validate!"][] = "See ATiM participant ".$atimPatientData['first_name']." ".$atimPatientData['last_name']." $participantIdMsg that matches (on bank number) the $participantDataForMessageStrg (and other line(s)..).";
        }
        $atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber]['confidence_index'][$confidenceIndexKey] = $confidenceIndex;
        $matchOn = implode((' & '), $matchOn);
        if($confidenceIndex == 0) {
            $counter['Number of ATiM participants rejected (no RAMQ or Hospital number matching)']++;
            $messages['ERROR']["ATiM participant selected from csv participant bank number is linked to RAMQ and hospital number that do not match the csv values! Csv data of the row won't be used to update ATiM data!"][] = "See ATiM RAMQ '".$atimPatientData['ramq']."' & hospital number '".$atimPatientData['hospital_numbers']."' of the ATiM participant ".$atimPatientData['first_name']." ".$atimPatientData['last_name']." $participantIdMsg that matches (on bank number) the $participantDataForMessageStrg (and other line(s)..).";
        } elseif ($confidenceIndex == 1) {
            $counter['Number of ATiM participants validated with confidence index equal to 1 (either RAMQ or Hospital number matching)']++;
            $messages['WARNING']["ATiM participant selected from csv participant bank number has only a $matchOn that is equal to the csv value! Csv data of the row will be used to update ATiM data, but please validate!"][] = "See ATiM participant ".$atimPatientData['first_name']." ".$atimPatientData['last_name']." $participantIdMsg that matches (on bank number) the $participantDataForMessageStrg (and other line(s)..).";
        } else {
            $counter['Number of ATiM participants validated with confidence index equal to 2 (both RAMQ and Hospital number matching)']++;
        }
    }
    
    // Validate csv image has to be improted
    // ---------------------------------------------------------------------------------------------------------
    $atimImageType = getAtimImageTypeFromCsvImageType($csvImageType);
      
    // Launch the atim data update or creation
    // ---------------------------------------------------------------------------------------------------------
    if($atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber] != '-1' && $atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber]['confidence_index'][$confidenceIndexKey]) {
        $participantId = $atimParticipantNominalDataFromBankNbr[$csvParticipantBankNumber]['participant_id'];
        $participantIdMsg = "(atim_participant_id = $participantId)";
        // Load ATiM participant image
        if(!array_key_exists($participantId, $atimParticipantImagesDataFromParticipantId)) {
            $query = "SELECT 
                    event_master_id, 
                    event_date, 
                    event_date_accuracy,
                    request_nbr, 
                    event_type, 
                    event_summary
                FROM event_masters EventMaster
                INNER JOIN qc_hb_ed_hepatobilary_medical_imagings EventDetail ON EventMaster.id = event_master_id
                INNER JOIN event_controls EventControl ON EventControl.id = EventMaster.event_control_id
                WHERE deleted <> 1
                AND participant_id = $participantId;";
            $atimPatientImages = getSelectQueryResult($query);
            $atimParticipantImagesDataFromParticipantId[$participantId] = array();
            foreach($atimPatientImages as $newAtimPatientImage) {
                $atimParticipantImagesDataFromParticipantId[$participantId][$newAtimPatientImage['event_date']][$newAtimPatientImage['event_type']][] = $newAtimPatientImage;
            }
        }
        // Check csv image date format
        if(!preg_match('/^([0-9]{4}\-[0-9]{2}-[0-9]{2})\ [0-9]{2}:[0-9]{2}:[0-9]{2}$/', $csvEventDate, $dateMatches)) {
            $messages['ERROR']["Wrong csv image date format! Csv data of the row won't be used to update ATiM data!"][] = "See csv date '".(empty($csvEventDate)? ' NULL' : $csvEventDate)."' for the $participantDataForMessageStrg.";
            $csvEventDate = '';
        } else {
            $csvEventDate = $dateMatches[1];
        }
        if(!empty($csvEventDate)) {
            if($atimImageType) {
                //Image date is set and an ATiM image type has been associated to the CSV image type
                if(isset($atimParticipantImagesDataFromParticipantId[$participantId][$csvEventDate][$atimImageType])) {
                    // Compare csv image and atim image
                    if(sizeof($atimParticipantImagesDataFromParticipantId[$participantId][$csvEventDate][$atimImageType]) > 1) {
                        $messages['WARNING']["More than one ATiM image ($atimImageType) matches both patient and date! Same image number will be attached to all ATiM exams! Please validate!"][] =  "See ATiM images on '$csvEventDate' and csv image '$csvImageType' $participantIdMsg defined for the $participantDataForMessageStrg.";  
                    }
                    foreach($atimParticipantImagesDataFromParticipantId[$participantId][$csvEventDate][$atimImageType] as &$newAtimImageToUpdate) {
                        $update = false;
                        $previousValue = '';
                        if(!$newAtimImageToUpdate['request_nbr']) {
                            $newAtimImageToUpdate['request_nbr'] = $csvAccessNbr;
                            $update = true;
                        } else  if(!preg_match("/$csvAccessNbr/", $newAtimImageToUpdate['request_nbr'])) {
                            $previousValue = $newAtimImageToUpdate['request_nbr'];
                            $newAtimImageToUpdate['request_nbr'] .= ' & '.$csvAccessNbr;
                        }
                        if($update) {
                            if(isset($newAtimImageToUpdate['just_created_updated'])) {
                                $event_summary = $newAtimImageToUpdate['event_summary'];
                            } else {
                                $event_summary = str_replace('..', '.',
                                    (strlen($newAtimImageToUpdate['event_summary'])? 
                                        $newAtimImageToUpdate['event_summary'].". 
                                        " : '').
                                    "Accession number updated by IVADO'S script on '$import_date_for_summary'.");
                            }
                            $data_to_update = array(
                                'event_masters' => array(
                                    'event_summary' => $event_summary),
                                $atim_controls['event_controls'][$newAtimImageToUpdate['event_type']]['detail_tablename'] => array(
                                    'request_nbr' => $newAtimImageToUpdate['request_nbr']));
                            updateTableData($newAtimImageToUpdate['event_master_id'], $data_to_update);
                            addToModifiedDatabaseTablesList('event_masters', $atim_controls['event_controls'][$newAtimImageToUpdate['event_type']]['detail_tablename']);
                            if (!strlen($previousValue)) {
                                $atimImageCreationsUpdatesSummary["Bank#$csvParticipantBankNumber"]['Update (added accession number)'][] = "Updated ATiM '".str_replace('medical imaging ', '', $atimImageType)."' on '$csvEventDate' with accession number '$csvAccessNbr' (previsously empty field into ATiM) from csv image '$csvImageType' defined for the $participantDataForMessageStrg.";
                            } else {
                                $atimImageCreationsUpdatesSummary["Bank#$csvParticipantBankNumber"]['Update (updated accession number)'][] = "Updated ATiM '".str_replace('medical imaging ', '', $atimImageType)."' on '$csvEventDate' with accession number '$csvAccessNbr' (changed value from '$previousValue' to '".$newAtimImageToUpdate['request_nbr']."') from csv image '$csvImageType' defined for the $participantDataForMessageStrg.";
                            }
                            if(!isset($newAtimImageToUpdate['just_created_updated'])) {
                                $counter['Number of ATiM images found and updated (ACC_NUM associated to the ATiM image)']++;
                            }
                        } else {
                            if(!isset($newAtimImageToUpdate['just_created_updated'])) {
                                $counter['Number of ATiM images found but not updated (ACC_NUM already exists into ATIM)']++;
                            }
                        }
                        $newAtimImageToUpdate['just_created_updated'] = 1;
                    }
                } else {
                    // Create a new ATiM image from csv image
                    $event_data = array(
                        'event_masters' => array(
                            'participant_id' => $participantId,
                            'event_control_id' => $atim_controls['event_controls'][$atimImageType]['id'],
                            'event_date' => $csvEventDate,
                            'event_date_accuracy' => 'c',
                            'event_summary' => "Created by IVADO'S script on $import_date_for_summary."),
                        $atim_controls['event_controls'][$atimImageType]['detail_tablename'] => array(
                            'request_nbr' => $csvAccessNbr));
                    $eventMasterId = customInsertRecord($event_data);
                    $atimImageCreationsUpdatesSummary["Bank#$csvParticipantBankNumber"]['Creation'][] = "Created ATiM '".str_replace('medical imaging ', '', $atimImageType)."' on '$csvEventDate' with accession number '$csvAccessNbr' from csv image '$csvImageType' defined for the $participantDataForMessageStrg.";  
                    $atimParticipantImagesDataFromParticipantId[$participantId][$csvEventDate][$atimImageType][] = array(
                        'event_master_id' => $eventMasterId,
                        'event_date' => $csvEventDate,
                        'event_date_accuracy' => 'c',
                        'request_nbr' => $csvAccessNbr,
                        'event_type' => $atimImageType,
                        'event_summary' => "Created by IVADO'S script on $import_date_for_summary.",
                        'just_created_updated' => 1
                    );
                    $counter['Number of new images created into ATiM']++;
                }
            } else {
                $messages['MESSAGE']["CSV image type has not been associated to an ATiM image type (by S. Turcotte)! Csv data of the row won't be used to update ATiM data!"][] = "See $participantDataForMessageStrg.";
                // Check csv scan does not match a atim scan on date
                if(isset($atimParticipantImagesDataFromParticipantId[$participantId][$csvEventDate])) {
                    $counter['Number of csv images matching ATiM images on date but the image types association (csv to ATiM) does not exist (not defined by S. Turcotte)']++;
                    foreach($atimParticipantImagesDataFromParticipantId[$participantId][$csvEventDate] as $atimImageType => $tmp) {
                        $messages['WARNING']["An ATiM image matches a CSV image on date but CSV image type has not been associated to the ATiM image type (by S. Turcotte)! Csv data of the row won't be used to update ATiM data!"][] = "See ATiM '".str_replace('medical imaging ', '', $atimImageType)."' on same date '$csvEventDate' than a csv image '$csvImageType' defined for $participantIdMsg the $participantDataForMessageStrg.";
                        $messages['TODO']["Check following CSV and ATiM image types association could be done (because images match on date for at least one participant)! Update script (getImageTypeAndTegexpToImport) if required"]["CSV [$csvImageType] vs ATiM [$atimImageType]"] = "CSV [$csvImageType] vs ATiM [$atimImageType]"; 
                    }
                }
            }
        }
    }
}
// Display migrated imaage type
ksort($csvImageTypeToAtiMImageType);
foreach($csvImageTypeToAtiMImageType as $xlsStudyDesc => $atimEventType) {
    if(strlen($atimEventType)) {
        $messages['MESSAGE']["CSV image type imported into ATiM for validation!"][] = "Csv [$xlsStudyDesc] migrated as an ATiM [".str_replace('medical imaging ', '', $atimEventType)."]";
    }
}

pr('== ======================================================================================================================== ==');
pr("==  ACC_NUM update summary");
pr('== ======================================================================================================================== ==');
pr("File (csv file with data from data warehouse) : $csv_file_name");
pr("Date : $import_date");
pr("Counter:");
foreach($counter as $title => $value) {
    pr(" -- $title : $value");
}
foreach(array('ERROR', 'WARNING', 'MESSAGE','TODO') as $messageType) {
    pr('<br><br>== ======================================================================================================================== ==');
    pr("== $messageType");
    pr('== ======================================================================================================================== ==');
    $counter = 0;
    foreach($messages[$messageType] as $title => $values) {
        $counter++;
        pr("<br>-- $messageType #$counter");;
        pr("-- $title");
        pr("-- -----------------------------------------------------------------------------------------------------------------------------------------------------<br>");
        foreach($values as $value) {
            pr(" ... $value");
        }
    }
    unset($messages[$messageType]);
}
if($messages) {
    die('ERR#9838839030#message');
}
pr('<br><br>== ======================================================================================================================== ==');
pr("==  ATiM data update/creation summary");
pr('== ======================================================================================================================== ==');
foreach($atimImageCreationsUpdatesSummary as $banknbr => $summary) {
    pr("<br>## Participant - $banknbr ##");
    pr("----------------------------------------");
    foreach($summary as $updateType => $updateData) {
        pr("<br> -- $updateType:<br>");
        foreach($updateData as $value) {
            pr(" ... $value");
        }
    }
}

insertIntoRevsBasedOnModifiedValues();
if(!$is_test_import_process) {
    mysqli_commit($db_connection);
}

// ==============================================================================================================
// Functions
// ==============================================================================================================

function validateHeaders($csvHeaders)
{
    $expectedHeaders = getExpectedHeaders();
    return (empty(array_diff_assoc($expectedHeaders, $csvHeaders)) && empty(array_diff_assoc($csvHeaders, $expectedHeaders)))? true : false;
}

function getExpectedHeaders() {
    return array(
        '0' => 'tmp',
        '1' => 'bank_number_name',
        '2' => 'bank_number',
        '3' => 'first_name',
        '4' => 'last_name',
        '5' => 'dossier_if_matched',
        '6' => 'hospital',
        '7' => 'nam_if_matched',
        '8' => 'dob_if_matched',
        '9' => 'accessionid',
        '10' => 'orderdtm',
        '11' => 'examid',
        '12' => 'codes_examens'
    );
}

function getAtimImageTypeFromCsvImageType($csvImageType) {
    global $csvImageTypeToAtiMImageType;
    global $messages;
    $atimImageType = '';
    if(array_key_exists($csvImageType, $csvImageTypeToAtiMImageType)) {
        $atimImageType = $csvImageTypeToAtiMImageType[$csvImageType];
    } else {
        $tmpEventType = array();
        foreach(getImageTypeAndTegexpToImport() as $tmpImageTypeToRegexp) {
            list($definedEventType, $definedRegExp) = $tmpImageTypeToRegexp;
            if(preg_match('/'.$definedRegExp.'/',$csvImageType)) {
                $tmpEventType[$definedEventType] = $definedEventType;
            }
        }
        if(!$tmpEventType) {
            $atimImageType = '';
            $messages['TODO']["CSV 'Image Type' has not been associated to an ATiM 'Image Type' (by S. Turcotte)! All images data linked to the following csv image type won't be imported! Please add image types match definitition to the script (see getImageTypeAndTegexpToImport())!"][$csvImageType] =  $csvImageType;
        } elseif(sizeof($tmpEventType) > 2) {
            die('ERR#imagetype#734839393 : '.$definedRegExp.' / ' .$csvImageType);
        } else {
            $atimImageType = array_shift($tmpEventType);
        }
        $csvImageTypeToAtiMImageType[$csvImageType] = $atimImageType;
    }
    return $atimImageType;
}

function getImageTypeAndTegexpToImport()
{
    $imageTypeToRegexp = array(
        array("medical imaging abdominal CT-scan", 'ANGIOSCAN ABDO\-PELVIEN'),
        array("medical imaging abdominal CT-scan", 'SCAN ABDO\-PELVIEN'),
        array("medical imaging abdominal CT-scan", 'COPIE DE FILMS DE EXT\(SCAN\) ABDOMEN'),
        array("medical imaging abdominal CT-scan", 'UROSCAN'),
        array("medical imaging abdominal CT-scan", 'SCAN ABDOMEN'),
        array("medical imaging abdominal CT-scan", 'SCAN PR.\-THERMOABLATION'),
        array("medical imaging abdominal CT-scan", 'FISTULO\-SCAN ABDOMEN'),
        array("medical imaging abdominal CT-scan", 'SCAN ABDOMINO\-PELVIEN'),
        array("medical imaging abdominal CT-scan", 'COPIE CT FILMS DE L\.EXTERIEUR \(ABDOMEN\)'),
    //    array("medical imaging abdominal CT-scan", 'SCAN ABDOMINO\-PELVIEN \(ANGIO\-SCAN\) '),
        array("medical imaging abdominal CT-scan", 'ENT.ROSCAN'),
        array("medical imaging abdominal CT-scan", 'ANGIOSCAN ABDOMEN'),
        array("medical imaging abdominal CT-scan", 'SCAN PELVIEN'),
        array("medical imaging abdominal CT-scan", 'CT Planification \- ABDOMINO\-PELVIEN'),
        array("medical imaging abdominal CT-scan", 'R.VISION DE FILMS EXT \(SCAN\) ABDOMEN'),
        array("medical imaging abdominal CT-scan", 'CYSTOSCAN'),
        array("medical imaging abdominal CT-scan", 'DRAINAGE ABDOMEN \(scan\)'),
        array("medical imaging abdominal CT-scan", 'PY.LOSCAN'),
    //    array("medical imaging abdominal CT-scan", 'ANGIOSCAN ABDO\-PELVIEN \(vasculaire\) '),
    //    array("medical imaging abdominal MRI", 'IRM FOIE \/ PANCR.AS'),
        array("medical imaging abdominal MRI", 'COPIE DE FILMS DE EXT\(IRM\) ABDOMEN'),
        array("medical imaging abdominal MRI", 'IRM FOIE'),
    //    array("medical imaging cerebral CT-scan", 'SCAN C.R.BRAL \(\+ MASTO.DES\) '),
        array("medical imaging cerebral CT-scan", 'SCAN C.R.BRAL '),
        array("medical imaging cerebral MRI", 'IRM TETE'),
        array("medical imaging cerebral MRI", 'IRM C.R.BRALE '),
        array("medical imaging chest CT-scan", 'SCAN THORAX'),
        array("medical imaging chest CT-scan", 'ANGIOSCAN THORAX EMBOLIE'),
        array("medical imaging chest CT-scan", 'COPIE DE FILMS DE EXT\(SCAN\) THORAX'),
    //    array("medical imaging chest CT-scan", 'SCAN THORAX EMBOLIE \(ANGIO\-SCAN\)'),
        array("medical imaging chest CT-scan", 'R?VISION DE FILMS EXT \(SCAN\) THORAX'),
        array("medical imaging chest CT-scan", 'ANGIOSCAN THORAX'),
    //    array("medical imaging pelvic MRI", 'IRM PELVIS OU BASSIN'),
        array("medical imaging pelvic MRI", 'IRM PELVIS'),
        array("medical imaging pelvic MRI", 'IRM BASSIN'),
        array("medical imaging TEP-scan", 'COPIE DE FILMS DE EXT \(PET\)'));
    return $imageTypeToRegexp;
}