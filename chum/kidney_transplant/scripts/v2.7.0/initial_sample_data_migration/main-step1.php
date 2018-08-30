<?php
require_once __DIR__.'/system.php';

/*
 * TODO:
In Nelson DB Dump and other xls:
  - Replace Contenant st├®rile 90mL urine by Contenant sterile 90mL urine into.
  - Replace accent for nominal inforamtion file field notes : 'greffe annulée', 'non greffé', 'non greffée', '2ème greffe', 'décédè'.
  - Créer champ created_at_date avec la formule =ENT(H2*1) ou H2 est la colonne de created_at et created_at_time avec la formule =H2-ENT(H2)');

 */
$is_test_import_process = false;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $is_test_import_process = true;   //Load in db + commit + truncate data imported the today
    } else {
        die('ERR ARG : '.$argv[1].' (should be test)');
    }
}

if($is_test_import_process) truncate();

//==============================================================================================
// Main Code
//==============================================================================================
ini_set('memory_limit', '2048M');

$excel_file_names = array($excel_file_names['main'], $excel_file_names['participants']);
if(!testExcelFile($excel_file_names)) {
    dislayErrorAndMessage();
    exit;
}

displayMigrationTitle("MUHC - Transplant Aliquots Migration - Step 1 : Collections & Aliquots Creation", $excel_file_names);

global $bank_id;
$atim_data = getSelectQueryResult("SELECT id FROM banks WHERE name = 'Kidney/Rein Transplant.'");
$bank_id = $atim_data[0]['id'];

global $identValueToNominalInformation;
$identValueToNominalInformation = array();

// Update participant nominal information
//---------------------------------------------------------------------------------------------------

$worksheet_name = 'Liste pour migration ATiM';
$ramqCheck = array();
$stLucCheck = array();
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_names[1], $worksheet_name, 1)) {
    if(isset($identValueToNominalInformation[str_pad($excel_line_data['# BD'], 5, "0", STR_PAD_LEFT)])) {
        pr('TODO 838328732373292387');
        pr($excel_line_data);
    }
    $bankNbr = str_pad($excel_line_data['# BD'], 5, "0", STR_PAD_LEFT);
    $identValueToNominalInformation[$bankNbr] = $excel_line_data;
    if(isset($ramqCheck[$excel_line_data['RAMQ']])) {
        $identValueToNominalInformation[$bankNbr]['RAMQ'] = '';
        recordErrorAndMessage('Participant creation',
            '@@WARNING@@',
            "RAMQ Nbr assigned twice - Second participant won't be linked to this nbr. If it's the same participant please merge participant after migration",
            "See participant [$bankNbr] & [".$ramqCheck[$excel_line_data['RAMQ']]."] and correct migrated data into ATiM.");
    } else {
        $ramqCheck[$excel_line_data['RAMQ']] = $bankNbr;
    }
    if(isset($dossCheck[$excel_line_data['# Dossier']])) {
        $identValueToNominalInformation[$bankNbr]['# Dossier'] = '';
        recordErrorAndMessage('Participant creation',
            '@@WARNING@@',
            "Hospital Nbr assigned twice - Second participant won't be linked to this nbr. If it's the same participant please merge participant after migration",
            "See participant [$bankNbr] & [".$dossCheck[$excel_line_data['# Dossier']]."] and correct migrated data into ATiM.");    
    } else {
        $dossCheck[$excel_line_data['# Dossier']] = $bankNbr;
    }
}

// Load invventory
//---------------------------------------------------------------------------------------------------

$worksheet_name = 'Feuil1';
$current_participant = null;
$participant_aliquots = null;
$participants_done = array();

global $participant_counter;
$participant_counter = 0;
global $sample_counter;
$sample_counter = 0;
global $aliquot_counter;
$aliquot_counter = 0;

global $dupAliquotBarcodesCheck;
$dupAliquotBarcodesCheck = array();

global $storages;
$storages = array();
global $created_storage_counters;
$created_storage_counters = 0;

while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_names[0], $worksheet_name, 1)) {
    
    if($excel_line_data['created_at_date'] != $excel_line_data['created_at_date_minus_4h']) {
        recordErrorAndMessage('Collection creation',
            '@@WARNING@@',
            "Initial collection date (Nelson DB) and collection date minus 4h are different.",
            "Dates (Nelson) ".$excel_line_data['created_at']." and date minus 4h ".$excel_line_data['created_at_minus_4h'].". See visit [".$excel_line_data['visit_number']."] of participant [".$excel_line_data['patient_number']."]. Correct migrated data into ATiM.",
            $excel_line_data['created_at_date'].$excel_line_data['created_at_date_minus_4h'].$excel_line_data['visit_number'].$excel_line_data['patient_number']);
    }
    /*
    
    compparer si un jour d'écart pour générer un warning
        VIH - > Warning partout.
        Aller chercher les RR1 si pas de dérivé'
    */
    
    $tmp_date = validateAndGetDatetimeAndAccuracy($excel_line_data['created_at_date_minus_4h'], $excel_line_data['created_at_time_minus_4h'], 'Collection creation', "Wrong collection date format", "See visit [".$excel_line_data['visit_number']."] of participant [".$excel_line_data['patient_number']."]. Correct migrated data into ATiM.");
    if(strlen($tmp_date[0])) {
       $excel_line_data['created_at'] = $tmp_date[0];
    } else {
       $excel_line_data['created_at'] = '';
    }
    if($current_participant != $excel_line_data['patient_number']) {
        if(!is_null($current_participant)) {pr($participant_aliquots);
            loadParticipantCollection($current_participant, $participant_aliquots);
        }
        $participant_aliquots = array();
        $current_participant = $excel_line_data['patient_number'];
        if(in_array($current_participant, $participants_done)) die('ERR2376286237862 '.$current_participant);
        $participants_done[] = $current_participant;
    }
    $participant_aliquots[$excel_line_data['visit_number']][$excel_line_data['name']][$excel_line_data['inventory_id']] = $excel_line_data;
    if(strlen($excel_line_data['source_worksheet'])) {
        if(preg_match('/^(.*[0-9]+)((NE)|(N1E))$/', $excel_line_data['source_worksheet'], $matches)) {
            $oldWorksheet =  $excel_line_data['source_worksheet'];
            $excel_line_data['source_worksheet'] = $matches[1].'N/E';
            recordErrorAndMessage('Collection creation',
                '@@WARNING@@',
                "Source_worksheet format modified",
                "source_worksheet [$oldWorksheet] has been modified to  [".$excel_line_data['source_worksheet']."]. See visit [".$excel_line_data['visit_number']."] of participant [$current_participant] (line $line_number). Please validate.");
        }
        if(!isset($participant_aliquots[$excel_line_data['visit_number']]['source_worksheet'])) {
            $participant_aliquots[$excel_line_data['visit_number']]['source_worksheet'] = $excel_line_data['source_worksheet'];
        } else if($participant_aliquots[$excel_line_data['visit_number']]['source_worksheet'] != $excel_line_data['source_worksheet']) {
            recordErrorAndMessage('Collection creation', 
                '@@ERROR@@',
                "Source_worksheet different between tubes of the same visit",
                "source_worksheet [".$participant_aliquots[$excel_line_data['visit_number']]['source_worksheet']."] & [".$excel_line_data['source_worksheet']."] does not match. See visit [".$excel_line_data['visit_number']."] of participant [$current_participant] (line $line_number) and correct migrated data into ATiM.");
        }
   }
   if(in_array($excel_line_data['name'], array('Rate', 'PAXGene ARN', 'Contenant sterile 90mL urine', '6mL red top tube', '6mL lavender top EDTA tube', '5mL Urine'))) {
       if(!isset($participant_aliquots[$excel_line_data['visit_number']]['created_at'])) {
           $participant_aliquots[$excel_line_data['visit_number']]['created_at'] = $excel_line_data['created_at'];
       } else if($participant_aliquots[$excel_line_data['visit_number']]['created_at'] != $excel_line_data['created_at']) {
           recordErrorAndMessage('Collection creation',
               '@@ERROR@@',
               "created_at different between tubes of the same visit",
               "created_at [".$participant_aliquots[$excel_line_data['visit_number']]['created_at']."] & [".$excel_line_data['created_at']."] does not match. See visit [".$excel_line_data['visit_number']."] of participant [$current_participant] (line $line_number) and correct migrated data into ATiM.");
       }
   }
}
loadParticipantCollection($current_participant, $participant_aliquots);

