<?php

//=================================================================================================================
// CLINICAL DATA UPDATE SCRIPT
//		Both fro active surveillance and radical prostatectomy project
//=================================================================================================================

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

$commitAll = true;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $commitAll = false;
    } else {
        die('ERR ARG : '.$argv[1].' (should be test or nothing)');
    }
}

//==============================================================================================
// Main Code
//==============================================================================================

displayMigrationTitle('CPCBN Clinical Data Update');

if(!testExcelFile(array_keys($excel_files_names))) {
	dislayErrorAndMessage();
	exit;
}

// *** PARSE EXCEL FILES ***
pr("<font color='red'>Any body mass info recorded into Excel will be created as a new record into ATiM. No mismatch analysis betweem excel data and ATiM data will be executed. Please confirm.</font>");
pr("<font color='red'>Any ECOG or ASA info recorded into Excel will be created as a new record into ATiM. No mismatch analysis betweem excel data and ATiM data will be executed. Please confirm.</font>");

$dateCheckDone = false;

foreach($excel_files_names as $excel_file_name => $excel_xls_offset) {
	recordErrorAndMessage('Parsed Files', '@@MESSAGE@@', "Files Names", $excel_file_name);
		
	$file_bank_name = null;	//New excel file so new bank
	$bank_participant_identifier_to_participant_id = array('-1' => '-1');
	
	// ******* Patient Data Update *******
	
	$worksheet_name = 'patient';
	$summary_section_title = "Worksheet '$worksheet_name'";
	
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2, $excel_xls_offset)) {
		if(isset($excel_line_data['Bank'])) {
			if($file_bank_name && $file_bank_name != $excel_line_data['Bank']) die("ERR_MANY_BANKS : $excel_file_name - [$file_bank_name] != [".$excel_line_data['Bank']."] at line $line_number");
			$file_bank_name = $excel_line_data['Bank'];
			$summary_details_add_in = "Patient '".$excel_line_data['Patient # in biobank']."' / bank '$file_bank_name' / line '$line_number / file '$excel_file_name''";
			$atim_patient_data = getSelectQueryResult("SELECT p.* FROM participants p INNER JOIN banks b ON b.id = p.qc_tf_bank_id WHERE b.name = '".$excel_line_data['Bank']."' AND p.qc_tf_bank_participant_identifier = '".$excel_line_data['Patient # in biobank']."' AND p.deleted <>1;");
			if(!empty($atim_patient_data)) {
				$atim_patient_data = $atim_patient_data[0];
				$bank_participant_identifier_to_participant_id[$excel_line_data['Patient # in biobank']] = $atim_patient_data['id'];
				//Get Excel Value
				$excel_patient_data = array();
				$excel_field = 'Death from prostate cancer';
				$excel_patient_data['qc_tf_death_from_prostate_cancer'] = validateAndGetExcelValueFromList($excel_line_data[$excel_field], array('-' => '', 'unknown' => '', 'yes' => 'y', 'no' => 'n'), true, $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_field = 'Death status';
				$excel_patient_data['vital_status'] = validateAndGetStructureDomainValue(str_replace(array('dead'), array('deceased'), strtolower($excel_line_data[$excel_field])), 'health_status', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_field = "Registered Date of Death Date";
				list($excel_patient_data['date_of_death'], $excel_patient_data['date_of_death_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_patient_data['date_of_death_accuracy'] = updateWithExcelAccuracy($excel_patient_data['date_of_death_accuracy'], $excel_line_data["Registered Date of Death Accuracy"]);
				$excel_field = "Suspected Date of Death Date";
				list($excel_patient_data['qc_tf_suspected_date_of_death'], $excel_patient_data['qc_tf_suspected_date_of_death_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_patient_data['qc_tf_suspected_date_of_death_accuracy'] = updateWithExcelAccuracy($excel_patient_data['qc_tf_suspected_date_of_death_accuracy'], $excel_line_data["Suspected Date of Death Accuracy"]);
				$excel_field = "Last contact (overall) Date";
				list($excel_patient_data['qc_tf_last_contact'], $excel_patient_data['qc_tf_last_contact_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				if(!$dateCheckDone && $excel_patient_data['qc_tf_last_contact']) {
				    pr("<font color='red'>Date of last contact for date format check : Line $line_number / Date " .$excel_patient_data['qc_tf_last_contact']. "</font>");
				    $dateCheckDone = true;
				}
				$excel_patient_data['qc_tf_last_contact_accuracy'] = updateWithExcelAccuracy($excel_patient_data['qc_tf_last_contact_accuracy'], $excel_line_data["Last contact (overall) Accuracy"]);
				$excel_patient_data['qc_tf_last_ct_ov_dept_visited'] = $excel_line_data["Last contact (overall) Department visited"];
				$excel_field = "Last contact (overall) Evidence of PC progression at last contact (yes, no, unknown - use last PC follow-up)";
				$excel_patient_data['qc_tf_last_ct_ov_evidence_of_pc_prog'] = validateAndGetStructureDomainValue(str_replace(array('unknown - use last PC follow-up'), array('unknown'), strtolower($excel_line_data[$excel_field])), 'yesnounknown', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_field = "Last contact PC related (urology/radiology/PSA/treatment) Date";
				list($excel_patient_data['qc_tf_last_pc_rel_date'], $excel_patient_data['qc_tf_last_pc_rel_date_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_patient_data['qc_tf_last_pc_rel_date_accuracy'] = updateWithExcelAccuracy($excel_patient_data['qc_tf_last_pc_rel_date_accuracy'], $excel_line_data["Last contact PC related (urology/radiology/PSA/treatment) Accuracy"]);
				$excel_field = "Last contact PC related (urology/radiology/PSA/treatment) Reason for visit (PSA, Clinic, Imaging)";
				$excel_patient_data['qc_tf_last_pc_rel_reason_for_visit'] = validateAndGetStructureDomainValue(str_replace(array('follow-up in clinic'), array('clinic'), strtolower($excel_line_data[$excel_field])), 'reason_last_contact_pc', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_field = "Last contact PC related (urology/radiology/PSA/treatment) Evidence of PC progression at last PC contact (yes, no)";
				$excel_patient_data['qc_tf_last_pc_rel_evidence_of_pc_prog'] = validateAndGetExcelValueFromList($excel_line_data[$excel_field], array('unknown' => '', 'yes' => 'y', 'no' => 'n'), true, $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
                if(strlen($excel_line_data['notes'])) {
                    if(!strpos($atim_patient_data['notes'], $excel_line_data['notes'])) {
                        $excel_patient_data['notes'] = $excel_line_data['notes'].'. '.$atim_patient_data['notes'];
                    }
                }
                $excel_field = 'Ethnicity Caucasian, African American, Asian, Hispanic, other';
                $excel_patient_data['qc_tf_ethnicity'] = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qc_tf_ethnicity', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
                $excel_field = 'Family History (prostatite/cancer)';
				$excel_patient_data['qc_tf_family_history'] = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qc_tf_fam_hist_prostate_cancer', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				//Get ATiM Patient Data to Update
				$data_to_update = getDataToUpdate($atim_patient_data, $excel_patient_data);		
				updateTableData($atim_patient_data['id'], array('participants' => $data_to_update));
				addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Updated  participant field(s)', $data_to_update);
    			//BMI
				recordErrorAndMessage($summary_section_title, '@@WARNING@@', "No check on existing record into ATiM will be done. New record will be created when data exists into Excel. Please confirm.", "Rule applied to BMI.",'bmi');
				recordErrorAndMessage($summary_section_title, '@@WARNING@@', "No check on existing record into ATiM will be done. New record will be created when data exists into Excel. Please confirm.", "Rule applied to ECOG.",'ecog');
				recordErrorAndMessage($summary_section_title, '@@WARNING@@', "No check on existing record into ATiM will be done. New record will be created when data exists into Excel. Please confirm.", "Rule applied to ASA.",'asa');
				$query = "SELECT * FROM event_masters WHERE deleted <> 1 AND participant_id = ".$atim_patient_data['id']." AND event_control_id IN (".$atim_controls['event_controls']['bmi']['id'].",".$atim_controls['event_controls']['physical status']['id'].")";
				$queryRes = getSelectQueryResult($query) ;
				if($queryRes) {
				    recordErrorAndMessage($summary_section_title, '@@WARNING@@', "No check on existing record into ATiM will be done. New record will be created when data exists into Excel. Please confirm.", "Either BMI or Physical Status seams to exist into ATiM for participant $summary_details_add_in. Please check data has not been duplicated.");
				}
				$excel_field = "Body Mass Index Info (at time of CPCBN specimen collection) Date (yyyy-mm-dd)";
				list($event_date, $event_date_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$event_date_accuracy = updateWithExcelAccuracy($event_date_accuracy, $excel_line_data["Body Mass Index Info (at time of CPCBN specimen collection) Accuracy"]);
				$excel_field = "Body Mass Index Info (at time of CPCBN specimen collection) Height (m)";
				$height_m  = validateAndGetDecimal($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_field = "Body Mass Index Info (at time of CPCBN specimen collection) Weight (kg)";
				$weight_kg  = validateAndGetDecimal($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				if(strlen($height_m.$weight_kg.$event_date)) {
				    $event_data = array(
				        'event_masters' => array(
			                'participant_id' => $atim_patient_data['id'],
			                'event_control_id' => $atim_controls['event_controls']['bmi']['id'],
			                'event_date' => $event_date,
			                'event_date_accuracy' => $event_date_accuracy),
				        $atim_controls['event_controls']['bmi']['detail_tablename'] => array(
				            'height_m' => $height_m,
				            'weight_kg' => $weight_kg));
				    if(strlen($height_m) && strlen($weight_kg) && $height_m != '0') {
				        $event_data[$atim_controls['event_controls']['bmi']['detail_tablename']]['bmi'] = $weight_kg / ($height_m * $height_m);
				    }
				    customInsertRecord($event_data);
				    addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Created BMI', array_merge(array('event_date' => $event_date, 'event_date_accuracy' => $event_date_accuracy), $event_data[$atim_controls['event_controls']['bmi']['detail_tablename']]));
				}
				//physical status
				$excel_field = "ECOG (refer to list and reference sheet) at time of CPCBN specimen collection";
				$ecog  = validateAndGetStructureDomainValue(str_replace(array(''), array(''), strtolower($excel_line_data[$excel_field])), 'qc_tf_ed_ecog', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_field = "ASA at time of CPCBN specimen collection";
				$asa  = validateAndGetStructureDomainValue(str_replace(array('1','2','3'), array('I', 'II', 'III'), strtolower($excel_line_data[$excel_field])), 'qc_tf_ed_asa', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				if(strlen($ecog.$asa)) {
				    $event_data = array(
				        'event_masters' => array(
				            'participant_id' => $atim_patient_data['id'],
				            'event_control_id' => $atim_controls['event_controls']['physical status']['id'],
				            'event_date' => $event_date,
				            'event_date_accuracy' => $event_date_accuracy),
				        $atim_controls['event_controls']['physical status']['detail_tablename'] => array(
				            'ecog' => $ecog,
				            'asa' => $asa));
				    customInsertRecord($event_data);
				    addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Created BMI', array_merge(array('event_date' => $event_date, 'event_date_accuracy' => $event_date_accuracy), $event_data[$atim_controls['event_controls']['physical status']['detail_tablename']]));
				}
			} else {
				recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Bank patient unknown", "No ATim Patient matches excel patient. Patient data won't be parsed. $summary_details_add_in");
			}
		} else {
			recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Bank column missing", "'Bank' column is missing into worksheet '$worksheet_name'. No data will be parsed.");
		}
	}
		
	// ******* Diagnosis Data Update *******
	
	$worksheet_name = 'diagnosis';
	$summary_section_title = "Worksheet '$worksheet_name'";
	
	$atim_prostate_primary_diagnosis_data = array();
	$atim_bcrs = array();
	$atim_secondary_diagnosis = array();
	
	$query = "SELECT pr_dx.participant_id, 
		pr_dx.id AS prostate_diagnosis_master_id, 
		pr_dxd.hormonorefractory_status, 
		bcr_dx.id AS bcr_diagnosis_master_id, 
		bcr_dx.dx_date AS bcr_dx_date, 
		bcr_dx.dx_date_accuracy AS bcr_dx_date_accuracy,
		bcr_dxd.type AS bcr_type
		FROM diagnosis_masters pr_dx
		INNER JOIN ".$atim_controls['diagnosis_controls']['primary-prostate']['detail_tablename']." AS pr_dxd ON pr_dxd.diagnosis_master_id = pr_dx.id
		LEFT JOIN diagnosis_masters bcr_dx ON pr_dx.id = bcr_dx.parent_id AND bcr_dx.deleted <> 1 AND bcr_dx.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['id']."
		LEFT JOIN ".$atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['detail_tablename'] ." bcr_dxd ON bcr_dx.id = bcr_dxd.diagnosis_master_id
		WHERE pr_dx.deleted <> 1 AND pr_dx.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['primary-prostate']['id']." AND pr_dx.participant_id IN (".implode(',', $bank_participant_identifier_to_participant_id).");";
	foreach(getSelectQueryResult($query) as $new_record) {  
		if(isset($atim_prostate_primary_diagnosis_data[$new_record['participant_id']])) {
			if($atim_prostate_primary_diagnosis_data[$new_record['participant_id']]['id'] != $new_record['prostate_diagnosis_master_id']) {
				$participant_id_to_bank_participant_identifiers = array_flip($bank_participant_identifier_to_participant_id);
				die("ERR_MANY_PROSTATE_DIAGNOSIS: Patient '".$participant_id_to_bank_participant_identifiers[$new_record['participant_id']]."' / bank '$file_bank_name'");
			}
		} else {
			$atim_prostate_primary_diagnosis_data[$new_record['participant_id']] = array('id' => $new_record['prostate_diagnosis_master_id'], 'hormonorefractory_status' => $new_record['hormonorefractory_status']);
		}
		if($new_record['bcr_diagnosis_master_id']) $atim_bcrs[$new_record['participant_id']][$new_record['bcr_dx_date']] = $new_record['bcr_type'];
	}
	$query = "SELECT second_dx.participant_id,
		second_dx.id AS second_diagnosis_master_id,
		second_dx.dx_date AS second_dx_date,
		second_dx.dx_date_accuracy AS second_dx_date_accuracy,
		second_dxd.site AS second_site
		FROM diagnosis_masters pr_dx
		INNER JOIN diagnosis_masters second_dx ON pr_dx.id = second_dx.parent_id AND second_dx.deleted <> 1 AND second_dx.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['secondary - distant-other']['id']." 
		INNER JOIN ".$atim_controls['diagnosis_controls']['secondary - distant-other']['detail_tablename']." AS second_dxd ON second_dxd.diagnosis_master_id = second_dx.id
		WHERE pr_dx.deleted <> 1 AND pr_dx.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['primary-prostate']['id']." AND pr_dx.participant_id IN (".implode(',', $bank_participant_identifier_to_participant_id).");";
	foreach(getSelectQueryResult($query) as $new_record) {
		$atim_secondary_diagnosis[$new_record['participant_id']]['sites'][$new_record['second_site']][] = $new_record['second_dx_date'];
		$atim_secondary_diagnosis[$new_record['participant_id']]['dates'][$new_record['second_dx_date']][] = empty($new_record['second_site'])? '-1' : $new_record['second_site'];
	}
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2, $excel_xls_offset)) {
		if(isset($excel_line_data['Patient # in biobank'])) {
			$summary_details_add_in = "Patient '".$excel_line_data['Patient # in biobank']."' / bank '$file_bank_name' / line '$line_number' / file '$excel_file_name'";
			if(isset($bank_participant_identifier_to_participant_id[$excel_line_data['Patient # in biobank']])) {				
				$atim_participant_id = $bank_participant_identifier_to_participant_id[$excel_line_data['Patient # in biobank']];
				if(isset($atim_prostate_primary_diagnosis_data[$atim_participant_id])) {
					$diagnosis_master_id = $atim_prostate_primary_diagnosis_data[$atim_participant_id]['id'];
					//1-Diagnosis Update
					$excel_field = "hormonorefractory status status";
					$new_diagnosis_data = array('hormonorefractory_status' => validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qc_tf_hormonorefractory_status', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in));
					$data_to_update = getDataToUpdate($atim_prostate_primary_diagnosis_data[$atim_participant_id], $new_diagnosis_data);
					updateTableData($atim_prostate_primary_diagnosis_data[$atim_participant_id]['id'], array('diagnosis_masters' => array(), $atim_controls['diagnosis_controls']['primary-prostate']['detail_tablename'] => $data_to_update));
					addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Updated  primary prostate diagnosis field(s)', $data_to_update);
					//2-Secondary Creation
					$excel_metastasis_data = array();
					$excel_field = "Development of metastasis Type of metastasis";
					$excel_metastasis_data['site'] = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qc_tf_metastasis_type', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					$excel_field = "Development of metastasis Date";
					list($excel_metastasis_data['dx_date'], $excel_metastasis_data['dx_date_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					$excel_patient_data['dx_date_accuracy'] = updateWithExcelAccuracy($excel_metastasis_data['dx_date_accuracy'], $excel_line_data["Development of metastasis Accuracy"]);
					$create_new_secondary = false;
					if($excel_metastasis_data['dx_date']) {
						if(isset($atim_secondary_diagnosis[$atim_participant_id]['dates'][$excel_metastasis_data['dx_date']])) {
							if($excel_metastasis_data['site']) {
								if(!in_array($excel_metastasis_data['site'], $atim_secondary_diagnosis[$atim_participant_id]['dates'][$excel_metastasis_data['dx_date']])) {
									//A secondary exists for the same date but site are different
									$create_new_secondary = true;
									if(in_array('-1',  $atim_secondary_diagnosis[$atim_participant_id]['dates'][$excel_metastasis_data['dx_date']])) {
										recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Both known secondary and undefined secondary will exist into ATiM at the same date after update", "On '".$excel_metastasis_data['dx_date']."', a '".$excel_metastasis_data['site']."' secondary diagnosis has been created but an undefined secondary diagnosis was already defined for the same date into ATiM. Plase review data and update if required. $summary_details_add_in");
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
						if(!isset($atim_secondary_diagnosis[$atim_participant_id]['sites'][$excel_metastasis_data['site']])) {
							$create_new_secondary = true;
						} else {
							//No date into excel. A secondary already exists into ATiM for this site. We won't create a new one with no date.
						}
					}
					if($create_new_secondary) {
						$secondary_data = array(
							'diagnosis_masters' => array(
								'participant_id' => $atim_participant_id,
								'diagnosis_control_id' => $atim_controls['diagnosis_controls']['secondary - distant-other']['id'],
								'primary_id' => $diagnosis_master_id,
								'parent_id' => $diagnosis_master_id,
								'dx_date' => $excel_metastasis_data['dx_date'],
								'dx_date_accuracy' => $excel_metastasis_data['dx_date_accuracy']),
							$atim_controls['diagnosis_controls']['secondary - distant-other']['detail_tablename'] => array(
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
						if(!array_key_exists($atim_participant_id, $atim_bcrs) || !array_key_exists($excel_bcr_data['dx_date'], $atim_bcrs[$atim_participant_id])) {
							$bcr_data = array(
								'diagnosis_masters' => array(
									'participant_id' => $atim_participant_id,
									'diagnosis_control_id' => $atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['id'],
									'primary_id' => $diagnosis_master_id,
									'parent_id' => $diagnosis_master_id,
									'dx_date' => $excel_bcr_data['dx_date'],
									'dx_date_accuracy' => $excel_bcr_data['dx_date_accuracy']),
								$atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['detail_tablename'] => array(
									'type' => $excel_bcr_data['type']));
							customInsertRecord($bcr_data);
							addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Created BCR', $excel_bcr_data);
						} else if($atim_bcrs[$atim_participant_id][$excel_bcr_data['dx_date']] != $excel_bcr_data['type'] ) {
							recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Types Of BCR does not match", "Types of BCR does not match on '".$excel_bcr_data['dx_date']."'. See following values: ATiM '".$atim_bcrs[$atim_participant_id][$excel_bcr_data['dx_date']]."' & Excel '".$excel_bcr_data['type']."'. Data won't be updated. $summary_details_add_in");
						}
					} else if($excel_bcr_data['type']) {
						recordErrorAndMessage($summary_section_title, '@@ERROR@@', "BCR date missing", "The date of the '".$excel_bcr_data['type']."' BCR is missing. New BCR won't be created. Plase review data. $summary_details_add_in");
					}
				} else {
					recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Missing prostate primary diagnosis", "No prostate primary diagnosis was defined into ATiM. Diagnosis, bcr and secondaries won't be parsed. $summary_details_add_in");
				}
			} else {
				recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Bank patient un-parsed", "The patient was not defined into 'Patient' worksheet. Patient data won't be parsed. $summary_details_add_in");
			}
			if(strlen($excel_line_data['notes'])) {
			    recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Diagnosis Note exists but won't be mirgated", "See note [".$excel_line_data['notes']."]. $summary_details_add_in");
			}
		} else {
			recordErrorAndMessage($summary_section_title, '@@ERROR@@', "'Patient # in biobank' column missing", "'Patient # in biobank' column is missing into worksheet '$worksheet_name'. No data will be parsed.");
		}
	}
	unset($atim_bcrs);
	unset($atim_secondary_diagnosis);
	
	// ******* Event/Treatment Data Update *******
	
	$worksheet_name = 'event';
	$summary_section_title = "Worksheet '$worksheet_name'";
	
	$atim_psa = array();
	$atim_radiotherapies = array();
	$atim_therapies_with_drugs = array();
	
	$query = "SELECT em.participant_id,
		em.event_date, 
		em.event_date_accuracy,
		ed.psa_ng_per_ml
		FROM event_masters em
		INNER JOIN ".$atim_controls['event_controls']['psa']['detail_tablename']." ed ON ed.event_master_id = em.id
		WHERE em.deleted <> 1 AND em.event_control_id = ".$atim_controls['event_controls']['psa']['id']." AND em.participant_id IN (".implode(',', $bank_participant_identifier_to_participant_id).");";
	foreach(getSelectQueryResult($query) as $new_record) $atim_psa[$new_record['participant_id']][$new_record['event_date']] = $new_record['psa_ng_per_ml'];
	$query = "SELECT tm.participant_id,
		tm.start_date,
		tm.start_date_accuracy,
		tm.finish_date,
		tm.finish_date_accuracy,
		td.qc_tf_dose_cg,
		td.qc_tf_type
		FROM treatment_masters tm 
		INNER JOIN ".$atim_controls['treatment_controls']['radiation']['detail_tablename']." td ON tm.id = td.treatment_master_id
		WHERE tm.deleted <> 1 AND tm.treatment_control_id  = ".$atim_controls['treatment_controls']['radiation']['id']." AND tm.participant_id IN (".implode(',', $bank_participant_identifier_to_participant_id).");";
	foreach(getSelectQueryResult($query) as $new_record) $atim_radiotherapies[$new_record['participant_id']][$new_record['start_date']] = $new_record;
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
			LEFT JOIN drugs dr ON dr.id = tem.drug_id AND dr.deleted <> 1
			WHERE tm.deleted <> 1 AND tm.treatment_control_id  = ".$atim_controls['treatment_controls'][$tx_method]['id']." AND tm.participant_id IN (".implode(',', $bank_participant_identifier_to_participant_id).");";
		if($tx_method == 'hormonotherapy') {
		    $query = str_replace('tm.finish_date_accuracy', 'tm.finish_date_accuracy, td.type', $query);
		}
		foreach(getSelectQueryResult($query) as $new_record) {
			if(!isset($atim_therapies_with_drugs[$tx_method][$new_record['participant_id']][$new_record['start_date']][$new_record['treatment_master_id']])) {
				$new_record['drugs'] = array();
				if($new_record['generic_name']) $new_record['drugs'][$new_record['generic_name']] = $new_record['generic_name'];
				unset($new_record['generic_name']);
				$atim_therapies_with_drugs[$tx_method][$new_record['participant_id']][$new_record['start_date']][$new_record['treatment_master_id']] = $new_record;
			} else {
				if($new_record['generic_name']) $atim_therapies_with_drugs[$tx_method][$new_record['participant_id']][$new_record['start_date']][$new_record['treatment_master_id']]['drugs'][$new_record['generic_name']] = $new_record['generic_name'];
			}
		}
	}
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2, $excel_xls_offset)) {
		if(isset($excel_line_data['Patient # in biobank'])) {
			$summary_details_add_in = "Patient '".$excel_line_data['Patient # in biobank']."' / bank '$file_bank_name' / line '$line_number' / file '$excel_file_name'";
			if(isset($bank_participant_identifier_to_participant_id[$excel_line_data['Patient # in biobank']])) {				
				$atim_participant_id = $bank_participant_identifier_to_participant_id[$excel_line_data['Patient # in biobank']];
				if(isset($atim_prostate_primary_diagnosis_data[$atim_participant_id])) {
					$diagnosis_master_id = $atim_prostate_primary_diagnosis_data[$atim_participant_id]['id'];
					$nbr_of_defined_treatement_types_on_row = 0;
					//0-Get Event Dates
					$excel_event_dates = array();
					$excel_field = "Dates of event Date of event (beginning)";
					list($excel_event_dates['start_date'], $excel_event_dates['start_date_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					$excel_event_dates['start_date_accuracy'] = updateWithExcelAccuracy($excel_event_dates['start_date_accuracy'], $excel_line_data["Dates of event Accuracy (beginning)"]);
					$excel_field = "Dates of event Date of event (end)";
					list($excel_event_dates['finish_date'], $excel_event_dates['finish_date_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					$excel_event_dates['finish_date_accuracy'] = updateWithExcelAccuracy($excel_event_dates['finish_date_accuracy'], $excel_line_data["Dates of event Accuracy (end)"]);
					if(!strlen($excel_event_dates['start_date'])) {
					    unset($excel_event_dates['start_date']);
					}
					if(!strlen($excel_event_dates['finish_date'])) {
					    unset($excel_event_dates['finish_date']);
					}
					$notes = $excel_line_data['Note'];
					//1-PSA Update
					$excel_field = "PSA (ng/ml)";
					$excel_psa = validateAndGetDecimal($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					if(strlen($excel_psa)) {
						$nbr_of_defined_treatement_types_on_row++;
						if(isset($excel_event_dates['start_date']) && isset($atim_psa[$atim_participant_id][$excel_event_dates['start_date']])) {
							if($atim_psa[$atim_participant_id][$excel_event_dates['start_date']] != $excel_psa) {
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "PSA values don't match", "See PSA values on '".$excel_event_dates['start_date']."': ATiM value [".$atim_psa[$atim_participant_id][$excel_event_dates['start_date']]."] != Excel value [$excel_psa] . Data won't be updated. $summary_details_add_in");	
							}
							if(strlen($notes)) {
							    recordErrorAndMessage($summary_section_title, '@@WARNING@@', "PSA already defined into ATiM but new notes exist into Excel. These notes won't be migrated. To migrate manually", "See PSA notes [$notes] on '".$excel_event_dates['start_date']."'. Data won't be updated. $summary_details_add_in");
							}
						} else {
							$event_dates = array('event_date' => (isset($excel_event_dates['start_date'])? $excel_event_dates['start_date'] : ''), 'event_date_accuracy' => $excel_event_dates['start_date_accuracy']);
							if(!$event_dates['event_date']) {
							    $event_dates = array();
							}							
							$psa_data = array(
								'event_masters' => array_merge(
									array('participant_id' => $atim_participant_id,
										'diagnosis_master_id' => $diagnosis_master_id,
										'event_control_id' => $atim_controls['event_controls']['psa']['id'],
									    'event_summary' => $notes
									),
									$event_dates),
								 $atim_controls['event_controls']['psa']['detail_tablename'] => array(
									'psa_ng_per_ml' => $excel_psa));
							customInsertRecord($psa_data);
							addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Created PSA', array_merge($event_dates, array('psa_ng_per_ml' => $excel_psa), (strlen($notes)? array('event_summary' => $notes) : array())));
						}
					}
					//2-Radiotherapy
					$excel_field = "Radiotherapy";
					$qc_tf_type = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qc_tf_radiotherapy_type', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					$excel_field = "radiotherapy dose cGy";
					$qc_tf_dose_cg = validateAndGetInteger($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
					if(strlen($qc_tf_type) || strlen($qc_tf_dose_cg)) {
						$nbr_of_defined_treatement_types_on_row++;
						if(isset($atim_radiotherapies[$atim_participant_id][$excel_event_dates['start_date']])) {
							//Just add a note if data does not match
							$data_that_could_be_updated = getDataToUpdate($atim_radiotherapies[$atim_participant_id][$excel_event_dates['start_date']], array_merge($excel_event_dates, array('qc_tf_type' => $qc_tf_type, 'qc_tf_dose_cg' => $qc_tf_dose_cg)));
							if($data_that_could_be_updated) {
								$diff_strg = array();
								foreach($data_that_could_be_updated as $field => $excel_value) $diff_strg[] = "$field : '".$atim_radiotherapies[$atim_participant_id][$excel_event_dates['start_date']][$field]."'(ATiM) != '$excel_value'(Excel)";
								$diff_strg = implode (' & ', $diff_strg);
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Radiation value(s) does not match", "Radiation value(s) on '".$excel_event_dates['start_date']."' does not match ($diff_strg). Data won't be updated. Please check and update if required. $summary_details_add_in");
							}
							if(strlen($notes)) {
							    recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Radiation already defined into ATiM but new notes exist into Excel. These notes won't be migrated. To migrate manually", "See Radiation notes [$notes] on '".$excel_event_dates['start_date']."'. Data won't be updated. $summary_details_add_in");
							}
						} else {
							$tx_data = array(
								'treatment_masters' => array_merge(
									array('participant_id' => $atim_participant_id, 
										'diagnosis_master_id' => $diagnosis_master_id, 
										'treatment_control_id' => $atim_controls['treatment_controls']['radiation']['id'],
									    'notes' => $notes
									), 
									$excel_event_dates),
								$atim_controls['treatment_controls']['radiation']['detail_tablename'] => (strlen($qc_tf_dose_cg)?
								    array('qc_tf_type' => $qc_tf_type, 'qc_tf_dose_cg' => $qc_tf_dose_cg) :
    								array('qc_tf_type' => $qc_tf_type)));
							customInsertRecord($tx_data);
							addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], 'Created radiotherpay', array_merge($excel_event_dates, $tx_data[$atim_controls['treatment_controls']['radiation']['detail_tablename']], (strlen($notes)? array('notes' => $notes) : array())));
						}
					}	
					//3-Treatment Linked To Drugs
					$excel_drug_list = array();
					$treatment_with_drug_detected = false;
					for($i = 1; $i < 5; $i ++) {
						$key = 'treatment Precision drug '.$i;
						if(!in_array($excel_line_data[$key], array('', 'no', 'unknown'))){
							$excel_drug_list['Drug-'.$i] = $excel_line_data[$key];
						}
					}
					foreach(array(array('hormonotherapy', 'hormonotherapy', 'hormonal'), array('chemiotherapy', 'chemotherapy', 'chemotherapy'), array('Other treatments', 'other treatment', '?')) as $new_treatment_data) {
						list($excel_field, $atim_treatment_type, $drug_type) = $new_treatment_data;
						$excel_line_data[$excel_field] = str_replace(array('no', 'unknown') , array('', ''), strtolower($excel_line_data[$excel_field]));
						if($atim_treatment_type == 'other treatment') {
							switch($excel_line_data[$excel_field]) {
								case 'bone specific':
									$atim_treatment_type = 'other treatment bone specific';
									$drug_type = 'bone';
									$excel_line_data[$excel_field] = 'yes';
									break;
								case 'hr specific':
									$atim_treatment_type = 'other treatment HR specific';
									$drug_type = 'HR';
									$excel_line_data[$excel_field] = 'yes';
									break;
								case 'yes':
									recordErrorAndMessage($summary_section_title, '@@ERROR@@', "The $excel_field value not supported", "See value [".$excel_line_data[$excel_field]."]. Treatment won't be parsed. $summary_details_add_in");
									$excel_line_data[$excel_field] = '';
									break;
							}
						}
						$hormonotherapy_type = null;
						if($atim_treatment_type == 'hormonotherapy' && strlen($excel_line_data[$excel_field]) && $excel_line_data[$excel_field] != 'yes') {
						    $hormonotherapy_type = validateAndGetStructureDomainValue($excel_line_data[$excel_field], 'qc_tf_cpcbn_hormonotherapy_type', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
						    $excel_line_data[$excel_field] = 'yes';
						}
						if($excel_line_data[$excel_field] == 'yes') {
							$nbr_of_defined_treatement_types_on_row++;
							$treatment_with_drug_detected = true;
							if(isset($excel_event_dates['start_date']) && isset($atim_therapies_with_drugs[$atim_treatment_type][$atim_participant_id][$excel_event_dates['start_date']])) {
								if(sizeof(isset($atim_therapies_with_drugs[$atim_treatment_type][$atim_participant_id][$excel_event_dates['start_date']])) > 1) {
									recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Too many $atim_treatment_type on same date", "More than one $atim_treatment_type exists into ATiM on '".$excel_event_dates['start_date']."' for the patient. Migration process won't be able to select the good one. The $atim_treatment_type data won't be updated. Please process manually after migration. $summary_details_add_in");
								} else {
									$matching_atim_treatment = current($atim_therapies_with_drugs[$atim_treatment_type][$atim_participant_id][$excel_event_dates['start_date']]);
									$updated_tx_data = array();
									//Compare finish dates
									if(isset($excel_event_dates['finish_date']) && $excel_event_dates['finish_date']) {
										if(!$matching_atim_treatment['finish_date']) {
											//Finish date was not set into ATiM
											$updated_tx_data = array('finish_date' => $excel_event_dates['finish_date'], 'finish_date_accuracy' => $excel_event_dates['finish_date_accuracy']);
											updateTableData($matching_atim_treatment['treatment_master_id'], array('treatment_masters' => $updated_tx_data));
										} else if($matching_atim_treatment['finish_date'] != $excel_event_dates['finish_date']) {
											recordErrorAndMessage($summary_section_title, '@@ERROR@@', "The $atim_treatment_type Finish dates does not match", "The finish dates of the $atim_treatment_type started on '".$excel_event_dates['start_date']."' are different ('".$matching_atim_treatment['finish_date']."'(ATiM) != '".$excel_event_dates['finish_date']."'(Excel)). Migration process won't be able to select the good one. Date won't be updated. $summary_details_add_in");
										}
									}
									if($hormonotherapy_type) {
									    if(!$matching_atim_treatment['type']) {
									        //type not set into ATiM
									        $updated_tx_data['type'] = $hormonotherapy_type;
									        updateTableData($matching_atim_treatment['treatment_master_id'], array(
                                                'treatment_masters' => array(), 
                                                $atim_controls['treatment_controls'][$atim_treatment_type]['detail_tablename'] => array('type' => $hormonotherapy_type)));
									    } else if($matching_atim_treatment['type'] != $hormonotherapy_type) {
									        recordErrorAndMessage($summary_section_title, '@@ERROR@@', "The $atim_treatment_type Types does not match", "The types of the $atim_treatment_type started on '".$excel_event_dates['start_date']."' are different ('".$matching_atim_treatment['type']."'(ATiM) != '$hormonotherapy_type'(Excel)). Migration process won't be able to select the good one. Date won't be updated. $summary_details_add_in");
									    }
									}
									//Compare drugs
									$formated_excel_drugs_list = array();
									foreach($excel_drug_list as $new_drug) $formated_excel_drugs_list[strtolower($new_drug)] = strtolower($new_drug);
									$formated_atim_drugs_list = array();
									foreach($matching_atim_treatment['drugs'] as $new_drug) $formated_atim_drugs_list[strtolower($new_drug)] = strtolower($new_drug);
									$drugs_only_listed_into_atim = array();;
									$created_drug_counter_for_display = 0;
									foreach(array_merge($formated_excel_drugs_list, $formated_atim_drugs_list) as $drug_name) {
										if(in_array($drug_name, $formated_excel_drugs_list) && in_array($drug_name, $formated_atim_drugs_list)) {
											//Both in excel and ATiM: nothing to update or create
										} else if(in_array($drug_name, $formated_excel_drugs_list)) {
											//Drug into excel (only)
											$drug_id = getDrugId($drug_name, $drug_type);
											if($drug_id) {
												$created_drug_counter_for_display++;
												$tx_ext_data = array(
													'treatment_extend_masters' => array(
														'treatment_master_id' => $matching_atim_treatment['treatment_master_id'],
														'treatment_extend_control_id' => $atim_controls['treatment_controls'][$atim_treatment_type]['treatment_extend_control_id'],
                                                        'drug_id' => $drug_id),
													$atim_controls['treatment_controls'][$atim_treatment_type]['treatment_extend_detail_tablename'] => array());
												customInsertRecord($tx_ext_data);
												$updated_tx_data['drug_creation_#'.$created_drug_counter_for_display] = $drug_name;
											}
										} else {
											//Drug Only into ATiM
											$drugs_only_listed_into_atim[] = $drug_name;
										}
									}
									if($drugs_only_listed_into_atim) {
										recordErrorAndMessage($summary_section_title, '@@WARNING@@', "One ro many $atim_treatment_type drugs are only listed into ATiM", "Following drugs [".implode(' & ', $drugs_only_listed_into_atim)."] of treatment strated on '".$excel_event_dates['start_date']."' are only defined into ATiM and don't match a drug listed into the excel file row. No ATiM drug will be erased. Plases confirm and correct if required. $summary_details_add_in");
									}
									if($updated_tx_data) {
										addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], "Updated  $atim_treatment_type started on ".$excel_event_dates['start_date'], $updated_tx_data);
									}
								}
								if(strlen($notes)) {
								    recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Treatment $atim_treatment_type already defined into ATiM but new notes exist into Excel. These notes won't be migrated. To migrate manually", "See treatment notes [$notes] on '".$excel_event_dates['start_date']."'. Data won't be updated. $summary_details_add_in");
								}
							} else {
								//TreatmentMaster
								$td_detail_data = (is_null($hormonotherapy_type) || !strlen($hormonotherapy_type))? array() : array('type' => $hormonotherapy_type);
								$tx_data = array(
									'treatment_masters' => array_merge(
										array('participant_id' => $atim_participant_id, 
											'diagnosis_master_id' => $diagnosis_master_id, 
											'treatment_control_id' => $atim_controls['treatment_controls'][$atim_treatment_type]['id'],
										    'notes' => $notes
										),
										$excel_event_dates),
									$atim_controls['treatment_controls'][$atim_treatment_type]['detail_tablename'] =>$td_detail_data);
								$treatment_master_id = customInsertRecord($tx_data);
								if($excel_drug_list) {
									//TreatmentExtendMaster
									foreach($excel_drug_list as $new_drug) {
										$drug_id = getDrugId($new_drug, $drug_type);
										if($drug_id) {
											$tx_ext_data = array(
												'treatment_extend_masters' => array(
													'treatment_master_id' => $treatment_master_id, 
													'treatment_extend_control_id' => $atim_controls['treatment_controls'][$atim_treatment_type]['treatment_extend_control_id'],
													'drug_id' => $drug_id),
												$atim_controls['treatment_controls'][$atim_treatment_type]['treatment_extend_detail_tablename'] => array());
											customInsertRecord($tx_ext_data);
										}
									}
								}
								addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in biobank'], "Created $atim_treatment_type", array_merge($excel_event_dates, $excel_drug_list, (strlen($notes)? array('notes' => $notes) : array())));
							}
						} else if(strlen($excel_line_data[$excel_field])) {
							recordErrorAndMessage($summary_section_title, '@@ERROR@@', "The $excel_field value not supported", "See value [".$excel_line_data[$excel_field]."]. Treatment won't be parsed. $summary_details_add_in");
						}			
					}
					if(!$treatment_with_drug_detected && !empty($excel_drug_list)) {
						recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Drugs list but no treatment defined", "A drugs list is defined but no treatment to link to this one has been detected into the excel row. No drug will be migrated or updated. $summary_details_add_in");
					}
					//Check only one treatment/event per row is defined
					if($nbr_of_defined_treatement_types_on_row > 1) {
						recordErrorAndMessage($summary_section_title, '@@WARNING@@', "More than one treatment or event is defined on the same row", "Please review migrated/updated data and validate. $summary_details_add_in");
					}
				} else {
					recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Missing prostate primary diagnosis", "No prostate primary diagnosis was defined into ATiM. Event data won't be parsed. $summary_details_add_in");	
				}
			} else {
				recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Bank patient un-parsed", "The patient was not defined into 'Patient' worksheet. Event data won't be parsed. $summary_details_add_in");
			}
		} else {
			recordErrorAndMessage($summary_section_title, '@@ERROR@@', "'Patient # in biobank' column missing", "'Patient # in biobank' column is missing into worksheet '$worksheet_name'. No data will be parsed.");
		}
	}
	unset($atim_prostate_primary_diagnosis_data);
	unset($atim_psa);
	unset($atim_radiotherapies);
	unset($atim_therapies_with_drugs);

	// ******* Secondary Data Update *******
	
	$worksheet_name = 'other cancer';
	$summary_section_title = "Worksheet '$worksheet_name'";
	
	$atim_other_primary_diagnosis_data = array('sorted_by_dates_and_sites' => array(), 'sorted_by_dates' => array(), 'sorted_by_sites' => array(), 'unknown_diagnosis' => array());
	
	$query = "SELECT other_dx.participant_id,
		other_dx.id AS diagnosis_master_id,
		other_dx.dx_date,
		other_dx.dx_date_accuracy,
		other_dxd.type
		FROM diagnosis_masters other_dx
		INNER JOIN ".$atim_controls['diagnosis_controls']['primary-other']['detail_tablename']." AS other_dxd ON other_dxd.diagnosis_master_id = other_dx.id
		WHERE other_dx.deleted <> 1 AND other_dx.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['primary-other']['id']." AND other_dx.participant_id IN (".implode(',', $bank_participant_identifier_to_participant_id).");";
	foreach(getSelectQueryResult($query) as $new_record) {
		$atim_other_primary_diagnosis_data['sorted_by_dates_and_sites'][$new_record['participant_id']][$new_record['dx_date'].'|'.$new_record['type']][] = $new_record;
		$atim_other_primary_diagnosis_data['sorted_by_dates'][$new_record['participant_id']][$new_record['dx_date']][] = $new_record;
		$atim_other_primary_diagnosis_data['sorted_by_sites'][$new_record['participant_id']][$new_record['type']][] = $new_record;
	}
	$query = "SELECT unknown_dx.participant_id,
		unknown_dx.id AS diagnosis_master_id,
		unknown_dx.dx_date,
		unknown_dx.dx_date_accuracy
		FROM diagnosis_masters unknown_dx
		WHERE unknown_dx.deleted <> 1 AND unknown_dx.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['primary-primary diagnosis unknown']['id']." AND unknown_dx.participant_id IN (".implode(',', $bank_participant_identifier_to_participant_id).");";
	foreach(getSelectQueryResult($query) as $new_record) $atim_other_primary_diagnosis_data['unknown_diagnosis'][$new_record['participant_id']][$new_record['dx_date']][] = $new_record;
	
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2, $excel_xls_offset)) {
		if(isset($excel_line_data['Patient # in Biobank Number (required)'])) {
			$summary_details_add_in = "Patient '".$excel_line_data['Patient # in Biobank Number (required)']."' / bank '$file_bank_name' / line '$line_number' / file '$excel_file_name'";
			if(isset($bank_participant_identifier_to_participant_id[$excel_line_data['Patient # in Biobank Number (required)']])) {
				$atim_participant_id = $bank_participant_identifier_to_participant_id[$excel_line_data['Patient # in Biobank Number (required)']];
				$excel_diagnosis_data = array();
				$excel_field = "Date of diagnostics Date";
				list($excel_diagnosis_data['dx_date'], $excel_diagnosis_data['dx_date_accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				$excel_diagnosis_data['dx_date_accuracy'] = updateWithExcelAccuracy($excel_diagnosis_data['dx_date_accuracy'], $excel_line_data["Date of diagnostics Accuracy"]);
				$excel_field = "cancer type";
				$excel_diagnosis_data['type'] = validateAndGetStructureDomainValue(str_replace('non - hodgkin', 'non-hodgkin', strtolower(str_replace('-',' - ', $excel_line_data[$excel_field]))), 'ctrnet_submission_disease_site', $summary_section_title, "$worksheet_name::$excel_field", $summary_details_add_in);
				if($excel_diagnosis_data['type'] == 'prostate') die("ERR_PROSTATE_OTHER_DIAGNOSIS: ".$summary_details_add_in);
				$notes = $excel_line_data['Note'];
				if($excel_diagnosis_data['type'] || $excel_diagnosis_data['dx_date']) {
					if($excel_diagnosis_data['type'] == 'other - primary unknown') {
						//1--Unknown diagnosis
						if(!isset($atim_other_primary_diagnosis_data['unknown_diagnosis'][$atim_participant_id][$excel_diagnosis_data['dx_date']])) {
							if(isset($atim_other_primary_diagnosis_data['unknown_diagnosis'][$atim_participant_id])) {
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "An unknown primary diagnosis already exists", "No new one will be created. Please review migrated/updated data, validate and create the new one if required. $summary_details_add_in");
								if(strlen($notes)) recordErrorAndMessage($summary_section_title, '@@WARNING@@', "An unknown primary diagnosis already exists and a note in excel has been found. The note won't be migrated. Please add note manually.", "Note [$notes] won't be migrated. $summary_details_add_in");
							} else {
								$unknown_dx = array(
									'diagnosis_masters' => array(
										'participant_id' => $atim_participant_id,
										'diagnosis_control_id' => $atim_controls['diagnosis_controls']['primary-primary diagnosis unknown']['id'],
										'dx_date' => $excel_diagnosis_data['dx_date'],
										'dx_date_accuracy' => $excel_diagnosis_data['dx_date_accuracy'],
									   'notes' => $notes),
									$atim_controls['diagnosis_controls']['primary-primary diagnosis unknown']['detail_tablename'] => array());
								customInsertRecord($unknown_dx);
								if(strlen($notes)) $excel_diagnosis_data['notes'] = $notes;
								addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in Biobank Number (required)'], 'Created unknown primary diagnosis', $excel_diagnosis_data);
							}
						}
					} else {
						//2--Other Primary
						if(!isset($atim_other_primary_diagnosis_data['sorted_by_dates_and_sites'][$atim_participant_id][$excel_diagnosis_data['dx_date'].'|'.$excel_diagnosis_data['type']])) {
							if(isset($atim_other_primary_diagnosis_data['sorted_by_dates'][$atim_participant_id][$excel_diagnosis_data['dx_date']])) {
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "An other primary diagnosis already exists on the same date", "No ".(empty($excel_diagnosis_data['type'])? "new other primary diagnosis" : "new '".$excel_diagnosis_data['type']."' other primary diagnosis")." will be created ".(empty($excel_diagnosis_data['dx_date'])? "" : "on '".$excel_diagnosis_data['dx_date']."'").". Please review migrated/updated data, validate and create the new one if required. $summary_details_add_in");
							     if(strlen($notes)) recordErrorAndMessage($summary_section_title, '@@WARNING@@', "An unknown primary diagnosis already exists and a note in excel has been found. The note won't be migrated. Please add note manually.", "Note [$notes] won't be migrated. $summary_details_add_in");
							} else if(isset($atim_other_primary_diagnosis_data['sorted_by_sites'][$atim_participant_id][$excel_diagnosis_data['type']])) {
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "An other primary diagnosis already exists for the same site", "No new '".$excel_diagnosis_data['type']."' other primary diagnosis will be created ".(empty($excel_diagnosis_data['dx_date'])? "" : "on '".$excel_diagnosis_data['dx_date']."'").". Please review migrated/updated data, validate and create the new one if required. $summary_details_add_in");
							     if(strlen($notes)) recordErrorAndMessage($summary_section_title, '@@WARNING@@', "An unknown primary diagnosis already exists and a note in excel has been found. The note won't be migrated. Please add note manually.", "Note [$notes] won't be migrated. $summary_details_add_in");
							} else if(isset($atim_other_primary_diagnosis_data['unknown_diagnosis'][$atim_participant_id][$excel_diagnosis_data['dx_date']])) {
								recordErrorAndMessage($summary_section_title, '@@WARNING@@', "An unknown primary diagnosis exists on the same date of a new other primary", "No ".(empty($excel_diagnosis_data['type'])? "new other primary diagnosis" : "new '".$excel_diagnosis_data['type']."' other primary diagnosis")." will be created ".(empty($excel_diagnosis_data['dx_date'])? "" : "on '".$excel_diagnosis_data['dx_date']."'").". Please review migrated/updated data, validate and create the new one or change the unknown diagnosis to other diagnosis if required. $summary_details_add_in");
							     if(strlen($notes)) recordErrorAndMessage($summary_section_title, '@@WARNING@@', "An unknown primary diagnosis already exists and a note in excel has been found. The note won't be migrated. Please add note manually.", "Note [$notes] won't be migrated. $summary_details_add_in");
							} else {
								$other_primary_dx = array(
									'diagnosis_masters' => array(
										'participant_id' => $atim_participant_id,
										'diagnosis_control_id' => $atim_controls['diagnosis_controls']['primary-other']['id'],
										'dx_date' => $excel_diagnosis_data['dx_date'],
										'dx_date_accuracy' => $excel_diagnosis_data['dx_date_accuracy'],
									   'notes' => $notes),
									$atim_controls['diagnosis_controls']['primary-other']['detail_tablename'] => array(
										'type' => $excel_diagnosis_data['type']));
								customInsertRecord($other_primary_dx);
								if(strlen($notes)) $excel_diagnosis_data['notes'] = $notes;
								addUpdatedDataToSummary($file_bank_name, $excel_line_data['Patient # in Biobank Number (required)'], 'Created other primary diagnosis', $excel_diagnosis_data);
							}
						} 
					}
				}				
			} else {
				recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Bank patient un-parsed", "The patient was not defined into 'Patient' worksheet. Event data won't be parsed. $summary_details_add_in");
			}
		} else {
			recordErrorAndMessage($summary_section_title, '@@ERROR@@', "'Patient # in Biobank Number (required)' column missing", "'Patient # in Biobank Number (required)' column is missing into worksheet '$worksheet_name'. No data will be parsed.");
		}
	}
	
	// End of excel file reading
}

//*** END PROCESS ***

executeEndProcessSourceCode();
insertIntoRevsBasedOnModifiedValues();

//Review dates in case we created a new secondary, BCR, psa, etc at the same date (or close) to an existing one because dates were inaccurate
$summary_section_title = 'Duplicated diagnosis, events and treatment detection at the end of the process for review (on all patients)';
//1-Secondary Diagnosis
$query = "SELECT res.participant_id, p.qc_tf_bank_participant_identifier, b.name AS bank_name, 'secondary diagnosis', date_year, site
	FROM (
		SELECT count(*) AS nbr_of_records, participant_id, diagnosis_control_id, DATE_FORMAT(dx_date,'%Y') as date_year, site
		FROM diagnosis_masters 
		INNER JOIN ".$atim_controls['diagnosis_controls']['secondary - distant-other']['detail_tablename']." ON id = diagnosis_master_id
		WHERE deleted <> 1 AND diagnosis_control_id = ".$atim_controls['diagnosis_controls']['secondary - distant-other']['id']."
		GROUP BY participant_id, diagnosis_control_id, DATE_FORMAT(dx_date,'%Y'), site
	) AS res
	INNER JOIN participants p ON p.id = res.participant_id
	LEFT JOIN banks b ON p.qc_tf_bank_id = b.id
	WHERE res.nbr_of_records > 1 AND p.deleted <> 1
	ORDER BY res.participant_id, res.date_year;";
foreach(getSelectQueryResult($query) as $new_data) {
	recordErrorAndMessage($summary_section_title, '@@WARNING@@', "More than one secondary diagnosis in the same year", "Review secondary diagnosis on '".$new_data['date_year']." for patient '".$new_data['qc_tf_bank_participant_identifier']."' of bank '".$new_data['bank_name'].". (ATiM Participant # '".$new_data['participant_id']."')");
}

//Other or unknown diagnosis

$query = "SELECT res.participant_id, p.qc_tf_bank_participant_identifier, b.name AS bank_name, 'other or unknown diagosis', date_year
	FROM (
		SELECT count(*) AS nbr_of_records, participant_id, diagnosis_control_id, DATE_FORMAT(dx_date,'%Y') as date_year
		FROM diagnosis_masters
		WHERE deleted <> 1 AND diagnosis_control_id IN (".$atim_controls['diagnosis_controls']['primary-other']['id'].",".$atim_controls['diagnosis_controls']['primary-primary diagnosis unknown']['id'].")
		GROUP BY participant_id, diagnosis_control_id, DATE_FORMAT(dx_date,'%Y')
	) AS res
	INNER JOIN participants p ON p.id = res.participant_id
	LEFT JOIN banks b ON p.qc_tf_bank_id = b.id
	WHERE res.nbr_of_records > 1 AND p.deleted <> 1
	ORDER BY res.participant_id, res.date_year;";
foreach(getSelectQueryResult($query) as $new_data) {
	recordErrorAndMessage($summary_section_title, '@@WARNING@@', "More than one other or unknown primary diagnosis in the same year", "Review the other or unknown primary diagnosis on '".$new_data['date_year']." for patient '".$new_data['qc_tf_bank_participant_identifier']."' of bank '".$new_data['bank_name'].". (ATiM Participant # '".$new_data['participant_id']."')");
}

// BCR

$query = "SELECT res.participant_id, p.qc_tf_bank_participant_identifier, b.name AS bank_name, 'bcr', date_year
	FROM (
		SELECT count(*) AS nbr_of_records, participant_id, diagnosis_control_id, DATE_FORMAT(dx_date,'%Y') as date_year
		FROM diagnosis_masters
		WHERE deleted <> 1 AND diagnosis_control_id = ".$atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['id']."
		GROUP BY participant_id, diagnosis_control_id, DATE_FORMAT(dx_date,'%Y')
	) AS res
	INNER JOIN participants p ON p.id = res.participant_id
	LEFT JOIN banks b ON p.qc_tf_bank_id = b.id
	WHERE res.nbr_of_records > 1 AND p.deleted <> 1
	ORDER BY res.participant_id, res.date_year;";
foreach(getSelectQueryResult($query) as $new_data) {
	recordErrorAndMessage($summary_section_title, '@@WARNING@@', "More than one BCR in the same year", "Review the BCR on '".$new_data['date_year']." for patient '".$new_data['qc_tf_bank_participant_identifier']."' of bank '".$new_data['bank_name'].". (ATiM Participant # '".$new_data['participant_id']."')");
}

//PSA

$query = "SELECT res.participant_id, p.qc_tf_bank_participant_identifier, b.name AS bank_name, 'psa', event_date
	FROM (
		SELECT count(*) AS nbr_of_records, participant_id, event_control_id, event_date
		FROM event_masters
		WHERE deleted <> 1 AND event_control_id = ".$atim_controls['event_controls']['psa']['id']."
		GROUP BY participant_id, event_control_id, event_date
	) AS res
	INNER JOIN participants p ON p.id = res.participant_id
	LEFT JOIN banks b ON p.qc_tf_bank_id = b.id
	WHERE res.nbr_of_records > 1 AND p.deleted <> 1
	ORDER BY res.participant_id, res.event_date;";
foreach(getSelectQueryResult($query) as $new_data) {
	recordErrorAndMessage($summary_section_title, '@@WARNING@@', "More than one PSA on the same date", "Review PSA on '".$new_data['event_date']." for patient '".$new_data['qc_tf_bank_participant_identifier']."' of bank '".$new_data['bank_name'].". (ATiM Participant # '".$new_data['participant_id']."')");
}

//Treatment
foreach(array('radiation','hormonotherapy','chemotherapy','other treatment bone specific','other treatment HR specific') AS $tx_method) {
	$query = "SELECT res.participant_id, p.qc_tf_bank_participant_identifier, b.name AS bank_name, date_year, '$tx_method' AS tx_method
		FROM (
			SELECT count(*) AS nbr_of_records, participant_id, treatment_control_id, DATE_FORMAT(start_date,'%M %Y') as date_year
			FROM treatment_masters
			WHERE deleted <> 1 AND treatment_control_id = ".$atim_controls['treatment_controls'][$tx_method]['id']."
			GROUP BY participant_id, treatment_control_id, DATE_FORMAT(start_date, '%M %Y')
		) AS res
		INNER JOIN participants p ON p.id = res.participant_id
		LEFT JOIN banks b ON p.qc_tf_bank_id = b.id
		WHERE res.nbr_of_records > 1 AND p.deleted <> 1
		ORDER BY res.participant_id, res.date_year;";
	foreach(getSelectQueryResult($query) as $new_data) {
		recordErrorAndMessage($summary_section_title, '@@WARNING@@', "More than one treatment '$tx_method' on the same month", "Review '$tx_method' on '".$new_data['date_year']." for patient '".$new_data['qc_tf_bank_participant_identifier']."' of bank '".$new_data['bank_name'].". (ATiM Participant # '".$new_data['participant_id']."')");
	}
}

// Look for all 'hormonotherapy', 'radiation', 'chemotherapy' done before DFS date (for all atim patients) 
$query = "SELECT tm_dfs.participant_id, part.qc_tf_bank_participant_identifier, b.name AS bank_name,
	tm_dfs.start_date AS dfs_start_date, tm_dfs.start_date_accuracy AS dfs_start_date_accuracy, tc_dfs.tx_method dfs_tx_method,
	tm_not_dfs.start_date AS unlabeled_tx_start_date, tm_not_dfs.start_date_accuracy AS unlabeled_tx_start_date_accuracy, tc_not_dfs.tx_method unlabeled_tx_tx_method
	FROM participants part
	LEFT JOIN banks b ON part.qc_tf_bank_id = b.id
	INNER JOIN treatment_masters tm_dfs ON part.id = tm_dfs.participant_id AND tm_dfs.deleted <> 1 AND tm_dfs.qc_tf_disease_free_survival_start_events = '1'
	INNER JOIN treatment_controls tc_dfs ON tc_dfs.id = tm_dfs.treatment_control_id AND tc_dfs.tx_method IN ('hormonotherapy', 'radiation', 'chemotherapy')
	INNER JOIN treatment_masters tm_not_dfs ON part.id = tm_not_dfs.participant_id AND tm_not_dfs.deleted <> 1 AND tm_not_dfs.qc_tf_disease_free_survival_start_events <> '1'
	INNER JOIN treatment_controls tc_not_dfs ON tc_not_dfs.id = tm_not_dfs.treatment_control_id AND tc_not_dfs.tx_method IN ('hormonotherapy', 'radiation', 'chemotherapy')
	WHERE tm_not_dfs.start_date < tm_dfs.start_date;";
foreach(getSelectQueryResult($query) as $new_data) {
	recordErrorAndMessage($summary_section_title, '@@WARNING@@', "'hormonotherapy', 'radiation', 'chemotherapy' done before the DFS", "Review '".$new_data['unlabeled_tx_tx_method']."' on '".$new_data['unlabeled_tx_start_date']."' not falgged as DFS Start and done before the DFS Start date ('".$new_data['dfs_tx_method']."' on '".$new_data['dfs_start_date']."') for patient '".$new_data['qc_tf_bank_participant_identifier']."' of bank '".$new_data['bank_name'].". (ATiM Participant # '".$new_data['participant_id']."')");
}

//*** SUMMARY DISPLAY ***

global $import_summary;

$update_summary = array();
if(isset($import_summary['Updated Data Summary'])) {
	$update_summary = array('Updated Data Summary' => $import_summary['Updated Data Summary']);
	unset($import_summary['Updated Data Summary']);
}

dislayErrorAndMessage(false, 'Migration Errors/Warnings/Messages');

$import_summary = $update_summary;

dislayErrorAndMessage($commitAll, 'Update Summary');

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
	recordErrorAndMessage('Drugs', '@@MESSAGE@@', "New ATiM Drug Creation", "$drug_name ($type)");

	return $atim_drugs[$drug_key];
}

function getDrugKey($drug_name, $type) {
	if(!in_array($type, array('', 'bone', 'HR', 'chemotherapy', 'hormonal'))) die('ERR 237 7263726 drug type'.$type);
	return strtolower($drug_name.'## ##'.$type);
}

function executeEndProcessSourceCode(){
	global $import_date;
	global $imported_by;
	global $atim_controls;
	
	$all_updated_participants_labels = array('-1' => '');
	$query = "SELECT p.id AS participant_id, b.name AS bank_name, p.qc_tf_bank_participant_identifier
		FROM (
			SELECT id AS participant_id FROM participants WHERE modified = '$import_date' AND modified_by = '$imported_by'
			UNION  
			SELECT participant_id FROM diagnosis_masters WHERE modified = '$import_date' AND modified_by = '$imported_by'
			UNION  
			SELECT participant_id FROM event_masters WHERE modified = '$import_date' AND modified_by = '$imported_by'
			UNION  
			SELECT participant_id FROM treatment_masters WHERE modified = '$import_date' AND modified_by = '$imported_by'
		) AS p2 
		INNER JOIN participants p ON p2.participant_id = p.id 
		LEFT JOIN banks b ON p.qc_tf_bank_id = b.id
		WHERE p.deleted <> 1";
	foreach(getSelectQueryResult($query) as $new_record) $all_updated_participants_labels[$new_record['participant_id']] = array(
		'qc_tf_bank_participant_identifier' => $new_record['qc_tf_bank_participant_identifier'],
		'bank' => $new_record['bank_name'],
		'label_for_summary' => $new_record['qc_tf_bank_participant_identifier'].' ('.$new_record['bank_name'].')');
	$all_updated_participant_ids_strg = implode(',',array_keys($all_updated_participants_labels));
	
	// ** Clean-up PARTICIPANTS **
	
	$queries = array(
		"UPDATE participants SET last_modification = NOW() WHERE id IN ($all_updated_participant_ids_strg);",
// 		"UPDATE participants SET date_of_birth = NULL WHERE date_of_birth LIKE '0000-00-00';",
// 		"UPDATE participants SET date_of_death = NULL WHERE date_of_death LIKE '0000-00-00';",
// 		"UPDATE participants SET qc_tf_suspected_date_of_death = NULL WHERE qc_tf_suspected_date_of_death LIKE '0000-00-00';",
// 		"UPDATE participants SET qc_tf_last_contact = NULL WHERE qc_tf_last_contact LIKE '0000-00-00';",
		"UPDATE participants SET date_of_birth_accuracy = 'c' WHERE date_of_birth IS NOT NULL AND date_of_birth_accuracy LIKE '';",
		"UPDATE participants SET date_of_death_accuracy = 'c' WHERE date_of_death IS NOT NULL AND date_of_death_accuracy LIKE '';",
		"UPDATE participants SET qc_tf_suspected_date_of_death_accuracy = 'c' WHERE qc_tf_suspected_date_of_death IS NOT NULL AND qc_tf_suspected_date_of_death_accuracy LIKE '';",
		"UPDATE participants SET qc_tf_last_contact_accuracy = 'c' WHERE qc_tf_last_contact IS NOT NULL AND qc_tf_last_contact_accuracy LIKE '';");
	foreach($queries as $query)	customQuery($query);

	//  ** Clean-up DIAGNOSIS_MASTERS **

	$queries = array(
		"UPDATE participants p, diagnosis_masters dx
			SET dx.age_at_dx = TIMESTAMPDIFF(YEAR,p.date_of_birth,dx.dx_date)
			WHERE p.deleted <> 1 AND dx.deleted <> 1 AND p.id = dx.participant_id
			AND dx.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['primary-other']['id']."
			AND p.id IN ($all_updated_participant_ids_strg)
			AND dx.modified = '$import_date' AND dx.modified_by = '$imported_by'",
//		"UPDATE diagnosis_masters SET dx_date = NULL WHERE dx_date LIKE '0000-00-00';",
		"UPDATE diagnosis_masters SET dx_date_accuracy = 'c' WHERE dx_date IS NOT NULL AND dx_date_accuracy LIKE '';",
		"UPDATE diagnosis_masters SET age_at_dx = NULL WHERE age_at_dx LIKE '0';",
		"UPDATE ".$atim_controls['diagnosis_controls']['primary-prostate']['detail_tablename']." dd, diagnosis_masters dm SET dd.hormonorefractory_status = 'not HR'
			WHERE dm.participant_id IN ($all_updated_participant_ids_strg) AND dm.id = dd.diagnosis_master_id AND (dd.hormonorefractory_status IS NULL OR dd.hormonorefractory_status = '');");
	foreach($queries as $query)	customQuery($query);

	//  ** Clean-up TREAMTENT_MASTERS **
	
	$queries = array(
//		"UPDATE treatment_masters SET start_date = NULL WHERE start_date LIKE '0000-00-00';",
		"UPDATE treatment_masters SET start_date_accuracy = 'c' WHERE start_date IS NOT NULL AND start_date_accuracy LIKE '';",
//		"UPDATE treatment_masters SET finish_date = NULL WHERE finish_date LIKE '0000-00-00';",
		"UPDATE treatment_masters SET finish_date_accuracy = 'c' WHERE finish_date IS NOT NULL AND finish_date_accuracy LIKE '';");
	foreach($queries as $query)	customQuery($query);

	//  ** Clean-up EVENT_MASTERS **
	
	$queries = array(
//		"UPDATE event_masters SET event_date = NULL WHERE event_date LIKE '0000-00-00';",
		"UPDATE event_masters SET event_date_accuracy = 'c' WHERE event_date IS NOT NULL AND event_date_accuracy LIKE '';",
		"UPDATE event_masters ev, diagnosis_masters rec
			SET ev.diagnosis_master_id = rec.id
			WHERE rec.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['id']."
			AND ev.event_control_id = ".$atim_controls['event_controls']['psa']['id']."
			AND ev.diagnosis_master_id = rec.parent_id
			AND ev.event_date = rec.dx_date
			AND rec.dx_date IS NOT NULL
			AND rec.participant_id IN ($all_updated_participant_ids_strg);");
	foreach($queries as $query)	customQuery($query);
	
	// ** SURVIVAL & BCR **
	
	$summary_section_title = 'DFS start & 1st BCR defintion + Survival & BCR calculation';
	
	// Set all treatments defined as DFS Start
	$query = "SELECT participant_id FROM treatment_masters WHERE deleted <> 1 AND (start_date IS NULL OR start_date LIKE '') AND participant_id IN ($all_updated_participant_ids_strg);";
	$participant_ids_to_remove = array();
	foreach(getSelectQueryResult($query) as $new_record) {
		$participant_ids_to_remove[] = $new_record['participant_id'];
		recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Missing some treatment date(s) to define the DFS start", "Survival and BCR have to be reviewed and updated manually if required. See patient ".$all_updated_participants_labels[$new_record['participant_id']]['label_for_summary']);
	}
	
	$tx_methode_sorted_for_dfs = array(
		'1' => 'RP',
		'2' => 'hormonotherapy',
		'3' => 'radiation',
		'4' => 'chemotherapy');
	$tc_conditions = array();
	foreach($tx_methode_sorted_for_dfs as $tmp_ct) $tc_conditions[] = "tc.tx_method = '$tmp_ct'";
	$tc_conditions = '('.implode(') OR (',$tc_conditions).')';
	$query = "SELECT tm.id, tm.participant_id, part.qc_tf_bank_participant_identifier, tm.start_date, tm.start_date_accuracy, tc.tx_method, tc.disease_site
		FROM treatment_masters tm INNER JOIN treatment_controls tc ON tc.id = tm.treatment_control_id INNER JOIN participants part ON part.id = tm.participant_id
		WHERE tm.participant_id IN ($all_updated_participant_ids_strg) 
		AND ($tc_conditions)
		ORDER BY tm.participant_id, tm.start_date ASC";
	$dfs_tx_ids = array();
	$participant_id = '-1';
	$first_tx_list_per_method = array();
	$accuracy_warning = false;
	$qc_tf_bank_participant_identifier = null;
	foreach(getSelectQueryResult($query) as $row) {
		if(!in_array($row['participant_id'], $participant_ids_to_remove)) {
			if($participant_id != $row['participant_id']) {
				if($participant_id != '-1') {
					foreach($tx_methode_sorted_for_dfs as $next_tx_method) {					
						if(isset($first_tx_list_per_method[$next_tx_method])) {
							$dfs_tx_ids[$participant_id] = $first_tx_list_per_method[$next_tx_method];
							if($accuracy_warning) recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Free survival start event defintion (unaccracy date detected)", "Free survival start event has been defined but at least one treatment (of the patient) was attached to an unaccracy date. Be sure this 'unaccracy' treatment should not be the 'DFS Start'. See patient ".$all_updated_participants_labels[$participant_id]['label_for_summary']);
							break;
						}
					}
				}
				$participant_id = $row['participant_id'];
				$first_tx_list_per_method = array();
				$accuracy_warning = false;
				$qc_tf_bank_participant_identifier = null;
				$qc_tf_bank_name = null;
			}
			$tx_method = $row['tx_method'].(empty($row['disease_site'])? '' : '-'.$row['disease_site']);	
			if(!in_array($tx_method, $tx_methode_sorted_for_dfs)) {
				pr($tx_method);
				pr($tx_methode_sorted_for_dfs);
				die("ERR88938 [".__FUNCTION__." ".__LINE__."]");
			}
			if(!isset($first_tx_list_per_method[$tx_method])) $first_tx_list_per_method[$tx_method] = $row['id'];
			if($row['start_date_accuracy'] != 'c') $accuracy_warning = true;
			$qc_tf_bank_participant_identifier = $row['qc_tf_bank_participant_identifier'];
		}
	}
	foreach($tx_methode_sorted_for_dfs as $next_tx_method) {
		if(isset($first_tx_list_per_method[$next_tx_method])) {
			$dfs_tx_ids[$participant_id] = $first_tx_list_per_method[$next_tx_method];
			if($accuracy_warning) recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Free survival start event defintion (unaccracy date detected)", "Free survival start event has been defined but at least one treatment (of the patient) was attached to an unaccracy date. Be sure this 'unaccracy' treatment should not be the 'DFS Start'. See patient ".$all_updated_participants_labels[$participant_id]['label_for_summary']);
			break;
		}
	}
	
	$current_atim_dfs_tx_ids = array();
	$query = "SELECT id, participant_id FROM treatment_masters WHERE qc_tf_disease_free_survival_start_events = '1' AND deleted <> 1 AND participant_id IN ($all_updated_participant_ids_strg)";
	foreach(getSelectQueryResult($query) as $row) $current_atim_dfs_tx_ids[$row['participant_id']] = $row['id'];
	foreach($all_updated_participants_labels as $updated_participant_id => $label_data) {
		if(isset($current_atim_dfs_tx_ids[$updated_participant_id]) && isset($dfs_tx_ids[$updated_participant_id])) {
			if($current_atim_dfs_tx_ids[$updated_participant_id] != $dfs_tx_ids[$updated_participant_id]) {
				//Update
				updateTableData($current_atim_dfs_tx_ids[$updated_participant_id], array('treatment_masters' => array('qc_tf_disease_free_survival_start_events' => '0')));
				updateTableData($dfs_tx_ids[$updated_participant_id], array('treatment_masters' => array('qc_tf_disease_free_survival_start_events' => '1')));
				addUpdatedDataToSummary($label_data['bank'], $label_data['qc_tf_bank_participant_identifier'], 'Changed DFS start from one treatment to another one', array('from_treatment_master_id' => $current_atim_dfs_tx_ids[$updated_participant_id], 'to_treatment_master_id' => $dfs_tx_ids[$updated_participant_id]));
				recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Changed DFS start from one treatment to another one", "See patient ".$label_data['label_for_summary']);
			}		
		} else if(isset($current_atim_dfs_tx_ids[$updated_participant_id])) {
			recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Validate previous DFS start set into ATiM", "Update process was unable to defined the DFS start treatment but one was already set into ATiM. This one has not been updated but has to be validated. See patient ".$label_data['label_for_summary']);
		} else if(isset($dfs_tx_ids[$updated_participant_id])) {
			updateTableData($dfs_tx_ids[$updated_participant_id], array('treatment_masters' => array('qc_tf_disease_free_survival_start_events' => '1')));
			addUpdatedDataToSummary($label_data['bank'], $label_data['qc_tf_bank_participant_identifier'], 'Set DFS start', array('to_treatment_master_id' => $dfs_tx_ids[$updated_participant_id]));
		}		
	}

	// Set first BCR
	$query = "SELECT dm.participant_id FROM diagnosis_masters dm INNER JOIN ".$atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['detail_tablename'] ." rec ON dm.id = rec.diagnosis_master_id WHERE (dm.dx_date IS NULL OR dm.dx_date LIKE '') AND dm.participant_id IN ($all_updated_participant_ids_strg);";
	$participant_ids_to_remove = array();
	foreach(getSelectQueryResult($query) as $row) {
		//added to allow process to continue when dates are missing
		$participant_ids_to_remove[] = $row['participant_id'];
		recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Missing BCR date to define the first BCR", "See patient ".$all_updated_participants_labels[$row['participant_id']]['label_for_summary']);
	}
	
	$query = "SELECT dm.id, dm.participant_id, part.qc_tf_bank_participant_identifier, dm.dx_date, dm.dx_date_accuracy
		FROM diagnosis_masters dm INNER JOIN ".$atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['detail_tablename'] ." rec ON dm.id = rec.diagnosis_master_id AND dm.deleted != 1 INNER JOIN participants part ON part.id = dm.participant_id
		WHERE dm.participant_id IN ($all_updated_participant_ids_strg) AND dm.dx_date IS NOT NULL
		ORDER BY dm.participant_id, dm.dx_date ASC";
	$participant_id = '-1';
	$first_bcr_dx_ids = array();
	$accuracy_warning = false;
	$previous_qc_tf_bank_participant_identifier = null;
	foreach(getSelectQueryResult($query) as $row) {
		if(!in_array($row['participant_id'], $participant_ids_to_remove)) {
			if($participant_id != $row['participant_id']) {
				$participant_id = $row['participant_id'];
				$first_bcr_dx_ids[$participant_id] = $row['id'];
				if($accuracy_warning) recordErrorAndMessage($summary_section_title, '@@WARNING@@', "First BCR defintion (unaccracy date detected)", "Fisrt BCR has been defined based on bcrs with at least one unaccracy date. See patient ".$all_updated_participants_labels[$participant_id]['label_for_summary']);
				$accuracy_warning = false;
				$previous_qc_tf_bank_participant_identifier = $row['qc_tf_bank_participant_identifier'];;
			}
			if($row['dx_date_accuracy'] != 'c') $accuracy_warning = true;
		}
	}
	if($accuracy_warning) recordErrorAndMessage($summary_section_title, '@@WARNING@@', "First BCR defintion (unaccracy date detected)", "Fisrt BCR has been defined based on bcrs with at least one unaccracy date. See patient ".$all_updated_participants_labels[$participant_id]['label_for_summary']);
	
	$current_atim_first_bcr_dx_ids = array();
	$query = "SELECT id, participant_id FROM diagnosis_masters INNER JOIN ".$atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['detail_tablename'] ." ON id = diagnosis_master_id WHERE first_biochemical_recurrence = '1' AND deleted <> 1 AND participant_id IN ($all_updated_participant_ids_strg)";
	foreach(getSelectQueryResult($query) as $row) $current_atim_first_bcr_dx_ids[$row['participant_id']] = $row['id'];
	foreach($all_updated_participants_labels as $updated_participant_id => $label_data) {
		if(isset($current_atim_first_bcr_dx_ids[$updated_participant_id]) && isset($first_bcr_dx_ids[$updated_participant_id])) {
			if($current_atim_first_bcr_dx_ids[$updated_participant_id] != $first_bcr_dx_ids[$updated_participant_id]) {
				//Update
				updateTableData($current_atim_first_bcr_dx_ids[$updated_participant_id], array('diagnosis_masters' => array(), $atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['detail_tablename'] => array('first_biochemical_recurrence' => '')));
				updateTableData($first_bcr_dx_ids[$updated_participant_id], array('diagnosis_masters' => array(), $atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['detail_tablename'] => array('first_biochemical_recurrence' => '1')));
				addUpdatedDataToSummary($label_data['bank'], $label_data['qc_tf_bank_participant_identifier'], 'Changed first BCR from one recurrence to another one', array('from_diagnosis_master_id' => $current_atim_first_bcr_dx_ids[$updated_participant_id], 'to_diagnosis_master_id' => $first_bcr_dx_ids[$updated_participant_id]));
				recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Changed first BCR from one recurrence to another one", "See patient ".$label_data['label_for_summary']);
			}
		} else if(isset($current_atim_first_bcr_dx_ids[$updated_participant_id])) {
			recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Validate previous first BCR set into ATiM", "Update process was unable to defined the first BCR but one was already set into ATiM. This one has not been updated but has to be validated. See patient ".$label_data['label_for_summary']);
		} else if(isset($first_bcr_dx_ids[$updated_participant_id])) {
			updateTableData($first_bcr_dx_ids[$updated_participant_id], array('diagnosis_masters' => array(), $atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['detail_tablename'] => array('first_biochemical_recurrence' => '1')));
			addUpdatedDataToSummary($label_data['bank'], $label_data['qc_tf_bank_participant_identifier'], 'Set first BCR', array('to_diagnosis_master_id' => $first_bcr_dx_ids[$updated_participant_id]));
		}
	}

	// Calculate survival and bcr
	$query = "SELECT dm.id as diagnosis_master_id, dm.participant_id, dd.bcr_in_months, dd.survival_in_months,
		part.qc_tf_bank_participant_identifier, part.date_of_death, part.date_of_death_accuracy, part.qc_tf_last_contact, part.qc_tf_last_contact_accuracy,
		bcr.bcr_date,
		bcr.bcr_date_accuracy,
		trt.start_date as dfs_date,
		trt.start_date_accuracy as dfs_date_accuracy	
		FROM diagnosis_masters dm 
		INNER JOIN ".$atim_controls['diagnosis_controls']['primary-prostate']['detail_tablename']." dd ON dd.diagnosis_master_id = dm.id
		INNER JOIN participants part ON part.id = dm.participant_id
		INNER JOIN treatment_masters trt ON trt.diagnosis_master_id = dm.id AND trt.qc_tf_disease_free_survival_start_events = 1
		LEFT JOIN (
			SELECT dmr.primary_id, dmr.dx_date bcr_date, dmr.dx_date_accuracy bcr_date_accuracy
			FROM diagnosis_masters dmr INNER JOIN ".$atim_controls['diagnosis_controls']['recurrence - locoregional-biochemical recurrence']['detail_tablename'] ." rec ON dmr.id = rec.diagnosis_master_id AND dmr.deleted != 1
			WHERE rec.first_biochemical_recurrence = 1 AND dmr.participant_id IN ($all_updated_participant_ids_strg)
		) bcr ON bcr.primary_id = dm.id
		WHERE part.id IN ($all_updated_participant_ids_strg) AND dm.diagnosis_control_id = ".$atim_controls['diagnosis_controls']['primary-prostate']['id'] ." AND dm.deleted <> 1
		AND trt.deleted <> 1
		ORDER BY dm.participant_id";
	$participant_id = '-1';
	foreach(getSelectQueryResult($query) as $row) {
		if($participant_id == $row['participant_id']) die('ERR889930303');

		$bcr_date = $row['bcr_date'];
		$bcr_accuracy = $row['bcr_date_accuracy'];
			
		$dfs_date = $row['dfs_date'];
		$dfs_accuracy = $row['dfs_date_accuracy'];
			
		$survival_end_date = '';
		$survival_end_date_accuracy = '';
		if(!empty($row['date_of_death'])) {
			$survival_end_date = $row['date_of_death'];
			$survival_end_date_accuracy = $row['date_of_death_accuracy'];
		} else if(!empty($row['qc_tf_last_contact'])) {
			$survival_end_date = $row['qc_tf_last_contact'];
			$survival_end_date_accuracy = $row['qc_tf_last_contact_accuracy'];
		}
			
		// Calculate Survival	
		$new_survival = '';
		if(!empty($dfs_date) && !empty($survival_end_date)) {
			if(in_array($survival_end_date_accuracy.$dfs_accuracy, array('cd','dc','cc'))) {
				if($survival_end_date_accuracy.$dfs_accuracy != 'cc') recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Survival calculation with unaccuracy date", "Survival has been calculated with at least one inaccurate date (month precision or more). See patient ".$all_updated_participants_labels[$row['participant_id']]['label_for_summary']);
				$dfs_date_ob = new DateTime($dfs_date);
				$survival_end_date_ob = new DateTime($survival_end_date);
				$interval = $dfs_date_ob->diff($survival_end_date_ob);
				if($interval->invert) {
					recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Unable to calculate survival on non-chronological dates", "Survival cannot be calculated because dates are not chronological. See patient ".$all_updated_participants_labels[$row['participant_id']]['label_for_summary']);
				} else {
					$new_survival = $interval->y*12 + $interval->m;
				}
			} else {
				recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Unable to calculate survival on inaccurate dates", "Survival cannot be calculated on inaccurate dates (month unknown). See patient ".$all_updated_participants_labels[$row['participant_id']]['label_for_summary']);
			}
		}
	
		// Calculate bcr
			
		$new_bcr = '';
		if(!empty($dfs_date) && !empty($bcr_date)) {
			if(in_array($dfs_accuracy.$bcr_accuracy, array('cd','dc','cc'))) {
				if($dfs_accuracy.$bcr_accuracy != 'cc') recordErrorAndMessage($summary_section_title, '@@WARNING@@', "BCR calculation with unaccuracy date", "BCR has been calculated with at least one inaccurate date (month precision or more). See patient ".$all_updated_participants_labels[$row['participant_id']]['label_for_summary']);
				$dfs_date_ob = new DateTime($dfs_date);
				$bcr_date_ob = new DateTime($bcr_date);
				$interval = $dfs_date_ob->diff($bcr_date_ob);
				if($interval->invert) {
					recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Unable to calculate BCR on non-chronological dates", "BCR cannot be calculated because dates are not chronological. See patient ".$all_updated_participants_labels[$row['participant_id']]['label_for_summary']);
				} else {
					$new_bcr = $interval->y*12 + $interval->m;
				}
			} else {
				recordErrorAndMessage($summary_section_title, '@@WARNING@@', "Unable to calculate BCR on inaccurate dates", "BCR cannot be calculated on inaccurate dates (month unknown). See patient ".$all_updated_participants_labels[$row['participant_id']]['label_for_summary']);
			}
		} else {
			$new_bcr = $new_survival;
		}
		
		// Data to update
		$data_to_update = array();//getDataToUpdate() can not be used because we have to erase value if the new one is empty
		if($row['survival_in_months'] != $new_survival) $data_to_update['survival_in_months'] = (strlen($new_survival)? $new_survival : null);
		if($row['bcr_in_months'] != $new_bcr) $data_to_update['bcr_in_months'] = (strlen($new_bcr)? $new_bcr : null);
		if($data_to_update) {
		  updateTableData($row['diagnosis_master_id'], array('diagnosis_masters' => array(), $atim_controls['diagnosis_controls']['primary-prostate']['detail_tablename']  => $data_to_update));
		  addUpdatedDataToSummary($all_updated_participants_labels[$row['participant_id']]['bank'], $all_updated_participants_labels[$row['participant_id']]['qc_tf_bank_participant_identifier'], 'Updated  primary diagnosis BCR or Survival', $data_to_update);
		}
	}
	
	//Final test to check only one DFS start exists per primary diagnosis
	$query = "SELECT
			TreatmentMaster.participant_id,
			Bank.name as 'Bank',
			Participant.participant_identifier as 'ATim#',
			Participant.qc_tf_bank_participant_identifier as 'Bank#',
			res.primary_id,
			TreatmentMaster.id as treatment_master_id,
			TreatmentMaster.start_date,
			TreatmentControl.tx_method,
			TreatmentMaster.created AS 'TreatmentMaster.created',
			TreatmentMaster.created_by AS 'TreatmentMaster.created_by',
			TreatmentMaster.modified AS 'TreatmentMaster.modified',
			TreatmentMaster.modified_by AS 'TreatmentMaster.modified_by'
		 FROM(
			SELECT count(*) as nbr,
				DiagnosisMaster.primary_id,
				DiagnosisMaster.participant_id
			FROM diagnosis_masters AS DiagnosisMaster
			INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id AND TreatmentMaster.deleted <> 1 AND TreatmentMaster.qc_tf_disease_free_survival_start_events = 1
			INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
			WHERE DiagnosisMaster.deleted <> 1 AND TreatmentMaster.deleted <> 1
			GROUP BY DiagnosisMaster.primary_id, DiagnosisMaster.participant_id
		) as res
		INNER JOIN diagnosis_masters DiagnosisMaster ON DiagnosisMaster.id = res.primary_id
		INNER JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id AND TreatmentMaster.deleted <> 1 AND TreatmentMaster.qc_tf_disease_free_survival_start_events = 1
		INNER JOIN treatment_controls AS TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
		INNER JOIN participants Participant ON Participant.id = DiagnosisMaster.participant_id
		LEFT JOIN banks Bank ON Bank.id = Participant.qc_tf_bank_id
		WHERE nbr  >1 AND DiagnosisMaster.deleted <> 1 AND TreatmentMaster.deleted <> 1 AND Participant.deleted <> 1 
		ORDER BY res.participant_id, res.primary_id, TreatmentMaster.start_date, TreatmentControl.tx_method;";
	foreach(getSelectQueryResult($query) as $row) {
		recordErrorAndMessage($summary_section_title, '@@ERROR@@', "A diagnosis is linked to more than one treatment flagged as 'DFS Start'", "See patient ".$row['Bank#']." (".$row['Bank'].")");
	}
}
	
?>
		