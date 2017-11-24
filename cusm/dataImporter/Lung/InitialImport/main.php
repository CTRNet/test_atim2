<?php

/**
 * Script to dowload the CUSM Lung Bank Initial Data
 * 
 * @author N. Luc
 * @version 2017-11-14
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

$tmp_files_names_list = array($excel_file_name);

displayMigrationTitle('CUSM Lung Bank : Initial Data Import', $tmp_files_names_list);

if(!testExcelFile($tmp_files_names_list)) {
	dislayErrorAndMessage();
	exit;
}

// *** Data Control ***

if(true) {
    $queries = array();
    
    // Main
    //.................................................................................
    
    // Inventory
    
    $queries[] = "TRUNCATE ad_tubes;";
    $queries[] = "DELETE FROM aliquot_masters;";
    
    $queries[] = "TRUNCATE sd_spe_bloods;";
    $queries[] = "TRUNCATE sd_spe_tissues;";
    $queries[] = "TRUNCATE sd_der_plasmas;";
    $queries[] = "TRUNCATE sd_der_serums;";
    $queries[] = "TRUNCATE sd_der_pbmcs;";
    
    $queries[] = "TRUNCATE specimen_details;";
    $queries[] = "TRUNCATE derivative_details;";
    $queries[] = "UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null;";
    $queries[] = "DELETE FROM sample_masters;";

    $queries[] = "DELETE FROM collections;";

    $queries[] = "TRUNCATE std_nitro_locates;";
    $queries[] = "TRUNCATE std_freezers;";
    $queries[] = "TRUNCATE std_boxs;";
    $queries[] = "TRUNCATE std_racks;";
    $queries[] = "UPDATE storage_masters SET parent_id = null";
    $queries[] = "DELETE FROM storage_masters;";   

    $queries[] = "TRUNCATE sopd_general_alls;";
    $queries[] = "DELETE FROM sop_masters;";
    
    // Clinical    

    $queries[] = "TRUNCATE cusm_cd_lungs;";
    $queries[] = "DELETE FROM consent_masters;";
    
    $queries[] = "TRUNCATE misc_identifiers;";
    
    $queries[] = "DELETE FROM participants;";
    
    // Revs
    //.................................................................................
    
    $queries[] = "TRUNCATE ad_tubes_revs;";
    $queries[] = "DELETE FROM aliquot_masters_revs;";
    
    $queries[] = "TRUNCATE sd_spe_ascites_revs;";
    $queries[] = "TRUNCATE specimen_details_revs;";
    $queries[] = "UPDATE sample_masters_revs SET parent_id = null, initial_specimen_sample_id = null;";
    $queries[] = "DELETE FROM sample_masters_revs;";
    
    $queries[] = "DELETE FROM collections_revs;";
    
    //---------------------------------------------------
    
    

    $queries[] = "TRUNCATE misc_identifiers_revs;";
    $queries[] = "TRUNCATE participants_revs;";
    
    foreach($queries as $new_truncate_query) {
        customQuery($new_truncate_query);
    }    
}
$data_counter = getSelectQueryResult("SELECT count(*) as res FROM participants WHERE deleted <> 1");
if($data_counter[0]['res']) {
    die('ERR1');
}
$data_counter = getSelectQueryResult("SELECT count(*) as res FROM collections WHERE deleted <> 1");
if($data_counter[0]['res']) {
    die('ERR2');
}
$data_counter = getSelectQueryResult("SELECT count(*) as res FROM storage_masters WHERE deleted <> 1");
if($data_counter[0]['res']) {
    die('ERR3');
}

// *** PARSE EXCEL FILES ***

$data_bank_id = getSelectQueryResult("SELECT id FROM banks WHERE name = 'Lung/Poumon' AND deleted <> 1");
$data_bank_id = $data_bank_id[0]['id'];
if(!$data_bank_id) die('ERR Bank Id Unknwon');
if($data_bank_id != $atim_controls['misc_identifier_controls']['lung bank participant number']['id']) die('ERR Bank Id != MiscIdentifier');

$sop_master_id = customInsertRecord(array(
    'sop_masters' => array('code' => 'Inventory/Inventaire', 'version' => '2016-08-20', 'sop_control_id' => '1', 'status' => 'activated'),
    'sopd_general_alls' => array()));

global $atim_storage_key_to_storage_master_id;
$atim_storage_key_to_storage_master_id = array();

$cusm_bank_patient_id_check = array();
$cusm_mrn_check = array();

$created_participant_counter = 0;
$created_consent_counter = 0;
$created_collection_counter = 0;
$created_sample_counter = 0;
$created_aliquot_counter = 0;
global $created_storage_counter;
$created_storage_counter = 0;

$last_lung_bank_key_value_used = 1;
$worksheet_name = 'DATABASE';
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2,  $windows_xls_offset)) {
	$bank_patient_id = $excel_line_data['Patient ID'];
	if($bank_patient_id) {
	    
	    // Chek it's a new participant
	    
	    $continue = true;
    	if(isset($cusm_bank_patient_id_check[$bank_patient_id])) {
    	    recordErrorAndMessage('Participant', 
    	        '@@ERROR@@', 
    	        "Patient Id Defined Twice - No participant data of this row will be migrated.", 
    	        "See PatientID '$bank_patient_id' and MRN '$bank_patient_mrn' on line $line_number.");
    	    $continue = false;
    	}
    	$cusm_bank_patient_id_check[$bank_patient_id] = '1';
    	
    	$bank_patient_mrn = $excel_line_data['Patient Information MRN'];
    	if($bank_patient_mrn && isset($cusm_mrn_check[$bank_patient_mrn])) {
            recordErrorAndMessage('Participant', 
                '@@ERROR@@', 
                "Patient MRN Defined Twice - No participant data of this row  will be migrated.", 
                "See PatientID '$bank_patient_id' and MRN '$bank_patient_mrn' on line $line_number.");
    	    $continue = false;
    	}
    	$cusm_mrn_check[$bank_patient_mrn] = '1';
    	
    	if($continue) {
    	
        	$excel_data_references = "Participant '<b>$bank_patient_id</b>' Line '<b>$line_number</b>'";
        	
    	   // Create participant
    	   //-------------------------------------------------------------------------------------------
    	   
        	$excel_participant_data = array(
        	    'first_name' => $excel_line_data['Patient Information First_Name'],
        	    'last_name' => $excel_line_data['Patient Information Last_Name'],
        	    'last_modification' => $import_date);    	
        	
        	$participant_id = customInsertRecord(array('participants' => $excel_participant_data));
        	addCreatedDataToSummary('New Participant', "Participant '".$excel_line_data['Patient Information First_Name']." ".$excel_line_data['Patient Information Last_Name']."'.", $excel_data_references);
        	$created_participant_counter++;
        	
        	if($bank_patient_id) {
        	    if(preg_match('/^JS\-[0-9]{2}\-([0-9]+)$/', $bank_patient_id, $matches)) {
        	        $matches[1] = $matches[1]*1;
        	        if($last_lung_bank_key_value_used < $matches[1]) $last_lung_bank_key_value_used = $matches[1];
        	    }  else {
        	        die('ERR Misc Identifier Format : '.$bank_patient_id);
        	    }
        	    $misc_identifier_data = array(
        	        'identifier_value' => $bank_patient_id,
        	        'participant_id' => $participant_id,
        	        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['lung bank participant number']['id'],
        	        'flag_unique' => $atim_controls['misc_identifier_controls']['lung bank participant number']['flag_unique'],
        	        'cusm_bank_id' => $atim_controls['misc_identifier_controls']['lung bank participant number']['cusm_bank_id'],
        	        'cusm_is_main_bank_participant_identifier' => $atim_controls['misc_identifier_controls']['lung bank participant number']['cusm_is_main_bank_participant_identifier']
        	    );
        	    customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
        	}
        	
        	if($bank_patient_mrn) {
        	    $misc_identifier_data = array(
        	        'identifier_value' => $bank_patient_mrn,
        	        'participant_id' => $participant_id,
        	        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['MGH-MRN']['id'],
        	        'flag_unique' => $atim_controls['misc_identifier_controls']['MGH-MRN']['flag_unique']
        	    );
        	    customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
        	}
    	}
    	
    	// Create consent
    	//-------------------------------------------------------------------------------------------
    	
    	$consent_master_id = null;
    	if(preg_match('/^[Yy]/', $excel_line_data['Consent Consented (Y/N)'])){
    	    if(strlen(trim($excel_line_data['Consent Consented (Y/N)'])) != 1) {
    	        recordErrorAndMessage('Consent', 
    	            '@@WARNING@@', 
    	            "Created 'Obtained' consent but the 'Consented' value is different than 'Y'. Please confirm and check no additional information has to be recorded.", 
    	            "See value '".$excel_line_data['Consent Consented (Y/N)']."' for $excel_data_references.");
    	    }
    	    
    	    $excel_field = 'Consent Date Consented';
    	    list($consent_date, $consent_date_accuracy) = validateAndGetDateAndAccuracy(
    	        $excel_line_data[$excel_field], 
    	        'Consent', 
    	        "See field '$excel_field'.", 
    	        "See $excel_data_references");
    	    	
    	    $excel_field = "Consent Consenter";
    	    $consent_person = validateAndGetStructureDomainValue(
    	        str_replace(array("Spicer", "Ioana", "Dong", "Aya", "Julie"), array("Jonathan Spicer", "Ioana Nicolau", "Dong", "Aya Siblini", "Julie Breau"), $excel_line_data[$excel_field]), 
    	        'cusm_lung_bank_staff', 
    	        'Consent', 
    	        "See field '$excel_field'.", 
    	        "The consenter value won't be migrated for $excel_data_references");

    	    $consent_data = array(
    	        'consent_masters' => array(
    	            "participant_id" => $participant_id,
    	            "consent_control_id" =>  $atim_controls['consent_controls']['lung bank consent']['id'],
    	            "consent_status" => 'obtained',
    	            "consent_person" => $consent_person,
    	            'consent_signed_date' => $consent_date,
    	            'consent_signed_date_accuracy' => $consent_date_accuracy),
    	        $atim_controls['consent_controls']['lung bank consent']['detail_tablename'] => array());
            $consent_master_id = customInsertRecord($consent_data);    	    
    	} else {
            recordErrorAndMessage('Consent', 
	            '@@MESSAGE@@', 
	            "Paricipant not consented. No consent will be created into ATiM. Please confirm.", 
	            "See $excel_data_references.");
            if(!preg_match('/^[Nn]{0,1}$/', $excel_line_data['Consent Consented (Y/N)'])){
                recordErrorAndMessage('Consent',
                    '@@WARNING@@',
                    "Created not consented but the value of 'Consent Consented (Y/N)' field is not empty and different than 'N'. Please check no data has to be recorded into ATiM and complete data after migration if required.",
                    "See value '".$excel_line_data['Consent Consented (Y/N)']."' for $excel_data_references.");
            }
    	}
    	if(strlen($excel_line_data['D_OPB'])) {
    	    recordErrorAndMessage('Consent',
    	        '@@WARNING@@',
    	        "'D_OPB' field is not empty but the data of this field is not a data migrated into ATiM. Please check no data has to be completed into ATiM.",
    	        "See value '".$excel_line_data['D_OPB']."' for $excel_data_references.");
    	    
    	}

    	// Create inventory
    	//-------------------------------------------------------------------------------------------
    	
    	$excel_line_data['D_OP'] = str_replace(array('Not scheduled yet', 'Cancelled'), array('', ''), $excel_line_data['D_OP']);
    	$excel_field = 'D_OP';
    	list($collection_date, $collection_date_accuracy) = validateAndGetDateAndAccuracy(
    	    $excel_line_data[$excel_field],
    	    'Inventory',
    	    "See field '$excel_field'.",
    	    "See $excel_data_references");
    	
	    // Check collection has to be created
	    
	    $collection_notes = array();
	    foreach(array('Tissue' => 'TISSUE Notes', 'Pre-Surgery' => 'Pre-Surgery Notes') as $note_title => $excel_field) {
	        if(strlen($excel_line_data[$excel_field]) && $excel_line_data[$excel_field] != '-') {
	            $collection_notes[] = "$note_title : <b>".$excel_line_data[$excel_field]."</b>.";
	        }
	    }
	    if($excel_line_data['TISSUE Lymph Nodes'] == 'No') {
	        $excel_line_data['TISSUE Lymph Nodes'] = '';
	        $collection_notes[] = 'No lymph nodes.';
	    }
	    
	    $inventory_data_found = false;
	    $inventory_fields = array(
	        'TISSUE Location', 'TISSUE Rack #', 'TISSUE Box #', 'TISSUE Normal', 'TISSUE Tumor', 'TISSUE Lymph Nodes',
            'Pre-Surgery Location', 
                'Pre-Surgery Box #1', 'Pre-Surgery Serum1', 'Pre-Surgery Plasma1', 'Pre-Surgery WBC1',
                'Pre-Surgery Box #2', 'Pre-Surgery Serum2', 'Pre-Surgery Plasma2', 'Pre-Surgery WBC2');
        
	    foreach($inventory_fields as $new_excel_fields) {
	        if($excel_line_data[$new_excel_fields] == '-') {
	            $excel_line_data[$new_excel_fields] = '';
	        }
	        if(strlen($excel_line_data[$new_excel_fields])) {
	            $inventory_data_found = true;
	        }    	        
	    }
        
	    if(!$inventory_data_found) {
	               
	           // No collection to create
                
                $tmp_data = $collection_notes;
	            if(!strlen($collection_date) && strlen( $excel_line_data['D_OP'])) $collection_date =  $excel_line_data['D_OP'];
	            if($collection_date) $tmp_data[] = "Collection date = <b>$collection_date</b>";
	            if($tmp_data) {
	                recordErrorAndMessage('Consent',
	                    '@@WARNING@@',
	                    "No aliquot data exists. Collection won't be created into ATiM but some notes and/or collection date exist. This information won't be mirgated. Please check no data has to be recorded into ATiM and complete data after migration if required.",
	                    "See note(s) '".implode("' & '", $tmp_data)."' for $excel_data_references.");
	            } else {
	                recordErrorAndMessage('Consent',
	                    '@@MESSAGE@@',
	                    "No collection won't be created into ATiM. Please check no data has to be recorded into ATiM and complete data after migration if required.",
	                    "See $excel_data_references.");
	            }
    	    
	   } else {  
    	        
    	    if(!$consent_master_id) {
    	        recordErrorAndMessage('Consent',
    	            '@@WARNING@@',
    	            "Participant did not consented but collection data exists. Collection will be created into ATiM. Please check no data has to be corrected into ATiM and complete data after migration if required.",
    	            "See collection for $excel_data_references.");
    	    }
    	    
    	    $collection_data = array(
    	        'collection_property' => 'participant collection',
    	        'participant_id' => $participant_id,
    	        'bank_id' => $data_bank_id,
    	        'collection_datetime' => $collection_date,
    	        'collection_datetime_accuracy' => str_replace('c', 'h', $collection_date_accuracy),
    	        'consent_master_id' => $consent_master_id,
    	        'sop_master_id' => $sop_master_id,
    	        'collection_site' => "montreal general hospital", 
    	        'collection_notes' => str_replace(array('<b>', '</b>'), array('', ''), implode(' ', $collection_notes))
    	    );
    	    $collection_id = customInsertRecord(array('collections' => $collection_data));
    	    $created_collection_counter++;
    	    
    	    // Load tissue aliquots	   
    	    
    	    $tissue_aliquots = getAliquots(
    	        $excel_data_references,
    	        'tissue', 
    	        $excel_line_data['TISSUE Location'], 
    	        $excel_line_data['TISSUE Box #'], 
                array('normal' => $excel_line_data['TISSUE Normal'], 'tumor' => $excel_line_data['TISSUE Tumor'], 'lymph nodes' => $excel_line_data['TISSUE Lymph Nodes']), 
    	        $excel_line_data['TISSUE Rack #']);
    	    
    	    // Load blood aliquots
    	    
    	    $blood_aliquots = getAliquots(
    	        $excel_data_references,
    	        'blood',
    	        $excel_line_data['Pre-Surgery Location'],
    	        $excel_line_data['Pre-Surgery Box #1'],
    	        array('serum' => $excel_line_data['Pre-Surgery Serum1'], 'plasma' => $excel_line_data['Pre-Surgery Plasma1'], 'pbmc' => $excel_line_data['Pre-Surgery WBC1']));
    	    
    	    $blood_2_aliquots = getAliquots(
    	        $excel_data_references,
    	        'blood',
    	        $excel_line_data['Pre-Surgery Location'],
    	        $excel_line_data['Pre-Surgery Box #2'],
    	        array('serum' => $excel_line_data['Pre-Surgery Serum2'], 'plasma' => $excel_line_data['Pre-Surgery Plasma2'], 'pbmc' => $excel_line_data['Pre-Surgery WBC2']));
    	    
    	    if(!$tissue_aliquots && !$blood_aliquots && !$blood_2_aliquots) {
    	        recordErrorAndMessage('Consent',
    	            '@@WARNING@@',
    	            "An empty collection (no aliquot) has been created into ATiM. Please check no data has to be recorded into ATiM and complete/correct data after migration if required.",
    	            "See ".($collection_date? " collection on $collection_date for " : '')." $excel_data_references.");
    	    } else {
    	        //Tissue aliquots creation
    	        $created_tissue_sample_master_ids = array();
    	        foreach($tissue_aliquots as $new_tissue_aliquots) {
    	            //WARNING :: positions x and y permuted
    	            list($cusm_tissue_nature, $storage_master_id, $storage_coord_y, $storage_coord_x) = $new_tissue_aliquots;
    	            if(!array_key_exists($cusm_tissue_nature, $created_tissue_sample_master_ids)) {
        	            $created_sample_counter++;
        	            $tissue_source = 'C34';
        	            $cusm_tissue_nature_to_record = $cusm_tissue_nature;
        	            if($cusm_tissue_nature_to_record == 'lymph nodes') {
        	                $cusm_tissue_nature_to_record = '';
        	                $tissue_source = 'C77';
        	            }
        	            $sample_data = array(
        	                'sample_masters' => array(
        	                    "sample_code" => 'tmp_tissue_'.$created_sample_counter,
        	                    "sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
        	                    "initial_specimen_sample_type" => 'tissue',
        	                    "collection_id" => $collection_id),
        	                'specimen_details' => array(),
        	                $atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
        	                    'tissue_source' => $tissue_source,
                                'cusm_tissue_nature' => $cusm_tissue_nature_to_record));
        	            $created_tissue_sample_master_ids[$cusm_tissue_nature] = customInsertRecord($sample_data);
    	            }
    	            $sample_master_id = $created_tissue_sample_master_ids[$cusm_tissue_nature];
    	            // Tissue tube
    	            $created_aliquot_counter++;
    	            $aliquot_data = array(
    	                'aliquot_masters' => array(
    	                    "barcode" => 'barcode_'.$created_aliquot_counter,
    	                    'aliquot_label' => 'label_'.$created_aliquot_counter,
    	                    "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-tube']['id'],
    	                    "collection_id" => $collection_id,
    	                    "sample_master_id" => $sample_master_id,
    	                    'storage_master_id' => $storage_master_id,
    	                    'storage_coord_x' => $storage_coord_x,
    	                    'storage_coord_y' => $storage_coord_y,
    	                    'in_stock' => 'yes - available',
    	                    'in_stock_detail' => ''),
    	                $atim_controls['aliquot_controls']['tissue-tube']['detail_tablename'] => array());
    	            customInsertRecord($aliquot_data);
    	        }
    	        //Blood aliquots creation
    	        $created_blood_sample_master_ids = array();
    	        foreach(array_merge($blood_aliquots, $blood_2_aliquots) as $new_blood_aliquots) {
    	            //WARNING :: positions x and y permuted
    	            list($cusm_derivative_sample_type, $storage_master_id, $storage_coord_y, $storage_coord_x) = $new_blood_aliquots;
    	            $blood_type = ($cusm_derivative_sample_type == 'serum')? 'serum' : 'edta';
    	            if(!array_key_exists($blood_type.'_key', $created_blood_sample_master_ids)) {
    	                $created_sample_counter++;
        	            $sample_data = array(
    	                    'sample_masters' => array(
    	                        "sample_code" => 'tmp_blood_'.$created_sample_counter,
    	                        "sample_control_id" => $atim_controls['sample_controls']['blood']['id'],
    	                        "initial_specimen_sample_type" => 'blood',
    	                        "collection_id" => $collection_id),
    	                    'specimen_details' => array(),
    	                    $atim_controls['sample_controls']['blood']['detail_tablename'] => array(
    	                        'blood_type' => $blood_type));
    	                $created_blood_sample_master_ids[$blood_type.'_key'] = customInsertRecord($sample_data);
    	            }
    	            $parent_sample_master_id = $created_blood_sample_master_ids[$blood_type.'_key'];
    	            if(!array_key_exists($cusm_derivative_sample_type, $created_blood_sample_master_ids)) {
    	                $created_sample_counter++;
        	            $sample_data = array(
    	                    'sample_masters' => array(
    	                        "sample_code" => 'tmp_blood_'.$created_sample_counter,
    	                        "sample_control_id" => $atim_controls['sample_controls'][$cusm_derivative_sample_type]['id'],
    	                        "initial_specimen_sample_type" => 'blood',
    	                        "initial_specimen_sample_id" => $parent_sample_master_id,
    	                        "parent_sample_type" => 'blood',
    	                        "parent_id" => $parent_sample_master_id,
    	                        "collection_id" => $collection_id),
    	                    'specimen_details' => array(),
    	                    $atim_controls['sample_controls'][$cusm_derivative_sample_type]['detail_tablename'] => array());
    	                $created_blood_sample_master_ids[$cusm_derivative_sample_type] = customInsertRecord($sample_data);
    	            }	
    	            $sample_master_id = $created_blood_sample_master_ids[$cusm_derivative_sample_type];
    	            // Derivative tube
    	            $created_aliquot_counter++;
    	            $aliquot_data = array(
    	                'aliquot_masters' => array(
    	                    "barcode" => 'barcode_'.$created_aliquot_counter,
    	                    'aliquot_label' => 'label_'.$created_aliquot_counter,
    	                    "aliquot_control_id" => $atim_controls['aliquot_controls'][$cusm_derivative_sample_type.'-tube']['id'],
    	                    "collection_id" => $collection_id,
    	                    "sample_master_id" => $sample_master_id,
    	                    'storage_master_id' => $storage_master_id,
    	                    'storage_coord_x' => $storage_coord_x,
    	                    'storage_coord_y' => $storage_coord_y,
    	                    'in_stock' => 'yes - available',
    	                    'in_stock_detail' => ''),
    	                $atim_controls['aliquot_controls'][$cusm_derivative_sample_type.'-tube']['detail_tablename'] => array());
    	            customInsertRecord($aliquot_data);
    	        }
    	    } 
    	}
	} else {
        recordErrorAndMessage('Participant', '@@ERROR@@', "PatientId Not Defined - No participant data will be migrated.", "See line : $line_number.");
	}
}  //End new line

recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Participants : '.$created_participant_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Obtained Consents : '.$created_consent_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Collections : '.$created_collection_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Samples : '.$created_sample_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Aliquots : '.$created_aliquot_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Storages : '.$created_storage_counter);

$last_queries_to_execute = array(
	"UPDATE participants SET participant_identifier = id WHERE participant_identifier = '' OR participant_identifier IS NULL;",
	"UPDATE sample_masters SET sample_code=id;",
	"UPDATE sample_masters SET initial_specimen_sample_id=id WHERE parent_id IS NULL;",
//	"UPDATE aliquot_masters SET barcode=id;",
	"UPDATE storage_masters SET code=id;",
	"UPDATE versions SET permissions_regenerated = 0;"
);
foreach($last_queries_to_execute as $query)	customQuery($query);

recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Next Lung Bank Patient Id", "Will be ".($last_lung_bank_key_value_used+1).".");
customQuery("UPDATE key_increments SET key_value = '$last_lung_bank_key_value_used' WHERE key_name = 'lung bank participant number';");

insertIntoRevsBasedOnModifiedValues();

//*** SUMMARY DISPLAY ***

global $import_summary;

$creation_update_summary = array();
foreach(array('Data Update Summary', 'Data Creation Summary') as $new_section) {
	if(isset($import_summary[$new_section])) {
		$creation_update_summary[$new_section] = $import_summary[$new_section];
		unset($import_summary[$new_section]);
	}
}

dislayErrorAndMessage(false, 'Migration Errors/Warnings/Messages');

$import_summary = $creation_update_summary;

dislayErrorAndMessage($commit_all, 'Creation/Update Summary');

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function getDataToUpdate($atim_data, $excel_data) {
	$data_to_update = array();
	foreach($excel_data as $key => $value) {
		if(!array_key_exists($key, $atim_data)) die('ERR_8837282882:'.$key);
		if(strlen($value) && $value != $atim_data[$key]) $data_to_update[$key] = $value;
	}
	return $data_to_update;
}

function addCreatedDataToSummary($creation_type, $detail, $excel_data_references) {
	recordErrorAndMessage('Data Creation Summary', '@@MESSAGE@@', $creation_type, "$detail. See $excel_data_references.");
}

function addUpdatedDataToSummary($update_type, $updated_data, $excel_data_references) {
	if($updated_data) {
		$updates = array();
		foreach($updated_data as $field => $value) $updates[] = "[$field = $value]";
		recordErrorAndMessage('Data Update Summary', '@@MESSAGE@@', $update_type, "Updated field(s) : ".implode(' + ', $updates).". See $excel_data_references.");
	}
}

function getAliquots($excel_data_references, $sample_type, $location, $box_number, $positions, $rack_number = '') {
	global $atim_controls;
	global $atim_storage_key_to_storage_master_id;
	global $created_storage_counter;
	
	// Flush empty cell
	
	if($location == '-') $location = '';
	if($box_number == '-') $box_number = '';
	if($rack_number == '-') $rack_number = '';
	$position_defined = array();
	foreach($positions as $key => $tmp_data) {
	    $tmp_data = str_replace(' ', '', trim($tmp_data));
	    $positions[$key] = trim($tmp_data);
	    if($tmp_data == '-') {
	        $positions[$key] = '';
	    } else {
	        if(strlen($tmp_data)) {
	            $position_defined[] = "'$key' = '$tmp_data'";
	        }
	    }
	}
	
	// Check box is defined
	
	if(!strlen($box_number)) {
    	if($position_defined) {
    	    recordErrorAndMessage('Collection',
    	        '@@ERROR@@',
    	        "No box is defined into the excel field with positions is not empty. No aliquot will be created. Please validate and correct data directly into ATiM if required.",
    	        "See $sample_type positions ".implode(' & ', $position_defined)." for $excel_data_references.");
    	}
    	return array();
    }
	
    // Create/Reuse storage
    
    $storage_unique_key_separator_tmp = '@##@';
    $parent_storage_unique_key = '';
    $parent_storage_master_id = null;
    $parent_storage_selection_label = '';
    
    // -- > Freezer & Nitrogen Locator
    $location = trim($location);
    if(strlen($location)) {
        $location = str_replace('Borque Freezer', 'Borque', $location);
        $storage_controls = $atim_controls['storage_controls'][(($sample_type == 'tissue')? 'nitrogen locator': 'freezer')];
        $parent_storage_unique_key = $storage_unique_key = "((".$storage_controls['id']."))".$location.$storage_unique_key_separator_tmp;
        if(!array_key_exists($storage_unique_key, $atim_storage_key_to_storage_master_id)) {
            if(strlen($location) > 10) die('ERR storage short label size : '.$location);
            $storage_data = array(
                'storage_masters' => array(
                    "code" => 'tmp'.$created_storage_counter,
                    "short_label" => $location,
                    "selection_label" => $location,
                    "storage_control_id" => $storage_controls['id'],
                    "parent_id" => null),
                $storage_controls['detail_tablename'] => array());
            $atim_storage_key_to_storage_master_id[$storage_unique_key] = array(customInsertRecord($storage_data), $location);
            $created_storage_counter++;
        }
        list($parent_storage_master_id, $parent_storage_selection_label) = $atim_storage_key_to_storage_master_id[$storage_unique_key];
    }
    // --> Rack
    $rack_number = trim($rack_number);
    if(strlen($rack_number)) {
        $storage_controls = $atim_controls['storage_controls'][(($sample_type == 'tissue')? 'rack9': 'rack16')];
        $parent_storage_unique_key = $storage_unique_key = $parent_storage_unique_key."((".$storage_controls['id']."))".$rack_number.$storage_unique_key_separator_tmp;
        if(!array_key_exists($storage_unique_key, $atim_storage_key_to_storage_master_id)) {
            if(strlen($rack_number) > 10) die('ERR storage short label size : '.$rack_number);
            $storage_data = array(
                'storage_masters' => array(
                    "code" => 'tmp'.$created_storage_counter,
                    "short_label" => $rack_number,
                    "selection_label" => $parent_storage_selection_label.'-'.$rack_number,
                    "storage_control_id" => $storage_controls['id'],
                    "parent_id" => $parent_storage_master_id),
                $storage_controls['detail_tablename'] => array());
            $atim_storage_key_to_storage_master_id[$storage_unique_key] = array(customInsertRecord($storage_data), $parent_storage_selection_label.'-'.$rack_number);
            $created_storage_counter++;
        }
        list($parent_storage_master_id, $parent_storage_selection_label) = $atim_storage_key_to_storage_master_id[$storage_unique_key];
    }
    // --> Box
    $box_number = trim(str_replace(' ', '', $box_number));
    if(!preg_match('/^[0-9]+(,[0-9]+){0,1}$/', $box_number)) {
        recordErrorAndMessage('Collection',
            '@@WARNING@@',
            "Box# value does not match the expected format. Please validate data after migration.",
            "See Box# '$box_number' for $excel_data_references.");
    }
    $created_box_storage_masters_ids = array();
    foreach(explode(',', $box_number) as $new_box_number) {
        $storage_controls = $atim_controls['storage_controls']['box81 1A-9I'];
        $storage_unique_key = $parent_storage_unique_key."((".$storage_controls['id']."))".$new_box_number.$storage_unique_key_separator_tmp;
        if(!array_key_exists($storage_unique_key, $atim_storage_key_to_storage_master_id)) {
            if(strlen($new_box_number) > 10) die('ERR storage short label size : '.$new_box_number);
            $storage_data = array(
                'storage_masters' => array(
                    "code" => 'tmp'.$created_storage_counter,
                    "short_label" => $new_box_number,
                    "selection_label" => $parent_storage_selection_label.'-'.$new_box_number,
                    "storage_control_id" => $storage_controls['id'],
                    "parent_id" => $parent_storage_master_id),
                $storage_controls['detail_tablename'] => array());
            $atim_storage_key_to_storage_master_id[$storage_unique_key] = array(customInsertRecord($storage_data), $parent_storage_selection_label.'-'.$new_box_number);
            $created_storage_counter++;
        }
        list($box_storage_master_id, $box_selection_label) = $atim_storage_key_to_storage_master_id[$storage_unique_key];
        $created_box_storage_masters_ids[] = array('box_storage_master_id' => $box_storage_master_id, 'selection_label' => $box_selection_label, 'aliquots' => array());
    }

    // Get aliquots positions

    $aliquots_positions = array();
    $aliquots_positions_key = 0;
    $is_first_sample_type = true;
    foreach($positions as $sample_type => $aliquots_positions_sets) {
        $increment_boxes_content_key = (!$is_first_sample_type && preg_match('/^A1/', $aliquots_positions_sets))? true : false;     // Ceck case when 2 sample types are into 2 differnet  boxes ([serum] => I4-I9 // [plasma] => A1-A6)
        foreach(explode(',', $aliquots_positions_sets) as $new_aliquots_postions_set) {
            if($increment_boxes_content_key) $aliquots_positions_key +=1;
            if(strlen($new_aliquots_postions_set)) {
                $aliquots_positions[$aliquots_positions_key][$sample_type] = $new_aliquots_postions_set;
            }
            $increment_boxes_content_key = true;
        }
        $is_first_sample_type = false;
    }
    // Create results (aliquots storage information)
    
    if(!$aliquots_positions) {
        recordErrorAndMessage('Collection',
            '@@ERROR@@',
            "A box is defined into the excel file but no position has been extracted from the excel file. No aliquot will be created. Please validate and correct data directly into ATiM if required.",
            "See box(es) '$box_number' ".($position_defined? "and defined positions '".implode("' & '", $position_defined) : '')." for $excel_data_references.");
        return array();
    } else if(!(sizeof($created_box_storage_masters_ids) == sizeof($aliquots_positions) && array_keys($aliquots_positions) == array_keys($created_box_storage_masters_ids))) {
       recordErrorAndMessage('Collection',
           '@@ERROR@@',
           "The number of boxes defined from the box(es) label(s) defintion does not match the number of boexs defined from the aliquots positions. Be sure than character ',' as not be used to separate positions of 2 aliquots of the same box (use '.' instead'). No aliquot will be created. Please validate and correct data directly into ATiM if required.",
           "See box(es) '$box_number' ".($position_defined? "and defined positions '".implode("' & '", $position_defined) : '')." for $excel_data_references.");
        return array();
    } else {
        foreach($aliquots_positions as $box_key => $aliquots_data) {
            $created_box_storage_masters_ids[$box_key]['aliquots'] = $aliquots_data;
        }
        $final_aliquots_storage_information = array();
        foreach($created_box_storage_masters_ids as $new_box) {
            $storage_master_id = $new_box['box_storage_master_id'];
            $storageselection_label = $new_box['selection_label'];
            foreach($new_box['aliquots'] as $sample_type => $all_box_sample_aliquots_positions) {
                // Expected positions formate /A1.A3.E3.E7-E9/
                foreach(explode('.', $all_box_sample_aliquots_positions) as $aliquot_positions) {
                    if(preg_match('/^([A-I])([1-9])$/', $aliquot_positions, $matches)) {
                        $final_aliquots_storage_information[] = array($sample_type, $storage_master_id, $matches[0], $matches[1]);
                    } else if(preg_match('/^([A-I])([1-9])\-([A-I])([1-9])$/', $aliquot_positions, $matches)) {
                        $from_x = $matches[1];
                        $from_y = $matches[2];
                        $to_x = $matches[3];
                        $to_y = $matches[4];
                        if(($from_x.$from_y) >= ($to_x.$to_y)) {
                            recordErrorAndMessage('Collection',
                                '@@ERROR@@',
                                "Wrong aliquots positions definition (1). The aliquots matching these postions won't be migrated. Please validate and correct data directly into ATiM if required.",
                                "See positions value '$aliquot_positions' in the box(es) '$box_number' for $excel_data_references.");
                        } else {
                            $x = $from_x;
                            $y = $from_y;
                            $last_aliquot_position_found = false;
                            while(!$last_aliquot_position_found) {
                                if(!preg_match('/^([A-I])([1-9])$/', ($x.$y))) die('ERR2234234'); // Should never happens
                                $final_aliquots_storage_information[] = array($sample_type, $storage_master_id, $x, $y);
                                if($y >= 9) {
                                    $next_x = ord($x)+1;
                                    $x = chr($next_x);
                                    $y = 1;
                                } else {
                                    $y++;
                                }
                                if(($x.$y) == ($matches[3].$matches[4])) {
                                    //Add the last aliquot position
                                    $last_aliquot_position_found = true;
                                    if(!preg_match('/^([A-I])([1-9])$/', ($x.$y))) die('ERR2234234'); // Should never happens
                                    $final_aliquots_storage_information[] = array($sample_type, $storage_master_id, $x, $y);
                                }
                            }
                        }
                    } else {
                        recordErrorAndMessage('Collection',
                            '@@ERROR@@',
                            "Wrong aliquots positions definition (2). The aliquots matching these postions won't be migrated. Please validate and correct data directly into ATiM if required.",
                            "See positions value '$aliquot_positions' in the box(es) '$box_number' for $excel_data_references.");
                    }
                }
            }            
        }
        return $final_aliquots_storage_information;
    }
}
	
?>
		