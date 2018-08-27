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
Pour ce qui des lames qui n'ont pas de blocs associés, oui nous voulons tout de même les migrer dans ATiM.
//==============================================================================================
// Main Code
//==============================================================================================
ini_set('memory_limit', '2048M');

if(!testExcelFile(array_merge($excel_file_names['blocks'], $excel_file_names['slides']))) {
    dislayErrorAndMessage();
    exit;
}

displayMigrationTitle("MUHC - Transplant Aliquots Migration - Step 2 : Block & Slide Creation", array_merge($excel_file_names['blocks'], $excel_file_names['slides']));

global $bank_id;
$atim_data = getSelectQueryResult("SELECT id FROM banks WHERE name = 'Kidney/Rein Transplant.'");
$bank_id = $atim_data[0]['id'];

$participant_found = array();
$participant_not_found =  array();
$created_identifier_counter = 0;
$created_collection_counter = 0;
$created_block_counter = 0;
$sample_counter = 0;

$storages = array();

// Blocks
//---------------------------------------------------------------------------------------------------

$worksheet_name = 'Blocks';
$participant_detection =  array();
$dateValidationDone = array('0', '0');
$createdBlockCounterPerFile = array();

$createdBlocks = array();
$createdBlocksSlidesFromSampleMasterId = array();
foreach($excel_file_names['blocks'] as $new_file) {
    $createdBlockCounterPerFile[$new_file] = array('lines' => 0, 'aliquot studied' => 0, 'aliquot created' => 0);
    while(list($line_number, $excel_line_data) = getNextExcelLineData($new_file, $worksheet_name, 1)) {
        $createdBlockCounterPerFile[$new_file]['lines']++;
        
        $excel_first_name = $excel_line_data['Prenom'];
        $excel_last_name = $excel_line_data['Nom'];
        $excel_dossier = $excel_line_data['No de dossier'];
        $excel_ramq = $excel_line_data['RAMQ'];
        
        $excel_collectiondate = $excel_line_data['Date du prelevement'];
        $excel_collection_site = $excel_line_data['Lieu du Prelevement ND, SL, HD'];
        $excel_patho = $excel_line_data['No Patho'];
        $collection_notes = isset($excel_line_data['Note de collection'])? $excel_line_data['Note de collection'] : (isset($excel_line_data['Notes de collection'])? $excel_line_data['Notes de collection'] : '');
        if(!isset($excel_line_data['Note de collection']) && !isset($excel_line_data['Notes de collection'])) {
            pr('TODO 8we4343447 23782');pr($excel_line_data);
        }
        
        $excel_block_nbr = $excel_line_data['Enumeration des blocs'];
        $excel_tissue_notes = isset($excel_line_data['Traitement description'])? $excel_line_data['Traitement description'] : 'Biopsie du greffon rénal.';
        
        if(!strlen($excel_patho)) {
            recordErrorAndMessage('Block creation',
                '@@WARNING@@',
                "Patho number unknown (reason could be that the all line is empty). No blocks will be imported. Please validate.",
                "RAMQ number [$excel_ramq], name = '$excel_first_name $excel_last_name', hospital number = '$excel_dossier'. See excel line $line_number in file [$new_file].");
        } else {

            $createdBlockCounterPerFile[$new_file]['aliquot studied']++;
            
            if($excel_line_data['Traitement description'] != 'Biopsie du greffon rénal' ||  $excel_line_data['Traitement'] != 'BIOP') {
                pr('TODO 24353456346 file '.$new_file.' line '.$line_number); pr($excel_line_data);
            }
            if(!in_array($excel_collection_site, array('ND','SL','HD'))) {
                pr('TODO 24574756786746 file '.$new_file.' line '.$line_number. "[$excel_collection_site]"); pr($excel_line_data);
            }
            if($collection_notes == 'ABSENT') {
                recordErrorAndMessage('Block creation',
                    '@@MESSAGE@@',
                    "Block 'Absent'. No blocks will be imported. Please validate.",
                    "RAMQ number [$excel_ramq], name = '$excel_first_name $excel_last_name', hospital number = '$excel_dossier'. See excel line $line_number in file [$new_file].");
                if(strlen($excel_block_nbr) &&  $excel_block_nbr != 'NUL') {
                    pr('TODO 243345566666 file '.$new_file.' line '.$line_number); pr($excel_line_data);
                }
            } else {
                if(!strlen($excel_ramq)) {
                    pr('TODO 43435634636 file '.$new_file.' line '.$line_number); pr($excel_line_data);
                } else {
                                        
                    if(!isset($participant_detection[$excel_ramq])) {
                    
                        // ----------------------------------------------------------------------------------------------------------------------------------
                        // Find Participant on RAMQ only
                        // ----------------------------------------------------------------------------------------------------------------------------------
                        
                        $query = "SELECT RAMQ.participant_id, Participant.first_name, last_name, 
                            SL.identifier_value AS StLuc, HD.identifier_value AS HotelDieu, ND.identifier_value AS NotreDame, 
                            CM.id as consent_master_id, CM.consent_status
                            FROM misc_identifiers RAMQ
                            INNER JOIN participants Participant ON Participant.id = RAMQ.participant_id 
                            LEFT JOIN misc_identifiers SL ON Participant.id = SL.participant_id AND SL.deleted <> 1 AND SL.misc_identifier_control_id = ".$atim_controls['misc_identifier_controls']['saint-luc id nbr']['id']."
                            LEFT JOIN misc_identifiers HD ON Participant.id = HD.participant_id AND HD.deleted <> 1 AND HD.misc_identifier_control_id = ".$atim_controls['misc_identifier_controls']['hotel-dieu id nbr']['id']."
                            LEFT JOIN misc_identifiers ND ON Participant.id = ND.participant_id AND ND.deleted <> 1 AND ND.misc_identifier_control_id = ".$atim_controls['misc_identifier_controls']['notre-dame id nbr']['id']."
                            LEFT JOIN consent_masters CM ON CM.participant_id = Participant.id AND CM.deleted <> 1
                            WHERE RAMQ.deleted <> 1 AND RAMQ.identifier_value = '$excel_ramq' AND RAMQ.misc_identifier_control_id = ".$atim_controls['misc_identifier_controls']['ramq nbr']['id'].";";
                        $atim_data = getSelectQueryResult($query);
                        if(sizeof($atim_data) > 1) {
                            pr('TODO 5523467857 file '.$new_file.' line '.$line_number); pr($excel_line_data);
                            $participant_detection[$excel_ramq]['participant_id'] = null;
                        } elseif(!$atim_data) {
                            $participant_not_found[$excel_ramq] = '-';
                            recordErrorAndMessage('Participant definition',
                                '@@ERROR@@',
                                "Participant not found based on RAMQ. No blocks will be imported. Please validate.",
                                "RAMQ number [$excel_ramq], name = '$excel_first_name $excel_last_name', hospital number = '$excel_dossier'. See excel line $line_number in file [$new_file].");
                            $participant_detection[$excel_ramq]['participant_id'] = null;
                        } else {
                            $participant_found[$excel_ramq] = '-';
                            $atim_data = $atim_data[0];
                            if(!$atim_data['NotreDame']) {
                              //We suppose that all hospital numbers created by step1 are from notre dame 
                                pr('TODO 4343563443434636 file '.$new_file.' line '.$line_number); pr($excel_line_data);pr($atim_data);
                            }
                            $participant_detection[$excel_ramq] = $atim_data;
                            $participant_detection[$excel_ramq]['collections'] = array();
                        }
                    }
                    
                    if(isset($participant_detection[$excel_ramq]['participant_id'])) {
                                                
                        // ----------------------------------------------------------------------------------------------------------------------------------
                        // Validate participant with hospital number
                        // Create new hospital number if required
                        // ----------------------------------------------------------------------------------------------------------------------------------
                    
                        $atim_key = '';
                        $atim_control_key_to_create = '';
                        
                        /*
                        switch($excel_collection_site) {
                            case 'SL':
                                $atim_key = 'StLuc';
                                if(!strlen($participant_detection[$excel_ramq][$atim_key])) {
                                    $atim_control_key_to_create = 'saint-luc id nbr';
                                }
                                break;
                            case 'ND':
                                $atim_key = 'NotreDame';
                                if(!strlen($participant_detection[$excel_ramq][$atim_key])) {
                                    $atim_control_key_to_create = 'notre-dame id nbr';
                                }
                                break;
                            case 'HD':
                                $atim_key = 'HotelDieu';
                                if(!strlen($participant_detection[$excel_ramq][$atim_key])) {
                                    $atim_control_key_to_create = 'hotel-dieu id nbr';
                                }
                                break;
                        }
                        */
                        
                        //TODO Should we change following line
                        // Based on Stephanie comment, all hospital number of the files are ND hospital number
                        $atim_key = 'NotreDame';
                        if(!strlen($participant_detection[$excel_ramq][$atim_key])) {
                            $atim_control_key_to_create = 'notre-dame id nbr';
                        }
                        //End TODO       
                        
                        $areNamesInAtimAndExcelEqual = (($participant_detection[$excel_ramq]['first_name'] ==  $excel_first_name  && $participant_detection[$excel_ramq]['last_name'] == $excel_last_name)? true : false);
                        if(!preg_match('/'.$excel_dossier.'/', $participant_detection[$excel_ramq][$atim_key])) {
                            if($atim_control_key_to_create) {
                                recordErrorAndMessage('Participant definition',
                                    $areNamesInAtimAndExcelEqual? '@@MESSAGE@@' : '@@WARNING@@',
                                    "Participant found based on RAMQ ".($areNamesInAtimAndExcelEqual? 'and names' : '')." but $atim_key # does not exist into ATiM for 2nd validation. Participant will be linked to the block and the $atim_key # will be added to ATiM but please validate.",
                                    "RAMQ number [$excel_ramq], ATiM data [name = '".$participant_detection[$excel_ramq]['first_name']." ".$participant_detection[$excel_ramq]['last_name']."'] & Excel data [name = '$excel_first_name $excel_last_name', $atim_key # = '$excel_dossier']. See excel line $line_number in file [$new_file].");
                            } else {
                                recordErrorAndMessage('Participant definition',
                                    $areNamesInAtimAndExcelEqual? '@@WARNING@@' : '@@ERROR@@',
                                    "Participant found based on RAMQ ".($areNamesInAtimAndExcelEqual? 'and names' : '')." but $atim_key # does not match. Participant will be linked to the block but please validate.",
                                    "RAMQ number [$excel_ramq], ATiM data [name = '".$participant_detection[$excel_ramq]['first_name']." ".$participant_detection[$excel_ramq]['last_name']."', $atim_key # = '".$participant_detection[$excel_ramq][$atim_key]."'] & Excel data [name = '$excel_first_name $excel_last_name', $atim_key # = '$excel_dossier']. See excel line $line_number in file [$new_file].");
                            }
                            foreach(array('StLuc', 'NotreDame', 'HotelDieu') as $other_atim_key) {
                                if($other_atim_key != $atim_key && strlen($participant_detection[$excel_ramq][$other_atim_key]) && preg_match('/'.$excel_dossier.'/', $participant_detection[$excel_ramq][$other_atim_key])) {
                                    recordErrorAndMessage('Participant definition',
                                        '@@ERROR@@',
                                        "Participant found based on RAMQ. Excel $atim_key # does not match the ATiM $atim_key # but the ATiM $other_atim_key #. Participant will be linked to the block but please validate the participant hospital numbers created by the first step. Values have probably be linked to the wrong identifier.",
                                        "RAMQ number [$excel_ramq], ATiM data [name = '".$participant_detection[$excel_ramq]['first_name']." ".$participant_detection[$excel_ramq]['last_name']."', $other_atim_key # = '".$participant_detection[$excel_ramq][$other_atim_key]."'] & Excel data [name = '$excel_first_name $excel_last_name', $atim_key # = '$excel_dossier']. See excel line $line_number in file [$new_file].");
                                }                                
                            }
                        }
                        
                        if($atim_control_key_to_create) {
                            $identifier_value_to_create = str_replace(array('notre-dame id nbr','saint-luc id nbr','hotel-dieu id nbr'), array('N','S','H'), $atim_control_key_to_create).str_replace(' ', '', $excel_dossier);
                            customInsertRecord(array(
                                'misc_identifiers' => array(
                                    'participant_id' => $participant_detection[$excel_ramq]['participant_id'],
                                    'misc_identifier_control_id' => $atim_controls['misc_identifier_controls'][$atim_control_key_to_create]['id'],
                                    'flag_unique' => '1',
                                    'identifier_value' => $identifier_value_to_create)));
                            $created_identifier_counter++;
                            $participant_detection[$excel_ramq][$atim_key] = $identifier_value_to_create;
                        }
                        
                        // ----------------------------------------------------------------------------------------------------------------------------------
                        // Create collections / Or Reuse collection
                        // ----------------------------------------------------------------------------------------------------------------------------------
                        
                        $collection_key = "$excel_collectiondate-$excel_collection_site-$excel_patho";
                        if(!isset($participant_detection[$excel_ramq]['collections'][$collection_key])) {
                            $source_worksheet_collection_part_type = '?';
                            $excel_collectiondate_short = '';
                            $source_worksheet_collection_time = '?';
                            if(preg_match('/^((0[1-9])|([1-2][0-9])|(3[0-1]))\-((0[1-9])|(1[0-2]))\-([0-9]{4})$/', $excel_collectiondate, $matches)) {
                                $excel_collectiondate = $matches[8].'-'.$matches[5].'-'.$matches[1];
                                $excel_collectiondate_short = $matches[8].'-'.$matches[5];
                                if(!$dateValidationDone[0]) {
                                    recordErrorAndMessage('Block creation',
                                        '@@MESSAGE@@',
                                        "TODO: Please validate the date of 'Date du prelevement'",
                                        "Date du prelevement date = [$excel_collectiondate] for patient with RAMQ number [$excel_ramq] and block at line $line_number in file [$new_file].");
                                    $dateValidationDone[0] = '1';
                                }
                            } elseif(preg_match('/^([0-9]{5})$/', $excel_collectiondate, $matches)) {
                                $excel_collectiondate = validateAndGetDateAndAccuracy(
                                    $excel_collectiondate, 
                                    'Block creation', 
                                    '',
                                    "Collection date [$excel_collectiondate] does not match expected format. Date won't be added to the collection information recorded. See patient with RAMQ number [$excel_ramq] at line $line_number in file [$new_file].");
                                $excel_collectiondate = $excel_collectiondate[0];
                                $excel_collectiondate_short = substr($excel_collectiondate, 0,7);
                                if($excel_collectiondate && !$dateValidationDone[1]) {
                                    recordErrorAndMessage('Block creation',
                                        '@@MESSAGE@@',
                                        "TODO: Please validate the date of 'Date du prelevement'",
                                        "Date du prelevement date = [$excel_collectiondate] for patient with RAMQ number [$excel_ramq] and block at line $line_number in file [$new_file].");
                                    $dateValidationDone[1] = '1';
                                }
                            } else {
                                recordErrorAndMessage('Block creation', 
                                    '@@ERROR@@',
                                    "Wrong collection date format",
                                    "Collection date [$excel_collectiondate] does not match expected format. Date won't be added to the collection information recorded. See patient with RAMQ number [$excel_ramq] at line $line_number in file [$new_file].");
                                $excel_collectiondate = '';
                            }
                            if($excel_collectiondate) {
                                // Try to get the RR participant number and the colelction time from another collection
                                $query = "SELECT * FROM collections WHERE deleted <> 1 AND participant_id = ".$participant_detection[$excel_ramq]['participant_id'] ." AND collection_datetime LIKE '$excel_collectiondate%' AND chum_kidney_transp_collection_part_type LIKE 'R%'";
                                $atim_data = getSelectQueryResult($query);
                                if($atim_data && sizeof($atim_data) == 1) {
                                    $source_worksheet_collection_part_type = $atim_data[0]['chum_kidney_transp_collection_part_type'];
                                    $source_worksheet_collection_time = $atim_data[0]['chum_kidney_transp_collection_time'];
                                } else {
                                    $query = "SELECT * FROM collections WHERE deleted <> 1 AND participant_id = ".$participant_detection[$excel_ramq]['participant_id'] ." AND collection_datetime LIKE '$excel_collectiondate_short%'";
                                    $atim_data = getSelectQueryResult($query);
                                    $coll_found_msg = array();
                                    if($atim_data) {
                                        foreach($atim_data as $new_collection) {
                                            $coll_found_msg[] = "<font color='red'>".$new_collection['chum_kidney_transp_collection_part_type'].' '.$new_collection['chum_kidney_transp_collection_time'].'</font> on <b>'.substr($new_collection['collection_datetime'], 0, 10).'</b>';                                    
                                        }
                                        $coll_found_msg = implode(' && ', $coll_found_msg);
                                        recordErrorAndMessage('Block creation',
                                            '@@WARNING@@',
                                            "No existing collection matches on date but some colletions match the same month. Collection time and participant type can not be defined. Please validateand and add information into ATiM after the migration.",
                                            "See collection on date [$excel_collectiondate] and atim collections [$coll_found_msg] for patient with RAMQ number [$excel_ramq] at line $line_number in file [$new_file].");
                                    } else {
                                        recordErrorAndMessage('Block creation',
                                            '@@WARNING@@',
                                            "No existing collection matches on date. Collection time and participant type can not be defined. Please validate and add information into ATiM after the migration.",
                                            "See collection on date [$excel_collectiondate] for patient with RAMQ number [$excel_ramq] at line $line_number in file [$new_file].");
                                    }
                                }
                            }
                            $collection_id = customInsertRecord(array(
                                'collections' => array(
                                    'participant_id' => $participant_detection[$excel_ramq]['participant_id'],
                                    'consent_master_id' => $participant_detection[$excel_ramq]['consent_master_id'],
                                    'bank_id' => $bank_id,
                                    'collection_datetime' => $excel_collectiondate,
                                    'collection_datetime_accuracy' => 'h',
                                    'chum_kidney_transp_collection_part_type' => $source_worksheet_collection_part_type,
                                    'chum_kidney_transp_collection_time' => $source_worksheet_collection_time,
                                    'qc_nd_pathology_nbr' => $excel_patho,
                                    'collection_site' => str_replace(array('HD', 'ND', 'SL'), array('hotel-dieu hospital', 'notre-dame hospital', 'saint-luc hospital'), $excel_collection_site),
                                    'visit_label' => '',
                                    'collection_notes' => 'Created by the process to download the pathology blocks data from excel file on '.date("Y-m-d").'.',
                                    'collection_property' => 'participant collection')));
                            $created_collection_counter++;
                            $participant_detection[$excel_ramq]['collections'][$collection_key] = array('collection_id' => $collection_id, 'samples' => array());
                        }
                        $collection_id = $participant_detection[$excel_ramq]['collections'][$collection_key]['collection_id'];
                        
                        // ----------------------------------------------------------------------------------------------------------------------------------
                        // Create samples / Or Reuse sample if 'Enumeration des blocs' prefixs are equal
                        // ----------------------------------------------------------------------------------------------------------------------------------
                        
                        $sampleKey = '';
                        $sample_master_id = null;
                        if(preg_match('/^([A-Z])([0-9]*)$/', $excel_block_nbr, $matches)) {
                            $sampleKey = $matches[1];
                            if(isset($participant_detection[$excel_ramq]['collections'][$collection_key]['samples'][$sampleKey])) {
                                $sample_master_id = $participant_detection[$excel_ramq]['collections'][$collection_key]['samples'][$sampleKey];
                            }
                        } else {
                            recordErrorAndMessage('Block creation',
                                    '@@WARNING@@',
                                    "Block Code format ('Enumeration des blocs') is different than the expected one. Block will be created but please validate.",
                                    "See block [$excel_block_nbr] of the collection on date [$excel_collectiondate] for patient with RAMQ number [$excel_ramq] at line $line_number in file [$new_file].");
                        }
                        if(!$sample_master_id) {
                            $sample_counter++;
                            $sample_data = array(
                                'sample_masters' => array(
                                    'sample_code' => 'tmp_'.$sample_counter,
                                    'collection_id' => $collection_id,
                                    'sample_control_id' => $atim_controls['sample_controls']['tissue']['id'],
                                    'initial_specimen_sample_type' => 'tissue',
                                    'sample_code' => "tmp_$sample_counter",
                                    'notes' => $excel_tissue_notes),
                                'specimen_details' => array(),
                                $atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
                                    'tissue_source' => 'kidney'
                                )
                            );
                            $sample_master_id = customInsertRecord($sample_data);
                        }
                        if($sampleKey) {
                            $participant_detection[$excel_ramq]['collections'][$collection_key]['samples'][$sampleKey] = $sample_master_id;
                        } else {
                            $participant_detection[$excel_ramq]['collections'][$collection_key]['samples']['___with no key___'][] = $sample_master_id;
                        }
                        
                        // ----------------------------------------------------------------------------------------------------------------------------------
                        // Create block
                        // ----------------------------------------------------------------------------------------------------------------------------------
                        
                        $aliquot_label = $excel_patho.(strlen($excel_block_nbr)? "-$excel_block_nbr" : '');
                        
                        $storage_master_id = '';
                        $storage_coord_x = '';
                        $storage_coord_y = '';
                        if(!isset($storages['room-----------'])) {
                            $storage_data = array(
                                'storage_masters' => array(
                                    "code" => 'tmp_storage_'.sizeof($storages),
                                    "short_label" => 'HD.B.B.Room',
                                    "selection_label" => 'HD.B.B.Room',
                                    "storage_control_id" => $atim_controls['storage_controls']['room']['id'],
                                    'notes' => ''),
                                $atim_controls['storage_controls']['room']['detail_tablename'] => array());
                            $storages['room-----------'] = customInsertRecord($storage_data);
                        }
                        if(strlen($excel_line_data['Boite'])) {
                            if(!isset($storages[$excel_line_data['Boite']])) {
                            $storage_data = array(
                                'storage_masters' => array(
                                    "code" => 'tmp_storage_'.sizeof($storages),
                                    "short_label" => $excel_line_data['Boite'],
                                    "selection_label" => 'HD.B.B.Room-'.$excel_line_data['Boite'],
                                    "storage_control_id" => $atim_controls['storage_controls']['blocks box']['id'],
                                    'notes' => ''),
                                $atim_controls['storage_controls']['blocks box']['detail_tablename'] => array());
                                $storages[$excel_line_data['Boite']] = customInsertRecord($storage_data);
                            }
                            $storage_master_id = $storages[$excel_line_data['Boite']];
                        }
                        if($storage_master_id) {
                            if(preg_match('/^[1-8]$/', $excel_line_data['Tiroir'])) {
                                $storage_coord_x = $excel_line_data['Tiroir'];
                            } else {
                                recordErrorAndMessage('Storage creation',
                                    '@@WARNING@@',
                                    "Wrong drawer",
                                    "See drawer [".$excel_line_data['Tiroir']."] for block [$aliquot_label] of the collection on date [$excel_collectiondate] for patient with RAMQ number [$excel_ramq] at line $line_number in file [$new_file].");
                            }
                        }
                        $aliquot_data = array(
                            'aliquot_masters' => array(
                                "barcode" => 'tmp_block_'.($created_block_counter),
                                "aliquot_label" => $aliquot_label,
                                "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
                                "collection_id" => $collection_id,
                                "sample_master_id" => $sample_master_id,
                                'in_stock' => 'yes - available',
                                'storage_master_id' => $storage_master_id,
                                'storage_coord_x' => $storage_coord_x,
                                'storage_coord_y' => $storage_coord_y,
                                'notes' => $collection_notes),
                            $atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
                                'block_type'  => 'paraffin',
                                'sample_position_code' => $excel_block_nbr));
                        $aliquot_master_id = customInsertRecord($aliquot_data);
                        $created_block_counter++;
                        $createdBlockCounterPerFile[$new_file]['aliquot created']++;
                        $createdBlocks[$aliquot_label][] = array($aliquot_master_id, $sample_master_id, $collection_id, $excel_ramq, $excel_dossier, $excel_line_data['Date du prelevement']);
                        $createdBlocksSlidesFromSampleMasterId[$sample_master_id][] = 'Block : '.$aliquot_label;
                    }
                }  
            }
        }
    }
}

