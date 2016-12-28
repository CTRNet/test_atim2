<?php

/**
 * Script to dowload all participant clinical data into ATiM QBCF and link existing participant collection to the breast diagnosis event (treatment).
 *
 * Notes on clinical data:
*   - A breast diagnosis event (treamtent) will be updated if an existing one exists into ATiM with the same date and type of intervention else a new one will be created.
*   - A breast diagnosis progression (diagnosis) will be updated if an existing one exists into ATiM with the same date and site else a new one will be created.
*   - A breast diagnosis treamtent will be updated if an existing one exists into ATiM with the same start date and type of treatment else a new one will be created.
*   - An other tumor diagnosis will be updated if an existing one exists into ATiM with the same date and site else a new one will be created.
*   - An other tumor diagnosis progression will be updated if an existing one exists into ATiM with the same site else a new one will be created.
*   - An other tumor diagnosis treamtent will be updated if an existing one exists into ATiM with the same start date and type of treatment else a new one will be created.
*
* Notes on invenotry data:
*   - No collection, sample and block will be created by the script.
*   - When a breast diagnosis event is defined as event of collection of the block shipped to the chum, the script will list all participant collections existing into ATiM
*     and not already linked to a breast diagnosis event then links them to the event (treatment). No update on existing collection to breast diagnosis event will be upadted.
*/
 
require_once 'system.php';

global $atim_drugs;
$atim_drugs = array();

//==============================================================================================
// Main Code
//==============================================================================================

$tmp_files_names_list = array();

foreach($excel_files_names as $file_data) {
	list($bank, $excel_file_name, $excel_xls_offset) = $file_data;
	$tmp_files_names_list[] = $excel_file_name;
}

displayMigrationTitle('QBCF Clinical and Inventroy Data Creation or Update');

if(!testExcelFile($tmp_files_names_list)) {
	dislayErrorAndMessage();
	exit;
}

// *** PARSE EXCEL FILES ***

