<?php

function loadVitalStatus(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	//Load Worksheet names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//Load Worksheet data
	$line_counter = 0;
	$headers = array();
	$vital_status_data = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('décès')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else if($line_counter > 2) {
			$new_line_data = formatNewLineData($headers, $new_line);
			if($new_line_data['DÉCÈS - Procure']) {
				$participant_identifier = $new_line_data['DÉCÈS - Procure'];
				if(array_key_exists($participant_identifier, $vital_status_data)) die('ERR3728726862');
				$last_followup_date = getDateAndAccuracy($new_line_data, 'Date de la dernière visite HDQ venu  selon ADT', 'Profile', $file_name, $line_counter);
				$date_of_death = getDateAndAccuracy($new_line_data, 'date décès', 'Profile', $file_name, $line_counter);
				$vital_status_data[$participant_identifier] = array(
					'procure_chuq_last_contact_date' => $last_followup_date['date'],
					'procure_chuq_last_contact_date_accuracy' => $last_followup_date['accuracy'],
					'date_of_death' => $date_of_death['date'],
					'date_of_death_accuracy' => $date_of_death['accuracy'],
					'procure_chuq_cause_of_death_details' => $new_line_data['reason']);
				if($vital_status_data[$participant_identifier]['date_of_death']) {
					$vital_status_data[$participant_identifier]['vital_status'] = 'deceased';
				} else if(strlen($vital_status_data[$participant_identifier]['procure_chuq_cause_of_death_details'])) {
					$import_summary['Profile']['@@ERROR@@']['No date of death'][] = "A cause of death [".$vital_status_data[$participant_identifier]['procure_chuq_cause_of_death_details']."] has been defined but no date of death has been set. Cause won't be migrated and vital status won't be set to 'deceased'! [field 'reason' - file '$file_name' - line: $line_counter]";
				}
			}
		}
	}	
	return $vital_status_data;
}

function loadPatients(&$XlsReader, $files_path, $file_name, $patients_status) {
	global $import_summary;
	global $import_date;
	global $controls;
	// MiscIdentifierControl
	$misc_identifier_controls = $controls['MiscIdentifierControl'];
	//Load Worksheet names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadPatientData
	$line_counter = 0;
	$headers = array();
	$psp_nbr_to_participant_id_and_patho = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('Patients')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['Patients'];
			if(preg_match('/^PS2P[0-9]{4}$/', $participant_identifier)) {
				//Load profile
				$date_of_birth_tmp = getDateAndAccuracy($new_line_data, 'Date de naissance', 'Profile', $file_name, $line_counter);
				$data = array(
					'participant_identifier' => $participant_identifier,
					'first_name' => $new_line_data['Prénom'],
					'last_name' => $new_line_data['Nom'],
					'date_of_birth' => $date_of_birth_tmp['date'],
					'date_of_birth_accuracy' => $date_of_birth_tmp['accuracy'],
					'last_modification' => $import_date
				 );	
				if(array_key_exists($participant_identifier, $patients_status)) {
					$data = array_merge($data, $patients_status[$participant_identifier]);
					unset($patients_status[$participant_identifier]);
				}				
				//Load identifiers
				$atim_participant_id  = customInsert($data, 'participants', __FILE__, __LINE__, false);
				if(strlen($new_line_data['RAMQ'])) {
					$misc_identifier_name = 'RAMQ';
					$data = array('misc_identifier_control_id' => $misc_identifier_controls[$misc_identifier_name]['id'],
						'participant_id' => $atim_participant_id,
						'flag_unique' => $misc_identifier_controls[$misc_identifier_name]['flag_unique'],
						'identifier_value' => $new_line_data['RAMQ']);	
					customInsert($data, 'misc_identifiers', __FILE__, __LINE__, false);
				}
				if(strlen($new_line_data['#dossier'])) {
					$misc_identifier_name = 'hospital number';
					$data = array('misc_identifier_control_id' => $misc_identifier_controls[$misc_identifier_name]['id'],
							'participant_id' => $atim_participant_id,
							'flag_unique' => $misc_identifier_controls[$misc_identifier_name]['flag_unique'],
							'identifier_value' => $new_line_data['#dossier']);
					customInsert($data, 'misc_identifiers', __FILE__, __LINE__, false);
				}
				if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) die('ERR328728762387632');
				$psp_nbr_to_participant_id_and_patho[$participant_identifier] = array('participant_id' => $atim_participant_id, 'patho#' => $new_line_data['#Patho']);
			} else {
				$import_summary['Profile']['@@ERROR@@']['Patient Identification Format Error'][] = "Format of Identification '$participant_identifier' is not supported! [field 'Patients' - file '$file_name' - line: $line_counter]";
			}
		}
	}
	if(!empty($patients_status)) die('ERR2372687326873268732');
	return $psp_nbr_to_participant_id_and_patho;
}

