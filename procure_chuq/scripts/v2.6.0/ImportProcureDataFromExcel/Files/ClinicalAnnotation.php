<?php

function loadVitalStatus(&$XlsReader, $files_path, $file_name) {
	global $import_summary;
	global $patients_to_import;
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
		} else  {
			$new_line_data = formatNewLineData($headers, $new_line);
			if($new_line_data['DÉCÈS - Procure']) {
				$participant_identifier = $new_line_data['DÉCÈS - Procure'];
				if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
				if(array_key_exists($participant_identifier, $vital_status_data)) {
					$import_summary['Profile']['@@ERROR@@']['Patient defined twice'][] = "Data of the second row won't be recorded. See patient $participant_identifier! [field <b>reason</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
					continue;
				}
//Not in excel anymore				$last_followup_date = getDateAndAccuracy($new_line_data, 'Date de la dernière visite HDQ venu  selon ADT', 'Profile', $file_name, $line_counter);
				$date_of_death = getDateAndAccuracy($new_line_data, 'date décès', 'Profile', $file_name, $line_counter);
				$details = array($new_line_data['cause décès'], $new_line_data['Formulaire SP-3'], $new_line_data['notes']);
				$details = implode ('. ', array_filter($details));
				$details = strlen($details)? $details.'.' : ''; 
				$procure_cause_of_death = '';
				switch($new_line_data["cause décès en binaire (DOD: cancer prostate) DOOD: death of other disease)"]) {
					case 'DOOD':
						$procure_cause_of_death = 'independent of prostate cancer';
						break;
					case 'DOD':
						$procure_cause_of_death = 'secondary to prostate cancer';
						break;
					case 'inconue':
					case '':
						break;
					default:
						$import_summary['Profile']['@@ERROR@@']['DOOD or DOD'][] = "T cause of death [".$new_line_data["cause décès en binaire (DOD: cancer prostate) DOOD: death of other disease)"]."] is not supported.  Cause won't be migrated! [field <b>cause décès en binaire (DOD: cancer prostate) DOOD: death of other disease)</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
				}
				$vital_status_data[$participant_identifier] = array(
					'procure_chuq_last_contact_date' => '', 			//$last_followup_date['date'],
					'procure_chuq_last_contact_date_accuracy' => '', 	//$last_followup_date['accuracy'],
					'date_of_death' => $date_of_death['date'],
					'date_of_death_accuracy' => $date_of_death['accuracy'],
					'procure_cause_of_death' => $procure_cause_of_death,
					'procure_chuq_cause_of_death_details' =>$details);
				if($vital_status_data[$participant_identifier]['date_of_death']) {
					$vital_status_data[$participant_identifier]['vital_status'] = 'deceased';
				} else if(strlen($vital_status_data[$participant_identifier]['procure_chuq_cause_of_death_details']) || strlen($procure_cause_of_death)) {
					$import_summary['Profile']['@@ERROR@@']['No date of death'][] = "A cause of death [".$vital_status_data[$participant_identifier]['procure_chuq_cause_of_death_details']."] or a 'cause décès en binaire' has been defined but no date of death has been set. Cause won't be migrated and vital status won't be set to 'deceased'! [field <b>reason</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
					unset($vital_status_data[$participant_identifier]);
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
	global $patients_to_import;
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
			if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
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
				$atim_participant_id  = customInsert($data, 'participants', __FILE__, __LINE__);
				//Load identifiers
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
				$psp_nbr_to_participant_id_and_patho[$participant_identifier] = array(
					'participant_id' => $atim_participant_id, 
					'patho#' => $new_line_data['#Patho']
				);
			} else {
				$import_summary['Profile']['@@ERROR@@']['Patient Identification Format Error'][] = "Format of Identification '$participant_identifier' is not supported! [field <b>Patients</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
			}
		}
	}
	if(!empty($patients_status)) die('ERR2372687326873268732 - All patient status not parsed....');
	return $psp_nbr_to_participant_id_and_patho;
}

function loadConsents(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho) {
	global $import_summary;
	global $controls;
	global $patients_to_import;
	// Control
	$consent_control = $controls['ConsentControl']['procure consent form signature'];
	$questionnaire_control = $controls['EventControl']['procure questionnaire administration worksheet'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadConsentData
	$line_counter = 0;
	$headers = array();
	$participant_identifier_to_consent_detail_data = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('consentement')]]['cells'] as $line_counter => $new_line) {
		if($line_counter == 4) {
			$headers = $new_line;
		} else if($line_counter > 4){
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['# procure'];
			if(preg_match('/^PS2P[0-9]{4}$/', $participant_identifier)) {
				if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
				if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
					if(!isset($participant_identifier_to_consent_detail_data[$participant_identifier])) {
						$excel_field_matches = array(
							'procure_chuq_tissue' => "tissu + dossier",
							'procure_chuq_blood' => "sang V01",
							'procure_chuq_urine' => "urine V01",
							'procure_chuq_followup' => "visite suivie",
							'procure_chuq_questionnaire' => "questionnaire",
							'procure_chuq_contact_for_additional_data' => "recontacté tél.",
							'procure_chuq_inform_significant_discovery' => "si résultat",
							'procure_chuq_contact_in_case_of_death' => "cas décès",
							'procure_chuq_witness' => "témoin",
							'procure_chuq_complete' => "colonne C à G");
						foreach($excel_field_matches as $db_field => $excel_field) {
							$db_val = '';
							switch($new_line_data[$excel_field]) {
								case '1':
									$db_val = 'y';
									break;
								case '0':
								case 'NON':
									$db_val = 'n';
									break;
								case '':
									$db_val = '';
									break;
								default:
									$import_summary['Consent & Questionnaire (consentement worksheet)']['@@WARNING@@']["Consent value of field $excel_field unsupported"][] = "See value '".$new_line_data[$excel_field]."'. Data won't be migrated. See patient '$participant_identifier'! [file <b>$file_name</b>- line: <b>$line_counter</b>]";
							}
							$participant_identifier_to_consent_detail_data[$participant_identifier][$db_field] = $db_val;
						}
					} else {
						$import_summary['Consent & Questionnaire (consentement worksheet)']['@@ERROR@@']['Patient Identification Duplicated'][] = "The Identification '$participant_identifier' is listed twice into this worksheet! Only first row will be migrated! [file <b>$file_name</b>- line: <b>$line_counter</b>]";
					}
				} else {
					$import_summary['Consent & Questionnaire (consentement worksheet)']['@@ERROR@@']['Patient Identification Unknown'][] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient consent and quuestionnaire data won't be migrated! file <b>$file_name</b>- line: <b>$line_counter</b>]";
				}
			} else {
				$import_summary['Consent & Questionnaire (consentement worksheet)']['@@MESSAGE@@']['Unparsed line'][] = "The line '$line_counter' does not begins with a participant identifier! No data will be imported! [file <b>$file_name</b>- line: <b>$line_counter</b>]";
			}
		}
	}
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
			if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
			if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
				$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
				//Consent
				$consent_signed_date = getDateAndAccuracy($new_line_data, 'Date de signature', 'Consent & Questionnaire', $file_name, $line_counter);
				$form_version = getDateAndAccuracy($new_line_data, 'Date de révision (version) du consentement', 'Consent & Questionnaire', $file_name, $line_counter);
				if($form_version['date'] && !in_array($form_version['date'], array('2006-02-20','2009-11-12','2011-03-14'))) {
					$import_summary['Consent & Questionnaire']['@@ERROR@@']['Consent version unknown'][] = "See value '".$form_version['date']."' for patient '$participant_identifier'! Value won't be migrated! [field <b>Date de remise du questionnaire au participant</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
					$form_version['date'] = '';
				}		
				$data = array(
					'ConsentMaster' => array(
						'participant_id' => $participant_id,
						'procure_form_identification' => "$participant_identifier V01 -CSF1",
						'consent_control_id' => $consent_control['id'],
						'consent_signed_date' => $consent_signed_date['date'],
						'consent_signed_date_accuracy' => $consent_signed_date['accuracy'],
						'form_version' => $form_version['date']),
					'ConsentDetail' => array());
				if(isset($participant_identifier_to_consent_detail_data[$participant_identifier])) {
					$data['ConsentDetail'] = $participant_identifier_to_consent_detail_data[$participant_identifier];
					unset($participant_identifier_to_consent_detail_data[$participant_identifier]);
				}
				if(empty($consent_signed_date['date'])) $import_summary['Consent & Questionnaire']['@@WARNING@@']['No Consent Signature Date'][] = "System is creating a consent with no signature date. See patient '$participant_identifier'! [field <b>Date de signature</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";	
				$data['ConsentMaster']['procure_language'] = 'french';
				$data['ConsentDetail']['consent_master_id'] = customInsert($data['ConsentMaster'], 'consent_masters', __FILE__, __LINE__, false);
				customInsert($data['ConsentDetail'], $consent_control['detail_tablename'], __FILE__, __LINE__, true);
				//Questionnaire
				$delivery_date  = getDateAndAccuracy($new_line_data, 'Date de remise du questionnaire au participant', 'Consent & Questionnaire', $file_name, $line_counter);
				$recovery_date  = getDateAndAccuracy($new_line_data, 'Date de réception du questionnaire', 'Consent & Questionnaire', $file_name, $line_counter);
				$verification_date  = getDateAndAccuracy($new_line_data, 'Date de vérification du questionnaire', 'Consent & Questionnaire', $file_name, $line_counter);
				$revision_date  = getDateAndAccuracy($new_line_data, 'Date de révision du questionnaire', 'Consent & Questionnaire', $file_name, $line_counter);
				$version_date = str_replace('x', '', $new_line_data['Version du questionnaire']);
				if(!in_array($version_date, array('2006','2009','2012', ''))) {
					$import_summary['Consent & Questionnaire']['@@ERROR@@']['Questionnaire version unknown'][] = "See value '$version_date' for patient '$participant_identifier'! Value won't be migrated! [field <b>Date de remise du questionnaire au participant</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";	
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
						'delivery_site_method' => 'pre-op clinic',
						'recovery_date' => $recovery_date['date'],
						'recovery_date_accuracy' => $recovery_date['accuracy'],
						'spent_time_delivery_to_recovery' => $spent_time_delivery_to_recovery,
						'verification_date' => $verification_date['date'],
						'verification_date_accuracy' => $verification_date['accuracy'],
						'revision_date' => $revision_date['date'],
						'revision_date_accuracy' => $revision_date['accuracy'],
						'version' => (($participant_identifier == 'PS2P0017')? 'english' : 'french'),
						'version_date' => $version_date,
						'procure_chuq_complete_at_recovery' => $procure_chuq_complete_at_recovery,
						'complete' => $complete));
				if(empty($delivery_date['date'])) $import_summary['Consent & Questionnaire']['@@WARNING@@']['No Questionnaire Delivery Date'][] = "System is creating a questionnaire with no delivery date. See patient '$participant_identifier'! [field <b>Date de remise du questionnaire au participant</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
				$data['EventDetail']['event_master_id'] = customInsert($data['EventMaster'], 'event_masters', __FILE__, __LINE__, false);
				customInsert($data['EventDetail'], $questionnaire_control['detail_tablename'], __FILE__, __LINE__, true);
			} else {
				$import_summary['Consent & Questionnaire']['@@ERROR@@']['Patient Identification Unknown'][] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient consent and quuestionnaire data won't be migrated! [field <b>Patients</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";	
			}
		}
	}
	foreach($participant_identifier_to_consent_detail_data as $participant_identifier => $tmp_data) {
		$import_summary['Consent & Questionnaire']['@@ERROR@@']["Patient in 'consentement' worksheet not defined into the other one "][] = "Data won't be migrated. See patient '$participant_identifier'! [file <b>$file_name]";
	}
}

