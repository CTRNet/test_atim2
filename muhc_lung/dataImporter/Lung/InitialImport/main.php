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

$tmp_files_names_list = array($excel_file_name, $consent_excel_file_name);

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
    
    $queries[] = "DELETE FROM misc_identifiers;";
    
    $queries[] = "DELETE FROM participants;";
    
    // Revs
    //.................................................................................
    
    foreach($queries as $new_truncate_query) {
        customQuery($new_truncate_query);
    }
    
//  dislayErrorAndMessage(true);
//  exit;
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

// *** PARSE CONSENT EXCEL FILES ***

$worksheet_name = 'Enrolled';
$allConsentsFromConsentFile = array();
$previousExcelLine = array();
while(list($line_number, $excel_line_data) = getNextExcelLineData($consent_excel_file_name, $worksheet_name, 2,  $windows_xls_offset)) {
    // Erase N/A value
    foreach($excel_line_data as &$value) {
        if($value== 'N/A' || $value== 'NA' ) {
            $value = '';
        }
    }
    // Import data when consent status defined
    $consent_status = '';
    if (strtolower($excel_line_data['Consent Consented (Y/N)']) == 'y') {
        $consent_status = 'obtained';
    } else if (strtolower($excel_line_data['Consent Consented (Y/N)']) == 'n') {
        $consent_status = 'denied';
        recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')', '@@WARNING@@', "Patient consent flagged as denied. Please validate and correct/erase data after the migration if required.", "See line : $line_number.");
    } else if(strlen($excel_line_data['Consent Consented (Y/N)'])) {
        recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')', '@@ERROR@@', "Patient consent status is not supported. Data of the (consent file) line including nominal information won't be used by the migration process. Please validate and correct data after the migration if required.", "See valeu '".$excel_line_data['Consent Consented (Y/N)']."' on line : $line_number.");
    } else {
        recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')', '@@ERROR@@', "Patient consent status is not set. Data of the (consent file) line including nominal information won't be used by the migration process. Please validate and correct data after the migration if required.", "See line : $line_number.");
    }
    if(!strlen($consent_status)) {
        $previousExcelLine = $excel_line_data;
    } else {
        // Check patient information of the previous line has to be reapplied
        $excel_line_data['Patient ID'] = str_replace(' ', '', $excel_line_data['Patient ID']);   // JS-17-0000
        if(!$excel_line_data['Patient ID']) {
            if($previousExcelLine) {
                $excelPatientInfoToCopy = array(
                    'Patient ID',
                    'Patient Information MRN',
                    'Patient Information Last_Name',
                    'Patient Information First_Name',
                    'Patient Information RAMQ',
                    'Patient Information DOB');
                $copyField = true;
                foreach($excelPatientInfoToCopy as $tmpField) {
                    if(strlen($excel_line_data[$tmpField])) {
                        $copyField = false;
                    }
                }
                if($copyField) {
                    recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')', 
                        '@@WARNING@@', 
                        "PatientId and patient information are not set on the current line. This information will be replaced by the information of the previous line. Please validate. (Re-used previous line information : ".implode(' & ', $excelPatientInfoToCopy).']', 
                        "See data for participant '".$previousExcelLine['Patient ID']."' on line : $line_number.");
                    foreach($excelPatientInfoToCopy as $excelfield) {
                        $excel_line_data[$excelfield] = $previousExcelLine[$excelfield];
                    }
                }
            } else {
                recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')', '@@ERROR@@', "PatientId not defined and previous data line seams to not exist. No data of the line will be migrated. Please validate.", "See line : $line_number.");
            }
        }
        $previousExcelLine = $excel_line_data;
        // Check patient is defined
        $bank_patient_id = $excel_line_data['Patient ID'];   // JS-17-0000
        $bank_patient_mrn = str_pad($excel_line_data['Patient Information MRN'], 7, "0", STR_PAD_LEFT); 
        if($bank_patient_mrn != $excel_line_data['Patient Information MRN']) {
            recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')', '@@WARNING@@', "MRN nbr size is too small. Added '0' first. Pelase validate.", "Changed '".$excel_line_data['Patient Information MRN']."' to '$bank_patient_mrn' : $line_number.");
            $bank_patient_mrn = '0'.$bank_patient_mrn;
        }
        $excel_line_data['Patient Information MRN'] = $bank_patient_mrn;
        $excel_data_references = "Participant '<b>$bank_patient_id</b>' Line '<b>$line_number</b>'";
        if(!$bank_patient_id) {
            recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')', '@@ERROR@@', "PatientId not set. No consent data and nominal information of the line will be migrated.", "See line : $line_number.");
        } elseif(!$bank_patient_mrn) {
            recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')', '@@ERROR@@', "Patient MRN not set. No consent data and nominal information of the line will be migrated.", "See Patient ID $bank_patient_id on line : $line_number.");
        } else {
            // Record consent data
            $excel_field = "Consent Consenter";
            $consent_person = validateAndGetStructureDomainValue(
                str_replace(
                    array("Spicer", "Ioana", "Dong", "Aya", "Julie", "Emma", 'Nick', 'Emma Lee Lee', 'Dr. Ferri', 'Dr. Cools', 'Sammantha, Emma Lee'), 
                    array("Jonathan Spicer", "Ioana Nicolau", "Dong", "Aya Siblini", "Julie Breau", "Emma Lee", 'Nick Berthos', "Emma Lee", 'Ferri', 'Cools-Lartigue', 'Emma Lee'), $excel_line_data[$excel_field]),
                'custom_laboratory_staff',
                'Consent File ('.$consent_excel_file_name.')',
                "See field '$excel_field'.",
                "The consenter value won't be migrated for $excel_data_references");
            $excel_field = "Consent Date Consented";
            list($consent_date, $consent_date_accuracy) = validateAndGetDateAndAccuracy(
                $excel_line_data[$excel_field],
                'Consent File ('.$consent_excel_file_name.')',
                "See field '$excel_field'.",
                "See $excel_data_references");
            $consent_data = array(
                'consent_masters' => array(
                    "participant_id" => null,
                    "consent_control_id" =>  $atim_controls['consent_controls']['lung bank consent']['id'],
                    "consent_status" => $consent_status,
                    "consent_person" => $consent_person,
                    'consent_signed_date' => $consent_date,
                    'consent_signed_date_accuracy' => $consent_date_accuracy,
                    'form_version' => '',
                    'notes' => $excel_line_data['Comments']),
                $atim_controls['consent_controls']['lung bank consent']['detail_tablename'] => array());
            $quertionArray = array(
                'questionnaires' => 'Consented components QOL',
                'blood_sampling' => 'Consented components Blood_1',
                'tissue_sampling' => 'Consented components Tissue',
                'muscle_biopsy' => 'Consented components Muscle',
                'access_dossier' => 'Consented components Medical file',
                'additional_sampling_followup' => 'Consented components Blood_2',
                'future_specific_research' => 'Consented components Future projects',
                'any_relevant_information' => 'Consented components Relevant Info',
                'stool_sampling' => 'Consented components Stool',
                'pericardial_fat_sampling' => 'Consented components Pericardial Fat');
            foreach($quertionArray as $atim_field => $excel_field) {
                $cst_value = '';
                if (strtolower($excel_line_data[$excel_field]) == 'y') {
                    $cst_value = 'y';
                } else if (strtolower($excel_line_data[$excel_field]) == 'n') {
                    $cst_value = 'n';
                } else if(strlen($excel_line_data[$excel_field])) {
                    recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')', '@@ERROR@@', "Patient consent value for field '$excel_field' is not supported. Value won't be migrated. Please validate and correct data after the migration if required.", "See '".$excel_line_data[$excel_field]."' for $excel_data_references");
                }
                $consent_data[$atim_controls['consent_controls']['lung bank consent']['detail_tablename']][$atim_field] = $cst_value;
            }
            // Record participant data
            $excel_field = 'Patient Information DOB';
            list($date_of_birth, $date_of_birth_accuracy) = validateAndGetDateAndAccuracy(
                $excel_line_data[$excel_field],
                'Consent File ('.$consent_excel_file_name.')',
                "See field '$excel_field'.",
                "See $excel_data_references");
            // Manage record
            if(!isset($allConsentsFromConsentFile[$bank_patient_mrn])) {
                $allConsentsFromConsentFile[$bank_patient_mrn] = array(
                    'first_name' => $excel_line_data['Patient Information First_Name'],
                    'last_name' => $excel_line_data['Patient Information Last_Name'],
                    'ramq' => $excel_line_data['Patient Information RAMQ'],
                    'date_of_birth' => $date_of_birth,
                    'date_of_birth_accuracy' => $date_of_birth_accuracy,
                    'atim_participant_id' => null,
                    'consents' => array(
                        $bank_patient_id => array(
                           $consent_date  => $consent_data
                        )
                    )
                );
            } else {
                if($allConsentsFromConsentFile[$bank_patient_mrn]['first_name'] != $excel_line_data['Patient Information First_Name']) {
                    recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')',
                        '@@ERROR@@',
                        "Participant (identified by the same MRN into consent excel file) is identified by 2 different first names.",
                        "See values '".$allConsentsFromConsentFile[$bank_patient_mrn]['first_name']."' & '".$excel_line_data['Patient Information First_Name']."' for $excel_data_references.");
                }
                if($allConsentsFromConsentFile[$bank_patient_mrn]['last_name'] != $excel_line_data['Patient Information Last_Name']) {
                    recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')',
                        '@@ERROR@@',
                        "Participant (identified by the same MRN into consent excel file) is identified by 2 different last names.",
                        "See values '".$allConsentsFromConsentFile[$bank_patient_mrn]['last_name']."' & '".$excel_line_data['Patient Information Last_Name']."' for $excel_data_references.");
                }
                if($allConsentsFromConsentFile[$bank_patient_mrn]['ramq'] != $excel_line_data['Patient Information RAMQ']) {
                    recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')',
                        '@@ERROR@@',
                        "Participant (identified by the same MRN into consent excel file) is identified by 2 different ramq.",
                        "See values '".$allConsentsFromConsentFile[$bank_patient_mrn]['ramq']."' & '".$excel_line_data['Patient Information RAMQ']."' for $excel_data_references.");
                }
                if($allConsentsFromConsentFile[$bank_patient_mrn]['date_of_birth'] != $date_of_birth) {
                    recordErrorAndMessage('Consent File ('.$consent_excel_file_name.')',
                        '@@ERROR@@',
                        "Participant (identified by the same MRN into consent excel file) is identified by 2 different date of birth.",
                        "See values '".$allConsentsFromConsentFile[$bank_patient_mrn]['date_of_birth']."' & '".$date_of_birth."' for $excel_data_references.");
                }
                if(isset($allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$consent_date])) {
                    //Consent defined twice
                    pr($excel_line_data);
                    pr($allConsentsFromConsentFile[$bank_patient_mrn]);
                    pr("==> $consent_date");
                    die('ERR 7836863');
                } else {
                    $allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$consent_date] = $consent_data;
                }
            }
        }
    }
}