// Slides
//---------------------------------------------------------------------------------------------------

$worksheet_name = 'Slides';
$created_slide_counter = 0;
$createdSlideCounterPerFile = array();

$createdSlideCounterPerFile = array();
foreach(array('Enumeration des blocs', 'No Patho', 'Note de collection', 'Date du prelevement', 'RAMQ', 'Notes de collection') as $field_label) {
recordErrorAndMessage('Slide creation',
    '@@WARNING@@',
    "Slide creation is based on a limited list of excel fields. Please check the followinf fields and validate.",
    "$field_label");
}
foreach($excel_file_names['slides'] as $new_file) {
    $createdSlideCounterPerFile[$new_file] = array('lines' => 0, 'aliquot studied' => 0, 'aliquot created' => 0);
    while(list($line_number, $excel_line_data) = getNextExcelLineData($new_file, $worksheet_name, 1)) {
        $createdSlideCounterPerFile[$new_file]['lines']++;
        $createdSlideCounterPerFile[$new_file]['aliquot studied']++;

        $excel_first_name = $excel_line_data['Prenom'];
        $excel_last_name = $excel_line_data['Nom'];
        $excel_dossier = $excel_line_data['No de dossier'];
        $excel_ramq = $excel_line_data['RAMQ'];

        $excel_collectiondate = $excel_line_data['Date du prelevement'];
        $excel_collection_site = $excel_line_data['Lieu du Prelevement ND, SL, HD'];
        $excel_patho = $excel_line_data['No Patho'];
        $collection_notes = isset($excel_line_data['Note de collection'])? $excel_line_data['Note de collection'] : (isset($excel_line_data['Notes de collection'])? $excel_line_data['Notes de collection'] : '');
        if(!isset($excel_line_data['Note de collection']) && !isset($excel_line_data['Notes de collection'])) {
            pr('TODO 8weqwqwqw207 23782');pr($excel_line_data);
        }
        $excel_block_nbr = $excel_line_data['Enumeration des blocs'];
        $excel_tissue_notes = isset($excel_line_data['Traitement description'])? $excel_line_data['Traitement description'] : 'Biopsie du greffon rénal.';
        
        // ----------------------------------------------------------------------------------------------------------------------------------
        // Find block or Tissue or Collection
        // ----------------------------------------------------------------------------------------------------------------------------------
        
        $aliquot_label = $excel_patho.(strlen($excel_block_nbr)? "-$excel_block_nbr" : '');
        $collection_key = "$excel_collectiondate-$excel_collection_site-$excel_patho";
        $sampleKey = '';
        if(preg_match('/^([A-Z])([0-9]*)$/', $excel_block_nbr, $matches)) {
            $sampleKey = $matches[1];
        }
        
        $collection_id = null;
        $sample_master_id = null;
        $parent_aliquot_master_id = null;
        if(!strlen($excel_patho)) {
            recordErrorAndMessage('Slide creation',
                '@@WARNING@@',
                "Patho number unknown (reason could be that the all line is empty). Slide won't be imported. Please validate.",
                "RAMQ number [$excel_ramq], name = '$excel_first_name $excel_last_name', hospital number = '$excel_dossier'. See excel line $line_number in file [$new_file].");
        } else if($collection_notes == 'ABSENT' || (strlen($excel_block_nbr) &&  $excel_block_nbr == 'NUL')) {
                recordErrorAndMessage('Slide creation',
                    '@@MESSAGE@@',
                    "Notes of the slide is flagged as 'Absent'. No slide will be imported. Please validate.",
                    "RAMQ number [$excel_ramq], name = '$excel_first_name $excel_last_name', hospital number = '$excel_dossier'. See excel line $line_number in file [$new_file].");
            if($excel_line_data['Boite'] != 'NUL') {
                pr('TODO 823errerer034 7207 23782');pr($excel_line_data);
            }
        } else if(isset($createdBlocks[$aliquot_label])) {
            if(sizeof($createdBlocks[$aliquot_label] == 1)) {
                // Block found
                list($parent_aliquot_master_id, $sample_master_id, $collection_id, $block_ramq, $block_dossier, $block_collection_date) = $createdBlocks[$aliquot_label][0];
                if($block_ramq != $excel_ramq || $block_dossier != $excel_dossier || $block_collection_date != $excel_collectiondate) {
                    pr('TODO 823794827 987230 827034 7207 23782');pr($createdBlocks[$aliquot_label][0]);pr($excel_line_data);
                }   
            } else {
                //More than one aliquot match the label: link slide to sample if it's the same one
                pr('TODO 828778888882');pr($createdBlocks[$aliquot_label][0]);pr($excel_file_names);
            }
        } else if(isset($participant_detection[$excel_ramq]['collections'][$collection_key]['samples'][$sampleKey])) {
            // aliquot label does not match a block aliquot label but can be linked to an existing sample
            $collection_id = $participant_detection[$excel_ramq]['collections'][$collection_key]['collection_id'];
            $sample_master_id = $participant_detection[$excel_ramq]['collections'][$collection_key]['samples'][$sampleKey];
            recordErrorAndMessage('Slide creation',
                '@@MESSAGE@@',
                "Block used to create slide can not be found based on aliquot label ('No Patho' + 'Enumeration des blocs') but the sample linked to this block has been created previously by the script. Slide will be linked to the sample but not to the block. Please validate.",
                "See slide '$aliquot_label' and blocks [".implode('], [', $createdBlocksSlidesFromSampleMasterId[$sample_master_id])."] linked to the sample of the slide for participant with RAMQ number [$excel_ramq], name = '$excel_first_name $excel_last_name', hospital number = '$excel_dossier'. See excel line $line_number in file [$new_file].");
        } else if(isset($participant_detection[$excel_ramq]['collections'][$collection_key]['collection_id'])) {
            // Create a new tissue
            $collection_id = $participant_detection[$excel_ramq]['collections'][$collection_key]['collection_id'];
            $sample_counter++;
            $sample_data = array(
                'sample_masters' => array(
                    'sample_code' => 'tmp_'.$sample_counter,
                    'collection_id' => $collection_id,
                    'sample_control_id' => $atim_controls['sample_controls']['tissue']['id'],
                    'initial_specimen_sample_type' => 'tissue',
                    'notes' => $excel_tissue_notes),
                'specimen_details' => array(),
                $atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
                    'tissue_source' => 'kidney'
                )
            );
            $sample_master_id = customInsertRecord($sample_data);
            if($sampleKey) {
                $participant_detection[$excel_ramq]['collections'][$collection_key]['samples'][$sampleKey] = $sample_master_id;
            } else {
                $participant_detection[$excel_ramq]['collections'][$collection_key]['samples']['___with no key___'][] = $sample_master_id;
            }
            recordErrorAndMessage('Slide creation',
                '@@WARNING@@',
                "Block and tissue used to create slide can not be found based on aliquot label ('No Patho' + 'Enumeration des blocs') but the collection linked to this block has been created previously by the script. A new tissue sample will be created and the slide will be linked to this new sample instead  to the block. Please validate.",
                "See slide '$aliquot_label' and new sample created for collection with collection date '$excel_collectiondate', site '$excel_collection_site' and patho# '$excel_patho' for participant with RAMQ number [$excel_ramq], name = '$excel_first_name $excel_last_name', hospital number = '$excel_dossier'. See excel line $line_number in file [$new_file].");
        } else {
            // Collection not found
            recordErrorAndMessage('Slide creation',
                '@@ERROR@@',
                "No collection used to create the slide can be found based on collection date, ramq and paho nunber. Slide won't be created. Please validate and create slide manually.",
                "See slide '$aliquot_label' for participant with RAMQ number [$excel_ramq], name = '$excel_first_name $excel_last_name', hospital number = '$excel_dossier'. See excel line $line_number in file [$new_file].");
        }
        
        if($sample_master_id) {
            
            // ----------------------------------------------------------------------------------------------------------------------------------
            // Create slide
            // ----------------------------------------------------------------------------------------------------------------------------------
            
            $storage_master_id = '';
            $storage_coord_x = '';
            $storage_coord_y = '';
            if(!isset($storages['room-----------'])) {
                $storage_data = array(
                    'storage_masters' => array(
                        "code" => 'tmp_storage_'.sizeof($storages),
                        "short_label" => 'HD.B.B.Room',
                        "selection_label" => 'HD.B.B.Room',
                        "storage_control_id" => $atim_controls['storage_controls']['room']['id'],
                        'notes' => ''),
                    $atim_controls['storage_controls']['room']['detail_tablename'] => array());
                $storages['room-----------'] = customInsertRecord($storage_data);
            }
            if(strlen($excel_line_data['Boite'])) {
                if(!isset($storages[$excel_line_data['Boite']])) {
                    $storage_data = array(
                        'storage_masters' => array(
                            "code" => 'tmp_storage_'.sizeof($storages),
                            "short_label" => $excel_line_data['Boite'],
                            "selection_label" => 'HD.B.B.Room-'.$excel_line_data['Boite'],
                            "storage_control_id" => $atim_controls['storage_controls']['blocks box']['id'],
                            'notes' => ''),
                        $atim_controls['storage_controls']['blocks box']['detail_tablename'] => array());
                    $storages[$excel_line_data['Boite']] = customInsertRecord($storage_data);
                }
                $storage_master_id = $storages[$excel_line_data['Boite']];
            }
            if($storage_master_id) {
                if(preg_match('/^[1-8]$/', $excel_line_data['Tiroir'])) {
                    $storage_coord_x = $excel_line_data['Tiroir'];
                } else {
                    recordErrorAndMessage('Storage creation',
                        '@@WARNING@@',
                        "Wrong drawer",
                        "See drawer [".$excel_line_data['Tiroir']."] for slide [$aliquot_label] of the collection on date [$excel_collectiondate] for patient with RAMQ number [$excel_ramq] at line $line_number in file [$new_file].");
                }
            }
            $aliquot_label = $excel_patho.(strlen($excel_block_nbr)? "-$excel_block_nbr" : '');
            $aliquot_data = array(
                'aliquot_masters' => array(
                    "barcode" => 'tmp_slide_'.($created_slide_counter),
                    "aliquot_label" => $aliquot_label,
                    "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-slide']['id'],
                    "collection_id" => $collection_id,
                    "sample_master_id" => $sample_master_id,
                    'in_stock' => 'yes - available',
                    'storage_master_id' => $storage_master_id,
                    'storage_coord_x' => $storage_coord_x,
                    'storage_coord_y' => $storage_coord_y,
                    'notes' => $collection_notes),
                $atim_controls['aliquot_controls']['tissue-slide']['detail_tablename'] => array());
            $aliquot_master_id = customInsertRecord($aliquot_data);
            $created_slide_counter++;
            $createdSlideCounterPerFile[$new_file]['aliquot created']++;
            $createdBlocksSlidesFromSampleMasterId[$sample_master_id][] = 'Slide : '.$aliquot_label;
            if($parent_aliquot_master_id) {
                customInsertRecord(array('realiquotings' => array('parent_aliquot_master_id' => $parent_aliquot_master_id, 'child_aliquot_master_id' => $aliquot_master_id)));
            }
        }  
    }
}

