<?php

/**
 * Script to dowload participants of the CHUM Adrenal participants
 * 
 * @author N. Luc
 * @version 2018-11-20
 */

require_once 'system.php';

//==============================================================================================
// Main Code
//==============================================================================================

$commit_all = true;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $commit_all = false;
    } else {
        die('ERR ARG : '.$argv[1].' (should be test or nothing)');
    }
}

displayMigrationTitle('CHUM Adrenal Bank : Participants Creation', array($excel_file_name));

if(!testExcelFile(array($excel_file_name))) {
	dislayErrorAndMessage();
	exit;
}


if(false) {
    $sqls = array(
        "DELETE FROM collections WHERE bank_id = (SELECT id FROM banks WHERE name = 'Adrenal/Surrénal' AND deleted <> 1)",
        "DELETE FROM misc_identifiers WHERE created LIKE '2018-11-21 13:49%'",
        "DELETE FROM cd_icm_generics WHERE consent_master_id IN (SELECT id FROM consent_masters WHERE created LIKE '2018-11-21 13:49%')",
        "DELETE FROM consent_masters WHERE created LIKE '2018-11-21 13:49%'",
        "DELETE FROM participants WHERE created LIKE '2018-11-21 13:49%'");
    foreach($sqls as $newSql) {
     //   customQuery($newSql);       
    }
}

// *** PARSE CONSENT EXCEL FILES ***

$worksheet_name = 'Feuil1';

$created_participant_counter = 0;

$ramqControlData = $atim_controls['misc_identifier_controls']['ramq nbr'];
$hdControlData = $atim_controls['misc_identifier_controls']['hotel-dieu id nbr'];
$ndControlData = $atim_controls['misc_identifier_controls']['notre-dame id nbr'];
$slControlData = $atim_controls['misc_identifier_controls']['saint-luc id nbr'];
$studyControlData = $atim_controls['misc_identifier_controls']['study number'];
$adrenalBankControlData = $atim_controls['misc_identifier_controls']['adrenal bank no lab'];

$data_bank_id = getSelectQueryResult("SELECT id FROM banks WHERE name = 'Adrenal/Surrénal' AND deleted <> 1");
$data_bank_id = $data_bank_id[0]['id'];
if(!$data_bank_id) die('ERR Bank Id Unknwon');

$carptionStudyId = getSelectQueryResult("SELECT id FROM study_summaries WHERE title = 'CAPRION'");
if(!$carptionStudyId || sizeof($carptionStudyId) > 1) die('ERR CAPRION');
$carptionStudyId = $carptionStudyId[0]['id'];

recordErrorAndMessage(
    'Participant Identifier',
    '@@MESSAGE@@',
    "Created adrenal bank nbr from B-268 to B-299 to be assigned to new participant.",
    "N/A");
for($noBank = 268; $noBank < 300; $noBank++) {
    $misc_identifier_data = array(
        'identifier_value' => "B-$noBank",
        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['adrenal bank no lab']['id'],
        'flag_unique' =>  $atim_controls['misc_identifier_controls']['adrenal bank no lab']['flag_unique'],
        'tmp_deleted' => 1,
        'deleted' => 1);
    customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
}
$key_value = 299;

