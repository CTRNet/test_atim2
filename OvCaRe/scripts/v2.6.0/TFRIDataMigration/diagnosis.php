<?php

function updateOvaryEndometriumDiagnosis(&$wroksheetcells, $sheets_keys, $dx_worksheet_name, $event_worksheet_name, $atim_controls, $all_studied_voas, &$participant_id_to_skip) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;
	global $voas_to_participant_id;
		
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
				if(!in_array($voa,$all_studied_voas)) die('ERR 237328832832 voa'.$voa);
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
					FROM diagnosis_masters DiagnosisMaster INNER JOIN ovcare_dxd_ovaries_endometriums DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
					WHERE DiagnosisMaster.participant_id = $participant_id AND DiagnosisMaster.deleted <> 1 
					AND DiagnosisMaster.diagnosis_control_id = ".$atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium tumor']['id'].";";
				$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				$atim_diagnosis_data = null;
				if($results->num_rows > 1) {
					$summary_msg['Un-migrated VOA#s']['@@WARNING@@']["Reason: More than one Ovarian/Endometrium primary into ATiM"]["$participant_id-$voa"] = "The migration process won't be able to match the excel diagnosis to one of the ATiM diagnoses: See atim patient id $participant_id (VOA#:$voa). [Worksheet: $worksheet_name]";
					ksort($summary_msg['Un-migrated VOA#s']['@@WARNING@@']["Reason: More than one Ovarian/Endometrium primary into ATiM"]);
					$summary_msg['Un-migrated VOA#s']['@@ERROR@@']["Un-migrated VOA#s (Data to enter manually into ATiM after migration process)"][$voa] = "VOA#$voa (ATiM participant_id = $participant_id)";
					$participant_id_to_skip[] = $participant_id;
				} else if($results->num_rows == 1) {
					$atim_diagnosis_data = $results->fetch_assoc();
				}
				if(!in_array($participant_id, $participant_id_to_skip)) {
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
						list($file_field, $db_field, $allowed_values) = $field_properties;
						$new_line_data[$file_field] = str_replace('not applicable','',$new_line_data[$file_field]);
						if(strlen($new_line_data[$file_field])) {
							if(!in_array($new_line_data[$file_field], $allowed_values)) die('ERR2387328 7872872832732');
							$file_diagnosis_data[$db_field] = $new_line_data[$file_field];
							$file_dx_data_strg[$db_field] = "$file_field = <b>".$new_line_data[$file_field].'</b>';
						}
					}
					//Manage Dx Data
					if(empty($atim_diagnosis_data)) {
						if(empty($file_diagnosis_data)) {
							$summary_msg[$worksheet_name]['@@WARNING@@']["No Diagnosis Data in ATiM and Excel"][] = "No diagnosis will be created. See atim patient id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";						
						} else {
							//create new diagnosis
							$dx_data = array(
								'DiagnosisMaster' => array(
									'participant_id' => $participant_id, 
									'diagnosis_control_id'=>$atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium tumor']['id']), 
								'DiagnosisDetail' => array());
							foreach($file_diagnosis_data as $field => $file_value) {
								preg_match('/^([a-zA-Z]+)\.([a-zA-Z_]+)$/', $field, $matches);
								if(!in_array($matches[1], array_keys($dx_data))) die('ERR737328839932');
								$dx_data[$matches[1]][$matches[2]] = $file_value;
							}
							pr($file_diagnosis_data);
							pr($dx_data);
							exit;
							$diagnosis_master_id = customInsertRecord($dx_data['DiagnosisMaster'], 'diagnosis_masters');
							$dx_data['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
							customInsertRecord($dx_data['DiagnosisDetail'], $atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium tumor']['detail_tablename'], true);
							$voa_to_diagnosis_master_id[$voa] = $diagnosis_master_id;
							$file_dx_data_strg = implode(' & ', $file_dx_data_strg);
							$summary_msg['Data Creation/Update Summary'][$participant_id]["New Ovary/Endometrium Primary Diagnosis"][] = "$file_dx_data_strg. See atim patient id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
						}
					} else {
						$diagnosis_master_id = $atim_diagnosis_data['id'];
						$voa_to_diagnosis_master_id[$voa] = $diagnosis_master_id;
						if(!empty($file_diagnosis_data)) {
							$atim_diagnosis_data_to_update = array();
							$update_summary = array();
							foreach($file_diagnosis_data as $field => $file_value) {
								if(!array_key_exists($field, $atim_diagnosis_data)) die('ERR327632767627632732632');
								preg_match('/^([a-zA-Z]+)\.([a-zA-Z_]+)$/', $field, $matches);
								$db_model = $matches[1];
								$db_field = $matches[2];
								if(!strlen($atim_diagnosis_data_to_update[$field])) {
									
								} else if($atim_diagnosis_data_to_update[$field] != $file_value){
									
								}							
							}
							
							
							//update and compare
							pr($atim_diagnosis_data);
							pr($file_diagnosis_data);
							exit;
							
							$dx_data_to_update = array();
							
							
						}
					}
					
					
					
					
					
					


					/**
					 * 
					 TODO si pas de diagnosis mettre un message
					 [Date of Progression/Recurrence::Date] =>
					 [Date of Progression/Recurrence::Accuracy] =>
					 [Site 1 of Primary Tumor Progression (metastasis)  If Applicable] =>
					 [Site 2 of Primary Tumor Progression (metastasis)  If applicable] =>
					
					 [Date of Progression of CA125::Date] =>
					 [Date of Progression of CA125::Accuracy] =>
					 *
					 */
							
					
				}
				
				
//TODO
/*				
				
				//-- ** Link collection to patient Dx when patient is linked to one dx **

SET @modified_by = (SELECT id FROM users WHERE username LIKE 'migration');
SET @modified = (SELECT NOW() FROM users LIMIT 0 ,1);
UPDATE collections Collection, diagnosis_masters DiagnosisMaster 
SET Collection.diagnosis_master_id = DiagnosisMaster.id, Collection.modified = @modified, Collection.modified_by = @modified_by
WHERE Collection.deleted <> 1
AND DiagnosisMaster.deleted <> 1
AND Collection.participant_id = DiagnosisMaster.participant_id
AND Collection.participant_id IN (SELECT participant_id FROM (SELECT count(*) as dx_nbr, participant_id FROM diagnosis_masters WHERE deleted <> 1 GROUP BY participant_id) AS res WHERE res.dx_nbr = 1)
AND Collection.diagnosis_master_id IS NULL;
INSERT INTO collections_revs (id,acquisition_label,bank_id,collection_site,collection_datetime,collection_datetime_accuracy,ovcare_collection_type,sop_master_id,collection_property,collection_notes,participant_id,diagnosis_master_id,
consent_master_id,treatment_master_id,event_master_id,collection_voa_nbr,modified_by,version_created) 
(SELECT id,acquisition_label,bank_id,collection_site,collection_datetime,collection_datetime_accuracy,ovcare_collection_type,sop_master_id,collection_property,collection_notes,participant_id,diagnosis_master_id,
consent_master_id,treatment_master_id,event_master_id,collection_voa_nbr,modified_by,modified FROM collections WHERE modified = @modified AND modified_by = @modified_by);
*/				
			
			}
			
		}
	}
	
	//TODO load ensuite les tx et mettre diagnosis_master_id = null si pas de dx....
	
	
displayErrorAndMessage();
	exit;
	return $participants_last_contact;
}

?>