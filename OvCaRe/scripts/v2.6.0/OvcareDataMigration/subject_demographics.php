<?php

function checkVoaNbrAndPatientId(&$wroksheetcells) {
	global $summary_msg;
	$max_file_patient_id = 0;
	$voas_matches = array();
	$voa_to_patient_id = array();
	$all_voas_linked_to_another_dup_voa = array();
	$all_dup_voas_alone = array();
	foreach($wroksheetcells as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_id = strlen($new_line_data['Patient ID'])? $new_line_data['Patient ID'] : false;
			$voa = strlen($new_line_data['VOA Number'])? $new_line_data['VOA Number'] : false;
			$dup_voa = strlen($new_line_data['Duplicate Patients::VOA Number'])? $new_line_data['Duplicate Patients::VOA Number'] : false;
			if($voa || $dup_voa) {
				if($voa) {
					if(!isset($voas_matches[$voa])) $voas_matches[$voa][$voa] = $voa;
				}
				if($dup_voa) {
					if(!isset($voas_matches[$dup_voa])) $voas_matches[$dup_voa][$dup_voa] = $dup_voa;
					if(!$voa)$all_dup_voas_alone[$dup_voa] = $dup_voa;
				}
				if($voa && $dup_voa) {
					$voas_matches[$voa][$dup_voa] = $dup_voa;
					$voas_matches[$dup_voa][$voa] = $voa;
					if($voa != $dup_voa) $all_voas_linked_to_another_dup_voa[$voa] = $voa;
				}
				if($patient_id) {
					if($voa) {
						if(isset($voa_to_patient_id[$voa]) && $voa_to_patient_id[$voa] != $patient_id) die('ERR 238787878327');
						$voa_to_patient_id[$voa] = $patient_id;
					}
					if($dup_voa) {
						if(isset($voa_to_patient_id[$dup_voa]) && $voa_to_patient_id[$dup_voa] != $patient_id) die('ERR 238787878328');
						$voa_to_patient_id[$dup_voa] = $patient_id;
					}
					if($max_file_patient_id < $patient_id) $max_file_patient_id = $patient_id;
				}
			} else if($patient_id) {
				die('ERR 32726873628762');
			}
		}
	}
	$dup_voas_in_error = array();
	if(array_diff($all_dup_voas_alone, $all_voas_linked_to_another_dup_voa)) {
		//Dup Voas not correctly linked to a Voa
		$dup_voas_in_error = array_diff($all_dup_voas_alone, $all_voas_linked_to_another_dup_voa);
		$summary_msg['Voa Groups Definition']['@@ERROR@@']['Duplicated V0a'][] = "The following Voa numbers defined as 'Duplicated Voa' seam to be not correctly linked to another Voa in the file : ".implode(',', $dup_voas_in_error).". Please review file and data into ATiM.";
	}
	// Build group
	$next_migration_group_number = 1;
	$voa_to_migration_group_number_for_check = array();
	$voas_groups = array();
	foreach($voas_matches as $linked_voas) {
		$migration_group_numbers_already_assigned = array();
		foreach($linked_voas as $studied_voa) {
			if(isset($voa_to_migration_group_number_for_check[$studied_voa])) {
				$number_already_assigned = $voa_to_migration_group_number_for_check[$studied_voa];
				$migration_group_numbers_already_assigned[$number_already_assigned] = $number_already_assigned;
			}
		}
		$migration_group_number = false;
		if(sizeof($migration_group_numbers_already_assigned) == 0) {
			$migration_group_number = $next_migration_group_number;
			$next_migration_group_number++;
		} else if(sizeof($migration_group_numbers_already_assigned) == 1) {
			$migration_group_number = array_shift($migration_group_numbers_already_assigned);
		} else {
			//error voas of the group already linked to more than one group
			die('ERR 3773738383');
		}
		if(!$migration_group_number) die('ERR 23876287632');
		//Only on migration group number: Assigns this number to all voas
		foreach($linked_voas as $studied_voa) {
			$voa_to_migration_group_number_for_check[$studied_voa] = $migration_group_number;
			if(!isset($voas_groups[$migration_group_number])) $voas_groups[$migration_group_number] = array('voas' => array(), 'patient_ids' => array());
			$voas_groups[$migration_group_number]['voas'][$studied_voa] = $studied_voa;
			if(isset($voa_to_patient_id[$studied_voa])) $voas_groups[$migration_group_number]['patient_ids'][$voa_to_patient_id[$studied_voa]] = $voa_to_patient_id[$studied_voa];
		}
	}
	//Build Voa To Patient_id
	$voa_to_patient_id = array();
	$patient_id_to_migration_group_number = array();
	foreach($voas_groups as $migration_group_number => $new_group) {
		$patient_id = null;
		if(sizeof($new_group['patient_ids']) == 0) {
			$max_file_patient_id++;
			$patient_id = $max_file_patient_id;
//TODO: Do they want we display this message?
			//$summary_msg['Voas Groups Definition']['@@MESSAGE@@']['New Patient ID'][] = "The system created the following Patient Id $patient_id  for following Voas group {".implode(',',$new_group['voas'])."}.";
		} else if(sizeof($new_group['patient_ids']) == 1) {
			$patient_id = array_shift($new_group['patient_ids']);
			if(isset($patient_id_to_migration_group_number[$patient_id])) {
				$summary_msg['Voas Groups Definition']['@@ERROR@@']['Duplicated Patient ID'][] = "The 2 distinct Voas groups are linked to the same Patient ID $patient_id : 1-{".$patient_id_to_migration_group_number[$patient_id]."} and 2-{".implode(',',$new_group['voas'])."}. The system will merge them.";
				$patient_id_to_migration_group_number[$patient_id] .= '//'.implode(',',$new_group['voas']);
			} else {
				$patient_id_to_migration_group_number[$patient_id] = implode(',',$new_group['voas']);
			}
		} else {
			//More than one patient ids for the groups
			die('ERR 2372876387687326823');
		}
		foreach($new_group['voas'] as $voa) {
			$voa_to_patient_id[$voa] = $patient_id;
		}
	}
	return $voa_to_patient_id;
}

