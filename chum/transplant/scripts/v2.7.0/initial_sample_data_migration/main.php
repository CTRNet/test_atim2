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

if($is_test_import_process) truncate();

//==============================================================================================
// Main Code
//==============================================================================================
ini_set('memory_limit', '2048M');

if(!testExcelFile(array($excel_file_names))) {
    dislayErrorAndMessage();
    exit;
}

displayMigrationTitle("MUHC - Transplant Aliquots Migration", array($excel_file_names));

global $bank_id;
$atim_data = getSelectQueryResult("SELECT id FROM banks WHERE name = 'Kidney/Rein Transplant.'");
$bank_id = $atim_data[0]['id'];

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

pr('TODO: Remove if($line_number > 353) break;');
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_names, $worksheet_name, 1)) {
if($line_number > (60)) break;
    if($current_participant != $excel_line_data['patient_number']) {
        if(!is_null($current_participant)) {
            loadParticipantCollection($current_participant, $participant_aliquots);
        }
        $participant_aliquots = array();
        $current_participant = $excel_line_data['patient_number'];
        if(in_array($current_participant, $participants_done)) die('ERR2376286237862 '.$current_participant);
        $participants_done[] = $current_participant;
    }
    $participant_aliquots[$excel_line_data['visit_number']][$excel_line_data['name']][$excel_line_data['inventory_id']] = $excel_line_data;
}
loadParticipantCollection($current_participant, $participant_aliquots);