$identifierAlreadyChecked = array(
    'RAMQ' => array(),
    'HD' => array(),
    'SL' => array(),
    'ND' => array(),
    'ALL' => array()
);
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1,  $windows_xls_offset)) {    
    $hd_hosp_nbr = $excel_line_data['# HD'];
    $hsl_hosp_nbr = $excel_line_data['# HSL'];
    $nd_hosp_nbr = $excel_line_data['# HND'];
    $ramq = $excel_line_data['RAMQ'];
    $excel_data_references = "patient with ramq = [$ramq], SL# [$hsl_hosp_nbr], HD# [$hd_hosp_nbr] and ND# [$nd_hosp_nbr] on line $line_number";
    foreach($excel_line_data as $field => $value) {
        $excel_line_data[$field] = trim($excel_line_data[$field]);
        if($value == 'N/A') $excel_line_data[$field] = '';
    }
    $excel_field = 'Date chirurgie';
    if($excel_line_data[$excel_field] == '2009') {
        $surgery_date = '2009-01-01';
        $surgery_date_accuracy = 'm';
    } else {
        list($surgery_date, $surgery_date_accuracy) = validateAndGetDateAndAccuracy(
            $excel_line_data[$excel_field],
            'Surgery',
            "See field '$excel_field'.",
            "See $excel_data_references");
    }
    $excel_field = 'Date du consentement';
    list($consent_date, $consent_date_accuracy) = validateAndGetDateAndAccuracy(
        $excel_line_data[$excel_field],
        'Consent',
        "See field '$excel_field'.",
        "See $excel_data_references");
    $patient_names = strtolower(utf8_decode($excel_line_data['Patient']));
    $hd_hosp_nbr = $excel_line_data['# HD'];
    $hsl_hosp_nbr = $excel_line_data['# HSL'];
    $nd_hosp_nbr = $excel_line_data['# HND'];
    $ramq = $excel_line_data['RAMQ'];
    $fc_data = $excel_line_data['FC-Oui/Non'];
    $patho_nbr = $excel_line_data['# Pathologie'];
    $bank_no_labo = $excel_line_data['CODE ATIM B-'];
    $caprion_patient_nbr = $excel_line_data['ATIM STUDY NO (CAPRION)'];
    // Create date of birth from RAMQ
    $date_of_birth = '';
    if(preg_match('/^[A-Z]{4}([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})$/', $ramq, $matches)) {
        $date_of_birth = 
            ((($matches[1]*1) < 15)? '20'.str_pad($matches[1],2, '0', STR_PAD_LEFT)  : '19'.str_pad($matches[1],2, '0', STR_PAD_LEFT)).
            '-'. 
            str_pad(((($matches[2]*1) < 13)? $matches[2]  : (($matches[2]*1)-50)),2, '0', STR_PAD_LEFT).
            '-'. 
            $matches[3];
    }
    // Reformat first-last names
    list($first_name, $last_name) = array($patient_names, '');
    $patient_names = explode(' ', $patient_names);
    foreach($patient_names as &$tmpname) {
        $tmpname = trim(str_replace(',', '', $tmpname));
        $tmpname = strtoupper(substr($tmpname, 0, 1)).substr($tmpname, 1);
    }
    if(sizeof($patient_names) == 2) {
        list($last_name, $first_name) = $patient_names;
    } else {
        recordErrorAndMessage(
            'Participant', 
            '@@WARNING@@', 
            "Patient names can not be transformed to first and last names. Please review participants names into ATim after migration to clean up infromation.", 
            "See names '".implode(' ', $patient_names)."' for $excel_data_references.");
    }
    
    $identifier_conditions = array();
    $idAlreadyUsed = array();
    if($ramq) {
        $identifier_conditions[] = "RAMQ.identifier_value = '$ramq'";
        if(isset($identifierAlreadyChecked['RAMQ'][$ramq])) {
            $idAlreadyUsed[] = "RAMQ [$ramq]";
        }
        $identifierAlreadyChecked['RAMQ'][$ramq] = $ramq;
    }
    if($hd_hosp_nbr) {
        $identifier_conditions[] = "HD.identifier_value = '$hd_hosp_nbr'";
        if(isset($identifierAlreadyChecked['HD'][$hd_hosp_nbr])) {
            $idAlreadyUsed[] = "HD [$hd_hosp_nbr]";
        }
        $identifierAlreadyChecked['HD'][$hd_hosp_nbr] = $hd_hosp_nbr;
    }   
    if($hsl_hosp_nbr) {
        $identifier_conditions[] = "SL.identifier_value = '$hsl_hosp_nbr'";
        if(isset($identifierAlreadyChecked['SL'][$hsl_hosp_nbr])) {
            $idAlreadyUsed[] = "SL [$hsl_hosp_nbr]";
        }
        $identifierAlreadyChecked['SL'][$hsl_hosp_nbr] = $hsl_hosp_nbr;
    }
    if($nd_hosp_nbr) {
        $identifier_conditions[] = "ND.identifier_value = '$nd_hosp_nbr'";
        if(isset($identifierAlreadyChecked['ND'][$nd_hosp_nbr])) {
            $idAlreadyUsed[] = "ND [$nd_hosp_nbr]";
        }
        $identifierAlreadyChecked['ND'][$nd_hosp_nbr] = $nd_hosp_nbr;
    }
    if(empty($identifier_conditions)) {
        // No identifier - Patient won't be created
        die('ERR 23876287623786');
    } else {
        $participant_key = implode('/',$identifier_conditions);
        $participant_key = str_replace('.identifier_value = ', '', $participant_key);
        if(isset($identifierAlreadyChecked['All'][$participant_key]) || $idAlreadyUsed) {
            recordErrorAndMessage(
                'Participant', 
                '@@WARNING@@', 
                "Patient is defined more than once into Excel file. New row data won't be migrated into ATiM. Please validate information and complete data into ATiM manually after the migration.", 
                "See $excel_data_references" . ($idAlreadyUsed? " matching on ".implode(' ', $idAlreadyUsed) : '' ).".");
        } else {
            // New participant
            $identifierAlreadyChecked['All'][$participant_key] = $participant_key;
            // Try to find participant
            $query = "SELECT Participant.id as participant_id,
                Participant.first_name,
                Participant.last_name,
                Participant.date_of_birth,
                RAMQ.identifier_value AS ramq_nbr,
                ND.identifier_value AS nd_nbr,
                SL.identifier_value AS sl_nbr,
                HD.identifier_value AS hd_nbr
                FROM participants Participant
                LEFT JOIN misc_identifiers RAMQ
                  ON RAMQ.participant_id = Participant.id AND RAMQ.deleted <> 1 AND RAMQ.misc_identifier_control_id = 7
                LEFT JOIN misc_identifiers SL
                  ON SL.participant_id = Participant.id AND SL.deleted <> 1 AND SL.misc_identifier_control_id = 10
                LEFT JOIN misc_identifiers HD
                  ON HD.participant_id = Participant.id AND HD.deleted <> 1 AND HD.misc_identifier_control_id = 8
                LEFT JOIN misc_identifiers ND
                  ON ND.participant_id = Participant.id AND ND.deleted <> 1 AND ND.misc_identifier_control_id = 9
                WHERE Participant.deleted <> 1
                AND (".implode(' OR ', $identifier_conditions).")";
            $atimParticipant = getSelectQueryResult($query);
            $participant_id = null;
            if($atimParticipant) {
                if(sizeof($atimParticipant) > 1) die('ERR237236782682323');
                $atimParticipant = $atimParticipant[0];
                $participant_id = $atimParticipant['participant_id'];
                $compareData = 
                    array(
                        array('first_name', $first_name, 0),
                        array('last_name', $last_name, 0),
                        array('date_of_birth', $date_of_birth, 0),
                        array('ramq_nbr', $ramq, 1),
                        array('nd_nbr', $nd_hosp_nbr, 1),
                        array('sl_nbr', $hsl_hosp_nbr, 1),
                        array('hd_nbr', $hd_hosp_nbr, 1)
                    );
                $diff = array();
                $match = array();
                foreach($compareData as $newDef) {
                    list($atim_field, $excelValue, $isIdUsedForMatch) = $newDef;
                    if($excelValue) {
                        if($excelValue != trim($atimParticipant[$atim_field])) {
                            $diff[] = $atim_field . ' [(xls)' . $excelValue .' != (atim)'.$atimParticipant[$atim_field].']';
                        } else {
                            if($isIdUsedForMatch) {
                                $match[] = $atim_field . ' = ' . $excelValue;
                            }
                        }
                    }
                }
                if($diff) {
                    recordErrorAndMessage(
                        'Participant',
                        '@@WARNING@@',
                        "Patient exists into ATiM based on identifiers and will be linked to the migrated data but some difference exists on identifier. Please validate data and update data manually into ATiM after migration.",
                        "See $excel_data_references marching ATiM participant on " . implode(' ', $match) . " but with follwing difference : ".implode(' ', $diff).".");
                } else {
                    recordErrorAndMessage(
                        'Participant',
                        '@@MESSAGE@@',
                        "Patient exists into ATiM based on identifiers and will be linked to the migrated data. Please validate data into ATiM after migration.",
                        "See $excel_data_references marching ATiM participant on " . implode(' ', $match) . ".");
                }  
            } else {
                $excel_participant_data = array(
                    'first_name' => utf8_encode($first_name),
                    'last_name' => utf8_encode($last_name),
                    'date_of_birth' => $date_of_birth,
                    'date_of_birth_accuracy' => ($date_of_birth? 'c' : ''),
                    'last_modification' => $import_date);
                $participant_id = customInsertRecord(array('participants' => $excel_participant_data));
                $created_participant_counter++;
                if($ramq) {
                    $misc_identifier_data = array(
                        'identifier_value' => $ramq,
                        'participant_id' => $participant_id,
                        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['ramq nbr']['id'],
                        'flag_unique' => $atim_controls['misc_identifier_controls']['ramq nbr']['flag_unique']
                    );
                    customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
                }
                if($nd_hosp_nbr) {
                    $misc_identifier_data = array(
                        'identifier_value' => $nd_hosp_nbr,
                        'participant_id' => $participant_id,
                        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['notre-dame id nbr']['id'],
                        'flag_unique' => $atim_controls['misc_identifier_controls']['notre-dame id nbr']['flag_unique']
                    );
                    customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
                }
                if($hsl_hosp_nbr) {
                    $misc_identifier_data = array(
                        'identifier_value' => $hsl_hosp_nbr,
                        'participant_id' => $participant_id,
                        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['saint-luc id nbr']['id'],
                        'flag_unique' => $atim_controls['misc_identifier_controls']['saint-luc id nbr']['flag_unique']
                    );
                    customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
                }
                if($hd_hosp_nbr) {
                    $misc_identifier_data = array(
                        'identifier_value' => $hd_hosp_nbr,
                        'participant_id' => $participant_id,
                        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['hotel-dieu id nbr']['id'],
                        'flag_unique' => $atim_controls['misc_identifier_controls']['hotel-dieu id nbr']['flag_unique']
                    );
                    customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
                }
            }
            
            if($caprion_patient_nbr) {
                $misc_identifier_data = array(
                    'identifier_value' => $caprion_patient_nbr,
                    'participant_id' => $participant_id,
                    'study_summary_id' => $carptionStudyId,
                    'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['study number']['id'],
                    'flag_unique' => $atim_controls['misc_identifier_controls']['study number']['flag_unique']
                );
                customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
            }
            if($bank_no_labo) {
                $misc_identifier_data = array(
                    'identifier_value' => 'B-'.$bank_no_labo,
                    'participant_id' => $participant_id,
                    'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['adrenal bank no lab']['id'],
                    'flag_unique' => $atim_controls['misc_identifier_controls']['adrenal bank no lab']['flag_unique']
                );
                customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
                if($key_value < ($bank_no_labo*1)) {
                    $key_value = $bank_no_labo;
                }
            }
            // Consent
            $tmp_fc_data = strtolower(str_replace(' ', '', $fc_data));
            $consent_status = ($tmp_fc_data == 'fc-non')? 'pending' : 'obtained';
            $consent_data = array(
                'consent_masters' => array(
                    "participant_id" => $participant_id,
                    "consent_control_id" =>  $atim_controls['consent_controls']['chum - adrenal']['id'],
                    "consent_status" => $consent_status,
                    'consent_signed_date' => ($consent_date? $consent_date : $surgery_date),
                    'consent_signed_date_accuracy' => ($consent_date? $consent_date_accuracy : $surgery_date_accuracy),
                    'notes' => $fc_data),
                $atim_controls['consent_controls']['chum - adrenal']['detail_tablename'] => array());
            $consent_master_id = customInsertRecord($consent_data);
            
            if(empty($surgery_date)) {
                recordErrorAndMessage(
                    'Collection',
                    '@@MESSAGE@@',
                    "Surgery date bot defined. No collection will be created and pathology number won't be tracked..",
                    "See patho nbr [$patho_nbr] for $excel_data_references.");
            } else {
                $collectionData = array(             
                    'acquisition_label' => "Surrénal B-$bank_no_labo $surgery_date",
                    'bank_id' => $data_bank_id,
                    'participant_id' => $participant_id,
                    'consent_master_id' => $consent_master_id,
                    'collection_datetime' => $surgery_date,
                    'collection_datetime_accuracy' => 'h',
                    'collection_property' => 'participant collection',
                    'qc_nd_pathology_nbr' => $patho_nbr);
                customInsertRecord(array('collections' => $collectionData));
            }
        }
    }
}

recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Participants : '.$created_participant_counter);

$key_value++;
$last_queries_to_execute = array(
	"UPDATE participants SET participant_identifier = id WHERE participant_identifier = '' OR participant_identifier IS NULL;",
    "DELETE FROM view_collections WHERE bank_id = $data_bank_id",
	"INSERT INTO view_collections (SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Collection.collection_protocol_id AS collection_protocol_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
Bank.name AS bank_name,
MiscIdentifier.identifier_value AS identifier_value,
MiscIdentifierControl.misc_identifier_name AS identifier_name,
Collection.visit_label AS visit_label,
Collection.qc_nd_pathology_nbr,
TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs as qc_nd_pathology_nbr_from_sardo
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
LEFT JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.id = Collection.treatment_master_id AND TreatmentMaster.deleted <> 1
        WHERE Collection.deleted <> 1 AND bank_id = $data_bank_id)",
    
    "UPDATE key_increments SET key_value = $key_value WHERE key_name = 'adrenal bank no lab';"
);
foreach($last_queries_to_execute as $query)	customQuery($query);

insertIntoRevsBasedOnModifiedValues();

//*** SUMMARY DISPLAY ***

dislayErrorAndMessage($commit_all, 'Migration Errors/Warnings/Messages');

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================
	
?>
		