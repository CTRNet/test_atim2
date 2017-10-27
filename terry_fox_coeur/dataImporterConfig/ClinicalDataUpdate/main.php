<?php

// *******************************************************************************************************************************************************
//
//    TFRI-COEUR
//
// *******************************************************************************************************************************************************
//
//	Script created to update the clinical data absed on the bank submitted files in 2017-05-17.
//  This script is supposed to be re-used in winter 2018 for the last update.
// 
//  Here are the list of fields updated:
//
//  ** Profile
//   -  Date of Birth
//   -  Date of Last Contact
//   -  Vital Status
//   -  Registered Date of Death
//   -  Family History
//   -  BRCA status
//   -  Post Chemo
//   -  Notes
//
//  ** EOC Diagnosis : 
//   -  Diagnosis Date
//   -  Age at Diagnosis
//   -  Tumour Grade
//   -  Figo
//   -  Progression status
//   -  Histopathology
//   -  Histopathology Revision
//   -  Residual disease
//   -  CA125 Recurrence
//   -  Recurrence
//   -  CA125 progression time (months) [calculated and populated by the migration process]
//   -  progression time (months) [calculated and populated by the migration process]
//   -  Follow-up from ovarectomy (months) [calculated and populated by the migration process]
//   -  Survival from diagnosis (months) [calculated and populated by the migration process]
//
//  ** Other Diagnosis :
//   No data 
//
//  ** EOC Treatment (including ovarectomy) : 
//   All treatment  
//
// @created 2017-05-17
// @author Nicolas Luc
// *******************************************************************************************************************************************************

require_once 'system.php';

$commit_all = true;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $commit_all = false;   
    } else {
        die('ERR ARG : '.$argv[1].' (should be test or nothing)');
    }
}

$excel_file_names = array();
foreach($bank_excel_files as $new_bank_file) { 
	if($new_bank_file['file']) {
	    $excel_file_names_for_title[] = $new_bank_file['file'];
	    $excel_file_names[] = $new_bank_file['file'];
	}
}

displayMigrationTitle('TFRI COEUR - Clinical Data Update', $excel_file_names_for_title);

if(!testExcelFile($excel_file_names)) {
	dislayErrorAndMessage();
	exit;
}

$creation_update_summary = array();

$atim_drugs = array();
foreach(getSelectQueryResult("SELECT id, generic_name FROM drugs WHERE deleted <> 1") as $new_drug) {
    $atim_drugs[$new_drug['generic_name']] = $new_drug['id'];    
}