function loadConsents(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho) {
	global $import_summary;
	global $controls;
	// Control
	$consent_control = $controls['ConsentControl']['procure consent form signature'];
	$questionnaire_control = $controls['EventControl']['procure questionnaire administration worksheet'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadConsentAndQuestionnaireData
	$line_counter = 0;
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('date consentement et date quest')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {		
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['Patients'];
			if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
				$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
				//Consent
				$consent_signed_date = getDateAndAccuracy($new_line_data, 'Date de signature', 'Consent & Questionnaire', $file_name, $line_counter);
				$revised_date = getDateAndAccuracy($new_line_data, 'Date de révision (version) du consentement', 'Consent & Questionnaire', $file_name, $line_counter);
				$data = array(
					'ConsentMaster' => array(
						'participant_id' => $participant_id,
						'procure_form_identification' => "$participant_identifier V01 -CSF1",
						'consent_control_id' => $consent_control['id'],
						'consent_signed_date' => $consent_signed_date['date'],
						'consent_signed_date_accuracy' => $consent_signed_date['accuracy'],
						'form_version' => null),
					'ConsentDetail' => array(
						'revised_date' => $revised_date['date'],
						'revised_date_accuracy' => $revised_date['accuracy']));
				if(empty($consent_signed_date['date'])) $import_summary['Consent & Questionnaire']['@@WARNING@@']['No Consent Signature Date'][] = "System is creating a consent with no signature date. See patient '$participant_identifier'! [field 'Date de signature' - file '$file_name' - line: $line_counter]";	
				switch($new_line_data['Version du consentement']) {
					case 'française':
					case 'française ':
						$data['ConsentMaster']['form_version'] = 'french';
						break;
					default:
						die('ERR 237 6287 632 '.$new_line_data['Version du consentement']);
				}
				$data['ConsentDetail']['consent_master_id'] = customInsert($data['ConsentMaster'], 'consent_masters', __FILE__, __LINE__, false);
				customInsert($data['ConsentDetail'], $consent_control['detail_tablename'], __FILE__, __LINE__, true);
				//Questionnaire
				$delivery_date  = getDateAndAccuracy($new_line_data, 'Date de remise du questionnaire au participant', 'Consent & Questionnaire', $file_name, $line_counter);
				$recovery_date  = getDateAndAccuracy($new_line_data, 'Date de réception du questionnaire', 'Consent & Questionnaire', $file_name, $line_counter);
				$verification_date  = getDateAndAccuracy($new_line_data, 'Date de vérification du questionnaire', 'Consent & Questionnaire', $file_name, $line_counter);
				$revision_date  = getDateAndAccuracy($new_line_data, 'Date de révision du questionnaire', 'Consent & Questionnaire', $file_name, $line_counter);
				$version_date = str_replace('x', '', $new_line_data['Version du questionnaire']);
				if(!in_array($version_date, array('2006','2009','2012', ''))) {
					$import_summary['Consent & Questionnaire']['@@ERROR@@']['Questionnaire version unknown'][] = "See value '$version_date' for patient '$participant_identifier'! Value won't be migrated! [field 'Date de remise du questionnaire au participant' - file '$file_name' - line: $line_counter]";	
					$version_date = '';
				}
				$procure_chuq_complete_at_recovery = str_replace(array('1','x'), array('y',''), $new_line_data['Questionnaire reçu complet']);
				if(!in_array($procure_chuq_complete_at_recovery, array('y','n',''))) die('ERR237326873243');
				$complete = str_replace(array('1','x'), array('y',''), $new_line_data['Questionnaire complet ou incomplet']);
				if(!in_array($complete, array('y','n',''))) die('ERR237326873243');
				$spent_time_delivery_to_recovery = $new_line_data['Temps écoulé entre remise et récupération du questionnaire'];
				$data = array(
					'EventMaster' => array(
						'participant_id' => $participant_id,
						'procure_form_identification' => "$participant_identifier V01 -QUE1",
						'event_control_id' => $questionnaire_control['event_control_id']),
					'EventDetail' => array(
						'delivery_date' => $delivery_date['date'],
						'delivery_date_accuracy' => $delivery_date['accuracy'],
						'recovery_date' => $recovery_date['date'],
						'recovery_date_accuracy' => $recovery_date['accuracy'],
						'spent_time_delivery_to_recovery' => $spent_time_delivery_to_recovery,
						'verification_date' => $verification_date['date'],
						'verification_date_accuracy' => $verification_date['accuracy'],
						'revision_date' => $revision_date['date'],
						'revision_date_accuracy' => $revision_date['accuracy'],
						'version_date' => $version_date,
						'procure_chuq_complete_at_recovery' => $procure_chuq_complete_at_recovery,
						'complete' => $complete));
				if(empty($delivery_date['date'])) $import_summary['Consent & Questionnaire']['@@WARNING@@']['No Questionnaire Delivery Date'][] = "System is creating a questionnaire with no delivery date. See patient '$participant_identifier'! [field 'Date de remise du questionnaire au participant' - file '$file_name' - line: $line_counter]";
				$data['EventDetail']['event_master_id'] = customInsert($data['EventMaster'], 'event_masters', __FILE__, __LINE__, false);
				customInsert($data['EventDetail'], $questionnaire_control['detail_tablename'], __FILE__, __LINE__, true);
			} else {
				$import_summary['Consent & Questionnaire']['@@ERROR@@']['Patient Identification Unknown'][] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient consent and quuestionnaire data won't be migrated! [field 'Patients' - file '$file_name' - line: $line_counter]";	
			}
		}
	}
}