// End of process
// ----------------------------------------------------------------------------------------------------------------

$participant_with_no_collection_counter = 0;
foreach($identValueToNominalInformation as $banknbr => $data) {
    $anonymise = false;
    $consent_status = null;
    $notes = null;
    switch(strtolower(utf8_decode($data['Commentaire']))) {
        case 'greffe annulee':
        case 'non greffe':
        case 'non greffee':
            $anonymise = true;
            $notes = $data['Commentaire'];
            break;
        case 'refus de consentement':
            $consent_status = 'denied';
            break;
        default:
            if(strlen($data['Commentaire'])) {
                $notes = $data['Commentaire'];
            }
    }
    if($anonymise) {
        $participant_id = customInsertRecord(array(
            'participants' => array(
                'first_name' =>'n/a',
                'last_name' => 'n/a',
                'participant_identifier' => "tmp_xxx_$participant_with_no_collection_counter",
                'last_modification' => $import_date,
                'notes' => $notes)));   
        $participant_with_no_collection_counter++;
        recordErrorAndMessage('Participant creation',
            '@@MESSAGE@@',
            "Anonymized participant : participant with no collection data into Nelson DB.",
            "See participant [$banknbr] ".(strlen($data['Commentaire'])? ' with comment ['.$data['Commentaire'].']': '')." and correct migrated data into ATiM.");
    } else {
        $hospitalNbr = $data['# Dossier'];
        $ramq = $data['RAMQ'];
        $date_of_birth = '';
        $date_of_birth_accuracy = '';
        if(preg_match('/^[A-Za-z]{4}([0-9]{2})([0-9]{2})([0-9]{2})[0-9]{2}$/', $ramq, $matches)) {
            $date_of_birth = '19'.$matches[1].'-'.((($matches[2]*1) > 49)? ($matches[2]-50): ($matches[2])).'-'.$matches[3] ;
            $date_of_birth_accuracy = 'c';
        } else if(strlen($ramq)) {
            recordErrorAndMessage('Participant creation',
                '@@ERROR@@',
                "Wrong RAMQ format for participant created with no collection",
                "See RAMQ of Participant [$banknbr].");
        } else {
            recordErrorAndMessage('Participant creation',
                '@@ERROR@@',
                "No RAMQ for participant created with no collection",
                "See RAMQ of Participant [$banknbr].");
        }
        $participant_id = customInsertRecord(array(
            'participants' => array(
                'first_name' =>$data['Prénom'],
                'last_name' => $data['Nom'],
                'participant_identifier' => "tmp_xxx_$participant_with_no_collection_counter",
                'date_of_birth' => $date_of_birth,
                'date_of_birth_accuracy' => $date_of_birth_accuracy,
                'last_modification' => $import_date,
                'notes' => $notes)));
        $participant_with_no_collection_counter++;
        if( $hospitalNbr) {
            customInsertRecord(array(
                'misc_identifiers' => array(
                    'participant_id' => $participant_id,
                    'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['notre-dame id nbr']['id'],
                    'flag_unique' => '1',
                    'identifier_value' => 'ND'.str_replace(' ', '', $hospitalNbr))));
        }
        if($ramq) {
            customInsertRecord(array(
                'misc_identifiers' => array(
                    'participant_id' => $participant_id,
                    'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['ramq nbr']['id'],
                    'flag_unique' => '1',
                    'identifier_value' =>  str_replace(' ', '', $ramq) )));
        }
        if($consent_status) {
            $consent_data = array(
                'consent_masters' => array(
                    'participant_id' => $participant_id,
                    'consent_status' => $consent_status,
                    'consent_control_id' => $atim_controls['consent_controls']['kidney transplant']['id'],
                    'notes' => ''),
                $atim_controls['consent_controls']['kidney transplant']['detail_tablename'] => array()
            );
            customInsertRecord($consent_data);
        }
        recordErrorAndMessage('Participant creation',
            '@@MESSAGE@@',
            "Created participant with nominal information but no collection data into Nelson DB. Update participant status based on comment if required.",
            "See participant [$banknbr] ".(strlen($data['Commentaire'])? ' with comment ['.$data['Commentaire'].']': '')." and correct migrated data into ATiM.");
    }
    customInsertRecord(array(
        'misc_identifiers' => array(
            'participant_id' => $participant_id,
            'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['kidney transplant bank no lab']['id'],
            'flag_unique' => '1',
            'identifier_value' => $banknbr)));
}

recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "$participant_counter participants.");
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "$participant_with_no_collection_counter participants with no collection.");
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "$sample_counter samples.");
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "$aliquot_counter aliquots.");
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "$created_storage_counters storages.");


$final_queries = array();
$final_queries[] = "UPDATE participants SET participant_identifier = id";
$final_queries[] = "UPDATE participants_revs SET participant_identifier = id";
$final_queries[] = "UPDATE sample_masters SET sample_code = id";
$final_queries[] = "UPDATE sample_masters_revs SET sample_code = id";
$final_queries[] = "UPDATE sample_masters SET initial_specimen_sample_id = id WHERE parent_id IS NULL";
$final_queries[] = "UPDATE sample_masters_revs SET initial_specimen_sample_id = id WHERE parent_id IS NULL";
$final_queries[] = "UPDATE storage_masters SET code = id";
$final_queries[] = "UPDATE storage_masters_revs SET code = id";

if(!$is_test_import_process) {
    $final_queries[] = "UPDATE versions SET permissions_regenerated = 0;";
} else {
    addViewUpdate($final_queries);
}

foreach($final_queries as $new_query) customQuery($new_query);