function loadAndRecordClinicalData(&$wroksheetcells, $worksheetname, $voa_to_patient_id, &$clinical_outcome_data, $atim_controls) {
	global $db_connection;
	global $summary_msg;
	global $histology_values;
	
	$histology_values = array();
	
	$patient_ids_to_clinical_data = array();
	$voas_to_collection_data = array();
	
	$last_participant_id = 0;
	$last_consent_master_id = 0;
	$last_diagnosis_master_id = 0;
	$last_treatment_master_id = 0;
	
	//===============================================================================================================
	// Load clinical Data And Sort Them Per Patient
	//===============================================================================================================
	
	$atim_studies = loadATiMStudies();
	$patient_identifiers_check = array(
		'medical record number' => array('field' => 'Medical Record Number', 'patient_ids' => array()),
		'personal health number' => array('field' => 'Personal Health Number', 'patient_ids' => array()),
		'bcca number' => array('field' => 'BCCA Number', 'patient_ids' => array()));
	foreach($wroksheetcells as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$voa_nbr = $new_line_data['VOA Number'];
			if(strlen($voa_nbr)) {
				//Get Patient id and VOA#
				if(!array_key_exists($voa_nbr, $voa_to_patient_id)) die("ERR 8839398299292 VOA# = $voa_nbr, line = $excel_line_counter");
				$voa_patient_id = $voa_to_patient_id[$voa_nbr];
				if($new_line_data['Patient ID'] && $new_line_data['Patient ID'] != $voa_patient_id) die("ERR 8763773728903 VOA# = $voa_nbr, line = $excel_line_counter (".$new_line_data['Patient ID']." != $voa_patient_id)");
				
				if(array_key_exists($voa_nbr, $voas_to_collection_data)) die('ERR 993824652823 '.$voa_nbr);
				$voas_to_collection_data[$voa_nbr] = array(
					'participant_id' => null, 
					'consent_master_id' => null, 
					'diagnosis_master_id' => null, 
					'treatment_master_id' => null,
					'collection_datetime' => null,
					'collection_datetime_accuracy' => null);
				
				$patient_voa_nbrs_for_msg = '';
					
				// ** 1 ** LOAD PROFILE & IDENTIFIERS
				
				$summary_message_title = $worksheetname.' : Profile';
				
				//Record Profile
				if(!isset($patient_ids_to_clinical_data[$voa_patient_id])) {
					//New Patient	
					$date_of_birth_tmp = getDateAndAccuracy($summary_message_title, $new_line_data, $worksheetname, 'Date of Birth', $excel_line_counter);
					$patient_ids_to_clinical_data[$voa_patient_id] = array(
						'Participant' => array(
							'id' => (++$last_participant_id),
							'participant_identifier' => $voa_patient_id, 
							'first_name' => $new_line_data['Patient First Name'],
							'last_name' => $new_line_data['Patient Surname'],
							'date_of_birth' => $date_of_birth_tmp['date'],
							'date_of_birth_accuracy' => $date_of_birth_tmp['accuracy'],
							'ovcare_last_followup_date' => null,
							'ovcare_last_followup_date_accuracy' => null),
						'MiscIdentifier' => array(),
						'Consent' => array(),
						'Diagnosis' => array(),
						'Event' => array(),
						'Treatment' => array(),
						'TreatmentExtend' => array(),
						'VOA#s' => array($voa_nbr),
						'vital_status_summary' => array('Profile' => null, 'Diagnosis' => null, 'Followup' => array())
					);
					$patient_voa_nbrs_for_msg = $voa_nbr;
					//Vital Status
					if(isset($clinical_outcome_data[$voa_nbr]) && strlen($clinical_outcome_data[$voa_nbr]['vital_status'])) {
						$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['vital_status'] = $clinical_outcome_data[$voa_nbr]['vital_status'];
						$patient_ids_to_clinical_data[$voa_patient_id]['vital_status_summary']['Profile'] = $clinical_outcome_data[$voa_nbr]['vital_status'];
					}
				} else {
					//Patient has already been parsed
					$patient_ids_to_clinical_data[$voa_patient_id]['VOA#s'][] = $voa_nbr;
					$patient_voa_nbrs_for_msg = implode(', ', $patient_ids_to_clinical_data[$voa_patient_id]['VOA#s']);
					if(strlen($new_line_data['Patient First Name'])) {
						if(!strlen($patient_ids_to_clinical_data[$voa_patient_id]['Participant']['first_name'])) {
							$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['first_name'] = $new_line_data['Patient First Name'];
						} else if($patient_ids_to_clinical_data[$voa_patient_id]['Participant']['first_name'] != $new_line_data['Patient First Name']) {
							$summary_msg[$summary_message_title]['@@ERROR@@']["2 values for field 'Patient First Name'"][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to 2 different values ".$new_line_data['Patient First Name']." & ".$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['first_name']." [Worksheet $worksheetname / line: $excel_line_counter]";
						}
					}
					if(strlen($new_line_data['Patient Surname'])) {
						if(!strlen($patient_ids_to_clinical_data[$voa_patient_id]['Participant']['last_name'])) {
							$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['last_name'] = $new_line_data['Patient Surname'];
						} else if($patient_ids_to_clinical_data[$voa_patient_id]['Participant']['last_name'] != $new_line_data['Patient Surname']) {
							$summary_msg[$summary_message_title]['@@ERROR@@']["2 values for field 'Patient Surname'"][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to 2 different values ".$new_line_data['Patient Surname']." & ".$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['last_name']." [Worksheet $worksheetname / line: $excel_line_counter]";
						}
					}
					if(strlen($new_line_data['Date of Birth'])) {
						$date_field = 'Date of Birth';
						$date_of_birth_tmp = getDateAndAccuracy($summary_message_title, $new_line_data, $worksheetname, $date_field, $excel_line_counter);
						if(!strlen($patient_ids_to_clinical_data[$voa_patient_id]['Participant']['date_of_birth'])) {
							$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['date_of_birth'] = $date_of_birth_tmp['date'];
							$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['date_of_birth_accuracy'] = $date_of_birth_tmp['accuracy'];
						} else if($date_of_birth_tmp['date'].$date_of_birth_tmp['accuracy'] != $patient_ids_to_clinical_data[$voa_patient_id]['Participant']['date_of_birth'].$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['date_of_birth_accuracy']) {
							$summary_msg[$summary_message_title]['@@ERROR@@']["2 values for field 'Date of Birth'"][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to 2 different values ".$date_of_birth_tmp['date']." & ".$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['date_of_birth']." [Worksheet $worksheetname / line: $excel_line_counter]";
						}
					}
					if(isset($clinical_outcome_data[$voa_nbr]) && strlen($clinical_outcome_data[$voa_nbr]['vital_status'])) {
						if(!isset($patient_ids_to_clinical_data[$voa_patient_id]['Participant']['vital_status'])) {
							$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['vital_status'] = $clinical_outcome_data[$voa_nbr]['vital_status'];
							$patient_ids_to_clinical_data[$voa_patient_id]['vital_status_summary']['Profile'] = $clinical_outcome_data[$voa_nbr]['vital_status'];
						} else if($patient_ids_to_clinical_data[$voa_patient_id]['Participant']['vital_status'] != $clinical_outcome_data[$voa_nbr]['vital_status']) {
							$summary_msg[$summary_message_title]['@@ERROR@@']["2 values for field 'Overall Censor'"][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to 2 different values ".$patient_ids_to_clinical_data[$voa_patient_id]['Participant']['vital_status']." & ".$clinical_outcome_data[$voa_nbr]['vital_status']." [Worksheet $worksheetname (plus ClinicalOutcome)/ line: $excel_line_counter]";
						}
					}
				}
				$voas_to_collection_data[$voa_nbr]['participant_id'] = $patient_ids_to_clinical_data[$voa_patient_id]['Participant']['id'];
				$atim_participant_id = $patient_ids_to_clinical_data[$voa_patient_id]['Participant']['id'];
				
				//Record Identifier
				foreach($patient_identifiers_check as $misc_identifier_name => &$identifier_data) {
					$identifier_value = $new_line_data[$identifier_data['field']];
					if(!empty($identifier_value)) {
						if(!empty($patient_ids_to_clinical_data[$voa_patient_id]['MiscIdentifier'][$misc_identifier_name])) {
							if($patient_ids_to_clinical_data[$voa_patient_id]['MiscIdentifier'][$misc_identifier_name] != $identifier_value)
								$summary_msg[$summary_message_title]['@@ERROR@@']["2 ".$misc_identifier_name."s for a same patient"][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to 2 different $misc_identifier_name identifier : ".$patient_ids_to_clinical_data[$voa_patient_id]['MiscIdentifier'][$misc_identifier_name]." & ".$identifier_value.". Second one won't be created. [Worksheet $worksheetname / line: $excel_line_counter]";
						} else if (isset($identifier_data['patient_ids'][$identifier_value])) {
							$summary_msg[$summary_message_title]['@@ERROR@@']["1 ".$misc_identifier_name." assigned to many patients"][] = "$misc_identifier_name value $identifier_value is assigned to many patients [Patient IDs ".implode(', ',$identifier_data['patient_ids'][$identifier_value])."]. Only one patient willbe assigned to this one. See worksheet $worksheetname.";
						} else {
							$patient_ids_to_clinical_data[$voa_patient_id]['MiscIdentifier'][$misc_identifier_name] = $identifier_value;
						}
						$identifier_data['patient_ids'][$identifier_value][$voa_patient_id] = $voa_patient_id;
					}
				}		
								
				// ** 2 ** LOAD CONSENT

				$summary_message_title = $worksheetname.' : Consent';
				
				if($new_line_data['Date of Consent']) {
					$date_consent_tmp = getDateAndAccuracy($summary_message_title, $new_line_data, $worksheetname, 'Date of Consent', $excel_line_counter);
					updateOvcareLastFollowUpDate($patient_ids_to_clinical_data[$voa_patient_id]['Participant'], $date_consent_tmp);
					$date_withdrawn_tmp = getDateAndAccuracy($summary_message_title, $new_line_data, $worksheetname, 'Date Consent Withdrawn', $excel_line_counter);
					updateOvcareLastFollowUpDate($patient_ids_to_clinical_data[$voa_patient_id]['Participant'], $date_withdrawn_tmp);
					$status = '';
					if($new_line_data['Date Consent Withdrawn']) {
						$status = 'withdrawn';
					} else {
						switch($new_line_data['Consent Status']) {
							case '';
								$status = 'obtained';
								$summary_msg[$summary_message_title]['@@WARNING@@']["No consent status"][] = "No status defined for consent '".$date_consent_tmp['date']."' assigned to Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. Set to obtained. [Worksheet $worksheetname / line: $excel_line_counter]";
								break;
							case 'Complete':
								$status = 'obtained';
								break;
							case 'Incomplete':
								$status = 'pending';
								break;
							case 'Not Consented':
								$status = 'denied';
								break;
							default:
								die('ERR Consent 83892387328328 '.$new_line_data['Consent Status']);
						}
					}	
					if(!isset($patient_ids_to_clinical_data[$voa_patient_id]['Consent'][$date_consent_tmp['date']])) {
						//New Consent to create
						$patient_ids_to_clinical_data[$voa_patient_id]['Consent'][$date_consent_tmp['date']] = array(
							'ConsentMaster' => array(
								'id' => (++$last_consent_master_id),
								'participant_id' => $atim_participant_id,
								'consent_control_id' => $atim_controls['consent_control_id'],
								'consent_status' => $status,
								'consent_signed_date' => $date_consent_tmp['date'],
								'consent_signed_date_accuracy' => $date_consent_tmp['accuracy'],
								'ovcare_withdrawn_date' => $date_withdrawn_tmp['date'],
								'ovcare_withdrawn_date_accuracy' => $date_withdrawn_tmp['accuracy']),
							'ConsentDetail' => array('consent_master_id' => $last_consent_master_id),
							'detail_tablename' => 'cd_nationals');
					} else {
						// Get previous consent data and line data to compare
						$previous_consent_data = $patient_ids_to_clinical_data[$voa_patient_id]['Consent'][$date_consent_tmp['date']];
						if($previous_consent_data['ConsentMaster']['consent_status'] != $status) $summary_msg[$summary_message_title]['@@WARNING@@']["Same consent date & Different statuses"][] = "Consent of Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] and defined as signed on ".$date_consent_tmp['date']." is parsed twice with 2 different statuses: [$status] & [".$previous_consent_data['ConsentMaster']['consent_status']."]. [Worksheet $worksheetname / line: $excel_line_counter]";
						if($previous_consent_data['ConsentMaster']['ovcare_withdrawn_date'].$previous_consent_data['ConsentMaster']['ovcare_withdrawn_date_accuracy'] != $date_withdrawn_tmp['date'].$date_withdrawn_tmp['accuracy']) $summary_msg[$summary_message_title]['@@WARNING@@']["Same consent date & Different withdrawn dates"][] = "Consent of Patient ID [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] and defined as signed on ".$date_consent_tmp['date']." is parsed twice with 2 different withdrawn dates ".$date_withdrawn_tmp['date']." & ".$previous_consent_data['ConsentMaster']['ovcare_withdrawn_date'].". [Worksheet $worksheetname / line: $excel_line_counter]";
					}
					$voas_to_collection_data[$voa_nbr]['consent_master_id'] = $patient_ids_to_clinical_data[$voa_patient_id]['Consent'][$date_consent_tmp['date']]['ConsentMaster']['id'];
				} else {
					if($new_line_data['Consent Status']&& $new_line_data['Consent Status'] != 'Not Consented') $summary_msg[$summary_message_title][(($new_line_data['Consent Status'] == 'Incomplete')? '@@MESSAGE@@' : '@@WARNING@@')]["No consent date & status"][] = "No consent has been created (no consent date) but a status ".$new_line_data['Consent Status']." has been defined. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname / line: $excel_line_counter]";
					if($new_line_data['Date Consent Withdrawn']) $summary_msg[$summary_message_title]['@@WARNING@@']["No consent date & withdrawn date"][] = "No consent has been created  (no consent date) but a withdrawn date ".$date_withdrawn_tmp['date']." has been defined. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname / line: $excel_line_counter]";
				}
				
				// ** 3 ** LOAD DIAGNOSIS

				$summary_message_title = $worksheetname.' : Diagnosis';
				
//TODO  Confirm with YING: The all diagnosis design into ATiM
				//check Dx data have been completed				
				$new_dx = false;
				foreach(array('Clinical Diagnosis', 'Clinical History', 'Ovarian Histology', 'Uterine Histology', 'Path Review Type') as $dx_field) {
					$tmp_empty_strg_test = str_replace(array("\n", 'none given', 'none provided',  'not given', 'not provided', 'not specified', 'unknown', 'n/a'), array("", '', '',  '', '', '', '', ''), strtolower($new_line_data[$dx_field]));
					if(strlen($tmp_empty_strg_test)) $new_dx = true;
				}
				if($new_dx || strlen($new_line_data['Site of Origin'])) {
					$dx_key = '';
					foreach(array('Clinical Diagnosis', 'Clinical History', 'Ovarian Histology', 'Uterine Histology', 'Path Review Type', 'Site of Origin') as $dx_field) $dx_key .= $new_line_data[$dx_field];
					$dx_key = md5($dx_key);
					if(!isset($patient_ids_to_clinical_data[$voa_patient_id]['Diagnosis'][$dx_key])) {
						$diagnosis_control_id = null;
						$detail_tablename = null;
						$dx_nature = '';
						$notes = '';
						$diagnosis_details = array();
						$ovcare_tumor_site = str_replace("\n", " ", $new_line_data['Site of Origin']);				
						switch($ovcare_tumor_site) {
							case 'Ovarian Endometrium':
//TODO Confirm with YING: Should we create 2 diagnosis into ATiM or add a flag?							
								$summary_msg[$summary_message_title]['@@WARNING@@']["Ovarian & Endometrium Diagnosis"][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] diagnosis is defined both as Ovarian & Endometrium. Will be just defined as Ovarian. [Worksheet $worksheetname / line: $excel_line_counter]";
								$notes = 'Both Ovarian & Endometrium.';
							case 'Ovarian':
								$ovcare_tumor_site = 'female genital-ovary';
								list($diagnosis_control_id, $detail_tablename) = $atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium'];
								break;
							case '':
//TODO Confirm with YING: All empty will be flagged as ovary							
								$ovcare_tumor_site = 'female genital-ovary';
								list($diagnosis_control_id, $detail_tablename) = $atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium'];
								break;
							case 'Ovarian':
								$ovcare_tumor_site = 'female genital-ovary';
								list($diagnosis_control_id, $detail_tablename) = $atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium'];
								break;
							case 'Endometrium':
								$ovcare_tumor_site = 'female genital-endometrium';
								list($diagnosis_control_id, $detail_tablename) = $atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium'];
								break;
							case 'Benign':
								$dx_nature = 'benign';
							case 'Unknown':
//TODO Replaced by 'Other' in excel file case 'Other…':
							case 'Other':
								$ovcare_tumor_site = 'other-primary unknown';
								list($diagnosis_control_id, $detail_tablename) = $atim_controls['diagnosis_control_ids']['primary']['other'];
								break;		
							case 'Metastasis':
//TODO Confirm with YING: Metastasis means metastase to ovary						
								$ovcare_tumor_site = 'female genital-ovary';
								list($diagnosis_control_id, $detail_tablename) = $atim_controls['diagnosis_control_ids']['secondary']['all'];
								break;
							default:
								die("ERR 23876287 62876 2876 3232 : line: $excel_line_counter /". $ovcare_tumor_site);						
						}
						if($diagnosis_control_id == $atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium'][0]) {
							$diagnosis_details['ovarian_histology'] = getCustomListValue($new_line_data['Ovarian Histology'], 'Ovarian Histology');
							$diagnosis_details['uterine_histology'] = getCustomListValue($new_line_data['Uterine Histology'], 'Uterine Histology');
						} else {
							if(strlen(str_replace("N/A", "", $new_line_data['Ovarian Histology']).str_replace("N/A", "", $new_line_data['Uterine Histology']))) {
								$summary_msg[$summary_message_title]['@@ERROR@@']["Histology values set for Dx different than ovary/endometriuem primary"][] = "Ovarian Histology or Uterine Histology linked to Voa $voa_nbr won't be migrated. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname (plus ClinicalOutcome) / line: $excel_line_counter]";
							}
						}
						//Figo
						if(isset($clinical_outcome_data[$voa_nbr]) && strlen($clinical_outcome_data[$voa_nbr]['figo'])) {
							if($diagnosis_control_id == $atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium'][0]) {
								$diagnosis_details['figo'] = $clinical_outcome_data[$voa_nbr]['figo'];
							} else {
								$summary_msg[$summary_message_title]['@@ERROR@@']["Figo value set for Dx different than ovary/endometriuem primary"][] = "Figo linked to Voa $voa_nbr won't be migrated. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname (plus ClinicalOutcome) / line: $excel_line_counter]";		
							}
						}
						//Censor					
						if(isset($clinical_outcome_data[$voa_nbr]) && strlen($clinical_outcome_data[$voa_nbr]['disease_censor'])) {
							if($diagnosis_control_id == $atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium'][0]) {
								$diagnosis_details['censor'] = $clinical_outcome_data[$voa_nbr]['disease_censor'];	
							} else if($clinical_outcome_data[$voa_nbr]['disease_censor'] == 'y') {
								$summary_msg[$summary_message_title]['@@ERROR@@']["Disease Censor value set for Dx different than ovary/endometriuem primary"][] = "Disease Censor linked to Voa $voa_nbr won't be migrated. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname (plus ClinicalOutcome) / line: $excel_line_counter]";
							}
						}	
						//Record Data
						$patient_ids_to_clinical_data[$voa_patient_id]['Diagnosis'][$dx_key] = array(
							'DiagnosisMaster' => array(
								'id' => (++$last_diagnosis_master_id),
								'participant_id' => $atim_participant_id,
								'diagnosis_control_id' => $diagnosis_control_id,
								'dx_nature' => $dx_nature,	//Will be only displayed for tumor different than Ovary and Endo.
								'ovcare_tumor_site' => $ovcare_tumor_site,
								'ovcare_clinical_diagnosis' => str_replace("'", "''", $new_line_data['Clinical Diagnosis']),
								'ovcare_clinical_history' => str_replace("'", "''", $new_line_data['Clinical History']),
								'ovcare_path_review_type' => getCustomListValue($new_line_data['Path Review Type'], 'Path Review Type'),
								'notes' => $notes),
							'DiagnosisDetail' => array_merge($diagnosis_details, array('diagnosis_master_id' => $last_diagnosis_master_id)),
							'detail_tablename' => $detail_tablename);
					} else {
						//Dx already created
						$summary_msg[$summary_message_title]['@@MESSAGE@@']["Same diagnosis detected"][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to many VOA#s with the same diagnosis. Only one diagnosis will be created. [Worksheet $worksheetname / line: $excel_line_counter]";
						$dx_data = $patient_ids_to_clinical_data[$voa_patient_id]['Diagnosis'][$dx_key];
						if(isset($clinical_outcome_data[$voa_nbr]) && strlen($clinical_outcome_data[$voa_nbr]['figo'])) {
							if(!isset($dx_data['DiagnosisDetail']['figo'])) {
								$patient_ids_to_clinical_data[$voa_patient_id]['Diagnosis'][$dx_key]['DiagnosisDetail']['figo'] = $clinical_outcome_data[$voa_nbr]['figo'];
							} else if($dx_data['DiagnosisDetail']['figo'] != $dx_data['DiagnosisDetail']['figo']) {
								$summary_msg[$summary_message_title]['@@ERROR@@']["Same Diagnosis & Different FIGO"][] = "System defined diagnosis as same but FIGO(s) are different (".$dx_data['DiagnosisDetail']['figo']." != ".$clinical_outcome_data[$voa_nbr]['figo']."). See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname (plus ClinicalOutcome) / line: $excel_line_counter]";
							}
						}
						if(isset($clinical_outcome_data[$voa_nbr]) && strlen($clinical_outcome_data[$voa_nbr]['disease_censor'])) {
							if(!isset($dx_data['DiagnosisDetail']['censor'])) {
								$patient_ids_to_clinical_data[$voa_patient_id]['Diagnosis'][$dx_key]['DiagnosisDetail']['censor'] = $clinical_outcome_data[$voa_nbr]['disease_censor'];
								if($clinical_outcome_data[$voa_nbr]['disease_censor'] == 'y') $patient_ids_to_clinical_data[$voa_patient_id]['vital_status_summary']['Diagnosis'][$dx_key] = 'deceased';
							} else if($dx_data['DiagnosisDetail']['censor'] != $clinical_outcome_data[$voa_nbr]['disease_censor']) {
								$summary_msg[$summary_message_title]['@@ERROR@@']["Same Diagnosis & Different censor"][] = "System defined diagnosis as same but censor(s) are different (".$dx_data['DiagnosisDetail']['censor']." != ".$clinical_outcome_data[$voa_nbr]['disease_censor']."). See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname (plus ClinicalOutcome) / line: $excel_line_counter]";
							}
						}
					}
					$voas_to_collection_data[$voa_nbr]['diagnosis_master_id'] = $patient_ids_to_clinical_data[$voa_patient_id]['Diagnosis'][$dx_key]['DiagnosisMaster']['id'];	
				} else {
					//No new diagnosis
					if(isset($clinical_outcome_data[$voa_nbr]) && strlen($clinical_outcome_data[$voa_nbr]['figo'])) {
						$summary_msg[$summary_message_title]['@@WARNING@@']["No Diagnosis & FIGO"][] = "No diagnosis has been defined but a FIGO disease value ".$clinical_outcome_data[$voa_nbr]['figo']." exists. Data won't be migrated. See Patient ID $voa_patient_id & VOA#s $patient_voa_nbrs_for_msg. [Worksheet $worksheetname (plus ClinicalOutcome) /line: $excel_line_counter]";
					}
					if(isset($clinical_outcome_data[$voa_nbr]) && strlen($clinical_outcome_data[$voa_nbr]['disease_censor'])) {
						$summary_msg[$summary_message_title]['@@WARNING@@']["No Diagnosis & Disease Censor"][] = "No diagnosis has been defined but a Disease Censor disease value ".$clinical_outcome_data[$voa_nbr]['disease_censor']." exists. Data won't be migrated. See Patient ID $voa_patient_id & VOA#s $patient_voa_nbrs_for_msg. [Worksheet $worksheetname (plus ClinicalOutcome) /line: $excel_line_counter]";
					}
				}
				$atim_diagnosis_master_id = $voas_to_collection_data[$voa_nbr]['diagnosis_master_id'];
				
				// ** 4 ** VOA 125
				
//TODO: Faut il lier CA125 a un dx				
				if(preg_match('/CA125\ {0,1}=\ {0,1}([0-9]{1,7})/', $new_line_data['Clinical History'], $matches)) {
					$ev_data = array(
						'EventMaster' => array(
							'id' => null,
							'participant_id' => $atim_participant_id,
							'diagnosis_master_id' => $atim_diagnosis_master_id,
							'event_control_id' => $atim_controls['event_controls']['ca125']['event_control_id']),
						'EventDetail' => array('ca125' => $matches[1]),
						'detail_tablename' => $atim_controls['event_controls']['ca125']['detail_tablename']);
					$patient_ids_to_clinical_data[$voa_patient_id]['Event'][] = $ev_data;
				}
				
				// ** 5 ** LOAD BRCA
				
				if(strlen($new_line_data['BRCA1 Variant'].$new_line_data['BRCA2 Variant'])) die('ERR 63322224');
				if(strlen($new_line_data['BRCA Mutation Status'])) {
					$brca_detail = array('brca1_plus' => '0','brca2_plus' => '0');
					$brca_values = explode("\n", $new_line_data['BRCA Mutation Status']);
					$brca_to_record = false;
					foreach($brca_values as $brca) {
						if(strlen($brca) && $brca != 'Never tested') {
							$brca_to_record = true;
							if(preg_match('/^BRCA([12])\ \+$/', $brca, $matches)) {
								$brca_detail['brca'.$matches[1].'_plus'] = '1';
							} else {							
								die("ERR 934938393993 [$brca] line $excel_line_counter");
							}
						}
					}
					if($brca_to_record) {
						if(!isset($patient_ids_to_clinical_data[$voa_patient_id]['Event']['brca'])) {
							$patient_ids_to_clinical_data[$voa_patient_id]['Event']['brca'] = array(
								'EventMaster' => array(
									'id' => null,
									'participant_id' => $atim_participant_id,
									'diagnosis_master_id' => null,
									'event_control_id' => $atim_controls['event_controls']['brca']['event_control_id']),
								'EventDetail' => $brca_detail,
								'detail_tablename' => $atim_controls['event_controls']['brca']['detail_tablename']);
						} else if(array_diff_assoc($patient_ids_to_clinical_data[$voa_patient_id]['Event']['brca']['EventDetail'], $brca_detail)) {
							die("ERR 911122223 [$brca] line $excel_line_counter");
						}
					}
				}
				
				// ** 6 ** LOAD STUDY
				
				if(strlen($new_line_data['Study Inclusion'])) {
					$studies = explode("\n", strtolower($new_line_data['Study Inclusion']));
					foreach($studies as $study) {
						if($study) {
							$study = str_replace('tfri couer','tfri coeur', $study);
							if(isset($atim_studies[$study])) {
								$patient_ids_to_clinical_data[$voa_patient_id]['Event'][$study] = array(
									'EventMaster' => array(
										'id' => null,
										'participant_id' => $atim_participant_id,
										'diagnosis_master_id' => null,
										'event_control_id' => $atim_controls['event_controls']['study inclusion']['event_control_id']),
									'EventDetail' => array(
										'study_summary_id' => $atim_studies[$study]),
									'detail_tablename' => $atim_controls['event_controls']['study inclusion']['detail_tablename']);
							} else {
								die("ERR 99122938774 [$study] line: $excel_line_counter");
							}
						}	
					}			
				}
				
				// ** 7 ** LOAD SURGERY

				$summary_message_title = $worksheetname.' : Treatment';
				
				if(strlen($new_line_data['Neoadjuvant Chemotherpay Given'].$new_line_data['Adjuvant Radiation'].$new_line_data['Date of Procedure'].$new_line_data['Surgical Pathology Number'])) {
					$treatment_master_id = null;
					$tx_detail = array();
					//Neoadjuvant Chemotherpay
					if($new_line_data['Neoadjuvant Chemotherpay Given']) {
						if(!in_array($new_line_data['Neoadjuvant Chemotherpay Given'], array('Yes','No', 'Unknown'))) die('ERR 884884882 '.$excel_line_counter);
						$tx_detail['ovcare_neoadjuvant_chemotherapy'] = str_replace(array('Yes','No', 'Unknown'), array('y','n', ''), $new_line_data['Neoadjuvant Chemotherpay Given']);
					}
					//Adjuvant Radiation
					if($new_line_data['Adjuvant Radiation']) {
						if(!in_array($new_line_data['Adjuvant Radiation'], array('Yes','No', 'Unknown'))) die('ERR 884884882 '.$excel_line_counter);
						$tx_detail['ovcare_adjuvant_radiation'] = str_replace(array('Yes','No', 'Unknown'), array('y','n', ''), $new_line_data['Adjuvant Radiation']);
					}
					//Surgical Pathology Number
					if($new_line_data['Surgical Pathology Number']) {
						if(strlen($new_line_data['Surgical Pathology Number']) > 50) die('ERR 872224882 '.$excel_line_counter);
						$tx_detail['path_num'] = $new_line_data['Surgical Pathology Number'];
					}
					//Age At Surgery
					$date_tx_tmp = getDateAndAccuracy($summary_message_title, $new_line_data, $worksheetname, 'Date of Procedure', $excel_line_counter);
					updateOvcareLastFollowUpDate($patient_ids_to_clinical_data[$voa_patient_id]['Participant'], $date_tx_tmp);
					$procedure_date = $date_tx_tmp['date'];
					$procedure_date_accuracy = $date_tx_tmp['accuracy'];
					$date_of_birth = $patient_ids_to_clinical_data[$voa_patient_id]['Participant']['date_of_birth'];
					$date_of_birth_accuracy = $patient_ids_to_clinical_data[$voa_patient_id]['Participant']['date_of_birth_accuracy'];
					$ovcare_age_at_surgery = '';
					$ovcare_age_at_surgery_precision = 'missing information';
					if($date_of_birth && $procedure_date) {
						$DateOfBirthObj = new DateTime($date_of_birth);
						$ProcedureDateObj = new DateTime($procedure_date);
						$interval = $DateOfBirthObj->diff($ProcedureDateObj);
						$ovcare_age_at_surgery = $interval->format('%r%y');
						if($ovcare_age_at_surgery < 0) {
							$ovcare_age_at_surgery = '';
							$ovcare_age_at_surgery_precision = "date error";
							$summary_msg[$summary_message_title]['@@ERROR@@']["Birth Date & Surgery Date error"][] = "Surgery Date [$procedure_date] < Brith Date [$date_of_birth]. Age at surgery can not be generated. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname / line: $excel_line_counter]";
						} else if(!(in_array($procedure_date_accuracy, array('c')) && in_array($date_of_birth_accuracy, array('c')))) {
							$ovcare_age_at_surgery_precision = "approximate";
						} else {
							$ovcare_age_at_surgery_precision = "exact";
						}
					}
					$tx_detail['ovcare_age_at_surgery'] = $ovcare_age_at_surgery;
					$tx_detail['ovcare_age_at_surgery_precision'] = $ovcare_age_at_surgery_precision;
					//Residual Disease
					if(isset($clinical_outcome_data[$voa_nbr]) && strlen($clinical_outcome_data[$voa_nbr]['ovcare_residual_disease'])) {
						$tx_detail['ovcare_residual_disease'] = $clinical_outcome_data[$voa_nbr]['ovcare_residual_disease'];				
					}
					//Recod Surgery					
					if(empty($procedure_date)) {
						$next_id = sizeof($patient_ids_to_clinical_data[$voa_patient_id]['Treatment']) + 1;
						$patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$next_id] = array(
							'TreatmentMaster' => array(
								'id' => (++$last_treatment_master_id),
								'participant_id' => $atim_participant_id,
								'diagnosis_master_id' => $atim_diagnosis_master_id,
								'treatment_control_id' => $atim_controls['treatment_controls']['procedure - surgery']['treatment_control_id'],
								'start_date' => $procedure_date,
								'start_date_accuracy' => $procedure_date_accuracy),
							'TreatmentDetail' => array_merge($tx_detail, array('treatment_master_id' => $last_treatment_master_id)),
							'detail_tablename' => $atim_controls['treatment_controls']['procedure - surgery']['detail_tablename']);
						$treatment_master_id = $patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$next_id]['TreatmentMaster']['id'];
						$summary_msg[$summary_message_title]['@@WARNING@@']["No Surgery Date"][] = "No surgery date (Procedure date) has been defined. Sugery will be created with no treatment date. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname / line: $excel_line_counter]";
					} else if(!isset($patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date])) {
						$patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date] = array(
							'TreatmentMaster' => array(
								'id' => (++$last_treatment_master_id),
								'participant_id' => $atim_participant_id,
								'diagnosis_master_id' => $atim_diagnosis_master_id,
								'treatment_control_id' => $atim_controls['treatment_controls']['procedure - surgery']['treatment_control_id'],
								'start_date' => $procedure_date,
								'start_date_accuracy' => $procedure_date_accuracy),
							'TreatmentDetail' => array_merge($tx_detail, array('treatment_master_id' => $last_treatment_master_id)),
							'detail_tablename' => $atim_controls['treatment_controls']['procedure - surgery']['detail_tablename']);
						$treatment_master_id = $patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentMaster']['id'];
					} else {
						//Compare Master Data
						$diff_found = false;
						if($atim_diagnosis_master_id) {
							//Treatment has to be linked to a diagnosis: check it's the same
							if(!$patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentMaster']['diagnosis_master_id']) {
								$patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentMaster']['diagnosis_master_id'] = $atim_diagnosis_master_id;
							} else if($atim_diagnosis_master_id != $patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentMaster']['diagnosis_master_id']) {
								$diff_found = true;
								$summary_msg[$summary_message_title]['@@ERROR@@']["Same Surgery & Different diagnoses"][] = "A surgery on $procedure_date is defined as linked to 2 different diagnoses. Will link surgery to the first diagnosis. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname / line: $excel_line_counter]";
							}
						}
						//Compare Detail Data
						$previous_treatment_details = $patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail'];
						if(isset($tx_detail['ovcare_neoadjuvant_chemotherapy'])) {
							if(!isset($previous_treatment_details['ovcare_neoadjuvant_chemotherapy'])) {
								$patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['ovcare_neoadjuvant_chemotherapy'] = $tx_detail['ovcare_neoadjuvant_chemotherapy'];
							} else if($previous_treatment_details['ovcare_neoadjuvant_chemotherapy'] != $tx_detail['ovcare_neoadjuvant_chemotherapy']) {
								$diff_found = true;
								$summary_msg[$summary_message_title]['@@WARNING@@']["Same Surgery Date & Different neoadjuvant chemotherapy"][] = "2 surgeries on $procedure_date are defined as same (same date) by migration process but Neoadjuvant Chemo defintions are different (".$previous_treatment_details['ovcare_neoadjuvant_chemotherapy']." != ".$tx_detail['ovcare_neoadjuvant_chemotherapy']."). See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname / line: $excel_line_counter]";
							}
						}
						if(isset($tx_detail['ovcare_adjuvant_radiation'])) {
							if(!isset($previous_treatment_details['ovcare_adjuvant_radiation'])) {
								$patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['ovcare_adjuvant_radiation'] = $tx_detail['ovcare_adjuvant_radiation'];
							} else if($previous_treatment_details['ovcare_adjuvant_radiation'] != $tx_detail['ovcare_adjuvant_radiation']) {
								$diff_found = true;
								$summary_msg[$summary_message_title]['@@ERROR@@']["Same Surgery Date & Different adjuvant radiation"][] = "2 surgeries on $procedure_date are defined as same (same date) by migration process but Adjuvant Radiation definitions are different (".$previous_treatment_details['ovcare_adjuvant_radiation']." != ".$tx_detail['ovcare_adjuvant_radiation']."). See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname / line: $excel_line_counter]";
							}
						}
						if(isset($tx_detail['path_num'])) {
							if(!isset($previous_treatment_details['path_num'])) {
								$patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['path_num'] = $tx_detail['path_num'];
							} else if($previous_treatment_details['path_num'] != $tx_detail['path_num']) {
								$diff_found = true;
								$summary_msg[$summary_message_title]['@@ERROR@@']["Same Surgery Date & Different patho number"][] = "2 surgeries on $procedure_date are defined as same (same date) by migration process but Patho Numbers are different (".$previous_treatment_details['path_num']." != ".$tx_detail['path_num']."). See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname / line: $excel_line_counter]";
							}
						}
						if($tx_detail['ovcare_age_at_surgery'] != $tx_detail['ovcare_age_at_surgery'] || $tx_detail['ovcare_age_at_surgery_precision'] != $tx_detail['ovcare_age_at_surgery_precision']) die('ERR 883737 883838 3');
						if(isset($tx_detail['ovcare_residual_disease'])) {
							if(!isset($previous_treatment_details['ovcare_residual_disease'])) {
								$patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['ovcare_residual_disease'] = $tx_detail['ovcare_residual_disease'];
							} else if($previous_treatment_details['ovcare_residual_disease'] != $tx_detail['ovcare_residual_disease']) {
								$diff_found = true;
								$summary_msg[$summary_message_title]['@@ERROR@@']["Same Surgery Date & Different residual disease values"][] = "2 surgeries on $procedure_date are defined as same (same date) by migration process but Residual Disease values are different (".$previous_treatment_details['ovcare_residual_disease']." != ".$tx_detail['ovcare_residual_disease']."). See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname (plus ClinicalOutcome) / line: $excel_line_counter]";
							}
						}
						//Res
						if(!$diff_found) $summary_msg[$summary_message_title]['@@MESSAGE@@']["Same Surgery"][] = "2 surgeries on $procedure_date are defined as same (same date) by migration process. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheetname / line: $excel_line_counter]";
						$treatment_master_id = $patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentMaster']['id'];
					}
					$voas_to_collection_data[$voa_nbr]['treatment_master_id'] = $treatment_master_id;
					$voas_to_collection_data[$voa_nbr]['collection_datetime'] = $procedure_date;
					$voas_to_collection_data[$voa_nbr]['collection_datetime_accuracy'] = $procedure_date_accuracy;
				} else {
					//No surgery linked to this VOa
					if(isset($clinical_outcome_data[$voa_nbr]) && strlen($clinical_outcome_data[$voa_nbr]['ovcare_residual_disease'])) {
						$summary_msg[$summary_message_title]['@@WARNING@@']["No Treatment & Residual Disease"][] = "No surgery has been defined in Profile but a residual disease value ".$clinical_outcome_data[$voa_nbr]['ovcare_residual_disease']." exists. Data won't be migrated. See Patient ID $voa_patient_id & VOA#s $patient_voa_nbrs_for_msg. [Worksheet $worksheetname (plus ClinicalOutcome) /line: $excel_line_counter]";
					}
				}
								
				// ** 8 ** FOLLOW UP
		
				if(isset($clinical_outcome_data[$voa_nbr])) {
//TODO: Faut il lier FOLLOW UP a un dx					
					if(strlen($clinical_outcome_data[$voa_nbr]['last_followup_date'].$clinical_outcome_data[$voa_nbr]['last_followup_date_accuracy'].$clinical_outcome_data[$voa_nbr]['last_followup_vital_status'])) {
						updateOvcareLastFollowUpDate($patient_ids_to_clinical_data[$voa_patient_id]['Participant'], array('date' => $clinical_outcome_data[$voa_nbr]['last_followup_date'], 'accuracy' => $clinical_outcome_data[$voa_nbr]['last_followup_date_accuracy']));
						$ev_data = array(
							'EventMaster' => array(
								'id' => null,
								'participant_id' => $atim_participant_id,
								'diagnosis_master_id' => null,
								'event_control_id' => $atim_controls['event_controls']['follow up']['event_control_id'],
								'event_date' => $clinical_outcome_data[$voa_nbr]['last_followup_date'],
								'event_date_accuracy' => $clinical_outcome_data[$voa_nbr]['last_followup_date_accuracy']),
							'EventDetail' => array('vital_status' => $clinical_outcome_data[$voa_nbr]['last_followup_vital_status']),
							'detail_tablename' => $atim_controls['event_controls']['follow up']['detail_tablename']);
						$patient_ids_to_clinical_data[$voa_patient_id]['Event'][] = $ev_data;
						if(strlen($clinical_outcome_data[$voa_nbr]['last_followup_vital_status'])) {
							if(isset($patient_ids_to_clinical_data[$voa_patient_id]['vital_status_summary']['Followup'][$clinical_outcome_data[$voa_nbr]['last_followup_date']])) {
								die('ERR238732687 326');
							} else {
								$patient_ids_to_clinical_data[$voa_patient_id]['vital_status_summary']['Followup'][$clinical_outcome_data[$voa_nbr]['last_followup_date']] = $clinical_outcome_data[$voa_nbr]['last_followup_vital_status'];
							}
						}
					}
				}
				
				// ** 9 ** CHEMOTHERAPY
				
				if(isset($clinical_outcome_data[$voa_nbr]) && !empty($clinical_outcome_data[$voa_nbr]['chemos'])) {
					foreach($clinical_outcome_data[$voa_nbr]['chemos'] as $chemo_data) {
						updateOvcareLastFollowUpDate($patient_ids_to_clinical_data[$voa_patient_id]['Participant'], array('date' => $chemo_data['start_date'], 'accuracy' => $chemo_data['start_date_accuracy']));
						updateOvcareLastFollowUpDate($patient_ids_to_clinical_data[$voa_patient_id]['Participant'], array('date' => $chemo_data['end_date'], 'accuracy' => $chemo_data['end_date_accuracy']));
						$next_id = sizeof($patient_ids_to_clinical_data[$voa_patient_id]['Treatment']) + 1;
						$patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$next_id] = array(
							'TreatmentMaster' => array(
								'id' => (++$last_treatment_master_id),
								'participant_id' => $atim_participant_id,
								'diagnosis_master_id' => $atim_diagnosis_master_id,
								'treatment_control_id' => $atim_controls['treatment_controls']['chemotherapy']['treatment_control_id'],
								'start_date' => $chemo_data['start_date'],
								'start_date_accuracy' => $chemo_data['start_date_accuracy'],
								'finish_date' => $chemo_data['end_date'],
								'finish_date_accuracy' => $chemo_data['end_date_accuracy']),
							'TreatmentDetail' => array('treatment_master_id' => $last_treatment_master_id),
							'detail_tablename' => $atim_controls['treatment_controls']['chemotherapy']['detail_tablename']);
						$treatment_master_id = $patient_ids_to_clinical_data[$voa_patient_id]['Treatment'][$next_id]['TreatmentMaster']['id'];
						foreach($chemo_data['drugs'] as $new_drug) {
							$drug_id = getChemoDrugId($new_drug);
							$patient_ids_to_clinical_data[$voa_patient_id]['TreatmentExtend'][] = array(
								'TreatmentExtendMaster' => array(
									'id' => null,
									'treatment_master_id' => $treatment_master_id,
									'treatment_extend_control_id' => $atim_controls['treatment_controls']['chemotherapy']['te_treatment_control_id']),
								'TreatmentExtendDetail' => array(
									'drug_id' => $drug_id),
								'detail_tablename' => $atim_controls['treatment_controls']['chemotherapy']['te_detail_tablename']);
						}
					}
				}
				
				// END VOA data
				unset($clinical_outcome_data[$voa_nbr]);
			}
		}
	}	
	unset($patient_identifiers_check);
	if(!empty($clinical_outcome_data)) die('ERR 237687 68732');
	
	//===============================================================================================================
	// RECORD CLINICAL ANNOTATION DATA
	//===============================================================================================================
	
	$summary_message_title = 'Clinical Data Record';
	
	$secondary_diagnosis_control_ids = array();
	foreach($atim_controls['diagnosis_control_ids']['secondary'] as $new_secondary_control) $secondary_diagnosis_control_ids[] = $new_secondary_control[0];
	
	foreach($patient_ids_to_clinical_data as $patient_id => $clinical_annotation_data) {
		
		// Vital Statuses Control
		$follow_up_vital_status = null;
		if($clinical_annotation_data['vital_status_summary']['Followup']) {
			ksort($clinical_annotation_data['vital_status_summary']['Followup']);
			foreach($clinical_annotation_data['vital_status_summary']['Followup'] as $date => $new_status) {
				if(!$follow_up_vital_status) {
					$follow_up_vital_status = $new_status;
				} else if($follow_up_vital_status == 'alive' && $new_status == 'deceased') {
					$follow_up_vital_status == 'deceased';
					$summary_msg[$summary_message_title]['@@ERROR@@']["Status Mis-Match"][] = "The Follow-Up Vital Status was intialy set to 'alive' checking status of the most recent Follow-Up. But the status of an older Follow-up  was set to 'deceased'. See Patient [Patient ID $patient_id / VOA#(s) ".implode(',',$clinical_annotation_data['VOA#s'])."].";
				}			
			}
		}
		$defined_as_deceased_in_dx = false;
		if(!empty($clinical_annotation_data['vital_status_summary']['Diagnosis'])) {
			//At least on diagnosis censor has been flagged to 'yes' (deceased from this disease)
			if(sizeof($clinical_annotation_data['vital_status_summary']['Diagnosis']) > 1) {
				$summary_msg[$summary_message_title]['@@WARNING@@']["Censor"][] = "The censor value has been set to 'yes' for more than one diagnosis. See Patient [Patient ID $patient_id / VOA#(s) ".implode(',',$clinical_annotation_data['VOA#s'])."].";
			}
			$defined_as_deceased_in_dx = true;
		}

		if($follow_up_vital_status == 'deceased' || $defined_as_deceased_in_dx) {
			if(isset($clinical_annotation_data['Participant']['vital_status']) && $clinical_annotation_data['Participant']['vital_status'] == 'alive') {
				$summary_msg[$summary_message_title]['@@ERROR@@']["Vital Status MisMatch"][] = "Vital status was set to 'alive' but patients was defined as deceased based on diagnosis or follow up data. Will set vital status to 'descased'. See Patient [Patient ID $patient_id / VOA#(s) ".implode(',',$clinical_annotation_data['VOA#s'])."].";
			} else if(!isset($clinical_annotation_data['Participant']['vital_status']) || !$clinical_annotation_data['Participant']['vital_status']) {
				$summary_msg[$summary_message_title]['@@MESSAGE@@']["Vital Status Completion"][] = "Vital status was set to 'decaesed' based on diagnosis or follow up data. Will set vital status to 'descased'. See Patient [Patient ID $patient_id / VOA#(s) ".implode(',',$clinical_annotation_data['VOA#s'])."].";
				$clinical_annotation_data['Participant']['vital_status'] = 'deceased';
			}
			$clinical_annotation_data['Participant']['vital_status'] = 'deceased';
		}
		
		// PARTICIPANT
		
		$atim_participant_id = customInsertRecord($clinical_annotation_data['Participant'], 'participants', false);
		
		// MISC IDENTIFIER
		
		foreach($clinical_annotation_data['MiscIdentifier'] as $misc_identifier_name => $identifier_value) {		
			if(!isset($atim_controls['misc_identifier_controls'][$misc_identifier_name])) die('ERR 838721782647623482');
			$tmp_data = array('misc_identifier_control_id' => $atim_controls['misc_identifier_controls'][$misc_identifier_name]['id'], 
				'participant_id' => $atim_participant_id, 
				'flag_unique' => $atim_controls['misc_identifier_controls'][$misc_identifier_name]['flag_unique'], 
				'identifier_value' => $identifier_value
			);			
			customInsertRecord($tmp_data, 'misc_identifiers', false);
		}
		
		// CONSENT
		
		foreach($clinical_annotation_data['Consent'] as &$consent_data) {
			customInsertRecord($consent_data['ConsentMaster'], 'consent_masters', false);
			customInsertRecord($consent_data['ConsentDetail'], $consent_data['detail_tablename'], true);
		}
		
		// DIAGNOSIS
		
		foreach($clinical_annotation_data['Diagnosis'] as $diagnosis_key => $diagnosis_data) {
			if(in_array($diagnosis_data['DiagnosisMaster']['diagnosis_control_id'], $secondary_diagnosis_control_ids)) {
				//*** Create a Primary ***
				list($diagnosis_control_id, $detail_tablename) = $atim_controls['diagnosis_control_ids']['primary']['other'];
				// Master
				$primary_diagnosis_master_data = array(
						'id' => (++$last_diagnosis_master_id),
						'primary_id' => $last_diagnosis_master_id,
						'participant_id' => $atim_participant_id,
						'diagnosis_control_id' => $diagnosis_control_id,
						'ovcare_tumor_site' => 'other-primary unknown',
						'ovcare_clinical_diagnosis' => $diagnosis_data['DiagnosisMaster']['ovcare_clinical_diagnosis'],
						'ovcare_clinical_history' => $diagnosis_data['DiagnosisMaster']['ovcare_clinical_history'],
						'ovcare_path_review_type' => $diagnosis_data['DiagnosisMaster']['ovcare_path_review_type']
				);
				unset($diagnosis_data['DiagnosisMaster']['ovcare_clinical_diagnosis']);
				unset($diagnosis_data['DiagnosisMaster']['ovcare_clinical_history']);
				unset($diagnosis_data['DiagnosisMaster']['ovcare_path_review_type']);
				$primary_diagnosis_master_id = customInsertRecord($primary_diagnosis_master_data, 'diagnosis_masters', false);
				// Detail
				customInsertRecord(array('diagnosis_master_id' => $primary_diagnosis_master_id), $detail_tablename, true);
				//*** Set Secondary _id fields ***
				$diagnosis_data['DiagnosisMaster']['parent_id'] = $last_diagnosis_master_id;
				$diagnosis_data['DiagnosisMaster']['primary_id'] = $last_diagnosis_master_id;
			} else {
				$diagnosis_data['DiagnosisMaster']['primary_id'] = $diagnosis_data['DiagnosisMaster']['id'];
			}
			//*** Record New Diagnosis ***
			customInsertRecord($diagnosis_data['DiagnosisMaster'], 'diagnosis_masters', false);
			customInsertRecord($diagnosis_data['DiagnosisDetail'], $diagnosis_data['detail_tablename'], true);
		}
		
		// EVENT
		
		foreach($clinical_annotation_data['Event'] as &$event_data) {
			$event_master_id = customInsertRecord($event_data['EventMaster'], 'event_masters', false);
			customInsertRecord(array_merge($event_data['EventDetail'], array('event_master_id' => $event_master_id)), $event_data['detail_tablename'], true);
		}	
		
		// TREATMENT
		
		foreach($clinical_annotation_data['Treatment'] as &$treatment_data) {
			customInsertRecord($treatment_data['TreatmentMaster'], 'treatment_masters', false);
			customInsertRecord($treatment_data['TreatmentDetail'], $treatment_data['detail_tablename'], true);
		}	

		// TREATMENT EXTEND
		
		foreach($clinical_annotation_data['TreatmentExtend'] as &$treatment_data) {
			$treatment_extend_master_id = customInsertRecord($treatment_data['TreatmentExtendMaster'], 'treatment_extend_masters', false);
			$treatment_data['TreatmentExtendDetail']['treatment_extend_master_id'] = $treatment_extend_master_id;
			customInsertRecord($treatment_data['TreatmentExtendDetail'], $treatment_data['detail_tablename'], true);
		}
	}
	unset($patient_ids_to_clinical_data);
	
	//===============================================================================================================
	// UPDATE Last Follow-Up Date & Initial Surgery Date & Survival Time in Months 
	// Note: No recurrence is migrated so initial_recurrence_date... won't be set
	// TODO: To confirm
	//===============================================================================================================
	
	$query = "SELECT Participant.participant_identifier,
		Participant.id AS participant_id, 
		DiagnosisMaster.id AS diagnosis_master_id, 
		TreatmentMaster.id AS treatment_master_id,
		Participant.ovcare_last_followup_date, 
		Participant.ovcare_last_followup_date_accuracy, 
		TreatmentMaster.start_date, 
		TreatmentMaster.start_date_accuracy
		FROM participants Participant
		INNER JOIN diagnosis_masters DiagnosisMaster ON Participant.id = DiagnosisMaster.participant_id 
		INNER JOIN treatment_masters TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id
		WHERE DiagnosisMaster.diagnosis_control_id = ".$atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium'][0].
		" AND TreatmentMaster.treatment_control_id = ".$atim_controls['treatment_controls']['procedure - surgery']['treatment_control_id'].
		" ORDER BY Participant.id ASC, TreatmentMaster.start_date ASC;";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
	$participant_data_to_update = array();
	while($row = $results->fetch_assoc()){	
		$atim_participant_id = $row['participant_id'];
		$diagnosis_master_id = $row['diagnosis_master_id'];
		if($row['ovcare_last_followup_date']) {
			$participant_data_to_update[$atim_participant_id]['participant_identifier'] = $row['participant_identifier'];
			$participant_data_to_update[$atim_participant_id]['ovcare_last_followup_date'] = $row['ovcare_last_followup_date'];
			$participant_data_to_update[$atim_participant_id]['ovcare_last_followup_date_accuracy'] = $row['ovcare_last_followup_date_accuracy'];
			if(!isset($participant_data_to_update[$atim_participant_id]['Diagnosis'][$diagnosis_master_id])) {
				$participant_data_to_update[$atim_participant_id]['Diagnosis'][$diagnosis_master_id] = array(
					'existing_empty_surgery_date' => false, 
					'initial_surgery_date' => null, 
					'initial_surgery_date_accuracy' => null);
			}
			if(empty($row['start_date'])) {
				$participant_data_to_update[$atim_participant_id]['Diagnosis'][$diagnosis_master_id]['existing_empty_surgery_date'] = true;
			} else if(!isset($participant_data_to_update[$atim_participant_id]['Diagnosis'][$diagnosis_master_id]['initial_surgery_date'])) {
				$participant_data_to_update[$atim_participant_id]['Diagnosis'][$diagnosis_master_id]['initial_surgery_date'] = $row['start_date'];
				$participant_data_to_update[$atim_participant_id]['Diagnosis'][$diagnosis_master_id]['initial_surgery_date_accuracy'] = $row['start_date_accuracy'];
			}
		}
	}
	
	// UPDATE participant
	foreach($participant_data_to_update as $atim_participant_id => $part_data) {
		$lastFollDateObj = new DateTime($part_data['ovcare_last_followup_date']);
		foreach($part_data['Diagnosis'] as $diagnosis_master_id => $dx_data) {
			//New Ovary & Endometrium Dx
			if($dx_data['initial_surgery_date']) {
				$initialSurgeryDateObj = new DateTime($dx_data['initial_surgery_date']);
				$interval = $initialSurgeryDateObj->diff($lastFollDateObj);
				$survival_time_months = $interval->format('%r%y')*12 + $interval->format('%r%m');
				$survival_time_months_precision = "";
				if($survival_time_months < 0) {
					$survival_time_months = '';
					$survival_time_months_precision = "date error";
					$summary_msg[$worksheetname.' : Diagnosis']['@@WARNING@@']['Survival time'][] = "Error in the date definition : surgery date = '".$dx_data['initial_surgery_date']."' AND last follow-up date = '".$part_data['ovcare_last_followup_date']."'. See patient id ".$part_data['participant_identifier'];
				} else if(!(in_array($dx_data['initial_surgery_date_accuracy'], array('c')) && in_array($part_data['ovcare_last_followup_date_accuracy'], array('c')))) {
					$survival_time_months_precision = "approximate";
				} else if($dx_data['existing_empty_surgery_date']) {
					$survival_time_months_precision = "some surgery dates empty";
				} else {
					$survival_time_months_precision = "exact";
				}
				$query = "UPDATE diagnosis_masters SET survival_time_months = '$survival_time_months', survival_time_months_precision = '$survival_time_months_precision' WHERE id = $diagnosis_master_id;";
				mysqli_query($db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
				$query = str_replace('diagnosis_masters', 'diagnosis_masters_revs', $query);
				mysqli_query($db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
				$query = "UPDATE ovcare_dxd_ovaries_endometriums SET initial_surgery_date = '".$dx_data['initial_surgery_date']."', initial_surgery_date_accuracy = '".$dx_data['initial_surgery_date_accuracy']."' WHERE diagnosis_master_id = $diagnosis_master_id;";
				mysqli_query($db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
				$query = str_replace('ovcare_dxd_ovaries_endometriums', 'ovcare_dxd_ovaries_endometriums_revs', $query);
				mysqli_query($db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
			}
		}		
	}
	
	return $voas_to_collection_data;
}

function loadATiMStudies() {
	global $db_connection;
	$atim_studies = array();
	$query = "SELECT id, title FROM study_summaries";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$atim_studies[strtolower($row['title'])] = $row['id'];
	}
	return $atim_studies;
}

function updateOvcareLastFollowUpDate(&$participant_data, $new_date_res) {
	if(!empty($new_date_res['date'])) {
		if(!$participant_data['ovcare_last_followup_date']) {
			$participant_data['ovcare_last_followup_date'] = $new_date_res['date'];
			$participant_data['ovcare_last_followup_date_accuracy'] = $new_date_res['accuracy'];
		} else {
			$new = str_replace('-', '', $new_date_res['date']);
			$previous = str_replace('-', '', $participant_data['ovcare_last_followup_date']);
			if($new > $previous) {
				$participant_data['ovcare_last_followup_date'] = $new_date_res['date'];
				$participant_data['ovcare_last_followup_date_accuracy'] = $new_date_res['accuracy'];
			}
		}
	}
}

function getChemoDrugId($drug_name) {
	global $drug_ids;
	
	if(!strlen($drug_name)) die('ERR23327732832832832');
	if(array_key_exists($drug_name, $drug_ids)) {
		return $drug_ids[$drug_name];
	} else {
		$drug_id = customInsertRecord(array('type' => 'chemotherapy', 'generic_name' => $drug_name), 'drugs', false);
		$drug_ids[$drug_name] = $drug_id;
		return $drug_id;
	}
}

function getCustomListValue($value, $control_name) {
	global $db_connection;
	global $histology_values;
	
	if(!in_array($control_name, array('Ovarian Histology','Uterine Histology','Path Review Type'))) die('ERR 23872837 827 2837 '.$control_name);
	if(!strlen($control_name)) return '';
	
	if(!isset($histology_values[$control_name])) {
		$query = "SELECT id, values_max_length FROM structure_permissible_values_custom_controls WHERE name = '$control_name'";
		$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
		if($results->num_rows != 1) die('ERR 23 763287873268632 ');
		$row = $results->fetch_assoc();
		$histology_values[$control_name]= array('control_id' => $row['id'], 'values_max_length' => $row['values_max_length'], 'values' => array());
	}
	$formated_value = strtolower($value);
	if(strlen($formated_value) > $histology_values[$control_name]['values_max_length']) die('ERR327832732873287');
	if(!in_array($formated_value, $histology_values[$control_name]['values'])) {
		customInsertRecord(array('control_id' =>  $histology_values[$control_name]['control_id'], 'value' => $formated_value, 'en' => $value, 'use_as_input' => '1'), 'structure_permissible_values_customs', false);
		$histology_values[$control_name]['values'][] = $formated_value;
	}
	return $formated_value;
}

?>