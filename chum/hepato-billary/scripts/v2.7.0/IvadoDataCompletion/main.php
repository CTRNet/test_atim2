<?php

//First Line of any main.php file
require_once __DIR__.'/system.php';

$commit = false;

if(!testExcelFile(array($excel_file_name))) {
    dislayErrorAndMessage();
    exit;
}


$counter = 0;
$hospitalMiscIdentifierControlIds = "'2','4','5'";
$ramqMiscIdentifierControlIds = "'1'";
$worksheet_name = 'ivado_acc_list_project';
$messages = array();
$excelParticipantToAtimData = array();
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
    $HospitalNumber = $excel_line_data['Patient ID'];
    if(preg_match('/^S(.*)$/', $HospitalNumber, $matches)) {
        $HospitalNumber = $matches[1];
    }
    $ramq = $excel_line_data['Other Patient IDs'];
    $eventDate = $excel_line_data['Study Date']; 
    $accessNbr = $excel_line_data['Accession Number'];
    $names = $excel_line_data["Patient's Name"];
    $namesSplit = explode('^', $names);
    $namesSplit = array_filter($namesSplit);
    $excel_participant_key = "$ramq||||$HospitalNumber";
    if(!array_key_exists($excel_participant_key, $excelParticipantToAtimData)) {
        if(strlen($HospitalNumber) < 4 || strlen($ramq) < 4) {
            $messages['Participant Detection']['Participant with either RAMQ or Hospital Nbr too small! No number will be updated!'][] = "Participant with RAMQ '$ramq' AND St-Luc Nbr '$HospitalNumber'has not been found into ATiM working on both values! (See Line $line_number, etc)";
            $excelParticipantToAtimData[$excel_participant_key] = null;
        } else {
            $query = "SELECT Participant.id, participant_identifier, Participant.first_name, Participant.last_name
                FROM participants Participant 
                INNER JOIN misc_identifiers Ramq ON Ramq.deleted <> 1 AND Ramq.participant_id = Participant.id AND Ramq.misc_identifier_control_id IN ($ramqMiscIdentifierControlIds)
                INNER JOIN misc_identifiers Hosp ON Hosp.deleted <> 1 AND Hosp.participant_id = Participant.id AND Hosp.misc_identifier_control_id IN ($hospitalMiscIdentifierControlIds)
                WHERE Participant.deleted <> 1
                AND Ramq.identifier_value = '$ramq'
                AND Hosp.identifier_value = '$HospitalNumber'";
            $atimPatientData = getSelectQueryResult($query);
            if(!$atimPatientData) {
                $messages['Participant Detection']['Participant Not Found! No number will be updated!'][] = "Participant with RAMQ '$ramq' AND St-Luc Nbr '$HospitalNumber'has not been found into ATiM working on both values! (See Line $line_number, etc)";
                $excelParticipantToAtimData[$excel_participant_key] = null;
            } else {
                if(sizeof($atimPatientData) > 1) die('ERR-94738479347');
                $atimPatientData = $atimPatientData[0];
                if(strtolower($atimPatientData['first_name']) != strtolower($namesSplit['1']) && strtolower($atimPatientData['last_name']) != strtolower($namesSplit['0'])) {
                    $messages['Participant Detection']["Participant first and last names are different (excel vs atim) but both RAMQ AND St-Luc Nbr are equal. Number will be migrated but please validate!"][] =  "See <b>". utf8_decode(strtolower($atimPatientData['first_name']))."</b> != <b>".strtolower($namesSplit['1'])."</b> Or <b>".strtolower($atimPatientData['last_name'])."</b> != <b>".strtolower($namesSplit['0']) ."</b> on Line $line_number, etc)";
                }
                $excelParticipantToAtimData[$excel_participant_key] = array('participant_id' => $atimPatientData['id'], 'participant_identifier' => $atimPatientData['participant_identifier'], 'images' => array());
            } 
        }
    }   
    if($excelParticipantToAtimData[$excel_participant_key]) {
        $participant_id = $excelParticipantToAtimData[$excel_participant_key]['participant_id'];
        $bankNbr = $excelParticipantToAtimData[$excel_participant_key]['participant_identifier'];
        if(empty($excelParticipantToAtimData[$excel_participant_key]['images'])) {
            $query = "SELECT event_master_id, event_date, event_date_accuracy, request_nbr, event_type
                FROM event_masters EventMaster
                INNER JOIN qc_hb_ed_hepatobilary_medical_imagings EventDetail ON EventMaster.id = event_master_id
                INNER JOIN event_controls EventControl ON EventControl.id = EventMaster.event_control_id
                WHERE deleted <> 1
                AND participant_id = $participant_id;";
            $atimPatientImages = getSelectQueryResult($query);
            foreach($atimPatientImages as $newAtimImage) {
                $excelParticipantToAtimData[$excel_participant_key]['images'][str_replace('-', '', $newAtimImage['event_date'])][] = $newAtimImage;
            }
        }
        
        if(isset($excelParticipantToAtimData[$excel_participant_key]['images'][$eventDate])) {
            if(sizeof($excelParticipantToAtimData[$excel_participant_key]['images'][$eventDate]) > 2) {
                $allImages = array();
                foreach($excelParticipantToAtimData[$excel_participant_key]['images'][$eventDate] as $newAtimImage) {
                    $allImages[$newAtimImage['event_type']] = $newAtimImage['event_type'];
                }
                $messages['Image']["More than one images matchs both patient and date! Image number will be record for all exams! Please validate"][] =  "See patient bank number '$bankNbr' AND following images on '$eventDate' on line $line_number : ".implode(' & ', $allImages);
            }
            foreach($excelParticipantToAtimData[$excel_participant_key]['images'][$eventDate] as &$newAtimImage) {
                $update = false;
                if(!$newAtimImage['request_nbr']) {
                    $newAtimImage['request_nbr'] = $accessNbr;
                    $update = true;
                } else  if(!preg_match("/$accessNbr/", $newAtimImage['request_nbr'])) {
                    $newAtimImage['request_nbr'] .= ' & '.$accessNbr;
                    $update = true;
                }
                if($update) {
                    $data_to_update = array(
                        'event_masters' => array(), //Nothing to update
                        $atim_controls['event_controls'][$newAtimImage['event_type']]['detail_tablename'] => array(
                            'request_nbr' => $newAtimImage['request_nbr']));
                    updateTableData($newAtimImage['event_master_id'], $data_to_update);
                    addToModifiedDatabaseTablesList('event_masters', $atim_controls['event_controls'][$newAtimImage['event_type']]['detail_tablename']);
                    $counter++;
                }
            }
        } else {
            $messages['Image']["No ATiM image matchs both patient and date! Image number won't be imported! Please validate"][] =  "See patient bank number '$bankNbr' AND image on '$eventDate' with number '$accessNbr' on line $line_number.";
        }
    }   
}
insertIntoRevsBasedOnModifiedValues();
dislayErrorAndMessage(true);

pr("Done: Added $counter Image Nbr.");
pr($messages);



		