function loadBiopsy(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho) {
	global $import_summary;
	global $controls;
	global $patients_to_import;
	// Control
	$event_control = $controls['EventControl']['procure diagnostic information worksheet'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadPSAs
	$line_counter = 0;
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('Rapports biopsie')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 4) {
			$headers = $new_line;
		} else if($line_counter > 5){
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['# Patient'];
			if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
			if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
				$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
				//Event Details Data
				$event_details = array();
				$biopsy_date  = getDateAndAccuracy($new_line_data, 'Date du prélèvement de biopsie', 'Biopsy', $file_name, $line_counter);
				$event_details['biopsy_pre_surgery_date'] = $biopsy_date['date'];
				$event_details['biopsy_pre_surgery_date_accuracy'] = $biopsy_date['accuracy'];
				$event_details['aps_pre_surgery_total_ng_ml'] = getDecimal($new_line_data, 'PSA', 'Biopsy', $file_name, $line_counter);
				if(strlen($new_line_data['Date de la PSA'])) {
					$psa_date  = getDateAndAccuracy($new_line_data, 'Date de la PSA', 'Biopsy', $file_name, $line_counter);
					$event_details['aps_pre_surgery_date'] = $psa_date['date'];
					$event_details['aps_pre_surgery_date_accuracy'] = $psa_date['accuracy'];
				}
				$tmp_array = array("Nombre de zones biopsiées" => "collected_cores_nbr", 
					"Nombre de zones avec tumeur" => "nbr_of_cores_with_cancer",
					"Gleason le plus élevé inscrit" => "highest_gleason_score_observed");
				foreach($tmp_array as $excel_field => $db_field) {
					if(strlen($new_line_data[$excel_field]) && !in_array($new_line_data[$excel_field], array('?', 'Nb N/D'))) {
						$new_line_data[$excel_field] = str_replace('%','', $new_line_data[$excel_field]);
						if(preg_match('/^[0-9]+$/', $new_line_data[$excel_field])) {
							$event_details[$db_field] = $new_line_data[$excel_field];
						} else {
							$import_summary['Biopsy']['@@ERROR@@']["'".$excel_field."' format error"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
						}
					}
				}
				$event_details['highest_gleason_score_percentage'] = getDecimal($new_line_data, "% d'atteinte Gleason le plus élevé inscrit", 'Biopsy', $file_name, $line_counter);
				if(isset($event_details['nbr_of_cores_with_cancer']) && isset($event_details['collected_cores_nbr'])) {
					if(strlen($event_details['nbr_of_cores_with_cancer']) && $event_details['collected_cores_nbr']) {
						$event_details['affected_core_total_percentage'] = $event_details['nbr_of_cores_with_cancer']/$event_details['collected_cores_nbr'];
					}
				}
				$tmp_array = array(
						array('histologic_grade_primary_pattern', 'histologic_grade_primary_pattern', array('1','2','3','4','5')),
						array('histologic_grade_secondary_pattern', 'histologic_grade_secondary_pattern', array('1','2','3','4','5')),
						array('histologic_grade_gleason_total', 'Gleason la zone la plus abondante', array('6','7','8','9','10')));
				foreach($tmp_array as $tmp_data) {
					list($db_field, $excel_field, $allowed_values) = $tmp_data;
					$new_line_data[$excel_field] = str_replace(array('.','-', ' '),array('', '', ''),$new_line_data[$excel_field]);
					if(strlen($new_line_data[$excel_field]) && $new_line_data[$excel_field] != 'NO') {
						if(in_array($new_line_data[$excel_field], $allowed_values)) {
							$event_details[$db_field] = $new_line_data[$excel_field];
						} else {
							$import_summary['Biopsy']['@@ERROR@@']["'".$excel_field."' value format not supported"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
						}
					}
				}
				$tmp_details = array_filter($event_details);
				if($tmp_details) {
					$data = array(
						'EventMaster' => array(
							'participant_id' => $participant_id,
							'procure_form_identification' => "$participant_identifier V01 -FBP1",
							'event_control_id' => $event_control['event_control_id'],
							'event_summary' => $new_line_data['Note']),
						'EventDetail' => $event_details);
					$data['EventDetail']['event_master_id'] = customInsert($data['EventMaster'], 'event_masters', __FILE__, __LINE__, false);
					customInsert($data['EventDetail'], $event_control['detail_tablename'], __FILE__, __LINE__, true);
				}


			} else {
				$import_summary['Biopsy']['@@ERROR@@']['Patient Identification Unknown'][$participant_identifier] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient PSA data won't be migrated! [field <b>NoProcure</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
			}
		}
	}
}