// *** PARSE COLLECTION EXCEL FILES ***

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

$misc_identifier_check = array();

$created_participant_counter = 0;
$created_consent_counter = 0;
$created_collection_counter = 0;
$created_sample_counter = 0;
$created_aliquot_counter = 0;
global $created_storage_counter;
$created_storage_counter = 0;

$worksheet_name = 'DATABASE';
$duplicatedJsNbrCounter = 0;
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2,  $windows_xls_offset)) {   
    
	$bank_patient_id = str_replace(' ', '', $excel_line_data['Patient ID']);   // JS-17-0000
	$bank_patient_mrn = $excel_line_data['Patient Information MRN'];
	if(!$bank_patient_id) {
        recordErrorAndMessage('Participant (file : '.$excel_file_name.')', '@@ERROR@@', "PatientId not defined - No participant data of the line will be migrated.", "See line : $line_number.");
	} elseif(!$bank_patient_mrn) {
        recordErrorAndMessage('Participant (file : '.$excel_file_name.')', '@@ERROR@@', "Patient MRN not defined - No participant data of the line will be migrated.", "See Patient ID $bank_patient_id line : $line_number.");
	} else {
	    $excel_data_references = "Participant '<b>$bank_patient_id</b>' Line '<b>$line_number</b>'";
	    	   
	    $bank_patient_mrn = str_pad($excel_line_data['Patient Information MRN'], 7, "0", STR_PAD_LEFT);
	    if($bank_patient_mrn != $excel_line_data['Patient Information MRN']) {
	        recordErrorAndMessage('Participant (file : '.$excel_file_name.')', '@@WARNING@@', "MRN nbr size is too small. Added '0' first. Pelase validate.", "Changed '".$excel_line_data['Patient Information MRN']."' to '$bank_patient_mrn' : $line_number.");
	        $bank_patient_mrn = '0'.$bank_patient_mrn;
	    }
	    $excel_line_data['Patient Information MRN'] = $bank_patient_mrn;
	    
	    // Check bank number format
	    if(!preg_match('/^[A-Z]+\-[0-9]{2}\-[0-9]{4}$/', $bank_patient_id, $matches)) {
	        recordErrorAndMessage('Participant (file : '.$excel_file_name.')',
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
        	
        	$ramq_to_create = '';
        	if(isset($allConsentsFromConsentFile[$bank_patient_mrn])) {
        	    // Compare participant data to excel consent file data
        	    // Add ramq and date of birth to partiicpant data set
        	    if(($allConsentsFromConsentFile[$bank_patient_mrn]['first_name']  != $excel_line_data['Patient Information First_Name']) ||
        	    ($allConsentsFromConsentFile[$bank_patient_mrn]['last_name']  != $excel_line_data['Patient Information Last_Name'])) {
        	        $cstNames = $allConsentsFromConsentFile[$bank_patient_mrn]['first_name'] . ' -- ' . $allConsentsFromConsentFile[$bank_patient_mrn]['last_name'] ;
        	        $invNames = $excel_line_data['Patient Information First_Name'] . ' -- ' . $excel_line_data['Patient Information Last_Name'];
        	        recordErrorAndMessage('Participant (both files)',
        	            '@@ERROR@@',
        	            "First or last name is different for a participant identified by the same MRN in both collection and consent excel files.",
        	            "See values (consent) '$cstNames' & (inv) '$invNames' for $excel_data_references.");
        	    }
        	    $excel_participant_data['date_of_birth'] = $allConsentsFromConsentFile[$bank_patient_mrn]['date_of_birth'];
        	    $excel_participant_data['date_of_birth_accuracy'] = $allConsentsFromConsentFile[$bank_patient_mrn]['date_of_birth_accuracy'];
        	    $ramq_to_create = $allConsentsFromConsentFile[$bank_patient_mrn]['ramq'];
        	}
        	$participant_id = customInsertRecord(array('participants' => $excel_participant_data));
        	$created_participant_counter++;
        	if(isset($allConsentsFromConsentFile[$bank_patient_mrn])) {
        	    $allConsentsFromConsentFile[$bank_patient_mrn]['atim_participant_id'] = $participant_id;
        	}
        	$misc_identifier_data = array(
    	        'identifier_value' => $bank_patient_mrn,
    	        'participant_id' => $participant_id,
    	        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['MGH-MRN']['id'],
    	        'flag_unique' => $atim_controls['misc_identifier_controls']['MGH-MRN']['flag_unique']
    	    );
    	    customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
        	    $misc_identifier_check[$atim_controls['misc_identifier_controls']['MGH-MRN']['id'].'||'.$bank_patient_mrn] = '1';
    	    if($ramq_to_create) {
        	    $misc_identifier_data = array(
        	        'identifier_value' => $ramq_to_create,
        	        'participant_id' => $participant_id,
        	        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['ramq nbr']['id'],
        	        'flag_unique' => $atim_controls['misc_identifier_controls']['ramq nbr']['flag_unique']
        	    );
        	    customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
        	    $misc_identifier_check[$atim_controls['misc_identifier_controls']['ramq nbr']['id'].'||'.$ramq_to_create] = '1';
    	    }
    	    $cusm_mrn_to_participant_id[$bank_patient_mrn] = array(
    	        'participant_id' => $participant_id,
        	    'first_name' => $excel_line_data['Patient Information First_Name'],
        	    'last_name' => $excel_line_data['Patient Information Last_Name'],
    	        'js_nbrs' => array($bank_patient_id => $bank_patient_id)
    	    );
    	} else {
    	    if($cusm_mrn_to_participant_id[$bank_patient_mrn]['first_name']  != $excel_line_data['Patient Information First_Name']) {
    	        recordErrorAndMessage('Participant (file : '.$excel_file_name.')',
    	            '@@ERROR@@',
    	            "Participant identified by the same MRN is defined into collection excel file by 2 different first names.",
    	            "See values '".$cusm_mrn_to_participant_id[$bank_patient_mrn]['first_name']."' & '".$excel_line_data['Patient Information First_Name']."' for $excel_data_references.");
    	    }
    	    if($cusm_mrn_to_participant_id[$bank_patient_mrn]['last_name']  != $excel_line_data['Patient Information Last_Name']) {
    	        recordErrorAndMessage('Participant (file : '.$excel_file_name.')',
    	            '@@ERROR@@',
    	            "Participant identified by the same MRN is defined into collection  excel file by 2 different last names.",
    	            "See values '".$cusm_mrn_to_participant_id[$bank_patient_mrn]['last_name']."' & '".$excel_line_data['Patient Information Last_Name']."' for $excel_data_references.");
    	    }
    	    $cusm_mrn_to_participant_id[$bank_patient_mrn]['js_nbrs'][$bank_patient_id] = $bank_patient_id;
    	    recordErrorAndMessage('Consent (file : '.$excel_file_name.')',
    	        '@@WARNING@@',
    	        "Participant identified more than once into excel collection file. Probably more than one consent has been created into ATiM. Please clean up data into ATim after migration",
    	        "See patient '".implode("' - '", $cusm_mrn_to_participant_id[$bank_patient_mrn]['js_nbrs'])."' for $excel_data_references.");
    	}
    	$participant_id = $cusm_mrn_to_participant_id[$bank_patient_mrn]['participant_id'];
    	
    	// Manage Bank Participant Identifier
    	//-------------------------------------------------------------------------------------------
    	
    	$bank_patient_misc_identifier_id = null;
    	if(isset($cusm_bank_nbr_check[$bank_patient_id])) {
    	    if(!isset($cusm_bank_nbr_check[$bank_patient_id][$participant_id])) {
                $duplicatedJsNbrCounter++;
    	        recordErrorAndMessage('Participant (file : '.$excel_file_name.')',
        	        '@@ERROR@@',
        	        "A JS number is linked to 2 different participants (with different MRN number) into the excel collection file. 2 participants will be created with same JS nbr but ATiM does not support this. Please validate and correct data after migration.",
        	        "See participants linked to $bank_patient_id.");
        	   $misc_identifier_data = array(
        	       'identifier_value' => "$bank_patient_id ($duplicatedJsNbrCounter)",
        	       'participant_id' => $participant_id,
        	       'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['lung bank participant number']['id'],
        	       'flag_unique' => $atim_controls['misc_identifier_controls']['lung bank participant number']['flag_unique']
        	   );
        	   $bank_patient_misc_identifier_id = customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
        	   $misc_identifier_check[$atim_controls['misc_identifier_controls']['lung bank participant number']['id'].'||'."$bank_patient_id ($duplicatedJsNbrCounter)"] = '1';
        	   $cusm_bank_nbr_check[$bank_patient_id][$participant_id] = array(
        	       'participant_id' => $participant_id,
        	       'bank_patient_misc_identifier_id' => $bank_patient_misc_identifier_id,
        	       'collections' => array()
        	   );
    	    } else {
        	    $bank_patient_misc_identifier_id = $cusm_bank_nbr_check[$bank_patient_id][$participant_id]['bank_patient_misc_identifier_id'];
        	}
    	} else {
    	    $misc_identifier_data = array(
    	        'identifier_value' => $bank_patient_id,
    	        'participant_id' => $participant_id,
    	        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['lung bank participant number']['id'],
    	        'flag_unique' => $atim_controls['misc_identifier_controls']['lung bank participant number']['flag_unique']
    	    );
    	    $bank_patient_misc_identifier_id = customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
    	    $misc_identifier_check[$atim_controls['misc_identifier_controls']['lung bank participant number']['id'].'||'."$bank_patient_id"] = '1';
    	    $cusm_bank_nbr_check[$bank_patient_id][$participant_id] = array(
    	        'participant_id' => $participant_id,
    	        'bank_patient_misc_identifier_id' => $bank_patient_misc_identifier_id,
    	        'collections' => array()
    	    );
    	}
    	
    	// Create consent
    	//-------------------------------------------------------------------------------------------
    	
    	// Get data of the collection file
    	
    	$collection_file_consent_data = array();
    	if(preg_match('/^[Yy]/', $excel_line_data['Consent Consented (Y/N)'])){
            if(strlen(trim($excel_line_data['Consent Consented (Y/N)'])) != 1) {
                recordErrorAndMessage('Consent (file : '.$excel_file_name.')',
                    '@@WARNING@@',
                    "Listed an 'Obtained' consent from excel collection file but the 'Consented' value is different than 'Y'. Please confirm and check no additional information has to be recorded.",
                    "See value '".$excel_line_data['Consent Consented (Y/N)']."' for $excel_data_references.");
            }
	        $excel_field = 'Consent Date Consented';
	        list($consent_date, $consent_date_accuracy) = validateAndGetDateAndAccuracy(
	            $excel_line_data[$excel_field],
	            'Consent (file : '.$excel_file_name.')',
	            "See field '$excel_field'.",
	            "See $excel_data_references");
	        $excel_field = "Consent Consenter";
	        $consent_person = validateAndGetStructureDomainValue(
	            str_replace(
                    array("Spicer", "Ioana", "Dong", "Aya", "Julie", "Emma", 'Nick', 'Emma Lee Lee', 'Dr. Ferri', 'Dr. Cools', 'Sammantha, Emma Lee'), 
                    array("Jonathan Spicer", "Ioana Nicolau", "Dong", "Aya Siblini", "Julie Breau", "Emma Lee", 'Nick Berthos', "Emma Lee", 'Ferri', 'Cools-Lartigue', 'Emma Lee'), 
	                $excel_line_data[$excel_field]),
	            'custom_laboratory_staff',
	            'Consent (file : '.$excel_file_name.')',
	            "See field '$excel_field'.",
	            "The consenter value won't be migrated for $excel_data_references");
	        $collection_file_consent_data = array(
	            "consent_status" => 'obtained',
	            "consent_person" => $consent_person,
	            'consent_signed_date' => $consent_date,
	            'consent_signed_date_accuracy' => $consent_date_accuracy);
        } elseif(preg_match('/^[Nn]/', $excel_line_data['Consent Consented (Y/N)'])){
            recordErrorAndMessage('Consent (file : '.$excel_file_name.')', 
	            '@@MESSAGE@@', 
	            "Consented (Y/N) is set to 'N'. No consent info from excel collection file will be used to create ATiM consent. Please confirm.", 
	            strlen($excel_line_data['Consent Consented (Y/N)'])? "See value '".$excel_line_data['Consent Consented (Y/N)']."' for $excel_data_references." : "See $excel_data_references.");
    	} else {
            recordErrorAndMessage('Consent (file : '.$excel_file_name.')', 
	            '@@MESSAGE@@', 
	            "Consent is not defined as either 'obtained' or 'denied' into excel collection file. No consent info from excel collection file will be used to create ATiM consent. Please confirm.", 
	            strlen($excel_line_data['Consent Consented (Y/N)'])? "See value '".$excel_line_data['Consent Consented (Y/N)']."' for $excel_data_references." : "See $excel_data_references.");
    	}
    	
    	// Manage consent creation
    	$consent_signed_date_to_consider = '-1';
	    if($collection_file_consent_data && !isset($allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id])) {
	        // Consent only defined into the collection file
	        // Will add this one to the list of consents
    	    if(isset($allConsentsFromConsentFile[$bank_patient_mrn])) {
                $js_nbrs = array_keys($allConsentsFromConsentFile[$bank_patient_mrn]['consents']);
    	        $js_nbrs = implode(' & ', $js_nbrs);
    	        recordErrorAndMessage('Consent (both files)',
    	            '@@WARNING@@',
    	            "Participant consent linked to a collection JS number is only defined into excel collection file but participant consents defined into excel consent file are assigned to other JS numbers. Will create a new consent from excel collection file data but please validate.", 
    	            "See new consent created from excel collection file data for the JS number $bank_patient_id and consents defined into excel consent file for JS number $js_nbrs of the patient with MRN $bank_patient_mrn. See $excel_data_references.");      
    	    } else {
    	        recordErrorAndMessage('Consent (both files)',
    	            '@@WARNING@@',
    	            "Consent linked to a participant is only defined into excel collection file. Will create a new consent from file data but please validate.",
    	            "See $excel_data_references."); 
    	    }
	        $allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$collection_file_consent_data['consent_signed_date']] = array(
	            'consent_masters' => array_merge($collection_file_consent_data, array("participant_id" => $participant_id, "consent_control_id" =>  $atim_controls['consent_controls']['lung bank consent']['id'])),
	            $atim_controls['consent_controls']['lung bank consent']['detail_tablename'] => array());
	        $consent_signed_date_to_consider = $collection_file_consent_data['consent_signed_date'];
	    } elseif(!$collection_file_consent_data && isset($allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id])) {
	        // Consent only defined into the consent file file
    	    $consentDates = array_keys($allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id]);
    	    if(sizeof($consentDates) == 1) {
    	        $consent_signed_date_to_consider = array_shift($consentDates);
    	    } else {
    	        recordErrorAndMessage('Consent (both files)',
    	            '@@WARNING@@',
    	            "Consent linked to a participant is only defined into excel consent file but more than one consent is linked to the JS number. Script won't be able to assign the right consent to the collection. Link should be done manually into ATiM after the migration.",
    	            "See new consent created from excel collection file data for the JS number $bank_patient_id of the patient with MRN $bank_patient_mrn. See $excel_data_references.");
    	    }   	    
    	} elseif($collection_file_consent_data && isset($allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id])) {
    	    // Consent defined into both the consent and collection files
    	    if(!isset($allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$collection_file_consent_data['consent_signed_date']])) {
    	        $csfFileDates = array_keys($allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id]);
    	        recordErrorAndMessage('Consent (both files)',
    	            '@@WARNING@@',
    	            "Participant consent linked to a collection JS number and a specific date is only defined into excel collection file but participant consents defined into excel consent file and assigned to the same JS numbers exist but are linked to different consent dates. Will create a new consent from excel collection file data but please validate.",
    	            "See new consent created from excel collection file data for the JS number $bank_patient_id and date [".$collection_file_consent_data['consent_signed_date']."] and consents defined into excel consent file for the same JS number and different date (".implode(' & ', $csfFileDates).") for the patient with MRN $bank_patient_mrn. See $excel_data_references."); 
    	        $allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$collection_file_consent_data['consent_signed_date']] = array(
    	            'consent_masters' => array_merge($collection_file_consent_data, array("participant_id" => $participant_id, "consent_control_id" =>  $atim_controls['consent_controls']['lung bank consent']['id'])),
    	            $atim_controls['consent_controls']['lung bank consent']['detail_tablename'] => array());
    	    } else {
    	        $diff = array();
    	        foreach(array('consent_status', 'consent_person', 'consent_signed_date', 'consent_signed_date_accuracy') as $fieldToCompare) {
    	            $valueFromConsentFile = $allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$collection_file_consent_data['consent_signed_date']]['consent_masters'][$fieldToCompare];
    	            if($valueFromConsentFile != $collection_file_consent_data[$fieldToCompare]){
    	                if($collection_file_consent_data[$fieldToCompare]) {
    	                   $diff[] = "on $fieldToCompare (collection file [".$collection_file_consent_data[$fieldToCompare]."] != consent file [$valueFromConsentFile])";
    	                }
    	            }
    	        }
    	        if($diff) {
    	            recordErrorAndMessage('Consent (both files)',
    	                '@@WARNING@@',
    	                "Consent data are different from excel collection file and excel consent file. Will create a new consent from consent file data but the collection will be linked to a second consent created from excel collection file data. Please validate.",
    	                "Diff ".implode(' & ', $diff)." for consent on [".$collection_file_consent_data['consent_signed_date']."] linked to $excel_data_references.");    	             
    	        }
    	    }
    	    $consent_signed_date_to_consider = $collection_file_consent_data['consent_signed_date'];    
    	}
    	
    	$final_consent_master_id = null;
    	if($consent_signed_date_to_consider == '-1') {
    	    recordErrorAndMessage('Consent (both files)',
    	        '@@WARNING@@',
    	        "Script is unable to link a consent to a collection. Please check data and correct data manually into ATiM.",
    	        "See new collection created for $excel_data_references.");
    	} else {
    	    if(!isset($allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$consent_signed_date_to_consider]['consent_master_id'])) {
    	        $allConsentsFromConsentFile[$bank_patient_mrn]['atim_participant_id'] = $participant_id;
    	        $allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$consent_signed_date_to_consider]['consent_masters']["participant_id"] = $participant_id;
    	        $allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$consent_signed_date_to_consider]['consent_masters']["consent_control_id"] = $atim_controls['consent_controls']['lung bank consent']['id'];
    	        $final_consent_master_id = customInsertRecord($allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$consent_signed_date_to_consider]);
    	        $allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$consent_signed_date_to_consider]['consent_master_id'] = $final_consent_master_id;
    	        $created_consent_counter++;
    	    }
    	    $final_consent_master_id = $allConsentsFromConsentFile[$bank_patient_mrn]['consents'][$bank_patient_id][$consent_signed_date_to_consider]['consent_master_id'];
    	}
    	
    	// Unused data
    	//-------------------------------------------------------------------------------------------
    	   
    	if(strlen($excel_line_data['D_OPB'])) {
    	    recordErrorAndMessage('Consent (file : '.$excel_file_name.')',
    	        '@@WARNING@@',
    	        "'D_OPB' field of the excel collection file is not empty but the data of this field is not a data migrated into ATiM. Please check no data has to be completed into ATiM.",
    	        "See value '".$excel_line_data['D_OPB']."' for $excel_data_references.");
    	    
    	}

    	// Create inventory
    	//-------------------------------------------------------------------------------------------
    	
    	// Warning on stool data not imported
    	for($tmpId = 1; $tmpId < 4; $tmpId++) {
    	    if(strlen($excel_line_data["Stool $tmpId Date"].$excel_line_data["Stool $tmpId Aliquots"].$excel_line_data["Stool $tmpId Location"])) {
    	        $stoolData = 'Date: ['.$excel_line_data["Stool $tmpId Date"].'], Aliquots: ['.$excel_line_data["Stool $tmpId Aliquots"].'] and location: ['.$excel_line_data["Stool $tmpId Location"].']';
    	        recordErrorAndMessage('Collection (file : '.$excel_file_name.') : TODO',
    	            '@@ERROR@@',
    	            "Stool data won't be imported by the script. Please complete data into ATiM after migration if required.",
    	            "See stool data (#$tmpId) : $stoolData. See $excel_data_references.");
    	    }
    	}
    	
    	$excel_line_data['D_OP'] = str_replace(array('Not scheduled yet', 'Cancelled'), array('', ''), $excel_line_data['D_OP']);
    	$excel_field = 'D_OP';
    	list($collection_date, $collection_date_accuracy) = validateAndGetDateAndAccuracy(
    	    $excel_line_data[$excel_field],
    	    'Collection File :: Inventory',
    	    "See field '$excel_field'.",
    	    "See $excel_data_references");
    	
	    // Check collection has to be created
	    
	    $inventory_data_found = false;
	    $inventory_fields = array(
	        'TISSUE Location', 'TISSUE Rack #', 'TISSUE Box #', 'TISSUE Normal', 'TISSUE Tumor', 'TISSUE Lymph Nodes', 'TISSUE Notes', 'Pathology Acession #',
	        'TISSUE Location2', 'TISSUE Box #2', 'TISSUE Normal2', 'TISSUE Tumor2',
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
	       if(!$final_consent_master_id) {
    	       recordErrorAndMessage('Consent (file : '.$excel_file_name.')',
    	           '@@WARNING@@',
    	           "Participant did not consent and no collection exists. Collection won't be created into ATiM but participant will. Please check no data has to be corrected into ATiM and complete data after migration if required.",
    	           "See $excel_data_references.");
	       } else {
	           recordErrorAndMessage('Consent (file : '.$excel_file_name.')',
	               '@@MESSAGE@@',
	               "Particicipant consented but no collection has been created into ATiM based on excel data. Please check no data has to be recorded into ATiM and complete data after migration if required.",
	               "See $excel_data_references.");
	       }
	       
	   } else {
	       if(!$final_consent_master_id) {
               recordErrorAndMessage('Consent (file : '.$excel_file_name.')',
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
    	        $excel_data_references, $excel_file_name,
    	        'tissue', 
    	        $excel_line_data['TISSUE Location'], 
    	        $excel_line_data['TISSUE Box #'], 
                array('normal' => $excel_line_data['TISSUE Normal'], 'tumor' => $excel_line_data['TISSUE Tumor'], 'lymph nodes' => $excel_line_data['TISSUE Lymph Nodes']), 
    	        $excel_line_data['TISSUE Rack #']);
	       $tissue_aliquots_2 = getAliquots(
	           $excel_data_references, $excel_file_name,
	           'tissue',
	           $excel_line_data['TISSUE Location2'],
	           $excel_line_data['TISSUE Box #2'],
	           array('normal' => $excel_line_data['TISSUE Normal2'], 'tumor' => $excel_line_data['TISSUE Tumor2']),
	           '');
	       $tissue_aliquots = array_merge($tissue_aliquots, $tissue_aliquots_2);
	       if($tissue_aliquots || strlen($excel_line_data['Pathology Acession #']) || strlen($excel_line_data['TISSUE Notes']) || $ln_collection_notes) {
    	        $collection_data = array(
    	            'collection_property' => 'participant collection',
    	            'participant_id' => $participant_id,
    	            'bank_id' => $data_bank_id,
                    'misc_identifier_id' => $bank_patient_misc_identifier_id,
    	            'cusm_collection_pathology_nbr' => $excel_line_data['Pathology Acession #'],
    	            'collection_datetime' => $collection_date,
    	            'collection_datetime_accuracy' => str_replace('c', 'h', $collection_date_accuracy),
    	            'consent_master_id' => $final_consent_master_id,
    	            'sop_master_id' => $sop_master_id,
    	            'cusm_collection_type' => 'surgery',
    	            'collection_site' => "montreal general hospital",
    	            'collection_notes' => $ln_collection_notes . $excel_line_data['TISSUE Notes']
    	        );
    	        $collection_id = customInsertRecord(array('collections' => $collection_data));
    	        addCollectionTypeToJsNbr($cusm_bank_nbr_check[$bank_patient_id][$participant_id], 'surgery', $bank_patient_id, $excel_file_name);
    	        $collection_date_label = getCollectionDateForLabel($collection_date);
    	        $created_collection_counter++;
    	        if(!$tissue_aliquots) {
    	            recordErrorAndMessage('Collection (file : '.$excel_file_name.')',
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
        	            list($cusm_tissue_nature, $storage_master_id, $storage_coord_y, $storage_coord_x, $position_extension) = $new_tissue_aliquots;
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
        	                        'tissue_nature' => $cusm_tissue_nature_to_record));
        	                $created_tissue_sample_master_ids[$cusm_tissue_nature] = customInsertRecord($sample_data);
        	            }
        	            $sample_master_id = $created_tissue_sample_master_ids[$cusm_tissue_nature];
        	            // Tissue tube   	            
        	            $created_aliquot_counter++;
        	            $tube_label = ($cusm_tissue_nature == 'lymph nodes') ? 'LN' : strtoupper($cusm_tissue_nature[0]);
        	            $tube_label_counter[$tube_label]++;
        	            $tmp_st_solution = 'OCT';
        	            $tmp_st_solution_label = 'OCT';
        	            if($position_extension == 'CC' || $position_extension == 'FBS/DMSO') {
        	                $tmp_st_solution = 'DMSO';
        	                $tmp_st_solution_label = $position_extension;      	                
        	            }
        	            $aliquot_data = array(
        	                'aliquot_masters' => array(
        	                    "barcode" => 'barcode_'.$created_aliquot_counter,
        	                    'aliquot_label' => "$bank_patient_id $tmp_st_solution_label $tube_label $collection_date_label ".$tube_label_counter[$tube_label],
        	                    "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-tube']['id'],
        	                    "collection_id" => $collection_id,
        	                    "sample_master_id" => $sample_master_id,
        	                    'storage_master_id' => $storage_master_id,
        	                    'storage_coord_x' => $storage_coord_y,
        	                    'storage_coord_y' => $storage_coord_x,
        	                    'in_stock' => 'yes - available',
        	                    'in_stock_detail' => '',
        	                    'notes' => ($position_extension? "Defined as [$position_extension] in excel." : '')),
        	                $atim_controls['aliquot_controls']['tissue-tube']['detail_tablename'] => array(
        	                    'cusm_storage_solution' => $tmp_st_solution
        	                ));
        	            customInsertRecord($aliquot_data);
                        $created_aliquots = true;
        	        }
        	    }
    	    }
                    
            // Load pre surgery blood aliquots
            $all_blood = array();
            $blood_aliquots = getAliquots(
                $excel_data_references, $excel_file_name,
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
    	        $excel_data_references, $excel_file_name,
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
    	            recordErrorAndMessage('Collection (file : '.$excel_file_name.')',
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
                    $excel_data_references, $excel_file_name,
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
                    'misc_identifier_id' => $bank_patient_misc_identifier_id,
    	            'collection_datetime' => $new_blood_collection['collection_datetime'],
    	            'collection_datetime_accuracy' => $new_blood_collection['collection_datetime_accuracy'],
    	            'consent_master_id' => $final_consent_master_id,
    	            'sop_master_id' => $sop_master_id,
    	            'collection_notes' => $new_blood_collection['collection_notes'],
    	            'collection_site' => "montreal general hospital",
    	            'cusm_collection_type' => $new_blood_collection['cusm_collection_type']
    	        );
    	        $collection_id = customInsertRecord(array('collections' => $collection_data));
    	        addCollectionTypeToJsNbr($cusm_bank_nbr_check[$bank_patient_id], $new_blood_collection['cusm_collection_type'].($new_blood_collection['tmp_counter']? " (".$new_blood_collection['tmp_counter'].")" : ''), $bank_patient_id, $excel_file_name);
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
    	            list($cusm_derivative_sample_type, $storage_master_id, $storage_coord_y, $storage_coord_x, $position_extension) = $new_blood_aliquots;
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
    	                    'storage_coord_x' => $storage_coord_y,
    	                    'storage_coord_y' => $storage_coord_x,
    	                    'in_stock' => 'yes - available',
    	                    'in_stock_detail' => '',
    	                    'notes' => ($position_extension? "Defined as [$position_extension] in excel." : '')),
    	                $atim_controls['aliquot_controls'][$cusm_derivative_sample_type.'-tube']['detail_tablename'] => array());
    	            customInsertRecord($aliquot_data);
                    $created_aliquots = true;
    	        }
    	    }
    	    if(!$created_aliquots) {
    	        recordErrorAndMessage('Collection (file : '.$excel_file_name.')',
    	            '@@WARNING@@',
    	            "No aliquot exists into a collection created for the participant. Collection has probably been created to track notes or pathology #. Please check no data has to be recorded into ATiM and complete/correct data after migration if required.",
    	            "See ".($collection_date? " collection on $collection_date for " : '')." $excel_data_references.");
    	    }
    	}
	}
}  //End new line

