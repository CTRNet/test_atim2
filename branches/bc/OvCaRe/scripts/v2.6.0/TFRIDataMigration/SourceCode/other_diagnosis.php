<?php

function updateOtherDiagnosis(&$wroksheetcells, $sheets_keys, $dx_worksheet_name, $event_worksheet_name, $atim_controls, $all_patients_worksheet_voas, &$participant_ids_to_skip) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;
	global $voas_to_participant_id;
	
	// Set variables for progressions
	
	$allowed_tumor_sites = getATiMTumorSites();
	$progression_summary_msg_key = $dx_worksheet_name.' - Progression';
	
	// Set variables for treatment
	
	$drug_list = getDrugList();
	$tmp_voa_to_residual_disease = array();
	
	// ***** DX *****
	
	$headers = array();
	$worksheet_name = $dx_worksheet_name;
	$voa_to_diagnosis_master_id = array();
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
			if(strlen($new_line_data['Tumor Site'])) {
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
					$participant_id = $voas_to_participant_id[$voa];
					if(!in_array($participant_id, $participant_ids_to_skip)) {
						//Note: Only other dx 'unknown' are into ATiM... will create all
						//Get Excel File Data
						$file_diagnosis_data = array();
						$dxd_data = getDateAndAccuracy($worksheet_name, $new_line_data, $worksheet_name, 'Date of Diagnosis::Date', 'Date of Diagnosis::Accuracy', $excel_line_counter);
						if($dxd_data) {
							$file_diagnosis_data['DiagnosisMaster.dx_date'] = $dxd_data['date'];
							$file_diagnosis_data['DiagnosisMaster.dx_date_accuracy'] = $dxd_data['accuracy'];
						}
						$ovcare_tumor_site = strtolower($new_line_data['Tumor Site']);
						if(!in_array($ovcare_tumor_site, $allowed_tumor_sites)) die('ERR3773828929202020 '.$ovcare_tumor_site);
						$file_diagnosis_data['DiagnosisMaster.ovcare_tumor_site'] = $ovcare_tumor_site;
						$laterality = str_replace('not applicable', '', $new_line_data['Laterality']);
						if(!in_array($laterality, array('right', "left", "bilateral", "unknown", ''))) die('ERR3773828929202023 '.$laterality);
						$file_diagnosis_data['DiagnosisDetail.laterality'] = $laterality;
						$file_diagnosis_data['DiagnosisDetail.histopathology'] = $new_line_data['Histopathology'];
						$file_diagnosis_data['DiagnosisMaster.tumour_grade'] = $new_line_data['Grade'];
						$file_diagnosis_data['DiagnosisDetail.stage'] = $new_line_data['Stage'];
						//create new diagnosis
						$dx_data = array(
							'DiagnosisMaster' => array(
								'participant_id' => $participant_id,
								'diagnosis_control_id'=>$atim_controls['diagnosis_control_ids']['primary']['other']['id']),
							'DiagnosisDetail' => array());
						foreach($file_diagnosis_data as $db_model_and_field => $file_value) {
							preg_match('/^([a-zA-Z]+)\.([a-zA-Z_]+)$/', $db_model_and_field, $matches);
							$db_model = $matches[1];
							if(!in_array($db_model, array('DiagnosisMaster','DiagnosisDetail'))) die('ERR32732783272837 '.$db_model);
							$db_field = $matches[2];
							$dx_data[$db_model][$db_field] = $file_value;
						}
						$diagnosis_master_id = customInsertRecord($dx_data['DiagnosisMaster'], 'diagnosis_masters', false, true);
						$query = "UPDATE diagnosis_masters SET primary_id = $diagnosis_master_id WHERE id = $diagnosis_master_id";
						mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
						$query = "UPDATE diagnosis_masters_revs SET primary_id = $diagnosis_master_id WHERE id = $diagnosis_master_id";
						mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
						$dx_data['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
						customInsertRecord($dx_data['DiagnosisDetail'], $atim_controls['diagnosis_control_ids']['primary']['other']['detail_tablename'], true, true);
						$summary_msg['Data Creation/Update Summary'][$participant_id]["New Other Primary Diagnosis"][] = "See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
						$voa_to_diagnosis_master_id[$voa] = $diagnosis_master_id;
						// Track Progression
						$new_line_data['Date of Progression/Recurrence::Date'] = str_replace('unknown', '', $new_line_data['Date of Progression/Recurrence::Date']);
						if(strlen($new_line_data['Date of Progression/Recurrence::Date'].$new_line_data['Date of Progression/Recurrence::Accuracy'].$new_line_data['Site of Tumor Progression (metastasis)  If Applicable'])) {
							$date_data = getDateAndAccuracy($progression_summary_msg_key, $new_line_data, $worksheet_name, 'Date of Progression/Recurrence::Date', 'Date of Progression/Recurrence::Accuracy', $excel_line_counter);
							if(!$date_data) {
								if(strlen($new_line_data['Date of Progression/Recurrence::Date'])) $summary_msg[$worksheet_name]['@@ERROR@@']["Secondary Diagnosis Date Error"][] = "Migration process is unable to get Progression date from value '".$new_line_data['Date of Progression/Recurrence::Date']."'. No date will be associated to the created secondary diagnosis. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
								$date_data = array('date'=>null, 'accuracy'=>null, 'site'=>null);
							}
							$site = strtolower($new_line_data['Site of Tumor Progression (metastasis)  If Applicable']);
							if(!in_array($site, $allowed_tumor_sites))	die("ERR 772873298327982932eee7 = $site");
							if(empty($site)) die('ERR23732328328329');
							$master_data = array(
								'participant_id' => $participant_id,
								'primary_id' => $diagnosis_master_id,
								'parent_id' => $diagnosis_master_id,
								'diagnosis_control_id' => $atim_controls['diagnosis_control_ids']['secondary']['all']['id'],
								'dx_date' => $date_data['date'],
								'dx_date_accuracy' => $date_data['accuracy'],
								'ovcare_tumor_site' => $site);
							$diagnosis_master_id = customInsertRecord($master_data, 'diagnosis_masters', false, true);
							customInsertRecord(array('diagnosis_master_id' => $diagnosis_master_id), $atim_controls['diagnosis_control_ids']['secondary']['all']['detail_tablename'], true, true);
						}						
					}
				}
			}
		}
	}
	
	// ***** EOC - Event *****
	
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
			krsort($headers);
			$last_key_line_1 = key($headers);
			$last_valueline_1 = $headers[$last_key_line_1];
			foreach($new_line as $key => $val) {
				if(isset($headers[$key])) {
					$headers[$key] .= '::'.$val;
				} else if($key > $last_key_line_1) {
					$headers[$key] = $last_valueline_1.'::'.$val;
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
					switch($new_line_data['Event Type']) {
						case '':
							if($drug_data_set) die('ERR238327832732');
							break;
						// == chemotherapy ==
						case 'chemotherapy':
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
							$summary_msg['Data Creation/Update Summary'][$participant_id]["Chemotherapy Creation For Other Dx"][] = "Created chemotherapy on '".$start_data['date']."' with drugs list {".implode(', ',array_keys($chemo_drugs))."}. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							break;
						// == procedure - surgery and biopsy ==
						case 'surgery':
						case 'biopsy':
							if($drug_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["Drugs linked to wrong event type"][] = "Drugs are associated to event ".$new_line_data['Event Type'].". Drug data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							$surgical_procedure = str_replace(array('biopsy', 'surgery'), array('unspecified biopsy', 'unspecified surgery'), $new_line_data['Event Type']);
							//Add Treatment
							$master_data = array(
								'participant_id' => $participant_id,
								'diagnosis_master_id' => $diagnosis_master_id,
								'treatment_control_id' => $atim_controls['treatment_controls']['procedure - surgery and biopsy']['treatment_control_id'],
								'start_date' => $start_data['date'],
								'start_date_accuracy' => $start_data['accuracy']);						
							$treatment_master_id = customInsertRecord($master_data, 'treatment_masters', false, false);
							customInsertRecord(array('treatment_master_id' => $treatment_master_id), $atim_controls['treatment_controls']['procedure - surgery and biopsy']['detail_tablename'], true, false);			
							//Add Treatment Extend
							$treatment_extend_master_id = customInsertRecord(array('treatment_master_id' => $treatment_master_id,'treatment_extend_control_id' => $atim_controls['treatment_controls']['procedure - surgery and biopsy']['te_treatment_control_id']), 'treatment_extend_masters', false, true);
							customInsertRecord(array('treatment_extend_master_id' => $treatment_extend_master_id, 'surgical_procedure' => $surgical_procedure), $atim_controls['treatment_controls']['procedure - surgery and biopsy']['te_detail_tablename'], true, true);
							$summary_msg['Data Creation/Update Summary'][$participant_id]["Surgery/Biopsy Creation For Other Dx"][] = "Created $surgical_procedure on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							break;
						// == radiotherapy == hormonal therapy ==
						case 'radiotherapy':
						case 'hormonal therapy':
							if($drug_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["Durgs linked to wrong event type"][] = "Drugs are associated to event ".$new_line_data['Event Type'].". Drug data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							$tx_method = str_replace('radiotherapy', 'radiation', $new_line_data['Event Type']);
							//Add Treatment
							$master_data = array(
								'participant_id' => $participant_id,
								'diagnosis_master_id' => $diagnosis_master_id,
								'treatment_control_id' => $atim_controls['treatment_controls'][$tx_method]['treatment_control_id'],
								'start_date' => $start_data['date'],
								'start_date_accuracy' => $start_data['accuracy']);
							$treatment_master_id = customInsertRecord($master_data, 'treatment_masters', false, false);
							customInsertRecord(array('treatment_master_id' => $treatment_master_id), $atim_controls['treatment_controls'][$tx_method]['detail_tablename'], true, false);
							$summary_msg['Data Creation/Update Summary'][$participant_id]["$tx_method Creation For Other Dx"][] = "Created $tx_method on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							break;
						// == radiology ==
						case 'radiology':
							if($drug_data_set) $summary_msg[$worksheet_name]['@@ERROR@@']["Durgs linked to wrong event type"][] = "Drugs are associated to event ".$new_line_data['Event Type'].". Drug data won't be migrated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							$master_data = array('participant_id' => $participant_id,
								'diagnosis_master_id' => $diagnosis_master_id,
								'event_control_id' => $atim_controls['event_controls']['radiology']['event_control_id'],
								'event_date' => $start_data['date'],
								'event_date_accuracy' => $start_data['accuracy']);
							$event_master_id = customInsertRecord($master_data, 'event_masters', false, true);
							customInsertRecord(array('event_master_id' => $event_master_id), $atim_controls['event_controls']['radiology']['detail_tablename'], true, true);
							$summary_msg['Data Creation/Update Summary'][$participant_id]["Radiology creation For Other Dx"][] = "Radiology on '".$start_data['date']."'. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
							break;
						default:
							$summary_msg[$worksheet_name]['@@ERROR@@']["Unknown Event Type"][] = "Event Type = '".$new_line_data['Event Type']."' is not supported. No data will be migrated. [Worksheet: $worksheet_name /line: $excel_line_counter]";
					}
				}
			}
		}
	}
}


?>