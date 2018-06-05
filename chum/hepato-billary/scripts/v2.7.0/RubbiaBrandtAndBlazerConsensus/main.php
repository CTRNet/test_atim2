<?php
require_once __DIR__.'/system.php';

$is_test_import_process = false;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $is_test_import_process = true;   //Load in db + commit + truncate data imported the today
    } else {
        die('ERR ARG : '.$argv[1].' (should be test)');
    }
}

//==============================================================================================
// Main Code
//==============================================================================================
ini_set('memory_limit', '2048M');

if(!testExcelFile($excel_file_names)) {
    dislayErrorAndMessage();
    exit;
}

displayMigrationTitle("CHUM Transplant - Rubbia brandt and blazer consensus migration", $excel_file_names);

$update_counter = 0;
$worksheet_name = 'Feuil1';
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_names[0], $worksheet_name, 1)) {
    
    $participant_identifier = $excel_line_data['HPB BIOBANK Patient Number'];
    $ramq = $excel_line_data['RAMQ'];
    $stLucNbr = $excel_line_data['CHUM St-Luc Hospital Number'];
    
    $date = validateAndGetDateAndAccuracy($excel_line_data['Date of liver Surgery'], 'Date definition', 'Date of liver Surgery', '');
    $date = $date[0];
    
    $query = "SELECT Participant.id,  Ramq.identifier_value as 'ramq', StLuc.identifier_value as 'stluc'
        FROM participants Participant
        LEFT JOIN misc_identifiers Ramq ON Ramq.participant_id = Participant.id AND Ramq.deleted <> 1 AND Ramq.misc_identifier_control_id = ".$atim_controls['misc_identifier_controls']['health_insurance_card']['id']."
        LEFT JOIN misc_identifiers StLuc ON StLuc.participant_id = Participant.id AND StLuc.deleted <> 1 AND StLuc.misc_identifier_control_id = ".$atim_controls['misc_identifier_controls']['saint_luc_hospital_nbr']['id']."
        WHERE Participant.deleted <> 1 AND Participant.participant_identifier = '$participant_identifier'";
    $atim_data = getSelectQueryResult($query);
    if(!$atim_data) {
        pr('TODO 23872837682736 Line : '.$line_number);
        pr($excel_line_data);
    } elseif(sizeof($atim_data) > 1) {
        pr('TODO 238728ewwww36 Line : '.$line_number);
        pr($excel_line_data);
    } else {
        $atim_data = $atim_data[0];
        $participantId = $atim_data['id'];
        if($atim_data['ramq'] != $ramq) {
            recordErrorAndMessage('Participant Definition',
                '@@WARNING@@',
                "RAMQ mismatch.",
                "See participant bank nbr '$participant_identifier' and Excel RAMQ '$ramq' and ATiM RAMQ '".$atim_data['ramq']."'. Data will be migrated. See line $line_number.");
        }
        if($atim_data['stluc'] != $stLucNbr) {
            recordErrorAndMessage('Participant Definition',
                '@@WARNING@@',
                "RAMQ mismatch.",
                "See participant bank nbr '$participant_identifier' and Excel St Luc number '$stLucNbr' and ATiM St Luc number '".$atim_data['stluc']."'. Data will be migrated. See line $line_number.");
        }
        if($date) {
            
            $query = "SELECT * 
                FROM event_masters EM 
                INNER JOIN ".$atim_controls['event_controls']['lab report - liver metastases']['detail_tablename']." ED ON ED.event_master_id = EM.id 
                WHERE EM.deleted <> 1 
                AND event_date = '$date' 
                AND EM.participant_id = $participantId
                AND EM.event_control_id = ".$atim_controls['event_controls']['lab report - liver metastases']['id'];
            $event_data = getSelectQueryResult($query);
            if(!$event_data) {
                recordErrorAndMessage('Participant Definition',
                    '@@ERROR@@',
                    "No Lab Report for the participant and the date.",
                    "See participant bank nbr '$participant_identifier' and and event_date = '$date'. No data migrated. See line $line_number.");
            } else {
                if(sizeof($event_data) != 1) {
                    recordErrorAndMessage('Participant Definition',
                        '@@ERROR@@',
                        "More than one report.",
                        "See participant bank nbr '$participant_identifier' and and event_date = '$date'. No data migrated. See line $line_number.");
                } else {
                    $event_data = $event_data[0];
                    if($event_data['rubbia_brandt_consensus'] || $event_data['blazer_consensus'] ) {
                        pr('TODO 23872837682ssss736 Line : '.$line_number);
                        pr($excel_line_data);
                    }
                    $brandt_consensus = str_replace('.', '', $excel_line_data['Rubbia-Brandt new consensus']);
                    $blazer_consensus = str_replace('.', '', $excel_line_data['Blazer new consensus']);
                    if(!preg_match('/^[1-5]{0,1}$/', $brandt_consensus)) {
                        pr('TODO 23872eeeees736 Line : '.$line_number);
                        pr($excel_line_data);
                    }
                    if(!preg_match('/^[1-3]{0,1}$/', $blazer_consensus)) {
                        pr('TODeeww36 Line : '.$line_number);
                        pr($excel_line_data);
                    }
                    if(strlen($brandt_consensus) || strlen($blazer_consensus)) {
                        $update_counter++;
                        updateTableData($event_data['id'], array(
                            'event_masters' => array(), 
                            $atim_controls['event_controls']['lab report - liver metastases']['detail_tablename'] => array(
                                'rubbia_brandt_consensus' => $brandt_consensus,
                                'blazer_consensus' => $blazer_consensus,
                            )));
                    }
                }
            }
        } else {
            recordErrorAndMessage('Date definition',
                '@@ERROR@@',
                "Date empty.",
                "See participant bank nbr '$participant_identifier'. No data mirgated. No data migrated. See line $line_number.");
        }
    }
}

recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Update Counter", "$update_counter reports have been updated.");



insertIntoRevsBasedOnModifiedValues();
dislayErrorAndMessage(!$is_test_import_process);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================