foreach($allConsentsFromConsentFile as $bank_patient_mrn => $allJsConsentData) {
    if(!$allJsConsentData['atim_participant_id']) {        
        recordErrorAndMessage('Consent File (both files)',
            '@@WARNING@@',
            "Participant of the excel consent file is not defined into excel collection file. Participant, RAMQ, MRN and consent data will be created but no collection. Please validate.",
            "See patient with MRN $bank_patient_mrn in excel consent file.");
        $excel_participant_data = array(
            'first_name' => $allJsConsentData['first_name'],
            'last_name' => $allJsConsentData['last_name'],
            'date_of_birth' => $allJsConsentData['date_of_birth'],
            'date_of_birth_accuracy' => $allJsConsentData['date_of_birth_accuracy'],
            'last_modification' => $import_date);
        $participant_id = customInsertRecord(array('participants' => $excel_participant_data));
        $created_participant_counter++;
        if($bank_patient_mrn) {
            $misc_identifier_data = array(
                'identifier_value' => $bank_patient_mrn,
                'participant_id' => $participant_id,
                'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['MGH-MRN']['id'],
                'flag_unique' => $atim_controls['misc_identifier_controls']['MGH-MRN']['flag_unique']
            );
            customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
    	    $misc_identifier_check[$atim_controls['misc_identifier_controls']['MGH-MRN']['id'].'||'."$bank_patient_mrn"] = '1';
        }
        if($allJsConsentData['ramq']) {
            $misc_identifier_data = array(
                'identifier_value' => $allJsConsentData['ramq'],
                'participant_id' => $participant_id,
                'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['ramq nbr']['id'],
                'flag_unique' => $atim_controls['misc_identifier_controls']['ramq nbr']['flag_unique']
            );
            customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
    	    $misc_identifier_check[$atim_controls['misc_identifier_controls']['ramq nbr']['id'].'||'.$allJsConsentData['ramq']] = '1';
        }
        foreach($allJsConsentData['consents'] as $bank_patient_id => $allConsents) {
            if($bank_patient_id) {
                if(isset($misc_identifier_check[$atim_controls['misc_identifier_controls']['lung bank participant number']['id'].'||'."$bank_patient_id"])) {
                    recordErrorAndMessage('Consent File (both files)',
                        '@@ERROR@@',
                        "System is creating new participant who consented but was not linked to collection by the script but the Bank Participant # has already be assigned to another created participant. New participant won't be created! Please validate participant is the same or is a different one then correct data after migration.",
                        "See patient with MRN $bank_patient_mrn  and JS nbr $bank_patient_id in excel consent file.");
                } else {
                    $misc_identifier_data = array(
                        'identifier_value' => "$bank_patient_id",
                        'participant_id' => $participant_id,
                        'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['lung bank participant number']['id'],
                        'flag_unique' => $atim_controls['misc_identifier_controls']['lung bank participant number']['flag_unique']
                    );
                    $bank_patient_misc_identifier_id = customInsertRecord(array('misc_identifiers' => $misc_identifier_data));
                    $misc_identifier_check[$atim_controls['misc_identifier_controls']['lung bank participant number']['id'].'||'."$bank_patient_id"] = '1';
                }
            }            
            foreach($allConsents as $newConsent) {
                $newConsent['consent_masters']['participant_id'] = $participant_id;
                customInsertRecord($newConsent);
            }
        }
    } else {
        foreach($allJsConsentData['consents'] as $bank_patient_id => $consentsData) {
            foreach($consentsData as $dateConsent => $consentData) {
                if(!isset($consentData['consent_master_id'])) {
                    $consentData['consent_masters']['participant_id'] = $allJsConsentData['atim_participant_id'];
                    customInsertRecord($consentData);
                    recordErrorAndMessage('Consent (both files)',
                        '@@WARNING@@',
                        "Created a consent defined into consent excel file that has not been linked to a collection by the script. Please validate data and complete/correct data after migration if required.",
                        "See consent created for participant (MRN '$bank_patient_mrn' / Js Nbr '$bank_patient_id') and date '$dateConsent'.");
                }
            }
        }   
    }
}
recordErrorAndMessage('Collection File :: Migration Summary', '@@MESSAGE@@', "Number of created records", 'Participants : '.$created_participant_counter);
recordErrorAndMessage('Collection File :: Migration Summary', '@@MESSAGE@@', "Number of created records", 'Obtained Consents : '.$created_consent_counter);
recordErrorAndMessage('Collection File :: Migration Summary', '@@MESSAGE@@', "Number of created records", 'Collections : '.$created_collection_counter);
recordErrorAndMessage('Collection File :: Migration Summary', '@@MESSAGE@@', "Number of created records", 'Samples : '.$created_sample_counter);
recordErrorAndMessage('Collection File :: Migration Summary', '@@MESSAGE@@', "Number of created records", 'Aliquots : '.$created_aliquot_counter);
recordErrorAndMessage('Collection File :: Migration Summary', '@@MESSAGE@@', "Number of created records", 'Storages : '.$created_storage_counter);

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
	recordErrorAndMessage('Collection File :: Data Creation Summary', '@@MESSAGE@@', $creation_type, "$detail. See $excel_data_references.");
}