insertIntoRevsBasedOnModifiedValues();
dislayErrorAndMessage(!$is_test_import_process);
//dislayErrorAndMessage(true);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function loadParticipantCollection($current_participant, $participant_aliquots) {
    global $participant_counter;
    global $sample_counter;
    global $aliquot_counter;
    global $atim_controls;
    global $import_date;
    global $bank_id;
    global $dupAliquotBarcodesCheck;
    global $identValueToNominalInformation;
    
    if(empty($current_participant)) die('ERR237628ssssss6237862 '.$current_participant);
    
    // Create participant
    $identifier_value = '';
    if(preg_match('/^CHUM0[0-9]{4}$/', $current_participant, $matches)) {
        $identifier_value = $current_participant;
    } else {
        $identifier_value = str_replace('CHUM', '', $current_participant);
        $identifier_value = str_pad($identifier_value, 5, "0", STR_PAD_LEFT);
        $identifier_value = "CHUM$identifier_value";
        recordErrorAndMessage('Participant creation', 
            '@@ERROR@@', 
            "Bank Number Format", 
            "Participant [$current_participant] bank number does not match expected format (5 digits) and has been replaced by [$identifier_value]. Please confirm.");
    }
    $query = "SELECT participant_id FROM misc_identifiers WHERE deleted <> 1 AND identifier_value = '$identifier_value';";
    $atim_data = getSelectQueryResult($query);
    if(sizeof($atim_data) > 0) {
        recordErrorAndMessage('Participant creation', 
            '@@ERROR@@', 
            "Duplicated Participant", 
            "Participant [$current_participant] already exists into ATiM because probably he was already defined above into the excel file. No new collaction will be imported. Please review the all invetory of the participant.");
        return;
    }
    $participant_counter++;
    
    $first_name = 'n/a';
    $last_name = 'n/a';
    $date_of_birth = '';
    $date_of_birth_accuracy = '';
    $ramq = '';
    $hospitalNbr = '';
    $vih = '';
    $notes = '';
    $vialt_status = '';
    
    if(isset($identValueToNominalInformation[$identifier_value])) {
       $first_name = $identValueToNominalInformation[$identifier_value]['Prénom'];
        $last_name = $identValueToNominalInformation[$identifier_value]['Nom'];
        
        $ramq = $identValueToNominalInformation[$identifier_value]['RAMQ'];
        if(preg_match('/^[A-Za-z]{4}([0-9]{2})([0-9]{2})([0-9]{2})[0-9]{2}$/', $ramq, $matches)) {
            $date_of_birth = '19'.$matches[1].'-'.(($matches[2]*1 > 49)? ($matches[2]-50): ($matches[2])).'-'.$matches[3] ;
            $date_of_birth_accuracy = 'c';
        } else if(strlen($ramq)) {
            recordErrorAndMessage('Participant creation',
                '@@ERROR@@',
                "Wrong RAMQ format",
                "See RAMQ of Participant [$current_participant].");
        } else {
            recordErrorAndMessage('Participant creation',
                '@@ERROR@@',
                "No RAMQ",
                "See RAMQ of Participant [$current_participant].");
        }
        $hospitalNbr = $identValueToNominalInformation[$identifier_value]['# Dossier'];
        $comments = $identValueToNominalInformation[$identifier_value]['Commentaire'];
        unset($identValueToNominalInformation[$identifier_value]);
    } else {
        recordErrorAndMessage('Participant creation',
            '@@ERROR@@',
            "Participant nominal infomration not known",
            "Participant [$current_participant] don't have nominal information extracted from participant xls file.");
    }
    
    $consent_status = 'obtained';
    $should_have_collection = true;
    switch(strtolower($comments)) {
        case '':
            break;
        case 'greffe annulee':
        case 'non greffe':
        case 'non greffee':
            recordErrorAndMessage('Collection creation', 
                '@@ERROR@@', 
                "Untransplanted participant with collection", 
                "See participant [$current_participant] and correct migrated visit number into ATiM.");
            $notes = $comments;
            break;
        case 'decede':
        case 'decedee':
            $vialt_status = 'deceased';
            break;
        case 'refus de consentement':
            $consent_status = 'denied';
            recordErrorAndMessage('Collection creation', 
                '@@ERROR@@', 
                "Participant denied with collection", 
                "See participant [$current_participant] and correct migrated visit number into ATiM.");
            break;
        case '2eme greffe':
            $notes = $comments;
            break;
        case 'retrait de consentement':
            $consent_status = 'withdrawn';
            recordErrorAndMessage('Collection creation', 
                '@@WARNING@@', 
                "Participant withdrawn with collection", 
                "See participant [$current_participant] and correct migrated colelction into ATiM if required (collection date > withdrawn date).");
            break;
        case 'vih':
            $vih = 'y';
            break;
        default:
            recordErrorAndMessage('Participant creation',
                '@@WARNING@@',
                "Unsupported participant comment",
                "Participant [$current_participant] and comment [$comments].");
    }
    
    $participant_id = customInsertRecord(array(
        'participants' => array(
            'first_name' => $first_name, 
            'last_name' => $last_name, 
            'participant_identifier' => "tmp_$participant_counter", 
            'date_of_birth' => $date_of_birth,
            'date_of_birth_accuracy' => $date_of_birth_accuracy,
            'chum_kidney_transp_vih' => $vih,
            'vital_status' => $vialt_status,
            'notes' => $notes,
            'last_modification' => $import_date)));
    customInsertRecord(array(
        'misc_identifiers' => array(
            'participant_id' => $participant_id, 
            'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['kidney transplant bank no lab']['id'], 
            'flag_unique' => '1', 
            'identifier_value' => $identifier_value)));
    
    if($hospitalNbr) {
        customInsertRecord(array(
            'misc_identifiers' => array(
                'participant_id' => $participant_id,
                'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['notre-dame id nbr']['id'],
                'flag_unique' => '1',
                'identifier_value' => 'ND'.str_replace(' ', '', $hospitalNbr))));
    }
    if($ramq) {
        customInsertRecord(array(
            'misc_identifiers' => array(
                'participant_id' => $participant_id,
                'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['ramq nbr']['id'],
                'flag_unique' => '1',
                'identifier_value' =>  str_replace(' ', '', $ramq) )));
    }
    $consent_data = array(
        'consent_masters' => array(
            'participant_id' => $participant_id,
            'consent_status' => $consent_status,
            'consent_control_id' => $atim_controls['consent_controls']['kidney transplant']['id'],
            'notes' => ''),
        $atim_controls['consent_controls']['kidney transplant']['detail_tablename'] => array()
    );
    $consent_master_id = customInsertRecord($consent_data);
    
    // Manage Tissue collection
    foreach ($participant_aliquots as $visitId => $new_collection_data) {
        //Visit
        if($visitId) {
            if(preg_match('/^[0-9]{1,2}$/', $visitId)) {
                $visitId = 'V'.str_pad($visitId, 2, "0", STR_PAD_LEFT);
            } else {
                recordErrorAndMessage('Collection creation', 
                    '@@ERROR@@', 
                    "Wrong visit number format", 
                    "Visit number [$visitId] does not match a supported format. See participant [$current_participant] and correct migrated visit number into ATiM.");
            }
        } else {
            recordErrorAndMessage('Collection creation', '@@ERROR@@', "No Visit Id", "See participant [$current_participant] and correct migrated visit number into ATiM.");
        }
        // Collection participant type and time
        $source_worksheet_identifier_value ='?';
        $source_worksheet_collection_part_type = '?';
        $source_worksheet_collection_time = '?';
        if(!isset($new_collection_data['source_worksheet'])) {
            recordErrorAndMessage('Collection creation', 
                '@@ERROR@@', 
                "No source_worksheet value for the collection visit. Collection Time and Collection Participant Type can not be defined probably derivative are not here.", 
                "See visit [$visitId] for the participant [$current_participant] and correct missing collection information into ATiM."); 
        } else {
            $source_worksheet = $new_collection_data['source_worksheet'];
            if(preg_match('/^([0-9]{5})([DCR]{2}[0-9])(.+)/', $source_worksheet, $matches)) {
                $source_worksheet_identifier_value = $matches[1];
                $source_worksheet_collection_part_type = $matches[2];
                $source_worksheet_collection_time = $matches[3];
                if(!preg_match('/^((DC)|(DV)|(RR))(([1-9])|([1-9][0-9]))$/', $source_worksheet_collection_part_type)) {
                    recordErrorAndMessage('Collection creation', 
                        '@@ERROR@@', 
                        "Wrong collection Participant Type (based on source_worksheet)", 
                        "Collection Participant Type [$source_worksheet_collection_part_type] created from source_worksheet [$source_worksheet] of visit [$visitId] does not match a supported format. See participant [$current_participant] and correct migrated data into ATiM.");
                }
                if(!preg_match('!^(([0-9]+)(([EN])|(N/E))([0-9]*))$!', $source_worksheet_collection_time)) {
                    recordErrorAndMessage('Collection creation', 
                        '@@ERROR@@', 
                        "Wrong collection Time (based on source_worksheet)", 
                        "Collection Time [$source_worksheet_collection_time] created from source_worksheet [$source_worksheet] of visit [$visitId] does not match a supported format. See participant [$current_participant] and correct migrated data into ATiM.");
                }
                if($identifier_value != $source_worksheet_identifier_value) {
                    recordErrorAndMessage('Collection creation', 
                        '@@ERROR@@', 
                        "Wrong participant bank number (based on source_worksheet)", 
                        "Participant bank number [$source_worksheet_identifier_value] created from source_worksheet [$source_worksheet] of visit [$visitId] is different than the number [$identifier_value] defined from 'patient_number' excel field. See participant [$current_participant] and correct migrated data into ATiM.");
                }
            } else {
                recordErrorAndMessage('Collection creation', 
                    '@@ERROR@@',
                    "Wrong source_worksheet format. Collection Time and Collection Participant Type can not be defined.",
                    "source_worksheet [$source_worksheet] does not match expected format for visit [$visitId] of the participant [$current_participant] and correct migrated data into ATiM.");
            }
        }
        unset($new_collection_data['source_worksheet']);

        //Collection datetime
        if(!array_key_exists('created_at', $new_collection_data)) {
            $collection_date_time = '';
            recordErrorAndMessage('Collection creation',
                '@@ERROR@@',
                "System Error: Collection creation field 'created_at' is not set.",
                "See visit number [$visitId] does not match a supported format. See participant [$current_participant] and correct migrated visit number into ATiM.");
            pr('ERR73738383 : probably all spicimen expected are not here');
            pr($new_collection_data);
        } else {
            $collection_date_time = $new_collection_data['created_at'];
            unset($new_collection_data['created_at']);
        }
        
        $collection_id = customInsertRecord(array(
            'collections' => array(
                'participant_id' => $participant_id,
                'consent_master_id' => $consent_master_id,
                'bank_id' => $bank_id, 
                'collection_datetime' => $collection_date_time,
                'collection_datetime_accuracy' => 'c',
                'chum_kidney_transp_collection_part_type' => $source_worksheet_collection_part_type,
                'chum_kidney_transp_collection_time' => $source_worksheet_collection_time,
                'visit_label' => $visitId,
                'collection_property' => 'participant collection')));

        $aliquot_label = $source_worksheet_identifier_value . $source_worksheet_collection_part_type . $source_worksheet_collection_time;
        
        // --------------------------------------------------------------------------------------------------------------------
        // Tissue Tube
        // --------------------------------------------------------------------------------------------------------------------
         
        // Create rates tubes
        $rateAliquots = array();
        $key = 'Rate';    
        $sample_type = 'tissue';
        if(array_key_exists($key, $new_collection_data)) {
            foreach($new_collection_data[$key] as $newTube) {
                // Rule Tissue: One tube One Tissue
                if(strlen($newTube['parent_inventory_id'].$newTube['quantity'].$newTube['label'].$newTube['position_string'])) {
                    pr('TODO38838933');
                    pr($newTube);
                }
                $sample_counter++;
                $sample_data = array(
                    'sample_masters' => array(
                        'collection_id' => $collection_id,
                        'sample_control_id' => $atim_controls['sample_controls'][$sample_type]['id'],
                        'initial_specimen_sample_type' => $sample_type,
                        'sample_code' => "tmp_$sample_counter",
                        'notes' => ''),
                    'specimen_details' => array(),
                    $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array(
                        'tissue_source' => 'spleen'
                    )
                );
                $sample_master_id = customInsertRecord($sample_data);
                $barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => $aliquot_label, 
                        "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                        "collection_id" => $collection_id,
                        "sample_master_id" => $sample_master_id,
                        'in_stock' => 'no',
                        'notes' => ''),
                    $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                $aliquot_master_id = customInsertRecord($aliquot_data);
                $aliquot_counter++;
                $rateAliquots[$barcode] = array($sample_master_id, $aliquot_master_id);

                // Check barcode not duplicated
                if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                    pr('TODO 37287278362783683276 : ' . $barcode);
                }
                $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
            }
        }
        unset($new_collection_data[$key]);
        
        // Create realiquoted rates tubes
        $key = 'Rateentube';
        $sample_type = 'tissue';
        if(array_key_exists($key, $new_collection_data)) {
            foreach($new_collection_data[$key] as $newTube) {
                $parentAliquotBarcode = $newTube['parent_inventory_id'];
                if(!array_key_exists($parentAliquotBarcode, $rateAliquots)) {
                    pr('TODO 32387 891698 7971.1 : ['.$parentAliquotBarcode.']');
                } else {
                    $barcode = trim($newTube['inventory_id']);
                    list($sample_master_id, $parent_aliquot_master_id) = $rateAliquots[$parentAliquotBarcode];
                    list($storage_master_id, $storage_coord_x, $storage_coord_y) = getStorageData($barcode, $newTube['label'], $newTube['position_string']);
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => $barcode,
                            "aliquot_label" => $aliquot_label, 
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                            "collection_id" => $collection_id,
                            "sample_master_id" => $sample_master_id,
                            'in_stock' => 'yes - available',
                            'storage_master_id' => $storage_master_id,
                            'storage_coord_x' => $storage_coord_x,
                            'storage_coord_y' => $storage_coord_y,
                            'notes' => (strlen($newTube['label'])? 'Position in XLS file : '.$newTube['label'].' p# [' . $newTube['position_string'].']. ' : '').strlen($newTube['quantity'])? 'Quantity = '.$newTube['quantity'] .'.': ''),
                        $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                    $aliquot_master_id = customInsertRecord($aliquot_data);
                    $aliquot_counter++;
                    customInsertRecord(array('realiquotings' => array('parent_aliquot_master_id' => $parent_aliquot_master_id, 'child_aliquot_master_id' => $aliquot_master_id)));
                    // Check barcode not duplicated
                    if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                        pr('TODO 37287278362783683276 : ' . $barcode);
                    }
                    $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
                }
            }
        }
        unset($new_collection_data[$key]);
        
        // --------------------------------------------------------------------------------------------------------------------
        // Red Blood Tube
        // --------------------------------------------------------------------------------------------------------------------
        
        // Create Red Blood Tube
        $specimenBloodAliquots = array();
        $key = '6mL red top tube';
        $sample_type = 'blood';
        if(array_key_exists($key, $new_collection_data)) {
            // Rule Blood: One blood per blood type
            $sample_counter++;
            $sample_data = array(
                'sample_masters' => array(
                    'collection_id' => $collection_id,
                    'sample_control_id' => $atim_controls['sample_controls'][$sample_type]['id'],
                    'initial_specimen_sample_type' => $sample_type,
                    'sample_code' => "tmp_$sample_counter",
                    'notes' => ''),
                'specimen_details' => array(),
                $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array(
                    'blood_type' => 'none (red)'));
            $sample_master_id = customInsertRecord($sample_data);
            foreach($new_collection_data[$key] as $newTube) {
                if(strlen($newTube['parent_inventory_id'].$newTube['quantity'])) {
                    pr('TODO3883888a788');
                    pr($newTube);
                }
                if(strlen($newTube['label'].$newTube['position_string'])) {
                    recordErrorAndMessage('Collection creation',
                        '@@ERROR@@',
                        "Storage position defined for a $key. No storage will be recorded.",
                        "See aliquot ".trim($newTube['inventory_id'])." of the participant [$current_participant] and correct migrated data into ATiM.");
                }
                $barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => $aliquot_label, 
                        "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                        "collection_id" => $collection_id,
                        "sample_master_id" => $sample_master_id,
                        'in_stock' => 'no',
                        'notes' => ''),
                    $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                $aliquot_master_id = customInsertRecord($aliquot_data);
                $aliquot_counter++;
                $specimenBloodAliquots[$barcode] = array($sample_master_id, $aliquot_master_id);
                // Check barcode not duplicated
                if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                    pr('TODO 37287278362783683276 : ' . $barcode);
                }
                $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
            }
        }
        unset($new_collection_data[$key]);
        
        // Create serum tubes
        $key = 'Serum';
        $sample_type = 'serum';
        if(array_key_exists($key, $new_collection_data)) {
            $tmpParentAliquotToDerivative = array();
            foreach($new_collection_data[$key] as $newTube) {
                $parentAliquotBarcode = $newTube['parent_inventory_id'];
                if(!array_key_exists($parentAliquotBarcode, $specimenBloodAliquots)) {
                    pr('TODO 32387 891698 7971.2.7 : ['.$parentAliquotBarcode.']');
                } else {
                    $barcode = trim($newTube['inventory_id']);
                    list($specimen_sample_master_id, $parent_aliquot_master_id) = $specimenBloodAliquots[$parentAliquotBarcode];
                    list($storage_master_id, $storage_coord_x, $storage_coord_y) = getStorageData($barcode, $newTube['label'], $newTube['position_string']);
                    if(!isset($tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type])) {
                        $sample_counter++;
                        $sample_data = array(
                            'sample_masters' => array(
                                'collection_id' => $collection_id,
                                'sample_control_id' => $atim_controls['sample_controls'][$sample_type]['id'],
                                'initial_specimen_sample_type' => 'blood',
                                'initial_specimen_sample_id' => $specimen_sample_master_id,
                                'parent_id' => $specimen_sample_master_id,
                                'parent_sample_type' =>'blood' ,
                                'sample_code' => "tmp_$sample_counter",
                                'notes' => ''),
                            'derivative_details' => array(),
                            $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array()
                        );
                        $sample_master_id = customInsertRecord($sample_data);
                        $tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type] = $sample_master_id;
                        customInsertRecord(array('source_aliquots' => array('sample_master_id' => $sample_master_id, 'aliquot_master_id' => $parent_aliquot_master_id)));
                    }
                    $sample_master_id = $tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type];
                    //Based on Stephanie comment
                    $newTube['quantity'] = '1';
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => $barcode,
                            "aliquot_label" => $aliquot_label, 
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                            "collection_id" => $collection_id,
                            "sample_master_id" => $sample_master_id,
                            'in_stock' => 'yes - available',
                            'storage_master_id' => $storage_master_id,
                            'storage_coord_x' => $storage_coord_x,
                            'storage_coord_y' => $storage_coord_y,
                            'initial_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'current_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'notes' => (strlen($newTube['label'])? 'Position in XLS file : '.$newTube['label'].' p# [' . $newTube['position_string'].']. ' : '')),
                        $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                    $aliquot_master_id = customInsertRecord($aliquot_data);
                    $aliquot_counter++;
                    // Check barcode not duplicated
                    if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                        pr('TODO 37287278362783683276 : ' . $barcode);
                    }
                    $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
                }
            }
        }
        unset($new_collection_data[$key]);
        
        // --------------------------------------------------------------------------------------------------------------------
        // EDTA Blood Tube
        // --------------------------------------------------------------------------------------------------------------------
                
        // Create EDTA Blood Tube
        $specimenBloodAliquots = array();
        $key = '6mL lavender top EDTA tube';
        $sample_type = 'blood';
        if(array_key_exists($key, $new_collection_data)) {
            // Rule Blood: One blood per blood type
            $sample_counter++;
            $sample_data = array(
                'sample_masters' => array(
                    'collection_id' => $collection_id,
                    'sample_control_id' => $atim_controls['sample_controls'][$sample_type]['id'],
                    'initial_specimen_sample_type' => $sample_type,
                    'sample_code' => "tmp_$sample_counter",
                    'notes' => ''),
                'specimen_details' => array(),
                $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array(
                    'blood_type' => 'edta (lavender)'));
            $sample_master_id = customInsertRecord($sample_data);
            foreach($new_collection_data[$key] as $newTube) {
                if(strlen($newTube['parent_inventory_id'].$newTube['quantity'].$newTube['label'].$newTube['position_string'])) {
                    pr('TODO3883888a788');
                    pr($newTube);
                }
                $barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => $aliquot_label, 
                        "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                        "collection_id" => $collection_id,
                        "sample_master_id" => $sample_master_id,
                        'in_stock' => 'no',
                        'notes' => ''),
                    $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                $aliquot_master_id = customInsertRecord($aliquot_data);
                $aliquot_counter++;
                $specimenBloodAliquots[$barcode] = array($sample_master_id, $aliquot_master_id);
                // Check barcode not duplicated
                if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                    pr('TODO 37287278362783683276 : ' . $barcode);
                }
                $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
            }
        }
        unset($new_collection_data[$key]);
        
        // Create plasma tubes
        $key = 'Buffy coat';
        $sample_type = 'buffy coat';
        if(array_key_exists($key, $new_collection_data)) {
            $tmpParentAliquotToDerivative = array();
            foreach($new_collection_data[$key] as $newTube) {
                $parentAliquotBarcode = $newTube['parent_inventory_id'];
                if(!array_key_exists($parentAliquotBarcode, $specimenBloodAliquots)) {
                    pr('TODO 32387 891698 7971.2.3 : ['.$parentAliquotBarcode.']');
                } else {
                    $barcode = trim($newTube['inventory_id']);
                    list($specimen_sample_master_id, $parent_aliquot_master_id) = $specimenBloodAliquots[$parentAliquotBarcode];
                    list($storage_master_id, $storage_coord_x, $storage_coord_y) = getStorageData($barcode, $newTube['label'], $newTube['position_string']);
                    if(!isset($tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type])) {
                        $sample_counter++;
                        $sample_data = array(
                            'sample_masters' => array(
                                'collection_id' => $collection_id,
                                'sample_control_id' => $atim_controls['sample_controls'][$sample_type]['id'],
                                'initial_specimen_sample_type' => 'blood',
                                'initial_specimen_sample_id' => $specimen_sample_master_id,
                                'parent_id' => $specimen_sample_master_id,
                                'parent_sample_type' =>'blood' ,
                                'sample_code' => "tmp_$sample_counter",
                                'notes' => ''),
                            'derivative_details' => array(),
                            $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array()
                        );
                        $sample_master_id = customInsertRecord($sample_data);
                        $tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type] = $sample_master_id;
                        customInsertRecord(array('source_aliquots' => array('sample_master_id' => $sample_master_id, 'aliquot_master_id' => $parent_aliquot_master_id)));
                    }
                    $sample_master_id = $tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type];     
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => $barcode,
                            "aliquot_label" => $aliquot_label, 
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                            "collection_id" => $collection_id,
                            "sample_master_id" => $sample_master_id,
                            'in_stock' => 'yes - available',
                            'storage_master_id' => $storage_master_id,
                            'storage_coord_x' => $storage_coord_x,
                            'storage_coord_y' => $storage_coord_y,
                            'initial_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'current_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'notes' => (strlen($newTube['label'])? 'Position in XLS file : '.$newTube['label'].' p# [' . $newTube['position_string'].']. ' : '')),
                        $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                    $aliquot_master_id = customInsertRecord($aliquot_data);
                    $aliquot_counter++;
                    // Check barcode not duplicated
                    if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                        pr('TODO 37287278362783683276 : ' . $barcode);
                    }
                    $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
                }
            }
        }
        unset($new_collection_data[$key]);
        
        // Create plasma tubes
        $key = 'Plasma';
        $sample_type = 'plasma';
        if(array_key_exists($key, $new_collection_data)) {
            $tmpParentAliquotToDerivative = array();
            foreach($new_collection_data[$key] as $newTube) {
                $parentAliquotBarcode = $newTube['parent_inventory_id'];
                if(!array_key_exists($parentAliquotBarcode, $specimenBloodAliquots)) {
                    pr('TODO 32387 891698 7971.2.5 : ['.$parentAliquotBarcode.']');
                } else {
                    $barcode = trim($newTube['inventory_id']);
                    list($specimen_sample_master_id, $parent_aliquot_master_id) = $specimenBloodAliquots[$parentAliquotBarcode];
                    list($storage_master_id, $storage_coord_x, $storage_coord_y) = getStorageData($barcode, $newTube['label'], $newTube['position_string']);
                    if(!isset($tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type])) {
                        $sample_counter++;
                        $sample_data = array(
                            'sample_masters' => array(
                                'collection_id' => $collection_id,
                                'sample_control_id' => $atim_controls['sample_controls'][$sample_type]['id'],
                                'initial_specimen_sample_type' => 'blood',
                                'initial_specimen_sample_id' => $specimen_sample_master_id,
                                'parent_id' => $specimen_sample_master_id,
                                'parent_sample_type' =>'blood' ,
                                'sample_code' => "tmp_$sample_counter",
                                'notes' => ''),
                            'derivative_details' => array(),
                            $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array()
                        );
                        $sample_master_id = customInsertRecord($sample_data);
                        $tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type] = $sample_master_id;
                        customInsertRecord(array('source_aliquots' => array('sample_master_id' => $sample_master_id, 'aliquot_master_id' => $parent_aliquot_master_id)));
                    }
                    $sample_master_id = $tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type];
                    //Based on Stephanie comment
                    $newTube['quantity'] = '1';
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => $barcode,
                            "aliquot_label" => $aliquot_label, 
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                            "collection_id" => $collection_id,
                            "sample_master_id" => $sample_master_id,
                            'in_stock' => 'yes - available',
                            'storage_master_id' => $storage_master_id,
                            'storage_coord_x' => $storage_coord_x,
                            'storage_coord_y' => $storage_coord_y,
                            'initial_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'current_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'notes' => (strlen($newTube['label'])? 'Position in XLS file : '.$newTube['label'].' p# [' . $newTube['position_string'].']. ' : '')),
                        $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                    $aliquot_master_id = customInsertRecord($aliquot_data);
                    $aliquot_counter++;
                    // Check barcode not duplicated
                    if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                        pr('TODO 37287278362783683276 : ' . $barcode);
                    }
                    $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
                }
            }
        }
        unset($new_collection_data[$key]);
        
        // --------------------------------------------------------------------------------------------------------------------
        // PAXGene ARN Blood Tube
        // --------------------------------------------------------------------------------------------------------------------
        
        // Create PAXGene ARN Blood Tube
        $specimenBloodAliquots = array();
        $key = 'PAXGene ARN';
        $sample_type = 'blood';
        if(array_key_exists($key, $new_collection_data)) {
            // Rule Blood: One blood per blood type
            $sample_counter++;
            $sample_data = array(
                'sample_masters' => array(
                    'collection_id' => $collection_id,
                    'sample_control_id' => $atim_controls['sample_controls'][$sample_type]['id'],
                    'initial_specimen_sample_type' => $sample_type,
                    'sample_code' => "tmp_$sample_counter",
                    'notes' => ''),
                'specimen_details' => array(),
                $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array(
                    'blood_type' => 'paxgene'));
            $sample_master_id = customInsertRecord($sample_data);
            foreach($new_collection_data[$key] as $newTube) {
                if(strlen($newTube['parent_inventory_id'].$newTube['quantity'].$newTube['label'].$newTube['position_string'])) {
                    pr('TODO3883888a788');
                    pr($newTube);
                }
                $barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => $aliquot_label, 
                        "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                        "collection_id" => $collection_id,
                        "sample_master_id" => $sample_master_id,
                        'in_stock' => 'no',
                        'notes' => ''),
                    $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                $aliquot_master_id = customInsertRecord($aliquot_data);
                $aliquot_counter++;
                $specimenBloodAliquots[$barcode] = array($sample_master_id, $aliquot_master_id);
                // Check barcode not duplicated
                if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                    pr('TODO 37287278362783683276 : ' . $barcode);
                }
                $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
            }
        }
        unset($new_collection_data[$key]);
        
        // --------------------------------------------------------------------------------------------------------------------
        // Urine Tube
        // --------------------------------------------------------------------------------------------------------------------
        
        // Create Urine Tube
        $specimenUrinAliquots = array();
        
        $key = '15mL Urine';
        $sample_type = 'urine';
        if(array_key_exists($key, $new_collection_data)) {
            // Rule Urine: One urine per visit
            $sample_counter++;
            $sample_data = array(
                'sample_masters' => array(
                    'collection_id' => $collection_id,
                    'sample_control_id' => $atim_controls['sample_controls'][$sample_type]['id'],
                    'initial_specimen_sample_type' => $sample_type,
                    'sample_code' => "tmp_$sample_counter",
                    'notes' => ''),
                'specimen_details' => array(),
                $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array(
                    'collected_volume' => '15',
                    'collected_volume_unit' => 'ml'));
            $sample_master_id = customInsertRecord($sample_data);
            foreach($new_collection_data[$key] as $newTube) {
                if(strlen($newTube['label'].$newTube['position_string'])) {
                    recordErrorAndMessage('Storage creation', 
                        '@@ERROR@@', 
                        "Storage Label and/or position defined for a $key. No storage position will be defined for the created aliquot.", 
                        "Please check data for aliquot [$barcode].");
                } else if(strlen($newTube['parent_inventory_id'].$newTube['quantity'])) {
                    pr('TODO3883888a788');
                    pr($newTube);
                }
                $barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => $aliquot_label, 
                        "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                        "collection_id" => $collection_id,
                        "sample_master_id" => $sample_master_id,
                        'in_stock' => 'no',
                        'notes' => ''),
                    $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                $aliquot_master_id = customInsertRecord($aliquot_data);
                $aliquot_counter++;
                $specimenUrinAliquots[$barcode] = array($sample_master_id, $aliquot_master_id);
                // Check barcode not duplicated
                if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                    pr('TODO 37287278362783683276 : ' . $barcode);
                }
                $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
            }
        }
        unset($new_collection_data[$key]);
        
        $key = 'Contenant sterile 90mL urine';
        $sample_type = 'urine';
        if(array_key_exists($key, $new_collection_data)) {
            // Rule Urine: One urine per visit
            $sample_counter++;
            $sample_data = array(
                'sample_masters' => array(
                    'collection_id' => $collection_id,
                    'sample_control_id' => $atim_controls['sample_controls'][$sample_type]['id'],
                    'initial_specimen_sample_type' => $sample_type,
                    'sample_code' => "tmp_$sample_counter",
                    'notes' => ''),
                'specimen_details' => array(),
                $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array(
                    'collected_volume' => '90',
                    'collected_volume_unit' => 'ml'));
            $sample_master_id = customInsertRecord($sample_data);
            foreach($new_collection_data[$key] as $newTube) {
                if(strlen($newTube['parent_inventory_id'].$newTube['quantity'].$newTube['label'].$newTube['position_string'])) {
                    pr('TODO3883888a788');
                    pr($newTube);
                }
                $barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => $aliquot_label, 
                        "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                        "collection_id" => $collection_id,
                        "sample_master_id" => $sample_master_id,
                        'in_stock' => 'no',
                        'notes' => ''),
                    $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                $aliquot_master_id = customInsertRecord($aliquot_data);
                $aliquot_counter++;
                $specimenUrinAliquots[$barcode] = array($sample_master_id, $aliquot_master_id);
                // Check barcode not duplicated
                if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                    pr('TODO 37287278362783683276 : ' . $barcode);
                }
                $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
            }
        }
        unset($new_collection_data[$key]);
        
        // Create centrif. urine tubes
        $key = 'Urine';
        $sample_type = 'centrifuged urine';
        if(array_key_exists($key, $new_collection_data)) {
            $tmpParentAliquotToDerivative = array();
            foreach($new_collection_data[$key] as $newTube) {
                $parentAliquotBarcode = $newTube['parent_inventory_id'];
                if(!array_key_exists($parentAliquotBarcode, $specimenUrinAliquots)) {
                    pr('TODO 32387 891698 7971.2.6 : ['.$parentAliquotBarcode.']');
                } else {
                    $barcode = trim($newTube['inventory_id']);
                    list($specimen_sample_master_id, $parent_aliquot_master_id) = $specimenUrinAliquots[$parentAliquotBarcode];
                    list($storage_master_id, $storage_coord_x, $storage_coord_y) = getStorageData($barcode, $newTube['label'], $newTube['position_string']);
                    if(!isset($tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type])) {
                        $sample_counter++;
                        $sample_data = array(
                            'sample_masters' => array(
                                'collection_id' => $collection_id,
                                'sample_control_id' => $atim_controls['sample_controls'][$sample_type]['id'],
                                'initial_specimen_sample_type' => 'urine',
                                'initial_specimen_sample_id' => $specimen_sample_master_id,
                                'parent_id' => $specimen_sample_master_id,
                                'parent_sample_type' =>'urine' ,
                                'sample_code' => "tmp_$sample_counter",
                                'notes' => ''),
                            'derivative_details' => array(),
                            $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array()
                        );
                        $sample_master_id = customInsertRecord($sample_data);
                        $tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type] = $sample_master_id;
                        customInsertRecord(array('source_aliquots' => array('sample_master_id' => $sample_master_id, 'aliquot_master_id' => $parent_aliquot_master_id)));
                    }
                    $sample_master_id = $tmpParentAliquotToDerivative[$parentAliquotBarcode][$sample_type];
                    //Based on Stephanie comment
                    $newTube['quantity'] = '1.5';
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => $barcode,
                            "aliquot_label" => $aliquot_label, 
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                            "collection_id" => $collection_id,
                            "sample_master_id" => $sample_master_id,
                            'in_stock' => 'yes - available',
                            'storage_master_id' => $storage_master_id,
                            'storage_coord_x' => $storage_coord_x,
                            'storage_coord_y' => $storage_coord_y,
                            'initial_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'current_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'notes' => (strlen($newTube['label'])? 'Position in XLS file : '.$newTube['label'].' p# [' . $newTube['position_string'].']. ' : '')),
                        $atim_controls['aliquot_controls'][$sample_type.'-tube']['detail_tablename'] => array());
                    $aliquot_master_id = customInsertRecord($aliquot_data);
                    $aliquot_counter++;
                    // Check barcode not duplicated
                    if(in_array($barcode, $dupAliquotBarcodesCheck)) {
                        pr('TODO 37287278362783683276 : ' . $barcode);
                    }
                    $dupAliquotBarcodesCheck[$barcode] = $newTube['inventory_id'];
                }
            }
        }
        unset($new_collection_data[$key]);
        
        // Check nothing else has to be created
        if(!empty($new_collection_data)) {
            pr('234587234897234897238947293');
            pr($new_collection_data);
        }        
    }
}