// End of the process
//---------------------------------------------------------------------------------------------------

recordErrorAndMessage('Summary', '@@MESSAGE@@', "Participants Found in blocks files", sizeof($participant_found).'/'.(sizeof($participant_found)+sizeof($participant_not_found)));
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter from block files", "$created_identifier_counter new participant identifiers.");
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter from block files", "$created_collection_counter new collections.");
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "$sample_counter tissues.");
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", sizeof($storages)." storages.");
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter from block files", "$created_block_counter blocks.");
foreach($createdBlockCounterPerFile as $new_file => $stat) {
    recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "File $new_file : created ".$stat['aliquot created']."/".$stat['aliquot studied']." blocks from ".$stat['lines']." lines.");
}
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter from block files", "$created_slide_counter slides.");
foreach($createdSlideCounterPerFile as $new_file => $stat) {
    recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "File $new_file : created ".$stat['aliquot created']."/".$stat['aliquot studied']." slides from ".$stat['lines']." lines.");
}

$final_queries = array();
$final_queries[] = "UPDATE aliquot_masters SET barcode = CONCAT('BlockATiM#',id) WHERE barcode like 'tmp_block_%';";
$final_queries[] = "UPDATE aliquot_masters_revs SET barcode = CONCAT('BlockATiM#',id) WHERE barcode like 'tmp_block_%';";
$final_queries[] = "UPDATE aliquot_masters SET barcode = CONCAT('BlockATiM#',id) WHERE barcode like 'tmp_slide_%';";
$final_queries[] = "UPDATE aliquot_masters_revs SET barcode = CONCAT('BlockATiM#',id) WHERE barcode like 'tmp_slide_%';";
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
	    
	    "DELETE FROM realiquotings  WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';",
	    
		"DELETE FROM  ad_tissue_slides WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"DELETE FROM  ad_tissue_slides_revs WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
        "DELETE FROM  ad_blocks WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"DELETE FROM  ad_blocks_revs WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
	    "DELETE FROM aliquot_masters  WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';", 
	    "DELETE FROM aliquot_masters_revs  WHERE modified_by = $migration_user_id AND version_created LIKE  '$truncate_date_limit%';", 
		"DELETE FROM  sd_spe_tissues WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"DELETE FROM  sd_spe_tissues_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"DELETE FROM  specimen_details WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"DELETE FROM  specimen_details_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');", 
		"UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null  WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';",
		"DELETE FROM sample_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';",
		"DELETE FROM sample_masters_revs WHERE modified_by = $migration_user_id AND version_created LIKE  '$truncate_date_limit%';", 
		
	    "DELETE FROM view_aliquot_uses WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	    "DELETE FROM view_aliquots WHERE collection_id IN (SELECT id FROM collections WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	    "DELETE FROM view_samples WHERE collection_id IN (SELECT id FROM collections WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	    "DELETE FROM view_collections WHERE collection_id IN (SELECT id FROM collections WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	        
	    "DELETE FROM collections WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';",
		"DELETE FROM collections_revs WHERE modified_by = $migration_user_id AND version_created LIKE  '$truncate_date_limit%';",
	        
	    "DELETE FROM misc_identifiers WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';",
		"DELETE FROM misc_identifiers_revs WHERE modified_by = $migration_user_id AND version_created LIKE  '$truncate_date_limit%';",
	    
	    "DELETE FROM  std_rooms WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	    "DELETE FROM  std_rooms_revs WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	    "DELETE FROM  std_boxs WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	    "DELETE FROM  std_boxs_revs WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%');",
	    "DELETE FROM storage_masters  WHERE created_by = $migration_user_id AND created LIKE  '$truncate_date_limit%';",
	    "DELETE FROM storage_masters_revs  WHERE modified_by = $migration_user_id AND version_created LIKE  '$truncate_date_limit%';",
	    	    
	    "SET FOREIGN_KEY_CHECKS=1;",
	);

    foreach($truncate_queries as $query) {
        pr($query);
        customQuery($query, __FILE__, __LINE__);
    }
    
 //   global $db_connection;mysqli_commit($db_connection);pr('truncate');exit;
}