function loadParticipantCollection($current_participant, $participant_aliquots) {
    global $participant_counter;
    global $sample_counter;
    global $aliquot_counter;
    global $atim_controls;
    global $import_date;
    global $bank_id;
    global $dupAliquotBarcodesCheck;
    
    if(empty($current_participant)) die('ERR237628ssssss6237862 '.$current_participant);
    
    // Create participant
    $identifier_value = '';
    if(preg_match('/^CHUM(0[0-9]{4})$/', $current_participant, $matches)) {
        $identifier_value = $matches[1];
    } else {
        $identifier_value = str_replace('CHUM', '', $current_participant);
        $identifier_value_new = str_pad($identifier_value, 5, "0", STR_PAD_LEFT);
        recordErrorAndMessage('Participant creation', '@@ERROR@@', "Participant [$current_participant] bank number does not match expected format (5 digits) and has been replaced by [$identifier_value_new]. Please confirm.");
    }
    $query = "SELECT participant_id FROM misc_identifiers WHERE identifier_value = '$identifier_value';";
    $atim_data = getSelectQueryResult($query);
    if(sizeof($atim_data) > 0) {
        recordErrorAndMessage('Participant creation', '@@ERROR@@', "Participant [$current_participant] already exists into ATiM because probably he was already defined above into the excel file. Please review the all invetory of the participant.");
        pr('TODO 34234234');
        pr($atim_data);
        exit;
    }
    $participant_counter++;
    $participant_id = customInsertRecord(array(
        'participants' => array(
            'first_name' => 'n/a', 
            'last_name' => 'n/a', 
            'participant_identifier' => "tmp_$participant_counter", 
            'last_modification' => $import_date)));
    customInsertRecord(array(
        'misc_identifiers' => array(
            'participant_id' => $participant_id, 
            'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['kidney transplant bank no lab']['id'], 
            'flag_unique' => '1', 
            'identifier_value' => $identifier_value)));
 
    // Manage Tissue collection
    foreach ($participant_aliquots as $visitId => $new_collection_data) {
        if($visitId) {
            if(preg_match('/^[0-9]{1,2}$/', $visitId)) {
                $visitId = 'V'.str_pad($visitId, 2, "0", STR_PAD_LEFT);
            } else {
                recordErrorAndMessage('Collection creation', '@@ERROR@@', "Visit number [$visitId] is not a supported format. See participant [$current_participant] and correct migrated visit number into ATiM.");
            }
        }
        $collection_id = customInsertRecord(array(
            'collections' => array(
                'participant_id' => $participant_id,
                'bank_id' => $bank_id, 
                'visit_label' => $visitId, 
                'collection_property' => 'participant collection')));

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
                    $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => array()
                );
                $sample_master_id = customInsertRecord($sample_data);
                $barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => '',
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
                            "aliquot_label" => '',
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                            "collection_id" => $collection_id,
                            "sample_master_id" => $sample_master_id,
                            'in_stock' => 'yes - available',
                            'storage_master_id' => $storage_master_id,
                            'storage_coord_x' => $storage_coord_x,
                            'storage_coord_y' => $storage_coord_y,
                            'notes' => strlen($newTube['quantity'])? 'Quantity = '.$newTube['quantity'] : ''),
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
                if(strlen($newTube['parent_inventory_id'].$newTube['quantity'].$newTube['label'].$newTube['position_string'])) {
                    pr('TODO3883888a788');
                    pr($newTube);
                }$barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => '',
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
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => $barcode,
                            "aliquot_label" => '',
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                            "collection_id" => $collection_id,
                            "sample_master_id" => $sample_master_id,
                            'in_stock' => 'yes - available',
                            'storage_master_id' => $storage_master_id,
                            'storage_coord_x' => $storage_coord_x,
                            'storage_coord_y' => $storage_coord_y,
                            'initial_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'current_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : ''),
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
                }$barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => '',
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
                            "aliquot_label" => '',
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                            "collection_id" => $collection_id,
                            "sample_master_id" => $sample_master_id,
                            'in_stock' => 'yes - available',
                            'storage_master_id' => $storage_master_id,
                            'storage_coord_x' => $storage_coord_x,
                            'storage_coord_y' => $storage_coord_y,
                            'initial_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'current_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : ''),
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
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => $barcode,
                            "aliquot_label" => '',
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                            "collection_id" => $collection_id,
                            "sample_master_id" => $sample_master_id,
                            'in_stock' => 'yes - available',
                            'storage_master_id' => $storage_master_id,
                            'storage_coord_x' => $storage_coord_x,
                            'storage_coord_y' => $storage_coord_y,
                            'initial_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'current_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : ''),
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
                }$barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => '',
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
                if(strlen($newTube['parent_inventory_id'].$newTube['quantity'].$newTube['label'].$newTube['position_string'])) {
                    pr('TODO3883888a788');
                    pr($newTube);
                }$barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => '',
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
        
        $key = 'Contenant st├®rile 90mL urine';
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
                }$barcode = trim($newTube['inventory_id']);
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => $barcode,
                        "aliquot_label" => '',
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
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => $barcode,
                            "aliquot_label" => '',
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$sample_type.'-tube']['id'],
                            "collection_id" => $collection_id,
                            "sample_master_id" => $sample_master_id,
                            'in_stock' => 'yes - available',
                            'storage_master_id' => $storage_master_id,
                            'storage_coord_x' => $storage_coord_x,
                            'storage_coord_y' => $storage_coord_y,
                            'initial_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : '',
                            'current_volume' => strlen($newTube['quantity'])? $newTube['quantity'] : ''),
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
        
        if(!empty($new_collection_data)) {
            pr('234587234897234897238947293');
            pr($new_collection_data);
        }

        
        
    }
}



recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "$participant_counter participants.");
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
//TODO
pr("TODO remove line is_test_import_process = false;");
$is_test_import_process = false;