function truncate() {
    global $migration_user_id;
    global $import_date;

    $truncate_date_limit = substr($import_date, 0, 10);

    $truncate_queries = array(
        "SET FOREIGN_KEY_CHECKS=0;",
        "TRUNCATE aliquot_internal_uses ;",
        "TRUNCATE aliquot_internal_uses_revs;",
        "TRUNCATE realiquotings ;",
        "TRUNCATE realiquotings_revs;",
        "TRUNCATE source_aliquots ;",
        "TRUNCATE source_aliquots_revs;",
         
        "TRUNCATE ad_tubes;",
        "TRUNCATE ad_tubes_revs;",
        "TRUNCATE aliquot_masters ;",
        "TRUNCATE aliquot_masters_revs ;",
                
        "TRUNCATE sd_der_buffy_coats;",
        "TRUNCATE sd_der_buffy_coats_revs;",
        "TRUNCATE sd_der_plasmas;",
        "TRUNCATE sd_der_plasmas_revs;",
        "TRUNCATE sd_der_serums;",
        "TRUNCATE sd_der_serums_revs;",
        "TRUNCATE sd_spe_bloods;",
        "TRUNCATE sd_spe_bloods_revs;",
        "TRUNCATE sd_spe_tissues;",
        "TRUNCATE sd_spe_tissues_revs;",
        "TRUNCATE derivative_details;",
        "TRUNCATE derivative_details_revs;",
        "TRUNCATE specimen_details;",
        "TRUNCATE specimen_details_revs;",
        "TRUNCATE sample_masters;",
        "TRUNCATE sample_masters_revs;",

        "TRUNCATE view_aliquot_uses;",
        "TRUNCATE  view_aliquots;",
        "TRUNCATE  view_samples;",
        "TRUNCATE  view_collections;",
         
        "TRUNCATE collections;",
        "TRUNCATE collections_revs;",
               
        "TRUNCATE misc_identifiers;",
        "TRUNCATE misc_identifiers_revs;",
        
        "TRUNCATE chum_kidney_transp_cd_generics;",
        "TRUNCATE chum_kidney_transp_cd_generics_revs;",
        
        "TRUNCATE consent_masters;",
        "TRUNCATE consent_masters_revs;",
               
        "TRUNCATE participants;",
        "TRUNCATE participants_revs;", 
        
        "TRUNCATE std_freezers;",
        "TRUNCATE std_freezers_revs;",
        "TRUNCATE std_boxs;",
        "TRUNCATE std_boxs_revs;", 
        "TRUNCATE std_racks;",
        "TRUNCATE std_racks_revs;", 
        "TRUNCATE storage_masters;",
        "TRUNCATE storage_masters_revs;",
                
        "SET FOREIGN_KEY_CHECKS=1;"       
    );

    foreach($truncate_queries as $query) {
        pr($query);
        customQuery($query, __FILE__, __LINE__);
    }
    
//    global $db_connection;mysqli_commit($db_connection);pr('truncate');exit;
}

