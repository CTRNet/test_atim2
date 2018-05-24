<?php

//First Line of any main.php file
require_once 'system.php';

truncate();

$excel_file_name = 'test.xls';
$excel_file_name = "2016-05-25 Fichier Alex epure pour ATIM avec macros_copy_20190629_tested.xls";
$excel_files_paths = array(array('file_name' => $excel_file_name));
displayMigrationTitle('Dr Ghadirian Data Import', true);

if(!testExcelFile(array($excel_file_name))) {
	dislayErrorAndMessage();
	exit;
}

$breast_no_labo_control_id = $atim_controls['misc_identifier_controls']['breast bank no lab']['id'];
$xls_misc_id_header_to_atim_control_ids = array(
	'RAMQ' => $atim_controls['misc_identifier_controls']['ramq nbr']['id'],
	'# HDM' => $atim_controls['misc_identifier_controls']['hotel-dieu id nbr']['id'],
	'# HSL' => $atim_controls['misc_identifier_controls']['saint-luc id nbr']['id'],
	'# HND' => $atim_controls['misc_identifier_controls']['notre-dame id nbr']['id']);

//==================================================================================================================================================
// PALB2 Worksheet
//==================================================================================================================================================

$palb2_worksheet_name = 'PALB2';
$all_palb2_data = array();
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $palb2_worksheet_name, 1)) {
	if($line_number > 1) {
		$palb2_key = $excel_line_data['NOM'].' '.$excel_line_data['PRÉNOM'];
		if(isset($all_palb2_data[$palb2_key])) die('ERR:647848848484'); //Check 2 patients have the same name...
		// Check dates
		foreach(array('Date envoi', 'Questionnaire de base', 'Confirmation - Date', '2e confirmation') as $new_excel_field) {
			$excel_line_data[$new_excel_field.' accuracy'] = '';
			$excel_line_data[$new_excel_field.' detail'] = '';
			if(preg_match('/[A-Za-z]/', $excel_line_data[$new_excel_field])) {
				$excel_line_data[$new_excel_field.' detail'] = $excel_line_data[$new_excel_field];
				$excel_line_data[$new_excel_field] = '';
			} else {
				list($excel_line_data[$new_excel_field], $excel_line_data[$new_excel_field.' accuracy']) = validateAndGetDateAndAccuracy($excel_line_data[$new_excel_field], $palb2_worksheet_name, "$palb2_worksheet_name::$new_excel_field:", "See Line:$line_number");
			}
		}
		// Set data
		$all_palb2_data[$palb2_key] = $excel_line_data;
		$all_palb2_data[$palb2_key]['summary_details'] = $excel_line_data['NOM'].' '.$excel_line_data['PRÉNOM']." in '$palb2_worksheet_name' worksheet at line $line_number";
		$all_palb2_data[$palb2_key]['used'] = false;
	}
}

//==================================================================================================================================================
// Participants Worksheet
//==================================================================================================================================================