function loadPSAs(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho) {
	global $import_summary;
	global $controls;
	// Control
	$psa_control = $controls['EventControl']['procure follow-up worksheet - aps'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadConsentAndQuestionnaireData
	$line_counter = 0;
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('par ordre chronologique')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {		
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['NoProcure'];
			if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
				$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
				//Questionnaire
				$event_date  = getDateAndAccuracy($new_line_data, 'DPSA', 'PSA', $file_name, $line_counter);
				switch($new_line_data['DPSA(P)']) {
					case 'j':
						$event_date['accuracy'] = 'd';
						break;
					case 'jm':
						$event_date['accuracy'] = 'm';
						break;
					case 'jma':
						$event_date['accuracy'] = 'y';
						break;
					default:					
				}
				$total_ngml = str_replace(array(' ', ','), array('', '.'), $new_line_data['PSA']);
				if(strlen($total_ngml)) {
					$procure_chuq_minimum = str_replace(array(' ', ','), array('', '.'), $new_line_data['Minimum']);
					if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $total_ngml)) die('ERR23873287328732 '.$total_ngml);
					if(strlen($procure_chuq_minimum) && !preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $procure_chuq_minimum)) die('ERR23873287328733 '.$procure_chuq_minimum);
					$procure_biochemical_relapse = (strlen(str_replace(' ', '', $new_line_data['date de récidive biochimique selon déf. procure'])))? 'y' : '';
					$data = array(
						'EventMaster' => array(
							'participant_id' => $participant_id,
							'procure_form_identification' => "$participant_identifier  Vx -FSPx",
							'event_control_id' => $psa_control['event_control_id'],
							'event_date' => $event_date['date'],
							'event_date_accuracy' => $event_date['accuracy'],),
						'EventDetail' => array(
							'total_ngml' => $total_ngml,
							'procure_chuq_minimum' => $procure_chuq_minimum,
							'procure_biochemical_relapse' => $procure_biochemical_relapse));
					$data['EventDetail']['event_master_id'] = customInsert($data['EventMaster'], 'event_masters', __FILE__, __LINE__, false);
					customInsert($data['EventDetail'], $psa_control['detail_tablename'], __FILE__, __LINE__, true);
				}
			} else {
				$import_summary['PSA']['@@ERROR@@']['Patient Identification Unknown'][$participant_identifier] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient PSA data won't be migrated! [field 'NoProcure' - file '$file_name' - line: $line_counter]";	
			}
		}
	}
}