function getStorageData($barcode, $box_selection_label, $position_string) {
    global $atim_controls;
    global $storages;
    global $created_storage_counters;

    $storage_short_label = null;
    if(preg_match('/^([A-Z])([0-9]{2})((0[1-9])|(1[0-9])|(2[0-4]))$/', $box_selection_label, $matches)) {
        $storage_short_label = array($matches[1], $matches[2], $matches[3]);
    } else {
        if(empty($box_selection_label)) {
            recordErrorAndMessage('Storage creation', '@@ERROR@@', "Storage Label is null.", "No aliquot storage and position will be set but the aliquot in stock value will be set to 'available'. Please check data for aliquot [$barcode].");
        } else {
            recordErrorAndMessage('Storage creation', '@@ERROR@@', "Wrong Storage Label", "Label [$box_selection_label] does not match a supported format. No aliquot storage and position will be set but the aliquot in stock value will be set to 'available'. Please check data for aliquot [$barcode].");
        }
        return array('', '', '');
    }
    $positions = null;
    if(preg_match('/^([A-J])(([1-9])|(10))$/', $position_string, $matches)) {
        //$positions = array($matches[1], $matches[2]);
        $positions = (strpos("ABCDEFGHIJ", $matches[1])*10) + $matches[2];
        $positions = array($positions, '');
    } else {
        pr('TODO 32837982eew239 ' . $position_string);
        return array('', '', '');
    }
    
    $freezer_short_label = $storage_short_label[0];
    $rack_short_label = $storage_short_label[1];
    $initial_rack_short_label = $storage_short_label[1];
    $box_short_label = $storage_short_label[2];
    $initial_box_short_label = $storage_short_label[2];
    
    $box_short_label = ($rack_short_label - 1)*24 + $box_short_label;
    
    $freezer_selection_label = $freezer_short_label;
    $rack_selection_label = $freezer_short_label.'-'.$rack_short_label;
    $box_selection_label = $freezer_short_label.'-'.$rack_short_label.'-'.$box_short_label;
    
    $freezer_storage_master_id = null;
    if(!isset($storages[$freezer_selection_label])) {
        $storage_data = array(
            'storage_masters' => array(
                "code" => 'tmp_storage_'.($created_storage_counters),
                "short_label" => $freezer_short_label,
                "selection_label" => $freezer_selection_label,
                "storage_control_id" => $atim_controls['storage_controls']['freezer24 6x4']['id'],
                'notes' => ''),
            $atim_controls['storage_controls']['freezer24 6x4']['detail_tablename'] => array());
        $freezer_storage_master_id = customInsertRecord($storage_data);
        $storages[$freezer_selection_label] = $freezer_storage_master_id;
        $created_storage_counters++;
    }
    $freezer_storage_master_id = $storages[$freezer_selection_label];
    
    $rack_storage_master_id = null;
    if(!isset($storages[$rack_selection_label])) {
        $storage_data = array(
            'storage_masters' => array(
                "code" => 'tmp_storage_'.($created_storage_counters),
                "short_label" => $rack_short_label,
                'parent_id' => $freezer_storage_master_id,
                "selection_label" => $rack_selection_label,
                "storage_control_id" => $atim_controls['storage_controls']['rack24 4x6']['id'],
                'notes' => ''),
            $atim_controls['storage_controls']['rack24 4x6']['detail_tablename'] => array());
        if(preg_match('/^((0{0,1}([1-9]))|(1[0-9])|(2[0-4]))$/', $initial_rack_short_label, $matches)) {
            $parent_storage_coord_x = isset($matches[3])? $matches[3]: (isset($matches[4])? $matches[4]: (isset($matches[5])? $matches[5]: ''));
            $storage_data['storage_masters']['parent_storage_coord_x'] = $parent_storage_coord_x;
        }
        $rack_storage_master_id = customInsertRecord($storage_data);
        $storages[$rack_selection_label] = $rack_storage_master_id;
        $created_storage_counters++;
    }
    $rack_storage_master_id = $storages[$rack_selection_label];
    
    $box_storage_master_id = null;
    if(!isset($storages[$box_selection_label])) {
        $storage_data = array(
            'storage_masters' => array(
                "code" => 'tmp_storage_'.($created_storage_counters),
                "short_label" => $box_short_label,
                'parent_id' => $rack_storage_master_id,
                "selection_label" => $box_selection_label,
                "storage_control_id" => $atim_controls['storage_controls']['box100']['id'],
                'notes' => 'Box label from Xls file : '.$storage_short_label[0].$storage_short_label[1].$storage_short_label[2].'.'),
            $atim_controls['storage_controls']['box100']['detail_tablename'] => array());
        if(preg_match('/^((0{0,1}([1-9]))|(1[0-9])|(2[0-4]))$/', $initial_box_short_label, $matches)) {
            $parent_storage_coord_x = isset($matches[3])? $matches[3]: (isset($matches[4])? $matches[4]: (isset($matches[5])? $matches[5]: ''));
            $storage_data['storage_masters']['parent_storage_coord_x'] = $parent_storage_coord_x;
        }
        $box_storage_master_id = customInsertRecord($storage_data);
        $storages[$box_selection_label] = $box_storage_master_id;
        $created_storage_counters++;
    }
    $box_storage_master_id = $storages[$box_selection_label];    
    
    return array($box_storage_master_id, $positions[0], $positions[1]);
}