foreach($bank_excel_files as $new_bank_file) { 
	
	// New Bank File
	
	$bank_name = $new_bank_file['bank'];
	$file_name = $new_bank_file['file'];
	$file_name_for_summary = "file '<b>".substr($file_name, 0, 15)."...xls</b>' of bank '$bank_name'";
	list($profile_worksheet_name, $treatment_worksheet_name) = $new_bank_file['worksheets'];
	$parser_function_suffix = $new_bank_file['parser_function'];
	$file_xls_offset = $new_bank_file['file_xls_offset'];
	
	// Get Bank
	
	$atim_qc_tf_bank_id = getSelectQueryResult("SELECT id FROM banks WHERE name = '$bank_name'");
	$atim_qc_tf_bank_id = isset($atim_qc_tf_bank_id[0]['id'])? $atim_qc_tf_bank_id[0]['id'] : null;
	if(empty($atim_qc_tf_bank_id)) {
	    recordErrorAndMessage(
	        'Excel File', 
	        '@@ERROR@@', 
	        "Bank does not exist into ATIM. No data of the file will be migrated.", 
	        "See bank $file_name_for_summary defined into config.php.");
	    
	} else {
	    
	    // Get all clinical events
	    
	    $file_parser_function = 'getClinicalEventBy'.$parser_function_suffix.'Parser';
	    $all_excel_clinical_events_treatments_records = array();
        
	    while($excel_line_clinical_event_data = $file_parser_function($file_name, $file_name_for_summary, $treatment_worksheet_name, $file_xls_offset)) {
	        if(isset($excel_line_clinical_event_data[0]['event']['qc_tf_bank_identifier'][0])) {
	            $all_excel_clinical_events_treatments_records[$excel_line_clinical_event_data[0]['event']['qc_tf_bank_identifier'][0]][] = $excel_line_clinical_event_data;  
	        }
	    }
	    
	    // Update bank clinical data
	
    	$file_parser_function = 'getProfileBy'.$parser_function_suffix.'Parser';
    	$check_date_done = false;
    	while($excel_line_clinical_data = $file_parser_function($file_name, $file_name_for_summary, $profile_worksheet_name, $file_xls_offset)) {
    		list($excel_line_clinical_data, $excel_file_name_and_line_for_summary) = $excel_line_clinical_data;
            
    		// Check file_xls_offset
    	    if(!$check_date_done && !empty($excel_line_clinical_data['participants']['qc_tf_last_contact'][0])) {
                recordErrorAndMessage(
                    'Excel File',
    		        '@@WARNING@@',
    		        "Migrated date format validation ('file_xls_offset' check) : Validate following date is exactly the date written into the excel file.",
    		        "See date '".$excel_line_clinical_data['participants']['qc_tf_last_contact'][0]."' for field '".$excel_line_clinical_data['participants']['qc_tf_last_contact'][1]."' in $excel_file_name_and_line_for_summary.");
    		    $check_date_done = true;
    		}
    		
    		// Check participant
    	    
    		$participant_identifier = $excel_line_clinical_data['participants']['participant_identifier'][0];
    		$qc_tf_bank_identifier = $excel_line_clinical_data['participants']['qc_tf_bank_identifier'][0];
    		$query = "SELECT id, qc_tf_last_contact, qc_tf_last_contact_accuracy, vital_status, date_of_birth, date_of_birth_accuracy, date_of_death, date_of_death_accuracy, qc_tf_brca_status, qc_tf_family_history, qc_tf_post_chemo, notes
        		FROM participants 
        		WHERE participant_identifier = '".str_replace(array('"', "'"), array('\"', "''"), $participant_identifier)."'
        		AND qc_tf_bank_id = '$atim_qc_tf_bank_id'
        		AND qc_tf_bank_identifier = '".str_replace(array('"', "'"), array('\"', "''"), $qc_tf_bank_identifier)."'
        		AND deleted <> 1";
    		$participant_identifier = empty($participant_identifier)? 'unknown' : $participant_identifier;
    		$qc_tf_bank_identifier = empty($qc_tf_bank_identifier)? 'unknown' : $qc_tf_bank_identifier;
    		$participant_identifiers_for_summary = "participant with TFRI# '$participant_identifier' and Bank# '$qc_tf_bank_identifier' of the bank '$bank_name'";
    		$atim_participant_data = getSelectQueryResult($query);
        	if(!$atim_participant_data) {
        	    recordErrorAndMessage(
        	        'Participant Profile',
        	        '@@ERROR@@',
        	        "Participant not found into ATiM. Row's data won't be migrated.",
        	        "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
        	} elseif (sizeof($atim_participant_data) > 1) {
        	    recordErrorAndMessage(
        	        'Participant Profile',
        	        '@@ERROR@@',
        	        "More than one participant match information into ATiM. Row's data won't be parsed then used for the data update.",
        	        "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
        	} else {
        	    
        	    // Participant found into ATiM
                
        	    $atim_participant_id = $atim_participant_data[0]['id'];
        	    unset($atim_participant_data[0]['id']);
        	     
        	    // Participant Profile Update
        	    //---------------------------------------------------------------------------------------
        	    
        	    $atim_participant_data = $atim_participant_data[0];
        	    $atim_participant_data_from_excel = array(
        	        'qc_tf_last_contact' => $excel_line_clinical_data['participants']['qc_tf_last_contact'][0],
        	        'qc_tf_last_contact_accuracy' => $excel_line_clinical_data['participants']['qc_tf_last_contact'][2],
        	        'vital_status' => validateAndGetStructureDomainValue(
                        $excel_line_clinical_data['participants']['vital_status'][0], 
                        'health_status', 
        	            'Participant Profile', 
        	            "Value of excel field ".$excel_line_clinical_data['participants']['vital_status'][1]." won't be used for the ATiM data update.", 
        	            "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary"),
        	        'date_of_birth' => $excel_line_clinical_data['participants']['date_of_birth'][0],
        	        'date_of_birth_accuracy' => $excel_line_clinical_data['participants']['date_of_birth'][2],
        	        'date_of_death' => $excel_line_clinical_data['participants']['date_of_death'][0],
        	        'date_of_death_accuracy' => $excel_line_clinical_data['participants']['date_of_death'][2],
        	        'qc_tf_family_history' => validateAndGetStructureDomainValue(
        	            $excel_line_clinical_data['participants']['qc_tf_family_history'][0],
        	            'qc_tf_fam_hist',
        	            'Participant Profile',
        	            "Value of excel field ".$excel_line_clinical_data['participants']['qc_tf_family_history'][1]." won't be used for the ATiM data update.", 
        	            "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary"),
        	        'qc_tf_brca_status' => validateAndGetStructureDomainValue(
        	            $excel_line_clinical_data['participants']['qc_tf_brca_status'][0],
        	            'qc_tf_brca',
        	            'Participant Profile',
        	            "Value of excel field ".$excel_line_clinical_data['participants']['qc_tf_brca_status'][1]." won't be used for the ATiM data update.", 
        	            "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary"),
        	        'qc_tf_post_chemo' => validateAndGetExcelValueFromList(
        	            $excel_line_clinical_data['participants']['qc_tf_post_chemo'][0],
        	            array('unknown' => '', 'y' => 'y', 'no' => 'n'),
        	            true,
        	            'Participant Profile',
        	            "Value of excel field ".$excel_line_clinical_data['participants']['qc_tf_post_chemo'][1]." won't be used for the ATiM data update.", 
        	            "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary")
        	    );
        	    // Check on vital status
                if($atim_participant_data_from_excel['date_of_death'] && $atim_participant_data_from_excel['vital_status'] != 'deceased') {
                    recordErrorAndMessage(
                        'Participant Profile',
                        '@@WARNING@@',
                        "Participant vital status is not equal to 'deceased' but a date of death is set into Excel. Vital status will be set to 'deceased' and compared to ATiM data.",
                        "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                    $atim_participant_data_from_excel['vital_status'] = 'deceased';
                }
                //Check notes
                if(strlen($excel_line_clinical_data['participants']['notes'][0]) && (strpos($atim_participant_data['notes'], $excel_line_clinical_data['participants']['notes'][0]) === false)) {
                    $atim_participant_notes = $atim_participant_data['notes'];
                    if(strlen($atim_participant_data['notes'])) {
                        if(!preg_match('/\.$/', $atim_participant_notes)) $atim_participant_notes .= '.';
                        $atim_participant_notes .= ' ';
                    }
                    $atim_participant_data_from_excel['notes'] = $atim_participant_notes.$excel_line_clinical_data['participants']['notes'][0];
                }
                
                // Launch Participant Profile Update
        	    $participant_data_to_update = getDataToUpdate($atim_participant_data, $atim_participant_data_from_excel, __LINE__);
        	    if(sizeof($participant_data_to_update) >= 1) {
                    updateTableData($atim_participant_id, array('participants' => $participant_data_to_update));
        	        addUpdatedDataToSummary(
        	            $participant_identifiers_for_summary, 
        	            $excel_file_name_and_line_for_summary, 
        	            'Updated Participant Profile', 
        	            $participant_data_to_update);
        	    }
        	    
        	    // Diagnosis Update
        	    //---------------------------------------------------------------------------------------
                
        	    $dx_eoc_diagnosis_control_id = $atim_controls['diagnosis_controls']['primary-EOC']['id'];
        	    $dx_eoc_detail_tablename = $atim_controls['diagnosis_controls']['primary-EOC']['detail_tablename'];
        	    $query = "SELECT diagnosis_master_id, dx_date, dx_date_accuracy, age_at_dx, tumour_grade, figo, histopathology, reviewed_histopathology, residual_disease, progression_status,
                    ca125_progression_time_in_months, progression_time_in_months, follow_up_from_ovarectomy_in_months, survival_from_ovarectomy_in_months, notes
            	    FROM diagnosis_masters
            	    INNER JOIN $dx_eoc_detail_tablename ON id = diagnosis_master_id
            	    WHERE deleted <> 1
            	    AND participant_id = $atim_participant_id
            	    AND diagnosis_control_id = $dx_eoc_diagnosis_control_id";
        	    $atim_diagnosis_data = getSelectQueryResult($query);
        	    if(!$atim_diagnosis_data) {
        	        recordErrorAndMessage(
        	            'Participant EOC Diagnosis',
        	            '@@ERROR@@',
        	            "Participant EOC diagnosis not found into ATiM. No EOC diagnosis data can be updated. Please create first an eoc diagnosis manually into ATiM",
        	            "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
        	        echo "<br><font color='red'>Participant EOC diagnosis not found into ATiM. No EOC diagnosis data can be updated. : See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.</font>";
        	    } elseif (sizeof($atim_diagnosis_data) > 1) {
        	        recordErrorAndMessage(
        	            'Participant EOC Diagnosis',
        	            '@@ERROR@@',
        	            "More than one participant EOC diagnosis found into ATiM. No EOC diagnosis data will be updated based on Excel data.",
        	            "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
        	    } else {
        	        
        	        // EOC diagnosis found
        	    
        	        $dx_eoc_diagnosis_master_id = $atim_diagnosis_data[0]['diagnosis_master_id'];
        	        unset($atim_diagnosis_data[0]['diagnosis_master_id']);
        	        
        	        $atim_diagnosis_data = $atim_diagnosis_data[0];
        	        $atim_eoc_diagnosis_data_from_excel = array(
        	            'diagnosis_masters' => array(
            	            'dx_date' =>  $excel_line_clinical_data['diagnosis']['dx_date'][0],
            	            'dx_date_accuracy' => $excel_line_clinical_data['diagnosis']['dx_date'][2],
        	                'notes' => isset($excel_line_clinical_data['diagnosis']['notes'])? $excel_line_clinical_data['diagnosis']['notes']['0'] : '', 
        	                'tumour_grade' => validateAndGetStructureDomainValue(
            	                $excel_line_clinical_data['diagnosis']['tumour_grade'][0],
            	                'qc_tf_grade',
            	                'Participant EOC Diagnosis',
            	                "Value of excel field ".$excel_line_clinical_data['diagnosis']['tumour_grade'][1]." won't be used for the ATiM data update.", 
            	                "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary")
        	            ),
        	            $dx_eoc_detail_tablename => array(
        	                'figo' => validateAndGetStructureDomainValue(
        	                    $excel_line_clinical_data['diagnosis']['figo'][0],
        	                    'qc_tf_figo',
        	                    'Participant EOC Diagnosis',
        	                    "Value of excel field ".$excel_line_clinical_data['diagnosis']['figo'][1]." won't be used for the ATiM data update.", 
        	                    "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary"),
        	                'histopathology' => validateAndGetStructureDomainValue(
            	                $excel_line_clinical_data['diagnosis']['histopathology'][0],
            	                'qc_tf_histopathology',
            	                'Participant EOC Diagnosis',
            	                "Value of excel field ".$excel_line_clinical_data['diagnosis']['histopathology'][1]." won't be used for the ATiM data update.", 
            	                "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary"),
        	                'reviewed_histopathology' => validateAndGetStructureDomainValue(
            	                $excel_line_clinical_data['diagnosis']['reviewed_histopathology'][0],
            	                'qc_tf_histopathology',
            	                'Participant EOC Diagnosis',
            	                "Value of excel field ".$excel_line_clinical_data['diagnosis']['reviewed_histopathology'][1]." won't be used for the ATiM data update.", 
            	                "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary"),
        	                'residual_disease' => validateAndGetStructureDomainValue(
            	                $excel_line_clinical_data['diagnosis']['residual_disease'][0],
            	                'qc_tf_residual_disease',
            	                'Participant EOC Diagnosis',
            	                "Value of excel field ".$excel_line_clinical_data['diagnosis']['residual_disease'][1]." won't be used for the ATiM data update.", 
            	                "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary"),
        	                'progression_status' => validateAndGetStructureDomainValue(
            	                $excel_line_clinical_data['diagnosis']['progression_status'][0],
            	                'qc_tf_progression_status',
            	                'Participant EOC Diagnosis',
            	                "Value of excel field ".$excel_line_clinical_data['diagnosis']['progression_status'][1]." won't be used for the ATiM data update.", 
            	                "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary")
    	                )
    	            );
        	        $diagnosis_data_to_update = array(
        	            'diagnosis_masters' => getDataToUpdate($atim_diagnosis_data, $atim_eoc_diagnosis_data_from_excel['diagnosis_masters'], __LINE__),
        	            $dx_eoc_detail_tablename => getDataToUpdate($atim_diagnosis_data, $atim_eoc_diagnosis_data_from_excel[$dx_eoc_detail_tablename], __LINE__));
                    
                    // Manage Age at dx update
        	        
        	        $next_record_of_date_of_birth = isset($participant_data_to_update['date_of_birth'])? $participant_data_to_update['date_of_birth'] : $atim_participant_data['date_of_birth'];
        	        $next_record_of_date_of_birth_accuracy = isset($participant_data_to_update['date_of_birth_accuracy'])? $participant_data_to_update['date_of_birth_accuracy'] : $atim_participant_data['date_of_birth_accuracy'];
        	        $next_record_of_eoc_diagnosis_date = isset($diagnosis_data_to_update['diagnosis_masters']['dx_date'])? $diagnosis_data_to_update['diagnosis_masters']['dx_date'] : $atim_diagnosis_data['dx_date'];
                    $next_record_of_eoc_diagnosis_date_accuracy = isset($diagnosis_data_to_update['diagnosis_masters']['dx_date_accuracy'])? $diagnosis_data_to_update['diagnosis_masters']['dx_date_accuracy'] : $atim_diagnosis_data['dx_date_accuracy'];
                    $excel_age_at_dx = validateAndGetInteger(
                        $excel_line_clinical_data['diagnosis']['age_at_dx'][0],
                        'Participant EOC Diagnosis',
                        "Value of excel field ".$excel_line_clinical_data['diagnosis']['age_at_dx'][1]." won't be used for the ATiM data update.",
                        "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary");
                    
                    $calculated_age_at_dx = null;
                    $unable_to_calculate_age_at_dx_msg = '';
        	        if(empty($next_record_of_date_of_birth) || empty($next_record_of_eoc_diagnosis_date)) {
                        // Date(s) are missing. No caluclated age at diagnosis value will be compared to ATiM data
        	            //$unable_to_calculate_age_at_dx_msg = 'Both ATiM and Excel Dates are missing to calculate the date of diagnosis.';
    	            } else if(!preg_match('/^[cd]{2}$/', $next_record_of_date_of_birth_accuracy.$next_record_of_eoc_diagnosis_date_accuracy)) { 
    	                // Approximate date(s)
        	            $unable_to_calculate_age_at_dx_msg = 'Either the date of birth or the date of diagnosis is approximate. The age at diagnosis can not be calculated and compared to ATiM data.';
    	            } else {
    	                $calculated_age_at_dx = datesDiff($next_record_of_date_of_birth, $next_record_of_eoc_diagnosis_date, 'm');
    	                $calculated_age_at_dx_modulo = $calculated_age_at_dx % 12;
    	                $calculated_age_at_dx = ($calculated_age_at_dx-$calculated_age_at_dx_modulo)/12;
    	                if($calculated_age_at_dx_modulo >= 6) {
    	                    $calculated_age_at_dx += 1;
    	                }
    	            }
    	            
    	            $age_at_dx_to_compare_to_atim = '';
    	            if(strlen($calculated_age_at_dx)) {
    	                if($calculated_age_at_dx < 0) {
    	                    $excel_age_at_dx_msg = '';
    	                    if(strlen($excel_age_at_dx)) {
    	                        $excel_age_at_dx_msg = 'Excel age at diagnosis will be used and compared to ATiM data.';
            	                if(strlen($atim_diagnosis_data['dx_date'])) {
            	                    if($atim_diagnosis_data['dx_date'] != $excel_age_at_dx) {
            	                        $age_at_dx_to_compare_to_atim = $excel_age_at_dx;
            	                   }
            	                } else {
            	                    $age_at_dx_to_compare_to_atim = $excel_age_at_dx;
            	                }
    	                    } else {
    	                        $excel_age_at_dx_msg = "No excel age at diagnosis exists. Age at diagnosis won't be a value updated by the process.";
    	                    }
    	                    recordErrorAndMessage(
    	                        'Participant EOC Diagnosis',
    	                        '@@ERROR@@',
    	                        "The age at diagnosis calculated from the date of birth and the date of diagnosis is not correct (dates are probably not chronological). $excel_age_at_dx_msg Please validate.",
    	                        "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
    	                } else {
    	                    $age_at_dx_to_compare_to_atim = $calculated_age_at_dx;
    	                    if(strlen($excel_age_at_dx) && $excel_age_at_dx != $calculated_age_at_dx) {
    	                        recordErrorAndMessage(
    	                            'Participant EOC Diagnosis',
    	                            '@@ERROR@@',
    	                            "The age at diagnosis calculated (from the date of birth and the date of diagnosis) and the age at diagnosis recorded into excel are different. Only the calculated age at diagnosis will be used and compared to ATiM diagnosis data. Please validate the calculated value.",
    	                            "See excel value $excel_age_at_dx and calculated value $calculated_age_at_dx (based on date of bith $next_record_of_date_of_birth and date of diagnosis $next_record_of_eoc_diagnosis_date) for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
    	                    }
    	                }
    	            } else if(strlen($excel_age_at_dx)) {
    	                if($unable_to_calculate_age_at_dx_msg) {
    	                    recordErrorAndMessage(
    	                        'Participant EOC Diagnosis',
    	                        '@@MESSAGE@@',
    	                        "The system is unable to calcualte the age at diagnosis (from the date of birth and the date of diagnosis). $unable_to_calculate_age_at_dx_msg. Excel 'Age at Diagnosis' will be used to manage the update of the diagnosis record.",
    	                        "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
    	                }
    	                $age_at_dx_to_compare_to_atim = $excel_age_at_dx;
    	            } else if($unable_to_calculate_age_at_dx_msg) {
    	                    recordErrorAndMessage(
    	                        'Participant EOC Diagnosis',
    	                        '@@WARNING@@',
    	                        "The system is unable to calcualte the age at diagnosis (from the date of birth and the date of diagnosis). $unable_to_calculate_age_at_dx_msg. No value will be used to manage the update of the diagnosis record. Please validate the dates.",
    	                        "See $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
    	            }
                    if(strlen($age_at_dx_to_compare_to_atim)) {
        	            if(strlen($atim_diagnosis_data['dx_date'])) {
        	                if($atim_diagnosis_data['dx_date'] != $age_at_dx_to_compare_to_atim) {
        	                    $diagnosis_data_to_update['diagnosis_masters']['age_at_dx'] = $age_at_dx_to_compare_to_atim;
        	                }
        	            } else {
        	                $diagnosis_data_to_update['diagnosis_masters']['age_at_dx'] = $age_at_dx_to_compare_to_atim;
        	            }
                    }
                    
                    // Ovarectomy Update
                    //---------------------------------------------------------------------------------------
                    
                    if(strlen($excel_line_clinical_data['ovarectomy']['start_date']['0'])) {
                        $tx_treatment_control_id = $atim_controls['treatment_controls']['EOC-ovarectomy']['id'];
                        $tx_detail_tablename = $atim_controls['treatment_controls']['EOC-ovarectomy']['detail_tablename'];
                        $query = "SELECT tm.participant_id,
                            tm.id AS treatment_master_id,
                            tm.start_date,
                            tm.start_date_accuracy
                            FROM treatment_masters tm
                            WHERE tm.deleted <> 1
                            AND tm.participant_id = $atim_participant_id
                            AND tm.treatment_control_id = $tx_treatment_control_id";
                        $atim_ovarectomy_data = getSelectQueryResult($query);
                        if(!$atim_ovarectomy_data) {
                            $ovarectomy_data_to_create = array(
                                'treatment_masters' => array(
                                    'participant_id' => $atim_participant_id,
                                    'treatment_control_id' => $tx_treatment_control_id,
                                    'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                    'start_date' => $excel_line_clinical_data['ovarectomy']['start_date']['0'],
                                    'start_date_accuracy' => $excel_line_clinical_data['ovarectomy']['start_date']['2'],
                                    'notes' => isset($excel_line_clinical_data['ovarectomy']['notes'])? $excel_line_clinical_data['ovarectomy']['notes']['0'] : ''),
                                $tx_detail_tablename => array());
                            customInsertRecord($ovarectomy_data_to_create);
                            addUpdatedDataToSummary(
                                $participant_identifiers_for_summary, 
                                $excel_file_name_and_line_for_summary, 
                                'Created Ovarectomy', 
                                array('start_date' => $excel_line_clinical_data['ovarectomy']['start_date']['0'], 'start_date_accuracy' => $excel_line_clinical_data['ovarectomy']['start_date']['2']));
                        } elseif (sizeof($atim_ovarectomy_data) > 1) {
                            $atim_ovarectomy_data_msg = array();
                            $date_found = false;
                            foreach($atim_ovarectomy_data as $new_ovarectomy) {
                                $atim_ovarectomy_data_msg[] = $new_ovarectomy['start_date']." (".$new_ovarectomy['start_date_accuracy'].")";
                                if($new_ovarectomy['start_date'] == $excel_line_clinical_data['ovarectomy']['start_date']['0']) {
                                    $date_found = true;
                                }
                            }
                            $atim_ovarectomy_data_msg = implode(' & ', $atim_ovarectomy_data_msg);
                            if(!$date_found) {
                                recordErrorAndMessage(
                                    'Ovarectomy',
                                    '@@ERROR@@',
                                    "More than one participant ovarectomy already exist into ATiM with no one with the excel date. The script won't use the excel data to update ovarectomy or create a new one. Please update data manually after the mirgation process.",
                                    "See excel ovarectomy on ".$excel_line_clinical_data['ovarectomy']['start_date']['0']." (".$excel_line_clinical_data['ovarectomy']['start_date']['2'].") and atim ovarectomy on $atim_ovarectomy_data_msg for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                            } else {
                                recordErrorAndMessage(
                                    'Ovarectomy',
                                    '@@WARNING@@',
                                    "More than one participant ovarectomy already exist into ATiM with at least one date matching the excel date. The script won't use the excel data to update ovarectomy or create a new one. Please update data manually after the mirgation process.",
                                    "See excel ovarectomy on ".$excel_line_clinical_data['ovarectomy']['start_date']['0']." (".$excel_line_clinical_data['ovarectomy']['start_date']['2'].") and atim ovarectomy on $atim_ovarectomy_data_msg for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                            }
                        } else {
                            // One ATiM Ovarectomy detected
                            if($excel_line_clinical_data['ovarectomy']['start_date']['0'] != $atim_ovarectomy_data[0]['start_date']) {
                                $ovarectomy_dates_diff = datesDiff($excel_line_clinical_data['ovarectomy']['start_date']['0'], $atim_ovarectomy_data[0]['start_date'], 'm');
                                if($ovarectomy_dates_diff == '-1') {
                                    $ovarectomy_dates_diff = datesDiff($atim_ovarectomy_data[0]['start_date'], $excel_line_clinical_data['ovarectomy']['start_date']['0'], 'm');
                                }
                                if($ovarectomy_dates_diff) {
                                    // Diff > 1 month
                                    $ovarectomy_data_to_create = array(
                                        'treatment_masters' => array(
                                            'participant_id' => $atim_participant_id,
                                            'treatment_control_id' => $tx_treatment_control_id,
                                            'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                            'start_date' => $excel_line_clinical_data['ovarectomy']['start_date']['0'],
                                            'start_date_accuracy' => $excel_line_clinical_data['ovarectomy']['start_date']['2'],
                                            'notes' => isset($excel_line_clinical_data['ovarectomy']['notes'])? $excel_line_clinical_data['ovarectomy']['notes']['0'] : ''),
                                        $tx_detail_tablename => array());
                                    customInsertRecord($ovarectomy_data_to_create);
                                    addUpdatedDataToSummary(
                                        $participant_identifiers_for_summary, 
                                        $excel_file_name_and_line_for_summary, 
                                        'Created a Second Ovarectomy', 
                                        array('start_date' => $excel_line_clinical_data['ovarectomy']['start_date']['0'], 'start_date_accuracy' => $excel_line_clinical_data['ovarectomy']['start_date']['2']));
                                    recordErrorAndMessage(
                                        'Ovarectomy',
                                        '@@WARNING@@',
                                        "A second participant ovarectomy has been created for participant into ATiM. Please validate.",
                                        "See excel overectomy on ".$excel_line_clinical_data['ovarectomy']['start_date']['0']." (".$excel_line_clinical_data['ovarectomy']['start_date']['2'].") and atim ovarectomy on ".$atim_ovarectomy_data['0']['start_date']." (".$atim_ovarectomy_data['0']['start_date_accuracy'].") for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                                } else {
                                    recordErrorAndMessage(
                                        'Ovarectomy',
                                        '@@WARNING@@',
                                        "ATiM participant ovarectomy and Excel participant ovarectomy are defined has done on two different dates but into the same month. No new ovarectomy will be created but please validate and create second ovarectomy manually after the migration.",
                                        "See excel overectomy on ".$excel_line_clinical_data['ovarectomy']['start_date']['0']." (".$excel_line_clinical_data['ovarectomy']['start_date']['2'].") and atim ovarectomy on ".$atim_ovarectomy_data['0']['start_date']." (".$atim_ovarectomy_data['0']['start_date_accuracy'].") for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                                }                            
                            } else if($excel_line_clinical_data['ovarectomy']['start_date']['2'] != $atim_ovarectomy_data[0]['start_date_accuracy']) {
                                recordErrorAndMessage(
                                    'Ovarectomy',
                                    '@@WARNING@@',
                                    "Excel and ATiM ovarectomy date accuracy mismatch. ATiM ovarectomy date won't be updated. Please validate.",
                                    "See excel overectomy on ".$excel_line_clinical_data['ovarectomy']['start_date']['0']." (".$excel_line_clinical_data['ovarectomy']['start_date']['2'].") and atim ovarectomy on ".$atim_ovarectomy_data['0']['start_date']." (".$atim_ovarectomy_data['0']['start_date_accuracy'].") for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                            }
                        }
                    }
                    
                    // Recurrence
                    //---------------------------------------------------------------------------------------
                    
                    $dx_recurrence_diagnosis_control_id = $atim_controls['diagnosis_controls']['secondary - distant-recurrence or metastasis']['id'];
                    $dx_recurrence_detail_tablename = $atim_controls['diagnosis_controls']['secondary - distant-recurrence or metastasis']['detail_tablename'];
                    
                    if(strlen($excel_line_clinical_data['recurrence']['ca125_recurrence_date']['0'])) {
                        $query = "SELECT id, dx_date, dx_date_accuracy, qc_tf_progression_detection_method, qc_tf_tumor_site
                            FROM diagnosis_masters
                            WHERE deleted <> 1
                            AND participant_id = $atim_participant_id
                            AND parent_id = $dx_eoc_diagnosis_master_id
                            AND diagnosis_control_id = $dx_recurrence_diagnosis_control_id
                            AND qc_tf_progression_detection_method = 'ca125'
                            AND dx_date = '".$excel_line_clinical_data['recurrence']['ca125_recurrence_date']['0']."'";
                        $atim_secondary_diagnosis_data = getSelectQueryResult($query);
                        if(!$atim_secondary_diagnosis_data) {
                            $atim_secondary_diagnosis_data_to_create = array(
                                'diagnosis_masters' => array(
                                    'participant_id' => $atim_participant_id,
                                    'diagnosis_control_id' => $dx_recurrence_diagnosis_control_id,
                                    'primary_id' => $dx_eoc_diagnosis_master_id,
                                    'parent_id' => $dx_eoc_diagnosis_master_id,
                                    'dx_date' => $excel_line_clinical_data['recurrence']['ca125_recurrence_date']['0'],
                                    'dx_date_accuracy' => $excel_line_clinical_data['recurrence']['ca125_recurrence_date']['2'],
                                    'qc_tf_progression_detection_method' => 'ca125',
                                    'qc_tf_tumor_site' => 'unknown',
                                    'notes' => isset($excel_line_clinical_data['recurrence']['notes'])? $excel_line_clinical_data['recurrence']['notes']['0'] : ''),
                                $dx_recurrence_detail_tablename => array());
                            customInsertRecord($atim_secondary_diagnosis_data_to_create);
                            addUpdatedDataToSummary(
                                $participant_identifiers_for_summary, 
                                $excel_file_name_and_line_for_summary, 
                                'Created EOC Diagnosis Recurrence With Ca125 Detection Method', 
                                array('dx_date' => $excel_line_clinical_data['recurrence']['ca125_recurrence_date']['0'], 'dx_date_accuracy' => $excel_line_clinical_data['recurrence']['ca125_recurrence_date']['2']));
                        } else if(sizeof($atim_secondary_diagnosis_data) == 1) {
                            // Process won't check if the accuracy has to be updated...
                        } else {
                            $atim_secondary_diagnosis_data_msg = array();
                            foreach($atim_secondary_diagnosis_data as $new_atim_secondary_diagnosis_data) {
                                $atim_secondary_diagnosis_data_msg[$new_atim_secondary_diagnosis_data['qc_tf_tumor_site']] = '<b>'.$new_atim_secondary_diagnosis_data['qc_tf_tumor_site'].'</b>';
                            }
                            $atim_secondary_diagnosis_data_msg = implode(' & ', $atim_secondary_diagnosis_data_msg);
                            recordErrorAndMessage(
                                'EOC Diagnosis Recurrence',
                                '@@WARNING@@',
                                "More than one EOC diagnosis recurrence with CA125 detection method exist at the same date into ATiM. No new one will be created. Please clean up data into ATiM manually after the migration if required.",
                                "See all ATiM CA125 recurrences on ".$excel_line_clinical_data['recurrence']['ca125_recurrence_date']['0']." (".$excel_line_clinical_data['recurrence']['ca125_recurrence_date']['2'].") with sites set to $atim_secondary_diagnosis_data_msg for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                        }
                    }
                    
                    if(strlen($excel_line_clinical_data['recurrence']['recurrence_date']['0'])) {
                        if(strlen($excel_line_clinical_data['recurrence']['ca125_recurrence_date']['0'])  && $excel_line_clinical_data['recurrence']['ca125_recurrence_date']['0'] == $excel_line_clinical_data['recurrence']['recurrence_date']['0']) {
                            recordErrorAndMessage(
                                'EOC Diagnosis Recurrence',
                                '@@MESSAGE@@',
                                "Both recurrence and CA125 recurrence are defined into the excel for the same date. Only CA125 recurrence data will be used for the ATiM data update.",
                                "See ATiM CA125 recurrence on ".$excel_line_clinical_data['recurrence']['ca125_recurrence_date']['0']." (".$excel_line_clinical_data['recurrence']['ca125_recurrence_date']['2'].") for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                        } else {
                            $query = "SELECT id, dx_date, dx_date_accuracy, qc_tf_progression_detection_method, qc_tf_tumor_site
                                FROM diagnosis_masters
                                WHERE deleted <> 1
                                AND participant_id = $atim_participant_id
                                AND parent_id = $dx_eoc_diagnosis_master_id
                                AND diagnosis_control_id = $dx_recurrence_diagnosis_control_id
                                AND qc_tf_progression_detection_method != 'ca125'
                                AND dx_date = '".$excel_line_clinical_data['recurrence']['recurrence_date']['0']."'";
                            $atim_secondary_diagnosis_data = getSelectQueryResult($query);
                            if(!$atim_secondary_diagnosis_data) {
                                $atim_secondary_diagnosis_data_to_create = array(
                                    'diagnosis_masters' => array(
                                        'participant_id' => $atim_participant_id,
                                        'diagnosis_control_id' => $dx_recurrence_diagnosis_control_id,
                                        'primary_id' => $dx_eoc_diagnosis_master_id,
                                        'parent_id' => $dx_eoc_diagnosis_master_id,
                                        'dx_date' => $excel_line_clinical_data['recurrence']['recurrence_date']['0'],
                                        'dx_date_accuracy' => $excel_line_clinical_data['recurrence']['recurrence_date']['2'],
                                        'qc_tf_progression_detection_method' => 'unknown',
                                        'qc_tf_tumor_site' => 'unknown',
                                        'notes' => isset($excel_line_clinical_data['recurrence']['notes'])? $excel_line_clinical_data['recurrence']['notes']['0'] : ''),
                                    $dx_recurrence_detail_tablename => array());
                                customInsertRecord($atim_secondary_diagnosis_data_to_create);
                                addUpdatedDataToSummary(
                                    $participant_identifiers_for_summary,
                                    $excel_file_name_and_line_for_summary,
                                    "Created EOC Diagnosis Recurrence With Detection Method 'Unknown'",
                                    array('dx_date' => $excel_line_clinical_data['recurrence']['recurrence_date']['0'], 'dx_date_accuracy' => $excel_line_clinical_data['recurrence']['recurrence_date']['2']));
                            } else if(sizeof($atim_secondary_diagnosis_data) == 1) {
                                // Process won't check if the accuracy has to be updated...
                            } else {
                                $atim_secondary_diagnosis_data_msg = array();
                                foreach($atim_secondary_diagnosis_data as $new_atim_secondary_diagnosis_data) {
                                    $atim_secondary_diagnosis_data_msg[$new_atim_secondary_diagnosis_data['qc_tf_progression_detection_method'].' - '.$new_atim_secondary_diagnosis_data['qc_tf_tumor_site']] =  "detection method <b>".$new_atim_secondary_diagnosis_data['qc_tf_progression_detection_method']."</b> and site <b>".$new_atim_secondary_diagnosis_data['qc_tf_tumor_site'] . "</b>";
                                }
                                $atim_secondary_diagnosis_data_msg = implode(' <br> ... ', $atim_secondary_diagnosis_data_msg);
                                recordErrorAndMessage(
                                    'EOC Diagnosis Recurrence',
                                    '@@WARNING@@',
                                    "More than one EOC diagnosis recurrence with detection method different than 'CA125' exist into ATiM at the same date defined into excel. No new recurrence with method and site equal to 'unknown' will be created into ATiM. Please clean up data into ATiM manually after the migration.",
                                    "See ATiM Recurrence on ".$excel_line_clinical_data['recurrence']['recurrence_date']['0']." (".$excel_line_clinical_data['recurrence']['recurrence_date']['2'].") with following properties <br> ... $atim_secondary_diagnosis_data_msg <br>for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                            }
                        }
                    }
                    
                    //.......................................................................................
                    // Treatment/Events
                    //.......................................................................................
                    
                    if(isset($all_excel_clinical_events_treatments_records[$qc_tf_bank_identifier])) {
                        foreach($all_excel_clinical_events_treatments_records[$qc_tf_bank_identifier] as $new_excel_clinical_event) {
                            list($new_excel_clinical_event_data, $treatment_event_excel_file_name_and_line_for_summary) = $new_excel_clinical_event;
                            $new_excel_clinical_event_data = $new_excel_clinical_event_data['event'];
                            //Date management
                            //... start date
                            $excel_start_date = $new_excel_clinical_event_data['start_date'][0];
                            $excel_start_date_for_search = $excel_start_date;
                            $excel_start_date_accuracy = $new_excel_clinical_event_data['start_date'][2];
                            if(strlen($new_excel_clinical_event_data['start_date_accuracy'][0]) && in_array($new_excel_clinical_event_data['start_date_accuracy'][0], array('c', 'm', 'd', 'y'))) {
                                $excel_start_date_accuracy_from_accuracy_column = str_replace(array('m', 'y'), array('d', 'm'), $new_excel_clinical_event_data['start_date_accuracy'][0]);
                                if(($excel_start_date_accuracy == 'd' && in_array($excel_start_date_accuracy_from_accuracy_column, array('c', 'm'))) ||
                                ($excel_start_date_accuracy == 'm' && $excel_start_date_accuracy_from_accuracy_column == 'c')) {
                                    recordErrorAndMessage(
                                        'Participant Treatment/Event',
                                        '@@WARNING@@',
                                        "Treatment/Event start date accuracy based on excel field '".$new_excel_clinical_event_data['start_date'][1]."' is less than accuracy defined into excel field '".$new_excel_clinical_event_data['start_date_accuracy'][1]."'. The accuracy of the first field will be used for the data check and update. Please validate and add data manually into ATiM if required.",
                                        "See kept accuracy '$excel_start_date_accuracy' from date and excel accuracy field value '$excel_start_date_accuracy_from_accuracy_column' for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                } else {
                                    $excel_start_date_accuracy = $excel_start_date_accuracy_from_accuracy_column;
                                }
                            }
                            if($excel_start_date_accuracy == 'm') {
                                $excel_start_date_for_search = substr($excel_start_date_for_search, 0, 4).'%';
                            } else if($excel_start_date_accuracy == 'd') {
                                $excel_start_date_for_search = substr($excel_start_date_for_search, 0, 7).'%';
                            } else {
                                $excel_start_date_accuracy == 'c';
                            }
                            //... finish date
                            $excel_finish_date = $new_excel_clinical_event_data['finish_date'][0];
                            $excel_finish_date_accuracy = $new_excel_clinical_event_data['finish_date'][2];
                            if(strlen($new_excel_clinical_event_data['finish_date_accuracy'][0]) && in_array($new_excel_clinical_event_data['finish_date_accuracy'][0], array('c', 'm', 'd', 'y'))) {
                                $excel_finish_date_accuracy_from_accuracy_column = str_replace(array('m', 'y'), array('d', 'm'), $new_excel_clinical_event_data['finish_date_accuracy'][0]);
                                if(($excel_finish_date_accuracy == 'd' && in_array($excel_finish_date_accuracy_from_accuracy_column, array('c', 'm'))) ||
                                ($excel_finish_date_accuracy == 'm' && $excel_finish_date_accuracy_from_accuracy_column == 'c')) {
                                    recordErrorAndMessage(
                                        'Participant Treatment/Event',
                                        '@@WARNING@@',
                                        "Treatment/Event finish date accuracy based on excel field '".$new_excel_clinical_event_data['finish_date'][1]."' is less than accuracy defined into excel field '".$new_excel_clinical_event_data['finish_date_accuracy'][1]."'. The accuracy of the first field will be used for the data check and update. Please validate and add data manually into ATiM if required.",
                                        "See kept accuracy '$excel_finish_date_accuracy' from date and excel accuracy field value '$excel_finish_date_accuracy_from_accuracy_column' for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                } else {
                                    $excel_finish_date_accuracy = $excel_finish_date_accuracy_from_accuracy_column;
                                }
                            }
                            if(!$excel_finish_date_accuracy) {
                                $excel_finish_date_accuracy = 'c';
                            }
                            if(!strlen($excel_start_date))  {
                                $excel_completed_data = array();
                                $treatment_event_type = 'unknown';
                                foreach($new_excel_clinical_event_data as $tmp_db_field => $tmp_excel_field_detail) {
                                    if(strlen($tmp_excel_field_detail[0])) {
                                        if($tmp_db_field == 'type') {
                                            $treatment_event_type = $tmp_excel_field_detail[0];
                                        } else if($tmp_db_field != 'qc_tf_bank_identifier') {
                                            $excel_completed_data[] = $tmp_excel_field_detail[1]." = '".$tmp_excel_field_detail[0]."'";
                                        }
                                    }
                                }
                                if(sizeof($excel_completed_data)) {
                                    $excel_completed_data = implode(' <br> ... ', $excel_completed_data);
                                    recordErrorAndMessage(
                                        'Participant Treatment/Event',
                                        '@@ERROR@@',
                                        "The '$treatment_event_type' treatment/Event start date is not defined into Excel. No data of the line will be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                        "See line data <br> ... $excel_completed_data <br> for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                }
                            } else {
                                switch(strtolower($new_excel_clinical_event_data['type'][0])) {
                                    
                                    // Empty type
                                    //---------------------------------------------------------------------------------------
                                    case '':
                                        $excel_completed_data = array();
                                        foreach($new_excel_clinical_event_data as $tmp_db_field => $tmp_excel_field_detail) {
                                            if(strlen($tmp_excel_field_detail[0])) {
                                                if($tmp_db_field != 'qc_tf_bank_identifier') {
                                                    $excel_completed_data[] = $tmp_excel_field_detail[1]." = '".$tmp_excel_field_detail[0]."'";
                                                }
                                            }
                                        }
                                        if(sizeof($excel_completed_data)) {
                                            $excel_completed_data = implode(' <br> ... ', $excel_completed_data);
                                            recordErrorAndMessage(
                                                'Participant Treatment/Event',
                                                '@@ERROR@@',
                                                "No treatment/event type is defined into Excel. No data of the line will be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                                "See line data <br> ... $excel_completed_data <br> for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                        break;
                                    
                                    // Chemotherapy
                                    //---------------------------------------------------------------------------------------
                                    case 'chemotherapy':
                                    case 'chimiotherapy':
                                        //Check wrong field completed
                                        $wrong_field_completed = array();
                                        foreach(array('ct_scan', 'ca125') as $wrong_field) {
                                            if(strlen($new_excel_clinical_event_data[$wrong_field][0])) {
                                                $wrong_field_completed[] = $new_excel_clinical_event_data[$wrong_field][1].' = '.$new_excel_clinical_event_data[$wrong_field][0];
                                            }
                                        }
                                        if($wrong_field_completed) {
                                            recordErrorAndMessage(
                                                'Participant Treatment/Event',
                                                '@@ERROR@@',
                                                "Wrong Treatment/Event field(s) completed for an EOC chemotherapy. The data of the field won't be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                                "See value(s) ".implode(' & ', $wrong_field_completed)." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                        //check excel drug
                                        $wrong_atim_drugs = array();
                                        $excel_drugs_array = array();
                                        for($drug_id = 1; $drug_id < 5; $drug_id++) {
                                            $excel_drug = strtolower($new_excel_clinical_event_data["drug_$drug_id"][0]);
                                            if(strlen($excel_drug)) {
                                                $excel_drug = trim($excel_drug);
                                                $atim_drug = '';
                                                switch($excel_drug) {
                                                    case 'carbo':
                                                    case 'carboplatin':
                                                    case 'carbopatinum':
                                                        $atim_drug = 'carboplatinum';
                                                        break;
                                                    case 'doxorubcin':
                                                    case 'doxo':
                                                    case 'doxyrubicin':
                                                    case 'caelyx':
                                                        $atim_drug = 'doxorubicin';
                                                        break;
                                                    case 'docetaxel':
                                                        $atim_drug = 'doxetaxel';
                                                        break;
                                                    case '':
                                                        $atim_drug = '';
                                                        break;
                                                    case 'cisp':
                                                    case 'cisplatin':
                                                    case 'cis':
                                                        $atim_drug = 'cisplatinum';
                                                        break;
                                                    case 'gemcitabin':
                                                    case 'germcitabine':
                                                    case 'gem':
                                                        $atim_drug = 'gemcitabine';
                                                        break;
                                                    case 'taxol':
                                                        $atim_drug = 'paclitaxel';
                                                        break;
                                                    case 'topetecan':
                                                    case 'toptecan':
                                                        $atim_drug = 'topotecan';
                                                        break;                                                    
                                                }
                                                if($atim_drug) {
                                                    recordErrorAndMessage(
                                                        'Participant Treatment/Event',
                                                        '@@WARNING@@',
                                                        "Replaced Excel drug name by the ATiM drug name. Please confirme.",
                                                        "See excel value '$excel_drug' replaced by '$atim_drug'.", $excel_drug.'='.$atim_drug);
                                                    $excel_drug = $atim_drug;
                                                }
                                                if(array_key_exists($excel_drug, $atim_drugs)) {
                                                    $excel_drugs_array[$excel_drug] = $atim_drugs[$excel_drug];
                                                } else {
                                                    $wrong_atim_drugs[] = "<b>".$excel_drug."</b>";
                                               }
                                            }
                                        }
                                        ksort($excel_drugs_array);
                                        $drug_strg_separator = ' ### ';
                                        $excel_drugs_array = array_flip($excel_drugs_array);
                                        if($wrong_atim_drugs) {
                                            recordErrorAndMessage('Participant Treatment/Event',
                                                '@@ERROR@@',
                                                "The EOC chemotherapy Drug is not a drug defined into ATiM. The drug won't be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                                "See drug(s) ".implode(' & ', $wrong_atim_drugs)." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                        //Check EOC chemotherapy exists based on start date only
                                        $tx_method = 'EOC-chemotherapy';
                                        $tx_treatment_control_id = $atim_controls['treatment_controls'][$tx_method]['id'];
                                        $tx_detail_tablename = $atim_controls['treatment_controls'][$tx_method]['detail_tablename'];
                                        $tx_treatment_extend_control_id = $atim_controls['treatment_controls'][$tx_method]['treatment_extend_control_id'];
                                        $tx_extend_detail_tablename = $atim_controls['treatment_controls'][$tx_method]['treatment_extend_detail_tablename'];
                                        $query = "SELECT tm.participant_id,
                                			tm.id AS treatment_master_id,
                                			tm.start_date,
                                			tm.start_date_accuracy,
                                			tm.finish_date,
                                			tm.finish_date_accuracy,
                                			GROUP_CONCAT(DISTINCT dr.generic_name  ORDER BY dr.generic_name SEPARATOR '$drug_strg_separator') as drugs
                                			FROM treatment_masters tm
                                			INNER JOIN $tx_detail_tablename td ON tm.id = td.treatment_master_id
                                			LEFT JOIN treatment_extend_masters tem ON tem.treatment_master_id = tm.id AND tem.deleted <> 1 AND tem.treatment_extend_control_id = $tx_treatment_extend_control_id
                                			LEFT JOIN drugs dr ON dr.id = tem.drug_id AND dr.deleted <> 1
                                			WHERE tm.deleted <> 1 
                                            AND tm.treatment_control_id  = $tx_treatment_control_id
                                            AND tm.start_date LIKE '$excel_start_date_for_search'
                                            AND (".(in_array($excel_start_date_accuracy, array('m', 'd'))? "tm.start_date_accuracy = '$excel_start_date_accuracy'" : "tm.start_date_accuracy IN ('c', '')").")
                                            AND tm.participant_id = $atim_participant_id
                                            GROUP BY tm.participant_id, tm.id, tm.start_date, tm.start_date_accuracy, tm.finish_date, tm.finish_date_accuracy;";
                                        $atim_treatment_data = getSelectQueryResult($query);
                                        if(!$atim_treatment_data) {
                                            // No chemo strated at the defined excel date exists into ATiM. A new chemotherapy will be created
                                            $atim_treatment_data_to_create = array(
                                                'treatment_masters' => array(
                                                    'participant_id' => $atim_participant_id,
                                                    'treatment_control_id' => $tx_treatment_control_id,
                                                    'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                                    'start_date' => $excel_start_date,
                                                    'start_date_accuracy' => $excel_start_date_accuracy,
                                                    'finish_date' => $excel_finish_date,
                                                    'finish_date_accuracy' => ($excel_finish_date? $excel_finish_date_accuracy : ''),
                                                    'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''),
                                                $tx_detail_tablename => array());
                                            $atim_treatment_master_id = customInsertRecord($atim_treatment_data_to_create);
                                            foreach($excel_drugs_array as $drug_id => $drug_name) {
                                                $atim_treatment_extend_data_to_create = array(
                                                    'treatment_extend_masters' => array(
                                                        'treatment_master_id' => $atim_treatment_master_id,
                                                        'treatment_extend_control_id' => $tx_treatment_extend_control_id,
                                                        'drug_id' => $drug_id),
                                                    $tx_extend_detail_tablename => array());
                                                customInsertRecord($atim_treatment_extend_data_to_create);
                                            }
                                            addUpdatedDataToSummary(
                                                $participant_identifiers_for_summary,
                                                $excel_file_name_and_line_for_summary,
                                                "Created New EOC Chemotherapy",
                                                array(
                                                    'start_date' => $excel_start_date,
                                                    'start_date_accuracy' => $excel_start_date_accuracy,
                                                    'finish_date' => $excel_finish_date,
                                                    'finish_date_accuracy' => ($excel_finish_date? $excel_finish_date_accuracy : ''),
                                                    'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : '',
                                                    'drugs' => implode(' & ', $excel_drugs_array)));
                                        } else if(sizeof($atim_treatment_data) == 1) {
                                            // Only one EOC chemo strated at the defined excel date exists into ATiM
                                            $atim_treatment_data = $atim_treatment_data[0];
                                            $excel_drugs_strg = implode($drug_strg_separator, $excel_drugs_array);
                                            $atim_drugs_strg = $atim_treatment_data['drugs'];
                                            if($excel_drugs_strg == $atim_drugs_strg) {
                                                // Only one EOC chemo strated at the defined excel date exists into ATiM and the list of drugs are exactly the same.
                                                if($excel_finish_date && ($atim_treatment_data['finish_date'] != $excel_finish_date || $atim_treatment_data['finish_date_accuracy'] != $excel_finish_date_accuracy)) {
                                                    // Excel Finish Date is set : Update the finish date
                                                    updateTableData(
                                                        $atim_treatment_data['treatment_master_id'], 
                                                        array(
                                                            'treatment_masters' => array(
                                                                'finish_date' => $excel_finish_date,
                                                                'finish_date_accuracy' => $excel_finish_date_accuracy),
                                                            $tx_extend_detail_tablename => array()));
                                                     addUpdatedDataToSummary(
                                                         $participant_identifiers_for_summary,
                                                         $excel_file_name_and_line_for_summary,
                                                         "Updated Finishing Date to an Existing EOC Chemotherapy",
                                                         array(
                                                            'atim chemo from' => $excel_start_date.' ('.$excel_start_date_accuracy.')',
                                                            'to' => $atim_treatment_data['finish_date'].' ('.$atim_treatment_data['finish_date_accuracy'].')',
                                                            'with drugs ' => $atim_drugs_strg,
                                                            'new finishing date' => "$excel_finish_date ($excel_finish_date_accuracy)"));
                                                }
                                                if(isset($new_excel_clinical_event_data['notes'][0]) && strlen($new_excel_clinical_event_data['notes'][0])) {
                                                    recordErrorAndMessage('Participant Treatment/Event',
                                                        '@@WARNING@@',
                                                        "An note from excel or script for an updated EOC chemotherapy has not been migrated. Please validate and add data manually into ATiM if required.",
                                                        "See note(s) ".$new_excel_clinical_event_data['notes'][0]." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                                    
                                                }
                                            } else {
                                                // Only one EOC chemo strated at the defined excel date exists into ATiM but the list of drugs are not exactly the same.
                                                if($excel_finish_date && $atim_treatment_data['finish_date'] == $excel_finish_date && $atim_treatment_data['finish_date_accuracy'] == $excel_finish_date_accuracy) {
                                                    // The EOC chemo finish dates are exactly the same into ATiM and Excel. Compare drugs and add new drug. 
                                                    if($excel_drugs_array) {
                                                        // Same finish date... add new drugs plus generate msg for mismatchs
                                                        $atim_treatment_master_id = $atim_treatment_data['treatment_master_id'];
                                                        $atim_drugs_array = explode($drug_strg_separator, $atim_treatment_data['drugs']);
                                                        $created_drugs = array();
                                                        foreach($excel_drugs_array as $drug_id => $new_excel_drug) {
                                                            if(!in_array($new_excel_drug, $atim_drugs_array)) {
                                                                $created_drugs[$new_excel_drug] = $new_excel_drug;
                                                                $atim_treatment_extend_data_to_create = array(
                                                                    'treatment_extend_masters' => array(
                                                                        'treatment_master_id' => $atim_treatment_master_id,
                                                                        'treatment_extend_control_id' => $tx_treatment_extend_control_id,
                                                                        'drug_id' => $drug_id),
                                                                    $tx_extend_detail_tablename => array());
                                                                customInsertRecord($atim_treatment_extend_data_to_create);
                                                            } 
                                                        }
                                                        if($created_drugs) {
                                                            //update message
                                                            addUpdatedDataToSummary(
                                                                $participant_identifiers_for_summary,
                                                                $excel_file_name_and_line_for_summary,
                                                                "Added New Drug(s) to an Existing EOC Chemotherapy",
                                                                array(
                                                                    'atim chemo from' => $excel_start_date.' ('.$excel_start_date_accuracy.') ',
                                                                    'to' => $excel_finish_date.' ('.$excel_finish_date_accuracy.')',
                                                                    'with drugs ' => implode(' & ', $atim_drugs_array),
                                                                    'new drugs' => implode(' & ', $created_drugs)));
                                                        }
                                                        $atim_drugs_not_in_excel_array = array();
                                                        foreach($atim_drugs_array as $new_atim_drug) {
                                                            if(!in_array($new_atim_drug, $excel_drugs_array)) {
                                                                $atim_drugs_not_in_excel_array[$new_atim_drug] = $new_atim_drug; 
                                                            }
                                                        }
                                                        if($atim_drugs_not_in_excel_array) {
                                                            if($created_drugs) {
                                                            //Drug not found into excel
                                                            recordErrorAndMessage(
                                                                'Participant Treatment/Event',
                                                                '@@WARNING@@',
                                                                "System added new drug(s) to an existing EOC chemotherapy (matching on start and finish dates) but some existing drugs already recorded into ATiM were not listed into the excel. Please validate and clean up data manually into ATiM if required.",
                                                                "Compare ATiM drugs <b>".implode(' & ', $atim_drugs_array)."</b> and excel drugs <b>".implode(' & ', $excel_drugs_array)."</b> for the EOC chemo started on $excel_start_date ($excel_start_date_accuracy) and finished on $excel_finish_date ($excel_finish_date_accuracy) for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                                            } else {
                                                                recordErrorAndMessage(
                                                                    'Participant Treatment/Event',
                                                                    '@@WARNING@@',
                                                                    "An existing ATiM EOC chemotherapy matches excel chemotherapy on dates but some existing drugs already recorded into ATiM were not listed into the excel. Please validate and clean up data manually into ATiM if required.",
                                                                    "Compare ATiM drugs <b>".implode(' & ', $atim_drugs_array)."</b> and excel drugs <b>".implode(' & ', $excel_drugs_array)."</b> for the EOC chemo started on $excel_start_date ($excel_start_date_accuracy) and finished on $excel_finish_date ($excel_finish_date_accuracy) for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary."); 
                                                            }
                                                        }
                                                    }
                                                    if(isset($new_excel_clinical_event_data['notes'][0]) && strlen($new_excel_clinical_event_data['notes'][0])) {
                                                        recordErrorAndMessage('Participant Treatment/Event',
                                                            '@@WARNING@@',
                                                            "An note from excel or script for an updated EOC chemotherapy has not been migrated. Please validate and add data manually into ATiM if required.",
                                                            "See note(s) ".$new_excel_clinical_event_data['notes'][0]." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                                        
                                                    }
                                                } else {
                                                    // Only one EOC chemo strated at the defined excel date exists into ATiM but the list of drugs are not exactly the same
                                                    // and either the excel finish date is not set or finish dates are different
                                                    // --> New EOC chemotherapy will be created and a message will inform users
                                                    $atim_treatment_data_to_create = array(
                                                        'treatment_masters' => array(
                                                            'participant_id' => $atim_participant_id,
                                                            'treatment_control_id' => $tx_treatment_control_id,
                                                            'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                                            'start_date' => $excel_start_date,
                                                            'start_date_accuracy' => $excel_start_date_accuracy,
                                                            'finish_date' => $excel_finish_date,
                                                            'finish_date_accuracy' => ($excel_finish_date? $excel_finish_date_accuracy : ''),
                                                            'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''),
                                                        $tx_detail_tablename => array());
                                                    $atim_treatment_master_id = customInsertRecord($atim_treatment_data_to_create);
                                                    foreach($excel_drugs_array as $drug_id => $drug_name) {
                                                        $atim_treatment_extend_data_to_create = array(
                                                            'treatment_extend_masters' => array(
                                                                'treatment_master_id' => $atim_treatment_master_id,
                                                                'treatment_extend_control_id' => $tx_treatment_extend_control_id,
                                                                'drug_id' => $drug_id),
                                                            $tx_extend_detail_tablename => array());
                                                        customInsertRecord($atim_treatment_extend_data_to_create);
                                                    }
                                                    addUpdatedDataToSummary(
                                                        $participant_identifiers_for_summary,
                                                        $excel_file_name_and_line_for_summary,
                                                        "Created New EOC Chemotherapy",
                                                        array(
                                                            'start_date' => $excel_start_date,
                                                            'start_date_accuracy' => $excel_start_date_accuracy,
                                                            'finish_date' => $excel_finish_date,
                                                            'finish_date_accuracy' => ($excel_finish_date? $excel_finish_date_accuracy : ''),
                                                            'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : '',
                                                            'drugs' => implode(' & ', $excel_drugs_array)));
                                                    // --> Generate Message
                                                    recordErrorAndMessage(
                                                        'Participant Treatment/Event',
                                                        '@@WARNING@@',
                                                        "Both ATim and Excel EOC chemotherapy start at the same date but both finish date and the drugs list are not the exaclty the same. A second EOC chemoatherapy has been created. Please validate that it's not the same chemotherapy and clean up data manually into ATiM if required.",
                                                        "Compare ATiM chemotherapy from $excel_start_date ($excel_start_date_accuracy) to ". (empty($atim_treatment_data['finish_date'])? "unknown finishing date" : ($atim_treatment_data['finish_date'] . " (" . $atim_treatment_data['finish_date_accuracy'] . ")")) . " with drug(s) " . str_replace($drug_strg_separator, ' & ', $atim_treatment_data['drugs']) .
                                                        " and Excel chemotherapy from same date to " . (empty($excel_finish_date)? "unknown finishing date" : "$excel_finish_date ($excel_finish_date_accuracy)") . " with drug(s) " . implode(' & ', $excel_drugs_array) .
                                                        " for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                                }
                                            }
                                        } else {
                                            // Many EOC chemo started at the defined excel date exists into ATiM
                                            $tmp_atim_tx_strg = array();
                                            foreach($atim_treatment_data as $tmp_new_atim_treatment) {
                                                $tmp_atim_tx_strg[] = "from same date to <b>". (empty($tmp_new_atim_treatment['finish_date'])? "unknown finishing date" : ($tmp_new_atim_treatment['finish_date'] . " (" . $tmp_new_atim_treatment['finish_date_accuracy'] . ")")) . "</b> with ".(empty($tmp_new_atim_treatment['drugs'])? 'no drug': "drug(s) <b>" . str_replace($drug_strg_separator, ' & ', $tmp_new_atim_treatment['drugs']).'</b>');
                                            }
                                            $tmp_atim_tx_strg = implode(' <br> . . . ', $tmp_atim_tx_strg);
                                            recordErrorAndMessage(
                                                'Participant Treatment/Event',
                                                '@@WARNING@@',
                                                "Two ATim chemotherapy start at the same date than the Excel EOC chemotherapy. No new EOC chemoatherapy has been created. Please validate that all chemos are not the same chemotherapy and clean up data manually into ATiM if required.",
                                                "Compare Excel chemotherapy from $excel_start_date ($excel_start_date_accuracy) date to <b>" . (empty($excel_finish_date)? "unknown finishing date" : "$excel_finish_date ($excel_finish_date_accuracy)") . "</b> with ".(empty($excel_drugs_array)? 'no drug' : "drug(s) <b>" . implode(' & ', $excel_drugs_array) . '</b>').
                                                " and ATiM chemotherapy <br> . . . $tmp_atim_tx_strg ".
                                                "<br>for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                        break;
                                    
                                    // Ovarectomy from event
                                    //---------------------------------------------------------------------------------------
                                    case 'surgery(ovarectomy)':
                                        //Check wrong field completed
                                        $wrong_field_completed = array();
                                        foreach(array('ct_scan', 'ca125', 'drug_1', 'drug_2', 'drug_3', 'drug_4', 'finish_date') as $wrong_field) {
                                            if(strlen($new_excel_clinical_event_data[$wrong_field][0])) {
                                                $wrong_field_completed[] = $new_excel_clinical_event_data[$wrong_field][1].' = '.$new_excel_clinical_event_data[$wrong_field][0];
                                            }
                                        }
                                        if($wrong_field_completed) {
                                            recordErrorAndMessage(
                                                'Participant Treatment/Event',
                                                '@@ERROR@@',
                                                "Wrong Treatment/Event field(s) completed for an ovarectomy. The data of the field won't be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                                "See value(s) ".implode(' & ', $wrong_field_completed)." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                        $tx_treatment_control_id = $atim_controls['treatment_controls']['EOC-ovarectomy']['id'];
                                        $tx_detail_tablename = $atim_controls['treatment_controls']['EOC-ovarectomy']['detail_tablename'];
                                        $query = "SELECT tm.participant_id,
                                            tm.id AS treatment_master_id,
                                            tm.start_date,
                                            tm.start_date_accuracy
                                            FROM treatment_masters tm
                                            WHERE tm.deleted <> 1
                                            AND tm.participant_id = $atim_participant_id
                                            AND tm.treatment_control_id = $tx_treatment_control_id";
                                        $atim_ovarectomy_data = getSelectQueryResult($query);
                                        if(!$atim_ovarectomy_data) {
                                            $ovarectomy_data_to_create = array(
                                                'treatment_masters' => array(
                                                    'participant_id' => $atim_participant_id,
                                                    'treatment_control_id' => $tx_treatment_control_id,
                                                    'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                                    'start_date' => $excel_start_date,
                                                    'start_date_accuracy' => $excel_start_date_accuracy,
                                                    'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''),
                                                $tx_detail_tablename => array());
                                            customInsertRecord($ovarectomy_data_to_create);
                                            addUpdatedDataToSummary(
                                                $participant_identifiers_for_summary,
                                                $treatment_event_excel_file_name_and_line_for_summary,
                                                'Created Ovarectomy (from event worksheet)',
                                                array('start_date' => $excel_start_date, 'start_date_accuracy' => $excel_start_date_accuracy, 'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''));
                                        } elseif (sizeof($atim_ovarectomy_data) > 1) {
                                            $atim_ovarectomy_data_msg = array();
                                            $date_found = false;
                                            foreach($atim_ovarectomy_data as $new_ovarectomy) {
                                                $atim_ovarectomy_data_msg[] = $new_ovarectomy['start_date']." (".$new_ovarectomy['start_date_accuracy'].")";
                                                if($new_ovarectomy['start_date'] == $excel_start_date) {
                                                    $date_found = true;
                                                }
                                            }
                                            $atim_ovarectomy_data_msg = implode(' & ', $atim_ovarectomy_data_msg);
                                            if(!$date_found) {
                                                recordErrorAndMessage(
                                                    'Participant Treatment/Event',
                                                    '@@ERROR@@',
                                                    "More than one participant ovarectomy already exist into ATiM with no one with the excel date. The script won't use the excel data to update ovarectomy or create a new one. Please update data manually after the mirgation process if required.",
                                                    "See excel ovarectomy on ".$excel_start_date." (".$excel_start_date_accuracy.") and atim ovarectomy on $atim_ovarectomy_data_msg for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                            } else {
                                                recordErrorAndMessage(
                                                    'Participant Treatment/Event',
                                                    '@@WARNING@@',
                                                    "More than one participant ovarectomy already exist into ATiM with at least one date matching the excel date. The script won't use the excel data to update ovarectomy or create a new one. Please update data manually after the mirgation process if required.",
                                                    "See excel ovarectomy on ".$excel_start_date." (".$excel_start_date_accuracy.") and atim ovarectomy on $atim_ovarectomy_data_msg for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                            }
                                        } else {
                                            // One ATiM Ovarectomy detected
                                            if($excel_start_date != $atim_ovarectomy_data[0]['start_date']) {
                                                $ovarectomy_dates_diff = datesDiff($excel_start_date, $atim_ovarectomy_data[0]['start_date'], 'm');
                                                if($ovarectomy_dates_diff == '-1') {
                                                    $ovarectomy_dates_diff = datesDiff($atim_ovarectomy_data[0]['start_date'], $excel_start_date, 'm');
                                                }
                                                if($ovarectomy_dates_diff) {
                                                    // Diff > 1 month
                                                    $ovarectomy_data_to_create = array(
                                                        'treatment_masters' => array(
                                                            'participant_id' => $atim_participant_id,
                                                            'treatment_control_id' => $tx_treatment_control_id,
                                                            'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                                            'start_date' => $excel_start_date,
                                                            'start_date_accuracy' => $excel_start_date_accuracy,
                                                            'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''),
                                                        $tx_detail_tablename => array());
                                                    customInsertRecord($ovarectomy_data_to_create);
                                                    addUpdatedDataToSummary(
                                                        $participant_identifiers_for_summary, 
                                                        $treatment_event_excel_file_name_and_line_for_summary,
                                                        'Created a Second Ovarectomy (from event worksheet)',
                                                        array('start_date' => $excel_start_date, 'start_date_accuracy' => $excel_start_date_accuracy, 'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''));
                                                    recordErrorAndMessage(
                                                        'Participant Treatment/Event',
                                                        '@@WARNING@@',
                                                        "A second participant ovarectomy has been created for participant into ATiM. Please validate.",
                                                        "See excel overectomy on ".$excel_start_date." (".$excel_start_date_accuracy.") and atim ovarectomy on ".$atim_ovarectomy_data['0']['start_date']." (".$atim_ovarectomy_data['0']['start_date_accuracy'].") for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                                } else {
                                                    recordErrorAndMessage(
                                                        'Participant Treatment/Event',
                                                        '@@WARNING@@',
                                                        "ATiM participant ovarectomy and Excel participant ovarectomy are defined has done on two different dates but into the same month. No new ovarectomy will be created but please validate and create second ovarectomy manually after the migration.",
                                                        "See excel overectomy on ".$excel_start_date." (".$excel_start_date_accuracy.") and atim ovarectomy on ".$atim_ovarectomy_data['0']['start_date']." (".$atim_ovarectomy_data['0']['start_date_accuracy'].") for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                                }
                                            } else if($excel_start_date_accuracy != $atim_ovarectomy_data[0]['start_date_accuracy']) {
                                                recordErrorAndMessage(
                                                    'Participant Treatment/Event',
                                                    '@@WARNING@@',
                                                    "Excel and ATiM ovarectomy date accuracy mismatch. ATiM ovarectomy date won't be updated. Please validate.",
                                                    "See excel overectomy on ".$excel_start_date." (".$excel_start_date_accuracy.") and atim ovarectomy on ".$atim_ovarectomy_data['0']['start_date']." (".$atim_ovarectomy_data['0']['start_date_accuracy'].") for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                            }
                                        }
                                        break;
                                        
                                    // CA125
                                    //---------------------------------------------------------------------------------------
                                    case 'ca125':
                                    case 'ca 125':
                                        //Check wrong field completed
                                        $wrong_field_completed = array();
                                        foreach(array('ct_scan', 'drug_1', 'drug_2', 'drug_3', 'drug_4', 'finish_date') as $wrong_field) {
                                            if(strlen($new_excel_clinical_event_data[$wrong_field][0])) {
                                                $wrong_field_completed[] = $new_excel_clinical_event_data[$wrong_field][1].' = '.$new_excel_clinical_event_data[$wrong_field][0];
                                            }
                                        }
                                        if($wrong_field_completed) {
                                            recordErrorAndMessage(
                                                'Participant Treatment/Event',
                                                '@@ERROR@@',
                                                "Wrong Treatment/Event field(s) completed for a CA125. The data of the field won't be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                                "See value(s) ".implode(' & ', $wrong_field_completed)." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                        $ev_control_id = $atim_controls['event_controls']['EOC-ca125']['id'];
                                        $ev_detail_tablename = $atim_controls['event_controls']['EOC-ca125']['detail_tablename'];
                                        $excel_ca125 = validateAndGetDecimal(                                            
                                            $new_excel_clinical_event_data['ca125'][0],
                                            'Participant Treatment/Event',
                                            "Value of excel field ".$new_excel_clinical_event_data['ca125'][1]." won't be used for the ATiM data update.",
                                            "See $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        if(!strlen($excel_ca125)) {
                                            if(!strlen($new_excel_clinical_event_data['ca125'][0])) {
                                            recordErrorAndMessage(
                                                'Participant Treatment/Event',
                                                '@@WARNING@@',
                                                "No CA125 value. The date of the CA125 line won't be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                                "See ".(strlen($new_excel_clinical_event_data['ca125'][0])? "value '".$new_excel_clinical_event_data['ca125'][0]."' for " : '')." $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                            }    
                                        } else {
                                            $query_end = 'TRUE';
                                            if(in_array($excel_start_date_accuracy, array('m', 'd'))) {
                                                $query_end = "em.event_date_accuracy = '$excel_start_date_accuracy' AND ed.precision_u = '".str_replace("'", "''", $excel_ca125)."'";
                                            } else {
                                                $query_end = "em.event_date_accuracy IN ('c', '')";
                                            }
                                            $query = "SELECT em.participant_id,
                                                em.id AS event_master_id,
                                                em.event_date,
                                                em.event_date_accuracy,
                                                ed.precision_u
                                                FROM event_masters em
                                                INNER JOIN $ev_detail_tablename ed ON em.id = ed.event_master_id
                                                WHERE em.deleted <> 1
                                                AND em.participant_id = $atim_participant_id
                                                AND em.event_control_id  = $ev_control_id
                                                AND em.event_date LIKE '$excel_start_date_for_search'
                                                AND ($query_end);";
                                            $atim_event_data = getSelectQueryResult($query);
                                            if(!$atim_event_data) {
                                                $ca125_data_to_create = array(
                                                    'event_masters' => array(
                                                        'participant_id' => $atim_participant_id,
                                                        'event_control_id' => $ev_control_id,
                                                        'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                                        'event_date' => $excel_start_date,
                                                        'event_date_accuracy' => $excel_start_date_accuracy,
                                                        'event_summary' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''),
                                                    $ev_detail_tablename => array(
                                                        'precision_u' => $excel_ca125
                                                    ));
                                                customInsertRecord($ca125_data_to_create);
                                                addUpdatedDataToSummary(
                                                    $participant_identifiers_for_summary,
                                                    $treatment_event_excel_file_name_and_line_for_summary,
                                                    'Created CA125',
                                                    array('event_date' => $excel_start_date, 'event_date_accuracy' => $excel_start_date_accuracy, 'precision_u' => $excel_ca125, 'event_summary' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''));
                                            } else if(sizeof($atim_event_data) == 1) {
                                                if($atim_event_data['0']['precision_u'] != $excel_ca125) {
                                                    updateTableData($atim_event_data['0']['event_master_id'], array('event_masters' => array(), $ev_detail_tablename => array('precision_u' => $excel_ca125)));
                                                    addUpdatedDataToSummary(
                                                        $participant_identifiers_for_summary, 
                                                        $treatment_event_excel_file_name_and_line_for_summary, 
                                                        'Updated EOC CA125', 
                                                        array('on event_date' => $excel_start_date, 'precision_u' => $excel_ca125));
                                                    if(isset($new_excel_clinical_event_data['notes'][0]) && strlen($new_excel_clinical_event_data['notes'][0])) {
                                                        recordErrorAndMessage('Participant Treatment/Event',
                                                            '@@WARNING@@',
                                                            "An note from excel or script for an updated EOC CA125 has not been migrated. Please validate and add data manually into ATiM if required.",
                                                            "See note(s) ".$new_excel_clinical_event_data['notes'][0]." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                                    }
                                                }
                                            } else {
                                                $all_ca125s = array();
                                                $value_found = false;
                                                foreach($atim_event_data as $new_event_data) {
                                                   $all_ca125s[] = "<b>".$new_event_data['precision_u']."</b>";
                                                   if($excel_ca125 == $new_event_data['precision_u']) {
                                                       $value_found = true;
                                                   }
                                                }
                                                $all_ca125s = implode(' & ', $all_ca125s);
                                                recordErrorAndMessage(
                                                    'Participant Treatment/Event',
                                                    '@@ERROR@@',
                                                    "More than one participant CA125 already exist into ATiM at the same date ".($value_found? "with at least one value matching the excel value" : "with no value matching the excel value").". No new CA125 data will be created. Please clean up data manually after the mirgation process.",
                                                    "See ca125 on ".$excel_start_date." (".$excel_start_date_accuracy.") with values $all_ca125s in ATiM and excel value <b>$excel_ca125</b> for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                            } 
                                        }
                                        break;
                                            
                                    // EOC biopsy
                                    //---------------------------------------------------------------------------------------
                                    case 'biopsy':
                                        //Check wrong field completed
                                        $wrong_field_completed = array();
                                        foreach(array('ct_scan', 'ca125', 'drug_1', 'drug_2', 'drug_3', 'drug_4', 'finish_date') as $wrong_field) {
                                            if(strlen($new_excel_clinical_event_data[$wrong_field][0])) {
                                                $wrong_field_completed[] = $new_excel_clinical_event_data[$wrong_field][1].' = '.$new_excel_clinical_event_data[$wrong_field][0];
                                            }
                                        }
                                        if($wrong_field_completed) {
                                            recordErrorAndMessage(
                                                'Participant Treatment/Event',
                                                '@@ERROR@@',
                                                "Wrong Treatment/Event field(s) completed for an EOC biopsy. The data of the field won't be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                                "See value(s) ".implode(' & ', $wrong_field_completed)." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                        $ev_control_id = $atim_controls['event_controls']['EOC-biopsy']['id'];
                                        $ev_detail_tablename = $atim_controls['event_controls']['EOC-biopsy']['detail_tablename'];
                                        $query = "SELECT em.participant_id,
                                            em.id AS event_master_id,
                                            em.event_date,
                                            em.event_date_accuracy
                                            FROM event_masters em
                                            INNER JOIN $ev_detail_tablename ed ON em.id = ed.event_master_id
                                            WHERE em.deleted <> 1
                                            AND em.participant_id = $atim_participant_id
                                            AND em.event_control_id  = $ev_control_id
                                            AND em.event_date LIKE '$excel_start_date_for_search'
                                            AND (".(in_array($excel_start_date_accuracy, array('m', 'd'))? "em.event_date_accuracy = '$excel_start_date_accuracy'" : "em.event_date_accuracy IN ('c', '')").");";
                                        $atim_event_data = getSelectQueryResult($query);
                                        if(!$atim_event_data) {
                                            $biopsy_data_to_create = array(
                                                'event_masters' => array(
                                                    'participant_id' => $atim_participant_id,
                                                    'event_control_id' => $ev_control_id,
                                                    'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                                    'event_date' => $excel_start_date,
                                                    'event_date_accuracy' => $excel_start_date_accuracy,
                                                    'event_summary' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''),
                                                $ev_detail_tablename => array());
                                            customInsertRecord($biopsy_data_to_create);
                                            addUpdatedDataToSummary(
                                                $participant_identifiers_for_summary,
                                                $treatment_event_excel_file_name_and_line_for_summary,
                                                'Created EOC biopsy',
                                                array('event_date' => $excel_start_date, 'event_date_accuracy' => $excel_start_date_accuracy, 'event_summary' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''));
                                        } else if(sizeof($atim_event_data) > 1) {
                                            recordErrorAndMessage(
                                                'Participant Treatment/Event',
                                                '@@ERROR@@',
                                                "More than one EOC biopsy already exist into ATiM at the same date. No new biopsy data will be updated. Please clean up data manually after the mirgation process.",
                                                "See biopsy on ".$excel_start_date." (".$excel_start_date_accuracy.") for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                    break;
                                    
                                // CT/PET scan
                                //---------------------------------------------------------------------------------------
                                case 'ct scan':
                                case 'pet scan':
                                    $scan_initials_for_summary = (strtolower($new_excel_clinical_event_data['type'][0]) == 'ct scan')? 'CT' : 'PET';
                                    $event_type = strtolower($scan_initials_for_summary).' scan';
                                    //Check wrong field completed
                                    $wrong_field_completed = array();
                                    foreach(array('ca125', 'drug_1', 'drug_2', 'drug_3', 'drug_4', 'finish_date') as $wrong_field) {
                                        if(strlen($new_excel_clinical_event_data[$wrong_field][0])) {
                                            $wrong_field_completed[] = $new_excel_clinical_event_data[$wrong_field][1].' = '.$new_excel_clinical_event_data[$wrong_field][0];
                                        }
                                    }
                                    if($wrong_field_completed) {
                                        recordErrorAndMessage(
                                            'Participant Treatment/Event',
                                            '@@ERROR@@',
                                            "Wrong Treatment/Event field(s) completed for a $scan_initials_for_summary scan. The data of the field won't be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                            "See value(s) ".implode(' & ', $wrong_field_completed)." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                    }
                                    $ev_control_id = $atim_controls['event_controls']["EOC-$event_type"]['id'];
                                    $ev_detail_tablename = $atim_controls['event_controls']["EOC-$event_type"]['detail_tablename'];
                                    $excel_scan_value = validateAndGetStructureDomainValue(
                                        $new_excel_clinical_event_data['ct_scan'][0],
                                        'qc_tf_ct_scan_precision',
                                        'Participant Treatment/Event',
                                        "Value of excel field ".$new_excel_clinical_event_data['ct_scan'][1]." won't be used for the ATiM data update.",
                                        "See $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                    $query = "SELECT em.participant_id,
                                        em.id AS event_master_id,
                                        em.event_date,
                                        em.event_date_accuracy,
                                        ed.scan_precision
                                        FROM event_masters em
                                        INNER JOIN $ev_detail_tablename ed ON em.id = ed.event_master_id
                                        WHERE em.deleted <> 1
                                        AND em.event_control_id  = $ev_control_id
                                        AND em.participant_id = $atim_participant_id
                                        AND em.event_date LIKE '$excel_start_date_for_search'
                                        AND (".(in_array($excel_start_date_accuracy, array('m', 'd'))? "em.event_date_accuracy = '$excel_start_date_accuracy'" : "em.event_date_accuracy IN ('c', '')").");";
                                    $atim_event_data = getSelectQueryResult($query);
                                    if(!$atim_event_data) {
                                        $scan_data_to_create = array(
                                            'event_masters' => array(
                                                'participant_id' => $atim_participant_id,
                                                'event_control_id' => $ev_control_id,
                                                'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                                'event_date' => $excel_start_date,
                                                'event_date_accuracy' => $excel_start_date_accuracy,
                                                'event_summary' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''),
                                            $ev_detail_tablename => array(
                                                'scan_precision' => $excel_scan_value
                                            ));
                                        customInsertRecord($scan_data_to_create);
                                        addUpdatedDataToSummary(
                                            $participant_identifiers_for_summary,
                                            $treatment_event_excel_file_name_and_line_for_summary,
                                            "Created EOC $scan_initials_for_summary Scan",
                                            array('event_date' => $excel_start_date, 'event_date_accuracy' => $excel_start_date_accuracy, 'scan_precision' => $excel_scan_value, 'event_summary' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''));
                                        //Check other scan
                                        $event_type_for_check = ($event_type == 'ct scan')? 'pet scan' : 'ct scan';
                                        $ev_control_id = $atim_controls['event_controls']["EOC-$event_type_for_check"]['id'];
                                        $ev_detail_tablename = $atim_controls['event_controls']["EOC-$event_type_for_check"]['detail_tablename'];
                                        $query = "SELECT em.participant_id,
                                            em.id AS event_master_id,
                                            em.event_date,
                                            em.event_date_accuracy,
                                            ed.scan_precision
                                            FROM event_masters em
                                            INNER JOIN $ev_detail_tablename ed ON em.id = ed.event_master_id
                                            WHERE em.deleted <> 1
                                            AND em.event_control_id  = $ev_control_id
                                            AND em.participant_id = $atim_participant_id
                                            AND em.event_date LIKE '$excel_start_date_for_search'
                                            AND (".(in_array($excel_start_date_accuracy, array('m', 'd'))? "em.event_date_accuracy = '$excel_start_date_accuracy'" : "em.event_date_accuracy IN ('c', '')").")
                                            AND ed.scan_precision = '".str_replace("'", "''", $excel_scan_value)."';";
                                        $atim_event_data = getSelectQueryResult($query);
                                        if($atim_event_data) {
                                            recordErrorAndMessage('Participant Treatment/Event',
                                                '@@WARNING@@',
                                                "The system just created a $event_type but a $event_type_for_check already exists into ATiM at the same date and with the same result. Please clean up data manually after the mirgation process if required.",
                                                "See Scans on ".$excel_start_date." (".$excel_start_date_accuracy.") with values $excel_scan_value into ATiM for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                    } else if(sizeof($atim_event_data) == 1) {
                                        if($excel_scan_value && $atim_event_data['0']['scan_precision'] != $excel_scan_value) {
                                            updateTableData(
                                                $atim_event_data['0']['event_master_id'], 
                                                array('event_masters' => array(), $ev_detail_tablename => array('scan_precision' => $excel_scan_value)));
                                            addUpdatedDataToSummary(
                                                $participant_identifiers_for_summary,
                                                $treatment_event_excel_file_name_and_line_for_summary,
                                                "Updated EOC $scan_initials_for_summary Scan",
                                                array('on event_date' => $excel_start_date, 'scan_precision' => $excel_scan_value));
                                            if(isset($new_excel_clinical_event_data['notes'][0]) && strlen($new_excel_clinical_event_data['notes'][0])) {
                                                recordErrorAndMessage('Participant Treatment/Event',
                                                    '@@WARNING@@',
                                                    "An note from excel or script for an updated EOC $scan_initials_for_summary Scan has not been migrated. Please validate and add data manually into ATiM if required.",
                                                    "See note(s) ".$new_excel_clinical_event_data['notes'][0]." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                            }
                                        }
                                    } else {
                                        $all_scan_precisions = array();
                                        foreach($atim_event_data as $new_event_data) {
                                           $all_scan_precisions[] = "<b>".$new_event_data['scan_precision']."</b>";
                                        }
                                        $all_scan_precisions = implode(' & ', $all_scan_precisions);
                                        recordErrorAndMessage('Participant Treatment/Event',
                                            '@@ERROR@@',
                                            "More than one participant $scan_initials_for_summary-Scan already exist into ATiM at the same date. No new $scan_initials_for_summary Scan data will be created/updated. Please clean up data manually after the mirgation process.",
                                            "See $scan_initials_for_summary-Scan on ".$excel_start_date." (".$excel_start_date_accuracy.") with values $all_scan_precisions into ATiM and <b>$excel_scan_value</b> into excel for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                    }
                                    break;
                                    
                                // EOC surgery
                                //---------------------------------------------------------------------------------------
                                case 'surgery(other)':
                                    //Check wrong field completed
                                    $wrong_field_completed = array();
                                    foreach(array('ct_scan', 'ca125', 'drug_1', 'drug_2', 'drug_3', 'drug_4', 'finish_date') as $wrong_field) {
                                        if(strlen($new_excel_clinical_event_data[$wrong_field][0])) {
                                            $wrong_field_completed[] = $new_excel_clinical_event_data[$wrong_field][1].' = '.$new_excel_clinical_event_data[$wrong_field][0];
                                        }
                                    }
                                    if($wrong_field_completed) {
                                        recordErrorAndMessage(
                                            'Participant Treatment/Event',
                                            '@@ERROR@@',
                                            "Wrong Treatment/Event field(s) completed for an EOC surgery. The data of the field won't be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                            "See value(s) ".implode(' & ', $wrong_field_completed)." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                    }
                                    $tx_treatment_control_id = $atim_controls['treatment_controls']['EOC-surgery']['id'];
                                    $tx_detail_tablename = $atim_controls['treatment_controls']['EOC-surgery']['detail_tablename'];
                                    $query = "SELECT tm.participant_id,
                                        tm.id AS treatment_master_id,
                                        tm.start_date,
                                        tm.start_date_accuracy
                                        FROM treatment_masters tm
                                        WHERE tm.deleted <> 1
                                        AND tm.participant_id = $atim_participant_id
                                        AND tm.treatment_control_id = $tx_treatment_control_id
                                        AND tm.start_date LIKE '$excel_start_date_for_search'
                                        AND (".(in_array($excel_start_date_accuracy, array('m', 'd'))? "tm.start_date_accuracy = '$excel_start_date_accuracy'" : "tm.start_date_accuracy IN ('c', '')").");";
                                    $atim_surgery_data = getSelectQueryResult($query);
                                    if(!$atim_surgery_data) {
                                        $surgery_data_to_create = array(
                                            'treatment_masters' => array(
                                                'participant_id' => $atim_participant_id,
                                                'treatment_control_id' => $tx_treatment_control_id,
                                                'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                                'start_date' => $excel_start_date,
                                                'start_date_accuracy' => $excel_start_date_accuracy,
                                                'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''),
                                            $tx_detail_tablename => array());
                                        customInsertRecord($surgery_data_to_create);
                                        addUpdatedDataToSummary(
                                            $participant_identifiers_for_summary,
                                            $treatment_event_excel_file_name_and_line_for_summary,
                                            'Created EOC Surgery (from event worksheet)',
                                            array('start_date' => $excel_start_date, 'start_date_accuracy' => $excel_start_date_accuracy, 'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''));
                                    } elseif (sizeof($atim_surgery_data) > 1) {
                                        recordErrorAndMessage(
                                            'Participant Treatment/Event',
                                            '@@ERROR@@',
                                            "More than one participant EOC surgery already exist into ATiM at the same date. No new surgery will be created. Please clean up data manually after the mirgation process.",
                                            "See EOC surgery on $excel_start_date ($excel_start_date_accuracy) for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                    }
                                    break;
                                    
                                    // EOC radiation
                                    //---------------------------------------------------------------------------------------
                                    case 'radiotherapy':
                                    case 'radiation':
                                        //Check wrong field completed
                                        $wrong_field_completed = array();
                                        foreach(array('ct_scan', 'ca125', 'drug_1', 'drug_2', 'drug_3', 'drug_4') as $wrong_field) {
                                            if(strlen($new_excel_clinical_event_data[$wrong_field][0])) {
                                                $wrong_field_completed[] = $new_excel_clinical_event_data[$wrong_field][1].' = '.$new_excel_clinical_event_data[$wrong_field][0];
                                            }
                                        }
                                        if($wrong_field_completed) {
                                            recordErrorAndMessage(
                                                'Participant Treatment/Event',
                                                '@@ERROR@@',
                                                "Wrong Treatment/Event field(s) completed for an EOC radiation. The data of the field won't be used for the ATiM data update. Please validate and add data manually into ATiM if required.",
                                                "See value(s) ".implode(' & ', $wrong_field_completed)." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                        $tx_treatment_control_id = $atim_controls['treatment_controls']['EOC-radiotherapy']['id'];
                                        $tx_detail_tablename = $atim_controls['treatment_controls']['EOC-radiotherapy']['detail_tablename'];
                                        $query = "SELECT tm.participant_id,
                                            tm.id AS treatment_master_id,
                                            tm.start_date,
                                            tm.start_date_accuracy,
                                            tm.finish_date,
                                            tm.finish_date_accuracy
                                            FROM treatment_masters tm
                                            WHERE tm.deleted <> 1
                                            AND tm.participant_id = $atim_participant_id
                                            AND tm.treatment_control_id = $tx_treatment_control_id
                                            AND tm.start_date LIKE '$excel_start_date_for_search'
                                            AND (".(in_array($excel_start_date_accuracy, array('m', 'd'))? "tm.start_date_accuracy = '$excel_start_date_accuracy'" : "tm.start_date_accuracy IN ('c', '')").");";
                                        $atim_radiotherapy_data = getSelectQueryResult($query);
                                        if(!$atim_radiotherapy_data) {
                                            $radiotherapy_data_to_create = array(
                                                'treatment_masters' => array(
                                                    'participant_id' => $atim_participant_id,
                                                    'treatment_control_id' => $tx_treatment_control_id,
                                                    'diagnosis_master_id' => $dx_eoc_diagnosis_master_id,
                                                    'start_date' => $excel_start_date,
                                                    'start_date_accuracy' => $excel_start_date_accuracy,
                                                    'finish_date' => $excel_finish_date,
                                                    'finish_date_accuracy' => ($excel_finish_date? $excel_finish_date_accuracy : ''),
                                                    'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''),
                                                $tx_detail_tablename => array());
                                            customInsertRecord($radiotherapy_data_to_create);
                                            addUpdatedDataToSummary(
                                                $participant_identifiers_for_summary,
                                                $treatment_event_excel_file_name_and_line_for_summary,
                                                'Created EOC Radiotherapy (from event worksheet)',
                                                array(
                                                    'start_date' => $excel_start_date,
                                                    'start_date_accuracy' => $excel_start_date_accuracy,
                                                    'finish_date' => $excel_finish_date,
                                                    'finish_date_accuracy' => ($excel_finish_date? $excel_finish_date_accuracy : ''),
                                                    'notes' => isset($new_excel_clinical_event_data['notes'][0])? $new_excel_clinical_event_data['notes'][0] : ''
                                                ));
                                        } elseif (sizeof($atim_radiotherapy_data) == 1) {
                                            $atim_radiotherapy_data = $atim_radiotherapy_data[0];
                                            if($excel_finish_date && ($atim_radiotherapy_data['finish_date'] != $excel_finish_date || $atim_radiotherapy_data['finish_date_accuracy'] != $excel_finish_date_accuracy)) {
                                                // Excel Finish Date is set : Update the finish date
                                                updateTableData(
                                                    $atim_radiotherapy_data['treatment_master_id'], 
                                                    array(
                                                        'treatment_masters' => array(
                                                            'finish_date' => $excel_finish_date,
                                                            'finish_date_accuracy' => $excel_finish_date_accuracy),
                                                        $tx_detail_tablename => array()));
                                                addUpdatedDataToSummary(
                                                    $participant_identifiers_for_summary,
                                                    $excel_file_name_and_line_for_summary,
                                                    "Updated Finishing Date to an Existing EOC Radiotherpay",
                                                    array(
                                                        'atim radiotherapy from' => $excel_start_date.' ('.$excel_start_date_accuracy.')',
                                                        'to' => $atim_treatment_data['finish_date'].' ('.$atim_treatment_data['finish_date_accuracy'].')',
                                                        'new finishing date' => "$excel_finish_date ($excel_finish_date_accuracy)"));
                                                if(isset($new_excel_clinical_event_data['notes'][0]) && strlen($new_excel_clinical_event_data['notes'][0])) {
                                                    recordErrorAndMessage('Participant Treatment/Event',
                                                        '@@WARNING@@',
                                                        "An note from excel or script for an updated EOC Radiotherpay has not been migrated. Please validate and add data manually into ATiM if required.",
                                                        "See note(s) ".$new_excel_clinical_event_data['notes'][0]." for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                                }
                                            }
                                        } elseif (sizeof($atim_radiotherapy_data) > 1) {
                                            recordErrorAndMessage(
                                                'Participant Treatment/Event',
                                                '@@ERROR@@',
                                                "More than one participant EOC radiotherapy already exists into ATiM with the same 'start'date. No new radiotherapy will be created. Please clean up data manually after the mirgation process.",
                                                "See EOC radiotherapy on $excel_start_date ($excel_start_date_accuracy) for $participant_identifiers_for_summary in $treatment_event_excel_file_name_and_line_for_summary.");
                                        }
                                        break;
                                        
                                    default:
                                        recordErrorAndMessage(
                                            'Participant Treatment/Event',
                                            '@@ERROR@@',
                                            "The treatment/event type '".$new_excel_clinical_event_data['type'][0]."' is not supported by the updated script. The treatment line data won't be used for the ATiM data update. Please clean up data manually after the mirgation process.",
                                            "See $treatment_event_excel_file_name_and_line_for_summary (and more).",
                                            __LINE__." treatment type"); 
                                }  
                            }
                        }
                        unset($all_excel_clinical_events_treatments_records[$qc_tf_bank_identifier]);
                    }
                    
                    //.......................................................................................
                    // END Treatment/Events
                    //.......................................................................................
                    
                    // End Of Diagnosis Update
                    //---------------------------------------------------------------------------------------
                    
                    $new_eoc_diagnosis_date = isset($diagnosis_data_to_update['diagnosis_masters']['dx_date'])? $diagnosis_data_to_update['diagnosis_masters']['dx_date'] : $atim_diagnosis_data['dx_date'];
                    $new_eoc_diagnosis_date_accuracy = isset($diagnosis_data_to_update['diagnosis_masters']['dx_date_accuracy'])? $diagnosis_data_to_update['diagnosis_masters']['dx_date_accuracy'] : $atim_diagnosis_data['dx_date_accuracy'];
                    
                    $new_qc_tf_last_contact = isset($participant_data_to_update['qc_tf_last_contact'])? $participant_data_to_update['qc_tf_last_contact'] : $atim_participant_data['qc_tf_last_contact'];
                    $new_qc_tf_last_contact_accuracy = isset($participant_data_to_update['qc_tf_last_contact_accuracy'])? $participant_data_to_update['qc_tf_last_contact_accuracy'] : $atim_participant_data['qc_tf_last_contact_accuracy'];
                    
                    $new_date_of_death = isset($participant_data_to_update['date_of_death'])? $participant_data_to_update['date_of_death'] : $atim_participant_data['date_of_death'];
                    $new_date_of_death_accuracy = isset($participant_data_to_update['date_of_death_accuracy'])? $participant_data_to_update['date_of_death_accuracy'] : $atim_participant_data['date_of_death_accuracy'];
                    
                    $query = "SELECT tm.participant_id,
                        tm.id AS treatment_master_id,
                        tm.start_date,
                        tm.start_date_accuracy
                        FROM treatment_masters tm
                        WHERE tm.deleted <> 1
                        AND tm.participant_id = $atim_participant_id
                        AND tm.diagnosis_master_id = $dx_eoc_diagnosis_master_id
                        AND tm.treatment_control_id = " . $atim_controls['treatment_controls']['EOC-ovarectomy']['id'] ."
                        AND tm.start_date IS NOT NULL AND tm.start_date NOT LIKE ''
                        ORDER BY tm.start_date ASC
                        LIMIT 0,1";
                    $atim_first_eoc_treatment_date_res = getSelectQueryResult($query);
                    $atim_first_eoc_treatment_date = empty($atim_first_eoc_treatment_date_res)? '' : $atim_first_eoc_treatment_date_res[0]['start_date'];
                    $atim_first_eoc_treatment_date_accuracy = empty($atim_first_eoc_treatment_date)? '' : $atim_first_eoc_treatment_date_res[0]['start_date_accuracy'];
                    
                    $query = "SELECT id, dx_date, dx_date_accuracy
                        FROM diagnosis_masters
                        WHERE deleted <> 1
                        AND participant_id = $atim_participant_id
                        AND parent_id = $dx_eoc_diagnosis_master_id
                        AND diagnosis_control_id = " . $atim_controls['diagnosis_controls']['secondary - distant-recurrence or metastasis']['id'] . "
                        AND qc_tf_progression_detection_method = 'ca125'
                        AND dx_date IS NOT NULL AND dx_date NOT LIKE ''
                        ORDER BY dx_date ASC
                        LIMIT 0,1";
                    $atim_first_ca125_recurrence_date_res = getSelectQueryResult($query);
                    $first_ca125_recurrence_date = empty($atim_first_ca125_recurrence_date_res)? '' : $atim_first_ca125_recurrence_date_res[0]['dx_date'];
                    $first_ca125_recurrence_date_accuracy = empty($first_ca125_recurrence_date)? '' : $atim_first_ca125_recurrence_date_res[0]['dx_date_accuracy'];
                    
                    $query = "SELECT id, dx_date, dx_date_accuracy
                        FROM diagnosis_masters
                        WHERE deleted <> 1
                        AND participant_id = $atim_participant_id
                        AND parent_id = $dx_eoc_diagnosis_master_id
                        AND diagnosis_control_id = " . $atim_controls['diagnosis_controls']['secondary - distant-recurrence or metastasis']['id'] . "
                        AND qc_tf_progression_detection_method != 'ca125'
                        AND dx_date IS NOT NULL AND dx_date NOT LIKE ''
                        ORDER BY dx_date ASC
                        LIMIT 0,1";
                    $atim_first_non_ca125_recurrence_date_res = getSelectQueryResult($query);
                    $first_non_ca125_recurrence_date = empty($atim_first_non_ca125_recurrence_date_res)? '' : $atim_first_non_ca125_recurrence_date_res[0]['dx_date'];
                    $first_non_ca125_recurrence_date_accuracy = empty($first_non_ca125_recurrence_date)? '' : $atim_first_non_ca125_recurrence_date_res[0]['dx_date_accuracy'];
                    
                    $atim_diagnosis_calculated_values_in_months = array(
                        'ca125_progression_time_in_months' => $atim_diagnosis_data['ca125_progression_time_in_months'],
                        'progression_time_in_months' => $atim_diagnosis_data['progression_time_in_months'],
                        'follow_up_from_ovarectomy_in_months' => $atim_diagnosis_data['follow_up_from_ovarectomy_in_months'],
                        'survival_from_ovarectomy_in_months' => $atim_diagnosis_data['survival_from_ovarectomy_in_months']);
                    
                    $new_diagnosis_calculated_values_in_months = array();

                    $calcul_properties =array(
                        // ca125_progression_time_in_months
                        //    from: First treatment date
                        //    to: first_ca125_recurrence_date
                        array(
                            'CA125 progression time in months',
                            'ca125_progression_time_in_months',
                            'First EOC Treatment',
                            $atim_first_eoc_treatment_date,
                            $atim_first_eoc_treatment_date_accuracy,
                            'First CA125 Recurrence',
                            $first_ca125_recurrence_date,
                            $first_ca125_recurrence_date_accuracy),
                        // progression_time_in_months 
                        //    from: First treatment date 
                        //    to: first_site_recurrence_date
                        array(
                            'Progression Time (months)',
                            'progression_time_in_months',
                            'First EOC Treatment',
                            $atim_first_eoc_treatment_date,
                            $atim_first_eoc_treatment_date_accuracy,
                            'First Non CA125 Recurrence',
                            $first_non_ca125_recurrence_date,
                            $first_non_ca125_recurrence_date_accuracy),
                        // follow_up_from_ovarectomy_in_months  
                        //    from: First treatment date 
                        //    to: date_of_death or last_contact_date
                        array(
                            'Follow up from ovarectomy (months)',
                            'follow_up_from_ovarectomy_in_months',
                            'First EOC Treatment',
                            $atim_first_eoc_treatment_date,
                            $atim_first_eoc_treatment_date_accuracy,
                            'Last Contact or Death',
                            (strlen($new_date_of_death)? $new_date_of_death : $new_qc_tf_last_contact),
                            (strlen($new_date_of_death)? $new_date_of_death_accuracy : $new_qc_tf_last_contact_accuracy)),                        
                        // survival_from_ovarectomy_in_months  
                        //    from: EOC diagnosis
                        //    to: date_of_death or last_contact_date
                        array(
                            'Survival from Ovarectomy (months)',
                            'survival_from_ovarectomy_in_months',
                            'EOC Diagnosis',
                            $new_eoc_diagnosis_date,
                            $new_eoc_diagnosis_date_accuracy,
                            'Last Contact or Death',
                            (strlen($new_date_of_death)? $new_date_of_death : $new_qc_tf_last_contact),
                            (strlen($new_date_of_death)? $new_date_of_death_accuracy : $new_qc_tf_last_contact_accuracy)));
                    foreach($calcul_properties as $new_calcul_properties) {
                        list(
                            $calcul_title,
                            $calculated_atim_field,
                            $start_field_title,
                            $start_date,
                            $start_date_accuracy,
                            $finish_field_title,
                            $finish_date,
                            $finish_date_accuracy) = $new_calcul_properties;
                        if(strlen($start_date) && strlen($finish_date)) {
                            if(!preg_match('/^[cd\ ]{2}$/', $start_date_accuracy.$finish_date_accuracy)) {
                                // Approximate date(s)
                                recordErrorAndMessage(
                                    'Participant EOC Diagnosis',
                                    '@@WARNING@@',
                                    "The precision of the dates '$start_field_title' and '$finish_field_title' used to calculate the '$calcul_title' is not sufficient. The value won't be calculated then used to update (or not) the value into ATiM.",
                                    "See '$start_field_title' (start) date $start_date ($start_date_accuracy) and '$finish_field_title' (end) date $finish_date ($finish_date_accuracy) for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                            } else {
                                $months = datesDiff($start_date, $finish_date, 'm');
                                if($months != '-1') {
                                    $new_diagnosis_calculated_values_in_months[$calculated_atim_field] = $months;
                                } else {
                                    recordErrorAndMessage(
                                        'Participant EOC Diagnosis',
                                        '@@ERROR@@',
                                        "There is a chronological error with the dates '$start_field_title' and '$finish_field_title' used to calculate the '$calcul_title'. The value won't be calculated then used to update (or not) the value into ATiM. Please correct data into ATiM after the migration.",
                                        "See '$start_field_title' (start) date $start_date ($start_date_accuracy) and '$finish_field_title' (end) date $finish_date ($finish_date_accuracy) for $participant_identifiers_for_summary in $excel_file_name_and_line_for_summary.");
                                } 
                            }
                        }
                    }
                    if($new_diagnosis_calculated_values_in_months && !empty($diagnosis_data_to_update[$dx_eoc_detail_tablename])) {
                        $calculated_fields_to_update = getDataToUpdate($atim_diagnosis_calculated_values_in_months, $new_diagnosis_calculated_values_in_months, __LINE__);
                        $diagnosis_data_to_update[$dx_eoc_detail_tablename] = array_merge($diagnosis_data_to_update[$dx_eoc_detail_tablename], $calculated_fields_to_update);
                    }
                    
        	        if(sizeof($diagnosis_data_to_update['diagnosis_masters']) || sizeof($diagnosis_data_to_update[$dx_eoc_detail_tablename])) {
                        updateTableData($dx_eoc_diagnosis_master_id, $diagnosis_data_to_update);
                        addUpdatedDataToSummary($participant_identifiers_for_summary, $excel_file_name_and_line_for_summary, 'Updated EOC Diagnosis', array_merge($diagnosis_data_to_update['diagnosis_masters'], $diagnosis_data_to_update[$dx_eoc_detail_tablename]));
        	        }
        	    }   
        	}    	    
    	}
    	
    	// Check $all_excel_clinical_events_treatments_records
           	
    	foreach($all_excel_clinical_events_treatments_records as $tfri_nbr_key => $worksheet_line_values) {
    	    if(!strlen($tfri_nbr_key)) {
        	    recordErrorAndMessage('Participant Treatment/Event',
        	        '@@WARNING@@',
        	        "At least one line of the Treatment/Event table does not contain a participant bank identifier. No data of this line will be used for the clinical data update. Please validate.",
        	        "See (and more) ".$worksheet_line_values[0][1],
        	        'empty identifier');
    	    } else {        
        	    recordErrorAndMessage('Participant Treatment/Event',
        	        '@@WARNING@@',
        	        "At least one line of the Treatment/Event table contains data for a participant bank identifier not listed into the diagnosis data worksheet. No data of this line will be used for the clinical data update. Please validate.",
        	        "See participant $tfri_nbr_key on ".$worksheet_line_values[0][1]." (and more)...",
        	        "No participant $tfri_nbr_key");
    	    }
    	}
	}
	
	// Manage Sumamry for the pasrsed file file
	
	foreach(array('Update Summary', 'Creation Summary') as $new_section) {
	    if(isset($import_summary[$new_section])) {
	        $creation_update_summary["$new_section [$file_name_for_summary]"] = $import_summary[$new_section];
	        unset($import_summary[$new_section]);
	    }
	}
	dislayErrorAndMessage(false, "Migration Messages [$file_name_for_summary]");
	$import_summary = array();
}

$import_summary = $creation_update_summary;

dislayErrorAndMessage($commit_all, 'Creation/Update Summary');

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function datesDiff($start, $end, $year_month) {
    $start_ob = new DateTime($start);
    $end_ob = new DateTime($end);
    $interval = $start_ob->diff($end_ob);
    if($interval->invert) {
        return '-1';
    } else {
        if($year_month == 'y') {
            return $interval->y;
        } else if($year_month == 'm') {
            return $interval->y*12 + $interval->m;
        } else {
            die('ERR 8237827283');
        }
    }
}

// Other Function
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function getDataToUpdate($atim_data, $excel_data, $line = '') {
	$data_to_update = array();
	foreach($excel_data as $key => $value) {
		if(!array_key_exists($key, $atim_data)) die('ERR_8837282882: '.$key.' from '.$line);
		if(strlen($value) && $value != $atim_data[$key]) $data_to_update[$key] = $value;
	}
	return $data_to_update;
}

function addUpdatedDataToSummary($participant_identifiers_for_summary, $excel_file_name_and_line_for_summary, $data_type, $data_to_update) {
	if($data_to_update) {
		$updates = array();
		foreach($data_to_update as $field => $value) $updates[] = "[$field = $value]";
		recordErrorAndMessage('Update Summary', '@@MESSAGE@@', "$participant_identifiers_for_summary", "$data_type : ".implode(' + ', $updates)." <i><font color='lightgrey'>[in $excel_file_name_and_line_for_summary]</font></i>");
	}
}

//==================================================================================================================================================================================
// ParserS
//==================================================================================================================================================================================

// General
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function getProfileByGeneralParser($excel_file_name, $file_name_for_summary, $worksheet_name, $file_xls_offset) {
	
	list($excel_line_counter, $next_excel_line_clinical_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1, $file_xls_offset);
	if(!$next_excel_line_clinical_data) return null;
	$excel_file_name_and_line_for_summary = $file_name_for_summary. " worksheet '<b>$worksheet_name</b>' and <b>line $excel_line_counter</b>";
    
	$atim_participant_data = array();
	
	// Participant Profile
	
	$migration_fields_properties = array(
    	'participants' => array(
    	    array('TFRI', 'participant_identifier', array(), array(), false),
    	    array('participantBank', 'qc_tf_bank_identifier', array(), array(), false),
            array('date of birth', 'date_of_birth', array(), array(), true),
    	    array('Date dernier contact', 'qc_tf_last_contact', array(), array(), true),
    	    array('Vital Status', 'vital_status', array('dead', 'Dead'), array('deceased', 'deceased'), false),
    	    array('Date du décès', 'date_of_death', array(), array(), true),
    	    array('BRCA status', 'qc_tf_brca_status', array(''), array(), false),
    	    array('Family History', 'qc_tf_family_history', array(), array(), false),
            array('Post Chemo', 'qc_tf_post_chemo', array('yes', 'no', 'Yes', 'no'), array('y', 'n', 'y', 'n'), false),
    	    array('Notes', 'notes', array(), array(), false)),
	    'diagnosis' => array(
    	    array('Diagnosis Date', 'dx_date', array(), array(), true),
    	    array('Age at Diagnosis', 'age_at_dx', array(), array(), false),
    	    array('Tumour Grade', 'tumour_grade', array(), array(), false),
    	    array('Figo', 'figo', array(), array(), false),
    	    array('Histopathology', 'histopathology', array('-'), array(''), false),
    	    array('Histopathologyrevision', 'reviewed_histopathology', array('Reviewed ', '-'), array('', ''), false),
    	    array('Residual disease', 'residual_disease', array(), array(), false),
    	    array('Progression Status', 'progression_status', array(), array(), false)),
	    'ovarectomy' => array(
	       array('Ovarectomy', 'start_date', array(), array(), true)),
	    'recurrence' => array(
	       array('Date recurrence', 'recurrence_date', array(), array(), true),
	       array('Date CA125 recurrence', 'ca125_recurrence_date', array(), array(), true))
	);
	$unmigrated_fields = $next_excel_line_clinical_data;
	foreach($migration_fields_properties as $data_type => $excel_field_to_atim_field) {
    	foreach($excel_field_to_atim_field as $field_properties) {
    	    list($excel_field, $atim_field, $search, $replace, $is_date) = $field_properties;
    	    $excel_field_for_summary = utf8_Decode($excel_field);
    	    if(!array_key_exists($excel_field, $next_excel_line_clinical_data)) {
    	        recordErrorAndMessage('Excel File',
    	            '@@ERROR@@',
                    "Excel field does not exist. Values of the excel column won't be imported then compared to atim data for updated (<i>$file_name_for_summary</i>).",
                    "$worksheet_name :: $excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
    	        $atim_participant_data[$data_type][$atim_field] = array('', $excel_field_for_summary, '');
    	    } else {
    	        if(preg_match('/^\-$/', $next_excel_line_clinical_data[$excel_field])) $next_excel_line_clinical_data[$excel_field] = '';
    	        if($is_date) {
    	            list($tmp_date, $tmp_date_accuracy) = validateAndGetDateAndAccuracy($next_excel_line_clinical_data[$excel_field], $excel_field_for_summary, "$worksheet_name::$excel_field:", "See $excel_file_name_and_line_for_summary");
    	            $atim_participant_data[$data_type][$atim_field] = array($tmp_date, $excel_field_for_summary, $tmp_date_accuracy);
    	        } else {
    	            $atim_participant_data[$data_type][$atim_field] = array(str_replace($search, $replace, $next_excel_line_clinical_data[$excel_field]), $excel_field_for_summary, null);
    	        }
                recordErrorAndMessage('Excel File',
                    '@@MESSAGE@@',
                    "Excel fields migrated from worksheet '$worksheet_name' (<i>$file_name_for_summary</i>).",
                    "$excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
    	    }
    	    unset($unmigrated_fields[$excel_field]);
    	}
	}
	foreach($unmigrated_fields as $excel_field => $tmp) {
	    $excel_field_for_summary = utf8_Decode($excel_field);
	    recordErrorAndMessage('Excel File',
	        '@@WARNING@@',
	        "Un-migrated Excel fields from worksheet '$worksheet_name' (<i>$file_name_for_summary</i>).",
	        "$excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
	}
	return array($atim_participant_data, $excel_file_name_and_line_for_summary);
}

function getClinicalEventByGeneralParser($excel_file_name, $file_name_for_summary, $worksheet_name, $file_xls_offset) {

    list($excel_line_counter, $next_excel_line_clinical_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2, $file_xls_offset);
    if(!$next_excel_line_clinical_data) return null;
    $excel_file_name_and_line_for_summary = $file_name_for_summary. " worksheet '<b>$worksheet_name</b>' and <b>line $excel_line_counter</b>";

    $atim_participant_data = array();

    // Participant Profile

    $excel_field_to_atim_field = array(
        array('Patient Biobank Number (required)', 'qc_tf_bank_identifier', array(), array(), false),
        array('Event Type', 'type', array(), array(), false),
        array('Date of event (beginning) Date', 'start_date', array(), array(), true),
        array('Date of event (beginning) Accuracy', 'start_date_accuracy', array(), array(), false),
        array('Date of event (end) Date', 'finish_date', array(), array(), true),
        array('Date of event (end) Accuracy', 'finish_date_accuracy', array(), array(), false),
        array('Chemotherapy Precision Drug1', 'drug_1', array(), array(), false),
        array('Chemotherapy Precision Drug2', 'drug_2', array(), array(), false),
        array('Chemotherapy Precision Drug3', 'drug_3', array(), array(), false),
        array('Chemotherapy Precision Drug4', 'drug_4', array(), array(), false),
        array('CA125 Precision (U)', 'ca125', array(), array(), false) ,
        array('CT Scan Precision', 'ct_scan', array(), array(), false)
    );
    $unmigrated_fields = $next_excel_line_clinical_data;
    foreach($excel_field_to_atim_field as $field_properties) {
        list($excel_field, $atim_field, $search, $replace, $is_date) = $field_properties;
        $excel_field_for_summary = utf8_Decode($excel_field);
        if(!array_key_exists($excel_field, $next_excel_line_clinical_data)) {
            recordErrorAndMessage('Excel File',
                '@@ERROR@@',
                "Excel field does not exist. Values of the excel column won't be imported then compared to atim data for updated (<i>$file_name_for_summary</i>).",
                "$worksheet_name :: $excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
            $atim_participant_data['event'][$atim_field] = array('', $excel_field_for_summary, '');
        } else {
            if(preg_match('/^\-$/', $next_excel_line_clinical_data[$excel_field])) $next_excel_line_clinical_data[$excel_field] = '';
            if($is_date) {
                list($tmp_date, $tmp_date_accuracy) = validateAndGetDateAndAccuracy($next_excel_line_clinical_data[$excel_field], $excel_field_for_summary, "$worksheet_name::$excel_field:", "See $excel_file_name_and_line_for_summary");
                $atim_participant_data['event'][$atim_field] = array($tmp_date, $excel_field_for_summary, $tmp_date_accuracy);
            } else {
                $atim_participant_data['event'][$atim_field] = array(str_replace($search, $replace, $next_excel_line_clinical_data[$excel_field]), $excel_field_for_summary, null);
            }
            recordErrorAndMessage('Excel File',
                '@@MESSAGE@@',
                "Excel fields migrated (<i>$file_name_for_summary</i> :: $worksheet_name).",
                "$excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
        }
        unset($unmigrated_fields[$excel_field]);
    }
    foreach($unmigrated_fields as $excel_field => $tmp) {
        $excel_field_for_summary = utf8_Decode($excel_field);
        recordErrorAndMessage('Excel File',
            '@@WARNING@@',
            "Un-migrated Excel fields (<i>$file_name_for_summary</i> - $worksheet_name).",
            "$excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
    }

    return array($atim_participant_data, $excel_file_name_and_line_for_summary);
}

// Otb
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function getProfileByOtbParser($excel_file_name, $file_name_for_summary, $worksheet_name, $file_xls_offset) {

    list($excel_line_counter, $next_excel_line_clinical_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1, $file_xls_offset);
    if(!$next_excel_line_clinical_data) return null;
    $excel_file_name_and_line_for_summary = $file_name_for_summary. " worksheet '<b>$worksheet_name</b>' and <b>line $excel_line_counter</b>";

    // Nbr of days are calculated from collection date
    $atim_qc_tf_bank_id = getSelectQueryResult("SELECT id FROM banks WHERE name = 'OTB'");
    $atim_qc_tf_bank_id = isset($atim_qc_tf_bank_id[0]['id'])? $atim_qc_tf_bank_id[0]['id'] : null;
    
    $query = "SELECT collection_datetime
		FROM participants INNER JOIN collections ON participants.id = participant_id
		WHERE qc_tf_bank_identifier  = '".str_replace(array('"', "'"), array('\"', "''"), trim($next_excel_line_clinical_data['participantBank']))."'
    		AND qc_tf_bank_id = '$atim_qc_tf_bank_id'
    		AND participant_identifier = '".str_replace(array('"', "'"), array('\"', "''"), trim($next_excel_line_clinical_data['TFRI']))."'
		AND collections.deleted <> 1 AND participants.deleted <> 1
        AND collections.collection_datetime IS NOT NULL
	    ORDER BY collections.collection_datetime ASC
	    LIMIT 0,1";
    $collection_datetime = getSelectQueryResult($query);
    $notes = '';
    if($collection_datetime) {
        $collection_datetime = substr($collection_datetime[0]['collection_datetime'], 0, 10);
        $notes = "Fake date defined based on the number of days '%d%' (defined into excel) between the first date of collection equals to '$collection_datetime' (into ATiM at the date of migration) and the event date.";
    } else {
        $collection_datetime = '2000-01-01';
        $notes = "Fake date defined based on the number of days '%d%' (defined into excel) between a (fake) first date of collection equals to '$collection_datetime' (not found into ATiM at the date of migration) and the event date.";
    }
    
    $atim_participant_data = array();

    // Participant Profile

    $migration_fields_properties = array(
        'participants' => array(
            array('TFRI', 'participant_identifier', array(), array(), false),
            array('participantBank', 'qc_tf_bank_identifier', array(), array(), false),
            array('date of birth', 'date_of_birth', array(), array(), true),
            array('Date dernier contact', 'qc_tf_last_contact', array(), array(), true),
            array('Vital Status', 'vital_status', array('dead', 'Dead'), array('deceased', 'deceased'), false),
            array('Date du décès', 'date_of_death', array(), array(), true),
            array('BRCA status', 'qc_tf_brca_status', array(''), array(), false),
            array('Family History', 'qc_tf_family_history', array(), array(), false),
            array('Post Chemo', 'qc_tf_post_chemo', array('yes', 'no', 'Yes', 'no'), array('y', 'n', 'y', 'n'), false),
            array('Notes', 'notes', array(), array(), false)),
        'diagnosis' => array(
            array('Diagnosis Date', 'dx_date', array(), array(), true),
            array('Age at Diagnosis', 'age_at_dx', array(), array(), false),
            array('Tumour Grade', 'tumour_grade', array(), array(), false),
            array('Figo', 'figo', array(), array(), false),
            array('Histopathology', 'histopathology', array('-'), array(''), false),
            array('Histopathologyrevision', 'reviewed_histopathology', array('Reviewed ', '-'), array('', ''), false),
            array('Residual disease', 'residual_disease', array(), array(), false),
            array('Progression Status', 'progression_status', array(), array(), false)),
        'ovarectomy' => array(
            array('Ovarectomy', 'start_date', array(), array(), true)),
        'recurrence' => array(
            array('Date recurrence', 'recurrence_date', array(), array(), true),
            array('Date CA125 recurrence', 'ca125_recurrence_date', array(), array(), true))
    );
    $unmigrated_fields = $next_excel_line_clinical_data;
    foreach($migration_fields_properties as $data_type => $excel_field_to_atim_field) {
        foreach($excel_field_to_atim_field as $field_properties) {
            list($excel_field, $atim_field, $search, $replace, $is_date) = $field_properties;
            $excel_field_for_summary = utf8_Decode($excel_field);
            if(!array_key_exists($excel_field, $next_excel_line_clinical_data)) {
                recordErrorAndMessage('Excel File',
                    '@@ERROR@@',
                    "Excel field does not exist. Values of the excel column won't be imported then compared to atim data for updated (<i>$file_name_for_summary</i>).",
                    "$worksheet_name :: $excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
                $atim_participant_data[$data_type][$atim_field] = array('', $excel_field_for_summary, '');
            } else {
                if(preg_match('/^\-$/', $next_excel_line_clinical_data[$excel_field])) $next_excel_line_clinical_data[$excel_field] = '';
                if($is_date) {
                    if(preg_match('/^[0-9,\.]+$/', $next_excel_line_clinical_data[$excel_field])) {
                        $next_excel_line_clinical_data[$excel_field] = str_replace(array('.',','), array('', ''), $next_excel_line_clinical_data[$excel_field]);
                        $calculated_event_date = date('Y-m-d', strtotime($collection_datetime.' +'.$next_excel_line_clinical_data[$excel_field].' days'));
                        if($calculated_event_date) {
                            $notes_to_add[$data_type][] = str_replace('%d%', $next_excel_line_clinical_data[$excel_field], "$excel_field : $notes");
                            $atim_participant_data[$data_type][$atim_field] = array($calculated_event_date, $excel_field_for_summary, 'c');
                        }
                    } else {
                        list($tmp_date, $tmp_date_accuracy) = validateAndGetDateAndAccuracy($next_excel_line_clinical_data[$excel_field], $excel_field_for_summary, "$worksheet_name::$excel_field:", "See $excel_file_name_and_line_for_summary");
                        $atim_participant_data[$data_type][$atim_field] = array($tmp_date, $excel_field_for_summary, $tmp_date_accuracy);
                    }
                } else {
                    $atim_participant_data[$data_type][$atim_field] = array(str_replace($search, $replace, $next_excel_line_clinical_data[$excel_field]), $excel_field_for_summary, null);
                }
                recordErrorAndMessage('Excel File',
                    '@@MESSAGE@@',
                    "Excel fields migrated from worksheet '$worksheet_name' (<i>$file_name_for_summary</i>).",
                    "$excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
            }
            unset($unmigrated_fields[$excel_field]);
        }
    }
    foreach($unmigrated_fields as $excel_field => $tmp) {
        $excel_field_for_summary = utf8_Decode($excel_field);
        recordErrorAndMessage('Excel File',
            '@@WARNING@@',
            "Un-migrated Excel fields from worksheet '$worksheet_name' (<i>$file_name_for_summary</i>).",
            "$excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
    }
    
    foreach($notes_to_add as $model => $notes) {
        $atim_participant_data[$model]['notes'] = array(implode(' ', $notes), 'Notes Generated By Migration Script', '');
    }
    
    return array($atim_participant_data, $excel_file_name_and_line_for_summary);
}

function getClinicalEventByOtbParser($excel_file_name, $file_name_for_summary, $worksheet_name, $file_xls_offset) {

    list($excel_line_counter, $next_excel_line_clinical_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2, $file_xls_offset);
    if(!$next_excel_line_clinical_data) return null;
    $excel_file_name_and_line_for_summary = $file_name_for_summary. " worksheet '<b>$worksheet_name</b>' and <b>line $excel_line_counter</b>";

    // Nbr of days are calculated from collection date
   	$atim_qc_tf_bank_id = getSelectQueryResult("SELECT id FROM banks WHERE name = 'OTB'");
	$atim_qc_tf_bank_id = isset($atim_qc_tf_bank_id[0]['id'])? $atim_qc_tf_bank_id[0]['id'] : null;
    
    $query = "SELECT collection_datetime
		FROM participants INNER JOIN collections ON participants.id = participant_id
		WHERE qc_tf_bank_identifier  = '".str_replace(array('"', "'"), array('\"', "''"), trim($next_excel_line_clinical_data['Patient Biobank Number (required)']))."'
    	AND qc_tf_bank_id = '$atim_qc_tf_bank_id'
    	AND participant_identifier = '".str_replace(array('"', "'"), array('\"', "''"), trim($next_excel_line_clinical_data['TFRI']))."'
		AND collections.deleted <> 1 AND participants.deleted <> 1
        AND collections.collection_datetime IS NOT NULL
	    ORDER BY collections.collection_datetime ASC
	    LIMIT 0,1";
    $collection_datetime = getSelectQueryResult($query);
    $notes = '';
    if($collection_datetime) {
        $collection_datetime = substr($collection_datetime[0]['collection_datetime'], 0, 10);
        $notes = "Fake date defined based on the number of days '%d%' (defined into excel) between the first date of collection equals to '$collection_datetime' (into ATiM at the date of migration) and the event date.";
    } else {
        $collection_datetime = '2000-01-01';
        $notes = "Fake date defined based on the number of days '%d%' (defined into excel) between a (fake) first date of collection equals to '$collection_datetime' (not found into ATiM at the date of migration) and the event date.";
    }
    
    $atim_participant_data = array();

    // Participant Profile
    
    $excel_field_to_atim_field = array(
        array('Patient Biobank Number (required)', 'qc_tf_bank_identifier', array(), array(), false),
        array('Event Type', 'type', array(), array(), false),
        array('Date of event (beginning) Date', 'start_date', array(), array(), true),
        array('Date of event (beginning) Accuracy', 'start_date_accuracy', array(), array(), false),
        array('Date of event (end) Date', 'finish_date', array(), array(), true),
        array('Date of event (end) Accuracy', 'finish_date_accuracy', array(), array(), false),
        array('Chemotherapy Precision Drug1', 'drug_1', array(), array(), false),
        array('Chemotherapy Precision Drug2', 'drug_2', array(), array(), false),
        array('Chemotherapy Precision Drug3', 'drug_3', array(), array(), false),
        array('Chemotherapy Precision Drug4', 'drug_4', array(), array(), false),
        array('CA125 Precision (U)', 'ca125', array(), array(), false) ,
        array('CT Scan Precision', 'ct_scan', array(), array(), false)
    );
    $unmigrated_fields = $next_excel_line_clinical_data;
    $notes_to_add = array();
    foreach($excel_field_to_atim_field as $field_properties) {
        list($excel_field, $atim_field, $search, $replace, $is_date) = $field_properties;
        $excel_field_for_summary = utf8_Decode($excel_field);
        if(!array_key_exists($excel_field, $next_excel_line_clinical_data)) {
            recordErrorAndMessage('Excel File',
                '@@ERROR@@',
                "Excel field does not exist. Values of the excel column won't be imported then compared to atim data for updated (<i>$file_name_for_summary</i>).",
                "$worksheet_name :: $excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
            $atim_participant_data['event'][$atim_field] = array('', $excel_field_for_summary, '');
        } else {
            if(preg_match('/^\-$/', $next_excel_line_clinical_data[$excel_field])) $next_excel_line_clinical_data[$excel_field] = '';
            if($is_date) {             
                if(preg_match('/^[0-9,\.]+$/', $next_excel_line_clinical_data[$excel_field])) {
                    $next_excel_line_clinical_data[$excel_field] = str_replace(array('.',','), array('', ''), $next_excel_line_clinical_data[$excel_field]);
                    $calculated_event_date = date('Y-m-d', strtotime($collection_datetime.' +'.$next_excel_line_clinical_data[$excel_field].' days'));
                    if($calculated_event_date) {
                        $notes_to_add[] = str_replace('%d%', $next_excel_line_clinical_data[$excel_field], "$excel_field : $notes");
                        $atim_participant_data['event'][$atim_field] = array($calculated_event_date, $excel_field_for_summary, 'c');
                    }
                } else {
                    list($tmp_date, $tmp_date_accuracy) = validateAndGetDateAndAccuracy($next_excel_line_clinical_data[$excel_field], $excel_field_for_summary, "$worksheet_name::$excel_field:", "See $excel_file_name_and_line_for_summary");
                    $atim_participant_data['event'][$atim_field] = array($tmp_date, $excel_field_for_summary, $tmp_date_accuracy);
                }
            } else {
                $atim_participant_data['event'][$atim_field] = array(str_replace($search, $replace, $next_excel_line_clinical_data[$excel_field]), $excel_field_for_summary, null);
            }
            recordErrorAndMessage('Excel File',
                '@@MESSAGE@@',
                "Excel fields migrated (<i>$file_name_for_summary</i> :: $worksheet_name).",
                "$excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
        }
        unset($unmigrated_fields[$excel_field]);
    }
    foreach($unmigrated_fields as $excel_field => $tmp) {
        $excel_field_for_summary = utf8_Decode($excel_field);
        recordErrorAndMessage('Excel File',
            '@@WARNING@@',
            "Un-migrated Excel fields (<i>$file_name_for_summary</i> - $worksheet_name).",
            "$excel_field_for_summary", "getProfileByGeneralParser.$excel_field");
    }
    
    $atim_participant_data['event']['notes'] = array(implode(' ', $notes_to_add), 'Notes Generated By Migration Script', '');
    
    return array($atim_participant_data, $excel_file_name_and_line_for_summary);
}

?>
		