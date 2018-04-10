<?php

//First Line of any main.php file
require_once __DIR__.'/system.php';

$commit = false;

if(!testExcelFile(array($excel_file_name))) {
    dislayErrorAndMessage();
    exit;
}

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

$excelImageTypeToAtiMImageType = array();  

$updatedDataCounter = 0;
$hospitalMiscIdentifierControlIds = "'2','4','5'";
$xlsRramqMiscIdentifierControlIds = "'1'";
$worksheet_name = 'ivado_acc_list_project';
$messages = array();
$excelParticipantToAtimData = array();
$xlsAccessNbrCounter = 0;
$xlsAccessNbrMatchingNoDateCounter = 0;
$xlsAccessNbrMatchingDateCounter = 0;
$xlsAccessNbrCounterWithPatientNotFound = 0;
$dataAlreadyUpdatedCounter = 0;
$accessNbrWithUnsupportedStudyDescriptionCounter = 0;
$creations_updates_summary = array();
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
    $HospitalNumber = $excel_line_data['Patient ID'];
    if(preg_match('/^S(.*)$/', $HospitalNumber, $matches)) {
        $HospitalNumber = $matches[1];
    }
    $xlsRramq = $excel_line_data['Other Patient IDs'];
    $xlsEventDate = $excel_line_data['Study Date']; 
    if(!preg_match('/^([0-9]{4})([0-9]{2})([0-9]{2})$/', $xlsEventDate, $matches)) die('ERR 237826872368');
    $xlsEventDate = $matches[1].'-'.$matches[2].'-'.$matches[3];
    $xlsAccessNbr = $excel_line_data['Accession Number'];
    if($xlsAccessNbr) $xlsAccessNbrCounter++;
    $xlsParticipantNames = $excel_line_data["Patient's Name"];
    $xlsParticipantNamesSplit = explode('^', $xlsParticipantNames);
    $xlsParticipantNamesSplit = array_filter($xlsParticipantNamesSplit);
    $excel_participant_key = "$xlsRramq||||$HospitalNumber";
    $xlsStudyDescription = $excel_line_data['Study Description'];
    if(!array_key_exists($excel_participant_key, $excelParticipantToAtimData)) {
        if(strlen($HospitalNumber) < 4 || strlen($xlsRramq) < 4) {
            $messages['Participant with either a RAMQ or a Hospital Nbr too small! No image number will be imported!'][] = "Participant with RAMQ '$xlsRramq' AND St-Luc Nbr '$HospitalNumber'has not been found into ATiM working on both values! (See Line $line_number, etc)";
            $excelParticipantToAtimData[$excel_participant_key] = null;
        } else {
            $query = "SELECT Participant.id, participant_identifier, Participant.first_name, Participant.last_name
                FROM participants Participant 
                INNER JOIN misc_identifiers Ramq ON Ramq.deleted <> 1 AND Ramq.participant_id = Participant.id AND Ramq.misc_identifier_control_id IN ($xlsRramqMiscIdentifierControlIds)
                INNER JOIN misc_identifiers Hosp ON Hosp.deleted <> 1 AND Hosp.participant_id = Participant.id AND Hosp.misc_identifier_control_id IN ($hospitalMiscIdentifierControlIds)
                WHERE Participant.deleted <> 1
                AND Ramq.identifier_value = '$xlsRramq'
                AND Hosp.identifier_value = '$HospitalNumber'";
            $atimPatientData = getSelectQueryResult($query);
            if(!$atimPatientData) {
                $messages['Participant not found into ATiM! No image number will be updated!'][] = "Participant with RAMQ '$xlsRramq' AND St-Luc Nbr '$HospitalNumber'has not been found into ATiM working on both values! (See Line $line_number, etc)";
                $excelParticipantToAtimData[$excel_participant_key] = null;
            } else {
                if(sizeof($atimPatientData) > 1) die('ERR-94738479347');
                $atimPatientData = $atimPatientData[0];
                if(strtolower($atimPatientData['first_name']) != strtolower($xlsParticipantNamesSplit['1']) && strtolower($atimPatientData['last_name']) != strtolower($xlsParticipantNamesSplit['0'])) {
                    $messages["Participant first and last names are different (excel vs atim) but both RAMQ AND St-Luc Nbr are equal. Image number will be migrated but please validate!"][] =  "See <b>". utf8_decode(strtolower($atimPatientData['first_name']))."</b> != <b>".strtolower($xlsParticipantNamesSplit['1'])."</b> Or <b>".strtolower($atimPatientData['last_name'])."</b> != <b>".strtolower($xlsParticipantNamesSplit['0']) ."</b> on Line $line_number, etc)";
                }
                //Set data
                $tmpParticipantId = $atimPatientData['id'];
                $excelParticipantToAtimData[$excel_participant_key] = array(
                    'participant_id' => $atimPatientData['id'],
                    'participant_identifier' => $atimPatientData['participant_identifier'],
                    'images' => array(),
                    'first_chemo' => '',
                    'first_liver_surgery' => ''
                );
                //Get first participant chemo
                $sqlTx = "SELECT TreatmentMaster.participant_id,
                    TreatmentMaster.id AS treatment_master_id,
                    TreatmentMaster.start_date
                    FROM treatment_masters TreatmentMaster
                    INNER JOIN txd_chemos TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
                    WHERE TreatmentMaster.deleted <> 1
                    AND TreatmentMaster.participant_id = $tmpParticipantId
                    AND TreatmentMaster.start_date IS NOT NULL
                    ORDER BY TreatmentMaster.start_date ASC LIMIT 0,1";
                $atimChemoData = getSelectQueryResult($sqlTx);
                if($atimChemoData) {
                    $excelParticipantToAtimData[$excel_participant_key]['first_chemo'] = $atimChemoData['0']['start_date'];
                }
                //Get first surgery
                $sql = "SELECT TreatmentMaster.participant_id,
                    TreatmentMaster.id AS treatment_master_id,
                    TreatmentMaster.start_date
                    FROM treatment_masters TreatmentMaster
                    INNER JOIN qc_hb_txd_surgery_livers TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
                    WHERE TreatmentMaster.deleted <> 1
                    AND TreatmentMaster.participant_id = $tmpParticipantId
                    AND TreatmentMaster.start_date IS NOT NULL
                    ORDER BY TreatmentMaster.start_date ASC LIMIT 0,1";
                $atimSurgData = getSelectQueryResult($sqlTx);
                if($atimSurgData) {
                    $excelParticipantToAtimData[$excel_participant_key]['first_liver_surgery'] = $atimSurgData['0']['start_date'];
                }
            } 
        }
    } 
    if(!$excelParticipantToAtimData[$excel_participant_key]) {
        $xlsAccessNbrCounterWithPatientNotFound++;
    } else {
        // Participant Found
        $participant_id = $excelParticipantToAtimData[$excel_participant_key]['participant_id'];      
        $bankNbr = $excelParticipantToAtimData[$excel_participant_key]['participant_identifier'];
        $atimEventTypeExpected = '';
        //Find Event Type
        if(array_key_exists($xlsStudyDescription, $excelImageTypeToAtiMImageType)) {
            $atimEventTypeExpected = $excelImageTypeToAtiMImageType[$xlsStudyDescription];
        } else {
            $tmpEventType = array();
            foreach($imageTypeToRegexp as $tmpImageTypeToRegexp) {
                list($definedEventType, $definedRegExp) = $tmpImageTypeToRegexp;
                if(preg_match('/'.$definedRegExp.'/',$xlsStudyDescription)) {
                    $tmpEventType[$definedEventType] = $definedEventType;
                }
            }
            if(!$tmpEventType) {
                $atimEventTypeExpected = null;
                $messages["Excel 'Study Descriptions' not imported! All images numbers linked to the following study descriptions won't be imported! Please validate!"]['Study Descriptions List'][] =  $xlsStudyDescription;
            } elseif(sizeof($tmpEventType) > 2) {
                die('ERR 734839393 : '.$definedRegExp.' / ' .$xlsStudyDescription);
            } else {
                $atimEventTypeExpected = array_shift($tmpEventType);
            }
            $excelImageTypeToAtiMImageType[$xlsStudyDescription] = $atimEventTypeExpected;
        }
        //Find event and update
        if(!$atimEventTypeExpected) {
            $accessNbrWithUnsupportedStudyDescriptionCounter++;
            $messages["Excel 'Study Descriptions' not imported! All images numbers linked to the following study descriptions won't be imported! Please validate!"]['Details'][] =  "See patient bank number '$bankNbr' AND image ($xlsStudyDescription) on '$xlsEventDate' with number '$xlsAccessNbr' on line $line_number.";
        } else {
           if(empty($excelParticipantToAtimData[$excel_participant_key]['images'])) {
                $query = "SELECT event_master_id, event_date, event_date_accuracy, request_nbr, event_type, event_summary
                    FROM event_masters EventMaster
                    INNER JOIN qc_hb_ed_hepatobilary_medical_imagings EventDetail ON EventMaster.id = event_master_id
                    INNER JOIN event_controls EventControl ON EventControl.id = EventMaster.event_control_id
                    WHERE deleted <> 1
                    AND participant_id = $participant_id;";
                $atimPatientImages = getSelectQueryResult($query);
                foreach($atimPatientImages as $newAtimPatientImage) {
                    $excelParticipantToAtimData[$excel_participant_key]['images'][$newAtimPatientImage['event_date']][$newAtimPatientImage['event_type']][] = $newAtimPatientImage;
                }
            }
            if(isset($excelParticipantToAtimData[$excel_participant_key]['images'][$xlsEventDate][$atimEventTypeExpected])) {
                if(sizeof($excelParticipantToAtimData[$excel_participant_key]['images'][$xlsEventDate][$atimEventTypeExpected]) > 2) {
                    $messages["More than one ATiM image ($atimEventTypeExpected) matchs both patient and date! Same image number will be attached to all exams! Please validate!"][] =  "See patient bank number '$bankNbr' AND following images on '$xlsEventDate' on line $line_number.";
                }
                foreach($excelParticipantToAtimData[$excel_participant_key]['images'][$xlsEventDate][$atimEventTypeExpected] as &$newAtimImageToUpdate) {
                    $update = false;
                    if(!$newAtimImageToUpdate['request_nbr']) {
                        $newAtimImageToUpdate['request_nbr'] = $xlsAccessNbr;
                        $update = true;
                    } else  if(!preg_match("/$xlsAccessNbr/", $newAtimImageToUpdate['request_nbr'])) {
                        $newAtimImageToUpdate['request_nbr'] .= ' & '.$xlsAccessNbr;
                        $update = true;
                    }
                    if($update) {
                        $event_summary = str_replace('..', '.', 
                            (strlen($newAtimImageToUpdate['event_summary'])? $newAtimImageToUpdate['event_summary'].'. ' : '').
                            "
Accession number updated by IVADO'S script on '$import_date' from image '$xlsStudyDescription' of the file '$excel_file_name' (line '$line_number').");
                        $data_to_update = array(
                            'event_masters' => array(
                                'event_summary' => $event_summary),
                            $atim_controls['event_controls'][$newAtimImageToUpdate['event_type']]['detail_tablename'] => array(
                                'request_nbr' => $newAtimImageToUpdate['request_nbr']));
                        updateTableData($newAtimImageToUpdate['event_master_id'], $data_to_update);
                        addToModifiedDatabaseTablesList('event_masters', $atim_controls['event_controls'][$newAtimImageToUpdate['event_type']]['detail_tablename']);
                        $updatedDataCounter++;
                        $creations_updates_summary["Bank# $bankNbr"]['Update'][] = "Updated ATiM '".str_replace('medical imaging ', '', $atimEventTypeExpected)."' on '$xlsEventDate' with accession number '$xlsAccessNbr' from excel image '$xlsStudyDescription' line $line_number.";
                    } else {
                        $dataAlreadyUpdatedCounter++;
                    }
                }
                $xlsAccessNbrMatchingDateCounter++;
            } else {
                $xlsAccessNbrMatchingNoDateCounter++;
                $chemoMsg = ($xlsEventDate < $excelParticipantToAtimData[$excel_participant_key]['first_chemo'])? 'pre-chemo' : 'post-chemo';
                $surgMsg = ($xlsEventDate < $excelParticipantToAtimData[$excel_participant_key]['first_liver_surgery'])? 'pre-surgery' : 'post-surgery';
                $messages["No ATiM matchs the patient image date! A new '$surgMsg & $chemoMsg' image will be created! Please validate!"][] =  "Will create '".str_replace('medical imaging ', '', $atimEventTypeExpected)."' on '$xlsEventDate' with accession number '$xlsAccessNbr' for patient bank number '$bankNbr' from excel image '$xlsStudyDescription' line $line_number.";
                $creations_updates_summary["Bank# $bankNbr"]['Creation'][] = "Created ATiM '".str_replace('medical imaging ', '', $atimEventTypeExpected)."' on '$xlsEventDate' with accession number '$xlsAccessNbr' from excel image '$xlsStudyDescription' line $line_number.";
                $event_data = array(
                    'event_masters' => array(
                        'participant_id' => $participant_id,
                        'event_control_id' => $atim_controls['event_controls'][$atimEventTypeExpected]['id'],
                        'event_date' => $xlsEventDate,
                        'event_date_accuracy' => 'c',
                        'event_summary' => "Created by IVADO'S script on '$import_date' from image '$xlsStudyDescription' of the file '$excel_file_name' (line '$line_number')."),
                    $atim_controls['event_controls'][$atimEventTypeExpected]['detail_tablename'] => array(
                        'request_nbr' => $xlsAccessNbr));
                customInsertRecord($event_data);
            }
        }
    }
}
insertIntoRevsBasedOnModifiedValues();
dislayErrorAndMessage(true);
pr('----------------------------------------------------------------------------------------------');
pr(' -- SUMMARY');
pr('----------------------------------------------------------------------------------------------');
pr("$xlsAccessNbrCounter Accession Numbers were defined into the excel file.");
pr("$xlsAccessNbrCounterWithPatientNotFound Accession Numbers were defined into the excel file but participant information did not match an ATiM participant.");
pr("$accessNbrWithUnsupportedStudyDescriptionCounter Accession Numbers were defined into the excel file but the 'Study Description' does not match an image type to import.");
pr("$xlsAccessNbrMatchingNoDateCounter Accession Numbers were defined into the excel file, match participant but the date of the event does not match an date into ATiM.");
pr("$xlsAccessNbrMatchingDateCounter Accession Numbers were defined into the excel file and match both a participant and a date into ATiM. These nbrs have been compared to ".($updatedDataCounter+$dataAlreadyUpdatedCounter) ." ATiM images and used to update $updatedDataCounter ATiM images.");
pr('');
pr('----------------------------------------------------------------------------------------------');
pr(' -- MESSAGES');
pr('----------------------------------------------------------------------------------------------');

if($messages["Excel 'Study Descriptions' not imported! All images numbers linked to the following study descriptions won't be imported! Please validate!"]['Study Descriptions List']) {
    asort($messages["Excel 'Study Descriptions' not imported! All images numbers linked to the following study descriptions won't be imported! Please validate!"]['Study Descriptions List']);    
}
ksort($excelImageTypeToAtiMImageType);
foreach($excelImageTypeToAtiMImageType as $xlsStudyDesc => $atimEventType) {
    if(strlen($atimEventType)) {
        $messages["Excel 'Study Descriptions' imported! Defintion of the linked ATiM Image Type for validation!"][] = "Xls [$xlsStudyDesc] migrated as an ATiM [".str_replace('medical imaging ', '', $atimEventType)."]";
    }
}
pr($messages);
pr('----------------------------------------------------------------------------------------------');
pr(' -- CREATION/UPDATE SUMMARY');
pr('----------------------------------------------------------------------------------------------');

ksort($creations_updates_summary);
pr($creations_updates_summary);

		