function loadPathos(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho) {
	global $import_summary;
	global $controls;
	global $patients_to_import;
	// Control
	$event_control = $controls['EventControl']['procure pathology report'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadPathoData
	$prostatectomy_data = array();
	$line_counter = 0;
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('Feuil1')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 7) {
			$headers = $new_line;
		} else if($line_counter > 7) {
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['# échantillon'];
			if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
			if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
				$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
				$event_date  = getDateAndAccuracy($new_line_data, 'date du rapport', 'Pathology Report', $file_name, $line_counter);
				//Event Details Data
				$event_details = array();
				if($new_line_data['# patho']) {
					if($psp_nbr_to_participant_id_and_patho[$participant_identifier]['patho#']) {
						if($new_line_data['# patho'] != $psp_nbr_to_participant_id_and_patho[$participant_identifier]['patho#']) {
							$import_summary['Pathology Report']['@@ERROR@@']["Patho # does not match"][] = "The patho# defined into participant file ".$psp_nbr_to_participant_id_and_patho[$participant_identifier]['patho#']." does not match the patho# defined into the patho file ".$new_line_data['# patho'].". Will use value of the patho file. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
						}
					} else {
						$import_summary['Pathology Report']['@@MESSAGE@@']["Patho # not defined into participant excel file - use # from patho file"][] = "Will use value ".$new_line_data['# patho']." of the patho file. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
					}
					$psp_nbr_to_participant_id_and_patho[$participant_identifier]['patho#'] = $new_line_data['# patho'];
					$event_details['path_number'] = $new_line_data['# patho'];
				} else if($psp_nbr_to_participant_id_and_patho[$participant_identifier]['patho#']) {
					$event_details['path_number'] = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['patho#'];
					$import_summary['Pathology Report']['@@WARNING@@']["Patho # defined in another excel file"][] = "The patho# is not defined into the patho excel file but this one was defined defined into participant file ".$psp_nbr_to_participant_id_and_patho[$participant_identifier]['patho#'].". Will use this one. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
				}
				$event_details['pathologist_name'] = $new_line_data['pathologiste'];
				$tmp_array = array(
					'prostate_length_cm' => 'dimension prostate long.',
					'prostate_thickness_cm' => 'dimension prostate haut.',
					'prostate_width_cm' => 'dimension prostate larg.',
			
					'right_seminal_vesicle_length_cm' => 'vésicule séminale droite long.',
					'right_seminal_vesicle_thickness_cm' => 'vésicule séminale droite haut.',
					'right_seminal_vesicle_width_cm' => 'vésicule séminale droite larg.',
			
					'left_seminal_vesicle_length_cm' => 'vésicule séminale gauche long.',
					'left_seminal_vesicle_thickness_cm' => 'vésicule séminale gauche haut.',
					'left_seminal_vesicle_width_cm' => 'vésicule séminale gauche larg.');
				foreach($tmp_array as $db_field => $excel_field) {
					$val = getDecimal($new_line_data, $excel_field, 'Pathology Report', $file_name, $line_counter);
					if(strlen($val)) $event_details[$db_field] = $val;
				}
				if(strlen($new_line_data['ADÉNOCARCINOME conventionnel infiltrant']) && strtolower($new_line_data['ADÉNOCARCINOME conventionnel infiltrant']) != 'no') {
					if(strtolower($new_line_data['ADÉNOCARCINOME conventionnel infiltrant']) == 'y') {
						$event_details['histology'] = 'acinar adenocarcinoma/usual type';
					} else if(preg_match('/^Y[\ ]{0,1}\+[\ ]{0,1}(.+)$/', $new_line_data['ADÉNOCARCINOME conventionnel infiltrant'], $matches)) {
						$event_details['histology'] = 'acinar adenocarcinoma/usual type';
						$event_details['histology_other_precision'] = '+ '.$matches[1];
						$import_summary['Pathology Report']['@@WARNING@@']["'histology' value contains more than one value"][] = "The histology value [".$new_line_data['ADÉNOCARCINOME conventionnel infiltrant']."] will be recorded in the 2 fields : Histology = 'acinar adenocarcinoma/usual type' &  Other procision = '".$matches[1]."'. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
					} else {
						$event_details['histology'] = 'other specify';
						$event_details['histology_other_precision'] = $new_line_data['ADÉNOCARCINOME conventionnel infiltrant'];
						$import_summary['Pathology Report']['@@WARNING@@']["'histology' value format not supported"][] = "Value [".$new_line_data['ADÉNOCARCINOME conventionnel infiltrant']."] will be added to the 'Other precision' field. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
					}
				}
				$tmp_array = array('tumour_location_right_anterior' => 'zones atteintes ant. drt',
						'tumour_location_left_anterior' => 'zones atteintes ant. gche',
						'tumour_location_right_posterior' => 'zones atteintes post. drt',
						'tumour_location_left_posterior' => 'zones atteintes post. gche',
						'tumour_location_apex' => 'zones atteintes apex',
						'tumour_location_base' => 'zones atteintes base',
						'tumour_location_bladder_neck' => 'zones atteintes col');
				foreach($tmp_array as $db_field => $excel_field) {
					if(strlen($new_line_data[$excel_field])) {
						if(strlen($new_line_data[$excel_field]) && $new_line_data[$excel_field] != '.') {
							if('1' == $new_line_data[$excel_field]) {
								$event_details[$db_field] = $new_line_data[$excel_field];
							} else {
								$import_summary['Pathology Report']['@@ERROR@@']["'".$excel_field."' format error"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
							}
						}
					}
				}
				if(strlen($new_line_data['vol. prost. Atteint en %']) && $new_line_data['vol. prost. Atteint en %'] != '-') {
					$tumour_volume = '';
					$new_line_data['vol. prost. Atteint en %'] = str_replace(array(' ', '%'), array('', ''), $new_line_data['vol. prost. Atteint en %']);			
					if(preg_match('/^(1)|(0)|^0\.[0-9]+$/', $new_line_data['vol. prost. Atteint en %'], $matches)) {				
						if($new_line_data['vol. prost. Atteint en %'] < 0.3) {
							$tumour_volume = "low";
						} else if($new_line_data['vol. prost. Atteint en %'] <= 0.6) {
							$tumour_volume = "moderate";
						} else {
							$tumour_volume = "high";
						}
					} else {					
						switch($new_line_data['vol. prost. Atteint en %']) {
							case "<1":
							case "<1":
							case "<10":
							case "<5":
							case "10à15":
							case "10-15":
							case "15-20":
							case "20-25":
							case "2-3":
							case "25-30":
							case "3à5":
							case "5à10":
							case "5-10":
							case "6-10":
								$tumour_volume = "low";
								break;
							case "35-40":
							case "40-50":
								$tumour_volume = "moderate";
								break;
							default:
								$import_summary['Pathology Report']['@@ERROR@@']["'vol. prost. Atteint en %' format error"][] = "Value [".$new_line_data['vol. prost. Atteint en %']."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
						}				
					}	
					$event_details['tumour_volume'] = $tumour_volume;
				}
				$tmp_array = array(
					array('histologic_grade_primary_pattern', 'patron gleason 1er', array('2','3','4','5')),
					array('histologic_grade_secondary_pattern', 'patron gleason 2e', array('2','3','4','5')),
					array('histologic_grade_tertiary_pattern', 'patron gleason 3e', array('2','3','4','5','none')),
					array('histologic_grade_gleason_score', 'gleason', array('6','7','8','9','0')));
				foreach($tmp_array as $tmp_data) {
					list($db_field, $excel_field, $allowed_values) = $tmp_data;
					$new_line_data[$excel_field] = str_replace(array('.','-', ' '),array('', '', ''),$new_line_data[$excel_field]);
					if(strlen($new_line_data[$excel_field]) && $new_line_data[$excel_field] != 'NO') {
						if(in_array($new_line_data[$excel_field], $allowed_values)) {
							$event_details[$db_field] = $new_line_data[$excel_field];
						} else {
							$import_summary['Pathology Report']['@@ERROR@@']["'".$excel_field."' value format not supported"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
						}
					}
				}
				$margins = '';
				$new_line_data['marge atteinte  (Y / NO)'] = strtolower(str_replace(array('É', 'é'), array('e', 'e'), $new_line_data['marge atteinte  (Y / NO)']));
				switch($new_line_data['marge atteinte  (Y / NO)']) {
					case 'y':
						$margins = 'positive';
						break;
					case 'n':
					case 'no':
						$margins = 'negative';
						break;
					case 'indetermine':
					case 'non-evaluable':
						$margins = 'cannot be assessed';
						break;
					case '':
					case '-':
						break;
					default:
						$excel_field = 'marge atteinte  (Y / NO)';
						$import_summary['Pathology Report']['@@ERROR@@']["'".$excel_field."' value format not supported"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";	
				}
				$event_details['margins'] = $margins;
				$event_details['margins_focal_or_extensive'] = '';
				$new_line_data['marge atteinte précision'] = strtolower(str_replace(array('É', 'é'), array('e', 'e'), $new_line_data['marge atteinte précision']));
				if(!in_array($new_line_data['marge atteinte précision'], array('indetermine', 'n', 'no', 'non-evaluable', 'y', '', '-'))) {
					if(preg_match('/^y\ exte[nm]si[fv][e]{0,1}\ ([0-9][\ ]{0,1}\+\ [0-9])$/', $new_line_data['marge atteinte précision'], $matches)) {
						$event_details['margins_focal_or_extensive'] = 'extensive';
						$event_details['margins_gleason_score'] = $matches[1];
					} else if(preg_match('/^y\ multifocal[e]{0,1}\ ([0-9][\ ]{0,1}\+\ [0-9])$/', $new_line_data['marge atteinte précision'], $matches)) {
						$event_details['margins_focal_or_extensive'] = 'extensive';
						$event_details['margins_gleason_score'] = $matches[1];
					} else if(preg_match('/^y(es){0,1}\ (uni){0,1}focal[e;]{0,1}(\ [grade\ ]{0,6}([0-9]\ \+\ [0-9])){0,1}$/', $new_line_data['marge atteinte précision'], $matches)) {
						$event_details['margins_focal_or_extensive'] = 'focal';
						if(isset($matches[4])) $event_details['margins_gleason_score'] = $matches[4];
					} else 	{
						$excel_field = 'marge atteinte précision';
						$import_summary['Pathology Report']['@@ERROR@@']["'".$excel_field."' value format not supported"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
					}	
				}
				if($event_details['margins_focal_or_extensive'] && $margins != 'positive') {
					$import_summary['Pathology Report']['@@ERROR@@']["'margins' data conflict"][] = "Margin was not defined as positive but a focal/extensive value was set. Please check data and correct if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
				}
				$extra_prostatic_extension = '';
				$new_line_data['extracapsulaire  (Y / NO)'] = strtolower(str_replace(array('É', 'é'), array('e', 'e'), $new_line_data['extracapsulaire  (Y / NO)']));
				switch($new_line_data['extracapsulaire  (Y / NO)']) {
					case 'y':
						$extra_prostatic_extension = 'present';
						break;
					case 'n':
					case 'no':
						$extra_prostatic_extension = 'absent';
						break;
					case 'indetermine':
					case 'non-evaluable':
					case '':
					case '-':
						break;
					default:
						$excel_field = 'extracapsulaire  (Y / NO)';
						$import_summary['Pathology Report']['@@ERROR@@']["'".$excel_field."' value format not supported"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";	
				}
				$event_details['extra_prostatic_extension'] = $extra_prostatic_extension;
				$event_details['extra_prostatic_extension_precision'] = '';	
				$new_line_data['extracapsulaire précision'] = strtolower(str_replace(array('É', 'é'), array('e', 'e'), $new_line_data['extracapsulaire précision']));		
				if(!in_array($new_line_data['extracapsulaire précision'], array('indetermine', 'n', 'no', 'non-evaluable', 'y', '', '-'))) {
					if(preg_match('/^y\ exte[nm]si[fv][e]{0,1}\ ([0-9]\ \+\ [0-9])$/', strtolower($new_line_data['extracapsulaire précision']), $matches)) {
						$event_details['extra_prostatic_extension_precision'] = 'established';
						if(isset($matches[1])) {
							$import_summary['Pathology Report']['@@ERROR@@']["Gleason score of 'extra-prostatic' extension value won't be imported"]['-1'] = "Please confirm.";
						}
					} else if(preg_match('/^y\ etablie\ ([0-9]\ \+\ [0-9])$/', strtolower($new_line_data['extracapsulaire précision']), $matches)) {
						$event_details['extra_prostatic_extension_precision'] = 'established';
						if(isset($matches[1])) {
							$import_summary['Pathology Report']['@@ERROR@@']["Gleason score of 'extra-prostatic' extension value won't be imported"]['-1'] = "Please confirm.";
						}
					} else if(preg_match('/^y\ etablie$/', strtolower($new_line_data['extracapsulaire précision']), $matches)) {
						$event_details['extra_prostatic_extension_precision'] = 'established';
					} else if(preg_match('/^y(es){0,1}\ (uni){0,1}focal[e]{0,1}(\ ([0-9]\ \+\ [0-9])){0,1}$/', strtolower($new_line_data['extracapsulaire précision']), $matches)) {
						$event_details['extra_prostatic_extension_precision'] = 'focal';
						if(isset($matches[4])) {
							$import_summary['Pathology Report']['@@ERROR@@']["Gleason score of 'extra-prostatic' extension value won't be imported"]['-1'] = "Please confirm.";
						}
					} else 	{
						$excel_field = 'extracapsulaire précision';
						$import_summary['Pathology Report']['@@ERROR@@']["'".$excel_field."' value format not supported"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
					}	
				}
				if($event_details['extra_prostatic_extension_precision'] && $extra_prostatic_extension != 'present') {
					$import_summary['Pathology Report']['@@ERROR@@']["'extra prostatic extension' data conflict"][] = "Margin was not defined as positive but a focal/extensuve value was set. Please check data and correct if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
				}
				$new_line_data['vésicule séminale unilatérale ou bilatérale'] = strtolower(str_replace(array('É', 'é'), array('e', 'e'), $new_line_data['vésicule séminale unilatérale ou bilatérale']));
				switch(strtolower($new_line_data['vésicule séminale unilatérale ou bilatérale'])) {
					case "y-droit":
					case "y-droite":
					case "y-drte":
					case "yes-droite":
					case "yes-gauche":
					case "unilat. (gauche)":
					case "y-unilaterale (g)":
					case "y-gauche":
					case "y-gche":
						$event_details['extra_prostatic_extension_seminal_vesicles'] = 'unilateral';
						break;
					case "y-bilaterale":
					case "y-bilaterales":
					case "yes-bilateral":
						$event_details['extra_prostatic_extension_seminal_vesicles'] = 'bilateral';
						break;
					case "y":
					case "y- nd":
					case "yes 9non-determine)":
					case "y-non-determine":
					case "y-non-determ.":
					case "yes-n/d":
						$event_details['extra_prostatic_extension_seminal_vesicles'] = 'bilateral';
						$import_summary['Pathology Report']['@@ERROR@@']["'Location of extra-prostatic extension : Seminal vesicles' will be set to bilateral when laterality is not specified"][] = "Please confirm. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
						break;
					case "no":
						$event_details['extra_prostatic_extension_seminal_vesicles'] = 'absent';
						break;
					case 'indetermine':
					case 'non-evaluable':
					case '':
					case '-':
						break;
					default:
						$excel_field = 'vésicule séminale unilatérale ou bilatérale';
						$import_summary['Pathology Report']['@@ERROR@@']["'".$excel_field."' value format not supported"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
				}
				$tmp_array = array(
					array('pathologic_staging_pt', 'pT (version avec pT2+)', array("pTx","pT2","pT2a","pT2b","pT2c","pT2+","pT3a","pT3b","pT4"), ''),
					array('pathologic_staging_pn', 'pN', array("Nx","N0","N1"), 'p'),
					array('pathologic_staging_pm', 'pM', array("Mx","M0","m1","M1a","M1b","M1c"), 'p'));
				foreach($tmp_array as $tmp_data) {
					list($db_field, $excel_field, $allowed_values, $prefix) = $tmp_data;
					if(strlen(str_replace(array('.','-', '?', '0'),array('', '', '', ''),$new_line_data[$excel_field]))) {
						$new_line_data[$excel_field] = str_replace(array('PT2c', 'PT2+', 'pT2C', 'MX', 'NX'), array('pT2c', 'pT2+', 'pT2c', 'Mx', 'Nx'), $new_line_data[$excel_field]);
						if(in_array($new_line_data[$excel_field], $allowed_values)) {
							$event_details[$db_field] = str_replace('pN0', 'pn0', $prefix.$new_line_data[$excel_field]);
						} else {
							$import_summary['Pathology Report']['@@ERROR@@']["'".$excel_field."' value format not supported"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
						}
					}
				}
				$tmp_array = array("ganglions nb examinés" => "pathologic_staging_pn_lymph_node_examined", "ganglions nb atteint(s)" => "pathologic_staging_pn_lymph_node_involved");
				foreach($tmp_array as $excel_field => $db_field) {
					if(strlen($new_line_data[$excel_field]) && $new_line_data[$excel_field] != '?') {
						if(preg_match('/^[0-9]+$/', $new_line_data[$excel_field])) {
							$event_details[$db_field] = $new_line_data[$excel_field];
						} else {
							$import_summary['Pathology Report']['@@ERROR@@']["'".$excel_field."' format error"][] = "Value [".$new_line_data[$excel_field]."] won't be migrated. To add manually into ATiM after migration if required. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
						}
					}
				}
				$val = getDecimal($new_line_data, 'poids prostate en gramme', 'Pathology Report', $file_name, $line_counter);
				if(strlen($val)) {
					$event_details['prostate_weight_gr'] = $val;
				}
				$tmp_details = array_filter($event_details);
				if($event_date['date'] || $tmp_details) {
					$event_details['pathologic_staging_pn_collected'] = (!isset($tmp_details['pathologic_staging_pn']) || $tmp_details['pathologic_staging_pn'] != 'pNx')? 'y' : 'n';
					$data = array(
						'EventMaster' => array(
							'participant_id' => $participant_id,
							'procure_form_identification' => "$participant_identifier V01 -PST1",
							'event_control_id' => $event_control['event_control_id'],
							'event_date' => $event_date['date'],
							'event_date_accuracy' => $event_date['accuracy'],
							'event_summary' => 'Révisé par Dr Têtu. '. $new_line_data['note; commentaires']),
						'EventDetail' => $event_details);
					$data['EventDetail']['event_master_id'] = customInsert($data['EventMaster'], 'event_masters', __FILE__, __LINE__, false);
					customInsert($data['EventDetail'], $event_control['detail_tablename'], __FILE__, __LINE__, true);
				}
			} else {
				$import_summary['Pathology Report']['@@ERROR@@']['Patient Identification Unknown'][$participant_identifier] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient Patho Data data won't be migrated! [field <b>NoProcure</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
			}
			//Record Prostatectomy Data
			if(!in_array($new_line_data['laparotomie'], array('', '1'))) {
				$import_summary['Treatment']['@@ERROR@@']["Wrong Laparotomy Value"][] = "See values [".$new_line_data['laparotomie']."] for '$participant_identifier' [file <b>$file_name</b>- line: <b>$line_counter</b>]";
				$new_line_data['laparotomie'] = '';
			}
			if(!in_array($new_line_data['laparoscopie'], array('', '1'))) {
				$import_summary['Treatment']['@@ERROR@@']["Wrong Laparoscopie Value"][] = "See values [".$new_line_data['laparoscopie']."] for '$participant_identifier' [file <b>$file_name</b>- line: <b>$line_counter</b>]";
				$new_line_data['laparoscopie'] = '';
			}
			if(strlen($new_line_data['Chirurgien'].$new_line_data['laparotomie'].$new_line_data['laparoscopie'])) {
				if(isset($prostatectomy_data[$participant_identifier])) {
					$import_summary['Treatment']['@@ERROR@@']["Prostatectomy data recorded twice"][] = "Only one will be imported! See '$participant_identifier' [file <b>$file_name</b>- line: <b>$line_counter</b>]";
				}
				$prostatectomy_data[$participant_identifier] = array('Chirurgien' => $new_line_data['Chirurgien'], 'laparotomie' => $new_line_data['laparotomie'], 'laparoscopie' => $new_line_data['laparoscopie']);
			}
		}
	}
	return $prostatectomy_data;
}

function loadPSAs(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho) {
	global $import_summary;
	global $controls;
	global $patients_to_import;
	// Control
	$psa_control = $controls['EventControl']['procure follow-up worksheet - aps'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadPSAs
	$line_counter = 0;
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('tous aps')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {		
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['NoProcure'];
			if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
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
					$biochemical_relapse = (strlen(str_replace(' ', '', $new_line_data['récidive procure selon définition strcte (2 mesure consécut.  >0,2 )'])))? 'y' : '';
					$data = array(
						'EventMaster' => array(
							'participant_id' => $participant_id,
							'procure_form_identification' => "$participant_identifier Vx -FSPx",
							'event_control_id' => $psa_control['event_control_id'],
							'event_date' => $event_date['date'],
							'event_date_accuracy' => $event_date['accuracy'],),
						'EventDetail' => array(
							'total_ngml' => $total_ngml,
							'procure_chuq_minimum' => $procure_chuq_minimum,
							'biochemical_relapse' => $biochemical_relapse));
					$data['EventDetail']['event_master_id'] = customInsert($data['EventMaster'], 'event_masters', __FILE__, __LINE__, false);
					customInsert($data['EventDetail'], $psa_control['detail_tablename'], __FILE__, __LINE__, true);
				}
			} else {
				$import_summary['PSA']['@@ERROR@@']['Patient Identification Unknown'][$participant_identifier] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient PSA data won't be migrated! [field <b>NoProcure</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";	
			}
		}
	}
}

function loadImagery(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho) {
	global $import_summary;
	global $controls;
	global $patients_to_import;
	// Control
	$event_control = $controls['EventControl']['procure follow-up worksheet - clinical event'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadPSAs
	$line_counter = 0;
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('Req_Immagerie_Médicale_24_04_20')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['NoProcure'];
			if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
			if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
				$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
				$event_date  = getDateAndAccuracy($new_line_data, 'DScan', 'Imagery', $file_name, $line_counter);
				switch($new_line_data['DScan(P)']) {
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
				$all_imagery = array();
				$scan_properties = array(
					'TacoIRM' => array('type' => array('1' => 'CT-scan', '2' => 'MRI'), 'sites' => array('Tete','Poumon','Foie','SurRenal','Rein','GGPelvien','GGRetroPerit','GGThorax')),
					'ScinTSerieMeta' => array('type' => array('1' => 'bone scintigraphy', '2' => 'PET-scan'), 'sites' =>  array('Cranien','Thorax','Vertebre','Sacrum','MembreInf','MembreSup'))
				);
				foreach($scan_properties as $excel_field => $imagery_data) {
					if($new_line_data[$excel_field]) {
						if(in_array($new_line_data[$excel_field], array_keys($imagery_data['type']))) {
							$type = $imagery_data['type'][$new_line_data[$excel_field]];
							$negative = false;
							$positive = false;
							$suspicious = false;
							$sites = array();
							foreach($imagery_data['sites'] as $site) {
								switch($new_line_data[$site]) {
									case '0':
										$sites[] = "$site = negatif";
										$negative = true;
										break;
									case '1':
										$sites[] = "$site = positif";
										$positive = true;
										break;
									case '2':
										$sites[] = "$site = suspect";
										$suspicious = true;
										break;
									case '9':
										$sites[] = "$site = inconnu";
										$import_summary['Imagery']['@@WARNING@@']["Imagery result '9' not supported - set as unknown"][] = "See '$excel_field' on site '$site' for patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
										break;
									case '':
										break;
									default:
										$import_summary['Imagery']['@@ERROR@@']["Imagery result not supported so not imported"][] = "See '$excel_field' result '".$new_line_data[$site]."' on site '$site' for patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
										
								}
							}					
							$all_imagery[$type] = array('result' => ($positive? 'positive' : ($suspicious? 'suspicious' : ($negative? 'negative' : ''))), 'sites' => $sites);
						} else {
							$import_summary['Imagery']['@@ERROR@@']["$excel_field value not supported so not imported"][] = "See '$excel_field' value '".$new_line_data[$excel_field]."' for patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";	
						}
					}
				}
				if($all_imagery) {
					foreach($all_imagery as $type => $res_data) {
						$data = array(
							'EventMaster' => array(
								'participant_id' => $participant_id,
								'procure_form_identification' => "$participant_identifier Vx -FSPx",
								'event_control_id' => $event_control['event_control_id'],
								'event_date' => $event_date['date'],
								'event_date_accuracy' => $event_date['accuracy'],
								'event_summary' => (empty($res_data['sites'])? '' : 'Res : ['.implode(' & ',  $res_data['sites']).'].').(empty($new_line_data['Notes'])? '' : ((empty($res_data['sites'])? '' : ' ').'Notes : '.$new_line_data['Notes']))),
							'EventDetail' => array(
								'type' => $type,
								'results' => $res_data['result']));
						$data['EventDetail']['event_master_id'] = customInsert($data['EventMaster'], 'event_masters', __FILE__, __LINE__, false);
						customInsert($data['EventDetail'], $event_control['detail_tablename'], __FILE__, __LINE__, true);
					}
				} else if(strlen($new_line_data['Notes'])) {
					$import_summary['Imagery']['@@WARNING@@']['Note with no type of imagery'][] = "The note won't be imported! See patient '$participant_identifier'! [field <b>NoProcure</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
				}
			} else {
				$import_summary['Imagery']['@@ERROR@@']['Patient Identification Unknown'][$participant_identifier] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient Imagery data won't be migrated! [field <b>NoProcure</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
			}
		}
	}
}

function loadOtherDx(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho) {
	global $import_summary;
	global $controls;
	global $patients_to_import;
	// Control
	$event_control = $controls['EventControl']['procure follow-up worksheet - other tumor dx'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadPSAs
	$line_counter = 0;
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('Feuil1')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = formatNewLineData($headers, $new_line);	
			$participant_identifier = $new_line_data['NoProcure'];
			if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
			if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
				$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
				$event_date  = getDateAndAccuracy($new_line_data, 'DtAutreCancer', 'Other Tumor Dx', $file_name, $line_counter);
				$icd_10_code = str_replace('.', '', $new_line_data['CodeAutreCancer']);
				$tumor_site = '';
				switch($new_line_data['site']) {
					case 'colon':
						$tumor_site = 'digestive - colorectal';
						break;
					case 'rectum':
						$tumor_site = 'digestive - colorectal';
						break;
					case 'bronches-poumon':
						$tumor_site = 'thoracic - lung';
						break;
					case 'mélanome':
						$tumor_site = 'skin - melanoma';
						break;
					case 'peau':
						$tumor_site = 'skin - non melanomas';
						break;
					case 'testicules':
						$tumor_site = 'male genital - testis';
						break;
					case 'rein':
						$tumor_site = 'urinary tract - kidney';
						break;
					case 'vessie':
						$tumor_site = 'urinary tract - bladder';
						break;
					case 'encéphale':
						$tumor_site = 'central nervous system - brain';
						break;
					case 'thyroïde':
						$tumor_site = 'head & neck - thyroid';
						break;
					case 'lymphome':
						$tumor_site = 'haematological - lymphoma';
						break;
					case 'leucémie':
						$tumor_site = 'haematological - leukemia';
						break;
					case '';
						break;
					default:
						$import_summary['Other Tumor Dx']['@@ERROR@@']['Tumor Site To Support In Migration Script'][] = "Tumor site'".$new_line_data['site']."' has to be supported. See '$participant_identifier'. Data won't be migrated! [field <b>NoProcure</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
				}
				$data = array(
					'EventMaster' => array(
						'participant_id' => $participant_id,
						'procure_form_identification' => "$participant_identifier Vx -FSPx",
						'event_control_id' => $event_control['event_control_id'],
						'event_date' => $event_date['date'],
						'event_date_accuracy' => $event_date['accuracy']),
					'EventDetail' => array(
						'procure_chuq_icd10_code' => $icd_10_code,
						'tumor_site' => $tumor_site));
				$data['EventDetail']['event_master_id'] = customInsert($data['EventMaster'], 'event_masters', __FILE__, __LINE__, false);
				customInsert($data['EventDetail'], $event_control['detail_tablename'], __FILE__, __LINE__, true);
			} else {
				$import_summary['Other Tumor Dx']['@@ERROR@@']['Patient Identification Unknown'][$participant_identifier] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient Other Tumor data won't be migrated! [field <b>NoProcure</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
			}
		}
	}
	//UPDATE ICD
	$sql = "SELECT DISTINCT procure_chuq_icd10_code FROM procure_ed_followup_worksheet_other_tumor_diagnosis 
		WHERE procure_chuq_icd10_code IS NOT NULL AND procure_chuq_icd10_code NOT IN (SELECT id FROM coding_icd10_who);";
	$results = customQuery($sql, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$unsupported_procure_chuq_icd10_code = $row['procure_chuq_icd10_code'];
		$new_procure_chuq_icd10_code = $unsupported_procure_chuq_icd10_code.'0';
		$sql = "SELECT id FROM coding_icd10_who WHERE id = '$new_procure_chuq_icd10_code'";
		$results_2 = customQuery($sql, __FILE__, __LINE__);
		if($results_2->num_rows) {
			$sql = "UPDATE procure_ed_followup_worksheet_other_tumor_diagnosis SET procure_chuq_icd10_code = '$new_procure_chuq_icd10_code' WHERE procure_chuq_icd10_code = '$unsupported_procure_chuq_icd10_code';";
			customQuery($sql, __FILE__, __LINE__);
			$import_summary['Other Tumor Dx']['@@WARNING@@']['ICD10 code unknown & reaplced'][] = "The ICD10 '$unsupported_procure_chuq_icd10_code' is not supported and has been replaced by code '$new_procure_chuq_icd10_code'! To validate!";
			
		} else {
			
			$sql = "UPDATE procure_ed_followup_worksheet_other_tumor_diagnosis, event_masters 
				SET procure_chuq_icd10_code = '', event_summary = 'Unknown ICD code $unsupported_procure_chuq_icd10_code' 
				WHERE procure_chuq_icd10_code = '$unsupported_procure_chuq_icd10_code' AND id = event_master_id;";
			customQuery($sql, __FILE__, __LINE__);
			$import_summary['Other Tumor Dx']['@@ERROR@@']['ICD10 code unknown'][] = "The ICD10 '$unsupported_procure_chuq_icd10_code' is not supported! Will be deleted and added to note!";
		}
	}
}

function loadTreatments(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho, &$prostatectomy_data_from_patho) {
	global $import_summary;
	global $controls;
	global $patients_to_import;
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
	list($periods, $period_control_id) = loadDbPermissibleCustomValues('Treatment Period');
	//Treatment Protocol
	$tx_protocols = array();
	list($tx_protocols, $tx_protocol_control_id) = loadDbPermissibleCustomValues('Treatment Protocols');
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadTreatment
	$line_counter = 0;
	$headers = array();
	$created_prostatectomy = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('traitements')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['NoProcure'];
			if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
			if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
				$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
				//***** NEW TREATMENT (!= Prostatectomy) *****
				if(strlen($new_line_data['Type'])) {
					$start_date = getDateAndAccuracy($new_line_data, 'DDebut', 'Treatment', $file_name, $line_counter);
					$finish_date = getDateAndAccuracy($new_line_data, 'DFin', 'Treatment', $file_name, $line_counter);
					switch($new_line_data['DDebut_P']) {
						case 'j':
							$start_date['accuracy'] = 'd';
							$finish_date['accuracy'] = 'd';
							break;
						case 'jm':
							$start_date['accuracy'] = 'm';
							$finish_date['accuracy'] = 'm';
							break;
						case 'jma':
							$start_date['accuracy'] = 'y';
							$finish_date['accuracy'] = 'y';
							break;
						default:
					}
					$dose = array();
					if(strlen($new_line_data['QteDose'])) $dose[] = 'Dose: '.$new_line_data['QteDose'];
					if(strlen($new_line_data['Fraction'])) $dose[] = 'Fraction: '.$new_line_data['Fraction'];
					$dose = implode(' & ', $dose);
					$treatment_controls = null;
					$treatment_notes = '';
					$detail_data = array();
					switch($new_line_data['Type']) {
						//Chemotherpay
						case 'Tx':				
						case 'Tx-Chimio':				
							$treatment_controls = $tx_control['procure follow-up worksheet - treatment'];
							$period = getPermissibleCustomValue($new_line_data['Periode'], $periods, $period_control_id);
							$tx_protocol = getPermissibleCustomValue($new_line_data['Protocole'], $tx_protocols, $tx_protocol_control_id);							
						 	$drug_ids = array();
							foreach(explode('-',$new_line_data['Med']) as $generic_name) $drug_ids[] = getDrugId($generic_name, 'chemotherapy', $drugs);
						 	if(empty($drug_ids)) $drug_ids[] = null;
						 	foreach($drug_ids as $drug_id) {
						 		$detail_data[] = array(
						 			'treatment_type' => 'chemotherapy',
						 			'drug_id' => $drug_id,
						 			'procure_chuq_period' => $period,
						 			'dosage' => $dose,
						 			'procure_chuq_protocol' => $tx_protocol
						 		);
						 	}
						 	break;
						case 'Hx':
						case 'Hx-AA':
						case 'Hx-LA':
						case 'Hx-X':
							$treatment_controls = $tx_control['procure follow-up worksheet - treatment']; 
							if(preg_match('/^Hx\-(.+)$/',  $new_line_data['Type'], $matches)) {
								$treatment_notes = 'Hormono-'.$matches[1];
							}
							$period = getPermissibleCustomValue($new_line_data['Periode'], $periods, $period_control_id);
							$tx_protocol = getPermissibleCustomValue($new_line_data['Protocole'], $tx_protocols, $tx_protocol_control_id);
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
									'drug_id' => $drug_id,
									'procure_chuq_period' => $period,
						 			'dosage' => $dose,
						 			'procure_chuq_protocol' => $tx_protocol);
							}
							break;
						case 'Rx':
						case 'Rx-Ext':
						case 'Rx-Cur':
							$treatment_controls = $tx_control['procure follow-up worksheet - treatment'];
							$tx_protocol = getPermissibleCustomValue($new_line_data['Protocole'], $tx_protocols, $tx_protocol_control_id);
							$period = getPermissibleCustomValue($new_line_data['Periode'], $periods, $period_control_id);
							$detail_data = array(array(
								'treatment_type' => ($new_line_data['Type'] == 'Rx-Cur')? 'brachytherapy' : 'radiotherapy',
								'procure_chuq_period' => $period,
						 		'dosage' => $dose,
						 		'procure_chuq_protocol' => $tx_protocol));
							if(strlen($new_line_data['Med']) && $new_line_data['Med'] != 'Curiethérapie HDR' && $new_line_data['Med'] != 'Curiethérapie') {
								$import_summary['Treatment']['@@WARNING@@']["'Med' info linked to 'radiotherapy' or 'brachytherapy'"][] = "Field 'med' is not empty (see value '".$new_line_data['Med']."'). Migration process will add this information to note. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
								$treatment_notes = $new_line_data['Med'];	
							}
							break;
						case 'HBP-AI':
						case 'HBP-AB':
							$drug_id = getDrugId($new_line_data['Med'], 'prostate', $drugs);
							if($drug_id) {
								$treatment_controls = $tx_control['procure medication worksheet - drug'];
								preg_match('/^HBP\-(.+)$/',  $new_line_data['Type'], $matches);
								$treatment_notes = 'Hyp. Beg. Pro. - '.$matches[1];
								$period = getPermissibleCustomValue($new_line_data['Periode'], $periods, $period_control_id);
								$tx_protocol = getPermissibleCustomValue($new_line_data['Protocole'], $tx_protocols, $tx_protocol_control_id);
								$detail_data = array(array(
									'drug_id' => $drug_id, 
									'procure_chuq_period' => $period,
						 			'dose' => $dose,
						 			'procure_chuq_protocol' => $tx_protocol));
							} else {
								$import_summary['Treatment']['@@WARNING@@']["Missing Drug"][] = "A Prostate treatment has been defined on ".$start_date['date']." but no drug has been associated to this one (field 'Med'). No treatment will be created. This one has to be created manually into ATiM after migration. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
							}
							break;
						case 'Autres':
							if(in_array($new_line_data['Periode'], array('ContrES', 'Pall'))) {
								$drug_id = getDrugId($new_line_data['Med'].' ('.$new_line_data['Periode'].')', 'prostate', $drugs);
								if($drug_id) {
									$treatment_controls = $tx_control['procure medication worksheet - drug'];
									$treatment_notes = '';
									$tx_protocol = getPermissibleCustomValue($new_line_data['Protocole'], $tx_protocols, $tx_protocol_control_id);
									$detail_data = array(array(
										'drug_id' => $drug_id,
										'dose' => $dose,
										'procure_chuq_protocol' => $tx_protocol));
								} else {
									$import_summary['Treatment']['@@WARNING@@']["Missing Drug"][] = "A Prostate treatment has been defined on ".$start_date['date']." but no drug has been associated to this one (field 'Med'). No treatment will be created. This one has to be created manually into ATiM after migration. See patient '$participant_identifier'. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
								}	
								break;
							}
						default:
							$import_summary['Treatment']['@@WARNING@@']["Treatment To Create Manually (type not supported)"][] = "See patient '$participant_identifier' : Treatment [".$new_line_data['Med']." - ".$new_line_data['Type']."' with Periode '".$new_line_data['Periode']."'] on ".$start_date['date']." won't be migrated. This one has to be created manually into ATiM after migration. [file <b>$file_name</b>- line: <b>$line_counter</b>]";
					}
					if($treatment_controls)  {
						if(empty($start_date['date'])) $import_summary['Treatment']['@@WARNING@@']['No Treatment Start Date'][] = "System is creating a treatment with no tratment date. See patient '$participant_identifier'! [field <b>Debut</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
						foreach($detail_data as $new_detail) {
							$data = array(
								'TreatmentMaster' => array(
									'participant_id' => $participant_id,
									'procure_form_identification' => ($treatment_controls['detail_tablename'] != 'procure_txd_medication_drugs')? "$participant_identifier Vx -FSPx" : "$participant_identifier Vx -MEDx",
									'treatment_control_id' => $treatment_controls['treatment_control_id'],
									'start_date' => $start_date['date'],
									'start_date_accuracy' => $start_date['accuracy'],
									'finish_date' => $finish_date['date'],
									'finish_date_accuracy' => $finish_date['accuracy'],
									'notes' => $treatment_notes),
								'TreatmentDetail' => $new_detail);
							$data['TreatmentDetail']['treatment_master_id'] = customInsert($data['TreatmentMaster'], 'treatment_masters', __FILE__, __LINE__, false);
							customInsert($data['TreatmentDetail'], $treatment_controls['detail_tablename'], __FILE__, __LINE__, true);
						}
					}
				} else if(strlen(str_replace(' ', '', ($new_line_data['DDebut'].$new_line_data['DDebut_P'].$new_line_data['DFin'].$new_line_data['Type'].$new_line_data['Med'].$new_line_data['QteDose'].$new_line_data['Fraction'].$new_line_data['Protocole'].$new_line_data['EnCours'].$new_line_data['Periode'])))) {
					$not_empty_data = array();
					foreach(array('DDebut','DDebut_P','DFin','Type','Med','QteDose','Fraction','Protocole','EnCours','Periode') as $field) {
						if(strlen($new_line_data[$field])) $not_empty_data[] = $field.' : '.$new_line_data[$field];
					}
					$not_empty_data = implode (' & ', $not_empty_data);
					$import_summary['Treatment']['@@WARNING@@']["Treatment field 'Type' empty but other fields compelted"][$participant_identifier] = "See values [$not_empty_data] for '$participant_identifier'! No treatment will be created! [field <b>patients</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
				}
				//***** CREATE PROSTATECTOMY *****
				if(strlen($new_line_data['Date Prostatec']) && !isset($created_prostatectomy[$participant_identifier])) {
					$date_of_prostatectomy = getDateAndAccuracy($new_line_data, 'Date Prostatec', 'Treatment', $file_name, $line_counter);
					if($date_of_prostatectomy) {
						$surgeon = '';
						$laparotomy = '';
						$laparoscopy = '';
						if(array_key_exists($participant_identifier, $prostatectomy_data_from_patho)) {
							$surgeon = $prostatectomy_data_from_patho[$participant_identifier]['Chirurgien'];
							$laparotomy = $prostatectomy_data_from_patho[$participant_identifier]['laparotomie'];
							$laparoscopy = $prostatectomy_data_from_patho[$participant_identifier]['laparoscopie'];
							unset($prostatectomy_data_from_patho[$participant_identifier]);
						}
						$prostatectomy_data = array(
							'TreatmentMaster' => array(
								'participant_id' => $participant_id,
								'procure_form_identification' => "$participant_identifier Vx -FSPx",
								'treatment_control_id' => $tx_control['procure follow-up worksheet - treatment']['treatment_control_id'],
								'start_date' => $date_of_prostatectomy['date'],
								'start_date_accuracy' => $date_of_prostatectomy['accuracy'],
								'notes' => ''),
							'TreatmentDetail' => array(
								'treatment_type' => 'prostatectomy',
								'procure_chuq_surgeon' => $surgeon,
								'procure_chuq_laparotomy' => $laparotomy,
								'procure_chuq_laparoscopy' => $laparoscopy));
						$prostatectomy_data['TreatmentDetail']['treatment_master_id'] = customInsert($prostatectomy_data['TreatmentMaster'], 'treatment_masters', __FILE__, __LINE__, false);
						customInsert($prostatectomy_data['TreatmentDetail'], $tx_control['procure follow-up worksheet - treatment']['detail_tablename'], __FILE__, __LINE__, true);
						$created_prostatectomy[$participant_identifier] = array(
							'id' => $prostatectomy_data['TreatmentDetail']['treatment_master_id'],
							'start_date' => $date_of_prostatectomy['date'],
							'start_date_accuracy' => $date_of_prostatectomy['accuracy']);
					}
				}
			} else {
				$import_summary['Treatment']['@@ERROR@@']['Patient Identification Unknown'][$participant_identifier] = "The Identification '$participant_identifier' has not been listed in the patient file! Patient PSA data won't be migrated! [field <b>patients</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
			}
		}
	}
	return $created_prostatectomy;
}