$file_counter = 0;
foreach($excel_files_names as $file_data) {
	$file_counter++;
	
	// New Excel File
	
	list($bank, $excel_file_name, $excel_xls_offset) = $file_data;
	$excel_file_name_for_ref = "File#$file_counter - ".((strlen($excel_file_name) > 30)? substr($excel_file_name, '0', '30')."...xls" : $excel_file_name);
	
	$banks_data = getSelectQueryResult("SELECT id, name FROM banks WHERE name like '$bank%'");
	if(!$banks_data) {
		recordErrorAndMessage('Files & Bank', '@@ERROR@@', "Bank unknown into ATiM - No file data will be migrated", "See Excel Bank '$bank'");
	} else if(sizeof($banks_data) > 1) {
		$ATiM_banks_names = array();
		foreach($banks_data as $new_bank) {
			$ATiM_banks_names[] = $new_bank['name'];
		}
		recordErrorAndMessage('Files & Bank', '@@ERROR@@', "More than one bank matches the file bank name - No file data will be migrated", "See Excel Bank '$bank' matching ATiM banks '".implode(', ', $ATiM_banks_names)."'");
	} else {
		$bank = $banks_data[0]['name'];
		recordErrorAndMessage('Files & Bank', '@@MESSAGE@@', "Excel Files Parsed", "File#$file_counter - $excel_file_name - Bank : $bank");
		
		$qbcf_bank_id = $banks_data[0]['id'];
		$qbcf_bank_participant_identifier_to_participant_id = array();
		
		//----------------------------------------------------------------------------------------------
		// Profile : 'patient' worksheet
		//----------------------------------------------------------------------------------------------
		
		$worksheet_name = 'patient';
		$summary_section_title = 'Participant Profile - Creation/Update';
		while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1, $excel_xls_offset)) {
			if($line_number > 3 && strlen($excel_line_data['Patient # in biobank'])) {
				$qbcf_bank_participant_identifier = $excel_line_data['Patient # in biobank'];
				$excel_data_references = "Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>' & Excel '<b>$excel_file_name_for_ref</b>' & Line '<b>$line_number</b>' & Worksheet '<b>$worksheet_name</b>'";
				
				// 1 ATiM PARTICIPANT DETECTION
				//..............................................................................................
				
				if(isset($qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier])) {
					
					// 1.a- PARTICIPANT DETECTION ERROR
					//..............................................................................................
					// Patient defined twice into the excel file
						
					recordErrorAndMessage('Participant Detection', '@@ERROR@@', "Paticipant defined more than once into the Excel file - No excel patient data of the lines will be migrated", "See following participant : $excel_data_references.");
					
				} else {
					
					$query = "SELECT * FROM participants WHERE qbcf_bank_id = '$qbcf_bank_id' AND qbcf_bank_participant_identifier = '$qbcf_bank_participant_identifier' AND deleted <> 1";
					$query_data = getSelectQueryResult($query);
					
					if(sizeof($query_data) > 1) {
						
						// 1.b- PARTICIPANT DETECTION ERROR
						//..............................................................................................
						// Patient defined twice into ATiM
						
						recordErrorAndMessage('Participant Detection', '@@ERROR@@', "More than one ATiM participant matches the bank patient identifier - No excel patient data will be migrated - Please fix bug into ATiM", "See following participant : $excel_data_references.");
						$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier] = null;
					
					} else {
						
						// 2 - PARTICIPANT CREATION/UPDATE
						//..............................................................................................
						
						$excel_participant_data = array(
							'qbcf_bank_id' => $qbcf_bank_id, 
							'qbcf_bank_participant_identifier' => $qbcf_bank_participant_identifier,
							'last_modification' => $import_date);
						
						// Current Status
						
						$excel_field = 'Vital Status';
						$excel_participant_data['vital_status'] = validateAndGetStructureDomainValue(str_replace(array('Died', 'died'), array('deceased', 'deceased'), $excel_line_data[$excel_field]), 'health_status', $summary_section_title, $excel_field, "See $excel_data_references");
						
						$excel_field = 'Registered Date of Death';
						$excel_field_accuracy = "$excel_field Accuracy";
						reformatExcelDate($excel_line_data, $excel_field, $excel_field_accuracy);
						list($excel_participant_data['date_of_death'], $excel_participant_data['date_of_death_accuracy']) = updateDateWithExcelAccuracy(
							validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, $excel_field, "See $excel_data_references"),
							$excel_line_data[$excel_field_accuracy]);
						
						$excel_field = 'Suspected Date of Death';
						$excel_field_accuracy = "$excel_field Accuracy";
						reformatExcelDate($excel_line_data, $excel_field, $excel_field_accuracy);
						list($excel_participant_data['qbcf_suspected_date_of_death'], $excel_participant_data['qbcf_suspected_date_of_death_accuracy']) = updateDateWithExcelAccuracy(
							validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, $excel_field, "See $excel_data_references"),
							$excel_line_data["$excel_field Accuracy"]);
							
						$excel_field = 'Date of last contact';
						$excel_field_accuracy = "$excel_field Accuracy";
						reformatExcelDate($excel_line_data, $excel_field, $excel_field_accuracy);
						list($excel_participant_data['qbcf_last_contact'], $excel_participant_data['qbcf_last_contact_accuracy']) = updateDateWithExcelAccuracy(
							validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, $excel_field, "See $excel_data_references"),
							$excel_line_data["$excel_field Accuracy"]);
							
						// Reproductive History
						
						$excel_to_atim_fields = array(
							'Gravida' => 'qbcf_gravida', 
							'Para' => 'qbcf_para', 
							'Aborta' => 'qbcf_aborta');
						foreach($excel_to_atim_fields as $excel_field => $atim_field) {
							if(strtolower($excel_line_data[$excel_field]) == 'u') {
								$excel_participant_data[$atim_field.'plus_integer_unknown'] = '1';
							} else {
								$excel_participant_data[$atim_field] = validateAndGetInteger($excel_line_data[$excel_field], $summary_section_title, $excel_field, "See $excel_data_references");
							}
						}
						
						$excel_field = 'Menopause';
						$excel_participant_data['qbcf_menopause'] = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qbcf_yes_no_unk', $summary_section_title, $excel_field, "See $excel_data_references");
						
						// Cancer History
						
						$excel_to_atim_fields = array(
							'Family History of Breast Cancer' => 'qbcf_breast_cancer_fam_hist',
							'Family History of Ovarian Cancer' => 'qbcf_ovarian_cancer_fam_hist',
							'Family History of Other Cancer' => 'qbcf_other_cancer_fam_hist');
						foreach($excel_to_atim_fields as $excel_field => $atim_field) {
							$excel_participant_data[$atim_field] = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qbcf_yes_no_unk', $summary_section_title, $excel_field, "See $excel_data_references");
						}
						
						$excel_field = 'Previous history of breast disease';
						$excel_participant_data['qbcf_breast_cancer_previous_hist'] = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qbcf_breast_cancer_previous_hist', $summary_section_title, $excel_field, "See $excel_data_references");
						
						if(!$query_data) {
							
							// 2.a - PARTICIPANT CREATION
							//..............................................................................................
							
							$participant_id = customInsertRecord(array('participants' => $excel_participant_data));
							addCreatedDataToSummary('New Participant', "Participant '$qbcf_bank_participant_identifier' of bank '$bank'", $excel_data_references);	
							$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier] = array(
								'participant_id' => $participant_id,
								'breast_diagnosis_id' => null,
								'collection_treatment_id' => null);
							
						} else {
							
							// 2.b - PARTICIPANT UPDATE
							//..............................................................................................
							
							$data_to_update = getDataToUpdate($query_data[0], $excel_participant_data);
							if(sizeof($data_to_update) > 1) {
								//last_modification always different
								updateTableData($query_data[0]['id'], array('participants' => $data_to_update));
								addUpdatedDataToSummary('Participant Profile Update', $data_to_update, $excel_data_references);
							}
							$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier] = array(
								'participant_id' => $query_data[0]['id'],
								'breast_diagnosis_id' => null,
								'collection_treatment_id' => null);
							
						}
					}
				}
			}
		} // End 'patient' worksheet
		
		//----------------------------------------------------------------------------------------------
		// Diagnosis & Treatment : 'Dx-event-Breast' worksheet
		//----------------------------------------------------------------------------------------------
		
		$worksheet_name = 'Dx-event-Breast';
		$summary_section_title = 'Breast Dx & Event - Creation/Update';
		while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1, $excel_xls_offset)) {
			if($line_number > 4 && strlen($excel_line_data['Patient # in biobank'])) {
				$qbcf_bank_participant_identifier = $excel_line_data['Patient # in biobank'];
				$excel_data_references = "Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>' & Excel '<b>$excel_file_name_for_ref</b>' & Line '<b>$line_number</b>' & Worksheet '<b>$worksheet_name</b>'";
				
				// 1- PARTICIPANT DETECTION
				//..............................................................................................
					
				if(!isset($qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier])) {
						
					// 1.a- PARTICIPANT DETECTION ERROR
					//..............................................................................................
					
					recordErrorAndMessage('Participant Detection', '@@ERROR@@', "Patient of 'Dx-event-Breast' worksheet not defined into the 'patient' worksheet - No excel diagnosis and treatment data will be migrated", "See following participant : $excel_data_references.");
					
				} else if(!in_array($excel_line_data['Type of Event'], array('Diagnostic', 'Treatment', 'Follow-up'))) {
					
					// 2- EVENT DEFINITION ERROR
					//..............................................................................................
					
					recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Type of 'Dx-event-Breast' not supported - No excel diagnosis and treatment data will be migrated", "See type '".$excel_line_data['Type of Event']."' for following participant : $excel_data_references.");
										
				} else {
						
					$type_of_event = $excel_line_data['Type of Event'];
					
					//Manage dates of event
					
					$excel_field = 'Dates of event - START';
					$excel_field_accuracy = "$excel_field Accuracy";
						reformatExcelDate($excel_line_data, $excel_field, $excel_field_accuracy);
					list($excel_start_date, $excel_start_date_accuracy) = updateDateWithExcelAccuracy(
						validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, $excel_field, "See $excel_data_references"),
						$excel_line_data["$excel_field Accuracy"]);
					
					$excel_field = 'Dates of event - END';
					$excel_field_accuracy = "$excel_field Accuracy";
					reformatExcelDate($excel_line_data, $excel_field, $excel_field_accuracy);
					list($excel_finish_date, $excel_finish_date_accuracy) = updateDateWithExcelAccuracy(
						validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, $excel_field, "See $excel_data_references"),
						$excel_line_data["$excel_field Accuracy"]);					
					
					$excel_field = 'Suspected Dates of event - END';
					$excel_field_accuracy = "$excel_field Accuracy";
					reformatExcelDate($excel_line_data, $excel_field, $excel_field_accuracy);
					list($suspected_finsih_date, $suspected_finsih_date_accuracy) = updateDateWithExcelAccuracy(
						validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, $excel_field, "See $excel_data_references"),
						$excel_line_data["$excel_field Accuracy"]);
					
					$is_suspected_finish_date = false;
					if($excel_finish_date && $suspected_finsih_date) {
						recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Both 'Dx-event-Breast' finished and supspected dates are defined - The suspected date won't be used by migration process", "See dates '$excel_finish_date' and& '$suspected_finsih_date' for following participant : $excel_data_references.");
					} else if($suspected_finsih_date) {
						$is_suspected_finish_date = true;
						$excel_finish_date = $suspected_finsih_date;
						$excel_finish_date_accuracy = $suspected_finsih_date_accuracy;
					}

					// 3 - BREAST DIAGNOSIS AND BREAST DIAGNOSIS EVENT
					//..............................................................................................
					
					// 3.a - BREAST DIAGNOSIS
					//..............................................................................................
					$specific_summary_section_title = "$summary_section_title : Breast Diagnosis";

					if(!$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id']) {
						//Only one breast diagnosis should be created per participant
						$dx_detail_tablename = $atim_controls['diagnosis_controls']['primary-breast']['detail_tablename'];
						$diagnosis_control_id = $atim_controls['diagnosis_controls']['primary-breast']['id'];
						$query = "SELECT DiagnosisMaster.id
							FROM diagnosis_masters AS DiagnosisMaster
							INNER JOIN $dx_detail_tablename AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
							WHERE DiagnosisMaster.deleted <> 1
							AND DiagnosisMaster.participant_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id']."
							AND DiagnosisMaster.diagnosis_control_id = $diagnosis_control_id;";
						$query_data = getSelectQueryResult($query);
						if($query_data) {
							if(sizeof($query_data) > 1) {
								// Two diagnoses matched the file diagnosis based on date and type of intervention
								recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "More than one ATiM breast diagnosis exists for the participant - System will use the first one but please clean up ATiM data.", "See breast diagnosis for following participant : $excel_data_references.");
							}
							$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id'] = $query_data['0']['id'];
						} else {
							$excel_breast_diagnosis_data = array(
								'diagnosis_masters' =>
									array('participant_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id'] ,
										'diagnosis_control_id' => $diagnosis_control_id),
								$dx_detail_tablename => array());
							$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id'] = customInsertRecord($excel_breast_diagnosis_data);
							addCreatedDataToSummary('New Breast Diagnosis', "Participant '$qbcf_bank_participant_identifier' of bank '$bank'", $excel_data_references);
						}
					}
										
					// 3.b - BREAST DIAGNOSIS EVENT
					
					$specific_summary_section_title = "$summary_section_title : Breast Diagnostic Event";
					
					$tx_detail_tablename = $atim_controls['treatment_controls']['breast diagnostic event']['detail_tablename'];
					$treatment_control_id = $atim_controls['treatment_controls']['breast diagnostic event']['id'];
					$excel_breast_diagnosis_event_data = array('treatment_masters' => array(), $tx_detail_tablename => array());
					
					// Manage data
					
					$excel_field = 'Age at Time of intervention';
					$excel_breast_diagnosis_event_data[$tx_detail_tablename]['age_at_dx'] = validateAndGetInteger($excel_line_data[$excel_field], $specific_summary_section_title, $excel_field, "See $excel_data_references");
					
					$excel_breast_diagnosis_event_data['treatment_masters']['notes'] = $excel_line_data['Note'];
					
					$excel_to_atim_fields = array(
						array('Type of intervention',$tx_detail_tablename,'type_of_intervention','qbcf_type_of_intervention'),
						array('Laterality', $tx_detail_tablename, 'laterality', 'qbcf_laterality'),
						array('Clinical Anatomic Stage', $tx_detail_tablename, 'clinical_stage_summary', 'qbcf_clinical_anatomic_stage'),
						array('TNM (cT)', $tx_detail_tablename, 'clinical_tstage', 'qbcf_tnm_ct'),
						array('TNM (cN)', $tx_detail_tablename, 'clinical_nstage', 'qbcf_tnm_cn'),
						array('TNM (cM)', $tx_detail_tablename, 'clinical_mstage', 'qbcf_tnm_cm'),
						array('Pathological Anatomic Stage', $tx_detail_tablename, 'path_stage_summary', 'qbcf_pathological_anatomic_stage'),
						array('TNM (pT)', $tx_detail_tablename, 'path_tstage', 'qbcf_tnm_pt'),
						array('TNM (pN)', $tx_detail_tablename, 'path_nstage', 'qbcf_tnm_pn'),
						array('TNM (pM)', $tx_detail_tablename, 'path_mstage', 'qbcf_tnm_pm'),
						array('Morphology', $tx_detail_tablename, 'morphology', 'qbcf_morphology'),
						array('Grade Notthingham / SBR-EE', $tx_detail_tablename, 'grade_notthingham_sbr_ee', 'qbcf_grade_notthingham_sbr_ee'),
						array('Glandular (Acinar)/ Tubular Differentiation', $tx_detail_tablename, 'glandular_acinar_tubular_differentiation', 'qbcf_glandular_acinar_tubular_differentiation'),
						array('Nuclear Pleomorphism', $tx_detail_tablename, 'nuclear_pleomorphism', 'qbcf_nuclear_pleomorphism'),
						array('Mitotic Rate', $tx_detail_tablename, 'mitotic_rate', 'qbcf_mitotic_rate'),
						array('Margin Status', $tx_detail_tablename, 'margin_status', 'qbcf_margin_status'),
						array('Number of positive Regional LN (Category)', $tx_detail_tablename, 'number_of_positive_regional_ln_category', 'qbcf_number_of_positive_regional_ln_category'),
						array('ER Overall (From path report)', $tx_detail_tablename, 'er_overall', 'qbcf_er_overall'),
						array('ER Intensity', $tx_detail_tablename, 'er_intensity', 'qbcf_er_intensity'),
						array('PR Overall (in path report)', $tx_detail_tablename, 'pr_overall', 'qbcf_pr_overall'),
						array('PR Intensity', $tx_detail_tablename, 'pr_intensity', 'qbcf_pr_intensity'),
						array('HER2 IHC', $tx_detail_tablename, 'her2_ihc', 'qbcf_her2_ihc'),
						array('HER2 FISH', $tx_detail_tablename, 'her2_fish', 'qbcf_her2_fish'));
					foreach($excel_to_atim_fields as $excel_to_atim_field) {
						list($excel_field, $atim_table_name, $atim_field, $domain_name) = $excel_to_atim_field;
						//Clean up data
						$excel_line_data[$excel_field] = preg_replace(
							array('/^na$/i', '/^na, event not related to dx$/i', '/^equivoqual$/i'), 
							array('', '', 'equivocal'), 
							$excel_line_data[$excel_field]);
						switch($domain_name) {
							case 'qbcf_tnm_ct':
							case 'qbcf_tnm_pt':
								$excel_line_data[$excel_field] = preg_replace('/^((1[abc])|(1(mi)))$/i', 'T$2$4', $excel_line_data[$excel_field]);
								break;
							case 'qbcf_grade_notthingham_sbr_ee':
							case 'qbcf_glandular_acinar_tubular_differentiation':
							case 'qbcf_nuclear_pleomorphism':
							case 'qbcf_mitotic_rate':
								$excel_line_data[$excel_field] = $excel_line_data[$excel_field];
								break;
							case 'qbcf_pr_intensity':
							case 'qbcf_er_intensity':
								$excel_line_data[$excel_field] = preg_replace(array('/^negative$/i', '/^unknown$/i'), array('Negative/background', 'Unknown, not provided'), $excel_line_data[$excel_field]);
								break;
							case 'qbcf_er_overall':
							case 'qbcf_pr_overall':
								$excel_line_data[$excel_field] = preg_replace('/^unknown$/i', 'Unknown, not provided', $excel_line_data[$excel_field]);
								break;
							case 'qbcf_number_of_positive_regional_ln_category':
								$excel_line_data[$excel_field] = preg_replace('/^u$/i', 'Unknown', $excel_line_data[$excel_field]);
								break;
						}
						//Get data
						$excel_breast_diagnosis_event_data[$atim_table_name][$atim_field] = 
							validateAndGetStructureDomainValue($excel_line_data[$excel_field], $domain_name, $specific_summary_section_title, $excel_field, "See $excel_data_references");
					}
	
					$excel_to_atim_fields = array(
						array('ER Percent', $tx_detail_tablename, 'er_percent'),
						array('PR Percent', $tx_detail_tablename, 'pr_percent'),
						array('Tumor size', $tx_detail_tablename, 'tumor_size'));
					foreach($excel_to_atim_fields as $excel_to_atim_field) {
						list($excel_field, $atim_table_name, $atim_field) = $excel_to_atim_field;
						$excel_breast_diagnosis_event_data[$atim_table_name][$atim_field] = validateAndGetDecimal($excel_line_data[$excel_field], $specific_summary_section_title, $excel_field, "See $excel_data_references");
					}
					
					$excel_to_atim_fields = array(
						array('Number of Positive Regional LN', $tx_detail_tablename, 'number_of_positive_regional_ln'),
						array('Total number of Regional LN analysed', $tx_detail_tablename, 'total_number_of_regional_ln_analysed'),
						array('Number of Positive Sentinel LN', $tx_detail_tablename, 'number_of_positive_sentinel_ln'),
						array('Total number of Sentinel LN analysed', $tx_detail_tablename, 'total_number_of_sentinel_ln_analysed'));
					foreach($excel_to_atim_fields as $excel_to_atim_field) {
						list($excel_field, $atim_table_name, $atim_field) = $excel_to_atim_field;
						if(strtolower($excel_line_data[$excel_field]) == 'u') {
							$excel_breast_diagnosis_event_data[$atim_table_name][$atim_field.'_integer_unknown'] = '1';
						} else {
							$excel_breast_diagnosis_event_data[$atim_table_name][$atim_field] = validateAndGetInteger($excel_line_data[$excel_field], $specific_summary_section_title, $excel_field, "See $excel_data_references");
						}
					}
					
					$her2_fish = $excel_breast_diagnosis_event_data[$tx_detail_tablename]['her2_fish'];
					$her2_ihc = $excel_breast_diagnosis_event_data[$tx_detail_tablename]['her2_ihc'];
					$er_overall = $excel_breast_diagnosis_event_data[$tx_detail_tablename]['er_overall'];
					$pr_overall = $excel_breast_diagnosis_event_data[$tx_detail_tablename]['pr_overall'];
					
					// Generated data
					
					$her_2_status = '';
					switch($her2_fish) {
						case 'positive':
							$her_2_status = 'positive';
							break;
						case 'negative':
							$her_2_status = 'negative';
							break;
						case 'equivocal':
							if($her2_ihc == 'positive') $her_2_status = 'positive';
							if($her2_ihc == 'negative') $her_2_status = 'equivocal';
							break;
						case 'unknown':
							if($her2_ihc == 'positive') $her_2_status = 'positive';
							if($her2_ihc == 'negative') $her_2_status = 'negative';
					}
					$excel_breast_diagnosis_event_data[$tx_detail_tablename]['her_2_status'] = $her_2_status;
						
					$tnbc = '';
					if($her_2_status == 'negative' && $er_overall == 'negative' && $pr_overall == 'negative' ) {
						$tnbc = 'yes';
					} else if($her_2_status == 'positive' || $er_overall == 'positive' || $pr_overall == 'positive' ) {
						$tnbc = 'no';
					} else if($her_2_status == 'unknown' || $er_overall == 'unknown' || $pr_overall == 'unknown' ) {
						$tnbc = 'unknown';
					} else if($her_2_status == 'equivocal' && $er_overall == 'negative' && $pr_overall == 'negative' ) {
						$tnbc = 'equivocal';
					}
					$excel_breast_diagnosis_event_data[$tx_detail_tablename]['tnbc'] = $tnbc;
					
					// Treatment creation or update
					
					$excel_breast_diagnosis_event_data['treatment_masters'] = array_filter($excel_breast_diagnosis_event_data['treatment_masters'], function($var){return (!($var == '' || is_null($var)));});
					$excel_breast_diagnosis_event_data[$tx_detail_tablename] = array_filter($excel_breast_diagnosis_event_data[$tx_detail_tablename], function($var){return (!($var == '' || is_null($var)));});
					if(empty($excel_breast_diagnosis_event_data['treatment_masters']) && empty ($excel_breast_diagnosis_event_data[$tx_detail_tablename])) $excel_breast_diagnosis_event_data = array();

					if($type_of_event == 'Diagnostic' && empty($excel_breast_diagnosis_event_data)) {
						recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "No breast diagnosis event data defined into excel for 'Diagnostic' event type - No excel diagnosis event data will be migrated", "See following participant : $excel_data_references.");
					
					} else if($type_of_event != 'Diagnostic' && !empty($excel_breast_diagnosis_event_data)) {
						recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Excel breast diagnosis event data defined into excel for event type different than 'Diagnostic' - No excel diagnosis event data will be migrated", "See following participant : $excel_data_references.");
					
					} else if($type_of_event == 'Diagnostic' && !empty($excel_breast_diagnosis_event_data)) {
						if(!array_key_exists('type_of_intervention', $excel_breast_diagnosis_event_data[$tx_detail_tablename])) {
							recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "Breast diagnosis event intervention type not defined (or erased by migration script after value check) - No excel diagnosis event data will be migrated", "See following participant : $excel_data_references.");
								
						} else {
						
							//Add missing information
							
							$excel_breast_diagnosis_event_data['treatment_masters'] = array_merge(
								array('participant_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id'],
									'treatment_control_id' => $treatment_control_id,
									'diagnosis_master_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id'],
									'start_date' => $excel_start_date,
									'start_date_accuracy' => $excel_start_date_accuracy),
								$excel_breast_diagnosis_event_data['treatment_masters']);
							
							//Check treatment should be updated or created
							
							$atim_breast_diagnosis_event_data = array();
							$query = "SELECT *
								FROM treatment_masters AS TreatmentMaster
								INNER JOIN $tx_detail_tablename AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
								WHERE TreatmentMaster.deleted <> 1
								AND TreatmentMaster.participant_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id']."
								AND TreatmentMaster.treatment_control_id = $treatment_control_id
								AND TreatmentMaster.diagnosis_master_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id']."
								AND TreatmentMaster.start_date = '$excel_start_date'
								AND TreatmentMaster.start_date_accuracy = '$excel_start_date_accuracy'
								AND TreatmentDetail.type_of_intervention = '".$excel_breast_diagnosis_event_data[$tx_detail_tablename]['type_of_intervention']."';";
							$query_data = getSelectQueryResult($query);
							if($query_data) {
								if(sizeof($query_data) > 1) {
									// Two treatments matched the file diagnosis based on date and type of intervention
									recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "More than one ATiM breast diagnosis event matches the excel participant diagnosis event based on date and the type of intervention - System will only compare excel data to the first ATiM record and update data of this one if required.", "See breast diagnosis event for following participant : $excel_data_references.");
								}
								$atim_breast_diagnosis_event_data = $query_data[0];
								if($excel_start_date_accuracy != 'c') {
									recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "An ATiM breast diagnosis event matches the excel participant diagnosis event based on date and the type of intervention,  but date is unlcear. System will compare excel data to ATiM data but please confrim.", "See breast diagnosis event for following participant : $excel_data_references.");
								}
							}
							
							$excel_breast_diagnosis_event_data[$tx_detail_tablename]['specimen_sent_to_chum_in_excel'] = (strtolower($excel_line_data['Specimen sent to CHUM']) == 'yes')? 'y' : 'n';
							
							$treatment_master_id = null;
							if(!$atim_breast_diagnosis_event_data) {
							
								// 3.b.1 - BREAST DIAGNOSIS EVENT CREATION
								
								$treatment_master_id = customInsertRecord($excel_breast_diagnosis_event_data);
								addCreatedDataToSummary('New Breast Diagnosis Event', "Participant '$qbcf_bank_participant_identifier' of bank '$bank' : Intervention '".$excel_breast_diagnosis_event_data[$tx_detail_tablename]['type_of_intervention']."' on '".($excel_start_date? $excel_start_date : 'Missing Date')."'", $excel_data_references);
								
							} else {
							
								// 3.b.2 - BREAST DIAGNOSIS EVENT  UPDATE
							
								$treatment_master_id = $atim_breast_diagnosis_event_data['id'];
								$data_to_update = array(
									'treatment_masters' => getDataToUpdate($atim_breast_diagnosis_event_data, $excel_breast_diagnosis_event_data['treatment_masters']),
									$tx_detail_tablename => getDataToUpdate($atim_breast_diagnosis_event_data, $excel_breast_diagnosis_event_data[$tx_detail_tablename]));
								if(sizeof($data_to_update['treatment_masters']) || sizeof($data_to_update[$tx_detail_tablename])) {
									updateTableData($treatment_master_id, $data_to_update);
									addUpdatedDataToSummary('Breast Diagnosis Event Update', array_merge($data_to_update['treatment_masters'], $data_to_update[$tx_detail_tablename]), $excel_data_references);
								}
								
							}
							if($excel_breast_diagnosis_event_data[$tx_detail_tablename]['specimen_sent_to_chum_in_excel'] == 'y') {
								if($qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['collection_treatment_id']) {
									recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "Two patient breast diagnosis events are defined as linked to specimen - Only the first one will be linked to the inventory, please validate and add correction if required into ATiM after the migration.", "See diagnosis for following participant : $excel_data_references.");
								} else {
									$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['collection_treatment_id'] = $treatment_master_id;
								}
							}
						}
					}
					
					// 4 - BREAST PROGRESSION DIAGNOSIS
					//..............................................................................................
								
					$specific_summary_section_title = "$summary_section_title : Breast Progression Diagnosis";
						
					$dx_detail_tablename = $atim_controls['diagnosis_controls']['secondary - distant-breast progression']['detail_tablename'];
					$diagnosis_control_id = $atim_controls['diagnosis_controls']['secondary - distant-breast progression']['id'];
					$excel_breast_progression_diagnosis_data = array('diagnosis_masters' => array(), $dx_detail_tablename => array());
						
					// Manage data
						
					$excel_to_atim_fields = array(
						array('Progression site',$dx_detail_tablename,'site','qbcf_diagnosis_progression_sites'),
						array('Progression label', $dx_detail_tablename, 'label', 'qbcf_diagnosis_progression_labels'));
					foreach($excel_to_atim_fields as $excel_to_atim_field) {
						list($excel_field, $atim_table_name, $atim_field, $domain_name) = $excel_to_atim_field;
						//Clean up data
						$excel_line_data[$excel_field] = preg_replace(
								array('/^na$/i', '/^na, event not related to dx$/i'),
								array('', ''),
								$excel_line_data[$excel_field]);
						$excel_line_data[$excel_field] = str_replace(' (ex. imaging)', '', $excel_line_data[$excel_field]);
						//Get data
						$excel_breast_progression_diagnosis_data[$atim_table_name][$atim_field] =
							validateAndGetStructureDomainValue($excel_line_data[$excel_field], $domain_name, $specific_summary_section_title, $excel_field, "See $excel_data_references");
					}
					if(preg_match('/breast/', $excel_breast_progression_diagnosis_data[$dx_detail_tablename]['site'])) {
						recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "Breast progression defined into the excel file - Please create a Breast Diagnosis Event manually into ATiM if this one does not exist.", "See following participant : $excel_data_references.");
					}					
					
					// Diagnosis creation or update
						
					$excel_breast_progression_diagnosis_data['diagnosis_masters'] = array_filter($excel_breast_progression_diagnosis_data['diagnosis_masters'], function($var){return (!($var == '' || is_null($var)));});
					$excel_breast_progression_diagnosis_data[$dx_detail_tablename] = array_filter($excel_breast_progression_diagnosis_data[$dx_detail_tablename], function($var){return (!($var == '' || is_null($var)));});
					if(empty($excel_breast_progression_diagnosis_data['diagnosis_masters']) && empty ($excel_breast_progression_diagnosis_data[$dx_detail_tablename])) $excel_breast_progression_diagnosis_data = array();
					
					if($type_of_event == 'Follow-up' && empty($excel_breast_progression_diagnosis_data)) {
						recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "No diagnosis progression data defined into excel for 'Follow-up' event type - No excel diagnosis progression data will be migrated", "See following participant : $excel_data_references.");
							
					} else if($type_of_event != 'Follow-up' && !empty($excel_breast_progression_diagnosis_data)) {
						recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Diagnosis progression data defined into excel for event type different than 'Follow-up' - No excel diagnosis progression data will be migrated", "See following participant : $excel_data_references.");
							
					} else if($type_of_event == 'Follow-up' && !empty($excel_breast_progression_diagnosis_data)) {
						if(!array_key_exists('site', $excel_breast_progression_diagnosis_data[$dx_detail_tablename])) {
							recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "Breast progression diagnosis site not defined (or erased by migration script after value check) - No excel diagnosis progression data will be migrated", "See following participant : $excel_data_references.");
					
						} else {
					
							//Add missing information
								
							$excel_breast_progression_diagnosis_data['diagnosis_masters'] = array_merge(
								array('participant_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id'],
									'diagnosis_control_id' => $diagnosis_control_id,
									'primary_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id'],
									'parent_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id'],
									'dx_date' => $excel_start_date,
									'dx_date_accuracy' => $excel_start_date_accuracy),
								$excel_breast_progression_diagnosis_data['diagnosis_masters']);
								
							//Check diagnosis should be updated or created
								
							$atim_diagnosis_data = array();
							$query = "SELECT *
								FROM diagnosis_masters AS DiagnosisMaster
								INNER JOIN $dx_detail_tablename AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
								WHERE DiagnosisMaster.deleted <> 1
								AND DiagnosisMaster.participant_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id']."
								AND DiagnosisMaster.diagnosis_control_id = $diagnosis_control_id
								AND DiagnosisMaster.parent_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id']."
								AND DiagnosisMaster.dx_date = '$excel_start_date'
								AND DiagnosisMaster.dx_date_accuracy = '$excel_start_date_accuracy'
								AND DiagnosisDetail.site = '".$excel_breast_progression_diagnosis_data[$dx_detail_tablename]['site']."';";
							$query_data = getSelectQueryResult($query);
							if($query_data) {
								if(sizeof($query_data) > 1) {
									// Two diagnoses matched the file diagnosis based on date and site
									recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "More than one ATiM breast progression diagnosis matches the excel participant diagnosis progression based on date and the site of the progression - System will only compare excel data to the first ATiM record and update data of this one if required.", "See breast diagnosis progression for following participant : $excel_data_references.");
								}
								$atim_diagnosis_data = $query_data[0];
								if($excel_start_date_accuracy != 'c') {
									recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "An ATiM breast progression diagnosis matches the excel participant diagnosis progression based on date and the site of the progression,  but date is unlcear. System will compare excel data to ATiM data but please confrim.", "See breast diagnosis progression for following participant : $excel_data_references.");
								}
							}
								
							if(!$atim_diagnosis_data) {
									
								// 4.a - BREAST PROGRESSION DIAGNOSIS CREATION
									
								$diagnosis_master_id = customInsertRecord($excel_breast_progression_diagnosis_data);
								addCreatedDataToSummary('New Breast Progression Diagnosis', "Participant '$qbcf_bank_participant_identifier' of bank '$bank' : Site '".$excel_breast_progression_diagnosis_data[$dx_detail_tablename]['site']."' on '".($excel_start_date? $excel_start_date : 'Missing Date')."'", $excel_data_references);
					
							} else {
									
								// 4.b - BREAST PROGRESSION DIAGNOSIS  UPDATE
									
								$data_to_update = array(
									'diagnosis_masters' => getDataToUpdate($atim_diagnosis_data, $excel_breast_progression_diagnosis_data['diagnosis_masters']),
									$dx_detail_tablename => getDataToUpdate($atim_diagnosis_data, $excel_breast_progression_diagnosis_data[$dx_detail_tablename]));
								if(sizeof($data_to_update['diagnosis_masters']) || sizeof($data_to_update[$dx_detail_tablename])) {
									updateTableData($atim_diagnosis_data['id'], $data_to_update);
									addUpdatedDataToSummary('Breast Progression Diagnosis Update', array_merge($data_to_update['diagnosis_masters'], $data_to_update[$dx_detail_tablename]), $excel_data_references);
								}
					
							}
						}
					}
					
					// 5 - TREATMENT
					//..............................................................................................
					
					$specific_summary_section_title = "$summary_section_title : Breast Treatment";
					
					$excel_systemic_treatment_data_set = false;
					$treatment_fields = array('Clinical Trial/ Protocol Used',
						'Systemic treatement - Treatment completed', 
						'Systemic treatement - Number of cycles planned', 
						'Systemic treatement - Number of cycles received', 
						'Drug 1', 
						'Drug 2', 
						'Drug 3', 
						'Drug 4');
					foreach($treatment_fields as $new_field) if(strlen($excel_line_data[$new_field])) $excel_systemic_treatment_data_set = true;
					
					$excel_radiation_treatment_data_set = false;
					$treatment_fields = array('Radiation Type', 
						'Radiation Completed',
						'Conventional-Number of cycles', 
						'Conventional - Dose (number of Gray)', 
						'Boost - Number of cycles', 
						'Boost- Dose (number of Gray)', 
						'Brachytherapy - Number of cycles', 	
						'Brachytherapy (number of Gray)');									
					foreach($treatment_fields as $new_field) if(strlen($excel_line_data[$new_field])) $excel_radiation_treatment_data_set = true;
					
					if($type_of_event == 'Treatment' && !$excel_systemic_treatment_data_set && !$excel_radiation_treatment_data_set && !strlen($excel_line_data['Treatment Type'])) {
						recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "No breast treatment data defined into excel for 'Treatment' event type - No excel treatment data will be migrated", "See following participant : $excel_data_references.");
							
					} else if($type_of_event != 'Treatment' && ($excel_systemic_treatment_data_set || $excel_radiation_treatment_data_set || strlen($excel_line_data['Treatment Type']))) {
						recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Breast treatment data defined into excel for event type different than 'Treatment' - No excel treatment data will be migrated", "See following participant : $excel_data_references.");
							
					} else if($type_of_event == 'Treatment' && ($excel_systemic_treatment_data_set || $excel_radiation_treatment_data_set || strlen($excel_line_data['Treatment Type']))) {
						$excel_treatment_type_to_atim_control_type = array(
							'hormonotherapy' => 'hormonotherapy', 
							'chemotherapy' => 'chemotherapy',
							'bone specific' => 'bone specific therapy',
							'immunotherapy' => 'immunotherapy', 
							'immunotherapy (trastuzumab)' => 'immunotherapy', 
							'radiation' => 'radiotherapy', 
							'other' => 'other (breast cancer systemic treatment)');
						$excel_treatment_type = strtolower($excel_line_data['Treatment Type']);
						if(!in_array($excel_treatment_type, array_keys($excel_treatment_type_to_atim_control_type))) {
							recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "Breast treatment type not defined or not supported - No excel treatment data will be migrated", "See treatment '".(strlen($excel_treatment_type)? $excel_treatment_type : '(Empty cell)')."' for following participant : $excel_data_references.");
					
						} else {
							if(!array_key_exists($excel_treatment_type_to_atim_control_type[$excel_treatment_type], $atim_controls['treatment_controls'])) die('ERR_8983993');
							$atim_treatment_control_data = $atim_controls['treatment_controls'][$excel_treatment_type_to_atim_control_type[$excel_treatment_type]];
							$tx_detail_tablename= $atim_treatment_control_data['detail_tablename'];
							
							$excel_treatment_data = array(
								'treatment_masters' => array(
									'participant_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id'] ,
									'treatment_control_id' => $atim_treatment_control_data['id'],
									'diagnosis_master_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id'],
									'start_date' => $excel_start_date,
									'start_date_accuracy' => $excel_start_date_accuracy,
									'finish_date' => $excel_finish_date,
									'finish_date_accuracy' => $excel_finish_date_accuracy,
									'qbcf_suspected_finish_date' => $is_suspected_finish_date? '1' : '0'),
								$tx_detail_tablename => array());
							
							if($atim_treatment_control_data['tx_method'] == 'radiotherapy') {
								
								// 5.a - RADIATION
								
								if(!$excel_radiation_treatment_data_set) {
									recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "Excel breast treatment type is a radiation but no raditation data found into excel - Treatment will be created with no detail. Please confirm.", "See '".$excel_line_data['Treatment Type']."' treatment for following participant : $excel_data_references.");
								}
								if($excel_systemic_treatment_data_set) {
									recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "Excel breast treatment type is a radiation but some systemic treatment detail data found into excel - Treatment will be created but all systemic data won't be mirgated. Please confirm.", "See '".$excel_line_data['Treatment Type']."' treatment for following participant : $excel_data_references.");
								}
								
								// Treatment data
								
								$excel_field = 'Radiation Type';
								$atim_field = 'type';
								$domain_name = 'qbcf_txd_radio_types';
								$excel_treatment_data[$tx_detail_tablename][$atim_field] =
									validateAndGetStructureDomainValue($excel_line_data[$excel_field], $domain_name, $specific_summary_section_title, $excel_field, "See $excel_data_references");

								$excel_field = 'Radiation Completed';
								$atim_field = 'completed';
								$domain_name = 'qbcf_yes_no_unk';
								$excel_treatment_data[$tx_detail_tablename][$atim_field] =
									validateAndGetStructureDomainValue($excel_line_data[$excel_field], $domain_name, $specific_summary_section_title, $excel_field, "See $excel_data_references");
								
								$excel_to_atim_fields = array(
									array('Conventional - Dose (number of Gray)', $tx_detail_tablename, 'dose_conventional'),
									array('Boost- Dose (number of Gray)', $tx_detail_tablename, 'dose_boost'),
									array('Brachytherapy (number of Gray)', $tx_detail_tablename, 'dose_brachytherapy'));
								foreach($excel_to_atim_fields as $excel_to_atim_field) {
									list($excel_field, $tx_detail_tablename, $atim_field) = $excel_to_atim_field;
									if(strtolower($excel_line_data[$excel_field]) == 'u') {
										$excel_treatment_data[$tx_detail_tablename][$atim_field.'_decimal_unknown'] = '1';
									} else {
										if(strlen($excel_line_data[$excel_field]) && !preg_match('/^[0-9]+([\.,][0-9]+){0,1}$/', $excel_line_data[$excel_field])) {
											recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "Excel value format different than a decimal value. Please confirm.", "See '$excel_field' value '".$excel_line_data[$excel_field]."' for participant : $excel_data_references.");
										}
										$excel_treatment_data[$tx_detail_tablename][$atim_field] = $excel_line_data[$excel_field];
										//$excel_treatment_data[$tx_detail_tablename][$atim_field] = validateAndGetDecimal($excel_line_data[$excel_field], $specific_summary_section_title, $excel_field, "See $excel_data_references");
									}
								}
									
								$excel_to_atim_fields = array(
									array('Conventional-Number of cycles', $tx_detail_tablename, 'num_cycles_conventional'),
									array('Boost - Number of cycles', $tx_detail_tablename, 'num_cycles_boost'),
									array('Brachytherapy - Number of cycles', $tx_detail_tablename, 'num_cycles_brachytherapy'));
								foreach($excel_to_atim_fields as $excel_to_atim_field) {
									list($excel_field, $tx_detail_tablename, $atim_field) = $excel_to_atim_field;
									if(strtolower($excel_line_data[$excel_field]) == 'u') {
										$excel_treatment_data[$tx_detail_tablename][$atim_field.'_integer_unknown'] = '1';
									} else {
										if(strlen($excel_line_data[$excel_field]) && !preg_match('/^[0-9]*$/', $excel_line_data[$excel_field])) {
											recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "Excel value format different than an integer value. Please confirm.", "See '$excel_field' value '".$excel_line_data[$excel_field]."' for participant : $excel_data_references.");
										}
										$excel_treatment_data[$tx_detail_tablename][$atim_field] = $excel_line_data[$excel_field];
										//$excel_treatment_data[$tx_detail_tablename][$atim_field] = validateAndGetInteger($excel_line_data[$excel_field], $specific_summary_section_title, $excel_field, "See $excel_data_references");
									}
								}
								
								//Check treatment should be updated or created
									
								$atim_treatment_data = array();
								$query = "SELECT TreatmentMaster.*, TreatmentDetail.*
									FROM treatment_masters AS TreatmentMaster
									INNER JOIN ".$tx_detail_tablename." AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
									WHERE TreatmentMaster.deleted <> 1
									AND TreatmentMaster.participant_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id']."
									AND TreatmentMaster.treatment_control_id = ".$atim_treatment_control_data['id']."
									AND TreatmentMaster.diagnosis_master_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id']."
									AND TreatmentMaster.start_date = '$excel_start_date'
									AND TreatmentMaster.start_date_accuracy = '$excel_start_date_accuracy';";
								$query_data = getSelectQueryResult($query);
								if($query_data) {
									if(sizeof($query_data) > 1) {
										// Two treatments matched the file treatment based on date and type
										recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "More than one ATiM breast treatment matches the excel treatment based on the start date and the type of the treatment - System will only compare excel data to the first ATiM record and update data of this one if required.", "See '".$excel_line_data['Treatment Type']."' treatment for following participant : $excel_data_references.");
									}
									$atim_treatment_data = $query_data[0];
									if($excel_start_date_accuracy != 'c') {
										recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "An ATiM breast treatment matches the excel treatment based on the start date and the type of the treatment,  but date is unlcear. System will compare excel data to ATiM data but please confrim.", "See '".$excel_line_data['Treatment Type']."' treatment for following participant : $excel_data_references.");
									}
								}
									
								if(!$atim_treatment_data) {
										
									// 5.a.1 - SYSTEMIC TREATMENT CREATION
									
									$treatment_master_id = customInsertRecord($excel_treatment_data);
									addCreatedDataToSummary('New Breast Treatment', "Participant '$qbcf_bank_participant_identifier' of bank '$bank' : '".$excel_line_data['Treatment Type']."' treatment on '".($excel_start_date? $excel_start_date : 'Missing Date')."'", $excel_data_references);
										
								} else {
										
									/// 5.a.2 - SYSTEMIC TREATMENT UPDATE
										
									$data_to_update = array(
											'treatment_masters' => getDataToUpdate($atim_treatment_data, $excel_treatment_data['treatment_masters']),
											$tx_detail_tablename => getDataToUpdate($atim_treatment_data, $excel_treatment_data[$tx_detail_tablename]));
									if(sizeof($data_to_update['treatment_masters']) || sizeof($data_to_update[$tx_detail_tablename])) {
										updateTableData($atim_treatment_data['treatment_master_id'], $data_to_update);
										addUpdatedDataToSummary('Breast Treatment Update ('.$excel_line_data['Treatment Type'].")", array_merge($data_to_update['treatment_masters'], $data_to_update[$tx_detail_tablename]), $excel_data_references);
									}
								}
								
							} else {
								
								// 5.b SYSTEMIC TREATMENT
								
								if(!$excel_systemic_treatment_data_set) {
									recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "Excel treatment type is a systemic breast treatment but no systemic treatment data found into excel - Treatment will be created with no detail. Pleas confirm.", "See '".$excel_line_data['Treatment Type']."' treatment for following participant : $excel_data_references.");
								}
								if($excel_radiation_treatment_data_set) {
									recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "Excel treatment type is a systemic breast treatment but some radiation treatment data found into excel - Treatment will be created but all radiation data won't be mirgated. Please confirm.", "See '".$excel_line_data['Treatment Type']."' treatment for following participant : $excel_data_references.");
								}
								
								// Treatment data
								
								$excel_treatment_data['treatment_masters']['qbcf_clinical_trial_protocol_number'] = $excel_line_data['Clinical Trial/ Protocol Used'];
								
								foreach(array('Systemic treatement - Number of cycles planned' => 'num_cycles_planned',	'Systemic treatement - Number of cycles received' => 'num_cycles_received',	'Systemic treatement - Treatment completed' => 'cycles_completed') as $excel_field => $atim_field) {
									if($atim_treatment_control_data['tx_method'] == 'bone specific therapy' && strlen($excel_line_data[$excel_field])) {
										recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "'$excel_field' defined into excel for a '".$excel_line_data['Treatment Type']."' (systemic breast treatment) - Value won't be mirgated. Please confirm.", "See '".$excel_line_data['Treatment Type']."' treatment for following participant : $excel_data_references.");
									} else if($atim_treatment_control_data['tx_method'] != 'bone specific therapy') {
										if($excel_field == 'Systemic treatement - Treatment completed') {
											$excel_treatment_data[$tx_detail_tablename]['cycles_completed'] = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qbcf_yes_no_unk', $specific_summary_section_title, $excel_field, "See $excel_data_references");
										} else {
											if(strtolower($excel_line_data[$excel_field]) == 'u') {
												$excel_treatment_data[$tx_detail_tablename][$atim_field.'_unknown'] = '1';
											} else {
												$excel_treatment_data[$tx_detail_tablename][$atim_field] = $excel_line_data[$excel_field];
											}
										}
									}
								}
								
								// Drugs
								
								$atim_drug_type = str_replace(array('bone specific therapy', 'hormonotherapy', 'other (breast cancer systemic treatment)'), array('bone specific', 'hormonal', 'other'), $excel_treatment_type_to_atim_control_type[$excel_treatment_type]);
								$atim_drug_ids_to_link_to_treatment = array();
								for($i = 1; $i < 5; $i ++) {
									$key = 'Drug '.$i;
									if(!in_array($excel_line_data[$key], array('', 'no', 'unknown', 'NA, event not related to Systemic treatment  or no combination used'))){
										$atim_drug_ids_to_link_to_treatment['Drug-'.$i] = getDrugId($excel_line_data[$key], $atim_drug_type, $excel_data_references);
									}
								}
								$atim_drug_ids_to_link_to_treatment = array_filter($atim_drug_ids_to_link_to_treatment);
								
								//Check treatment should be updated or created
									
								$atim_treatment_data = array();
								$query = "SELECT TreatmentMaster.*, TreatmentDetail.*, GROUP_CONCAT(TreatmentExtendMaster.drug_id SEPARATOR ',') as drug_ids
									FROM treatment_masters AS TreatmentMaster
									INNER JOIN ".$tx_detail_tablename." AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
									LEFT JOIN  treatment_extend_masters AS TreatmentExtendMaster ON TreatmentExtendMaster.treatment_master_id = TreatmentMaster.id AND TreatmentExtendMaster.deleted <> 1
									WHERE TreatmentMaster.deleted <> 1
									AND TreatmentMaster.participant_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id']."
									AND TreatmentMaster.treatment_control_id = ".$atim_treatment_control_data['id']."
									AND TreatmentMaster.diagnosis_master_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['breast_diagnosis_id']."
									AND TreatmentMaster.start_date = '$excel_start_date'
									AND TreatmentMaster.start_date_accuracy = '$excel_start_date_accuracy'
									AND (".(strlen($excel_treatment_data['treatment_masters']['qbcf_clinical_trial_protocol_number'])? "TreatmentMaster.qbcf_clinical_trial_protocol_number = '".str_replace("'", "''", $excel_treatment_data['treatment_masters']['qbcf_clinical_trial_protocol_number'])."'" : 'TRUE').")
									GROUP BY TreatmentMaster.id;";
								$query_data = getSelectQueryResult($query);
								if($query_data) {
									if(sizeof($query_data) > 1) {
										// Two treatments matched the file treatment based on date and type
										recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "More than one ATiM breast treatment matches the excel treatment based on the start date and the type of the treatment - System will only compare excel data to the first ATiM record and update data of this one if required.", "See '".$excel_line_data['Treatment Type']."' treatment for following participant : $excel_data_references.");
									}
									$atim_treatment_data = $query_data[0];
									if($excel_start_date_accuracy != 'c') {
										recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "An ATiM breast treatment matches the excel treatment based on the start date and the type of the treatment,  but date is unlcear. System will compare excel data to ATiM data but please confrim.", "See '".$excel_line_data['Treatment Type']."' treatment for following participant : $excel_data_references.");
									}
								}
									
								if(!$atim_treatment_data) {
									
									// 5.b.1 - SYSTEMIC TREATMENT CREATION
									
									$treatment_master_id = customInsertRecord($excel_treatment_data);
									foreach($atim_drug_ids_to_link_to_treatment as $new_drug_id) {
										$drug_data = array(
											'treatment_extend_masters' => array(
												'treatment_master_id' => $treatment_master_id,
												'treatment_extend_control_id' => $atim_treatment_control_data['treatment_extend_control_id'],
												'drug_id' => $new_drug_id),
											$atim_treatment_control_data['treatment_extend_detail_tablename'] => array());
										customInsertRecord($drug_data);
									}
									addCreatedDataToSummary('New Breast Treatment', "Participant '$qbcf_bank_participant_identifier' of bank '$bank' : '".$excel_line_data['Treatment Type']."' treatment on '".($excel_start_date? $excel_start_date : 'Missing Date')."' including ".sizeof($atim_drug_ids_to_link_to_treatment)." drugs", $excel_data_references);
									
								} else {
									
									/// 5.b.2 - SYSTEMIC TREATMENT UPDATE
									
									$data_to_update = array(
										'treatment_masters' => getDataToUpdate($atim_treatment_data, $excel_treatment_data['treatment_masters']),
										$tx_detail_tablename => getDataToUpdate($atim_treatment_data, $excel_treatment_data[$tx_detail_tablename]));
									if(sizeof($data_to_update['treatment_masters']) || sizeof($data_to_update[$tx_detail_tablename])) {
										updateTableData($atim_treatment_data['treatment_master_id'], $data_to_update);
										addUpdatedDataToSummary('Breast Treatment Update ('.$excel_line_data['Treatment Type'].")", array_merge($data_to_update['treatment_masters'], $data_to_update[$tx_detail_tablename]), $excel_data_references);
									}
									$atim_treatment_drug_ids = array_filter(explode(',', $atim_treatment_data['drug_ids']));
									$drug_ids_only_in_excel = array_diff($atim_drug_ids_to_link_to_treatment, $atim_treatment_drug_ids);
									if($drug_ids_only_in_excel) {
										foreach($drug_ids_only_in_excel as $new_drug_id) {
											$drug_data = array(
												'treatment_extend_masters' => array(
													'treatment_master_id' => $atim_treatment_data['treatment_master_id'],
													'treatment_extend_control_id' => $atim_treatment_control_data['treatment_extend_control_id'],
													'drug_id' => $new_drug_id),
												$atim_treatment_control_data['treatment_extend_detail_tablename'] => array());
											customInsertRecord($drug_data);
										}		
										recordErrorAndMessage('Data Update Summary', '@@MESSAGE@@', 'Breast Treatment Update ('.$excel_line_data['Treatment Type'].")", "Added ".sizeof($drug_ids_only_in_excel)." drugs to an existing ATiM treatment. See $excel_data_references.");
									}
									$drug_ids_only_in_atim = array_diff($atim_treatment_drug_ids, $atim_drug_ids_to_link_to_treatment);
									if($drug_ids_only_in_atim) {
										recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "At least one breast treatment drug is already attached to the treatment into ATiM but this one is not defined into Excel (raison could be that 2 drugs are defined on 2 different lines into Excel) - Please confirm.", "Compare ATiM and excel drugs defintion of a '".$excel_line_data['Treatment Type']."' treatment for following participant : $excel_data_references.");
									}
								}
							}	
						}
					}
				}
			}
		} // End 'Dx-event-Breast' worksheet
		
		//----------------------------------------------------------------------------------------------
		// Breast Diagnosis Event : Calculated times
		//----------------------------------------------------------------------------------------------
		
		if($qbcf_bank_participant_identifier_to_participant_id) {
			
			$summary_section_title = 'Breast Diadgnosis Event Calculated Times - Creation/Update';
			
			$query = "SELECT Participant.id AS participant_id,
				Participant.qbcf_bank_participant_identifier,
				Participant.date_of_death,
				Participant.date_of_death_accuracy,
				Participant.qbcf_suspected_date_of_death,
				Participant.qbcf_suspected_date_of_death_accuracy,
				Participant.qbcf_last_contact,
				Participant.qbcf_last_contact_accuracy,
				TreatmentMaster.id AS treatment_master_id,
				TreatmentMaster.diagnosis_master_id AS diagnosis_master_id,
				TreatmentMaster.start_date,
				TreatmentMaster.start_date_accuracy,
				TreatmentDetail.time_to_last_contact_months,
				TreatmentDetail.time_to_first_progression_months,
				TreatmentDetail.time_to_next_breast_dx_event_months
				FROM participants Participant
				INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.participant_id = Participant.id
				INNER JOIN ".$atim_controls['treatment_controls']['breast diagnostic event']['detail_tablename']." AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				WHERE Participant.deleted <> 1
				AND Participant.qbcf_bank_id = $qbcf_bank_id
				AND qbcf_bank_participant_identifier IN ('".implode("','", array_keys($qbcf_bank_participant_identifier_to_participant_id))."')
				AND TreatmentMaster.deleted <> 1
				AND TreatmentMaster.treatment_control_id = ".$atim_controls['treatment_controls']['breast diagnostic event']['id'].";";
			foreach(getSelectQueryResult($query) AS $new_breast_diagnosis_event_tx) {
				
				$qbcf_bank_participant_identifier = $new_breast_diagnosis_event_tx['qbcf_bank_participant_identifier'];
				
				// Get participant last contact or death

				$last_contact_or_death_date = '';
				$last_contact_or_death_date_accuracy = '';
				if(!empty($new_breast_diagnosis_event_tx['date_of_death'])) {
					$last_contact_or_death_date = $new_breast_diagnosis_event_tx['date_of_death'];
					$last_contact_or_death_date_accuracy = $new_breast_diagnosis_event_tx['date_of_death_accuracy'];
				} else if(!empty($new_breast_diagnosis_event_tx['qbcf_suspected_date_of_death'])) {
					$last_contact_or_death_date = $new_breast_diagnosis_event_tx['qbcf_suspected_date_of_death'];
					$last_contact_or_death_date_accuracy = $new_breast_diagnosis_event_tx['qbcf_suspected_date_of_death_accuracy'];
				}else if(!empty($new_breast_diagnosis_event_tx['qbcf_last_contact'])) {
					$last_contact_or_death_date = $new_breast_diagnosis_event_tx['qbcf_last_contact'];
					$last_contact_or_death_date_accuracy = $new_breast_diagnosis_event_tx['qbcf_last_contact_accuracy'];
				}
				if(empty($last_contact_or_death_date)) recordErrorAndMessage($summary_section_title, '@@WARNING@@', "The last contact or death date is unknown - The 'time to last contact' values cannot be calculated", "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");
				
				//Calculate times to

				$new_time_to_last_contact_months = '';
				$new_time_to_first_progression_months = '';
				$new_time_to_next_breast_dx_event_months = '';
				if($new_breast_diagnosis_event_tx['start_date']) {
					$start_date = $new_breast_diagnosis_event_tx['start_date'];
					$start_date_accuracy = $new_breast_diagnosis_event_tx['start_date_accuracy'];
					$start_date_ob = new DateTime($start_date);
					// Time To Last Contcat
					if(!empty($last_contact_or_death_date)) {
						if(in_array($start_date_accuracy.$last_contact_or_death_date_accuracy, array('cc', 'cd', 'dc'))) {
							if($start_date_accuracy.$last_contact_or_death_date_accuracy != 'cc') $all_warnings["'time to last contact' has been calculated with at least one unaccuracy date"][$start_date] = $start_date;
							$end_date_ob = new DateTime($last_contact_or_death_date);
							$interval = $start_date_ob->diff($end_date_ob);
							if($interval->invert) {
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "All 'times to last contact' cannot be calculated because dates are not chronological", "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");
							} else {
								$new_time_to_last_contact_months = $interval->y*12 + $interval->m;
							}
						} else {
							recordErrorAndMessage($summary_section_title, '@@WARNING@@', "The 'time to last contact' cannot be calculated on inaccurate dates", "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");
						}
					}
					// Time to first progression
					$query_2 = "SELECT DiagnosisMaster.id AS diagnosis_master_id,
						DiagnosisMaster.dx_date,
						DiagnosisMaster.dx_date_accuracy
						FROM diagnosis_masters AS DiagnosisMaster
						WHERE DiagnosisMaster.participant_id = ".$new_breast_diagnosis_event_tx['participant_id']."
						AND DiagnosisMaster.deleted <> 1
						AND DiagnosisMaster.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['secondary - distant-breast progression']['id']."
						AND DiagnosisMaster.parent_id = ".$new_breast_diagnosis_event_tx['diagnosis_master_id']."
						AND DiagnosisMaster.dx_date IS NOT NULL
						AND DiagnosisMaster.dx_date >= '".$new_breast_diagnosis_event_tx['start_date']."'
						ORDER BY DiagnosisMaster.dx_date ASC
						LIMIT 0,1;";
					$first_progression = getSelectQueryResult($query_2);
					if($first_progression) {
						$first_progression_date = $first_progression[0]['dx_date'];
						$first_progression_date_accuracy = $first_progression[0]['dx_date_accuracy'];
						if(in_array($start_date_accuracy.$first_progression_date_accuracy, array('cc', 'cd', 'dc'))) {
							if($start_date_accuracy.$first_progression_date_accuracy != 'cc') recordErrorAndMessage($summary_section_title, '@@WARNING@@', "A 'time to first progression' has been calculated with at least one unaccuracy date", "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");
							$end_date_ob = new DateTime($first_progression_date);
							$interval = $start_date_ob->diff($end_date_ob);
							if($interval->invert) {
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "A 'time to first progression' cannot be calculated because dates are not chronological", "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");
							} else {
								$new_time_to_first_progression_months = $interval->y*12 + $interval->m;
							}
						} else {
							recordErrorAndMessage($summary_section_title, '@@WARNING@@', "A 'time to first progression' cannot be calculated on inaccurate dates", "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");		
						}
					}
					// Time to next breast diagnosis
					$query_3 = "SELECT TreatmentMaster.id AS treatment_master_id,
						TreatmentMaster.start_date,
						TreatmentMaster.start_date_accuracy
						FROM treatment_masters AS TreatmentMaster
						WHERE TreatmentMaster.id != ".$new_breast_diagnosis_event_tx['treatment_master_id']."
						AND TreatmentMaster.participant_id = ".$new_breast_diagnosis_event_tx['participant_id']."
						AND TreatmentMaster.deleted <> 1
						AND TreatmentMaster.treatment_control_id = ".$atim_controls['treatment_controls']['breast diagnostic event']['id']."
						AND TreatmentMaster.diagnosis_master_id = ".$new_breast_diagnosis_event_tx['diagnosis_master_id']."
						AND TreatmentMaster.start_date IS NOT NULL
						AND TreatmentMaster.start_date > '".$new_breast_diagnosis_event_tx['start_date']."'
						ORDER BY TreatmentMaster.start_date ASC
						LIMIT 0,1;";
					$next_breast_dx_event = getSelectQueryResult($query_3);
					if($next_breast_dx_event) {
						$next_breast_dx_event_date = $next_breast_dx_event[0]['start_date'];
						$next_breast_dx_event_date_accuracy = $next_breast_dx_event[0]['start_date_accuracy'];
						if(in_array($start_date_accuracy.$next_breast_dx_event_date_accuracy, array('cc', 'cd', 'dc'))) {
							if($start_date_accuracy.$next_breast_dx_event_date_accuracy != 'cc') recordErrorAndMessage($summary_section_title, '@@WARNING@@', "A 'time to next breast diagnosis event' has been calculated with at least one unaccuracy date", "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");
							$end_date_ob = new DateTime($next_breast_dx_event_date);
							$interval = $start_date_ob->diff($end_date_ob);
							if($interval->invert) {
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "A 'time to next breast diagnosis event' cannot be calculated because dates are not chronological", "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");
							} else {
								$new_time_to_next_breast_dx_event_months = $interval->y*12 + $interval->m;
							}
						} else {
							recordErrorAndMessage($summary_section_title, '@@WARNING@@', "A 'time to next breast diagnosis event' cannot be calculated on inaccurate dates", "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");
						}
					}
				} else {
					recordErrorAndMessage($summary_section_title, '@@WARNING@@', "At least one breast diagnosis date is unknown - the 'time to' values cannot be calculated for 'un-dated' diagnosis", "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");
				}
				//Update data
				$breast_diagnosis_event_detail_to_update = array();
				if($new_time_to_last_contact_months !== $new_breast_diagnosis_event_tx['time_to_last_contact_months']) $breast_diagnosis_event_detail_to_update['time_to_last_contact_months'] = $new_time_to_last_contact_months;
				if($new_time_to_first_progression_months !== $new_breast_diagnosis_event_tx['time_to_first_progression_months']) $breast_diagnosis_event_detail_to_update['time_to_first_progression_months'] = $new_time_to_first_progression_months;
				if($new_time_to_next_breast_dx_event_months !== $new_breast_diagnosis_event_tx['time_to_next_breast_dx_event_months']) $breast_diagnosis_event_detail_to_update['time_to_next_breast_dx_event_months'] = $new_time_to_next_breast_dx_event_months;
				if($breast_diagnosis_event_detail_to_update) {
					updateTableData($new_breast_diagnosis_event_tx['treatment_master_id'], array('treatment_masters' => array(), $atim_controls['treatment_controls']['breast diagnostic event']['detail_tablename'] => $breast_diagnosis_event_detail_to_update));
					addUpdatedDataToSummary($summary_section_title, $breast_diagnosis_event_detail_to_update, "See Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>'", "$bank-$qbcf_bank_participant_identifier");
				}
			}
		} // End of breast diagnosis event times calculation		
		
		//----------------------------------------------------------------------------------------------
		// Breast Diagnosis : Date and laterality
		//----------------------------------------------------------------------------------------------
		
		if($qbcf_bank_participant_identifier_to_participant_id) {
				
			$summary_section_title = 'Breast Diadgnosis Date and Laterality - Creation/Update';
			$dx_detail_tablename = $atim_controls['diagnosis_controls']['primary-breast']['detail_tablename'];
			$tx_detail_tablename = $atim_controls['treatment_controls']['breast diagnostic event']['detail_tablename'];
			$query = "SELECT Participant.id AS participant_id,
				Participant.qbcf_bank_participant_identifier,
				DiagnosisMaster.id AS diagnosis_master_id,
				DiagnosisMaster.dx_date,
				DiagnosisMaster.dx_date_accuracy,
				DiagnosisDetail.laterality_left,
				DiagnosisDetail.laterality_right,
				DiagnosisDetail.laterality_bilateral,
				TreatmentMaster.id AS treatment_master_id,
				TreatmentMaster.diagnosis_master_id AS diagnosis_master_id,
				TreatmentMaster.start_date,
				TreatmentMaster.start_date_accuracy,
				TreatmentDetail.laterality
				FROM participants Participant
				INNER JOIN diagnosis_masters AS DiagnosisMaster ON DiagnosisMaster.participant_id = Participant.id
				INNER JOIN ".$dx_detail_tablename." AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
				LEFT JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id
					AND TreatmentMaster.deleted <> 1 AND TreatmentMaster.treatment_control_id = ".$atim_controls['treatment_controls']['breast diagnostic event']['id']."
				LEFT JOIN ".$tx_detail_tablename." AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
				WHERE Participant.deleted <> 1
				AND Participant.qbcf_bank_id = $qbcf_bank_id
				AND qbcf_bank_participant_identifier IN ('".implode("','", array_keys($qbcf_bank_participant_identifier_to_participant_id))."')
				AND DiagnosisMaster.deleted <> 1
				AND DiagnosisMaster.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['primary-breast']['id']."
				ORDER BY DiagnosisMaster.id ASC, TreatmentMaster.start_date ASC;";
			$all_dx_data = array();
			foreach(getSelectQueryResult($query) AS $new_breast_diagnosis) {
				$diagnosis_master_id = $new_breast_diagnosis['diagnosis_master_id'];
				if(!isset($all_dx_data[$diagnosis_master_id])) {
					$all_dx_data[$diagnosis_master_id] = array(
						'qbcf_bank_participant_identifier' => $new_breast_diagnosis['qbcf_bank_participant_identifier'],
						'diagnosis_master_id' => $new_breast_diagnosis['diagnosis_master_id'],
						'old' => array(
							'diagnosis_masters' => array(
								'dx_date' => $new_breast_diagnosis['dx_date'],
								'dx_date_accuracy' => $new_breast_diagnosis['dx_date_accuracy']),
							$dx_detail_tablename => array(
								'laterality_left' => $new_breast_diagnosis['laterality_left'],
								'laterality_right' => $new_breast_diagnosis['laterality_right'],
								'laterality_bilateral' => $new_breast_diagnosis['laterality_bilateral'])),
						'new' => array(
							'diagnosis_masters' => array(
								'dx_date' => '',
								'dx_date_accuracy' => ''),
							$dx_detail_tablename => array(
								'laterality_left' => 'n',
								'laterality_right' => 'n',
								'laterality_bilateral' => 'n')));
				}
				//Diagnosis Date
				if(!$all_dx_data[$diagnosis_master_id]['new']['diagnosis_masters']['dx_date'] && $new_breast_diagnosis['start_date']) {
					$all_dx_data[$diagnosis_master_id]['new']['diagnosis_masters']['dx_date'] = $new_breast_diagnosis['start_date'];
					$all_dx_data[$diagnosis_master_id]['new']['diagnosis_masters']['dx_date_accuracy'] = $new_breast_diagnosis['start_date_accuracy'];
				}
				foreach(array('left','right','bilateral') as $tmp_laterality) {
					if($new_breast_diagnosis['laterality'] == $tmp_laterality) $all_dx_data[$diagnosis_master_id]['new'][$dx_detail_tablename]['laterality_'.$tmp_laterality] = 'y';
				}
			}
			foreach($all_dx_data as $new_breast_dx) {
				$breast_dx_data_to_update = array(
					'diagnosis_masters' => getDataToUpdate($new_breast_dx['old']['diagnosis_masters'], $new_breast_dx['new']['diagnosis_masters']),
					$dx_detail_tablename => getDataToUpdate($new_breast_dx['old'][$dx_detail_tablename], $new_breast_dx['new'][$dx_detail_tablename]));
				if(sizeof($breast_dx_data_to_update['diagnosis_masters']) || sizeof($breast_dx_data_to_update[$dx_detail_tablename])) {
					updateTableData($new_breast_dx['diagnosis_master_id'], $breast_dx_data_to_update);
					addUpdatedDataToSummary('Breast Diagnosis Update', array_merge($breast_dx_data_to_update['diagnosis_masters'], $breast_dx_data_to_update[$dx_detail_tablename]), "See Bank '<b>$bank</b>' & Participant '<b>".$new_breast_dx['qbcf_bank_participant_identifier']."</b>'");
				}
			}
		} // End of breast diagnosis date and laterality update
		
		//----------------------------------------------------------------------------------------------
		// Diagnosis & Treatment : 'other cancer- not Breast' worksheet
		//----------------------------------------------------------------------------------------------
		
		$worksheet_name = 'other cancer- not Breast';
		$summary_section_title = 'Other cancer - Creation/Update';
		while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1, $excel_xls_offset)) {
			if($line_number > 4 && strlen($excel_line_data['Patient # in biobank'])) {
				$qbcf_bank_participant_identifier = $excel_line_data['Patient # in biobank'];
				$excel_data_references = "Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>' & Excel '<b>$excel_file_name_for_ref</b>' & Line '<b>$line_number</b>' & Worksheet '<b>$worksheet_name</b>'";
		
				if(!isset($qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier])) {
		
					// 1- PARTICIPANT DETECTION ERROR
		
					recordErrorAndMessage('Participant Detection', '@@ERROR@@', "Patient of 'other cancer- not Breast' worksheet not defined into the 'patient' worksheet - No excel other diagnosis data will be migrated", "See following participant : $excel_data_references.");
				
				} else {
					
					//Check cancer type
					
					$excel_field = 'Cancer Type';
					$domain_name = 'ctrnet_submission_disease_site';
					$excel_line_data[$excel_field] = preg_replace('/^([^-.]*)\-(.*)$/', '$1 - $2', $excel_line_data[$excel_field]);
					$excel_other_diagnosis_site = validateAndGetStructureDomainValue($excel_line_data[$excel_field], $domain_name, $summary_section_title, $excel_field, "See $excel_data_references");
					
					if(!strlen($excel_other_diagnosis_site)) {
					
						// 2- TUMOR TYPE DEFINITION ERROR
						
						recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Type/Site of the other diagnosis not supported - No excel diagnosis and treatment data will be migrated", "See data for following participant : $excel_data_references.");
					
					} else {
						$other_diagnosis_master_id = null;
						
						// 3- OTHER DIAGNOSIS
						//..............................................................................................
						
						$dx_detail_tablename = $atim_controls['diagnosis_controls']['primary-other cancer']['detail_tablename'];
						$diagnosis_control_id = $atim_controls['diagnosis_controls']['primary-other cancer']['id'];
						$excel_other_diagnosis_data = array('diagnosis_masters' => array(), $dx_detail_tablename => array());
						
						$excel_field = 'Date of diagnosis';
						$excel_field_accuracy = "Dx date Accuracy";
						reformatExcelDate($excel_line_data, $excel_field, $excel_field_accuracy);
						list($excel_other_diagnosis_data['diagnosis_masters']['dx_date'], $excel_other_diagnosis_data['diagnosis_masters']['dx_date_accuracy']) 
							= updateDateWithExcelAccuracy(
								validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, $excel_field, "See $excel_data_references"),
								$excel_line_data[$excel_field_accuracy]);	
						
						$excel_other_diagnosis_data[$dx_detail_tablename]['disease_site'] = $excel_other_diagnosis_site;
						
						$excel_field = 'Development of Metastasis';
						$excel_other_diagnosis_data[$dx_detail_tablename]['metastasis_development'] = validateAndGetExcelValueFromList($excel_line_data[$excel_field], array('yes' => 'y', 'no' => 'n', 'unknown' => ''), true, $summary_section_title, $excel_field, "See $excel_data_references");
						
						$excel_other_diagnosis_data['diagnosis_masters'] = array_filter($excel_other_diagnosis_data['diagnosis_masters'], function($var){return (!($var == '' || is_null($var)));});
						$excel_other_diagnosis_data[$dx_detail_tablename] = array_filter($excel_other_diagnosis_data[$dx_detail_tablename], function($var){return (!($var == '' || is_null($var)));});
						if(empty($excel_other_diagnosis_data['diagnosis_masters']) && empty ($excel_other_diagnosis_data[$dx_detail_tablename])) $excel_other_diagnosis_data = array();
						
						if(!empty($excel_other_diagnosis_data)) {
							if(!array_key_exists('disease_site', $excel_other_diagnosis_data[$dx_detail_tablename])) {
								recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Other diagnosis site not defined (or erased by migration script after value check) - No excel diagnosis data will be migrated", "See following participant : $excel_data_references.");
						
							} else {					
								//Add missing information
						
								$excel_other_diagnosis_data['diagnosis_masters'] = array_merge(
									array('participant_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id'] ,
										'diagnosis_control_id' => $diagnosis_control_id),
									$excel_other_diagnosis_data['diagnosis_masters']);
						
								//Check diagnosis should be updated or created
						
								$atim_other_diagnosis_data = array();
								$query = "SELECT *
									FROM diagnosis_masters AS DiagnosisMaster
									INNER JOIN $dx_detail_tablename AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
									WHERE DiagnosisMaster.deleted <> 1
									AND DiagnosisMaster.participant_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id']."
									AND DiagnosisMaster.diagnosis_control_id = $diagnosis_control_id
									AND (".(isset($excel_other_diagnosis_data['diagnosis_masters']['dx_date'])?
										"DiagnosisMaster.dx_date = '".$excel_other_diagnosis_data['diagnosis_masters']['dx_date']."' AND DiagnosisMaster.dx_date_accuracy = '".$excel_other_diagnosis_data['diagnosis_masters']['dx_date_accuracy']."'"
										: 'TRUE').")
									AND DiagnosisDetail.disease_site = '".str_replace("'", "''", $excel_other_diagnosis_data[$dx_detail_tablename]['disease_site'])."';";
								$query_data = getSelectQueryResult($query);
								if($query_data) {
									if(sizeof($query_data) > 1) {
										// Two diagnoses matched the file diagnosis based on date and type of intervention
										recordErrorAndMessage($summary_section_title, '@@ERROR@@', "More than one ATiM other diagnosis matches the excel participant diagnosis based on date and the site - System will only compare excel data to the first ATiM record and update data of this one if required.", "See other diagnosis for following participant : $excel_data_references.");
									}
									$atim_other_diagnosis_data = $query_data[0];
									if(!isset($excel_other_diagnosis_data['diagnosis_masters']['dx_date_accuracy']) || $excel_other_diagnosis_data['diagnosis_masters']['dx_date_accuracy'] != 'c') {
										recordErrorAndMessage($summary_section_title, '@@WARNING@@', "An ATiM other diagnosis matches the excel participant diagnosis based on date and the site - But date is unknown or unlcear. Please confrim.", "See other diagnosis for following participant : $excel_data_references.");
									}
								}
						
								if(!$atim_other_diagnosis_data) {
										
									// 3.a - OTHER DIAGNOSIS CREATION
								
									$other_diagnosis_master_id = customInsertRecord($excel_other_diagnosis_data);
									addCreatedDataToSummary('New Other Diagnosis', "Participant '$qbcf_bank_participant_identifier' of bank '$bank' : Site '".$excel_other_diagnosis_data[$dx_detail_tablename]['disease_site']."' on '".(isset($excel_other_diagnosis_data['diagnosis_masters']['dx_date'])? $excel_other_diagnosis_data['diagnosis_masters']['dx_date'] : '?')."'", $excel_data_references);
								
								} else {
										
									// 3.b - OTHER DIAGNOSIS UPDATE
										
									$other_diagnosis_master_id = $atim_other_diagnosis_data['id'];
									
									$data_to_update = array(
										'diagnosis_masters' => getDataToUpdate($atim_other_diagnosis_data, $excel_other_diagnosis_data['diagnosis_masters']),
										$dx_detail_tablename => getDataToUpdate($atim_other_diagnosis_data, $excel_other_diagnosis_data[$dx_detail_tablename]));
									if(sizeof($data_to_update['diagnosis_masters']) || sizeof($data_to_update[$dx_detail_tablename])) {
										updateTableData($atim_other_diagnosis_data['id'], $data_to_update);
										addUpdatedDataToSummary('Other Diagnosis Update', array_merge($data_to_update['diagnosis_masters'], $data_to_update[$dx_detail_tablename]), $excel_data_references);
									}
								
								}
							}		
						}
						
						// 4- OTHER DIAGNOSIS PROGRESSION
						//..............................................................................................
						
						$dx_detail_tablename = $atim_controls['diagnosis_controls']['secondary - distant-other cancer progression']['detail_tablename'];
						$diagnosis_control_id = $atim_controls['diagnosis_controls']['secondary - distant-other cancer progression']['id'];
								
						$value_matches = array('ln' => 'ln',
							'soft tissue (lung, liver, brain)' => 'soft tissue',
							'soft tissue' => 'soft tissue',
							'bone' => 'bone',
							'multiple sites' => 'multiple sites',
							'na' => '');
						$excel_field = 'Metastastasis site(s)';
						$excel_other_diagnosis_progression_site = validateAndGetExcelValueFromList($excel_line_data[$excel_field], $value_matches, true, $summary_section_title, $excel_field, "See $excel_data_references");
						
						if($excel_other_diagnosis_progression_site) {
							if(!$other_diagnosis_master_id) {
								
								//The other diagnosis primary is not defined
								recordErrorAndMessage($summary_section_title, '@@ERROR@@', "'Other diagnosis progression' defined but no 'other primary diagnosis' does not exist - No progression will be created.", "See other diagnosis progression for following participant : $excel_data_references.");
							
							} else {
						
								//Check diagnosis should be created
								
								$create_new_other_diagnosis_progression = true;
								$query = "SELECT *
									FROM diagnosis_masters AS DiagnosisMaster
									INNER JOIN $dx_detail_tablename AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
									WHERE DiagnosisMaster.deleted <> 1
									AND DiagnosisMaster.participant_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id']."
									AND DiagnosisMaster.diagnosis_control_id = $diagnosis_control_id
									AND DiagnosisMaster.parent_id = $other_diagnosis_master_id
									AND DiagnosisDetail.secondary_disease_site = '$excel_other_diagnosis_progression_site';";
								$query_data = getSelectQueryResult($query);
								if($query_data) {
									$create_new_other_diagnosis_progression = false;
								}
								
								if($create_new_other_diagnosis_progression) {
								
									// 4.a - OTHER DIAGNOSIS CREATION
									
									$excel_other_diagnosis_data = array(
										'diagnosis_masters' => array(
											'participant_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id'] ,
											'diagnosis_control_id' => $diagnosis_control_id,
											'primary_id' => $other_diagnosis_master_id,
											'parent_id' => $other_diagnosis_master_id),
										 $dx_detail_tablename => array(
										 	'secondary_disease_site' => $excel_other_diagnosis_progression_site));
									$diagnosis_master_id = customInsertRecord($excel_other_diagnosis_data);
									addCreatedDataToSummary('New Other Diagnosis Progression', "Participant '$qbcf_bank_participant_identifier' of bank '$bank' : Site '$excel_other_diagnosis_progression_site' of '$excel_other_diagnosis_site' other primary diagnosis", $excel_data_references);
								
								}
							}
						}
						
						// 5- OTHER DIAGNOSIS TREATMENT
						//..............................................................................................
						
						$tx_detail_tablename= $atim_controls['treatment_controls']['other cancer']['detail_tablename'];
						$treatment_control_id = $atim_controls['treatment_controls']['other cancer']['id'];
						
						$excel_field = 'Cancer treated by';
						$domain_name = 'qbcf_txd_other_cancer_treatments';
						$excel_other_diagnosis_treatment_type = validateAndGetStructureDomainValue($excel_line_data[$excel_field], $domain_name, $summary_section_title, $excel_field, "See $excel_data_references");
						
						$excel_field = 'Treatment Date Start';
						$excel_field_accuracy = "Start Date Accuracy";
						reformatExcelDate($excel_line_data, $excel_field, $excel_field_accuracy);
						list($excel_start_date, $excel_start_date_accuracy) = updateDateWithExcelAccuracy(
							validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, $excel_field, "See $excel_data_references"),
							$excel_line_data[$excel_field_accuracy]);
							
						$excel_field = 'Treatment End Date';
						$excel_field_accuracy = "End Date Accuracy";
						reformatExcelDate($excel_line_data, $excel_field, $excel_field_accuracy);
						list($excel_finish_date, $excel_finish_date_accuracy) = updateDateWithExcelAccuracy(
							validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, $excel_field, "See $excel_data_references"),
							$excel_line_data[$excel_field_accuracy]);
						
						if(!strlen($excel_other_diagnosis_treatment_type) && $excel_start_date) {
							recordErrorAndMessage($summary_section_title, '@@ERROR@@', "No other diagnosis treatment type set but a treatment date is set - No treatment will be created.", "See other diagnosis treatment for following participant : $excel_data_references.");
							
						} else if(strlen($excel_other_diagnosis_treatment_type)) {
							
							if(!$other_diagnosis_master_id) {
							
								//The other diagnosis primary is not defined
								recordErrorAndMessage($summary_section_title, '@@ERROR@@', "'Other diagnosis treatment' defined but no 'other primary diagnosis' does not exist - No treatment will be created.", "See other diagnosis treatment for following participant : $excel_data_references.");
									
							} else {
								
								$excel_treatment_data = array(
									'treatment_masters' => array(
										'participant_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id'] ,
										'treatment_control_id' => $treatment_control_id,
										'diagnosis_master_id' => $other_diagnosis_master_id,
										'start_date' => $excel_start_date,
										'start_date_accuracy' => $excel_start_date_accuracy,
										'finish_date' => $excel_finish_date,
										'finish_date_accuracy' => $excel_finish_date_accuracy),
									$tx_detail_tablename => array(
										'type' => $excel_other_diagnosis_treatment_type));
								
								//Check treatment should be updated or created
								
								$atim_treatment_data = array();
								$query = "SELECT TreatmentMaster.*, TreatmentDetail.*
									FROM treatment_masters AS TreatmentMaster
									INNER JOIN ".$tx_detail_tablename." AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
									WHERE TreatmentMaster.deleted <> 1
									AND TreatmentMaster.participant_id = ".$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]['participant_id']."
									AND TreatmentMaster.treatment_control_id = $treatment_control_id
									AND TreatmentMaster.diagnosis_master_id = $other_diagnosis_master_id
									AND TreatmentMaster.start_date = '$excel_start_date'
									AND TreatmentMaster.start_date_accuracy = '$excel_start_date_accuracy'
									AND TreatmentDetail.type = '$excel_other_diagnosis_treatment_type';";
								$query_data = getSelectQueryResult($query);
								if($query_data) {
									if(sizeof($query_data) > 1) {
										// Two treatments matched the file treatment based on date and type
										recordErrorAndMessage($specific_summary_section_title, '@@ERROR@@', "More than one ATiM other diagnosis treatment matches the excel treatment based on the start date, the type of the other cancer and the type of the treatment - System will only compare excel data to the first ATiM record and update data of this one if required.", "See '$excel_other_diagnosis_treatment_type' treatment for following participant : $excel_data_references.");
									}
									$atim_treatment_data = $query_data[0];
									if($excel_start_date_accuracy != 'c') {
										recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "An ATiM other diagnosis treatment matches the excel treatment based on the start date, the type of the other cancer and the type of the treatment,  but date is unlcear. System will compare excel data to ATiM data but please confrim.", "See '$excel_other_diagnosis_treatment_type' treatment for following participant : $excel_data_references.");
									}
								}
								
								if(!$atim_treatment_data) {
								
									// 5.a - OTHER DIAGNOSIS TREATMENT CREATION
										
									$treatment_master_id = customInsertRecord($excel_treatment_data);
									addCreatedDataToSummary('New Breast Treatment', "Participant '$qbcf_bank_participant_identifier' of bank '$bank' : '$excel_other_diagnosis_treatment_type' treatment on '".($excel_start_date? $excel_start_date : 'Missing Date')."'", $excel_data_references);
								
								} else {
								
									/// 5.b - OTHER DIAGNOSIS TREATMENT UPDATE
								
									$data_to_update = array(
										'treatment_masters' => getDataToUpdate($atim_treatment_data, $excel_treatment_data['treatment_masters']),
										$tx_detail_tablename => getDataToUpdate($atim_treatment_data, $excel_treatment_data[$tx_detail_tablename]));
									if(sizeof($data_to_update['treatment_masters']) || sizeof($data_to_update[$tx_detail_tablename])) {
										updateTableData($atim_treatment_data['treatment_master_id'], $data_to_update);
										addUpdatedDataToSummary("Other Diagnosis Treatment Update ($excel_other_diagnosis_treatment_type)", array_merge($data_to_update['treatment_masters'], $data_to_update[$tx_detail_tablename]), $excel_data_references);
									}
								}
							}
						}
					}
				}
			}
		} // End 'other cancer- not Breast' worksheet
		
		//----------------------------------------------------------------------------------------------
		// Inventory : 
		//      - 'Inventory - FFPE block sent' worksheet not use anymore. 
		//      - Just set the collection.treatment_master_id value.
		//----------------------------------------------------------------------------------------------
		
		$specific_summary_section_title = "Breast Dx & Event - Creation/Update : Breast Diagnostic Event";
		foreach($qbcf_bank_participant_identifier_to_participant_id as $qbcf_bank_participant_identifier => $excel_participant_data) {
			$participant_id = $excel_participant_data['participant_id'];
			$excel_collection_treatment_id = $excel_participant_data['collection_treatment_id'];
			$excel_data_references = "Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>' & Excel '<b>$excel_file_name_for_ref</b>'";
			if($excel_collection_treatment_id) {
				// Dx event to link to collection : Create new collection or update an existing one
				$query = "SELECT DISTINCT Collection.id AS collection_id, Collection.qbcf_pathology_id, Collection.treatment_master_id
					FROM collections Collection
					WHERE Collection.deleted <> 1
					AND Collection.participant_id = '$participant_id'";
				$query_data = getSelectQueryResult($query);
				if($query_data) {
					// Collection exists : update collection
					$update_collection_treatment_master_id = true;
					$collection_ids_to_update = array();
					foreach($query_data as $atim_collection_data) {
						if($atim_collection_data['treatment_master_id']) {
							if($atim_collection_data['treatment_master_id'] != $excel_collection_treatment_id) {
								$update_collection_treatment_master_id = false;
							}
						} else {
							$collection_ids_to_update[$atim_collection_data['collection_id']] = $atim_collection_data['qbcf_pathology_id'];
						}
					}
					if(!$update_collection_treatment_master_id) {
						recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "A Breast Diagnostic Event is already linked to collection into ATiM and different than the value defined into the Excel file. Breast Diagnostic Event to collection link won't be updated. Please review all links for the listed participants after the migration process.", "See $excel_data_references.");
					} else if($collection_ids_to_update) {
						foreach($collection_ids_to_update as $collection_id => $qbcf_pathology_id) {
							//ATiM collection diagnosis event not already set : update value
							updateTableData($collection_id, array('collections' => array('treatment_master_id' => $excel_collection_treatment_id)));
						}
						addUpdatedDataToSummary('Update Breast diagnostic Event to collection link(s)', array('collection_treatment_master_id' => 'Excel Diagnosis Event (treatment_master_id = '.$excel_collection_treatment_id.')'), "See all collections of following participant : $excel_data_references");
					}				
				} else {
					recordErrorAndMessage($specific_summary_section_title, '@@WARNING@@', "No collection exists. Breast Diagnostic Event to collection link won't be recorded. Please review data previously imported.", "See $excel_data_references.");
				}
			}
		}
	}
} // End new excel file
	