$worksheet_name = 'Participants';
$ghadirian_no_labo = 90000;
$sample_conter = 0;
$aliquot_counter = 0;
$shipped_items = array();
$participant_id_to_collection_data = array();
$created_family_nbr = array();
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
	if($line_number > 1) {
	
		//Get palb2 data if exists
		$palb2_data = array();
		$palb2_key = $excel_line_data['Nom'].' '.$excel_line_data['Prénom'];
		if(isset($all_palb2_data[$palb2_key])) {
			if($all_palb2_data[$palb2_key]['used']) {
				recordErrorAndMessage('PALB2', '@@ERROR@@', "More than one patient of the '$worksheet_name' worksheet matches a record of the '$palb2_worksheet_name' worksheet. Data of the '$palb2_worksheet_name' worksheet will be recorded for both patients. Data to clean up after migration.", "See ".$all_palb2_data[$palb2_key]['summary_details']);	
			}
			$all_palb2_data[$palb2_key]['used'] = true;
			$palb2_data = $all_palb2_data[$palb2_key];
		}
		//-----------------------------------
		// I *** Check participant exists ***
		//-----------------------------------
			
		$sql_conditions = array();
		$xls_patient_definition_for_summary = array();
		$xls_patient_identifiers = array();
		foreach($xls_misc_id_header_to_atim_control_ids as $xls_misc_id_header => $misc_identifier_control_id) {
			$excel_line_data[$xls_misc_id_header] = str_replace(
				array('?','N/A','n/a', "De l'Ontario", "'", 'Pas de RAMQ', 'Pas au CHUM', 'Du Nouveau-Brunswick', "De l'Ontario"), 
				array('', '', '', '', "\'", '', '', ''), 
				$excel_line_data[$xls_misc_id_header]);
			$xls_misc_id_value_to_test = strtolower($excel_line_data[$xls_misc_id_header]);
			if($xls_misc_id_value_to_test) {
				$wrong_format = false;
				switch($xls_misc_id_header) {
					case 'RAMQ':
						if(!preg_match('/^([a-z]{4}){0,1}[0-9]+$/', $xls_misc_id_value_to_test)) $wrong_format = true;
						break;
					case '# HDM':
						if(preg_match('/^[0-9]+$/', $xls_misc_id_value_to_test)) {
							$xls_misc_id_value_to_test = 'h'.$xls_misc_id_value_to_test;
							$excel_line_data[$xls_misc_id_header] = 'H'.$excel_line_data[$xls_misc_id_header];
						}
						if(!preg_match('/^h[0-9]+$/', $xls_misc_id_value_to_test)) $wrong_format = true;
						break;
					case '# HND':
						if(preg_match('/^[0-9]+$/', $xls_misc_id_value_to_test)) {
							$xls_misc_id_value_to_test = 'n'.$xls_misc_id_value_to_test;
							$excel_line_data[$xls_misc_id_header] = 'N'.$excel_line_data[$xls_misc_id_header];
						}
						if(!preg_match('/^n[0-9]+$/', $xls_misc_id_value_to_test)) $wrong_format = true;						
						break;
					case '# HSL':
						if(preg_match('/^[0-9]+$/', $xls_misc_id_value_to_test)) {
							$xls_misc_id_value_to_test = 's'.$xls_misc_id_value_to_test;
							$excel_line_data[$xls_misc_id_header] = 'S'.$excel_line_data[$xls_misc_id_header];
						}
						if(!preg_match('/^s[0-9]+$/', $xls_misc_id_value_to_test)) $wrong_format = true;						
						break;
				}
				if($wrong_format) {
					recordErrorAndMessage('Patient', '@@ERROR@@', "Wrong $xls_misc_id_header format. Please validate.", $excel_line_data[$xls_misc_id_header]." (line $line_number)");
				} else {
					$xls_patient_definition_for_summary[] = $xls_misc_id_header." = '".$excel_line_data[$xls_misc_id_header]."'";
					$sql_conditions[] = "(misc_identifier_control_id = $misc_identifier_control_id AND lower(identifier_Value) REGEXP  '^[\ ]*".$xls_misc_id_value_to_test."[\ ]*$')";
					$xls_patient_identifiers[$misc_identifier_control_id] = array($xls_misc_id_header, strtoupper($xls_misc_id_value_to_test));
				}
			}
		}
		//Validate excel participants dates of birth and death
		$excel_field = 'Date de naissance';
		list($xls_date_of_birth, $xls_date_of_birth_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], 'Patient', "$worksheet_name::$excel_field:", "See Line:$line_number");
		$excel_field = 'Date de décès';
		list($xls_date_of_death, $xls_date_of_death_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], 'Patient', "$worksheet_name::$excel_field:", "See Line:$line_number");
		$xls_vital_status = $xls_date_of_death? 'deceased' : '';
		//Build excel patient defintion for summary
		$xls_first_name = $excel_line_data['Prénom'];
		$xls_last_name = $excel_line_data['Nom'];
		$xls_patient_definition_for_summary = "Excel (line $line_number) patient <b>$xls_first_name $xls_last_name</b> (BDate:$xls_date_of_birth) (".implode(' & ', ($xls_patient_definition_for_summary? $xls_patient_definition_for_summary : array('No idenitfiers into excel'))).")";
		//Try to match ATiM and Excel misc identifiers
		$atim_participant_data = array();
		$atim_first_name = null;
		$atim_last_name = null;
		if($sql_conditions) {
	 		$query = "SELECT participant_id, first_name, last_name, date_of_birth, date_of_birth_accuracy, vital_status, date_of_death, date_of_death_accuracy,
	 			misc_identifiers.id as misc_identifier_id, misc_identifier_name, identifier_value, misc_identifier_control_id
				FROM misc_identifiers
				INNER JOIN participants ON participant_id = participants.id
				INNER JOIN misc_identifier_controls ON misc_identifier_controls.id = misc_identifier_control_id
				WHERE misc_identifiers.deleted <> 1
				AND participants.deleted <> 1
				AND (".implode(' OR ',$sql_conditions).")
 				ORDER BY participant_id";
	 		foreach(getSelectQueryResult($query) as $new_match) {
				if(!isset($atim_participant_data[$new_match['participant_id']])) {
					$atim_participant_data[$new_match['participant_id']] = array(
						'participant_id' => $new_match['participant_id'],
						'first_name' => $new_match['first_name'], 
						'last_name' => $new_match['last_name'],
						'date_of_birth'	=> $new_match['date_of_birth'],
						'date_of_birth_accuracy'	=> $new_match['date_of_birth_accuracy'],
						'vital_status'	=> $new_match['vital_status'],
						'date_of_death'	=> $new_match['date_of_death'],
						'date_of_death_accuracy'	=> $new_match['date_of_death_accuracy'],
						'atim_patient_definition_for_summary' => array(),
						'identifiers' => array());
				} 
				$atim_participant_data[$new_match['participant_id']]['identifiers'][$new_match['misc_identifier_control_id']] = array(
					'id' => $new_match['misc_identifier_id'],
					'misc_identifier_name' =>  $new_match['misc_identifier_name'], 
					'misc_identifier_control_id' => $new_match['misc_identifier_control_id'],
					'identifier_value' => $new_match['identifier_value']);
				$atim_participant_data[$new_match['participant_id']]['atim_patient_definition_for_summary'][] = $new_match['misc_identifier_name']." = '".$new_match['identifier_value']."'";
			}
			foreach($atim_participant_data as $participant_id => $atim_participant_data_record) $atim_participant_data[$participant_id]['atim_patient_definition_for_summary'] = "ATiM patient <b>".$atim_participant_data_record['first_name'].' '.$atim_participant_data_record['last_name']."</b> (BDate:".$atim_participant_data_record['date_of_birth'].") (participant_id=".$participant_id.") matching on ".sizeof($atim_participant_data_record['atim_patient_definition_for_summary'])." identifiers (".implode(' & ', $atim_participant_data_record['atim_patient_definition_for_summary']).")";
		}
		if($atim_participant_data) {
			if(sizeof($atim_participant_data) > 1) {
				//More than one patient - Nothing should be created
				$all_atim_patient_defintions = array();
				foreach($atim_participant_data as $new_patient) $all_atim_patient_defintions[] = $new_patient['atim_patient_definition_for_summary'];
				recordErrorAndMessage('Patient', '@@ERROR@@', "More than one ATiM patient matched the Excel data based on identifiers. A new patient will be created. Please check data and add correction if required.", "See $xls_patient_definition_for_summary <br>and ".implode(' <br>+ ', $all_atim_patient_defintions));			
				$atim_participant_data = array();
			} else  {
				//Only one participant found check first name last name are equal
				$atim_participant_data = array_shift($atim_participant_data);
				$diff_on_names = 0;
				if(strtolower($xls_first_name) != strtolower($atim_participant_data['first_name'])) $diff_on_names++;
				if(strtolower($xls_last_name) != strtolower($atim_participant_data['last_name'])) $diff_on_names++;
				if($diff_on_names == 1) {
					if(sizeof($atim_participant_data['identifiers']) == 1) {
						if($atim_participant_data['date_of_birth'] == $xls_date_of_birth) {
							recordErrorAndMessage('Patient', '@@WARNING@@', "Patient matched based on one identifier and date of birth but a difference exists on one name. We assume patient is the good one but please check data and add correction if required.", "See $xls_patient_definition_for_summary <br>and ".$atim_participant_data['atim_patient_definition_for_summary']);
						} else {
							recordErrorAndMessage('Patient', '@@WARNING@@', "Patient matched based on one identifier but a difference exists on both date of birth and one name. We assume patient is the good one but please check data and add correction if required.", "See $xls_patient_definition_for_summary <br>and ".$atim_participant_data['atim_patient_definition_for_summary']);
						}
					} else {
						recordErrorAndMessage('Patient', '@@MESSAGE@@', "Patient matched based on many identifiers but a difference exists on one name. We assume patient is the good one but please check data and add correction if required.", "See $xls_patient_definition_for_summary <br>and ".$atim_participant_data['atim_patient_definition_for_summary']);
					}
				} else if($diff_on_names == 2) {
					if(sizeof($atim_participant_data['identifiers']) == 1) {
						if($atim_participant_data['date_of_birth'] == $xls_date_of_birth) {
							recordErrorAndMessage('Patient', '@@WARNING@@', "Patient matched based on one identifier and date of birth but differences exist on both names. We assume patient is the good one but please check data and add correction if required.", "See $xls_patient_definition_for_summary <br>and ".$atim_participant_data['atim_patient_definition_for_summary']);
						} else {
							recordErrorAndMessage('Patient', '@@ERROR@@', "Patient matched based on one identifier but differences exist on both names plus date of birth. A new patient will be created. Please check data and add correction if required.", "See $xls_patient_definition_for_summary <br>and ".$atim_participant_data['atim_patient_definition_for_summary']);
							$atim_participant_data = array();
						}
					} else {
						recordErrorAndMessage('Patient', '@@WARNING@@', "Patient matched based on many identifiers but differences exist on both names. We assume patient is the good one but please check data and add correction if required.", "See $xls_patient_definition_for_summary <br>and ".$atim_participant_data['atim_patient_definition_for_summary']);
					}
				}
			}
		} else {
			//No match on identifiers. Try to match on date and birth date.
			if($xls_date_of_birth) {
				$query = "SELECT id as participant_id, first_name, last_name, date_of_birth, date_of_birth_accuracy, vital_status, date_of_death, date_of_death_accuracy
		 			FROM participants
					WHERE deleted <> 1
		 			AND first_name REGEXP '^[\ ]*".str_replace("'", "\'", $xls_first_name)."[\ ]*$' 
		 			AND last_name REGEXP '^[\ ]*".str_replace("'", "\'", $xls_last_name)."[\ ]*$'
					AND date_of_birth = '$xls_date_of_birth'
	 				ORDER BY participant_id";
				$atim_participant_data = getSelectQueryResult($query);
				if(sizeof($atim_participant_data) > 1) {
					die('ERR4847847847');
				}
				if($atim_participant_data) {
					$atim_participant_data = array_shift($atim_participant_data);
					$atim_participant_data['atim_patient_definition_for_summary'] = "ATiM patient <b>$xls_first_name $xls_last_name</b> (BDate:$xls_date_of_birth) (participant_id=".$atim_participant_data['participant_id'].") matching only on date, first name and last name (not on identifier)";
					$atim_participant_data['identifiers'] = array();
					recordErrorAndMessage('Patient', '@@WARNING@@', "Patient did not match based on one identifier but matched based on names plus date of birth. We assume patient is the good one but please check data and add correction if required.", "See $xls_patient_definition_for_summary <br>and ".$atim_participant_data['atim_patient_definition_for_summary']);
				}
			}			
		}		
		
		if($atim_participant_data) {
			//Participant found based on identifiers or date of birth + names
			//1-Check profile data are similar and update missing data
			$data_to_update = array();
			if($xls_date_of_birth) {
				if(!$atim_participant_data['date_of_birth']) {
					$data_to_update['date_of_birth'] = $xls_date_of_birth;
					$data_to_update['date_of_birth_accuracy'] = $xls_date_of_birth_accuracy;
				} else if($atim_participant_data['date_of_birth'] != $xls_date_of_birth || $atim_participant_data['date_of_birth_accuracy'] != $xls_date_of_birth_accuracy) {
					recordErrorAndMessage('Patient', '@@WARNING@@', "Date of birth are different. Date won't be updated into ATiM.", "ATiM : ".$atim_participant_data['date_of_birth'].'('.$atim_participant_data['date_of_birth_accuracy'].") != Xls : $xls_date_of_birth($xls_date_of_birth_accuracy). See $xls_patient_definition_for_summary and ".$atim_participant_data['atim_patient_definition_for_summary']);
				}
			}
			if($xls_date_of_death) {
				if(!$atim_participant_data['date_of_death']) {
					$data_to_update['date_of_death'] = $xls_date_of_death;
					$data_to_update['date_of_death_accuracy'] = $xls_date_of_death_accuracy;
					if($atim_participant_data['vital_status'] != $xls_vital_status) $data_to_update['vital_status'] = $xls_vital_status;
				} else {
					if($atim_participant_data['date_of_death'] != $xls_date_of_death || $atim_participant_data['date_of_death_accuracy'] != $xls_date_of_death_accuracy) {
						recordErrorAndMessage('Patient', '@@WARNING@@', "Date of death are different. Date won't be updated into ATiM.", "ATiM : ".$atim_participant_data['date_of_death'].'('.$atim_participant_data['date_of_death_accuracy'].") != Xls : $xls_date_of_death($xls_date_of_death_accuracy).See $xls_patient_definition_for_summary and ".$atim_participant_data['atim_patient_definition_for_summary']);
					}
					if($atim_participant_data['vital_status'] != $xls_vital_status) {
						recordErrorAndMessage('Patient', '@@WARNING@@', "Vital status is different. Vital status won't be updated into ATiM.", "ATiM : ".$atim_participant_data['vital_status']." != Xls : $xls_vital_status.See $xls_patient_definition_for_summary and ".$atim_participant_data['atim_patient_definition_for_summary']);
					}
				}
			}
			if($data_to_update) {
				$update_detail = array();
				foreach($data_to_update as $field => $value) {
					$update_detail[] = "[$field = $value]";
				}
				$update_detail = implode(' & ', $update_detail);
				updateTableData($atim_participant_data['participant_id'], array('participants' =>$data_to_update));
				recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Updated participant data", "$update_detail. See $xls_patient_definition_for_summary and ".$atim_participant_data['atim_patient_definition_for_summary']);
			}
			//2-Manage breast NoLabo
			$no_labo = getSelectQueryResult("SELECT identifier_value, id FROM misc_identifiers WHERE deleted != 1 AND participant_id = ".$atim_participant_data['participant_id']." AND misc_identifier_control_id = $breast_no_labo_control_id");
			if($no_labo)  {
				$atim_participant_data['identifiers'][$breast_no_labo_control_id] = array(
						'id' => $no_labo[0]['id'],
						'misc_identifier_name' => 'breast bank no lab',
						'misc_identifier_control_id' => $breast_no_labo_control_id,
						'identifier_value' => $no_labo[0]['identifier_value']);
			} else {
				// Add no labo
				$misc_identifiers_data = array(
					'misc_identifiers' => array(
						'participant_id' => $atim_participant_data['participant_id'],
						'identifier_value' => $ghadirian_no_labo,
						'misc_identifier_control_id' => $breast_no_labo_control_id,
						'flag_unique' => '1'));
				$atim_participant_data['identifiers'][$breast_no_labo_control_id] = $misc_identifiers_data['misc_identifiers'];
				$atim_participant_data['identifiers'][$breast_no_labo_control_id]['id'] = customInsertRecord($misc_identifiers_data);
				recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created a breast NoLabo for an existing patient", "No Labo $ghadirian_no_labo. See $xls_patient_definition_for_summary and ".$atim_participant_data['atim_patient_definition_for_summary']);
				$ghadirian_no_labo++;
			}
			//3-Manage patient identifiers
			$xls_patient_identifiers_to_create = $xls_patient_identifiers;
			foreach($atim_participant_data['identifiers']  as $atim_identifiers_that_matched_an_xls_value) 
				unset($xls_patient_identifiers_to_create[$atim_identifiers_that_matched_an_xls_value['misc_identifier_control_id']]);
			foreach($xls_patient_identifiers_to_create as $misc_identifier_control_id => $new_identifier_to_record) {
				list($xls_misc_id_header, $new_identifier_value_to_record) = $new_identifier_to_record;
				$query = "SELECT participant_id, identifier_value
					FROM misc_identifiers
					WHERE deleted <> 1
					AND misc_identifier_control_id = $misc_identifier_control_id
					AND identifier_value LIKE '".$new_identifier_value_to_record."'";
				$matching_identifiers = getSelectQueryResult($query);
				if(!$matching_identifiers) {
					//Check patient not already linked to an identifier
					$query = "SELECT participant_id, identifier_value
						FROM misc_identifiers
						WHERE deleted <> 1
						AND misc_identifier_control_id = $misc_identifier_control_id
						AND participant_id = ".$atim_participant_data['participant_id'];
					$matching_identifiers = getSelectQueryResult($query);
					if(!$matching_identifiers) {
						$misc_identifiers_data = array(
							'misc_identifiers' => array(
								'participant_id' => $atim_participant_data['participant_id'],
								'identifier_value' => $new_identifier_value_to_record,
								'misc_identifier_control_id' => $misc_identifier_control_id,
								'flag_unique' => '1'));
						customInsertRecord($misc_identifiers_data);
						recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Recorded a $xls_misc_id_header identifier for an existing participant", "See value '$new_identifier_value_to_record' for $xls_patient_definition_for_summary and ".$atim_participant_data['atim_patient_definition_for_summary']);
					} else {
						$tmp_ids =array();
						foreach($matching_identifiers as $tmp_new) $tmp_ids[] = $tmp_new['identifier_value'];
						$tmp_ids = implode (' & ', $tmp_ids);
						recordErrorAndMessage('Patient', '@@ERROR@@', "ATiM Patient $xls_misc_id_header is different than the excel value. Data won't be updated into ATiM. Please check data then add correction if required.", "See excel value '$new_identifier_value_to_record' and atim value '$tmp_ids'. Test done for $xls_patient_definition_for_summary <br>and ".$atim_participant_data['atim_patient_definition_for_summary']);
					}
				} else if(sizeof($matching_identifiers) > 1) {
					die('ERR 838399393');
				} else {
					if($matching_identifiers[0]['participant_id'] != $atim_participant_data['participant_id']) {
						recordErrorAndMessage('Patient', '@@ERROR@@', "Excel identifier $xls_misc_id_header is still recorded for another patient into ATiM. Please check data then add correction if required.", "See excel value '$new_identifier_value_to_record' and other participant_id ".$matching_identifiers[0]['participant_id']." for $xls_patient_definition_for_summary and ".$atim_participant_data['atim_patient_definition_for_summary']);
					}
				}
			}
		}
		
		if(!$atim_participant_data) {
			//No ATiM patient found based on identifier values or birth date : Create new patient
			//A-Try to find patient based on names (just for information)		
			$atim_participants_matching_on_names = getSelectQueryResult("SELECT participants.id AS participant_id, first_name, last_name, misc_identifier_name, identifier_value, misc_identifier_control_id, date_of_birth
				FROM participants 
 				LEFT JOIN misc_identifiers ON participant_id = participants.id AND misc_identifiers.deleted <> 1
				LEFT JOIN misc_identifier_controls ON misc_identifier_controls.id = misc_identifier_control_id
				WHERE participants.deleted != 1 AND first_name REGEXP '^[\ ]*".str_replace("'", "\'", $xls_first_name)."[\ ]*$' AND last_name REGEXP '^[\ ]*".str_replace("'", "\'", $xls_last_name)."[\ ]*$'
 				ORDER BY participants.id");
 			if($atim_participants_matching_on_names) {
 				$atim_patients_with_same_names = array();
 				foreach($atim_participants_matching_on_names as $new_patient) {
 					$patient_key = 'ATiM patient <b>'.$new_patient['first_name'].' '.$new_patient['last_name'].'</b> (BDate:'.$new_patient['date_of_birth'].') (id = '.$new_patient['participant_id'].')';
 					if(!isset($atim_patients_with_same_names[$patient_key])) $atim_patients_with_same_names[$patient_key] = array();
 					if($new_patient['misc_identifier_name'] && in_array($new_patient['misc_identifier_control_id'], array_merge(array($breast_no_labo_control_id), $xls_misc_id_header_to_atim_control_ids))) $atim_patients_with_same_names[$patient_key][] = $new_patient['misc_identifier_name']." = '".$new_patient['identifier_value']."'";
 				}
 				foreach($atim_patients_with_same_names as $patient_key => $identifiers) $atim_patients_with_same_names[$patient_key] = $patient_key.' ('.implode(' & ',($identifiers? $identifiers : array('No identifiers'))).')';
 				$atim_patients_with_same_names = implode(' <br>or ', $atim_patients_with_same_names);
				recordErrorAndMessage('Patient', '@@MESSAGE@@', "Patient did not match based on identifier and date of birth but ATiM patient matched based on names. A new patient will be created anyway but please validate.", "See $xls_patient_definition_for_summary <br>and ATiM Patient(s) $atim_patients_with_same_names.");
 			}
			//B-Create new patient
 			$atim_participant_data = array(
				'first_name' => $xls_first_name,
				'last_name' => $xls_last_name,
				'date_of_birth'	=> $xls_date_of_birth,
				'date_of_birth_accuracy' => $xls_date_of_birth_accuracy,
				'vital_status' => $xls_vital_status,
				'date_of_death'	=> $xls_date_of_death,
				'date_of_death_accuracy' => $xls_date_of_death_accuracy,
				'notes' => 'Created by the Dr Ghadirian data import process.');
 			if(!$xls_date_of_birth) {
 				unset($atim_participant_data['date_of_birth']);
 				unset($atim_participant_data['date_of_birth_accuracy']);
 			}
			if(!$xls_date_of_death) {
 				unset($atim_participant_data['date_of_death']);
 				unset($atim_participant_data['date_of_death_accuracy']);
 			}
			$atim_participant_data['participant_id'] = customInsertRecord(array('participants' => $atim_participant_data));
			$atim_participant_data['atim_patient_definition_for_summary'] = 'N/A - New participant (participant_id='.$atim_participant_data['participant_id'].')';
			recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created new participant plus identifiers plus new Breast NoLabo", "See $xls_patient_definition_for_summary");
			foreach($xls_patient_identifiers as $misc_identifier_control_id => $new_identifier_to_record) {
				list($xls_misc_id_header, $new_identifier_value_to_record) = $new_identifier_to_record;
				$query = "SELECT participant_id, identifier_value
					FROM misc_identifiers
					WHERE deleted <> 1
					AND misc_identifier_control_id = $misc_identifier_control_id
					AND identifier_value LIKE '".$new_identifier_value_to_record."'";
				$matching_identifiers = getSelectQueryResult($query);
				if($matching_identifiers) {
					recordErrorAndMessage('Patient', '@@ERROR@@', "Excel identifier $xls_misc_id_header is still recorded for another patient into ATiM. Please check data then add correction if required.", "See value '$new_identifier_value_to_record' for $xls_patient_definition_for_summary and ".$atim_participant_data['atim_patient_definition_for_summary']);
				} else {
					$misc_identifiers_data = array(
						'misc_identifiers' => array(
							'participant_id' => $atim_participant_data['participant_id'],
							'identifier_value' => $new_identifier_value_to_record,
							'misc_identifier_control_id' => $misc_identifier_control_id,
							'flag_unique' => '1'));
					customInsertRecord($misc_identifiers_data);
				}
			}
			$misc_identifiers_data = array(
				'misc_identifiers' => array(
					'participant_id' => $atim_participant_data['participant_id'],
					'identifier_value' => $ghadirian_no_labo,
					'misc_identifier_control_id' => $breast_no_labo_control_id,
					'flag_unique' => '1'));
			$atim_participant_data['identifiers'][$breast_no_labo_control_id] = $misc_identifiers_data['misc_identifiers'];
			$atim_participant_data['identifiers'][$breast_no_labo_control_id]['id'] = customInsertRecord($misc_identifiers_data);
			$ghadirian_no_labo++;
		}
		
		if($atim_participant_data) {		
			$participant_id = $atim_participant_data['participant_id'];
			$atim_patient_definition_for_summary = $atim_participant_data['atim_patient_definition_for_summary'];
			$breast_no_labo = $atim_participant_data['identifiers'][$breast_no_labo_control_id]['identifier_value'];
			$breast_no_labo_misc_identifier_id = $atim_participant_data['identifiers'][$breast_no_labo_control_id]['id'];
			
			//-----------------------------------
			// II *** Phone number ***
			//-----------------------------------
			
			if($excel_line_data['Téléphone']) {
				if(preg_match('/([0-9]{3}).*([0-9]{3}).*([0-9]{4})/', $excel_line_data['Téléphone'])) {
					$participant_contact_data = array(
						'participant_contacts' => array(
							'participant_id' => $participant_id,
							'confidential' => '1',
							'relationship' => 'the participant',
							'notes' => 'Created by the Dr Ghadirian data import process.',
							'phone' => $excel_line_data['Téléphone'])
					);
					customInsertRecord($participant_contact_data);
					recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Recorded phone number", $excel_line_data['Téléphone'].". See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
				} else {
					recordErrorAndMessage('Phone number', '@@WARNING@@', "Wrong phone number format", $excel_line_data['Téléphone'].". Data won't be recorded. See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
				}
			}
			
			//-----------------------------------
			// III *** Genetic Test BRCA 1-2 ***
			//-----------------------------------
			
			$excel_field = 'Test BRCA 1- 2';
			list($test_date, $test_date_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], 'Genetic Test', "$worksheet_name::$excel_field:", "See Line:$line_number");
			if(strlen($excel_line_data['Mutation']) || strlen($excel_line_data['Exon']) || $test_date) {
				$event_data = array(
					'event_masters' => array(
						'participant_id' => $participant_id,
						'event_control_id' => $atim_controls['event_controls']['genetic test']['id'],
						'event_date' => $test_date,
						'event_date_accuracy' => $test_date_accuracy,
						'event_summary' => 'Created by the Dr Ghadirian data import process.'),
					$atim_controls['event_controls']['genetic test']['detail_tablename'] => array(
						'test' => 'BRCA 1-2',
						'result' => ($excel_line_data['Mutation'])? $excel_line_data['Mutation'] : 'No mutation found',
						'detail' => $excel_line_data['Exon']));
				if(!$test_date) {
					unset($event_data['event_masters']['event_date']);
					unset($event_data['event_masters']['event_date_accuracy']);
				}
				customInsertRecord($event_data);		
				recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created 'BRCA 1-2' Genetic Test", "Result = '".$excel_line_data['Mutation']."' & detail = '".$excel_line_data['Exon']."'.See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
			}
			
			//-----------------------------------
			// III *** Family History ***
			//-----------------------------------
				
			$family_cancers = array();
			$fields = array(
				"Cancers Familiaux déclarés" => 'family cancer',
				"Cancer du sein" => 'breast',
				"Cancer du sein bilatéral" => 'breast 2',
				"Cancer de l'ovaire" => 'ovary',
				"Cancer de la prostate" => 'prostate',
				"Cancer du poumon" => 'lung',
				"Cancer du côlon" => 'colon',
				"Cancer de l'utérus" => 'uterus',
				"Leucémie" => 'leukemia',
				"Cancer de la peau" => 'skin',
				"Cancer du foie" => 'liver',
				"Cancer de l'estomac" => 'stomach',
				"Cancer du cerveau" => 'brain',
				"Cancer du pancréas" => 'pancreas',
				"Autre cancer dans la famille; détail" => 'other cancer');
			$new_person = 1;
			foreach($fields as $xls_field => $qc_nd_cancer) {
				$qc_nd_cancer_detail = '';
				$records_to_create = str_replace(array('oui','non', '?', "\0"), array('1','0', '', ''), $excel_line_data[$xls_field]);
				if($records_to_create) {
					switch($qc_nd_cancer) {
						case 'breast 2':
							$qc_nd_cancer = 'breast';
							$qc_nd_cancer_detail = 'Bilateral';
							break;
						case 'other cancer':
							foreach(explode("\n", $records_to_create) as $new_fam_histo) {
								if(preg_match('/^(.*)[\ ]*:[\ ]*([0-9]+)$/', $new_fam_histo, $matches)) {
									for($counter = 0; $counter < $matches[2]; $counter++) {
										$data = array(
											'family_histories' => array(
												'participant_id' => $participant_id,
												'qc_nd_cancer' => $qc_nd_cancer,
												'qc_nd_cancer_detail' => $matches[1],
												'qc_nd_relation_detail' => 'Unknown person #'.$new_person.'. Created by the Dr Ghadirian data import process.'));
										$new_person++;
										customInsertRecord($data);
									}
									recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Family history", "Created ".$matches[2]." $qc_nd_cancer '".$matches[1]."' (cancer). See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
								} else {
									$data = array(
										'family_histories' => array(
											'participant_id' => $participant_id,
											'qc_nd_cancer' => 'other cancer',
											'qc_nd_cancer_detail' => $new_fam_histo,
											'qc_nd_relation_detail' => 'Unknown person #'.$new_person.'. Created by the Dr Ghadirian data import process.'));
									$new_person++;
									customInsertRecord($data);
									recordErrorAndMessage('Family history', '@@WARNING@@', "Wrong other cancer format", "See data [$new_fam_histo]. Data will be recorded as is. See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
									recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Family history", "Created 1 other cancer '$new_fam_histo' (cancer). See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
								}
							}
							$records_to_create = 0;
							break;
						default:
					}
					$records_to_create = validateAndGetInteger($records_to_create, "Family history", "$worksheet_name::$xls_field:", "Family history record won't be created. See Line:$line_number");
					if($records_to_create) {
						for($counter = 0; $counter < $records_to_create; $counter++) {
							$data = array(
								'family_histories' => array(
									'participant_id' => $participant_id, 
									'qc_nd_cancer' => $qc_nd_cancer,
									'qc_nd_cancer_detail' => $qc_nd_cancer_detail,
									'qc_nd_relation_detail' => 'Unknown person #'.$new_person.'. Created by the Dr Ghadirian data import process.'));
							$new_person++;
							customInsertRecord($data);
						}
						recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Family history", "Created $records_to_create $qc_nd_cancer (cancer). See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
					}
				}
			}
			
			//-----------------------------------
			// IV *** Ghadirian Form ***
			//-----------------------------------
			
			$table_name = $atim_controls['event_controls']['ghadirian form']['detail_tablename'];
			$event_data = array(
				'event_masters' => array(
					'event_control_id' => $atim_controls['event_controls']['ghadirian form']['id'],
					'participant_id' => $participant_id
				),
				$table_name => array());
			$field_to_field = array(
				"Questionnaire alimentaire reçu" => 'food_questionnaire_received',
				"Suivi #1" => 'follow_up_1',
				"Suivi #2 (projeté)" => 'follow_up_2',
				"Suivi #3 (projeté)" => 'follow_up_3');
			foreach($field_to_field as $excel_field => $table_field) {
				if($excel_line_data[$excel_field]) {
					if(preg_match('/[A-Za-z]+/', $excel_line_data[$excel_field])) {
						$event_data[$table_name][$table_field.'_detail'] = $excel_line_data[$excel_field];
					} else {
						list($xls_date, $xls_date_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], 'Ghadirian Form', "$worksheet_name::$excel_field:", "See Line:$line_number");
						if($xls_date) {
							$event_data[$table_name][$table_field] = $xls_date;
							$event_data[$table_name][$table_field.'_accuracy'] = $xls_date_accuracy;
						}	
					}
				}
			}
			$field_to_field = array(
				"Âge au Dx" => 'age_at_dx', 
				"Cancer (Dx)" => 'cancer', 
				"Consultation génique: endroit" => 'genetic_consultation_site');
			foreach($field_to_field as $excel_field => $table_field) {
				$event_data[$table_name][$table_field] = $excel_line_data[$excel_field];
			}
			$excel_field = 'Consultation génique faite';
			if($excel_line_data[$excel_field]) {
				if(strtolower($excel_line_data[$excel_field]) != 'oui') {
					recordErrorAndMessage('Ghadirian Form', '@@ERROR@@', "Wrong 'Consultation génique faite' format", $excel_line_data[$excel_field].". Data won't be recorded. See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
				} else {
					$event_data[$table_name]['genetic_consultation'] = 'y';
				}
			}
			if($palb2_data) {
				if($palb2_data['Questionnaire de base']) {
					$event_data[$table_name]['questionnaire'] = $palb2_data['Questionnaire de base'];
					$event_data[$table_name]['questionnaire_accuracy'] = $palb2_data['Questionnaire de base accuracy'];
				}
				$event_data[$table_name]['questionnaire_detail'] = $palb2_data['Questionnaire de base detail'];
				$event_data[$table_name]['link_to_family_nbr'] = $palb2_data['Lien: # de famille'];
			}
			if($event_data[$table_name]) {
				$event_data['event_masters']['event_summary'] = $excel_line_data['Notes'];
				customInsertRecord($event_data);
				recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Ghadirian Form", "Created form. See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
			}
			
			//-----------------------------------
			// V *** Genetic Test PALB2 ***
			//-----------------------------------
				
			if($palb2_data) {
				if($palb2_data["ID de l'étude PALB2"]) {
					$event_data = array(
						'event_masters' => array(
							'participant_id' => $participant_id,
							'event_control_id' => $atim_controls['event_controls']['genetic test']['id'],
							'event_date' => $palb2_data["Confirmation - Date"],
							'event_date_accuracy' => $palb2_data["Confirmation - Date accuracy"],
							'event_summary' => 'Study : '.$palb2_data["ID de l'étude PALB2"].(strlen($palb2_data["Confirmation - Date detail"])? '. '.$palb2_data["Confirmation - Date detail"] : '').'. Created by the Dr Ghadirian data import process.'),
						$atim_controls['event_controls']['genetic test']['detail_tablename'] => array(
							'site' => $palb2_data["Labo qui a fait le test"],
							'test' => 'PALB2',
							'result' => $palb2_data["Confirmation - Résultat"],
							'detail' => $palb2_data["Mutation PALB2"]));
					if($palb2_data["2e confirmation detail"]) {
						$event_data['event_masters']['event_summary'] = 'Study : '.$palb2_data["ID de l'étude PALB2"].
							(strlen($palb2_data["Confirmation - Date detail"])? '. '.$palb2_data["Confirmation - Date detail"] : '').
							'. Note about the 2nd confirmation : '.$palb2_data["2e confirmation detail"].
							'. Created by the Dr Ghadirian data import process.';
					}
					if(!$event_data['event_masters']['event_date']) {
						unset($event_data['event_masters']['event_date']);
						unset($event_data['event_masters']['event_date_accuracy']);
					}
					customInsertRecord($event_data);
					recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created 'PALB2' Genetic Test", "Result = '".$palb2_data["Confirmation - Résultat"]."' & detail = '".$palb2_data["Mutation PALB2"]."'. See $xls_patient_definition_for_summary and ".$palb2_data['summary_details']);	
					if($palb2_data["2e confirmation"]) {
						$event_data['event_masters']['event_date'] = $palb2_data["2e confirmation"];
						$event_data['event_masters']['event_date_accuracy'] = $palb2_data["2e confirmation accuracy"];
						$event_data['event_masters']['event_summary'] = 'Study : '.$palb2_data["ID de l'étude PALB2"].
							(strlen($palb2_data["Confirmation - Date detail"])? '. '.$palb2_data["Confirmation - Date detail"] : '').
							'. 2nd confirmation'.
							'. Created by the Dr Ghadirian data import process.';
						if(!$event_data['event_masters']['event_date']) {
							unset($event_data['event_masters']['event_date']);
							unset($event_data['event_masters']['event_date_accuracy']);
						}
						customInsertRecord($event_data);
						recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created 'PALB2' Genetic Test - Confirmation", "Result = '".$palb2_data["Confirmation - Résultat"]."' & detail = '".$palb2_data["Mutation PALB2"]."'. See $xls_patient_definition_for_summary and ".$palb2_data['summary_details']);	
					}
				} else {
					foreach(array("Confirmation - Date", "Confirmation - Résultat", "2e confirmation", "Confirmation - Résultat", "Mutation PALB2", "Labo qui a fait le test") as $palb2_field) {
						if(strlen($palb2_data[$palb2_field])) die('ERR 2376287 632876');
					}
				}
			}
			
			//-----------------------------------
			// V *** Nail Collection ***
			//-----------------------------------
			
			$collection_id = null;
			$excel_field = "Échantillon d'ongles";
			list($xls_date, $xls_date_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], 'Nail Collection', "$worksheet_name::$excel_field:", "No Nail collection will be created. See Line:$line_number");
			if($xls_date) {
				//Collection
				$collection_data = array(
					'collections' => array(
						'acquisition_label' => 'Dr Darviz Ghadirian',	
						'bank_id' => $breast_no_labo_control_id,
						'collection_datetime' => $xls_date,
						'collection_datetime_accuracy' => ($xls_date_accuracy == 'c')? 'h' : $xls_date_accuracy,
						'collection_property' => 'participant collection',
						'collection_notes' => 'Created by the Dr Ghadirian data import process.',
						'participant_id' => $participant_id));
				$collection_id = customInsertRecord($collection_data);
				//Sample
				$sample_data = array(
					'sample_masters' => array(
						'collection_id' => $collection_id,
						'sample_control_id' => $atim_controls['sample_controls']['nail']['id'],
						'initial_specimen_sample_type' => 'nail',
						'qc_nd_sample_label' => "NAIL - $breast_no_labo",
						'sample_code' => 'TMP_GH'.($sample_conter++),
						'notes' => 'Created by the Dr Ghadirian data import process.'),
					'specimen_details' => array('type_code' => 'N', 'reception_by' => 'autre'),
					$atim_controls['sample_controls']['nail']['detail_tablename'] => array());	
				$sample_master_id = customInsertRecord($sample_data);
				//Aliquot
				$aliquot_data = array(
					'aliquot_masters' => array(
						"barcode" => 'tmp_gh_'.($aliquot_counter++),
						"aliquot_label" => "NAIL - $breast_no_labo",
						"aliquot_control_id" => $atim_controls['aliquot_controls']['nail-envelope']['id'],
						"collection_id" => $collection_id,
						"sample_master_id" => $sample_master_id,
						'in_stock' => 'yes - available',
						'use_counter' => '0',
						'notes' => 'Created by the Dr Ghadirian data import process.'),
					$atim_controls['aliquot_controls']['nail-envelope']['detail_tablename'] => array());
				$aliquot_master_id = customInsertRecord($aliquot_data);
				recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created nail 'collection' and aliquot", "Aliquot = '"."NAIL - $breast_no_labo"."'. See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
			}
			$participant_id_to_collection_data[$participant_id] = array($breast_no_labo, $collection_id, $xls_date);
			
			//-----------------------------------
			// VI *** Blood and block collection ***
			//-----------------------------------
			
			// Dr. Steven Narod
			$aliquot_shipping_name = '';
			if(strlen($excel_line_data['No Échantillon Narod'])) {
				if(!preg_match('/^P[0-9]+/', $excel_line_data['No Échantillon Narod'])) die('ERR 23786287362387623');
				$aliquot_shipping_name = $excel_line_data['No Échantillon Narod'];
			}
			$excel_field = "Date Envoi Toronto";
			list($datetime_shipped, $datetime_shipped_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], 'Narod', "$worksheet_name::$excel_field:", "See Line:$line_number");
			if($datetime_shipped || $aliquot_shipping_name) {
				$tmp_data = array(
					'participant_id' => $participant_id,
					'sample_type' => 'blood',
					'aliquot_type' => 'tube',
					'shipping_name' => $aliquot_shipping_name,
					'institution' => 'Dr. Steven Narod',
					'datetime_shipped' => $datetime_shipped,
					'datetime_shipped_accuracy' => $datetime_shipped_accuracy,
					'summary_details' => "See worksheet $worksheet_name : $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
				$shipped_items['Narod'][] = $tmp_data;
			} else if(strlen($excel_line_data[$excel_field]) && !in_array($excel_line_data[$excel_field], array('N/A'))) {
				recordErrorAndMessage('Narod', '@@ERROR@@', "No item shipped to Dr Steven Narod but a date value is set with a wrong value format. No data will be recorded. To record manually if required.", "DAte = '".$excel_line_data[$excel_field]."'.See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
			}
			
			// FRSQ
			$shipped = false;
			$test_frsq_sample_type = 'blood';
			if(strlen($excel_line_data['FRSQ']) && !in_array($excel_line_data['FRSQ'], array('N/A', 'Non', 'Refus', 'Refus FRSQ'))) {
				if(in_array($excel_line_data['FRSQ'], array('Oui', 'oui', 'déjà fait', 'Déjà fait'))) {
					$shipped = true;
					$test_frsq_sample_type = 'blood';
				} else if(in_array($excel_line_data['FRSQ'], array('Oui mais salive seul.', 'Oui mais salive seul', 'Oui mais pas de sang'))) {
					$shipped = true;
					$test_frsq_sample_type = 'saliva';
				} else {
					recordErrorAndMessage('FRSQ', '@@ERROR@@', "No item shipped to FRSQ but a FRSQ value is set with a wrong value format. No data will be recorded. To record manually if required.", "Value = '".$excel_line_data['FRSQ']."'.See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
				}					
			}
			$excel_field = "Date Envoi FRSQ";
			$excel_line_data[$excel_field] = str_replace(array('RefusFRSQ', 'N/AFRSQ', 'N/A'), array('', '', ''), $excel_line_data[$excel_field]);
			list($datetime_shipped, $datetime_shipped_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], 'FRSQ', "$worksheet_name::$excel_field:", "See Line:$line_number");
			if($datetime_shipped || $shipped) {
				$tmp_data = array(
					'participant_id' => $participant_id,
					'sample_type' => $test_frsq_sample_type,
					'aliquot_type' => 'tube',
					'shipping_name' => '',
					'institution' => 'Labo Mes-Masson',
					'datetime_shipped' => $datetime_shipped,
					'datetime_shipped_accuracy' => $datetime_shipped_accuracy,
					'summary_details' => "See worksheet $worksheet_name : $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
				$shipped_items['FRSQ'][] = $tmp_data;
			} else if(strlen($excel_line_data[$excel_field]) && !in_array($excel_line_data[$excel_field], array('N/A'))) {
				recordErrorAndMessage('FRSQ', '@@ERROR@@', "No item shipped to FRSQ but a date value is set with a wrong value format. No data will be recorded. To record manually if required.", "Date = '".$excel_line_data[$excel_field]."'.See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
			}
			
			// PALB2
			if($palb2_data) {
				if($palb2_data["ID de l'étude PALB2"]) {
					if($palb2_data["Date envoi detail"] && !in_array($palb2_data["Date envoi detail"], array('N/A', 'En attente'))) die('ERR 2372368236'.$palb2_data["Date envoi detail"]);
					$aliquot_shipping_name = $palb2_data['Sample ID'].' [Study '.$palb2_data["ID de l'étude PALB2"].']';
					$palb2_data["Échantillon testé"] = str_replace(' ', '', $palb2_data["Échantillon testé"]);
					foreach(explode('+', $palb2_data["Échantillon testé"]) as $new_aliquot_type) {
						$sample_type = '';
						$aliquot_type = '';
						switch($new_aliquot_type) {
							case 'Sang':
								$sample_type = 'blood';
								$aliquot_type = 'tube';
								break;
							case 'Bloc':
								$sample_type = 'tissue';
								$aliquot_type = 'block';
								break;
							default : 
								die('ERR 2389728772398723');
						}
						$tmp_data = array(
							'participant_id' => $participant_id,
							'sample_type' => $sample_type,
							'aliquot_type' => $aliquot_type,
							'shipping_name' => $aliquot_shipping_name,
							'institution' => '',
							'datetime_shipped' => $palb2_data["Date envoi"],
							'datetime_shipped_accuracy' => $palb2_data["Date envoi accuracy"],
							'summary_details' => "See".$palb2_data['summary_details']);
						$shipped_items['PALB2'][] = $tmp_data;
					}
				} else {
					foreach(array("Date envoi", "Date envoi detail", "Sample ID") as $palb2_field) {
						if(strlen($palb2_data[$palb2_field]) && !in_array($palb2_data[$palb2_field], array('N/A', 'En attente'))) die('ERR 237623232376');
					}
				}
			}	

			//-----------------------------------
			// VII *** Blood and block collection ***
			//-----------------------------------
					
			$excel_field = '# famille/Ind';
			if($excel_line_data[$excel_field]) {
				if(in_array($excel_line_data[$excel_field], $created_family_nbr)) {
					recordErrorAndMessage('Family Nbr', '@@ERROR@@', "Family Nbr assigned to 2 patients. Must be unique. Won't be assigned to the second patient.", "See value = '".$excel_line_data[$excel_field]."'.See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
				} else {
					$misc_identifiers_data = array(
						'misc_identifiers' => array(
							'participant_id' => $participant_id,
							'identifier_value' => $excel_line_data[$excel_field],
							'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['family number']['id'],
							'flag_unique' => '1'));
					customInsertRecord($misc_identifiers_data);
					$created_family_nbr[$excel_line_data[$excel_field]] = $excel_line_data[$excel_field];
					recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created Family Nbr", "See value = '".$excel_line_data[$excel_field]."'.See $xls_patient_definition_for_summary and $atim_patient_definition_for_summary");
				}
			}
		} else {
			//Should never happens
			die('ERR3267263762');
		}
	}
}

foreach($all_palb2_data as $palb2_key => $palb2_data) {
	if(!$palb2_data['used']) {
		recordErrorAndMessage('PALB2', '@@ERROR@@', "Patient of the '$palb2_worksheet_name' worksheet does not match a record of the '$worksheet_name' worksheet. New patient will be created. Data to clean up after migration.", "Patient $palb2_key. See ".$palb2_data['summary_details']);
		
		//Create patient	
		$atim_participant_data = array(
			'first_name' => $palb2_data['PRÉNOM'],
			'last_name' =>  $palb2_data['NOM'],
			'notes' => 'Created by the Dr Ghadirian data import process.');
		$participant_id = customInsertRecord(array('participants' => $atim_participant_data));
		recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created new participant plus new Breast NoLabo from PALB2 worksheet", "See ".$palb2_data['summary_details'].' (participant_id='.$participant_id.')');
		
		//Misc identifiers
		$misc_identifiers_data = array(
			'misc_identifiers' => array(
				'participant_id' => $participant_id,
				'identifier_value' => $ghadirian_no_labo,
				'misc_identifier_control_id' => $breast_no_labo_control_id,
				'flag_unique' => '1'));
		$atim_participant_data['identifiers'][$breast_no_labo_control_id] = $misc_identifiers_data['misc_identifiers'];
		$atim_participant_data['identifiers'][$breast_no_labo_control_id]['id'] = customInsertRecord($misc_identifiers_data);
		$ghadirian_no_labo++;

		$participant_id_to_collection_data[$participant_id] = array($misc_identifiers_data['misc_identifiers']['identifier_value'], null, null);
		
		//Ghadirian Form
		$table_name = $atim_controls['event_controls']['ghadirian form']['detail_tablename'];
		$event_data = array(
			'event_masters' => array(
				'event_control_id' => $atim_controls['event_controls']['ghadirian form']['id'],
				'participant_id' => $participant_id
			),
			$table_name => array());
		if($palb2_data['Questionnaire de base'])  {
			$event_data[$table_name]['questionnaire'] = $palb2_data['Questionnaire de base'];
			$event_data[$table_name]['questionnaire_accuracy'] = $palb2_data['Questionnaire de base accuracy'];
		}
		if($palb2_data['Questionnaire de base detail']) $event_data[$table_name]['questionnaire_detail'] = $palb2_data['Questionnaire de base detail'];
		if($palb2_data['Lien: # de famille']) $event_data[$table_name]['link_to_family_nbr'] = $palb2_data['Lien: # de famille'];
		if($event_data[$table_name]) {
			$event_data['event_masters']['event_summary'] = $excel_line_data['Notes'];
			customInsertRecord($event_data);
			recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Ghadirian Form from PALB2 worksheet", "See ".$palb2_data['summary_details'].' (participant_id='.$participant_id.')');
		}
		
		//Genetic Test PALB2 ***
		
		if($palb2_data["ID de l'étude PALB2"]) {
			$event_data = array(
				'event_masters' => array(
					'participant_id' => $participant_id,
					'event_control_id' => $atim_controls['event_controls']['genetic test']['id'],
					'event_date' => $palb2_data["Confirmation - Date"],
					'event_date_accuracy' => $palb2_data["Confirmation - Date accuracy"],
					'event_summary' => 'Study : '.$palb2_data["ID de l'étude PALB2"].(strlen($palb2_data["Confirmation - Date detail"])? '. '.$palb2_data["Confirmation - Date detail"] : '').'. Created by the Dr Ghadirian data import process.'),
				$atim_controls['event_controls']['genetic test']['detail_tablename'] => array(
					'site' => $palb2_data["Labo qui a fait le test"],
					'test' => 'PALB2',
					'result' => $palb2_data["Confirmation - Résultat"],
					'detail' => $palb2_data["Mutation PALB2"]));
			if(!$event_data['event_masters']['event_date']) {
				unset($event_data['event_masters']['event_date']);
				unset($event_data['event_masters']['event_date_accuracy']);
			}
			if($palb2_data["2e confirmation detail"]) {
				$event_data['event_masters']['event_summary'] = 'Study : '.$palb2_data["ID de l'étude PALB2"].
				(strlen($palb2_data["Confirmation - Date detail"])? '. '.$palb2_data["Confirmation - Date detail"] : '').
				'. Note about the 2nd confirmation : '.$palb2_data["2e confirmation detail"].
				'. Created by the Dr Ghadirian data import process.';
			}
			customInsertRecord($event_data);
			recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created 'PALB2' Genetic Test from PALB2 worksheet", "Result = '".$palb2_data["Confirmation - Résultat"]."' & detail = '".$palb2_data["Mutation PALB2"]."'. See ".$palb2_data['summary_details'].' (participant_id='.$participant_id.')');
			if($palb2_data["2e confirmation"]) {
				$event_data['event_masters']['event_date'] = $palb2_data["2e confirmation"];
				$event_data['event_masters']['event_date_accuracy'] = $palb2_data["2e confirmation accuracy"];
				$event_data['event_masters']['event_summary'] = 'Study : '.$palb2_data["ID de l'étude PALB2"].
				(strlen($palb2_data["Confirmation - Date detail"])? '. '.$palb2_data["Confirmation - Date detail"] : '').
				'. 2nd confirmation'.
				'. Created by the Dr Ghadirian data import process.';
				if(!$event_data['event_masters']['event_date']) {
					unset($event_data['event_masters']['event_date']);
					unset($event_data['event_masters']['event_date_accuracy']);
				}
				customInsertRecord($event_data);
				recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created 'PALB2' Genetic Test - Confirmation from PALB2 worksheet", "Result = '".$palb2_data["Confirmation - Résultat"]."' & detail = '".$palb2_data["Mutation PALB2"]."'. See ".$palb2_data['summary_details'].' (participant_id='.$participant_id.')');
			}
		} else {
			foreach(array("Confirmation - Date", "Confirmation - Résultat", "2e confirmation", "Confirmation - Résultat", "Mutation PALB2", "Labo qui a fait le test") as $palb2_field) {
				if(strlen($palb2_data[$palb2_field])) die('ERR 2376287 632876');
			}
		}
		
		//Blood and block collection
		if($palb2_data["ID de l'étude PALB2"]) {
			if($palb2_data["Date envoi detail"] && !in_array($palb2_data["Date envoi detail"], array('N/A', 'En attente'))) die('ERR 23723682eee36');
			$aliquot_shipping_name = $palb2_data['Sample ID'].' [Study '.$palb2_data["ID de l'étude PALB2"].']';
			$palb2_data["Échantillon testé"] = str_replace(' ', '', $palb2_data["Échantillon testé"]);
			foreach(explode('+', $palb2_data["Échantillon testé"]) as $new_aliquot_type) {
				$sample_type = '';
				$aliquot_type = '';
				switch($new_aliquot_type) {
					case 'Sang':
						$sample_type = 'blood';
						$aliquot_type = 'tube';
						break;
					case 'Bloc':
						$sample_type = 'tissue';
						$aliquot_type = 'block';
						break;
					default :
						die('ERR 2389728772398723');
				}
				$tmp_data = array(
					'participant_id' => $participant_id,
					'sample_type' => $sample_type,
					'aliquot_type' => $aliquot_type,
					'shipping_name' => $aliquot_shipping_name,
					'institution' => '',
					'datetime_shipped' => $palb2_data["Date envoi"],
					'datetime_shipped_accuracy' => $palb2_data["Date envoi accuracy"],
					'summary_details' => "See".$palb2_data['summary_details']);
				$shipped_items['PALB2'][] = $tmp_data;
			}
		} else {
			foreach(array("Date envoi", "Date envoi detail", "Sample ID") as $palb2_field) {
				if(strlen($palb2_data[$palb2_field]) && !in_array($palb2_data[$palb2_field], array('N/A', 'En attente'))) die('ERR 237623232376');
			}
		}
	}
}

$short_order_title_to_order_ids = array();
foreach($shipped_items as $short_order_title => $shipped_items_set) {
	foreach($shipped_items_set as $new_shipped_item) {
		$participant_id = $new_shipped_item['participant_id'];
		//Order
		if(!isset($short_order_title_to_order_ids[$short_order_title])) {
			$order_data = array(
				'orders' => array(
					'order_number' => "Dr Ghadirian / $short_order_title #".(sizeof($short_order_title_to_order_ids)+1),
					'short_title' => 'Dr Ghadirian to '.$short_order_title,
					'institution' => $new_shipped_item['institution'],
					'comments' => 'Created by the Dr Ghadirian data import process.'));
			$short_order_title_to_order_ids[$short_order_title] = array(
				'order_id' => customInsertRecord($order_data),
				'order_number' => $order_data['orders']['order_number'],
				'order_lines' => array(),
				'shipments' => array(),
				'date_order_placed' => $new_shipped_item['datetime_shipped'],
				'date_order_placed_accuracy' => $new_shipped_item['datetime_shipped_accuracy'],
				'date_order_completed' => $new_shipped_item['datetime_shipped'],
				'date_order_completed_accuracy' => $new_shipped_item['datetime_shipped_accuracy']);
			recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created order", "See order 'Dr Ghadirian to '.$short_order_title'. ".$new_shipped_item['summary_details']);
		} else {
			if(!$short_order_title_to_order_ids[$short_order_title]['date_order_placed'] || ($new_shipped_item['datetime_shipped'] && $new_shipped_item['datetime_shipped'] < $short_order_title_to_order_ids[$short_order_title]['date_order_placed']) ){
				$short_order_title_to_order_ids[$short_order_title]['date_order_placed'] = $new_shipped_item['datetime_shipped'];
				$short_order_title_to_order_ids[$short_order_title]['date_order_placed_accuracy'] = $new_shipped_item['datetime_shipped_accuracy'];
			}
			if(!$short_order_title_to_order_ids[$short_order_title]['date_order_completed'] || ($new_shipped_item['datetime_shipped'] && $new_shipped_item['datetime_shipped'] > $short_order_title_to_order_ids[$short_order_title]['date_order_completed'])) {
				$short_order_title_to_order_ids[$short_order_title]['date_order_completed'] = $new_shipped_item['datetime_shipped'];
				$short_order_title_to_order_ids[$short_order_title]['date_order_completed_accuracy'] = $new_shipped_item['datetime_shipped_accuracy'];
			}
		}
		$order_id = $short_order_title_to_order_ids[$short_order_title]['order_id'];
		// Order Line
		if(!isset($short_order_title_to_order_ids[$short_order_title]['order_lines'][$new_shipped_item['sample_type'].$new_shipped_item['aliquot_type']])) {
			$order_line_data = array(
				'order_lines' => array(
					'order_id' => $order_id,
					'sample_control_id' => $atim_controls['sample_controls'][$new_shipped_item['sample_type']]['id'],
					'aliquot_control_id' => $atim_controls['aliquot_controls'][$new_shipped_item['sample_type'].'-'.$new_shipped_item['aliquot_type']]['id'],
					'status' => 'shipped'));
			$short_order_title_to_order_ids[$short_order_title]['order_lines'][$new_shipped_item['sample_type'].$new_shipped_item['aliquot_type']] = customInsertRecord($order_line_data);
		}
		$order_line_id = $short_order_title_to_order_ids[$short_order_title]['order_lines'][$new_shipped_item['sample_type'].$new_shipped_item['aliquot_type']];
		// Shipment
		if(!isset($short_order_title_to_order_ids[$short_order_title]['shipments'][$new_shipped_item['datetime_shipped'].$new_shipped_item['datetime_shipped_accuracy']])) {
			$shipment_data = array(
				'shipments' => array(
					'order_id' => $order_id,
					'shipment_code' => $short_order_title_to_order_ids[$short_order_title]['order_number'].'-'.(sizeof($short_order_title_to_order_ids[$short_order_title]['shipments'])+1)));
			if($new_shipped_item['datetime_shipped']) {
				$shipment_data['shipments']['datetime_shipped'] = $new_shipped_item['datetime_shipped'];
				$shipment_data['shipments']['datetime_shipped_accuracy'] = ($new_shipped_item['datetime_shipped_accuracy']=='c'? 'h' : $new_shipped_item['datetime_shipped_accuracy']);
			}
			$short_order_title_to_order_ids[$short_order_title]['shipments'][$new_shipped_item['datetime_shipped'].$new_shipped_item['datetime_shipped_accuracy']] = customInsertRecord($shipment_data);
		}
		$shipment_id = $short_order_title_to_order_ids[$short_order_title]['shipments'][$new_shipped_item['datetime_shipped'].$new_shipped_item['datetime_shipped_accuracy']];
		//Order Item : collection
		list($breast_no_labo, $collection_id, $tmp_date) = $participant_id_to_collection_data[$participant_id];
		if(!$collection_id) {
			$collection_data = array(
				'collections' => array(
					'acquisition_label' => 'Dr Darviz Ghadirian',
					'bank_id' => $breast_no_labo_control_id,
					'collection_property' => 'participant collection',
					'collection_notes' => 'Created by the Dr Ghadirian data import process.',
					'participant_id' => $participant_id));
			$collection_id = customInsertRecord($collection_data);
			$participant_id_to_collection_data[$participant_id] = array($breast_no_labo, $collection_id, null);
			recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created 'collection' because no nail collected and aliquot has been shipped", "For NoLabo = '$breast_no_labo'. ".$new_shipped_item['summary_details']);	
		}
		//Order Item : Sample
		$sample_data = array(
			'sample_masters' => array(
				'collection_id' => $collection_id,
				'sample_control_id' => $atim_controls['sample_controls'][$new_shipped_item['sample_type']]['id'],
				'initial_specimen_sample_type' => $new_shipped_item['sample_type'],
				'qc_nd_sample_label' => "",
				'sample_code' => 'TMP_GH'.($sample_conter++),
				'notes' => 'Created by the Dr Ghadirian data import process.'),
			'specimen_details' => array('type_code' => '', 'reception_by' => 'autre'),
			$atim_controls['sample_controls'][$new_shipped_item['sample_type']]['detail_tablename'] => array());
		switch($new_shipped_item['sample_type']) {
			case 'blood':
				$sample_data['sample_masters']['qc_nd_sample_label'] = "S - $breast_no_labo n/a";
				$sample_data['specimen_details']['type_code'] = "S";
				break;
			case 'saliva':
				$sample_data['sample_masters']['qc_nd_sample_label'] = "SA - $breast_no_labo n/a";
				$sample_data['specimen_details']['type_code'] = "SA";
				break;
			case 'tissue':
				$sample_data['sample_masters']['qc_nd_sample_label'] = "BR - $breast_no_labo n/a";
				$sample_data['specimen_details']['type_code'] = "BR";
				$sample_data[$atim_controls['sample_controls'][$new_shipped_item['sample_type']]['detail_tablename']]['tissue_source'] = 'breast';
				$sample_data[$atim_controls['sample_controls'][$new_shipped_item['sample_type']]['detail_tablename']]['tissue_nature'] = 'unknown';
				break;
			default:
				die('ERR/232323');
		}
		$sample_master_id = customInsertRecord($sample_data);
		//Order Item : Aliquot
		$aliquot_data = array(
			'aliquot_masters' => array(
				"barcode" => 'tmp_gh_'.($aliquot_counter++),
				"aliquot_label" => $sample_data['sample_masters']['qc_nd_sample_label'],
				"aliquot_control_id" => $atim_controls['aliquot_controls'][$new_shipped_item['sample_type'].'-'.$new_shipped_item['aliquot_type']]['id'],
				"collection_id" => $collection_id,
				"sample_master_id" => $sample_master_id,
				'in_stock' => 'no',
				'in_stock_detail' => 'shipped',
				'use_counter' => '1',
				'notes' => 'Created by the Dr Ghadirian data import process.'),
			$atim_controls['aliquot_controls'][$new_shipped_item['sample_type'].'-'.$new_shipped_item['aliquot_type']]['detail_tablename'] => array());
		$aliquot_master_id = customInsertRecord($aliquot_data);
		//Order Item : order item
		$order_item_data = array(
			'order_items' => array(
				'order_line_id' => $order_line_id,
				'shipment_id' => $shipment_id,
				'aliquot_master_id' => $aliquot_master_id,
				'shipping_name' => $new_shipped_item['shipping_name'],
				'status' => 'shipped'));
		customInsertRecord($order_item_data);
		recordErrorAndMessage('Data Creation & Update', '@@MESSAGE@@', "Created shipped order item", "Aliquot = '".$sample_data['sample_masters']['qc_nd_sample_label']."'. ".$new_shipped_item['summary_details']);
	}
}
foreach($short_order_title_to_order_ids as $order_data) {
	$tables_data = array();
	if($order_data['date_order_placed']) {
		$tables_data['date_order_placed'] = $order_data['date_order_placed'];
		$tables_data['date_order_placed_accuracy'] = $order_data['date_order_placed_accuracy'];
	}
	if($order_data['date_order_completed']) {
		$tables_data['date_order_completed'] = $order_data['date_order_completed'];
		$tables_data['date_order_completed_accuracy'] = $order_data['date_order_completed_accuracy'];
	}
	if($tables_data) updateTableData($order_data['order_id'], array('orders' => $tables_data));
}
foreach($participant_id_to_collection_data as $participant_id => $New_participant_and_colllection_data) {
	list($breast_no_labo, $collection_id, $collection_date) = $New_participant_and_colllection_data;
	if(!$collection_date) $collection_date = '2005-01-01';
	$consent_data = array(
		'consent_masters' => array(
			'participant_id' => $participant_id,
			'consent_control_id' => $atim_controls['consent_controls']['ghadirian consent']['id'],
			'consent_status' => 'obtained',
			'status_date' => $import_date,
			'status_date_accuracy' => 'c',
			'consent_signed_date' => $collection_date,
			'consent_signed_date_accuracy' => 'y',
			'notes' => ''),
			$atim_controls['consent_controls']['ghadirian consent']['detail_tablename'] => array());
	$consent_master_id = customInsertRecord($consent_data);
	if($collection_id) updateTableData($collection_id, array('collections' => array('consent_master_id' => $consent_master_id)));
}

$queries = array();
$queries[] = "UPDATE sample_masters SET sample_code = id, initial_specimen_sample_id = id WHERE sample_code LIKE 'TMP_GH%'";
$queries[] = "UPDATE aliquot_masters SET barcode = id WHERE barcode LIKE 'tmp_gh_%'";
$queries[] = "UPDATE versions SET permissions_regenerated = 0";
foreach($queries as $query) {
	if($query)  customQuery($query);
}		

$tmp = $import_summary['Data Creation & Update'];
unset($import_summary['Data Creation & Update']);
$import_summary['Data Creation & Update'] = $tmp;

dislayErrorAndMessage(true);

//==================================================================================================================================================================================

function truncate() {
	global $import_date;
	global $imported_by;
	global $atim_controls;
	
	$truncate_date = '2016-06-29 14:33:00';
	
	$queries = array();
	
	$queries[] = "DELETE FROM order_items WHERE created > '$truncate_date' AND created_by = $imported_by";
	$queries[] = "DELETE FROM shipments WHERE created > '$truncate_date' AND created_by = $imported_by";
	$queries[] = "DELETE FROM order_lines WHERE created > '$truncate_date' AND created_by = $imported_by";
	$queries[] = "DELETE FROM orders WHERE created > '$truncate_date' AND created_by = $imported_by";
	
	$queries[] = "DELETE FROM ".$atim_controls['aliquot_controls']['nail-envelope']['detail_tablename']." WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created > '$truncate_date' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM ".$atim_controls['aliquot_controls']['nail-tube']['detail_tablename']." WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created > '$truncate_date' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM ".$atim_controls['aliquot_controls']['saliva-tube']['detail_tablename']." WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created > '$truncate_date' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM ".$atim_controls['aliquot_controls']['blood-tube']['detail_tablename']." WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created > '$truncate_date' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM ".$atim_controls['aliquot_controls']['tissue-block']['detail_tablename']." WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created > '$truncate_date' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM aliquot_masters WHERE created > '$truncate_date' AND created_by = $imported_by";

	$queries[] = "DELETE FROM ".$atim_controls['sample_controls']['nail']['detail_tablename']." WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created > '$truncate_date' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM ".$atim_controls['sample_controls']['blood']['detail_tablename']." WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created > '$truncate_date' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM ".$atim_controls['sample_controls']['saliva']['detail_tablename']." WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created > '$truncate_date' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM ".$atim_controls['sample_controls']['tissue']['detail_tablename']." WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created > '$truncate_date' AND created_by = $imported_by)";
	$queries[] = "DELETE FROM specimen_details WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created > '$truncate_date' AND created_by = $imported_by)";
	$queries[] = "UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null WHERE created > '$truncate_date' AND created_by = $imported_by";
	$queries[] = "DELETE FROM sample_masters WHERE created > '$truncate_date' AND created_by = $imported_by";
	
	$queries[] = "DELETE FROM collections WHERE created > '$truncate_date' AND created_by = $imported_by";
	
	$queries[] = "DELETE FROM ".$atim_controls['event_controls']['ghadirian form']['detail_tablename'];
	$queries[] = "DELETE FROM event_masters WHERE created > '$truncate_date' AND created_by = $imported_by AND event_control_id = ".$atim_controls['event_controls']['ghadirian form']['id'];
	
	$queries[] = "DELETE FROM ".$atim_controls['event_controls']['genetic test']['detail_tablename'];
	$queries[] = "DELETE FROM event_masters WHERE created > '$truncate_date' AND created_by = $imported_by AND event_control_id = ".$atim_controls['event_controls']['genetic test']['id'];
	
	$queries[] = "DELETE FROM participant_contacts WHERE created > '$truncate_date' AND created_by = $imported_by";
	$queries[] = "DELETE FROM family_histories WHERE created > '$truncate_date' AND created_by = $imported_by";
	$queries[] = "DELETE FROM misc_identifiers WHERE created > '$truncate_date' AND created_by = $imported_by";
	
	$queries[] = "DELETE FROM participants WHERE created > '$truncate_date' AND created_by = $imported_by";
	
	foreach($queries as $query) {
		if($query) {
			customQuery($query);
		}
	}
}
	
?>
		