function getDrugId($drug_name, $type, &$drugs) {
	global $import_summary;
	$drug_name = trim($drug_name);
	$generic_name = '';
	if(strlen($drug_name)) {
		$generic_name = $drug_name;
	}
	$generic_name_key = strtolower($generic_name);
	if(!strlen($generic_name_key)) return null;
	$procure_study = (preg_match('/(placebo)|([ée]tude)/', $generic_name_key))? '1' : '';
	if(!isset($drugs[$type]) || !isset($drugs[$type][$generic_name_key])) {
		$drugs[$type][$generic_name_key] = customInsert(array('generic_name' => $generic_name, 'type' => $type, 'procure_study' => $procure_study), 'drugs', __FILE__, __LINE__, false, true);
		$import_summary['Treatment']['@@MESSAGE@@']["New Drug"][] = "Created $type drug [$generic_name]".($procure_study? ' flagged as study': '')."!";
	}
	return $drugs[$type][$generic_name_key];	
}

function loadDbPermissibleCustomValues($control_name) {
	$query = "SELECT id FROM structure_permissible_values_custom_controls WHERE name = '$control_name';";
	$results = customQuery($query, __FILE__, __LINE__);
	$row = $results->fetch_assoc();
	$control_id = $row['id'];
	$query = "SELECT value FROM structure_permissible_values_customs WHERE control_id = $control_id AND deleted <> 1;";
	$values = array();
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$values[getPermissibleCustomValueKey($row['value'])] = $row['value'];
	}
	return array($values, $control_id);
}