$last_queries_to_execute = array(
	"UPDATE participants SET participant_identifier = id WHERE participant_identifier = '' OR participant_identifier IS NULL;",
	"UPDATE diagnosis_masters SET primary_id = id WHERE primary_id IS NULL AND parent_id IS NULL;",
	"UPDATE versions SET permissions_regenerated = 0;"
);
foreach($last_queries_to_execute as $query)	customQuery($query);

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

dislayErrorAndMessage(true, 'Creation/Update Summary');

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function reformatExcelDate(&$excel_line_data, $excel_field, $excel_field_accuracy) {
	if(!array_key_exists($excel_field, $excel_line_data) || !array_key_exists($excel_field_accuracy, $excel_line_data)) { die('ERR8839393930'); }
	if(preg_match('/^[0-9]{4}\-mm\-dd$/', $excel_line_data[$excel_field]) || preg_match('/^[0-9]{4}\-mm\-jj$/', $excel_line_data[$excel_field])) {
		$excel_line_data[$excel_field_accuracy] = 'y';
	} else if(preg_match('/^[0-9]{4}\-[0-9]{2}\-dd$/', $excel_line_data[$excel_field]) || preg_match('/^[0-9]{4}\-[0-9]{2}\-jj$/', $excel_line_data[$excel_field])) {
		$excel_line_data[$excel_field_accuracy] = 'm';
	}
	$excel_line_data[$excel_field] = str_replace(array('mm', 'dd', 'jj'), array('01', '01', '01'), $excel_line_data[$excel_field]);
}