function addViewUpdate(&$final_queries) {
    global $import_date;
    global $migration_user_id;
    
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
		Participant.participant_identifier AS participant_identifier,
CONCAT(IFNULL(MiscIdentifier.identifier_value, '?'), ' ', Collection.chum_kidney_transp_collection_part_type, ' ', Collection.chum_kidney_transp_collection_time) acquisition_label,
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
Collection.chum_kidney_transp_collection_part_type,
Collection.chum_kidney_transp_collection_time,
TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs as qc_nd_pathology_nbr_from_sardo
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
LEFT JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.id = Collection.treatment_master_id AND TreatmentMaster.deleted <> 1
			WHERE Collection.deleted <> 1
        AND Collection.created = "."'$import_date' AND Collection.created_by = '$migration_user_id'
    )";

    $final_queries[] = 'INSERT INTO view_samples (
    SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
	
		Collection.bank_id,
		Collection.sop_master_id,
		Collection.participant_id,
	
		Participant.participant_identifier,
	
CONCAT(IFNULL(MiscIdentifier.identifier_value, "?"), " ", Collection.chum_kidney_transp_collection_part_type, " ", Collection.chum_kidney_transp_collection_time) acquisition_label,
	
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
        AND SampleMaster.created = "'.$import_date.'" AND SampleMaster.created_by = "'.$migration_user_id.'"
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
		
CONCAT(IFNULL(MiscIdentifier.identifier_value, "?"), " ", Collection.chum_kidney_transp_collection_part_type, " ", Collection.chum_kidney_transp_collection_time) acquisition_label,
		
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
        AND AliquotMaster.created = "'.$import_date.'" AND AliquotMaster.created_by = "'.$migration_user_id.'"
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
        AND AliquotMaster.created = '$import_date' AND AliquotMaster.created_by = '$migration_user_id'
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
        AND AliquotMaster.created = '$import_date' AND AliquotMaster.created_by = '$migration_user_id'

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
        AND AliquotMaster.created = '$import_date' AND AliquotMaster.created_by = '$migration_user_id'

    )";
}