function getPermissibleCustomValue($value_to_test, &$db_values, $tx_permissible_value_control_id) {
	$value_to_test = trim($value_to_test);
	$value_key = getPermissibleCustomValueKey($value_to_test);
	if(!strlen($value_key)) return null;
	if(!array_key_exists($value_key, $db_values)) {
		customInsert(array('value' => $value_key, 'en' => $value_to_test, 'fr' => $value_to_test, 'use_as_input' => '1', 'control_id' => $tx_permissible_value_control_id), 'structure_permissible_values_customs', __FILE__, __LINE__, false, true);
		$db_values[$value_key] = $value_key;
	}
	return $db_values[$value_key];
}

function getPermissibleCustomValueKey($value) {
	$value = str_replace(
		array(
			'à', 'â', 'ä', 'á', 'ã', 'å',
			'î', 'ï', 'ì', 'í', 
			'ô', 'ö', 'ò', 'ó', 'õ', 'ø', 
			'ù', 'û', 'ü', 'ú', 
			'é', 'è', 'ê', 'ë', 
			'ç', 'ÿ', 'ñ',
			'À', 'Â', 'Ä', 'Á', 'Ã', 'Å',
			'Î', 'Ï', 'Ì', 'Í', 
			'Ô', 'Ö', 'Ò', 'Ó', 'Õ', 'Ø', 
			'Ù', 'Û', 'Ü', 'Ú', 
			'É', 'È', 'Ê', 'Ë', 
			'Ç', 'Ÿ', 'Ñ', 
		),
		array(
			'a', 'a', 'a', 'a', 'a', 'a', 
			'i', 'i', 'i', 'i', 
			'o', 'o', 'o', 'o', 'o', 'o', 
			'u', 'u', 'u', 'u', 
			'e', 'e', 'e', 'e', 
			'c', 'y', 'n', 
			'A', 'A', 'A', 'A', 'A', 'A', 
			'I', 'I', 'I', 'I', 
			'O', 'O', 'O', 'O', 'O', 'O', 
			'U', 'U', 'U', 'U', 
			'E', 'E', 'E', 'E', 
			'C', 'Y', 'N', 
		),$value);
	$value = trim($value);
	$value = strtolower($value);
	return $value;
}