function addViewUpdate(&$final_queries) {
    $final_queries[] = "INSERT INTO view_collections (
		SELECT
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
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
CONCAT(IFNULL(MiscIdentifier.identifier_value, '?'), ' ', Collection.chum_kidney_transp_collection_part_type, ' ', Collection.chum_kidney_transp_collection_time) acquisition_label,
Bank.name AS bank_name,
MiscIdentifier.identifier_value AS identifier_value,
MiscIdentifierControl.misc_identifier_name AS identifier_name,
Collection.visit_label AS visit_label,
Collection.qc_nd_pathology_nbr,
Collection.chum_kidney_transp_collection_part_type,
Collection.chum_kidney_transp_collection_time
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
    WHERE Collection.deleted <> 1
    )";

    $final_queries[] = 'INSERT INTO view_samples (
        
        SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
    
		Collection.bank_id,
		Collection.sop_master_id,
		Collection.participant_id,
		Collection.collection_protocol_id AS collection_protocol_id,
    
		Participant.participant_identifier,
    
    
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,
		SampleMaster.sample_code,
		SampleControl.sample_category,
    
		IF(SpecimenDetail.reception_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR SpecimenDetail.reception_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > SpecimenDetail.reception_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, SpecimenDetail.reception_datetime))))) AS coll_to_rec_spent_time_msg,
		
		IF(DerivativeDetail.creation_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR DerivativeDetail.creation_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > DerivativeDetail.creation_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, DerivativeDetail.creation_datetime))))) AS coll_to_creation_spent_time_msg,
		 
