<?php

function updateOvaryEndometriumDiagnosis(&$wroksheetcells, $sheets_keys, $dx_worksheet_name, $event_worksheet_name, $atim_controls, $all_patients_worksheet_voas, &$participant_ids_to_skip) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;
	global $voas_to_participant_id;
	
	// Set variables for progressions
	
	$dx_progressions = array();
	$allowed_tumor_sites = getATiMTumorSites();
	$progression_summary_msg_key = $dx_worksheet_name.' - Progression';
	
	// Set variables for treatment
	
	$drug_list = getDrugList();
	$tmp_voa_to_residual_disease = array();
	
	// ***** DX *****
	
	$headers = array();
	$worksheet_name = $dx_worksheet_name;
	$voa_to_diagnosis_master_id = array();
	$studied_voas_for_duplicated_data_check = array();
	foreach($wroksheetcells[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers  = $new_line;
			$last_val = '';
			$last_key = 0;
			foreach($headers as $key => $val) {
				for($previous_key = ($last_key + 1); $previous_key < $key; $previous_key++) {
					$headers[$previous_key] = $last_val;
				}
				$last_val = $val;
				$last_key = $key;
			}
		} else if($excel_line_counter == 2) {
			foreach($new_line as $key => $val) {
				if(isset($headers[$key])) {
					$headers[$key] .= '::'.$val;
				} else {
					$headers[$key] = $val;
				}
			}
			ksort($headers);
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			//Get VOA
			$voa = null;
			if(preg_match('/^VOA([0-9]+)$/', $new_line_data['Patient Biobank Number (required)'], $matches)) {
				$voa = $matches[1];
			} else if(preg_match('/^([0-9]+)$/', $new_line_data['Patient Biobank Number (required)'], $matches)) {
				$voa = $matches[1];
			} else if(strlen($new_line_data['Patient Biobank Number (required)'])) {
				$summary_msg[$worksheet_name]['@@ERROR@@']["Unable to find VOA# from cell"][] = "Cell val = '".$new_line_data['Patient Biobank Number (required & unique)']."'. No data will be migrated. [Worksheet: $worksheet_name /line: $excel_line_counter]";
			}
			if($voa) {
				if(!in_array($voa, $all_patients_worksheet_voas)) die('ERR 237328832832 voa'.$voa);
				if(in_array($voa, $studied_voas_for_duplicated_data_check)) {
					$summary_msg[$worksheet_name]['@@ERROR@@']["VOA linked to many rows"][] = "VOA#$voa is linked to at least 2 rows. Only data of the first row will be parsed for updates. [Worksheet: $worksheet_name /line: $excel_line_counter]";	
				} else {
					$studied_voas_for_duplicated_data_check[$voa] = $voa;
					$participant_id = $voas_to_participant_id[$voa];
					$query = "SELECT DiagnosisMaster.id,
						DiagnosisMaster.dx_date AS 'DiagnosisMaster.dx_date',
						DiagnosisMaster.dx_date_accuracy AS 'DiagnosisMaster.dx_date_accuracy',
						DiagnosisMaster.notes AS 'DiagnosisMaster.notes',
						DiagnosisMaster.ovcare_clinical_history AS 'DiagnosisMaster.ovcare_clinical_history',
						DiagnosisMaster.ovcare_clinical_diagnosis AS 'DiagnosisMaster.ovcare_clinical_diagnosis',
						DiagnosisMaster.ovcare_tumor_site AS 'DiagnosisMaster.ovcare_tumor_site',
						DiagnosisMaster.ovcare_path_review_type AS 'DiagnosisMaster.ovcare_path_review_type',
						DiagnosisMaster.tumour_grade AS 'DiagnosisMaster.tumour_grade',
						DiagnosisDetail.figo AS 'DiagnosisDetail.figo',
						DiagnosisDetail.laterality AS 'DiagnosisDetail.laterality',
						DiagnosisDetail.censor AS 'DiagnosisDetail.censor',
						DiagnosisDetail.ovarian_histology AS 'DiagnosisDetail.ovarian_histology',
						DiagnosisDetail.uterine_histology AS 'DiagnosisDetail.uterine_histology',
						DiagnosisDetail.histopathology AS 'DiagnosisDetail.histopathology',
						DiagnosisDetail.benign_lesions_precursor_presence AS 'DiagnosisDetail.benign_lesions_precursor_presence',
						DiagnosisDetail.fallopian_tube_lesions AS 'DiagnosisDetail.fallopian_tube_lesions',
						DiagnosisDetail.progression_status AS 'DiagnosisDetail.progression_status'
						FROM diagnosis_masters DiagnosisMaster INNER JOIN ".$atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium tumor']['detail_tablename']." DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
						WHERE DiagnosisMaster.participant_id = $participant_id AND DiagnosisMaster.deleted <> 1 
						AND DiagnosisMaster.diagnosis_control_id = ".$atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium tumor']['id'].";";
					$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
					$atim_diagnosis_data = null;
					if($results->num_rows > 1) {
						$summary_msg['Un-migrated VOA#s']['@@WARNING@@']["Reason: More than one Ovarian/Endometrium primary diagnosis into ATiM"]["$participant_id-$voa"] = "The migration process won't be able to match the excel diagnosis and an ATiM diagnosis: See ATiM participant_id $participant_id (VOA#:$voa). [Worksheet: $worksheet_name]";
						ksort($summary_msg['Un-migrated VOA#s']['@@WARNING@@']["Reason: More than one Ovarian/Endometrium primary diagnosis into ATiM"]);
						$summary_msg['Un-migrated VOA#s']['@@ERROR@@']["Un-migrated VOA#s (Data has to be enter manually into ATiM after migration process)"][$voa] = "VOA#$voa (ATiM participant_id = $participant_id)";
						$participant_ids_to_skip[] = $participant_id;
					} else if($results->num_rows == 1) {
						$atim_diagnosis_data = $results->fetch_assoc();
					}
					if(!in_array($participant_id, $participant_ids_to_skip)) {
						//Get Excel File Data
						$file_diagnosis_data = array();
						$file_dx_data_strg = array();
						$dxd_data = getDateAndAccuracy($worksheet_name, $new_line_data, $worksheet_name, 'Date of EOC Diagnosis::Date', 'Date of EOC Diagnosis::Accuracy', $excel_line_counter);
						if($dxd_data) {
							$file_diagnosis_data['DiagnosisMaster.dx_date'] = $dxd_data['date'];
							$file_diagnosis_data['DiagnosisMaster.dx_date_accuracy'] = $dxd_data['accuracy'];
							$file_dx_data_strg['DiagnosisMaster.dx_date'] = 'Date = <b>'.$dxd_data['date'].'</b>';
						}
						$fields_properties = array(
							array('Presence of precursor of benign lesions','DiagnosisDetail.benign_lesions_precursor_presence', array('unknown', 'ovarian cysts', 'endometriosis', 'benign or borderline tumours', 'no')),
							array('fallopian tube lesions', 'DiagnosisDetail.fallopian_tube_lesions', array('unknown', 'yes', 'benign tumors', 'no')),					
							array('Laterality', 'DiagnosisDetail.laterality', array('right', "left", "bilateral", "unknown")),					
							array('Histopathology', 'DiagnosisDetail.histopathology', array('clear cells', 'endometrioid', 'high grade serous', 'low grade serous', 'mixed', 'mucinous', 'undifferentiated', 'serous', 'other', 'unknown', 'non applicable', 'low grade', 'high grade')),					
							array('Grade', 'DiagnosisMaster.tumour_grade', array('1', '2', '3', '4', 'unknown')),					
							array('FIGO ', 'DiagnosisDetail.figo', array('I', 'Ia', 'Ib', 'Ic', 'II', 'IIa', 'IIb', 'IIc', 'III', 'IIIa', 'IIIb', 'IIIc', 'IV', 'unknown')),					
							array('Progression status', 'DiagnosisDetail.progression_status', array('no', 'yes', 'unknown','progressive disease')),					
						);
						foreach($fields_properties as $field_properties) {
							list($file_field, $db_model_and_field, $allowed_values) = $field_properties;
							$new_line_data[$file_field] = str_replace('not applicable','',$new_line_data[$file_field]);
							if(strlen($new_line_data[$file_field])) {
								if(!in_array($new_line_data[$file_field], $allowed_values)) die('ERR2387328 7872872832732');
								$file_diagnosis_data[$db_model_and_field] = $new_line_data[$file_field];
								$file_dx_data_strg[$db_model_and_field] = "$file_field = <b>".$new_line_data[$file_field].'</b>';
							}
						}
						//Manage Dx Data
						$diagnosis_master_id = null;
						if(empty($atim_diagnosis_data)) {
							if(empty($file_diagnosis_data)) {
								$summary_msg[$worksheet_name]['@@WARNING@@']["No Diagnosis Data in ATiM and Excel"][] = "No diagnosis and progressions will be created. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";						
							} else {
								//create new diagnosis
								$dx_data = array(
									'DiagnosisMaster' => array(
										'participant_id' => $participant_id, 
										'diagnosis_control_id'=>$atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium tumor']['id']), 
									'DiagnosisDetail' => array());
								foreach($file_diagnosis_data as $db_model_and_field => $file_value) {
									preg_match('/^([a-zA-Z]+)\.([a-zA-Z_]+)$/', $db_model_and_field, $matches);
									$db_model = $matches[1];
									if(!in_array($db_model, array('DiagnosisMaster','DiagnosisDetail'))) die('ERR32732783272837');
									$db_field = $matches[2];
									$dx_data[$db_model][$db_field] = $file_value;
								}
								$diagnosis_master_id = customInsertRecord($dx_data['DiagnosisMaster'], 'diagnosis_masters', false, false);
								$query = "UPDATE diagnosis_masters SET primary_id = $diagnosis_master_id WHERE id = $diagnosis_master_id";
								mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
								$dx_data['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
								customInsertRecord($dx_data['DiagnosisDetail'], $atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium tumor']['detail_tablename'], true, false);
								$file_dx_data_strg = implode(' & ', $file_dx_data_strg);
								$summary_msg['Data Creation/Update Summary'][$participant_id]["New Ovary/Endometrium Primary Diagnosis"][] = "With following values: $file_dx_data_strg. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							}
						} else {
							$diagnosis_master_id = $atim_diagnosis_data['id'];
							if(!empty($file_diagnosis_data)) {
								$atim_diagnosis_data_to_update = array();
								foreach($file_diagnosis_data as $db_model_and_field => $file_value) {
									if(!array_key_exists($db_model_and_field, $atim_diagnosis_data)) die('ERR327632767627632732632');
									preg_match('/^([a-zA-Z]+)\.([a-zA-Z_]+)$/', $db_model_and_field, $matches);
									$db_model = $matches[1];
									if(!in_array($db_model, array('DiagnosisMaster','DiagnosisDetail'))) die('ERR32732783272837');
									$db_field = $matches[2];
									$update_dx = false;
									if(!strlen($atim_diagnosis_data[$db_model_and_field])) {
										$update_dx = true;
									} else if($atim_diagnosis_data[$db_model_and_field] != $file_diagnosis_data[$db_model_and_field]) {
										$update_dx = true;
										$summary_msg[$worksheet_name]['@@WARNING@@']["Field '$db_field' Conflict"][] = "ATiM  value [".$atim_diagnosis_data[$db_model_and_field]."] is different than file value [".$file_diagnosis_data[$db_model_and_field]."]. Data will be updated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									}
									if($update_dx) {	
										$atim_diagnosis_data_to_update[$db_model][$db_field] = "$db_field = '".$file_diagnosis_data[$db_model_and_field]."'";
									} else {
										unset($file_dx_data_strg[$db_model_and_field]);
									}						
								}
								if($atim_diagnosis_data_to_update) {
									$atim_diagnosis_data_to_update['DiagnosisMaster']['modified'] = "modified = '$modified'";
									$atim_diagnosis_data_to_update['DiagnosisMaster']['modified_by'] = "modified_by = '$modified_by'";
									$query = "UPDATE diagnosis_masters SET ".implode(',',$atim_diagnosis_data_to_update['DiagnosisMaster'])." WHERE id = $diagnosis_master_id;";
									mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
									if(isset($atim_diagnosis_data_to_update['DiagnosisDetail'])) {
										$query = "UPDATE ".$atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium tumor']['detail_tablename']." SET ".implode(',',$atim_diagnosis_data_to_update['DiagnosisDetail'])." WHERE diagnosis_master_id = $diagnosis_master_id;";
										mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
									}
									$summary_msg['Data Creation/Update Summary'][$participant_id]["Ovarian/Endometrium Primary Diagnosis Update Summary"][] = "Updated following information : ".implode(',',$file_dx_data_strg).". See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";	
								}
							}
						}
						$voa_to_diagnosis_master_id[$voa] = $diagnosis_master_id;
						// Track Progression For Next Step
						if(strlen($new_line_data['Date of Progression of CA125::Date'].$new_line_data['Date of Progression of CA125::Accuracy'])) {
							$date_data = getDateAndAccuracy($progression_summary_msg_key, $new_line_data, $worksheet_name, 'Date of Progression of CA125::Date', 'Date of Progression of CA125::Accuracy', $excel_line_counter);
							if($date_data) {
								$dx_progressions[$voa]['CA125'][$date_data['date']] = $date_data;
							} else {
								$summary_msg[$progression_summary_msg_key]['@@ERROR@@']["CA125 Progression Date Error"][] = "Migration process is unable to get date from value '".$new_line_data['Date of Progression of CA125::Date']."'. No CA125 progression will be created. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							}
						}
						if(strlen($new_line_data['Date of Progression/Recurrence::Date'].$new_line_data['Date of Progression/Recurrence::Accuracy'].$new_line_data['Site 1 of Primary Tumor Progression (metastasis)  If Applicable'].$new_line_data['Site 2 of Primary Tumor Progression (metastasis)  If applicable'])) {
							$date_data = getDateAndAccuracy($progression_summary_msg_key, $new_line_data, $worksheet_name, 'Date of Progression/Recurrence::Date', 'Date of Progression/Recurrence::Accuracy', $excel_line_counter);
							if(!$date_data) {
								if(strlen($new_line_data['Date of Progression/Recurrence::Date'])) $summary_msg[$progression_summary_msg_key]['@@ERROR@@']["Secondary Diagnosis Date Error"][] = "Migration process is unable to get Progression date from value '".$new_line_data['Date of Progression/Recurrence::Date']."'. No date will be associated to the created secondary diagnosis. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
								$date_data = array('date'=>null, 'accuracy'=>null, 'site'=>null);
							}
							$site_found = false;
							foreach(array('Site 1 of Primary Tumor Progression (metastasis)  If Applicable', 'Site 2 of Primary Tumor Progression (metastasis)  If applicable') as $file_field) {
								$site = str_replace('ascite', 'other-ascite', strtolower($new_line_data[$file_field]));
								if(strlen($site)) {
									if(in_array($site, $allowed_tumor_sites)) {
										$site_found = true;
										$dx_progressions[$voa]['progression'][] = array_merge(array('site' => $site), $date_data);
									} else {
										die("ERR 772873298327982932873287 = $site");
									}
								}
							}
							if(!$site_found && !empty($date_data['date'])) {
								$summary_msg[$progression_summary_msg_key]['@@WARNING@@']["Secondary Diagnosis Site is missing"][] = "But a date is set '".$date_data['date']."'. An 'unknown' secondary diagnosis will be created. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
								$dx_progressions[$voa]['progression'][] = array_merge(array('site' => 'unknown'), $date_data);
							}
						}
					}
					//Track Residual Disease					
					$tmp_voa_to_residual_disease[$voa] = $new_line_data['Residual Disease'];
				}
			}
		}
	}
	
	// ***** PROGRESSION *****
	
	$existing_secondaries = array();
	$query = "SELECT participant_id, ovcare_tumor_site FROM diagnosis_masters WHERE diagnosis_control_id = ".$atim_controls['diagnosis_control_ids']['secondary']['all']['id']."
		AND participant_id IN (".implode(',',$voas_to_participant_id).");";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()){
		$existing_secondaries[$row['participant_id']] = $row['ovcare_tumor_site'];
	}
	$ca125_progression_diagnosis_master_id = array();
	foreach($dx_progressions as $voa => $new_voa_progressions) {
		if(!isset($voa_to_diagnosis_master_id[$voa]) || empty($voa_to_diagnosis_master_id[$voa])) {
			$summary_msg[$progression_summary_msg_key]['@@WARNING@@']["Unknown primary diagnosis of a progression"][] = "A diagnosis progression has been defined into the excel file but no primary diagnosis has been created or defined into ATiM. No progression will be created. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name]";
		} else {
			$participant_id = $voas_to_participant_id[$voa];
			$primary_id = $voa_to_diagnosis_master_id[$voa];
			
			
			if(array_key_exists('progression', $new_voa_progressions)) {
				foreach($new_voa_progressions['progression'] as $new_progression) {
					if(empty($new_progression['date']) && $new_progression['site'] == 'unknown') {
						$summary_msg[$progression_summary_msg_key]['@@WARNING@@']["Unknown site of a diagnosis progression plus no date"][] = "No progression will be created. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name]";
					} else {
						$master_data = array(
								'participant_id' => $participant_id,
								'primary_id' => $primary_id,
								'parent_id' => $primary_id,
								'diagnosis_control_id' => $atim_controls['diagnosis_control_ids']['secondary']['all']['id'],
								'dx_date' => $new_progression['date'],
								'dx_date_accuracy' => $new_progression['accuracy'],
								'ovcare_tumor_site' => $new_progression['site']);
						//Check also CA progression
						$tmp_ca125_progression = false;
						if(array_key_exists('CA125', $new_voa_progressions) && array_key_exists($new_progression['date'], $new_voa_progressions['CA125'])) {
							$master_data['notes'] = 'And progression of CA125';
							$tmp_ca125_progression = true;
							unset($new_voa_progressions['CA125'][$new_progression['date']]);
						}
						$diagnosis_master_id = customInsertRecord($master_data, 'diagnosis_masters', false, true);
						if($tmp_ca125_progression) $ca125_progression_diagnosis_master_id[$voa][$new_progression['date']] = $diagnosis_master_id;
						customInsertRecord(array('diagnosis_master_id' => $diagnosis_master_id), $atim_controls['diagnosis_control_ids']['secondary']['all']['detail_tablename'], true, true);
						if(array_key_exists($participant_id, $existing_secondaries)) {
							$summary_msg[$progression_summary_msg_key]['@@WARNING@@']["Existsing Secondary"][] = "A new secondary has been created for patient but a '".$existing_secondaries[$participant_id]."' was already created into ATiM. Check if these 2 secodnaries can be merged and do it manually after migration if they have to. See ATiM participant_id $participant_id (VOA#$voa).";
						}
					}
				}
			}
			if(array_key_exists('CA125', $new_voa_progressions)) {
				foreach($new_voa_progressions['CA125'] as $new_progression) {
					$master_data = array(
						'participant_id' => $participant_id,
						'primary_id' => $primary_id,
						'parent_id' => $primary_id,
						'diagnosis_control_id' => $atim_controls['diagnosis_control_ids']['progression']['undetailed']['id'],
						'dx_date' => $new_progression['date'],
						'dx_date_accuracy' => $new_progression['accuracy'],
						'notes' => 'Progression of CA125'
					);
					$diagnosis_master_id = customInsertRecord($master_data, 'diagnosis_masters', false, true);
					customInsertRecord(array('diagnosis_master_id' => $diagnosis_master_id), $atim_controls['diagnosis_control_ids']['progression']['undetailed']['detail_tablename'], true, true);
					$ca125_progression_diagnosis_master_id[$voa][$new_progression['date']] = $diagnosis_master_id;
				}
			}
		}		
	}
	unset($dx_progressions);
	
	// ***** EOC - Event *****
	
	//Get ATiM Chemo
	$participant_id_to_atim_chemos = array();
	$query = "SELECT TreatmentDetail.treatment_master_id,
		TreatmentMaster.participant_id, 
		TreatmentMaster.diagnosis_master_id,
		TreatmentMaster.start_date, 
		TreatmentMaster.start_date_accuracy, 
		TreatmentMaster.finish_date, 
		TreatmentMaster.finish_date_accuracy,
		Drug.generic_name
		FROM treatment_masters TreatmentMaster
		INNER JOIN ".$atim_controls['treatment_controls']['chemotherapy']['detail_tablename']." TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
		LEFT JOIN treatment_extend_masters TreatmentExtendMaster ON TreatmentExtendMaster.treatment_master_id = TreatmentMaster.id AND TreatmentExtendMaster.deleted <> 1
		LEFT JOIN ".$atim_controls['treatment_controls']['chemotherapy']['te_detail_tablename']." TreatmentExtendDetail ON TreatmentExtendMaster.id = TreatmentExtendDetail.treatment_extend_master_id
		LEFT JOIN drugs Drug ON Drug.id = TreatmentExtendDetail.drug_id
		WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.treatment_control_id = ".$atim_controls['treatment_controls']['chemotherapy']['treatment_control_id']."
		AND TreatmentMaster.participant_id IN (".implode(',',$voas_to_participant_id).");";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		if(!isset($participant_id_to_atim_chemos[$row['participant_id']][$row['start_date']][$row['treatment_master_id']])) {
			$participant_id_to_atim_chemos[$row['participant_id']][$row['start_date']][$row['treatment_master_id']] = array(
					'treatment_master_id' => $row['treatment_master_id'],
					'participant_id' => $row['participant_id'],
					'diagnosis_master_id' => $row['diagnosis_master_id'],
					'start_date' => $row['start_date'],
					'start_date_accuracy' => $row['start_date_accuracy'],
					'finish_date' => $row['finish_date'],
					'finish_date_accuracy' => $row['finish_date_accuracy'],
					'drugs' => array());
			if($row['generic_name']) $participant_id_to_atim_chemos[$row['participant_id']][$row['start_date']][$row['treatment_master_id']]['drugs'][$row['generic_name']] = $row['generic_name'];
		}
	}
	//Get ATiM Surgery and Biopsy
	$participant_id_to_atim_surgery_biopsy = array();
	$query = "SELECT TreatmentDetail.treatment_master_id,
		TreatmentMaster.participant_id,
		TreatmentMaster.diagnosis_master_id,
		TreatmentMaster.start_date,
		TreatmentMaster.start_date_accuracy,
		TreatmentMaster.finish_date,
		TreatmentMaster.finish_date_accuracy,
		TreatmentDetail.ovcare_residual_disease,
		TreatmentExtendDetail.surgical_procedure
		FROM treatment_masters TreatmentMaster
		INNER JOIN ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['detail_tablename']." TreatmentDetail ON TreatmentMaster.id = TreatmentDetail.treatment_master_id
		LEFT JOIN treatment_extend_masters TreatmentExtendMaster ON TreatmentExtendMaster.treatment_master_id = TreatmentMaster.id AND TreatmentExtendMaster.deleted <> 1
		LEFT JOIN ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['te_detail_tablename']." TreatmentExtendDetail ON TreatmentExtendMaster.id = TreatmentExtendDetail.treatment_extend_master_id
		WHERE TreatmentMaster.deleted <> 1 AND TreatmentMaster.treatment_control_id = ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['treatment_control_id']."
		AND TreatmentMaster.participant_id IN (".implode(',',$voas_to_participant_id).");";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		if(!isset($participant_id_to_atim_surgery_biopsy[$row['participant_id']][$row['start_date']][$row['treatment_master_id']])) {
			$participant_id_to_atim_surgery_biopsy[$row['participant_id']][$row['start_date']][$row['treatment_master_id']] = array(
				'treatment_master_id' => $row['treatment_master_id'],
				'participant_id' => $row['participant_id'],
				'diagnosis_master_id' => $row['diagnosis_master_id'],
				'start_date' => $row['start_date'],
				'start_date_accuracy' => $row['start_date_accuracy'],
				'finish_date' => $row['finish_date'],
				'finish_date_accuracy' => $row['finish_date_accuracy'],
				'ovcare_residual_disease' => $row['ovcare_residual_disease'],
				'surgical_procedures' => array());
		}
		if($row['surgical_procedure']) $participant_id_to_atim_surgery_biopsy[$row['participant_id']][$row['start_date']][$row['treatment_master_id']]['surgical_procedures'][$row['surgical_procedure']] = $row['surgical_procedure'];
	}
	//Get ATiM Ca125
	$participant_id_to_atim_ca125s = array();
	$query = "SELECT EventMaster.participant_id, 
		EventMaster.diagnosis_master_id, 
		EventDetail.event_master_id, 
		EventMaster.event_date, 
		EventMaster.event_date_accuracy, 
		EventDetail.ca125
		FROM event_masters EventMaster
		INNER JOIN ".$atim_controls['event_controls']['ca125']['detail_tablename']." EventDetail ON EventDetail.event_master_id = EventMaster.id
		WHERE EventMaster.deleted <> 1 AND EventMaster.event_control_id = ".$atim_controls['event_controls']['ca125']['event_control_id']."
		AND EventMaster.participant_id IN (".implode(',',$voas_to_participant_id).");";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		$participant_id_to_atim_ca125s[$row['participant_id']][$row['ca125']][$row['event_master_id']] = $row;
	}
	//Process
	$headers = array();
	$worksheet_name = $event_worksheet_name;
	$previous_voa = null;
	foreach($wroksheetcells[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers  = $new_line;
			$last_val = '';
			$last_key = 0;
			foreach($headers as $key => $val) {
				for($previous_key = ($last_key + 1); $previous_key < $key; $previous_key++) {
					$headers[$previous_key] = $last_val;
				}
				$last_val = $val;
				$last_key = $key;
			}
		} else if($excel_line_counter == 2) {
			foreach($new_line as $key => $val) {
				if(isset($headers[$key])) {
					$headers[$key] .= '::'.$val;
				} else {
					$headers[$key] = $val;
				}
			}
			ksort($headers);
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			//Get VOA
			$voa = null;
			if(!strlen($new_line_data['Patient Biobank Number (required)']) && $previous_voa) {
				$voa = $previous_voa;
			} else if($new_line_data['Patient Biobank Number (required)'] == '2237 (2390 blood)') {	
				$voa = '2237';
			} else if(preg_match('/^VOA([0-9]+)$/', $new_line_data['Patient Biobank Number (required)'], $matches)) {
				$voa = $matches[1];
				$previous_voa = $voa;
			} else if(preg_match('/^([0-9]+)$/', $new_line_data['Patient Biobank Number (required)'], $matches)) {
				$voa = $matches[1];
				$previous_voa = $voa;
			} else if(strlen($new_line_data['Patient Biobank Number (required)'])) {
				$summary_msg[$worksheet_name]['@@ERROR@@']["Unable to find VOA# from cell"][] = "Cell val = '".$new_line_data['Patient Biobank Number (required)']."'. No data will be migrated. [Worksheet: $worksheet_name /line: $excel_line_counter]";
				$previous_voa = null;
			}
			if($voa) {
				$participant_id = $voas_to_participant_id[$voa];
				if(!in_array($participant_id, $participant_ids_to_skip)) {
					$diagnosis_master_id = (isset($voa_to_diagnosis_master_id[$voa]) && $voa_to_diagnosis_master_id[$voa])? $voa_to_diagnosis_master_id[$voa] : null;
					$start_data = getDateAndAccuracy($worksheet_name, $new_line_data, $worksheet_name, 'Date of event (beginning)::Date', 'Date of event (beginning)::Accuracy', $excel_line_counter);
					$finish_data = getDateAndAccuracy($worksheet_name, $new_line_data, $worksheet_name, 'Date of event (end)::Date', 'Date of event (end)::Accuracy', $excel_line_counter);
					$drug_data_set = strlen($new_line_data['Chemotherapy Precision::Drug1'].$new_line_data['Chemotherapy Precision::Drug2'].$new_line_data['Chemotherapy Precision::Drug3'].$new_line_data['Chemotherapy Precision::Drug4'])? true : false;
					$ca125_data_set = strlen($new_line_data['CA125  Precision (U)'])? true : false;
					$scan_data_set = strlen($new_line_data['CT Scan Precision'])? true : false;
					switch($new_line_data['Event Type']) {
						case '':
							if($drug_data_set || $ca125_data_set || $scan_data_set || $start_data) die('ERR238327832732');
							break;
						// == chemotherapy ==
						case 'chemotherapy':
							if($ca125_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["CA125 linked to wrong event type"][] = "CA125 are associated to event ".$new_line_data['Event Type'].". CA125 data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							if($scan_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["CTScan result linked to wrong event type"][] = "CTScan are associated to event ".$new_line_data['Event Type'].". CTScan data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							$chemo_drugs = array();
							for($id=1; $id<5; $id++) {
								$drug = trim(str_replace(array('carboplatinum'), array('carboplatin'), strtolower($new_line_data["Chemotherapy Precision::Drug$id"])));
								if($drug == 'other') {
									$summary_msg[$worksheet_name]['@@WARNING@@']["Chemo Drug Value 'other'"][] = "A chemo drug was defined as 'other' for chemotherapy on on '".$start_data['date']."'. Value won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
								} else if(strlen($drug)) {
									if(!array_key_exists($drug, $drug_list)) die('ERR8237832732 '.$drug);
									$chemo_drugs[$drug] = $drug_list[$drug];
								}							
							}
							if(isset($participant_id_to_atim_chemos[$participant_id][$start_data['date']])) {
								if(sizeof($participant_id_to_atim_chemos[$participant_id][$start_data['date']]) > 1) die('ERR327328eesd 232 to support');
								$key = key($participant_id_to_atim_chemos[$participant_id][$start_data['date']]);
								$atim_tx_data = $participant_id_to_atim_chemos[$participant_id][$start_data['date']][$key];
								$treatment_master_id = $atim_tx_data['treatment_master_id'];
								//Update TreatmentMaster
								$master_data_to_update = array();
								$update_msg = array();
								if($start_data['date'] != $atim_tx_data['start_date']) die('ERR 2823797329 7297'); //Suppose to be the same
								if($start_data['accuracy'] != $atim_tx_data['start_date_accuracy']) {
									$master_data_to_update[] = "start_date_accuracy = '".$start_data['accuracy']."'";
									$summary_msg[$worksheet_name]['@@WARNING@@']["Chemotherapy Start Date Accuracy"][] = "An ATiM chemotherapy matched a file chemotherapy based on voa# and start date '".$start_data['date']."' but the  accuracy values are different (".$start_data['accuracy']." != ".$atim_tx_data['start_date_accuracy']."). Accuracy will be updated. Please check after migration. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									$summary_msg['Data Creation/Update Summary'][$participant_id]["Changed chemo start date accurcy"][] = "Changed start date accuracy (from ".$atim_tx_data['start_date_accuracy']." to ".$start_data['accuracy'].") for a chemotherapy started on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									$participant_id_to_atim_chemos[$participant_id][$start_data['date']][$key]['start_date_accuracy'] = $start_data['accuracy'];
								}
								if($finish_data['date'] != $atim_tx_data['finish_date'] || $finish_data['accuracy'] != $atim_tx_data['finish_date_accuracy']) {
									$master_data_to_update[] = "finish_date = '".$finish_data['date']."', finish_date_accuracy = '".$finish_data['accuracy']."'";
									$summary_msg[$worksheet_name]['@@ERROR@@']["Chemotherapy Finish Date"][] = "An ATiM chemotherapy matched a file chemotherapy based on voa# and start date '".$start_data['date']."' but the finish dates are different (".$finish_data['date']." (".$finish_data['accuracy'].") != ".$atim_tx_data['finish_date']." (".$atim_tx_data['finish_date_accuracy'].")). Finish Date will be updated. Please check after migration. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									$summary_msg['Data Creation/Update Summary'][$participant_id]["Changed chemo end date"][] = "Changed end date (from ".$atim_tx_data['finish_date']." (".$atim_tx_data['finish_date_accuracy'].") to ".$finish_data['date']." (".$finish_data['accuracy'].")) for a chemotherapy started on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									$participant_id_to_atim_chemos[$participant_id][$start_data['date']][$key]['finish_date'] = $finish_data['date'];
									$participant_id_to_atim_chemos[$participant_id][$start_data['date']][$key]['finish_date_accuracy'] = $finish_data['accuracy'];
								}
								if($diagnosis_master_id) {
									$update_diagnosis_master_id = false;
									if(!$atim_tx_data['diagnosis_master_id']) {
										$update_diagnosis_master_id = true;
										$summary_msg['Data Creation/Update Summary'][$participant_id]["Linked a chemotherapy to diagnosis"][] = "Linked chemotherapy started on '".$start_data['date']."' to a diagnosis. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									} else if($atim_tx_data['diagnosis_master_id'] != $diagnosis_master_id) {
										$update_diagnosis_master_id = true;
										$summary_msg['Data Creation/Update Summary'][$participant_id]["Changed the diagnosis linked to a chemotherapy"][] = "Linked chemotherapy started on '".$start_data['date']."' to another diagnosis (atim id ".$atim_tx_data['diagnosis_master_id']." to $diagnosis_master_id) . See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									}
									if($update_diagnosis_master_id) {
										$master_data_to_update[] = "diagnosis_master_id = '$diagnosis_master_id'";
										$participant_id_to_atim_chemos[$participant_id][$start_data['date']][$key]['diagnosis_master_id'] = $diagnosis_master_id;
									}
								}
								if($master_data_to_update) {
									$master_data_to_update[] = "modified = '$modified', modified_by = '$modified_by'";
									$master_data_to_update = implode(',',$master_data_to_update);
									$query = "UPDATE treatment_masters SET $master_data_to_update WHERE id = $treatment_master_id";
									mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
									$query ="INSERT INTO treatment_masters_revs (id,participant_id,treatment_control_id,start_date,start_date_accuracy,finish_date,finish_date_accuracy,notes,diagnosis_master_id,modified_by, version_created)
										(SELECT id,participant_id,treatment_control_id,start_date,start_date_accuracy,finish_date,finish_date_accuracy,notes,diagnosis_master_id,modified_by,modified FROM treatment_masters WHERE id = $treatment_master_id);";
									mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
									$query ="INSERT INTO txd_chemos_revs (treatment_master_id,version_created) VALUES ($treatment_master_id, '$modified');";
									mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
								}
								//Add Treatment Extend
								$surgical_procedure_already_recorded = false;
								foreach($chemo_drugs as $drug_name => $drug_id) {
									if(!in_array($drug_name, $atim_tx_data['drugs'])) {
										$treatment_extend_master_id = customInsertRecord(array('treatment_master_id' => $treatment_master_id,'treatment_extend_control_id' => $atim_controls['treatment_controls']['chemotherapy']['te_treatment_control_id']), 'treatment_extend_masters', false, true);
										customInsertRecord(array('treatment_extend_master_id' => $treatment_extend_master_id, 'drug_id' => $drug_id), $atim_controls['treatment_controls']['chemotherapy']['te_detail_tablename'], true, true);
										$summary_msg['Data Creation/Update Summary'][$participant_id]["Added new chemotherapy drug"][] = "Added '$drug_name' to chemotherapy started on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";			
										$participant_id_to_atim_chemos[$participant_id][$start_data['date']][$treatment_master_id]['drugs'][$drug_name] = $drug_name;
									}
								}
							} else {
								//Add Treatment
								$master_data = array(
									'participant_id' => $participant_id,
									'diagnosis_master_id' => $diagnosis_master_id,
									'treatment_control_id' => $atim_controls['treatment_controls']['chemotherapy']['treatment_control_id'],
									'start_date' => $start_data['date'],
									'start_date_accuracy' => $start_data['accuracy'],
									'finish_date' =>  $finish_data['date'],
									'finish_date_accuracy' =>  $finish_data['accuracy']);						
								$treatment_master_id = customInsertRecord($master_data, 'treatment_masters', false, true);
								customInsertRecord(array('treatment_master_id' => $treatment_master_id), $atim_controls['treatment_controls']['chemotherapy']['detail_tablename'], true, true);			
								//Add Treatment Extend
								foreach($chemo_drugs as $drug => $drug_id) {
									$treatment_extend_master_id = customInsertRecord(array('treatment_master_id' => $treatment_master_id,'treatment_extend_control_id' => $atim_controls['treatment_controls']['chemotherapy']['te_treatment_control_id']), 'treatment_extend_masters', false, true);
									customInsertRecord(array('treatment_extend_master_id' => $treatment_extend_master_id, 'drug_id' => $drug_id), $atim_controls['treatment_controls']['chemotherapy']['te_detail_tablename'], true, true);
								}
								//Keep creation in memory
								$participant_id_to_atim_chemos[$participant_id][$start_data['date']][$treatment_master_id] = 
									array('treatment_master_id' => $treatment_master_id,
										'participant_id' => $participant_id,
										'diagnosis_master_id' => $diagnosis_master_id,
										'start_date' => $start_data['date'],
										'start_date_accuracy' =>  $start_data['accuracy'],
										'finish_date' =>  $finish_data['date'],
										'finish_date_accuracy' =>  $finish_data['accuracy'],
										'drugs' => array());
								foreach($chemo_drugs as $drug => $id) $participant_id_to_atim_chemos[$participant_id][$start_data['date']][$treatment_master_id]['drugs'][$drug] = $drug;
								$summary_msg['Data Creation/Update Summary'][$participant_id]["Chemotherapy Creation"][] = "Created chemotherapy on '".$start_data['date']."' with drugs list {".implode(', ',array_keys($chemo_drugs))."}. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							}
							break;
						// == procedure - surgery and biopsy ==
						case 'surgery(ovarectomy)':
						case 'surgery(other)':
						case 'biopsy':
							if($drug_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["Durgs linked to wrong event type"][] = "Drugs are associated to event ".$new_line_data['Event Type'].". Drug data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							if($ca125_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["CA125 linked to wrong event type"][] = "CA125 are associated to event ".$new_line_data['Event Type'].". CA125 data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							if($scan_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["CTScan result linked to wrong event type"][] = "CTScan are associated to event ".$new_line_data['Event Type'].". CTScan data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							$surgical_procedure = str_replace(array('biopsy', 'surgery(other)', 'surgery(ovarectomy)'), array('unspecified biopsy', 'unspecified surgery', 'ovarectomy'), $new_line_data['Event Type']);
							$residual_disease = '';
							if(isset($tmp_voa_to_residual_disease[$voa]) && $surgical_procedure == 'ovarectomy') {
								$residual_disease = $tmp_voa_to_residual_disease[$voa];
								unset($tmp_voa_to_residual_disease[$voa]);
								if(!in_array($residual_disease, array('', "macroscopic","1-2cm","<1cm",">2cm","miliary","none","suboptimal","unknown","yes unknown"))) die('ERR23873283278732');							
							}
							if(isset($participant_id_to_atim_surgery_biopsy[$participant_id][$start_data['date']])) {
								if(sizeof($participant_id_to_atim_surgery_biopsy[$participant_id][$start_data['date']]) > 1) {			
									$summary_msg[$worksheet_name]['@@WARNING@@']["2 surgeries or biopsy on same date"][] = "Migration process detected 2 biopsy or surgery on same date (".$start_data['date']."). Please check and confirm no migration error has been done. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
								}
								reset($participant_id_to_atim_surgery_biopsy[$participant_id][$start_data['date']]);
								$key = key($participant_id_to_atim_surgery_biopsy[$participant_id][$start_data['date']]);
								$atim_tx_data = $participant_id_to_atim_surgery_biopsy[$participant_id][$start_data['date']][$key];
								$treatment_master_id = $atim_tx_data['treatment_master_id'];
								//Update TreatmentDetail
								$update_residual_disease = false;
								if($residual_disease) {
									if(!$atim_tx_data['ovcare_residual_disease']) {
										$update_residual_disease = true;
										$summary_msg['Data Creation/Update Summary'][$participant_id]["Recorded residual disease"][] = "Set residual disease '$residual_disease' for $surgical_procedure on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									} else if($atim_tx_data['ovcare_residual_disease'] != $residual_disease) {
										$update_residual_disease = true;
										$summary_msg['Data Creation/Update Summary'][$participant_id]["Updated residual disease"][] = "Changed residual disease '".$atim_tx_data['ovcare_residual_disease']."'  to '$residual_disease' for $surgical_procedure on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									}
									if($update_residual_disease) {
										$query = "UPDATE ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['detail_tablename']." SET ovcare_residual_disease = '".$residual_disease."' WHERE treatment_master_id = $treatment_master_id";
										mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));								
										$participant_id_to_atim_surgery_biopsy[$participant_id][$start_data['date']][$key]['ovcare_residual_disease'] = $residual_disease;
									}									
								}
								//Update TreatmentMaster
								if($start_data['date'] != $atim_tx_data['start_date']) die('ERR 2823797329 7297'); //Suppose to be the same
								if($start_data['accuracy'] != $atim_tx_data['start_date_accuracy']) die('ERR to support 327238328');
								$master_data_to_update = array();
								if($update_residual_disease) $master_data_to_update['modified'] = "modified = '$modified', modified_by = '$modified_by'";
								if($diagnosis_master_id) {
									$update_diagnosis_master_id = false;
									if(!$atim_tx_data['diagnosis_master_id']) {
										$update_diagnosis_master_id = true;
										$summary_msg['Data Creation/Update Summary'][$participant_id]["Linked a surgery to diagnosis"][] = "Linked $surgical_procedure on '".$start_data['date']."' to a diagnosis. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									} else if($atim_tx_data['diagnosis_master_id'] != $diagnosis_master_id) {
										$update_diagnosis_master_id = true;
										$summary_msg['Data Creation/Update Summary'][$participant_id]["Changed the diagnosis linked to a surgery"][] = "Linked $surgical_procedure on '".$start_data['date']."' to another diagnosis (atim id ".$atim_tx_data['diagnosis_master_id']." to $diagnosis_master_id) . See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									}
									if($update_diagnosis_master_id) {
										$master_data_to_update['modified'] = "modified = '$modified', modified_by = '$modified_by'";
										$master_data_to_update['$diagnosis_master_id'] = "diagnosis_master_id = '$diagnosis_master_id'";
										$participant_id_to_atim_surgery_biopsy[$participant_id][$start_data['date']][$key]['diagnosis_master_id'] = $diagnosis_master_id;
									}	
								}
								if(!empty($master_data_to_update)) {
									$master_data_to_update = implode(', ', $master_data_to_update);
									$query = "UPDATE treatment_masters SET $master_data_to_update WHERE id = $treatment_master_id";
									mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
								}
								//Add Treatment Extend
								$surgical_procedure_already_recorded = false;
								foreach($atim_tx_data['surgical_procedures'] as $atim_surgical_procedure) if($atim_surgical_procedure == $surgical_procedure) $surgical_procedure_already_recorded = true;
								if(!$surgical_procedure_already_recorded) {
									$treatment_extend_master_id = customInsertRecord(array('treatment_master_id' => $treatment_master_id,'treatment_extend_control_id' => $atim_controls['treatment_controls']['procedure - surgery and biopsy']['te_treatment_control_id']), 'treatment_extend_masters', false, true);
									customInsertRecord(array('treatment_extend_master_id' => $treatment_extend_master_id, 'surgical_procedure' => $surgical_procedure), $atim_controls['treatment_controls']['procedure - surgery and biopsy']['te_detail_tablename'], true, true);
									$summary_msg['Data Creation/Update Summary'][$participant_id]["Created new Surgery/Biopsy Procedure Performed"][] = "Added '$surgical_procedure' to Procedures Performed list for surgery/biopsy on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
								}
							} else {
								//Add Treatment
								$master_data = array(
									'participant_id' => $participant_id,
									'diagnosis_master_id' => $diagnosis_master_id,
									'treatment_control_id' => $atim_controls['treatment_controls']['procedure - surgery and biopsy']['treatment_control_id'],
									'start_date' => $start_data['date'],
									'start_date_accuracy' => $start_data['accuracy']);						
								$treatment_master_id = customInsertRecord($master_data, 'treatment_masters', false, false);
								customInsertRecord(array('treatment_master_id' => $treatment_master_id, 'ovcare_residual_disease' => $residual_disease), $atim_controls['treatment_controls']['procedure - surgery and biopsy']['detail_tablename'], true, false);		
								//Add Treatment Extend
								$treatment_extend_master_id = customInsertRecord(array('treatment_master_id' => $treatment_master_id,'treatment_extend_control_id' => $atim_controls['treatment_controls']['procedure - surgery and biopsy']['te_treatment_control_id']), 'treatment_extend_masters', false, true);
								customInsertRecord(array('treatment_extend_master_id' => $treatment_extend_master_id, 'surgical_procedure' => $surgical_procedure), $atim_controls['treatment_controls']['procedure - surgery and biopsy']['te_detail_tablename'], true, true);
								//Keep creation in memory
								$participant_id_to_atim_surgery_biopsy[$participant_id][$start_data['date']][$treatment_master_id] = 
									array('treatment_master_id' => $treatment_master_id,
										'participant_id' => $participant_id,
										'diagnosis_master_id' => $diagnosis_master_id,
										'start_date' => $start_data['date'],
										'start_date_accuracy' =>  $start_data['accuracy'],
										'finish_date' => null,
										'finish_date_accuracy' => null,
										'ovcare_residual_disease' => $residual_disease,
										'surgical_procedures' => array($surgical_procedure => $surgical_procedure));
								$summary_msg['Data Creation/Update Summary'][$participant_id]["Surgery/Biopsy Creation"][] = "Created $surgical_procedure on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							}
							break;
						// == ct scan ==
						case 'CA125':
							if($drug_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["Durgs linked to wrong event type"][] = "Drugs are associated to event ".$new_line_data['Event Type'].". Drug data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							if($scan_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["CTScan result linked to wrong event type"][] = "CTScan are associated to event ".$new_line_data['Event Type'].". CTScan data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							$ca125_value = $new_line_data['CA125  Precision (U)'];
							if(!strlen($ca125_value)) {
								$summary_msg[$worksheet_name]['@@ERROR@@']["CA125 value empty"][] = "No CA125 Value is set for an event on '".$start_data['date']."'. No CA125 will be created. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							} else if(!preg_match('/^[0-9]+\.[0-9]{2}$/', $ca125_value)){
								$summary_msg[$worksheet_name]['@@ERROR@@']["Wrong CA125 value format"][] = "Format of CA125 Value '$ca125_value' is wrong. No CA125 will be created. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							} else {
								$event_master_id_to_update = null;
								$diagnosis_master_id_of_event_to_update = null;
								if(isset($participant_id_to_atim_ca125s[$participant_id]) && array_key_exists($ca125_value, $participant_id_to_atim_ca125s[$participant_id])) {
									foreach($participant_id_to_atim_ca125s[$participant_id][$ca125_value] as $key => $event_data) {
										if(empty($event_data['event_date'])) {
											$event_master_id_to_update = $event_data['event_master_id'];
											$participant_id_to_atim_ca125s[$participant_id][$ca125_value][$key]['event_date'] = $start_data['date'];
											$participant_id_to_atim_ca125s[$participant_id][$ca125_value][$key]['event_date_accuracy'] =  $start_data['accuracy'];
											$summary_msg['Data Creation/Update Summary'][$participant_id]["Set date to an existing ATiM CA125"][] = "The test of an existing CA125 = [$ca125_value] has been set to '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
											$diagnosis_master_id_of_event_to_update = $event_data['diagnosis_master_id'];
											break;
										}
									}
								}
								if(isset($ca125_progression_diagnosis_master_id[$voa]) && array_key_exists($start_data['date'], $ca125_progression_diagnosis_master_id[$voa])) {
									$diagnosis_master_id = $ca125_progression_diagnosis_master_id[$voa][$start_data['date']];
									$summary_msg['Data Creation/Update Summary'][$participant_id]["Linked a CA125 value to a diagnosis progression"][] = "CA125 on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
								} else if($diagnosis_master_id && $event_master_id_to_update) {
									if(!$diagnosis_master_id_of_event_to_update) {
										$summary_msg['Data Creation/Update Summary'][$participant_id]["Linked existing CA125 to diagnosis"][] = "Linked CA125 on '".$start_data['date']."' to a diagnosis. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									} else if($diagnosis_master_id_of_event_to_update != $diagnosis_master_id) {
										$summary_msg['Data Creation/Update Summary'][$participant_id]["Changed diagnosis linked to CA125"][] = "Linked CA125 on '".$start_data['date']."' to another diagnosis (atim id $diagnosis_master_id_of_event_to_update to $diagnosis_master_id) . See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
									}
								}
								if($event_master_id_to_update) {
									$data_to_update = array("modified = '$modified', modified_by = '$modified_by'");
									$data_to_update[] = "event_date = '".$start_data['date']."', event_date_accuracy = '".$start_data['accuracy']."'";
									if($diagnosis_master_id) $data_to_update[] = "diagnosis_master_id = $diagnosis_master_id";
									$data_to_update = implode(',', $data_to_update);
									$query = "UPDATE event_masters SET $data_to_update WHERE id = $event_master_id_to_update";
									mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
									$query ="INSERT INTO event_masters_revs (id,event_control_id,event_summary,event_date,event_date_accuracy,participant_id,diagnosis_master_id,modified_by,version_created) 
										(SELECT id,event_control_id,event_summary,event_date,event_date_accuracy,participant_id,diagnosis_master_id,modified_by,modified FROM event_masters WHERE id = $event_master_id_to_update);";
									mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
									$query ="INSERT INTO ovcare_ed_ca125s_revs (event_master_id,ca125,version_created) VALUES ($event_master_id_to_update, '$ca125_value', '$modified');";
									mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
								} else {
									$master_data = array('participant_id' => $participant_id, 
										'diagnosis_master_id' => $diagnosis_master_id, 
										'event_control_id' => $atim_controls['event_controls']['ca125']['event_control_id'], 
										'event_date' => $start_data['date'], 
										'event_date_accuracy' => $start_data['accuracy']);
									$event_master_id = customInsertRecord($master_data, 'event_masters', false, true);
									customInsertRecord(array('event_master_id' => $event_master_id, 'ca125' => $ca125_value), $atim_controls['event_controls']['ca125']['detail_tablename'], true, true);
									$summary_msg['Data Creation/Update Summary'][$participant_id]["Added CA125 value"][] = "Recorded CA125 = [$ca125_value] on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
								}
							}
							break;
						// == ct scan ==
						case 'CT scan':
							if($drug_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["Durgs linked to wrong event type"][] = "Drugs are associated to event ".$new_line_data['Event Type'].". Drug data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							if($ca125_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["CA125 linked to wrong event type"][] = "CA125 are associated to event ".$new_line_data['Event Type'].". CA125 data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							if(!in_array($new_line_data['CT Scan Precision'], array('', 'negative', 'positive', 'unknown'))) {
								$new_line_data['CT Scan Precision'] = '';
								$summary_msg[$worksheet_name]['@@ERROR@@']["Wrong CT-Scan result"][] = "The format of a CT-Scan result '".$new_line_data['CT Scan Precision']."' is wrong. Value won't be recorded. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							}
							if(strlen($start_data['date'].$new_line_data['CT Scan Precision'])) {
								$master_data = array('participant_id' => $participant_id,
									'diagnosis_master_id' => $diagnosis_master_id,
									'event_control_id' => $atim_controls['event_controls']['ct scan']['event_control_id'],
									'event_date' => $start_data['date'],
									'event_date_accuracy' => $start_data['accuracy']);
								$event_master_id = customInsertRecord($master_data, 'event_masters', false, true);
								customInsertRecord(array('event_master_id' => $event_master_id, 'result' => $new_line_data['CT Scan Precision']), $atim_controls['event_controls']['ct scan']['detail_tablename'], true, true);
								$summary_msg['Data Creation/Update Summary'][$participant_id]["CT-Scan creation"][] = "CT-Scan with result = [".$new_line_data['CT Scan Precision']."] on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							}
							break;
						default:
							die('ERR327328732832 '.$new_line_data['Event Type'].$excel_line_counter);
					}
				}
			}
		}
	}
	foreach($tmp_voa_to_residual_disease as $voa => $residual_disease) {
		if($residual_disease) {
			$summary_msg[$worksheet_name]['@@ERROR@@']["Unrecorded residual disease"][] = "Residual disease '$residual_disease' set for an ovarectomy (of the patient voa#".$voa.") can not be recorded because no ovarectomy has been defined/created. Please check. See ATiM participant_id $participant_id (VOA#$voa).";
		}
	}
}

function getATiMTumorSites() {
	global $db_connection;
	$data = array();
	$query = "SELECT value 
		FROM structure_value_domains dom
		INNER JOIN structure_value_domains_permissible_values link ON dom.id = link.structure_value_domain_id
		INNEr JOIN structure_permissible_values val ON val.id = link.structure_permissible_value_id
		WHERE domain_name='ovcare_tumor_site';";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$data[] = $row['value'];
	}
	return $data;
}

function getDrugList() {
	global $db_connection;
	$existing_drugs = array();
	$query = "SELECT id, generic_name FROM drugs;";	
	$results = mysqli_query($db_connection, $query) or die("Main [line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		$existing_drugs[strtolower($row['generic_name'])] = $row['id'];
	}
	foreach(array('Paclitaxel','Ectoposide','Doxorubicin','Cisplatinum','Gemcitabine','Topotecan','Doxetaxel','Vinorelbine','Oxaliplatinum','Cyclophosphamide') as $new_generic_name) {
		if(!isset($existing_drugs[strtolower($new_generic_name)])) {
			$drug_id = customInsertRecord(array('generic_name' => $new_generic_name), 'drugs', false, true);
			$existing_drugs[strtolower($new_generic_name)] = $drug_id;
		}
	}
	return $existing_drugs;
}

?>