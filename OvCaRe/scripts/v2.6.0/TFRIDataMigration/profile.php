<?php

function updateProfile(&$wroksheetcells, $sheets_keys, $worksheet_name, $atim_controls) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;
	global $voas_to_participant_id;
	
	$summary_msg['Un-migrated VOA#s'] = array();
	
	$headers = array();
	$all_patients_worksheet_voas = array();
	$studied_participant_ids_to_voa = array();
	$participants_family_histories = array();
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
			if($new_line_data['Patient Biobank Number (required & unique)'] == '2237 (2390 blood)') {
				$voa = '2237';
			} else if(preg_match('/^VOA([0-9]+)$/', $new_line_data['Patient Biobank Number (required & unique)'], $matches)) {
				$voa = $matches[1];
			} else if(preg_match('/^([0-9]+)$/', $new_line_data['Patient Biobank Number (required & unique)'], $matches)) {
				$voa = $matches[1];
			} else if(strlen($new_line_data['Patient Biobank Number (required & unique)'])) {
				$summary_msg[$worksheet_name]['@@ERROR@@']["Unable to find VOA# from cell"][] = "Cell val = '".$new_line_data['Patient Biobank Number (required & unique)']."'. No data will be migrated. [Worksheet: $worksheet_name /line: $excel_line_counter]";
			}
			if($voa) {
				if(!array_key_exists($voa, $voas_to_participant_id)) {
					$summary_msg[$worksheet_name]['@@ERROR@@']["Unable to find VOA# into ATiM"][] = "VOA# '".$new_line_data['Patient Biobank Number (required & unique)']."' does not match an ATiM Patient. No data will be migrated. [Worksheet: $worksheet_name /line: $excel_line_counter]";
				} else {
					$all_patients_worksheet_voas[$voa] = $voa;
					$participant_id = $voas_to_participant_id[$voa];
					$studied_participant_ids_to_voa[$participant_id][$voa] = $voa; 
					$query = "SELECT first_name, last_name, date_of_birth, date_of_birth_accuracy, vital_status, ovcare_last_followup_date, ovcare_last_followup_date_accuracy, date_of_death, date_of_death_accuracy, p.notes as participant_notes,
						event_master_id,  brca1_plus, brca2_plus, ovcare_last_followup_date, ovcare_last_followup_date_accuracy
						FROM participants p
						LEFT JOIN event_masters em ON p.id = em.participant_id AND em.deleted <> 1 AND em.event_control_id = ".$atim_controls['event_controls']['brca']['event_control_id']."
						LEFT JOIN ".$atim_controls['event_controls']['brca']['detail_tablename']." ed ON ed.event_master_id = em.id
						WHERE p.id = $participant_id AND p.deleted <> 1;";
					$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
					if($results->num_rows != 1) die('ERR 8838383 '.$participant_id);
					$atim_patient_data = $results->fetch_assoc();
					
					// *** PROFILE ***
					
					$profile_data_to_update = array();
					$update_summary = array();
					//Date of Birth
					$dob_data = getDateAndAccuracy($worksheet_name, $new_line_data, $worksheet_name, 'Date of Birth::Date', 'Date of Birth::date accuracy', $excel_line_counter);
					if($dob_data) {
						$update_profile = false;
						if(!strlen($atim_patient_data['date_of_birth'])) {
							$update_profile = true;
						} else if($atim_patient_data['date_of_birth'] != $dob_data['date']) {
							$update_profile = true;
							$summary_msg[$worksheet_name]['@@WARNING@@']["Date of Birth Conflict"][] = "ATiM date of birth value ".$atim_patient_data['date_of_birth']." (".$atim_patient_data['date_of_birth_accuracy'].") is different than file value ".$dob_data['date'].". Data will be updated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
						}
						if($update_profile) {
							$profile_data_to_update['date_of_birth'] = "date_of_birth = '".$dob_data['date']."'";
							$profile_data_to_update['date_of_birth_accuracy'] = "date_of_birth_accuracy = '".$dob_data['accuracy']."'";
							$update_summary[] = "Date of birth = <b>".$dob_data['date']."(".$dob_data['accuracy'].")</b>";
						}
					}
					//Date of death
					$dod_data = getDateAndAccuracy($worksheet_name, $new_line_data, $worksheet_name, 'Registered Date of Death::Date', 'Registered Date of Death::date accuracy', $excel_line_counter);
					if(!$dod_data) {
						$dod_data = getDateAndAccuracy($worksheet_name, $new_line_data, $worksheet_name, 'Suspected Date of Death::Date', 'Registered Date of Death::date accuracy', $excel_line_counter);
						if($dod_data) {
							$summary_msg[$worksheet_name]['@@WARNING@@']["Suspected Date of Birth"][] = "Only suspected date of death is set in excel file. Used this one as excel date of death. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
						}
					}					
					if($dod_data) {
						$update_profile = false;
						if(!strlen($atim_patient_data['date_of_death'])) {
							$update_profile = true;
						} else if($atim_patient_data['date_of_death'] != $dod_data['date']) {
							$update_profile = true;
							$summary_msg[$worksheet_name]['@@WARNING@@']["Date of Death Conflict"][] = "ATiM date of death value ".$atim_patient_data['date_of_death']." (".$atim_patient_data['date_of_death_accuracy'].") is different than file value ".$dod_data['date'].". Data will updated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
						}
						if($update_profile) {
							$profile_data_to_update['date_of_death'] = "date_of_death = '".$dod_data['date']."'";
							$profile_data_to_update['date_of_death_accuracy'] = "date_of_death_accuracy = '".$dod_data['accuracy']."'";
							$update_summary[] = "Date of death = <b>".$dod_data['date']."(".$dod_data['accuracy'].")</b>";
						}
					}
					//Vital Status
					$file_vital_status = null;
					if($new_line_data['Death::Death']) {
						if(!in_array($new_line_data['Death::Death'], array('dead', 'alive'))) {
							$summary_msg[$worksheet_name]['@@WARNING@@']["Excel Vital Status Error"][] = "File vital status <b>".$new_line_data['Death::Death']."</b> is not supported. Data won't be studied. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
						} else {
							$file_vital_status = ($new_line_data['Death::Death'] == 'dead')? 'deceased' : 'alive';
						}
					} else if($dod_data) {
						$file_vital_status = 'deceased';
						$summary_msg[$worksheet_name]['@@WARNING@@']["Excel Vital Status is missing"][] = "File vital status value is not set but a date of death is set. Set excel vital status to deceased. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
					}
					if($file_vital_status) {
						$update_profile = false;
						if(!strlen($atim_patient_data['vital_status'])) {
							$update_profile = true;
						} else if($atim_patient_data['vital_status'] != $file_vital_status) {
							$update_profile = true;
							$summary_msg[$worksheet_name]['@@WARNING@@']["Vital Status Conflict"][] = "ATiM Vital Status value ".$atim_patient_data['vital_status']." is different than file value $file_vital_status. Data will be updated. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
						}
						if($update_profile) {
							$profile_data_to_update['vital_status'] = "vital_status = '".$file_vital_status."'";
							$update_summary[] = "Vital status = <b>$file_vital_status</b>";
						}
					}
					//Last Contact
					$last_followup_date = getDateAndAccuracy($worksheet_name, $new_line_data, $worksheet_name, 'Date of Last Contact::Date', 'Date of Last Contact::date accuracy', $excel_line_counter);
					if($last_followup_date) {
						$update_last_followup_date = false;
						if(!strlen($atim_patient_data['ovcare_last_followup_date'])) {
							$update_last_followup_date = true;
						} else if($atim_patient_data['ovcare_last_followup_date'] < $last_followup_date['date']) {
							$update_last_followup_date = true;
						}
						if($update_last_followup_date) {
							$profile_data_to_update['ovcare_last_followup_date'] = "ovcare_last_followup_date = '".$last_followup_date['date']."', ovcare_last_followup_date_accuracy = '".$last_followup_date['accuracy']."'";
							$update_summary[] = "Last Followup Date = <b>".$last_followup_date['date']."</b>";
						}
					}
					
					//Notes
					$new_notes = null;
					if(strlen($new_line_data['notes'])) {
						$notes = str_replace("'", "''", $new_line_data['notes']);
						if(strlen($atim_patient_data['participant_notes'])) {
							$profile_data_to_update[] = "notes = CONCAT('$notes', '\n', notes)";
						} else {
							$profile_data_to_update[] = "notes = '$notes'";
						}
						$update_summary[] = "notes= <b>".$new_line_data['notes']."</b>";
					}
					//Update
					if($profile_data_to_update) {
						$profile_data_to_update[] = "modified = '".$modified."', modified_by = '".$modified_by."'";
						$summary_msg['Data Creation/Update Summary'][$participant_id]["Profile Update Summary"][] = "Updated following information : ".implode(',',$update_summary).". See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
						$query = "UPDATE participants SET ".implode(',',$profile_data_to_update)." WHERE id = $participant_id;";
						mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
					}
					
					// *** Family history ***
					
					$family_historires = array();
					$excel_fam_histo = strtolower($new_line_data['family history']);
					if($excel_fam_histo == 'precursor of benign ovarian lesions') {
						$family_historires[] = 'female genital-other female genital';
					} else {
						if(preg_match('/breast cancer/', $excel_fam_histo)) $family_historires[] = 'breast-breast';
						if(preg_match('/colon/', $excel_fam_histo)) $family_historires[] = 'digestive-colonic';
						if(preg_match('/ovarian/', $excel_fam_histo)) $family_historires[] = 'female genital-ovary';
						if(preg_match('/endometrial/', $excel_fam_histo)) $family_historires[] = 'female genital-endometrium';
					}		
					if($family_historires) {
						foreach($family_historires as $new_site) {
							$participants_family_histories[$participant_id]['sites'][$new_site] = $new_site;	//Remove duplication
						}
						$participants_family_histories[$participant_id]['voas'][$voa] =  $voa;
					}
					
					// *** BRCA ***
					
					$file_brca_data = array();
					if($new_line_data['BRCA status']) {
						switch($new_line_data['BRCA status']) {
							case 'BRCA1 mutated':
								$file_brca_data['brca1_plus'] = '1';
								$file_brca_data['brca2_plus'] = '0';
								break;
							case 'BRCA2 mutated':
								$file_brca_data['brca1_plus'] = '0';
								$file_brca_data['brca2_plus'] = '1';
								break;
							case 'BRCA1/2 mutated':
								$file_brca_data['brca1_plus'] = '1';
								$file_brca_data['brca2_plus'] = '1';
								break;
							default:
								$summary_msg[$worksheet_name]['@@WARNING@@']["BRCA"][$new_line_data['BRCA status']] = "ATiM value <b>".$new_line_data['BRCA status']."</b> is not supported. This value won't be used for update.";
						}
					}
					if($file_brca_data) {
						$file_brca_msg = 'BRCA1'.($file_brca_data['brca1_plus']? '+' : '-').' BRCA2'.($file_brca_data['brca2_plus']? '+' : '-');
						if(!$atim_patient_data['event_master_id']) {
							$file_brca_data['event_master_id'] = customInsertRecord(array('participant_id' => $participant_id, 'event_control_id' => $atim_controls['event_controls']['brca']['event_control_id']), 'event_masters', false, true);
							customInsertRecord($file_brca_data, $atim_controls['event_controls']['brca']['detail_tablename'], true, true);
							$summary_msg['Data Creation/Update Summary'][$participant_id]["BRCA Creation"][] = "Created BRCA record: $file_brca_msg. See ATiM participant_id $participant_id (VOA#$voa). [Worksheet: $worksheet_name /line: $excel_line_counter]";
						} else if(($file_brca_data['brca1_plus'] != $atim_patient_data['brca1_plus']) || ($file_brca_data['brca2_plus'] != $atim_patient_data['brca2_plus'])) {
							die('ERR377338383');//To update to use file data
						}
					}
				}
			}
		}
	}
	
	// Family Histories Creation

	foreach($participants_family_histories as $participant_id => $family_histories) {
		foreach($family_histories['sites'] as $new_site) {
			customInsertRecord(array('participant_id' => $participant_id, 'ovcare_tumor_site' => $new_site), 'family_histories', false, true);
		}
		$summary_msg['Data Creation/Update Summary'][$participant_id]["Family History Creation"][] = "Created following family histories : <b>".implode('</b> & <b>',$family_histories['sites'])."</b>. See ATiM participant_id $participant_id (VOA#:".implode(',',$family_histories['voas'])."). [Worksheet: $worksheet_name]";
	}
		
	// Check duplicated participants
	
	$participant_ids_to_skip = array();
	foreach($studied_participant_ids_to_voa as $participant_id => $voas) {
		if(sizeof($voas) > 1) {
			$summary_msg['Un-migrated VOA#s']['@@WARNING@@']["Reason: Duplicated Patient Data"][] = "A patient is listed more than one into this excel file : See ATiM participant_id $participant_id (VOA#:".implode(',',$voas)."). [Worksheet: $worksheet_name]";
			foreach($voas as $voa) $summary_msg['Un-migrated VOA#s']['@@ERROR@@']["Un-migrated VOA#s (Data has to be enter manually into ATiM after migration process)"][$voa] = "VOA#$voa (ATiM participant_id = $participant_id)";
			$participant_ids_to_skip[] = $participant_id;
		}
	}
	
	return array($all_patients_worksheet_voas, $participant_ids_to_skip);
}

?>