MiscIdentifier.identifier_value AS identifier_value,
Collection.visit_label AS visit_label,
Collection.diagnosis_master_id AS diagnosis_master_id,
Collection.consent_master_id AS consent_master_id,
Collection.chum_kidney_transp_collection_part_type,
Collection.chum_kidney_transp_collection_time,
SampleMaster.qc_nd_sample_label AS qc_nd_sample_label
    
		FROM sample_masters AS SampleMaster
		INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
		LEFT JOIN specimen_details AS SpecimenDetail ON SpecimenDetail.sample_master_id=SampleMaster.id
		LEFT JOIN derivative_details AS DerivativeDetail ON DerivativeDetail.sample_master_id=SampleMaster.id
		LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
		LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id = ParentSampleControl.id
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
        WHERE SampleMaster.deleted != 1
    )';

    $final_queries[] = 'INSERT INTO view_aliquots (
  SELECT 
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id, 
			Collection.bank_id, 
			AliquotMaster.storage_master_id AS storage_master_id,
			Collection.participant_id, 
			
			Participant.participant_identifier, 
			
            Collection.collection_protocol_id AS collection_protocol_id,
			
			SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
			SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
			ParentSampleControl.sample_type AS parent_sample_type,
			ParentSampleMaster.sample_control_id AS parent_sample_control_id,
			SampleControl.sample_type,
			SampleMaster.sample_control_id,
			
			AliquotMaster.barcode,
			AliquotMaster.aliquot_label,
			AliquotControl.aliquot_type,
			AliquotMaster.aliquot_control_id,
			AliquotMaster.in_stock,
			AliquotMaster.in_stock_detail,
			StudySummary.title AS study_summary_title,
			StudySummary.id AS study_summary_id,
			
			StorageMaster.code,
			StorageMaster.selection_label,
			AliquotMaster.storage_coord_x,
			AliquotMaster.storage_coord_y,
			
			StorageMaster.temperature,
			StorageMaster.temp_unit,
			
			AliquotMaster.created,
			
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(Collection.collection_datetime IS NULL, -1,
			 IF(Collection.collection_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(Collection.collection_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, AliquotMaster.storage_datetime))))) AS coll_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(SpecimenDetail.reception_datetime IS NULL, -1,
			 IF(SpecimenDetail.reception_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(SpecimenDetail.reception_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, SpecimenDetail.reception_datetime, AliquotMaster.storage_datetime))))) AS rec_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(DerivativeDetail.creation_datetime IS NULL, -1,
			 IF(DerivativeDetail.creation_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(DerivativeDetail.creation_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, DerivativeDetail.creation_datetime, AliquotMaster.storage_datetime))))) AS creat_to_stor_spent_time_msg,
			 
			IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes,
        