function updateDateWithExcelAccuracy($validated_excel_date, $excel_accuracy_field_value){
	if($validated_excel_date[0]) {
		switch($excel_accuracy_field_value) {
			case 'c':
				if($validated_excel_date[1] != 'c') die('ERR 888888.1');
				$validated_excel_date[1] = 'c';
				break;
			case 'm':
				if(!in_array($validated_excel_date[1], array('c', 'd'))) die('ERR 888888.2');
				$validated_excel_date[1] = 'd';
				break;
			case 'y':
				if(!in_array($validated_excel_date[1], array('c', 'd', 'm'))) die('ERR 888888.3');
				$validated_excel_date[1] = 'm';
				break;
		}
	}
	return $validated_excel_date;
}

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

function getDrugId($drug_name, $type, $excel_data_references) {
	global $atim_drugs;
	
	if(!strlen($drug_name)) return null;

	if(empty($atim_drugs)) {
		//Get first drugs list from ATiM
		$query = "SELECT id, generic_name, type FROM drugs WHERE deleted <> 1;";
		foreach(getSelectQueryResult($query) as $new_record) {
			$drug_key = getDrugKey($new_record['generic_name'], $new_record['type'], $excel_data_references);
			$atim_drugs[$drug_key] = $new_record['id'];
		}
	}
	
	$drug_name = formatDrugName($drug_name, $type, $excel_data_references);
	
	$drug_key = getDrugKey($drug_name, $type, $excel_data_references);
	if(array_key_exists($drug_key, $atim_drugs)) return $atim_drugs[$drug_key];

	$drug_data = array('drugs' => array('generic_name' => $drug_name, 'type' =>$type));
	$atim_drugs[$drug_key] = customInsertRecord($drug_data);
	recordErrorAndMessage('Data Creation Summary', '@@MESSAGE@@', "New ATiM Drug Creation", "$drug_name ($type)");

	return $atim_drugs[$drug_key];
}