function loadRevision(&$XlsReader, $files_path, $file_name, $psp_nbr_to_participant_id_and_patho) {
	global $import_summary;
	global $controls;
	global $patients_to_import;
	// Control
	$event_control = $controls['EventControl']['procure follow-up worksheet - clinical note'];
	//Load Worksheet Names
	$XlsReader->read($files_path.$file_name);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	//LoadPSAs
	$line_counter = 0;
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('Feuil1')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = formatNewLineData($headers, $new_line);
			$participant_identifier = $new_line_data['Code Patient'];
			if(!empty($patients_to_import) && !in_array($participant_identifier, $patients_to_import)) continue;
			if(array_key_exists($participant_identifier, $psp_nbr_to_participant_id_and_patho)) {
				$participant_id = $psp_nbr_to_participant_id_and_patho[$participant_identifier]['participant_id'];
				$event_date['date']  = '2015-01-01';
				$event_date['accuracy']  = 'd';
				$data_to_migrate = array();
				foreach( array('pT', 'Hormono','Date du décès (cause)','Renseignements additionnels','Opinion LL si Tx adjuvant à la chx','Opinion LL date de récidive') as $excel_field) {
					if(strlen($new_line_data[$excel_field])) $data_to_migrate[$excel_field] = $excel_field.' : '.$new_line_data[$excel_field];
				}
				if($data_to_migrate) {
					$data = array(
						'EventMaster' => array(
							'participant_id' => $participant_id,
							'procure_form_identification' => "$participant_identifier Vx -FSPx",
							'event_control_id' => $event_control['event_control_id'],
							'event_date' => $event_date['date'],
							'event_date_accuracy' => $event_date['accuracy'],
							'event_summary' => 'Revision Dr Lacombe: \n'.implode('.\n', $data_to_migrate).'.'),
						'EventDetail' => array());
					$data['EventDetail']['event_master_id'] = customInsert($data['EventMaster'], 'event_masters', __FILE__, __LINE__, false);
					customInsert($data['EventDetail'], $event_control['detail_tablename'], __FILE__, __LINE__, true);
				}
			} else {
				$import_summary['Dr Lacombe Revision']['@@ERROR@@']['Patient Identification Unknown'][$participant_identifier] = "The Identification '$participant_identifier' has not been listed in the patient file! Data won't be migrated! [field <b>Code Patient</b> - file <b>$file_name</b>- line: <b>$line_counter</b>]";
			}
		}
	}
}

?>