CONCAT(IFNULL(MiscIdentifier.identifier_value, "?"), " ", Collection.chum_kidney_transp_collection_part_type, " ", Collection.chum_kidney_transp_collection_time) acquisition_label,
MiscIdentifier.identifier_value AS identifier_value,
Collection.chum_kidney_transp_collection_part_type,
Collection.chum_kidney_transp_collection_time
			
			FROM aliquot_masters AS AliquotMaster
			INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
			INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
			INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
			LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
			LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id=ParentSampleControl.id
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
			LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id AND StorageMaster.deleted != 1
			LEFT JOIN specimen_details AS SpecimenDetail ON AliquotMaster.sample_master_id=SpecimenDetail.sample_master_id
			LEFT JOIN derivative_details AS DerivativeDetail ON AliquotMaster.sample_master_id=DerivativeDetail.sample_master_id
			LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
        WHERE AliquotMaster.deleted != 1 
    )';

    $final_queries[] = "INSERT INTO view_aliquot_uses (
        SELECT CONCAT(SourceAliquot.id,1) AS `id`,
    AliquotMaster.id AS aliquot_master_id,
    CONCAT('sample derivative creation#', SampleMaster.sample_control_id) AS use_definition,
    SampleMaster.sample_code AS use_code,
    '' AS `use_details`,
    SourceAliquot.used_volume AS used_volume,
    AliquotControl.volume_unit AS aliquot_volume_unit,
    DerivativeDetail.creation_datetime AS use_datetime,
    DerivativeDetail.creation_datetime_accuracy AS use_datetime_accuracy,
    NULL AS `duration`,
    '' AS `duration_unit`,
    DerivativeDetail.creation_by AS used_by,
    SourceAliquot.created AS created,
    CONCAT('/InventoryManagement/SampleMasters/detail/',SampleMaster.collection_id,'/',SampleMaster.id) AS detail_url,
    SampleMaster2.id AS sample_master_id,
    SampleMaster2.collection_id AS collection_id,
    NULL AS study_summary_id,
    '' AS study_title
    FROM source_aliquots AS SourceAliquot
    JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
    JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
    JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
    JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
    JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
    WHERE SourceAliquot.deleted <> 1
    )";

    $final_queries[] = "INSERT INTO view_aliquot_uses (
      SELECT CONCAT(Realiquoting.id ,2) AS id,
    AliquotMaster.id AS aliquot_master_id,
    'realiquoted to' AS use_definition,
    AliquotMasterChild.barcode AS use_code,
    '' AS use_details,
    Realiquoting.parent_used_volume AS used_volume,
    AliquotControl.volume_unit AS aliquot_volume_unit,
    Realiquoting.realiquoting_datetime AS use_datetime,
    Realiquoting.realiquoting_datetime_accuracy AS use_datetime_accuracy,
    NULL AS duration,
    '' AS duration_unit,
    Realiquoting.realiquoted_by AS used_by,
    Realiquoting.created AS created,
    CONCAT('/InventoryManagement/AliquotMasters/detail/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
    SampleMaster.id AS sample_master_id,
    SampleMaster.collection_id AS collection_id,
    NULL AS study_summary_id,
    '' AS study_title
    FROM realiquotings AS Realiquoting
    JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
    JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
    JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
    JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
    WHERE Realiquoting.deleted <> 1

    )";

    $final_queries[] = "INSERT INTO view_aliquot_uses (

    SELECT CONCAT(AliquotInternalUse.id,6) AS id,
    AliquotMaster.id AS aliquot_master_id,
    AliquotInternalUse.type AS use_definition,
    AliquotInternalUse.use_code AS use_code,
    AliquotInternalUse.use_details AS use_details,
    AliquotInternalUse.used_volume AS used_volume,
    AliquotControl.volume_unit AS aliquot_volume_unit,
    AliquotInternalUse.use_datetime AS use_datetime,
    AliquotInternalUse.use_datetime_accuracy AS use_datetime_accuracy,
    AliquotInternalUse.duration AS duration,
    AliquotInternalUse.duration_unit AS duration_unit,
    AliquotInternalUse.used_by AS used_by,
    AliquotInternalUse.created AS created,
    CONCAT('/InventoryManagement/AliquotMasters/detailAliquotInternalUse/',AliquotMaster.id,'/',AliquotInternalUse.id) AS detail_url,
    SampleMaster.id AS sample_master_id,
    SampleMaster.collection_id AS collection_id,
    StudySummary.id AS study_summary_id,
    StudySummary.title AS study_title
    FROM aliquot_internal_uses AS AliquotInternalUse
    JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
    JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
    JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
    LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotInternalUse.study_summary_id AND StudySummary.deleted != 1
    WHERE AliquotInternalUse.deleted <> 1

    )";
}