insertIntoRevsBasedOnModifiedValues();
dislayErrorAndMessage(!$is_test_import_process);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function truncate() {
    global $migration_user_id;
    global $import_date;

    $truncate_date_limit = substr($import_date, 0, 10);

    $truncate_queries = array(
        "SET FOREIGN_KEY_CHECKS=0;",
        
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
    
//    global $db_connection;mysqli_commit($db_connection);exit;
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
            recordErrorAndMessage('Storage creation', '@@ERROR@@', "Storage Label is null.", "No aliquot storage and position will be set but the aliquot in stock value will be est to 'available'. Please check data for aliquot [$barcode].");
        } else {
            recordErrorAndMessage('Storage creation', '@@ERROR@@', "Wrong Storage Label", "Label [$visitId] is not a supported format. No aliquot storage and position will be set but the aliquot in stock value will be est to 'available'. Please check data for aliquot [$barcode].");
        }
        return array('', '', '');
    }
    $positions = null;
    if(preg_match('/^([A-J])(([1-9])|(10))$/', $position_string, $matches)) {
        $positions = array($matches[1], $matches[2]);
    } else {
        pr('TODO 32837982eew239 ' . $position_string);
        return array('', '', '');
    }
    
    $freezer_selection_label = $storage_short_label[0];
    $rack_selection_label = $storage_short_label[0].'-'.$storage_short_label[1];
    $box_selection_label = $storage_short_label[0].'-'.$storage_short_label[1].'-'.$storage_short_label[2];
    
    $freezer_storage_master_id = null;
    if(!isset($storages[$freezer_selection_label])) {
        $storage_data = array(
            'storage_masters' => array(
                "code" => 'tmp_storage_'.($created_storage_counters),
                "short_label" => $storage_short_label[0],
                "selection_label" => $freezer_selection_label,
                "storage_control_id" => $atim_controls['storage_controls']['freezer']['id'],
                'notes' => ''),
            $atim_controls['storage_controls']['freezer']['detail_tablename'] => array());
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
                "short_label" => $storage_short_label[1],
                'parent_id' => $freezer_storage_master_id,
                "selection_label" => $rack_selection_label,
                "storage_control_id" => $atim_controls['storage_controls']['rack24']['id'],
                'notes' => ''),
            $atim_controls['storage_controls']['rack24']['detail_tablename'] => array());
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
                "short_label" => $storage_short_label[1],
                'parent_id' => $rack_storage_master_id,
                "selection_label" => $box_selection_label,
                "storage_control_id" => $atim_controls['storage_controls']['box100 1A-10J']['id'],
                'notes' => ''),
            $atim_controls['storage_controls']['box100 1A-10J']['detail_tablename'] => array());
        
        if(preg_match('/^((0{0,1}([1-9]))|(1[0-9])|(2[0-4]))$/', $storage_short_label[2], $matches)) {
            $parent_storage_coord_x = isset($matches[3])? $matches[3]: (isset($matches[4])? $matches[4]: (isset($matches[5])? $matches[5]: ''));
            $storage_data['storage_masters']['parent_storage_coord_x'] = $parent_storage_coord_x;
        }
        $box_storage_master_id = customInsertRecord($storage_data);
        $storages[$box_selection_label] = $box_storage_master_id;
        $created_storage_counters++;
    }
    $box_storage_master_id = $storages[$box_selection_label];    
    
    return array($box_storage_master_id, $positions[1], $positions[0]);
}

function addViewUpdate(&$final_queries) {
    $final_queries[] = 'INSERT INTO view_collections (
		SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
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
Collection.chum_kidney_transp_collection_time,
TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs as qc_nd_pathology_nbr_from_sardo
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
LEFT JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.id = Collection.treatment_master_id AND TreatmentMaster.deleted <> 1
			WHERE Collection.deleted <> 1
    )';

    $final_queries[] = 'INSERT INTO view_samples (
    SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,

		Collection.bank_id,
		Collection.sop_master_id,
		Collection.participant_id,

		Participant.participant_identifier,

		Collection.acquisition_label,

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

			Collection.acquisition_label,

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

MiscIdentifier.identifier_value AS identifier_value,
Collection.visit_label AS visit_label,
Collection.diagnosis_master_id AS diagnosis_master_id,
Collection.consent_master_id AS consent_master_id,
SampleMaster.qc_nd_sample_label AS qc_nd_sample_label,
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