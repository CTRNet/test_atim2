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
    $queries[] = "TRUNCATE sd_der_buffy_coats;";
    
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
    
    
    
    foreach($queries as $new_truncate_query) {
        customQuery($new_truncate_query);
    } 
    mysqli_commit($db_connection);pr('done');exit;
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

$sop_master_id = customInsertRecord(array(
    'sop_masters' => array('code' => 'Inventory/Inventaire', 'version' => '2016-08-20', 'sop_control_id' => '1', 'status' => 'activated'),
    'sopd_general_alls' => array()));

global $atim_storage_key_to_storage_master_id;
$atim_storage_key_to_storage_master_id = array();

$cusm_mrn_to_participant_id = array();
$cusm_bank_nbr_check = array();

$created_participant_counter = 0;
$created_consent_counter = 0;
$created_collection_counter = 0;
$created_sample_counter = 0;
$created_aliquot_counter = 0;
global $created_storage_counter;
$created_storage_counter = 0;

$worksheet_name = 'DATABASE';
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2,  $windows_xls_offset)) {   
    
	$bank_patient_id = str_replace(' ', '', $excel_line_data['Patient ID']);   // JS-17-0000
	$bank_patient_mrn = $excel_line_data['Patient Information MRN'];
	if(!$bank_patient_id) {
        recordErrorAndMessage('Participant', '@@ERROR@@', "PatientId Not Defined - No participant data of the line will be migrated.", "See line : $line_number.");
	} elseif(!$bank_patient_mrn) {
        recordErrorAndMessage('Participant', '@@ERROR@@', "Patient MRN Not Defined - No participant data of the line will be migrated.", "See Patient ID $bank_patient_id line : $line_number.");
	} else {
	    $excel_data_references = "Participant '<b>$bank_patient_id</b>' Line '<b>$line_number</b>'";
	    	    
	    // Check bank number format
	    if(!preg_match('/^[A-Z]+\-[0-9]{2}\-[0-9]{4}$/', $bank_patient_id, $matches)) {
	        recordErrorAndMessage('Participant',
	            '@@ERROR@@',
	            "Wrong bank number format. Participant will be created with this bank number but please confirm and complete data into ATiM if required.",
	            "See value '$bank_patient_id' for $excel_data_references.");
	    }
	        	
    	if(!isset($cusm_mrn_to_participant_id[$bank_patient_mrn])) {
        	
    	   // Create participant
    	   //-------------------------------------------------------------------------------------------
    	   
        	$excel_participant_data = array(
        	    'first_name' => $excel_line_data['Patient Information First_Name'],
        	    'last_name' => $excel_line_data['Patient Information Last_Name'],
        	    'last_modification' => $import_date);    	
        	
        	$participant_id = customInsertRecord(array('participants' => $excel_participant_data));
        	addCreatedDataToSummary('New Participant', "Participant '".$excel_line_data['Patient Information First_Name']." ".$excel_line_data['Patient Information Last_Name']."'.", $excel_data_references);
        	$created_participant_counter++;
        	$misc_identifier_data = array(
    	        'identifier_value' => $bank_patient_mrn,
    	        'participant_id' => $participant_id,
    	        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['MGH-MRN']['id'],
    	        'flag_unique' => $atim_controls['misc_identifier_controls']['MGH-MRN']['flag_unique']
    	    );
    	    customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
    	    $cusm_mrn_to_participant_id[$bank_patient_mrn] = array(
    	        'participant_id' => $participant_id,
        	    'first_name' => $excel_line_data['Patient Information First_Name'],
        	    'last_name' => $excel_line_data['Patient Information Last_Name'],
    	        'js_nbrs' => array($bank_patient_id => $bank_patient_id)
    	    );
    	} else {
    	    if($cusm_mrn_to_participant_id[$bank_patient_mrn]['first_name']  != $excel_line_data['Patient Information First_Name']) {
    	        recordErrorAndMessage('Participant',
    	            '@@ERROR@@',
    	            "Participant identified by the same MRN is defined into excel file by 2 different first names.",
    	            "See values '".$cusm_mrn_to_participant_id[$bank_patient_mrn]['first_name']."' & '".$excel_line_data['Patient Information First_Name']."' for $excel_data_references.");
    	    }
    	    if($cusm_mrn_to_participant_id[$bank_patient_mrn]['last_name']  != $excel_line_data['Patient Information Last_Name']) {
    	        recordErrorAndMessage('Participant',
    	            '@@ERROR@@',
    	            "Participant identified by the same MRN is defined into excel file by 2 different last names.",
    	            "See values '".$cusm_mrn_to_participant_id[$bank_patient_mrn]['last_name']."' & '".$excel_line_data['Patient Information Last_Name']."' for $excel_data_references.");
    	    }
    	    $cusm_mrn_to_participant_id[$bank_patient_mrn]['js_nbrs'][$bank_patient_id] = $bank_patient_id;
    	    recordErrorAndMessage('Consent',
    	        '@@WARNING@@',
    	        "Participant identified more than once into file. Probably more than one consent has been created into ATiM. Please clean up data into ATim after migration",
    	        "See patient '".implode("' - '", $cusm_mrn_to_participant_id[$bank_patient_mrn]['js_nbrs'])."' for $excel_data_references.");
    	}
    	$participant_id = $cusm_mrn_to_participant_id[$bank_patient_mrn]['participant_id'];
    	
    	if(isset($cusm_bank_nbr_check[$bank_patient_id])) {
    	    if($cusm_bank_nbr_check[$bank_patient_id]['participant_id'] != $participant_id) {
    	        recordErrorAndMessage('Participant',
        	        '@@ERROR@@',
        	        "A JS number is linked to 2 different participants (with same MRN number). 2 participants will be created. Please validate and correct data after migration.",
        	        "See $bank_patient_id and their MRN for $excel_data_references.");
        	}
    	} else {
    	    $cusm_bank_nbr_check[$bank_patient_id] = array(
    	        'participant_id' => $participant_id,
    	        'collections' => array()
    	    );
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
    	        str_replace(array("Spicer", "Ioana", "Dong", "Aya", "Julie", "Emma", 'Nick'), array("Jonathan Spicer", "Ioana Nicolau", "Dong", "Aya Siblini", "Julie Breau", "Emma Lee", 'Nick Berthos'), $excel_line_data[$excel_field]), 
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
    	            'consent_signed_date_accuracy' => $consent_date_accuracy,
                    'form_version' => ''),
    	        $atim_controls['consent_controls']['lung bank consent']['detail_tablename'] => array());
            $consent_master_id = customInsertRecord($consent_data);   
            $created_consent_counter++;
    	} else if(preg_match('/^[Nn]/', $excel_line_data['Consent Consented (Y/N)'])){
    	    if(strlen(trim($excel_line_data['Consent Consented (Y/N)'])) != 1) {
    	        recordErrorAndMessage('Consent', 
    	            '@@WARNING@@', 
    	            "Created 'Denied' consent but the 'Consented' value is different than 'N'. Please confirm and check no additional information has to be recorded.", 
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
    	        str_replace(array("Spicer", "Ioana", "Dong", "Aya", "Julie", "Emma", 'Nick'), array("Jonathan Spicer", "Ioana Nicolau", "Dong", "Aya Siblini", "Julie Breau", "Emma Lee", 'Nick Berthos'), $excel_line_data[$excel_field]), 
    	        'cusm_lung_bank_staff', 
    	        'Consent', 
    	        "See field '$excel_field'.", 
    	        "The consenter value won't be migrated for $excel_data_references");

    	    $consent_data = array(
    	        'consent_masters' => array(
    	            "participant_id" => $participant_id,
    	            "consent_control_id" =>  $atim_controls['consent_controls']['lung bank consent']['id'],
    	            "consent_status" => 'denied',
    	            "consent_person" => $consent_person,
    	            'consent_signed_date' => $consent_date,
    	            'consent_signed_date_accuracy' => $consent_date_accuracy),
    	        $atim_controls['consent_controls']['lung bank consent']['detail_tablename'] => array());
            customInsertRecord($consent_data);   
            $created_consent_counter++;
    	} else {
            recordErrorAndMessage('Consent', 
	            '@@MESSAGE@@', 
	            "Consent is not defined as either 'obtained' or 'denied'. No consent will be created into ATiM. Please confirm.", 
	            strlen($excel_line_data['Consent Consented (Y/N)'])? "See value '".$excel_line_data['Consent Consented (Y/N)']."' for $excel_data_references." : "See $excel_data_references.");
    	}
    	
    	// Unused data
    	//-------------------------------------------------------------------------------------------
    	   
    	if(strlen($excel_line_data['D_OPB'])) {
    	    recordErrorAndMessage('Consent',
    	        '@@WARNING@@',
    	        "'D_OPB' field is not empty but the data of this field is not a data migrated into ATiM. Please check no data has to be completed into ATiM.",
    	        "See value '".$excel_line_data['D_OPB']."' for $excel_data_references.");
    	    
    	}

    	// Create inventory
    	//-------------------------------------------------------------------------------------------
    	
    	// Warning on stool data not imported
    	for($tmpId = 1; $tmpId < 4; $tmpId++) {
    	    if(strlen($excel_line_data["Stool $tmpId Date"].$excel_line_data["Stool $tmpId Aliquots"].$excel_line_data["Stool $tmpId Location"])) {
    	        $stoolData = 'Date: ['.$excel_line_data["Stool $tmpId Date"].'], Aliquots: ['.$excel_line_data["Stool $tmpId Aliquots"].'] and location: ['.$excel_line_data["Stool $tmpId Location"].']';
    	        recordErrorAndMessage('Collection',
    	            '@@WARNING@@',
    	            "Stool data won't be imported by the script. Please complete data into ATiM after migration if required.",
    	            "See stool data (#$tmpId) : $stoolData. See $excel_data_references.");
    	    }
    	}
    	
    	$excel_line_data['D_OP'] = str_replace(array('Not scheduled yet', 'Cancelled'), array('', ''), $excel_line_data['D_OP']);
    	$excel_field = 'D_OP';
    	list($collection_date, $collection_date_accuracy) = validateAndGetDateAndAccuracy(
    	    $excel_line_data[$excel_field],
    	    'Inventory',
    	    "See field '$excel_field'.",
    	    "See $excel_data_references");
    	
	    // Check collection has to be created
	    
	    $inventory_data_found = false;
	    $inventory_fields = array(
	        'TISSUE Location', 'TISSUE Rack #', 'TISSUE Box #', 'TISSUE Normal', 'TISSUE Tumor', 'TISSUE Lymph Nodes', 'TISSUE Notes', 'Pathology Acession #',
            'Pre-Surgery Location', 
	        'Pre-Surgery Box #1', 'Pre-Surgery Serum1', 'Pre-Surgery Plasma1', 'Pre-Surgery WBC1',
	        'Pre-Surgery Box #2', 'Pre-Surgery Serum2', 'Pre-Surgery Plasma2', 'Pre-Surgery WBC2', 'Pre-Surgery Notes',
            'Baseline blood Date of collection', 'Baseline blood Location', 'Baseline blood Box#', 'Baseline blood Serum', 'Baseline blood Plasma', 'Baseline blood WBC',
	        'POST SURGERY BLOOD Location1','POST SURGERY BLOOD Box#1','POST SURGERY BLOOD Serum1','POST SURGERY BLOOD Plasma1','POST SURGERY BLOOD Date1',
	        'POST SURGERY BLOOD Location2','POST SURGERY BLOOD Box#2','POST SURGERY BLOOD Serum2','POST SURGERY BLOOD Plasma2','POST SURGERY BLOOD Date2',
	        'POST SURGERY BLOOD Location3','POST SURGERY BLOOD Box#3','POST SURGERY BLOOD Serum3','POST SURGERY BLOOD Plasma3','POST SURGERY BLOOD Date3'	        
	    );
        
	    foreach($inventory_fields as $new_excel_fields) {
	        if($excel_line_data[$new_excel_fields] == '-') {
	            $excel_line_data[$new_excel_fields] = '';
	        }
	        if(strlen($excel_line_data[$new_excel_fields])) {
	            $inventory_data_found = true;
	        }    	        
	    }
	   
	   if(!$inventory_data_found) { 
	       if(!$consent_master_id) {
    	       recordErrorAndMessage('Consent',
    	           '@@WARNING@@',
    	           "Participant did not consent and no collection exists. Collection won't be created into ATiM but participant will. Please check no data has to be corrected into ATiM and complete data after migration if required.",
    	           "See $excel_data_references.");
	       } else {
	           recordErrorAndMessage('Consent',
	               '@@MESSAGE@@',
	               "Particicipant consented but no collection has been created into ATiM based on excel data. Please check no data has to be recorded into ATiM and complete data after migration if required.",
	               "See $excel_data_references.");
	       }
	       
	   } else {
	       if(!$consent_master_id) {
               recordErrorAndMessage('Consent',
                   '@@ERROR@@',
                   "Participant did not consent but collection data exists and collection will be created. Please check no data has to be corrected into ATiM and complete data after migration if required.",
                   "See $excel_data_references.");
           }
           
	       $created_aliquots = false;
	       
    	    // Load tissue aliquots
	       $ln_collection_notes = '';
	       if($excel_line_data['TISSUE Lymph Nodes'] == 'No') {
	           $excel_line_data['TISSUE Lymph Nodes'] = '';
	           $ln_collection_notes = 'No lymph nodes. ';
	       }
	       $tissue_aliquots = getAliquots(
    	        $excel_data_references,
    	        'tissue', 
    	        $excel_line_data['TISSUE Location'], 
    	        $excel_line_data['TISSUE Box #'], 
                array('normal' => $excel_line_data['TISSUE Normal'], 'tumor' => $excel_line_data['TISSUE Tumor'], 'lymph nodes' => $excel_line_data['TISSUE Lymph Nodes']), 
    	        $excel_line_data['TISSUE Rack #']);
    	    if($tissue_aliquots || strlen($excel_line_data['Pathology Acession #']) || strlen($excel_line_data['TISSUE Notes']) || $ln_collection_notes) {
    	        $collection_data = array(
    	            'collection_property' => 'participant collection',
    	            'participant_id' => $participant_id,
    	            'bank_id' => $data_bank_id,
    	            'acquisition_label' => $bank_patient_id,
    	            'cusm_collection_pathology_nbr' => $excel_line_data['Pathology Acession #'],
    	            'collection_datetime' => $collection_date,
    	            'collection_datetime_accuracy' => str_replace('c', 'h', $collection_date_accuracy),
    	            'consent_master_id' => $consent_master_id,
    	            'sop_master_id' => $sop_master_id,
    	            'cusm_collection_type' => 'surgery',
    	            'collection_site' => "montreal general hospital",
    	            'collection_notes' => $ln_collection_notes . $excel_line_data['TISSUE Notes']
    	        );
    	        $collection_id = customInsertRecord(array('collections' => $collection_data));
    	        addCollectionTypeToJsNbr($cusm_bank_nbr_check[$bank_patient_id], 'surgery', $excel_data_references);
    	        $collection_date_label = getCollectionDateForLabel($collection_date);
    	        $created_collection_counter++;
    	        if(!$tissue_aliquots) {
    	            recordErrorAndMessage('Collection',
    	                '@@WARNING@@',
    	                "Created an empty tissue collection to track either the pathology number or a note. No sample has been created. Please cleanup and complete data after migration if required.",
    	                "See tissue collection for $excel_data_references.");
    	        } else {
        	        $created_tissue_sample_master_ids = array();
        	        $tube_label_counter = array(
        	            'T' => 0,
        	            'N' => 0,
        	            'LN' => 0
        	        );
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
        	            $tube_label = ($cusm_tissue_nature == 'lymph nodes') ? 'LN' : strtoupper($cusm_tissue_nature[0]);
        	            $tube_label_counter[$tube_label]++;
        	            $aliquot_data = array(
        	                'aliquot_masters' => array(
        	                    "barcode" => 'barcode_'.$created_aliquot_counter,
        	                    'aliquot_label' => "$bank_patient_id OCT $tube_label $collection_date_label ".$tube_label_counter[$tube_label],
        	                    "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-tube']['id'],
        	                    "collection_id" => $collection_id,
        	                    "sample_master_id" => $sample_master_id,
        	                    'storage_master_id' => $storage_master_id,
        	                    'storage_coord_x' => $storage_coord_x,
        	                    'storage_coord_y' => $storage_coord_y,
        	                    'in_stock' => 'yes - available',
        	                    'in_stock_detail' => ''),
        	                $atim_controls['aliquot_controls']['tissue-tube']['detail_tablename'] => array(
        	                    'cusm_storage_solution' => 'OCT'
        	                ));
        	            customInsertRecord($aliquot_data);
                        $created_aliquots = true;
        	        }
        	    }
    	    }
                    
            // Load pre surgery blood aliquots
            $all_blood = array();
            $blood_aliquots = getAliquots(
                $excel_data_references, 
                'blood', 
                $excel_line_data['Pre-Surgery Location'],
                $excel_line_data['Pre-Surgery Box #1'], 
                array(
                    'serum' => $excel_line_data['Pre-Surgery Serum1'],
                    'plasma' => $excel_line_data['Pre-Surgery Plasma1'],
                    'buffy coat' => $excel_line_data['Pre-Surgery WBC1']
                )
            );
    	    $blood_2_aliquots = getAliquots(
    	        $excel_data_references,
    	        'blood',
    	        $excel_line_data['Pre-Surgery Location'],
    	        $excel_line_data['Pre-Surgery Box #2'],
    	        array(
    	            'serum' => $excel_line_data['Pre-Surgery Serum2'], 
    	            'plasma' => $excel_line_data['Pre-Surgery Plasma2'], 
    	            'buffy coat' => $excel_line_data['Pre-Surgery WBC2']
    	        )
	        );
    	    
    	    if($blood_aliquots || $blood_2_aliquots || $excel_line_data['Pre-Surgery Notes']) {
    	        $all_blood[] = array(    	        
    	            'collection_datetime' => $collection_date,
        	        'collection_datetime_accuracy' => str_replace('c', 'h', $collection_date_accuracy),
    	            'cusm_collection_type' => 'pre-surgery',
        	        'collection_notes' => $excel_line_data['Pre-Surgery Notes'],
    	            'aliquots' => array_merge($blood_aliquots, $blood_2_aliquots)   ,
                    'tmp_counter' =>  '' 	            
    	        );
    	        if(empty($blood_aliquots) && empty($blood_2_aliquots)) {
    	            recordErrorAndMessage('Collection',
    	                '@@WARNING@@',
    	                "Created an empty pre-surgery collection to track a notes. No sample has been created. Please cleanup and complete data after migration if required.",
    	                "See pre-surgery collection for $excel_data_references.");
    	        }
    	    }
    	    
    	    // Load other blood    
    	    $arryOtherBlood = array(
        	    array('Baseline blood Date of collection', 'Baseline blood Location', 'Baseline blood Box#', 'Baseline blood Serum', 'Baseline blood Plasma', 'Baseline blood WBC', 'baseline', ''),
        	    array('POST SURGERY BLOOD Date1', 'POST SURGERY BLOOD Location1', 'POST SURGERY BLOOD Box#1', 'POST SURGERY BLOOD Serum1', 'POST SURGERY BLOOD Plasma1', '', 'post-surgery', '1'),
        	    array('POST SURGERY BLOOD Date2', 'POST SURGERY BLOOD Location2', 'POST SURGERY BLOOD Box#2', 'POST SURGERY BLOOD Serum2', 'POST SURGERY BLOOD Plasma2', '', 'post-surgery', '2'),
        	    array('POST SURGERY BLOOD Date3', 'POST SURGERY BLOOD Location3', 'POST SURGERY BLOOD Box#3', 'POST SURGERY BLOOD Serum3', 'POST SURGERY BLOOD Plasma3', '', 'post-surgery', '3'));
            foreach($arryOtherBlood as $tmpFields) {
                list($collection_date, $collection_date_accuracy) = validateAndGetDateAndAccuracy(
                    $excel_line_data[$tmpFields[0]],
                    'Collection',
                    "See field '".$tmpFields[0]."'.",
                    "See $excel_data_references");
                $tmpExcelAliquotsData = array(
                        'serum' => $excel_line_data[$tmpFields[3]],
                        'plasma' => $excel_line_data[$tmpFields[4]],
                        'buffy coat' => empty($tmpFields[5])? null: $excel_line_data[$tmpFields[5]]
                    );
                if(is_null($tmpExcelAliquotsData['buffy coat'])) {
                    unset($tmpExcelAliquotsData['buffy coat']);
                }
                $blood_aliquots = getAliquots(
                    $excel_data_references,
                    'blood',
                    $excel_line_data[$tmpFields[1]],
                    $excel_line_data[$tmpFields[2]],
                    $tmpExcelAliquotsData
                );
                if($blood_aliquots) {
                    $all_blood[] = array(
                        'collection_datetime' => $collection_date,
                        'collection_datetime_accuracy' => str_replace('c', 'h', $collection_date_accuracy),
                        'cusm_collection_type' => $tmpFields[6],
                        'collection_notes' => '',
                        'aliquots' => $blood_aliquots,
                        'tmp_counter' =>  $tmpFields[7]
                    );
                    $dis = true;
                }
            }
    	    foreach($all_blood as $new_blood_collection) {
    	        $collection_data = array(
    	            'collection_property' => 'participant collection',
    	            'participant_id' => $participant_id,
    	            'bank_id' => $data_bank_id,
    	            'acquisition_label' => $bank_patient_id,
    	            'collection_datetime' => $new_blood_collection['collection_datetime'],
    	            'collection_datetime_accuracy' => $new_blood_collection['collection_datetime_accuracy'],
    	            'consent_master_id' => $consent_master_id,
    	            'sop_master_id' => $sop_master_id,
    	            'collection_notes' => $new_blood_collection['collection_notes'],
    	            'collection_site' => "montreal general hospital",
    	            'cusm_collection_type' => $new_blood_collection['cusm_collection_type']
    	        );
    	        $collection_id = customInsertRecord(array('collections' => $collection_data));
    	        addCollectionTypeToJsNbr($cusm_bank_nbr_check[$bank_patient_id], $new_blood_collection['cusm_collection_type'].($new_blood_collection['tmp_counter']? " (".$new_blood_collection['tmp_counter'].")" : ''), $excel_data_references);
    	        $collection_date_label = getCollectionDateForLabel($new_blood_collection['collection_datetime']);
    	        $created_collection_counter++;
    	        $created_blood_sample_master_ids = array();
    	        $tube_label_counter = array(
    	            'BC' => 0,
    	            'S' => 0,
    	            'P' => 0
    	        );
    	        foreach($new_blood_collection['aliquots'] as $new_blood_aliquots) {
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
    	            $tube_label = str_replace(array('buffy coat', 'plasma', 'serum'), array('BC', 'P', 'S'), $cusm_derivative_sample_type);
    	            $tube_label_counter[$tube_label]++;
    	            $aliquot_data = array(
    	                'aliquot_masters' => array(
    	                    "barcode" => 'barcode_'.$created_aliquot_counter,
    	                    'aliquot_label' => "$bank_patient_id $tube_label $collection_date_label ".$tube_label_counter[$tube_label],
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
                    $created_aliquots = true;
    	        }
    	    }
    	    if(!$created_aliquots) {
    	        recordErrorAndMessage('Collection',
    	            '@@WARNING@@',
    	            "No collection created for the participant will gather aliquots. Collection(s) has(ve) probably be created to keep notes or pathology #. Please check no data has to be recorded into ATiM and complete/correct data after migration if required.",
    	            "See ".($collection_date? " collection on $collection_date for " : '')." $excel_data_references.");
    	    }
    	}
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
	"UPDATE aliquot_masters SET barcode=CONCAT('ATiM#',id);",
	"UPDATE storage_masters SET code=id;",
	"UPDATE versions SET permissions_regenerated = 0;"
);
foreach($last_queries_to_execute as $query)	customQuery($query);

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
        if(preg_match('/borque freezer/i', $location)) {
            $location = 'Borque';
        }
        $storage_controls = $atim_controls['storage_controls'][(($sample_type == 'tissue')? 'nitrogen locator': 'freezer')];
        $parent_storage_unique_key = $storage_unique_key = "((".$storage_controls['id']."))".$location.$storage_unique_key_separator_tmp;
        if(!array_key_exists($storage_unique_key, $atim_storage_key_to_storage_master_id)) {
            if(strlen($location) > 10) die('ERR storage short label size : ['.$location.']');
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
           "The number of boxes defined from the box(es) label(s) defintion does not match the number of boxes defined from the aliquots positions. Be sure than character ',' as not be used to separate positions of 2 aliquots of the same box (use '.' instead'). No aliquot will be created. Please validate and correct data directly into ATiM if required.",
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

function getCollectionDateForLabel($collection_datetime) {
    $collection_datetime_label = '?';
    if(preg_match('/^([0-9]{2})([0-9]{2})\-([0-9]{2})\-([0-9]{2})$/', $collection_datetime, $matches)) {
        $collection_datetime_label = $matches[4].'-'.str_replace(
            array('01', '02','03','04','05','06','07','08','09','10','11','12'), 
            array('Jan', 'Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'), $matches[3]).'-'.$matches[2];
    }  
    return $collection_datetime_label;
}

function addCollectionTypeToJsNbr(&$cusm_bank_nbr_check, $collectiontype, $excel_data_references) {
    if(isset($cusm_bank_nbr_check['collections'][$collectiontype])) {
        recordErrorAndMessage('Participant',
            '@@ERROR@@',
            "Participant collection type recorded twice for the same JS number. Please validate and correct data after migration.",
            "See create '$collectiontype' collections for '".implode("' & '", $cusm_bank_nbr_check['collections'][$collectiontype]).".");
    }
    $cusm_bank_nbr_check['collections'][$collectiontype][] = $excel_data_references;
}
	
?>
		