function loadTreatments(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho) {
	global $import_summary;
	global $controls;
	// Control
	$tx_control = $controls['TreatmentControl'];	
	//Existing Drugs
	$drugs = array();
	$query = "SELECT id, generic_name, type FROM drugs WHERE deleted <> 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$drugs[$row['type']][strtolower($row['generic_name'])] = $row['id'];
	}	
	//Period
	$periods = array();
	$query = "SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Treatment Period';";
	$results = customQuery($query, __FILE__, __LINE__);
	$row = $results->fetch_assoc();
	$period_control_id = $row['id'];
	$query = "SELECT value FROM structure_permissible_values_customs WHERE control_id = $period_control_id AND deleted <> 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$periods[$row['value']] = $row['value'];
	}
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadConsentAndQuestionnaireData
	$line_counter = 0;
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('Procure_Patient_Traitement 2013')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['. patients'];
			if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
				$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
				if(strlen($new_line_data['Type'])) {
					$start_date = getDateAndAccuracy($new_line_data, 'DDebut', 'Treatment', $file_name, $line_counter);
					$finish_date = getDateAndAccuracy($new_line_data, 'DFin', 'Treatment', $file_name, $line_counter);
					$detail_data = array();
					$treatment_controls = array();
					switch($new_line_data['Type']) {
						//Chemotherpay
						case 'Tx-Chimio':				
							$treatment_controls = $tx_control['procure follow-up worksheet - treatment'];
							$period = getPeriod($new_line_data['Periode'], $periods, $period_control_id);
						 	$drug_ids = array();
							foreach(explode('-',$new_line_data['Med']) as $generic_name) $drug_ids[] = getDrugId($generic_name, 'chemotherapy', $drugs);
						 	if(empty($drug_ids)) $drug_ids[] = null;
						 	foreach($drug_ids as $drug_id) {
						 		$detail_data[] = array(
						 			'treatment_type' => 'chemotherapy',
						 			'drug_id' => $drug_id,
						 			'procure_chuq_period' => $period);
						 	}
						 	break;
						case 'Hx-AA':
						case 'Hx-LA':
						case 'Hx-X':
							preg_match('/^Hx\-(.+)$/',  $new_line_data['Type'], $matches);
							$treatment_controls = $tx_control['procure follow-up worksheet - treatment']; 
							$period = getPeriod($new_line_data['Periode'], $periods, $period_control_id);
							$drug_ids = array();
							if(preg_match('/^((LHRH)|(MDV))\-/', $new_line_data['Med'])) {
								$drug_ids[] = getDrugId($new_line_data['Med'], 'hormonotherapy', $drugs);
							} else {
								foreach(explode('-',$new_line_data['Med']) as $generic_name) $drug_ids[] = getDrugId($generic_name, 'hormonotherapy', $drugs);
							}
							if(empty($drug_ids)) $drug_ids[] = null;
							foreach($drug_ids as $drug_id) {
								$detail_data[] = array(
									'treatment_type' => 'hormonotherapy',
									'type' => $matches[1],
									'drug_id' => $drug_id,
									'procure_chuq_period' => $period);
							}
							break;
						case 'Rx-Ext':
							$treatment_controls = $tx_control['procure follow-up worksheet - treatment'];
							$period = getPeriod($new_line_data['Periode'], $periods, $period_control_id);
							$detail_data = array(array(
								'treatment_type' => 'radiotherapy',
								'type' => 'Ext',
								'procure_chuq_period' => $period));
							break;
						case 'HBP-AI':
						case 'HBP-AB':
							$drug_id = getDrugId($new_line_data['Med'], 'prostate', $drugs);
							if($drug_id) {
								$treatment_controls = $tx_control['procure medication worksheet - drug'];
								$period = getPeriod($new_line_data['Periode'], $periods, $period_control_id);
								$detail_data = array(array(
									'drug_id' => $drug_id, 
									'procure_chuq_period' => $period));
							} else {
								$import_summary['Treatment']['@@WARNING@@']["Missing Drug"][] = "A Prostate treatment has been defined on ".$start_date['date']." but no drug has been recorded. This one has to be created manually into ATiM after migration. See patient '$participant_identifier'. [file '$file_name' - line: $line_counter]";
							}				
//TODO						todo calculer la duree
							break;
						case 'Autres':
							$import_summary['Treatment']['@@WARNING@@']["Treatment 'Autre' To Create Manually"][] = "See patient '$participant_identifier' : Treatment [".$new_line_data['Med']." - ".$new_line_data['Type']."' with Periode '".$new_line_data['Periode']."'] on ".$start_date['date']." won't be migrated. This one has to be created manually into ATiM after migration. [file '$file_name' - line: $line_counter]";
							break;
						default:
							die('ERR23873287238723');
					}
					if($treatment_controls)  {
						if(empty($start_date['date'])) $import_summary['Treatment']['@@WARNING@@']['No Treatment Start Date'][] = "System is creating a treatment with no tratment date. See patient '$participant_identifier'! [field 'DDebut' - file '$file_name' - line: $line_counter]";
						foreach($detail_data as $new_detail) {
							$data = array(
								'TreatmentMaster' => array(
									'participant_id' => $participant_id,
									'procure_form_identification' => "$participant_identifier  Vx -FSPx",
									'treatment_control_id' => $treatment_controls['treatment_control_id'],
									'start_date' => $start_date['date'],
									'start_date_accuracy' => $start_date['accuracy'],
									'finish_date' => $finish_date['date'],
									'finish_date_accuracy' => $finish_date['accuracy']),
								'TreatmentDetail' => $new_detail);
							$data['TreatmentDetail']['treatment_master_id'] = customInsert($data['TreatmentMaster'], 'treatment_masters', __FILE__, __LINE__, false);
							customInsert($data['TreatmentDetail'], $treatment_controls['detail_tablename'], __FILE__, __LINE__, true);
						}
					}
				}				
			} else {
				$import_summary['Treatment']['@@ERROR@@']['Patient Identification Unknown'][$participant_identifier] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient PSA data won't be migrated! [field '. patients' - file '$file_name' - line: $line_counter]";
			}
		}
	}
}

function getDrugId($generic_name, $type, &$drugs) {
	$generic_name = trim($generic_name);
	$generic_name_key = strtolower($generic_name);
	if(!strlen($generic_name_key)) return null;
	if(!isset($drugs[$type]) || !isset($drugs[$type][$generic_name_key])) {
		$drugs[$type][$generic_name_key] = customInsert(array('generic_name' => $generic_name, 'type' => $type), 'drugs', __FILE__, __LINE__, false, true);
	}
	return $drugs[$type][$generic_name_key];	
}

function getPeriod($period, &$periods, $period_control_id) {
	$period = trim($period);
	$period_key = strtolower($period);
	if(!strlen($period_key)) return null;
	if(!isset($periods[$period_key])) {
		customInsert(array('value' => $period_key, 'en' => $period, 'fr' => $period, 'use_as_input' => '1', 'control_id' => $period_control_id), 'structure_permissible_values_customs', __FILE__, __LINE__, false, true);
		$periods[$period_key] = $period_key;
	}
	return $period_key;
}

?>