function formatDrugName($xls_drug_name, $xls_drug_type, $excel_data_references) {
	
	$drug_matches = array(
		"5-fluorouracil" => array("5-fluorouracil", "chemotherapy"),
		"5-fluouracil" => array("5-fluorouracil", "chemotherapy"),
		"fluorouracile" => array("5-fluorouracil", "chemotherapy"),
		"fluouracile" => array("5-fluorouracil", "chemotherapy"),
		"abemaciclib" => array("abemaciclib", "chemotherapy"),
		"abraxane" => array("abraxane", "chemotherapy"),
		"anastrozole" => array("anastrozole", "hormonal"),
		"anastrozole" => array("anastrozole", "hormonal"),
		"anatrozole" => array("anastrozole", "hormonal"),
		"arimidex" => array("anastrozole", "hormonal"),
		"arimidex + zoladex" => array("anastrozole+goserelin", "hormonal"),
		"aredia" => array("aredia", "bone specific"),
		"avastin" => array("Bevacizumab ", "chemotherapy"),
		"bevacizumab" => array("Bevacizumab ", "chemotherapy"),
		"capecitabine" => array("capecitabine", "chemotherapy"),
		"xeloda" => array("capecitabine", "chemotherapy"),
		"carboplatin" => array("carboplatin", "chemotherapy"),
		"carboplatine" => array("carboplatin", "chemotherapy"),
		"cyclophosphamide" => array("cyclophosphamide", "chemotherapy"),
		"cyclophosphamide" => array("cyclophosphamide", "chemotherapy"),
		"cyclphosphamide" => array("cyclophosphamide", "chemotherapy"),
		"cylophosphamide" => array("cyclophosphamide", "chemotherapy"),
		"denosumab" => array("denosumab", "bone specific"),
		"denosumab" => array("denosumab", "bone specific"),
		"denosumab ou placebo" => array("denosumab or placebo", "bone specific"),
		"docetaxel" => array("docetaxel", "chemotherapy"),
		"taxotere" => array("docetaxel", "chemotherapy"),
		"taxotere" => array("docetaxel", "chemotherapy"),
		"docetaxel + herceptin" => array("docetaxel + trastuzumab", "chemotherapy"),
		"adramicin" => array("doxorubicin", "chemotherapy"),
		"adriamcyin" => array("doxorubicin", "chemotherapy"),
		"adriamcyin" => array("doxorubicin", "chemotherapy"),
		"adriamycin" => array("doxorubicin", "chemotherapy"),
		"adriamycine" => array("doxorubicin", "chemotherapy"),
		"doxorubicin" => array("doxorubicin", "chemotherapy"),
		"epirubicin" => array("epirubicin", "chemotherapy"),
		"epirubicine" => array("epirubicin", "chemotherapy"),
		"eribulin" => array("eribulin", "chemotherapy"),
		"eribuline" => array("eribulin", "chemotherapy"),
		"aromasin" => array("exemestane", "hormonal"),
		"exemestane" => array("exemestane", "hormonal"),
		"fulvestrant" => array("fulvestrant", "hormonal"),
		"gemcitabine" => array("gemcitabine", "chemotherapy"),
		"gosereline" => array("goserelin", "hormonal"),
		"gosereline" => array("goserelin", "hormonal"),
		"lapatinib" => array("lapatinib", "chemotherapy"),
		"femara" => array("letrozole", "hormonal"),
		"letrozole" => array("letrozole", "hormonal"),
		"leuprolide" => array("leuprolide", "hormonal"),
		"metformin vs placebo" => array("metformin vs placebo", "other"),
		"methotrexate" => array("methotrexate", "chemotherapy"),
		"paclitaxel" => array("paclitaxel", "chemotherapy"),
		"taxol" => array("paclitaxel", "chemotherapy"),
		"pamidronate" => array("pamidronate", "bone specific"),
		"tamoxifen" => array("tamoxifen", "hormonal"),
		"tamoxifen 3 mo" => array("tamoxifen", "hormonal"),
		"herceptin" => array("trastuzumab", "immunotherapy"),
		"herceptin" => array("trastuzumab", "immunotherapy"),
		"trastuzumab" => array("trastuzumab", "immunotherapy"),
		"triptorelin" => array("triptorelin", "hormonal"),
		"vinorelbin" => array("vinorelbine", "chemotherapy"),
		"vinorelbine" => array("vinorelbine", "chemotherapy"),
		"acide zoledronique" => array("zoledronic acid", "bone specific"),
		"zoledronic acid" => array("zoledronic acid", "bone specific"),
		"zometa" => array("zoledronic acid", "bone specific"));
	$xls_drug_name = strtolower($xls_drug_name);
	
	$drug_name = $xls_drug_name;
	if(array_key_exists($xls_drug_name, $drug_matches)) {
		list($atim_drug_name, $atim_drug_type) = $drug_matches[$xls_drug_name];
		if($xls_drug_name != $atim_drug_name) {
			recordErrorAndMessage('Drug', '@@MESSAGE@@', "Re-named Drug Name", "Replaced '$xls_drug_name' by '$atim_drug_name'. See $excel_data_references.");
			$drug_name = $atim_drug_name;
		}
		if($atim_drug_type != $xls_drug_type) {
			recordErrorAndMessage('Drug', '@@WARNING@@', "Drug Type Mis-Matche", "The excel $xls_drug_type drug '$xls_drug_name' is defined as a '$atim_drug_type' drug".($xls_drug_name != $atim_drug_name? " with name '$atim_drug_name'" : '')." into ATiM. The drug will be recorded as a $xls_drug_type drug with name '$atim_drug_name'. Please validate and correct data if required. See $excel_data_references.");	
		}
	}
	
	return ucfirst($drug_name);
}

function getDrugKey($drug_name, $type, $excel_data_references) {
	if(!in_array($type, array('bone specific', 'chemotherapy', 'immunotherapy', 'hormonal', 'other'))) die('ERR 237 7263726 drug type'.$type." See $excel_data_references");
	return strtolower($drug_name.'## ##'.$type);
}
	
?>
		