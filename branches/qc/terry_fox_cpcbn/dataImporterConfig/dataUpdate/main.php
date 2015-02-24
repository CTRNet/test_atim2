<?php

//First Line of any main.php file
require_once 'system.php';

//==============================================================================================
// Custom Require Section
//==============================================================================================

//require_once 'CustomFiles/cutsom_file.php';

//==============================================================================================
// Custom Variables
//==============================================================================================

global $atim_drugs;
$atim_drugs = array();

//==============================================================================================
// Main Code
//==============================================================================================

if(!testExcelFile(array_keys($excel_files_names))) {
	dislayErrorAndMessage();
	exit;
}

foreach($excel_files_names as $excel_file_name => $excel_xls_offset) {
	//New excel file so new bank
	
	$bank_participant_identifier_to_id = array('' => '-1');
	$file_bank_name = null;
	
	// ******* Patient Data Update *******
	
	$worksheet_name = 'patient';
	$summary_section_title = "Worksheet '$worksheet_name'";
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2, $excel_xls_offset)) {
		if(isset($excel_line_data['Bank'])) {
			if($file_bank_name && $file_bank_name != $excel_line_data['Bank']) die("ERR_NO_UNIQUE_FILE_BANK - $excel_file_name - $file_bank_name != ".$excel_line_data['Bank']);
			$file_bank_name = $excel_line_data['Bank'];
			$summary_details_add_in = "Patient '".$excel_line_data['Patient # in biobank']."' / bank '$file_bank_name' / line '$line_number'";
			$atim_patient_data = getSelectQueryResult("SELECT p.* FROM participants p INNER JOIN banks b ON b.id = p.qc_tf_bank_id WHERE b.name = '".$excel_line_data['Bank']."' AND p.qc_tf_bank_participant_identifier = '".$excel_line_data['Patient # in biobank']."' AND p.deleted <>1;");
			if(!empty($atim_patient_data)) {
				$atim_patient_data = $atim_patient_data[0];
				$bank_participant_identifier_to_id[$excel_line_data['Patient # in biobank']] = $atim_patient_data['id'];
				//Get Excel Value
				$excel_patient_data = array();
				$excel_field = 'Death from prostate cancer';
				$excel_patient_data['qc_tf_death_from_prostate_cancer'] = validateAndGetExcelValueFromList($excel_line_data[$excel_field], array('unknown' => '', 'yes' => 'y', 'no' => 'n'), true, $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_field = 'Death status';
				$excel_patient_data['vital_status'] = validateAndGetStructureDomainValue(str_replace(array('dead'), array('deceased'), strtolower($excel_line_data[$excel_field])), 'health_status', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_field = "Registered Date of Death Date";
				list($excel_patient_data['date_of_death'], $excel_patient_data['date_of_death_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_patient_data['date_of_death_accuracy'] = updateWithExcelAccuracy($excel_patient_data['date_of_death_accuracy'], $excel_line_data["Registered Date of Death Accuracy"]);
				$excel_field = "Suspected Date of Death Date";
				list($excel_patient_data['qc_tf_suspected_date_of_death'], $excel_patient_data['qc_tf_suspected_date_of_death_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_patient_data['qc_tf_suspected_date_of_death_accuracy'] = updateWithExcelAccuracy($excel_patient_data['qc_tf_suspected_date_of_death_accuracy'], $excel_line_data["Suspected Date of Death Accuracy"]);
				$excel_field = "Date of last contact Date";
				list($excel_patient_data['qc_tf_last_contact'], $excel_patient_data['qc_tf_last_contact_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_patient_data['qc_tf_last_contact_accuracy'] = updateWithExcelAccuracy($excel_patient_data['qc_tf_last_contact_accuracy'], $excel_line_data["Date of last contact Accuracy"]);
				$excel_field = 'Family History (prostatite/cancer)';
				$excel_patient_data['qc_tf_family_history'] = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qc_tf_fam_hist_prostate_cancer', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				//Get ATiM Patient Data to Update
				$data_to_update = getDataToUpdate($atim_patient_data, $excel_patient_data);		
				updateTableData($atim_patient_data['id'], array('participants' => $data_to_update));
				addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Upddated Participant Field(s)', $data_to_update);
			} else {
				recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Bank Patient Unknown", "No ATim Patient matches excel patient. Patient data won't be parsed. $summary_details_add_in");
			}
		} else {
			recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Bank Column Missing", "'Bank' column is missing into worksheet '$worksheet_name'. No data will be parsed.");
		}
	}
		
	// ******* Diagnosis Data Update *******
	
	$worksheet_name = 'diagnosis';
	$summary_section_title = "Worksheet '$worksheet_name'";
	$existing_prostate_dxs = array();
	$existing_bcrs = array();
	$query = "SELECT pr_dx.participant_id, 
		pr_dx.id AS prostate_diagnosis_master_id, 
		pr_dxd.hormonorefractory_status, 
		bcr_dx.id AS bcr_diagnosis_master_id, 
		bcr_dx.dx_date AS bcr_dx_date, 
		bcr_dx.dx_date_accuracy AS bcr_dx_date_accuracy,
		bcr_dxd.type AS bcr_type
		FROM diagnosis_masters pr_dx
		INNER JOIN ".$atim_controls['diagnosis_controls']['primary-prostate']['detail_tablename']." AS pr_dxd ON pr_dxd.diagnosis_master_id = pr_dx.id
		LEFT JOIN diagnosis_masters bcr_dx ON pr_dx.id = bcr_dx.parent_id AND bcr_dx.deleted <> 1 AND bcr_dx.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['recurrence-biochemical recurrence']['id']."
		LEFT JOIN qc_tf_dxd_recurrence_bio bcr_dxd ON bcr_dx.id = bcr_dxd.diagnosis_master_id
		WHERE pr_dx.deleted <> 1 AND pr_dx.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['primary-prostate']['id']." AND pr_dx.participant_id IN (".implode(',', $bank_participant_identifier_to_id).");";
	$participant_id_to_primary_diagnosis_ids = array('-1' => '-1');
	foreach(getSelectQueryResult($query) as $new_record) {  
		if(isset($existing_prostate_dxs[$new_record['participant_id']]) && $existing_prostate_dxs[$new_record['participant_id']]['id'] != $new_record['prostate_diagnosis_master_id']) {
			//$participant_id_to_bank_participant_identifiers = array_flip($bank_participant_identifier_to_id);
			//recordErrorAndMessage($summary_section_title, '@@ERROR@@', "More Than One Prostate Diagnosis", "Patient '".$participant_id_to_bank_participant_identifiers[$new_record['participant_id']]."' of the bank '$file_bank_name' is linked to more than one Prostate Diagnosis. Only first one will be considered. Review all the data!");
			die("ERR_MANY_PROSTATE_DIAGNOSIS: Patient '".$participant_id_to_bank_participant_identifiers[$new_record['participant_id']]."' / bank '$file_bank_name'");
		} else {
			$existing_prostate_dxs[$new_record['participant_id']] = array('id' => $new_record['prostate_diagnosis_master_id'], 'hormonorefractory_status' => $new_record['hormonorefractory_status']);
			$participant_id_to_primary_diagnosis_ids[$new_record['participant_id']] = $new_record['prostate_diagnosis_master_id'];
		}
		if($new_record['bcr_diagnosis_master_id']) $existing_bcrs[$new_record['participant_id']][$new_record['bcr_dx_date']] = $new_record['bcr_type'];
	}
	$existing_secondary_diagnosis = array();
	$query = "SELECT second_dx.participant_id,
		second_dx.parent_id AS prostate_diagnosis_master_id,
		second_dx.id AS second_diagnosis_master_id,
		second_dx.dx_date AS second_dx_date,
		second_dx.dx_date_accuracy AS second_dx_date_accuracy,
		second_dxd.site AS second_site
		FROM diagnosis_masters second_dx
		INNER JOIN ".$atim_controls['diagnosis_controls']['secondary-other']['detail_tablename']." AS second_dxd ON second_dxd.diagnosis_master_id = second_dx.id
		WHERE second_dx.deleted <> 1 AND second_dx.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['secondary-other']['id']." AND second_dx.parent_id IN (".implode(',', $participant_id_to_primary_diagnosis_ids).");";
	foreach(getSelectQueryResult($query) as $new_record) {
		if($new_record['second_diagnosis_master_id']) {
			$existing_secondary_diagnosis[$new_record['participant_id']]['sites'][$new_record['second_site']][] = $new_record['second_dx_date'];
			$existing_secondary_diagnosis[$new_record['participant_id']]['dates'][$new_record['second_dx_date']][] = empty($new_record['second_site'])? '-1' : $new_record['second_site'];
		}
	}
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2, $excel_xls_offset)) {
		if(isset($excel_line_data['Patient # in biobank'])) {
			$summary_details_add_in = "Patient '".$excel_line_data['Patient # in biobank']."' / bank '$file_bank_name' / line '$line_number'";
			if(isset($bank_participant_identifier_to_id[$excel_line_data['Patient # in biobank']])) {				
				$atim_participant_id = $bank_participant_identifier_to_id[$excel_line_data['Patient # in biobank']];
				//1-Diagnosis Update
				$excel_field = "hormonorefractory status status";
				$excel_hormonorefractory_status = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qc_tf_hormonorefractory_status', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				if(strlen($excel_hormonorefractory_status)) {
					//Get ATiM Diagnosis Data to Update
					if(!isset($existing_prostate_dxs[$atim_participant_id])) {
						recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Prostate Primary Diagnosis Missing", "No prostate diagnosis exists into ATiM but a diagnosis data hase to be updated. Data won't be migrated. $summary_details_add_in");
					} else {
						$data_to_update = getDataToUpdate($existing_prostate_dxs[$atim_participant_id], array('hormonorefractory_status' => $excel_hormonorefractory_status));
						updateTableData($existing_prostate_dxs[$atim_participant_id]['id'], array('diagnosis_masters' => array(), $atim_controls['diagnosis_controls']['primary-prostate']['detail_tablename'] => $data_to_update));
						addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Upddated Primary Prostate Diagnosis Field(s)', $data_to_update);
					}
				}
				//2-Secondary Creation
				$excel_metastasis_data = array();
				$excel_field = "Development of metastasis Type of metastasis";
				$excel_metastasis_data['site'] = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qc_tf_metastasis_type', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_field = "Development of metastasis Date";
				list($excel_metastasis_data['dx_date'], $excel_metastasis_data['dx_date_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_patient_data['dx_date_accuracy'] = updateWithExcelAccuracy($excel_metastasis_data['dx_date_accuracy'], $excel_line_data["Development of metastasis Accuracy"]);
				$create_new_secondary = false;
				if($excel_metastasis_data['dx_date']) {
					if(isset($existing_secondary_diagnosis[$atim_participant_id]['dates'][$excel_metastasis_data['dx_date']])) {
						if($excel_metastasis_data['site']) {
							if(!in_array($excel_metastasis_data['site'], $existing_secondary_diagnosis[$atim_participant_id]['dates'][$excel_metastasis_data['dx_date']])) {
								//A secondary exists for the same date but site are different
								$create_new_secondary = true;
								if(in_array('-1',  $existing_secondary_diagnosis[$atim_participant_id]['dates'][$excel_metastasis_data['dx_date']])) {
									recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Secondary Diagnosis Created With Site But Undefined Secondary At Same Date Exists", "On '".$excel_metastasis_data['dx_date']."', a '".$excel_metastasis_data['site']."' secondary diagnosis has been created but an undefined secondary diagnosis was already defined for the same date into ATiM. Plase review data. $summary_details_add_in");
								}
							} else {
								//Already created: same site same date
							}							
						} else {
							//No site into excel. A secondary already exists into ATiM for this date. We won't create a new one with no site.
						}					
					} else {
						//No ATiM secondary exists into ATiM for this date: create new secondary
						$create_new_secondary = true;
					}
				} else if($excel_metastasis_data['site']) {
					if(!isset($existing_secondary_diagnosis[$atim_participant_id]['sites'][$excel_metastasis_data['site']])) {
						$create_new_secondary = true;
					} else {
						//No date into excel. A secondary already exists into ATiM for this site. We won't create a new one with no date.
					}
				}
				if($create_new_secondary) {
					$secondary_data = array(
						'diagnosis_masters' => array(
							'participant_id' => $atim_participant_id,
							'diagnosis_control_id' => $atim_controls['diagnosis_controls']['secondary-other']['id'],
							'dx_date' => $excel_metastasis_data['dx_date'],
							'dx_date_accuracy' => $excel_metastasis_data['dx_date_accuracy']),
						$atim_controls['diagnosis_controls']['secondary-other']['detail_tablename'] => array(
							'site' => $excel_metastasis_data['site']));
					customInsertRecord($secondary_data);
					addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Created Secondary Diagnosis', $excel_metastasis_data);
				}
				//3-BCR
				$excel_bcr_data = array();
				$excel_field = "Date of biochemical recurrence Date";
				list($excel_bcr_data['dx_date'], $excel_bcr_data['dx_date_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_patient_data['dx_date_accuracy'] = updateWithExcelAccuracy($excel_metastasis_data['dx_date_accuracy'], $excel_line_data["Date of biochemical recurrence Accuracy"]);
				$excel_field = "Date of biochemical recurrence Definition";
				$excel_bcr_data['type'] = validateAndGetStructureDomainValue(str_replace(array('first PSA of at least 0.2 and rising'), array('qc_tf_first_psa_2'), $excel_line_data[$excel_field]), 'qc_tf_date_biochemical_recurrence_definition', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				if($excel_bcr_data['dx_date']) {
					if(!array_key_exists($atim_participant_id, $existing_bcrs) || !array_key_exists($excel_bcr_data['dx_date'], $existing_bcrs[$atim_participant_id])) {
						$bcr_data = array(
							'diagnosis_masters' => array(
								'participant_id' => $atim_participant_id,
								'diagnosis_control_id' => $atim_controls['diagnosis_controls']['recurrence-biochemical recurrence']['id'],
								'dx_date' => $excel_bcr_data['dx_date'],
								'dx_date_accuracy' => $excel_bcr_data['dx_date_accuracy']),
							$atim_controls['diagnosis_controls']['recurrence-biochemical recurrence']['detail_tablename'] => array(
								'type' => $excel_bcr_data['type']));
						customInsertRecord($secondary_data);
						addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Created BCR Diagnosis', $excel_bcr_data);
					} else if($existing_bcrs[$atim_participant_id][$excel_bcr_data['dx_date']] != $excel_bcr_data['type'] ) {
						recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Types Of BCR Does Not Match", "Types of BCR does not match on '".$excel_bcr_data['dx_date']."' between ATiM '".$existing_bcrs[$atim_participant_id][$excel_bcr_data['dx_date']]."' and Excel '".$excel_bcr_data['type']."'. Plase review data. $summary_details_add_in");
					}
				} else if($excel_bcr_data['type']) {
					recordErrorAndMessage($summary_section_title, '@@WARNING@@', "BCR Date Missing", "BCR date is missing. BCR data won't be parsed. Plase review data. $summary_details_add_in");
				}
			} else {
				recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Bank Patient Un-Parsed", "The patient was not defined into 'Patient' worksheet. Patient data won't be parsed. $summary_details_add_in");
			}
		}
	}
	unset($existing_prostate_dxs);
	unset($existing_bcrs);
	unset($existing_secondary_diagnosis);
	
	// ******* Event Data Update *******
	
	$worksheet_name = 'event';
	$summary_section_title = "Worksheet '$worksheet_name'";
	$existing_psa = array();
	$query = "SELECT em.participant_id,
		em.event_date, 
		em.event_date_accuracy,
		ed.psa_ng_per_ml
		FROM event_masters em
		INNER JOIN ".$atim_controls['event_controls']['psa']['detail_tablename']." ed ON ed.event_master_id = em.id
		WHERE em.deleted <> 1 AND em.event_control_id = ".$atim_controls['event_controls']['psa']['id']." AND em.participant_id IN (".implode(',', $bank_participant_identifier_to_id).");";
	foreach(getSelectQueryResult($query) as $new_record) {
		$existing_psa[$new_record['participant_id']][$new_record['event_date']] = $new_record['psa_ng_per_ml'];
	}
	$existing_radiotherapies = array();
	$query = "SELECT tm.participant_id,
		tm.start_date,
		tm.start_date_accuracy,
		tm.finish_date,
		tm.finish_date_accuracy,
		td.qc_tf_dose_cg,
		td.qc_tf_type
		FROM treatment_masters tm 
		INNER JOIN ".$atim_controls['treatment_controls']['radiation']['detail_tablename']." td ON tm.id = td.treatment_master_id
		WHERE tm.deleted <> 1 AND tm.treatment_control_id  = ".$atim_controls['treatment_controls']['radiation']['id']." AND tm.participant_id IN (".implode(',', $bank_participant_identifier_to_id).");";
	foreach(getSelectQueryResult($query) as $new_record) {
		$existing_radiotherapies[$new_record['participant_id']][$new_record['start_date']] = $new_record;
	}
	
	$existing_therapies_with_drugs = array();
	foreach(array('hormonotherapy', 'chemotherapy', 'other treatment bone specific', 'other treatment HR specific') as $tx_method) {
		$query = "SELECT tm.participant_id,
			tm.id AS treatment_master_id,
			tm.start_date,
			tm.start_date_accuracy,
			tm.finish_date,
			tm.finish_date_accuracy,
			dr.generic_name
			FROM treatment_masters tm
			INNER JOIN ".$atim_controls['treatment_controls'][$tx_method]['detail_tablename']." td ON tm.id = td.treatment_master_id
			LEFT JOIN treatment_extend_masters tem ON tem.treatment_master_id = tm.id AND tem.deleted <> 1 AND tem.treatment_extend_control_id = ".$atim_controls['treatment_controls'][$tx_method]['treatment_extend_control_id']."
			LEFT JOIN ".$atim_controls['treatment_controls'][$tx_method]['treatment_extend_detail_tablename']." ted ON tem.id = ted.treatment_extend_master_id
			LEFT JOIN drugs dr ON dr.id = ted.drug_id AND dr.deleted <> 1
			WHERE tm.deleted <> 1 AND tm.treatment_control_id  = ".$atim_controls['treatment_controls'][$tx_method]['id']." AND tm.participant_id IN (".implode(',', $bank_participant_identifier_to_id).");";
		foreach(getSelectQueryResult($query) as $new_record) {
			if(!isset($existing_therapies_with_drugs[$tx_method][$new_record['participant_id']][$new_record['start_date']][$new_record['treatment_master_id']])) {
				$new_record['drugs'] = array();
				if($new_record['generic_name']) $new_record['drugs'][$new_record['generic_name']] = $new_record['generic_name'];
				unset($new_record['generic_name']);
				$existing_therapies_with_drugs[$tx_method][$new_record['participant_id']][$new_record['start_date']][$new_record['treatment_master_id']] = $new_record;
			} else {
				if($new_record['generic_name']) $existing_therapies_with_drugs[$tx_method][$new_record['participant_id']][$new_record['start_date']][$new_record['treatment_master_id']]['drugs'][] = $new_record['generic_name'];
			}
		}
	}
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2, $excel_xls_offset)) {
		if(isset($excel_line_data['Patient # in biobank'])) {
			$summary_details_add_in = "Patient '".$excel_line_data['Patient # in biobank']."' / bank '$file_bank_name' / line '$line_number'";
			if(isset($bank_participant_identifier_to_id[$excel_line_data['Patient # in biobank']])) {				
				$atim_participant_id = $bank_participant_identifier_to_id[$excel_line_data['Patient # in biobank']];
				if(isset($participant_id_to_primary_diagnosis_ids[$atim_participant_id])) {
					$diagnosis_master_id = $participant_id_to_primary_diagnosis_ids[$atim_participant_id];
					$nbr_of_defined_treatement_types = 0;
					//Get Dates
					$excel_event_dates = array();
					$excel_field = "Dates of event Date of event (beginning)";
					list($excel_event_dates['start_date'], $excel_event_dates['start_date_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					$excel_event_dates['start_date_accuracy'] = updateWithExcelAccuracy($excel_event_dates['start_date_accuracy'], $excel_line_data["Dates of event Accuracy (beginning)"]);
					$excel_field = "Dates of event Date of event (end)";
					list($excel_event_dates['finish_date'], $excel_event_dates['finish_date_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					$excel_event_dates['finish_date_accuracy'] = updateWithExcelAccuracy($excel_event_dates['finish_date_accuracy'], $excel_line_data["Dates of event Accuracy (end)"]);
					//1-PSA Update
					$excel_field = "PSA (ng/ml)";
					$excel_psa = validateAndGetDecimal($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					if(strlen($excel_psa)) {
						$nbr_of_defined_treatement_types++;
						if(isset($existing_psa[$atim_participant_id][$excel_event_dates['start_date']])) {
							if($existing_psa[$atim_participant_id][$excel_event_dates['start_date']] != $excel_psa) {
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "PSA Value Does Not Match", "See ATiM value [".$existing_psa[$atim_participant_id][$excel_event_dates['start_date']]."] and excel value [$excel_psa] on '".$excel_event_dates['start_date']."'. Data won't be updated. $summary_details_add_in");	
							}
						} else {
							$psa_data = array(
								'event_masters' => array(
									'participant_id' => $atim_participant_id,
									'diagnosis_master_id' => $diagnosis_master_id,
									'event_control_id' => $atim_controls['event_controls']['psa']['id'],
									'event_date' => $excel_event_dates['start_date'],
									'event_date_accuracy' => $excel_event_dates['start_date_accuracy']),
								 $atim_controls['event_controls']['psa']['detail_tablename'] => array(
									'psa_ng_per_ml' => $excel_psa));
							customInsertRecord($psa_data);
							addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Created PSA', array_merge(array('event_date' => $excel_event_dates['start_date'], 'event_date_accuracy' => $excel_event_dates['start_date_accuracy']), array('psa_ng_per_ml' => $excel_psa)));
						}
					}
					//2-Radiotherapy
					$excel_field = "Radiotherapy";
					$qc_tf_type = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qc_tf_radiotherapy_type', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					$excel_field = "radiotherapy dose cGy";
					$qc_tf_dose_cg = validateAndGetInteger($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					if(strlen($qc_tf_type) || strlen($qc_tf_type)) {
						$nbr_of_defined_treatement_types++;
						if(isset($existing_radiotherapies[$atim_participant_id][$excel_event_dates['start_date']])) {
							$mismatch_data = getDataToUpdate($existing_radiotherapies[$atim_participant_id][$excel_event_dates['start_date']],
								array_merge($excel_event_dates, array('participant_id' => $atim_participant_id, 'qc_tf_type' => $qc_tf_type, 'qc_tf_dose_cg' => $qc_tf_dose_cg)));
							if($mismatch_data) {
								$diff_strg = array();
								foreach($mismatch_data as $key => $excel_value) $diff_strg[] = "$key : '".$existing_radiotherapies[$atim_participant_id][$excel_event_dates['start_date']][$key]."'(ATiM) != '$excel_value'(Excel)";
								$diff_strg = implode (' & ', $diff_strg);
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Radiation Value(s) Does Not Match", "See following values [$diff_strg]. Data won't be updated. $summary_details_add_in");
							}
//TODO Should we update values in case values are empty into ATiM? Todo if many cases.				
						} else {
							$tx_data = array(
								'treatment_masters' => array_merge(
									array('participant_id' => $atim_participant_id, 'diagnosis_master_id' => $diagnosis_master_id, 'treatment_control_id' => $atim_controls['treatment_controls']['radiation']['id']), 
									$excel_event_dates),
								$atim_controls['treatment_controls']['radiation']['detail_tablename'] => array(
									'qc_tf_type' => $qc_tf_type,
									'qc_tf_dose_cg' => $qc_tf_dose_cg));
							customInsertRecord($tx_data);
							addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Created Radiotherpay', array_merge($excel_event_dates, $tx_data[$atim_controls['treatment_controls']['radiation']['detail_tablename']]));
						}
					}	
					//3-Treatment Linked To Drugs
					$excel_drug_list = array();
					for($i = 1; $i < 5; $i ++) {
						$key = 'treatment Precision drug '.$i;
						if(!in_array($excel_line_data[$key], array('', 'no', 'unknown'))){
							$excel_drug_list['Drug '.$i] = $excel_line_data[$key];
						}
					}
					$treatment_with_drug_detected = false;
					foreach(array(array('hormonotherapy', 'hormonotherapy', 'hormonal'), array('chemotherapy', 'chemiotherapy', 'chemotherapy'), array('other treatment', 'Other treatments', '?')) as $new_treatment_data) {
						list($treatment_type, $excel_field, $drug_type) = $new_treatment_data;
						$excel_line_data[$excel_field] = str_replace(array('no', 'unknown') , array('', ''), strtolower($excel_line_data[$excel_field]));
						if($excel_field == 'Other treatments') {
							if(in_array($excel_line_data[$excel_field], array('bone specific', 'hr specific'))) {
								$treatment_type = 'other treatment '.(($excel_line_data[$excel_field] == 'bone specific')? 'bone specific' : 'HR specific');
								$drug_type = ($excel_line_data[$excel_field] == 'bone specific')? 'bone' : 'HR';
								$excel_line_data[$excel_field] = 'yes';								
							}
						}
						if($excel_line_data[$excel_field] == 'yes') {
							$nbr_of_defined_treatement_types++;
							$treatment_with_drug_detected = true;
							if(isset($existing_therapies_with_drugs[$treatment_type][$atim_participant_id][$excel_event_dates['start_date']])) {
								if(sizeof(isset($existing_therapies_with_drugs[$treatment_type][$atim_participant_id][$excel_event_dates['start_date']])) > 1) {
									recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Too Many $treatment_type On Same date", "More than one $treatment_type exists into ATiM on '".$excel_event_dates['start_date']."' for the patient. Migration process won't be able to select the good one. The $treatment_type data won't be updated. $summary_details_add_in");
								} else {
									$atim_data = array_shift($existing_therapies_with_drugs[$treatment_type][$atim_participant_id][$excel_event_dates['start_date']]);
									$updated_tx_data = array();
									//Compare Finish Dates
									if($atim_data['finish_date'] != $excel_event_dates['finish_date']) {
										if(!$atim_data['finish_date']) {
											$updated_tx_data = array('finish_date' => $excel_event_dates['finish_date'], 'finish_date_accuracy' => $excel_event_dates['finish_date_accuracy']);
											updateTableData($atim_data['treatment_master_id'], array('treatment_masters' => $updated_tx_data));
										} else if($excel_event_dates['finish_date']) {
											recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Different Finish Data", "The finish dates of the $treatment_type started on '".$excel_event_dates['start_date']."' are different ('".$atim_data['finish_date']."'(ATiM) != '".$excel_event_dates['finish_date']."'(Excel)). Migration process won't be able to select the good one. Date won't be updated. $summary_details_add_in");
										}
									}
									//Compare drugs
									$formated_excel_list = array();
									foreach($excel_drug_list as $new_drug) $formated_excel_list[strtolower($new_drug)] = strtolower($new_drug);
									$formated_atim_list = array();
									foreach($atim_data['drugs'] as $new_drug) $formated_atim_list[strtolower($new_drug)] = strtolower($new_drug);
									$drug_only_into_atim = array();;
									$created_drug_counter = 0;
									foreach(array_merge($formated_excel_list, $formated_atim_list) as $drug_name) {
										if(in_array($drug_name, $formated_excel_list) && in_array($drug_name, $formated_atim_list)) {
											//Nothing to do
										} else if(in_array($drug_name, $formated_excel_list)) {
											$drug_id = getDrugId($drug_name, $drug_type);
											if($drug_id) {
												$created_drug_counter++;
												$tx_ext_data = array(
													'treatment_extend_masters' => array(
														'treatment_master_id' => $atim_data['treatment_master_id'],
														'treatment_extend_control_id' => $atim_controls['treatment_controls'][$treatment_type]['treatment_extend_control_id']),
													$atim_controls['treatment_controls'][$treatment_type]['treatment_extend_detail_tablename'] => array(
														'drug_id' => $drug_id));
												customInsertRecord($tx_ext_data);
												$updated_tx_data['Created Drug'.$created_drug_counter] = $drug_name;
											}
										} else {
											//Drug Only Into ATiM
											$drug_only_into_atim[] = $drug_name;
										}
									}
									if($drug_only_into_atim) {
										recordErrorAndMessage($summary_section_title, '@@WARNING@@', "$treatment_type Drugs Only Into ATiM", "See following drugs [".implode(' & ', $drug_only_into_atim)."] of treatment strated on '".$excel_event_dates['start_date']."'. Data won't be updated. $summary_details_add_in");
									}
									if($updated_tx_data) {
										addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], "Upddated $treatment_type started on ".$excel_event_dates['start_date'], $updated_tx_data);
									}
								}
							} else {
								//TreatmentMaster
								$tx_data = array(
									'treatment_masters' => array_merge(
										array('participant_id' => $atim_participant_id, 'diagnosis_master_id' => $diagnosis_master_id, 'treatment_control_id' => $atim_controls['treatment_controls'][$treatment_type]['id']),
										$excel_event_dates),
									$atim_controls['treatment_controls'][$treatment_type]['detail_tablename'] => array());
								$treatment_master_id = customInsertRecord($tx_data);
								if($excel_drug_list) {
									//TreatmentExtendMaster
									foreach($excel_drug_list as $new_drug) {
										$drug_id = getDrugId($new_drug, $drug_type);
										if($drug_id) {
											$tx_ext_data = array(
												'treatment_extend_masters' => array(
													'treatment_master_id' => $treatment_master_id, 
													'treatment_extend_control_id' => $atim_controls['treatment_controls'][$treatment_type]['treatment_extend_control_id']),
												$atim_controls['treatment_controls'][$treatment_type]['treatment_extend_detail_tablename'] => array(
													'drug_id' => $drug_id));
											customInsertRecord($tx_ext_data);
										}
									}
								}
								addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], "Created $treatment_type", array_merge($excel_event_dates, $excel_drug_list));
							}
						} else if(strlen($excel_line_data[$excel_field])) {
							recordErrorAndMessage($summary_section_title, '@@ERROR@@', "$excel_field Value Not Supported", "See value [".$excel_line_data[$excel_field]."]. No treatment will be migrated. $summary_details_add_in");
						}			
					}
					if(!$treatment_with_drug_detected && !empty($excel_drug_list)) {
						recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Drugs List With No Treatment", "A drug list has been defined but no treatment to link to this one is defined into excel. No drug will be migrated. $summary_details_add_in");
					}
					//Check only on treatment per row is defined
					if($nbr_of_defined_treatement_types > 1) {
						recordErrorAndMessage($summary_section_title, '@@WARNING@@', "More Than One Treatment Type Defined On The Same Row", "Please review data and validate migration. $summary_details_add_in");
					}
				} else {
					recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Missing Prostate Primary Diagnosis", "No prostate primary diagnosis was defined into ATiM. Event won't be parsed. $summary_details_add_in");	
				}
			} else {
				recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Bank Patient Un-Parsed", "The patient was not defined into 'Patient' worksheet. Patient data won't be parsed. $summary_details_add_in");
			}
		}
	}	
}



















//TODO refiare les champs calculé???
//TODO Mettre PSA lié a récurrence si besoin
//TODO redéfinir le DFS start...

global $import_summary;

$update_summary = array();
if(isset($import_summary['Updated Data Summary'])) {
	$update_summary = array('Updated Data Summary' => $import_summary['Updated Data Summary']);
	unset($import_summary['Updated Data Summary']);
}

dislayErrorAndMessage();

$import_summary = $update_summary;

dislayErrorAndMessage();

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function updateWithExcelAccuracy($excel_date_accuracy, $excel_accuracy_field_value){
	switch($excel_accuracy_field_value) {
		case 'c':
			$excel_date_accuracy = 'c';
			break;
		case 'm':
			$excel_date_accuracy = 'd';
			break;
		case 'y':
			$excel_date_accuracy = 'm';
			break;
	}
	return $excel_date_accuracy;
}

function getDataToUpdate($atim_data, $excel_data) {
	$data_to_update = array();
	foreach($excel_data as $key => $value) {
		if(!array_key_exists($key, $atim_data)) die('ERR_8837282882:'.$key);
		if(strlen($value) && $value != $atim_data[$key]) $data_to_update[$key] = $value;
	}
	return $data_to_update;
}

function addUpdatedDataToSummary($bank, $qc_tf_bank_participant_identifier, $data_type, $data_to_update) {
	if($data_to_update) {
		$updates = array();
		foreach($data_to_update as $field => $value) $updates[] = "[$field = $value]";
		recordErrorAndMessage('Updated Data Summary', '@@MESSAGE@@', "Patient# $qc_tf_bank_participant_identifier ($bank)", "$data_type : ".implode(' + ', $updates));
	}
}

function getDrugId($drug_name, $type) {
	global $atim_drugs;
	
	if(!strlen($drug_name)) return null;

	if(empty($atim_drugs)) {
		//Get first drugs list from ATiM
		$query = "SELECT id, generic_name, type FROM drugs WHERE deleted <> 1;";
		foreach(getSelectQueryResult($query) as $new_record) {
			$drug_key = getDrugKey($new_record['generic_name'], $new_record['type']);
			$atim_drugs[$drug_key] = $new_record['id'];
		}
	}

	$drug_key = getDrugKey($drug_name, $type);
	if(array_key_exists($drug_key, $atim_drugs)) return $atim_drugs[$drug_key];

	$drug_data = array('drugs' => array('generic_name' => $drug_name, 'type' =>$type));
	$atim_drugs[$drug_key] = customInsertRecord($drug_data);

	return $atim_drugs[$drug_key];
}

function getDrugKey($drug_name, $type) {
	if(!in_array($type, array('', 'bone', 'HR', 'chemotherapy', 'hormonal'))) die('ERR 237 7263726 drug type'.$type);
	return strtolower($drug_name.'## ##'.$type);
}
	
?>
		