function addUpdatedDataToSummary($update_type, $updated_data, $excel_data_references) {
	if($updated_data) {
		$updates = array();
		foreach($updated_data as $field => $value) $updates[] = "[$field = $value]";
		recordErrorAndMessage('Collection File :: Data Update Summary', '@@MESSAGE@@', $update_type, "Updated field(s) : ".implode(' + ', $updates).". See $excel_data_references.");
	}
}

function getAliquots($excel_data_references, $excel_file_name, $sample_type, $location, $box_number, $positions, $rack_number = '') {
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
	    } elseif($tmp_data == 'none') {
	        $positions[$key] = '';
	    } elseif($tmp_data == 'NA') {
	        $positions[$key] = '';
	    } elseif($tmp_data == '_') {
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
    	    recordErrorAndMessage('Collection (file : '.$excel_file_name.')',
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
    $_new_box_number = trim(str_replace('.', ',', $box_number));
    
   if($_new_box_number != $box_number) { 
        recordErrorAndMessage('Collection (file : '.$excel_file_name.')',
            '@@WARNING@@',
            "Box# value updated by script. Please validate data after migration.",
            "See Box# '$box_number' changed to $_new_box_number for $excel_data_references.");
   }
    
    $box_number = $_new_box_number; 
    if(!preg_match('/^[0-9]+(,[0-9]+){0,1}$/', $box_number)) {
        recordErrorAndMessage('Collection (file : '.$excel_file_name.')',
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
        if(strlen($aliquots_positions_sets)) {
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
    }
    // Create results (aliquots storage information)
    
    if(!$aliquots_positions) {
        recordErrorAndMessage('Collection (file : '.$excel_file_name.')',
            '@@ERROR@@',
            "A box is defined into the excel file but no position has been extracted from the excel file. No aliquot will be created. Please validate and correct data directly into ATiM if required.",
            "See box(es) '$box_number' ".($position_defined? "and defined positions '".implode("' & '", $position_defined) : '')." for $excel_data_references.");
        return array();
    } else if(!(sizeof($created_box_storage_masters_ids) == sizeof($aliquots_positions) && array_keys($aliquots_positions) == array_keys($created_box_storage_masters_ids))) {
        recordErrorAndMessage('Collection (file : '.$excel_file_name.')',
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
                    if(preg_match('/^([A-I])([1-9])(\(((FBS\/DMSO)|(CC)|(OCT))\)){0,1}$/', $aliquot_positions, $matches)) {
                        $posExtension = isset($matches[4])? $matches[4] : '';
                        $final_aliquots_storage_information[] = array($sample_type, $storage_master_id, $matches[1], $matches[2], $posExtension);
                    } else if(preg_match('/^([A-I])([1-9])\-([A-I])([1-9])(\(((FBS\/DMSO)|(CC)|(OCT))\)){0,1}$/', $aliquot_positions, $matches)) {
                        $from_x = $matches[1];
                        $from_y = $matches[2];
                        $to_x = $matches[3];
                        $to_y = $matches[4];
                        $posExtension = isset($matches[6])? $matches[6] : '';
                        if(($from_x.$from_y) >= ($to_x.$to_y)) {
                            recordErrorAndMessage('Collection (file : '.$excel_file_name.')',
                                '@@ERROR@@',
                                "Wrong aliquots positions definition (1). The aliquots matching these postions won't be migrated. Please validate and correct data directly into ATiM if required.",
                                "See positions value '$aliquot_positions' in the box(es) '$box_number' for $excel_data_references.");
                        } else {
                            $x = $from_x;
                            $y = $from_y;
                            $last_aliquot_position_found = false;
                            while(!$last_aliquot_position_found) {
                                if(!preg_match('/^([A-I])([1-9])$/', ($x.$y))) die('ERR2234234'); // Should never happens
                                $final_aliquots_storage_information[] = array($sample_type, $storage_master_id, $x, $y, $posExtension);
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
                                    $final_aliquots_storage_information[] = array($sample_type, $storage_master_id, $x, $y, $posExtension);
                                }
                            }
                        }
                    } else {
                        recordErrorAndMessage('Collection (file : '.$excel_file_name.')',
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

function addCollectionTypeToJsNbr(&$cusm_bank_nbr_check, $collectiontype, $bank_patient_id, $excel_file_name) {
    if(isset($cusm_bank_nbr_check['collections'][$collectiontype])) {
        recordErrorAndMessage('Participant (file : '.$excel_file_name.')',
            '@@ERROR@@',
            "Participant collection type recorded twice for the same JS number. Please validate and correct data after migration if required.",
            "See created '$collectiontype' collections for participant(s) with JS number '".implode("' & '", $cusm_bank_nbr_check['collections'][$collectiontype]).".");
    }
    $cusm_bank_nbr_check['collections'][$collectiontype][] = $bank_patient_id;
}
	
?>
		