<?php

function loadFollowupData() {
	Config::$followups = array();
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path_followups);
	$filename = substr(Config::$xls_file_path_followups, (strrpos(Config::$xls_file_path_followups,'/')+1));
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	Config::$summary_msg['Follow-up : File: '.$filename]['@@WARNING@@']['Fields not parsed'][] = 
		"Médicaments pour autres problèmes de santé (prescrits et en vente libre)  (nom et posologie)"."<br>".
		"Produits naturels";

	for($v_id = 2; $v_id < 8; $v_id++) {
		$work_sheet_name = 'V0'.$v_id;
		$summary_msg_title = 'Follow-up : File: '.$filename.' / '.$work_sheet_name;
		if(!isset($tmp_xls_reader->sheets[$sheets_nbr[$work_sheet_name]])) die('ERR lfollop 3222222');
		$headers = array();
		$line_counter = 0;
		$is_2011_version = preg_match('/v2011$/', $work_sheet_name);
		foreach($tmp_xls_reader->sheets[$sheets_nbr[$work_sheet_name]]['cells'] as $line => $new_line) {
			$line_counter++;
			if($line_counter == 1) {
				$headers = $new_line;
			} else {
				$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
				$patient_identification = $new_line_data['Code du Patient'];
				if($patient_identification) {
					if(isset(Config::$followups[$patient_identification][$work_sheet_name])) {
						Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Same Patient'][] = "Patient $patient_identification is listed more than once. No new data will be imported. See line: $line_counter";
					} else {	
						//1 ** procure follow-up worksheet 
						// EVENT MASTER
						$event_masters = array();
						$event_master_summary = array();
						$new_line_data['Date de la visite'] = str_replace(array('-', 'Abandon', 'Exclus'), array('', '', ''), $new_line_data['Date de la visite']);
						$tmp_event_date = getDateAndAccuracy($new_line_data['Date de la visite'], $summary_msg_title, "Date de la visite", $line_counter);
						if($tmp_event_date) {
							$event_masters['event_date'] = $tmp_event_date['date'];
							$event_masters['event_date_accuracy'] = $tmp_event_date['accuracy'];
						}
						$event_masters['procure_form_identification'] = $patient_identification." $work_sheet_name -FSP1";
						// EVENT DETAIL
						$event_details = array();
						$file_field = "Récidive biochimique (APS >= 0.2 ng/mL dans deux dosages successifs)";					
						if(strlen($new_line_data[$file_field])) {
							if(preg_match('/^[xX1]$/', $new_line_data[$file_field], $matches)) {
								$event_details['biochemical_recurrence'] = 'y';
							} else {
								Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Wrong bichemical recurrence value'][] = "Value '".$new_line_data[$file_field]."' assigned to field '$file_field' is different than [X or 1]. Won't be considered. See line: $line_counter";
							}
						}
						if(strlen($new_line_data['Récidive clinique Non'])) {
							if(!in_array($new_line_data['Récidive clinique Non'], array('X','x', '1'))) die('ERR 2387 68726 8723632 '.$new_line_data['Récidive clinique Non'].' / '.$work_sheet_name.' / '.$line_counter);
							if(strlen($new_line_data['Récidive clinique locale']) || strlen($new_line_data['Récidive clinique métastases à distance'])) {
								Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Clinical Recurrence Mismatch'][] = "Clinical Recurrence conflict. No one will be imported. See line: $line_counter";
							} else {
								$event_details['clinical_recurrence'] = 'n';
							}
						} else {
							if(strlen($new_line_data['Récidive clinique locale'])) {
								$event_details['clinical_recurrence'] = 'y';
								$event_details['clinical_recurrence_type'] = 'local';
								if(!in_array($new_line_data['Récidive clinique locale'], array('X','x', '1'))) {
									if($new_line_data['Récidive clinique locale'] == 'régionale') {
										$event_details['clinical_recurrence_type'] = 'regional';
									} else {
										die('ERR 8327 687263 872687 2 ');
									}								
								}
							}
							if(strlen($new_line_data['Récidive clinique métastases à distance'])) {
								$event_details['clinical_recurrence'] = 'y';
								if(isset($event_details['clinical_recurrence_type'])) {
									Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Clinical Recurrence defined both local and distant'][] = "Will set to distant and add local information into notes. See line: $line_counter";
									$event_master_summary[] = 'Clinical recurrence both local and distant.';
								}
								$event_details['clinical_recurrence_type'] = 'distant';		
								if(preg_match('/^(À distance - os)|([Oo]s)$/', $new_line_data['Récidive clinique métastases à distance'], $matches)) {
									$event_details['clinical_recurrence_site'] = 'bones';
								} else {	
									Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Distant Clinical Recurrence - No site'][] = "No site specified in [".str_replace("\n", '', $new_line_data['Récidive clinique métastases à distance'])."]. Added description to notes. See line: $line_counter";
									$event_master_summary[] = "Distant recurrence = " . str_replace(array("\n", ""), array('', "''"), $new_line_data['Récidive clinique métastases à distance']);
								}														
							}
						}
						if(strlen($new_line_data['Chirurgie pour métastases Oui'])) {
							Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['TODO: Add manualy metastasis surgery after migration'][] = str_replace("\n", '', 'Add following information to patient '.$patient_identification.' ['.$new_line_data['Chirurgie pour métastases Oui'].']['.$new_line_data['Chirurgie pour métastases Site'].']['.$new_line_data['Chirurgie pour métastases Date']."]. See line: $line_counter");
						} else if(strlen($new_line_data['Chirurgie pour métastases Site'].$new_line_data['Chirurgie pour métastases Date'])) {
							die('ERR 328 88232 3923 9');
						}
						if($event_master_summary) $event_masters['event_summary'] = str_replace("'","''", implode(' // ', $event_master_summary));
						Config::$followups[$patient_identification][$work_sheet_name]['procure follow-up worksheet'] = array('EventMaster' => $event_masters, 'EventDetail' => $event_details);
						
						//2 ** procure follow-up worksheet - aps
						$tmp_res =  loadFollowUpAPS($patient_identification, $new_line_data, $summary_msg_title, $line_counter, $event_masters['procure_form_identification']);
						if($tmp_res) {
							Config::$followups[$patient_identification][$work_sheet_name]['procure follow-up worksheet - aps'] = $tmp_res;
						} else if(isset($event_details['biochemical_recurrence'])) {
							die('ERR 3628 87236 87268 32');
						}
						
						//3 ** procure follow-up worksheet - clinical event
						$tmp_res =  loadFollowUpClinicaEvent($patient_identification, $new_line_data, $summary_msg_title, $line_counter, $event_masters['procure_form_identification']);
						if($tmp_res) Config::$followups[$patient_identification][$work_sheet_name]['procure follow-up worksheet - clinical event'] = $tmp_res;
						
						//4 ** procure follow-up worksheet - treatment
						$tmp_res =  loadFollowUpClinicaTreatment($patient_identification, $new_line_data, $summary_msg_title, $line_counter, $event_masters['procure_form_identification']);
						if($tmp_res) Config::$followups[$patient_identification][$work_sheet_name]['procure follow-up worksheet - treatment'] = $tmp_res;
						
						//5 ** Vital Status
						if(strlen($new_line_data['Décès Oui'].$new_line_data['Décès Date'].$new_line_data['Décès Cause du décès (cochez)'].$new_line_data['Décès Précisez'])) {
							Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['TODO: Decease information'][] = str_replace("\n", '', 'Add following decease information to patient ['.$patient_identification.'] ['.$new_line_data['Décès Oui'].'] ['.$new_line_data['Décès Date'].'] ['.$new_line_data['Décès Cause du décès (cochez)'].'] ['.$new_line_data['Décès Précisez']."]. See line: $line_counter");
						}
					}
				}
			}
		}		
	}	
}

function loadFollowUpClinicaTreatment($patient_identification, $new_line_data, $summary_msg_title, $line_counter, $procure_form_identification){
	$all_trts = array();
	$summary_msg_title = $summary_msg_title.(' - Treatment');
	
	// ** RADIOTHERAPY **
	$tmp_array = array(
		array('start_date_file_field' => 'Radiothérapie seule Date début',
			'finih_date_file_field' => 'Radiothérapie seule Date fin',
			'dose_file_field' => 'Radiothérapie seule Dose (Gray)',
			'treatment_type' => 'radiotherapy',
			'type' => ''),
		array('start_date_file_field' => 'Radiothérapie + Hormonothérapie Date début (radio)',
			'finih_date_file_field' => 'Radiothérapie + Hormonothérapie Date fin (radio)',
			'dose_file_field' => 'Radiothérapie + Hormonothérapie Dose (Gray)',
			'treatment_type' => 'radiotherapy + hormonotherapy',
			'type' => 'Radiotherapy'),
		array('start_date_file_field' => 'Radiothérapie antalgique Date début',
			'finih_date_file_field' => 'Radiothérapie antalgique Date fin',
			'dose_file_field' => 'Radiothérapie antalgique Dose (Gray)',
			'treatment_type' => 'antalgic radiotherapy', 
			'type' => ''));
	foreach($tmp_array as $new_trt) {
		if(strlen($new_line_data[$new_trt['start_date_file_field']].$new_line_data[$new_trt['finih_date_file_field']].$new_line_data[$new_trt['dose_file_field']])) {
			// Master Data
			$treatment_masters = array('procure_form_identification' => $procure_form_identification);
			$tmp_event_date = getDateAndAccuracy($new_line_data[$new_trt['start_date_file_field']], $summary_msg_title, $new_trt['start_date_file_field'], $line_counter);
			if($tmp_event_date) {
				$treatment_masters['start_date'] = $tmp_event_date['date'];
				$treatment_masters['start_date_accuracy'] = $tmp_event_date['accuracy'];
			}
			$tmp_event_date = getDateAndAccuracy($new_line_data[$new_trt['finih_date_file_field']], $summary_msg_title, $new_trt['finih_date_file_field'], $line_counter);
			if($tmp_event_date) {
				$treatment_masters['finish_date'] = $tmp_event_date['date'];
				$treatment_masters['finish_date_accuracy'] = $tmp_event_date['accuracy'];
			}
			// Detail Data
			$treatment_details = array('treatment_type' => $new_trt['treatment_type'], 'type' => $new_trt['type']);
			if(preg_match('/([0-9]{1,2}\ (Gy|Gray|Grays|grays)\ en [0-9]{1,2}\ fractions)/', $new_line_data[$new_trt['dose_file_field']], $matches)) {
				$treatment_details['dosage'] = $matches[1];
			} else {
				Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Unfound Radiotherpay Dose'][] = "No dose parsed in [".str_replace("\n", '', $new_line_data[$new_trt['dose_file_field']])."] for field '".$new_trt['dose_file_field']."'. See line: $line_counter";
			}
			$treatment_masters['notes'] = str_replace(array("\n", "'"), array('', "''"), $new_line_data[$new_trt['dose_file_field']]);
			$all_trts[] = array('TreatmentMaster' => $treatment_masters, 'TreatmentDetail' => $treatment_details);
		}
	}

	// ** HORMONOTHERAPY + CHEMO **
	$tmp_array = array(
		array('start_date_file_field' => 'Radiothérapie + Hormonothérapie Date début (hormono)',
			'finih_date_file_field' => 'Radiothérapie + Hormonothérapie Date fin (hormono)',
			'dose_file_field' => 'Radiothérapie + Hormonothérapie Médicament et dose',
			'treatment_type' => 'radiotherapy + hormonotherapy',
			'type' => 'Hormonotherapy'),
		array('start_date_file_field' => 'Hormonothérapie seule Date début',
			'finih_date_file_field' => 'Hormonothérapie seule Date fin',
			'dose_file_field' => 'Hormonothérapie seule Médicament et dose',
			'treatment_type' => 'hormonotherapy',
			'type' => ''),
		array('start_date_file_field' => 'Hormonothérapie (2e ligne) Date début',
			'finih_date_file_field' => 'Hormonothérapie (2e ligne) Date fin',
			'dose_file_field' => 'Hormonothérapie (2e ligne) Médicament et dose',
			'treatment_type' => 'hormonotherapy',
			'type' => '2nd line'),
		array('start_date_file_field' => 'Chimiothérapie Date début',
			'finih_date_file_field' => 'Chimiothérapie Date fin',
			'dose_file_field' => 'Chimiothérapie Médicament et dose',
			'treatment_type' => 'chemotherapy',
			'type' => ''),
		array('start_date_file_field' => 'Chimiothérapie (2e ligne) Date début',
			'finih_date_file_field' => 'Chimiothérapie (2e ligne) Date fin',
			'dose_file_field' => 'Chimiothérapie (2e ligne) Médicament et dose',
			'treatment_type' => 'chemotherapy',
			'type' => '2nd line'));
	foreach($tmp_array as $new_trt) {
		if(strlen($new_line_data[$new_trt['start_date_file_field']].$new_line_data[$new_trt['finih_date_file_field']].$new_line_data[$new_trt['dose_file_field']])) {
			// Master Data
			$treatment_masters = array('procure_form_identification' => $procure_form_identification);
			$tmp_event_date = getDateAndAccuracy($new_line_data[$new_trt['start_date_file_field']], $summary_msg_title, $new_trt['start_date_file_field'], $line_counter);
			if($tmp_event_date) {
				$treatment_masters['start_date'] = $tmp_event_date['date'];
				$treatment_masters['start_date_accuracy'] = $tmp_event_date['accuracy'];
			}
			$tmp_event_date = getDateAndAccuracy($new_line_data[$new_trt['finih_date_file_field']], $summary_msg_title, $new_trt['finih_date_file_field'], $line_counter);
			if($tmp_event_date) {
				$treatment_masters['finish_date'] = $tmp_event_date['date'];
				$treatment_masters['finish_date_accuracy'] = $tmp_event_date['accuracy'];
			}
			// Detail Data
			$treatment_details = array('treatment_type' => $new_trt['treatment_type'], 'type' => $new_trt['type']);
			if(strlen($new_line_data[$new_trt['dose_file_field']])) {
				$treatment_details['dosage'] = str_replace(array("\n", "'"), array('', "''"), $new_line_data[$new_trt['dose_file_field']]);
				if(strlen($treatment_details['dosage']) > 50) {
					$treatment_masters['notes'] = $treatment_details['dosage'];
					Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Hormonotherapy Or Chemotherapie Dosage too long'][] = "Specified Dosage is too long [".$treatment_details['dosage']."] for field '".$new_trt['dose_file_field']."'. See line: $line_counter";
				}
			} else {
				Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['No Hormonotherapy Or Chemotherapie Dose'][] = "No dose specified for field '".$new_trt['dose_file_field']."'. See line: $line_counter";
			}
			$all_trts[] = array('TreatmentMaster' => $treatment_masters, 'TreatmentDetail' => $treatment_details);
		}
	}
	
	// ** OTHER TRT **
	if(strlen($new_line_data['Autre traitement Préciser le traitement'].$new_line_data['Autre traitement Date début'].$new_line_data['Autre traitement Date fin'].$new_line_data['Autre traitement Posologie (dose)'])) {
		die('ERR 327 2863286 823687 3223 ');
	}
	
	// ** EXP TRT **
	$new_trt = array('start_date_file_field' => 'Traitement expérimental Date début',
		'finih_date_file_field' => 'Traitement expérimental Date fin',
		'dose_file_field' => 'Traitement expérimental Posologie (dose)',
		'treatment_type' => 'experimental treatment',
		'type_file_field' => 'Traitement expérimental Type de traitement');
	if(strlen($new_line_data[$new_trt['start_date_file_field']].$new_line_data[$new_trt['finih_date_file_field']].$new_line_data[$new_trt['dose_file_field']].$new_line_data[$new_trt['type_file_field']])) {
		// Master Data
		$treatment_masters = array('procure_form_identification' => $procure_form_identification);
		$tmp_event_date = getDateAndAccuracy($new_line_data[$new_trt['start_date_file_field']], $summary_msg_title, $new_trt['start_date_file_field'], $line_counter);
		if($tmp_event_date) {
			$treatment_masters['start_date'] = $tmp_event_date['date'];
			$treatment_masters['start_date_accuracy'] = $tmp_event_date['accuracy'];
		}
		$tmp_event_date = getDateAndAccuracy($new_line_data[$new_trt['finih_date_file_field']], $summary_msg_title, $new_trt['finih_date_file_field'], $line_counter);
		if($tmp_event_date) {
			$treatment_masters['finish_date'] = $tmp_event_date['date'];
			$treatment_masters['finish_date_accuracy'] = $tmp_event_date['accuracy'];
		}
		// Detail Data
		$treatment_details = array('treatment_type' => $new_trt['treatment_type'], 'type' => $new_line_data[$new_trt['type_file_field']]);
		if(strlen($new_line_data[$new_trt['dose_file_field']])) {
			$treatment_details['dosage'] = str_replace(array("\n", "'"), array('', "''"), $new_line_data[$new_trt['dose_file_field']]);
			if(strlen($treatment_details['dosage']) > 50) {
				$treatment_masters['notes'] = $treatment_details['dosage'];
				Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Hormonotherapy Or Chemotherapie Dosage too long'][] = "Specified Dosage is too long [".$treatment_details['dosage']."] for field '".$new_trt['dose_file_field']."'. See line: $line_counter";
			}
		} else {
			Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['No Hormonotherapy Or Chemotherapie Dose'][] = "No dose specified for field '".$new_trt['dose_file_field']."'. See line: $line_counter";
		}
		$all_trts[] = array('TreatmentMaster' => $treatment_masters, 'TreatmentDetail' => $treatment_details);
	}

	return $all_trts;
}

function loadFollowUpClinicaEvent($patient_identification, $new_line_data, $summary_msg_title, $line_counter, $procure_form_identification){
	$all_events = array();
	$event_fields = array(
		'Scintigraphie osseuse' => "bone scintigraphy", 
		'CT-Scan' => "CT-scan", 
		'TEP-Scan' => "PET-scan", 
		'IRM' => "MRI",
		'Examen additionnel' => 'specified',
		'Examen additionnel 2' => 'specified',
		'Examen additionnel 3' => 'specified',
		'Examen additionnel 4' => 'specified',
		'Examen additionnel 5' => 'specified',
		'Examen additionnel 6' => 'specified',
		'Examen additionnel 7' => 'specified');
	foreach($event_fields as $event_file_type => $event_db_type) {	
		if(array_key_exists($event_file_type.'Date', $new_line_data)) die('ERR 36 8762387 628736 8726 3232 '.$event_file_type.'Date');
		if(array_key_exists($event_file_type.' Date', $new_line_data)) {		
			if(strlen($new_line_data[$event_file_type.' Date'])) {
				// EVENT MASTER
				$event_masters = array('procure_form_identification' => $procure_form_identification);
				$tmp_event_date = getDateAndAccuracy($new_line_data[$event_file_type.' Date'], $summary_msg_title, $event_file_type.' Date', $line_counter);
				if($tmp_event_date) {
					$event_masters['event_date'] = $tmp_event_date['date'];
					$event_masters['event_date_accuracy'] = $tmp_event_date['accuracy'];
				}
				if(!strlen($new_line_data[$event_file_type.' Interprétation'])) die('ERR 736321323232823');
				$event_masters['event_summary'] = str_replace("'","''",$new_line_data[$event_file_type.' Interprétation']);
				// EVENT DETAIL
				$event_details = array();
				if('specified' == $event_db_type) {
					switch($new_line_data[$event_file_type." Préciser l'examen"]) {
						
						case 'CT-Scan':
							$event_db_type = 'CT-scan';
							break;
						case 'IRM':
							$event_db_type = 'MRI';
							break;
						case 'Scintigraphie osseuse':
						case 'Scinti. Osseuse':
							$event_db_type = 'bone scintigraphy';
							break;
						case 'TEP-Scan':
							$event_db_type = 'PET-scan';
							break;
						default:
							$event_db_type = null;
							Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Unknown clinical event'][] = "Event '".$new_line_data[$event_file_type." Préciser l'examen"]."' for field '$event_file_type Préciser l'examen' is not supported. Clinical event won't be imported. See line: $line_counter";
					}
				}
			if($event_db_type) {
				$event_details['type'] = $event_db_type;		
				$all_events[] = array('EventMaster' => $event_masters, 'EventDetail' => $event_details);
			}
			} else if(strlen($new_line_data[$event_file_type.' Interprétation'])) die('ERR 7363262628732823');
		}
	}
	return $all_events;
}

function loadFollowUpAPS($patient_identification, $new_line_data, $summary_msg_title, $line_counter, $procure_form_identification) {
	$all_events = array();
	for($aps_id = 1; $aps_id < 20; $aps_id++) {
		if(array_key_exists('Date APS'.$aps_id, $new_line_data)) {
			$date_field = 'Date APS'.$aps_id;
			$aps_field = 'APS'.$aps_id;
			if(strlen($new_line_data[$aps_field])) {
				// EVENT MASTER
				$event_masters = array('procure_form_identification' => $procure_form_identification);
				$tmp_event_date = getDateAndAccuracy($new_line_data[$date_field], $summary_msg_title, $date_field, $line_counter);
				if($tmp_event_date) {
					$event_masters['event_date'] = $tmp_event_date['date'];
					$event_masters['event_date_accuracy'] = $tmp_event_date['accuracy'];
				}
				// EVENT DETAIL
				$event_details = array();
				if(strlen($new_line_data[$aps_field]) && !in_array($new_line_data[$aps_field], array('ND', 'N/A', 'nd', '-'))) {
					if(preg_match('/^(<){0,1}([0-9]+)([\.\,][0-9]+){0,1}$/', $new_line_data[$aps_field], $matches)) {
						$aps_value = $matches[2].(empty($matches[3])? '' : str_replace(',','.',$matches[3]));
						$event_details['total_ngml'] = $aps_value;
						if($matches[1]) {
							$event_masters['event_summary'] = $new_line_data[$aps_field];
							Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Approximative APS Value'][] = "Value '".$new_line_data[$aps_field]."' for field '$aps_field' is Approximative. Will set APS = $aps_value and keep file value in notes. See line: $line_counter";	
						}
					} else {
						Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Wrong APS Value'][] = "Value '".$new_line_data[$aps_field]."' for field '$aps_field' is not a float. See line: $line_counter";
					}
				}
				$all_events[] = array('EventMaster' => $event_masters, 'EventDetail' => $event_details);
			}
		}
	}
	return $all_events;
}


function recordFollowUpForm($patient_identification, $participant_id) {
	if(isset(Config::$followups[$patient_identification])) {
		foreach(Config::$followups[$patient_identification] as $visit => $visit_data) {
			if(sizeof($visit_data) > 1 || !empty($visit_data['procure follow-up worksheet']['EventDetail'])) {
				$event_control_data = Config::$event_controls['procure follow-up worksheet'];
				$event_master_id = customInsertRecord(array_merge($visit_data['procure follow-up worksheet']['EventMaster'], array('participant_id' => $participant_id, 'event_control_id' => $event_control_data['event_control_id'])), 'event_masters', false);
				customInsertRecord(array_merge($visit_data['procure follow-up worksheet']['EventDetail'], array('event_master_id' => $event_master_id)), $event_control_data['detail_tablename'], true);
				unset($visit_data['procure follow-up worksheet']);
				$followup_event_master_id = $event_master_id;
				foreach($visit_data as $event_tx_type => $event_tx_list) {
					foreach($event_tx_list as $new_event_tx) {
						if(preg_match('/treatment/', $event_tx_type)) {
							$tx_control_data = Config::$treatment_controls[$event_tx_type];
							$treatment_master_id = customInsertRecord(array_merge($new_event_tx['TreatmentMaster'], array('participant_id' => $participant_id, 'treatment_control_id' => $tx_control_data['treatment_control_id'])), 'treatment_masters', false);
							customInsertRecord(array_merge($new_event_tx['TreatmentDetail'], array('treatment_master_id' => $treatment_master_id, 'followup_event_master_id' => $followup_event_master_id)), $tx_control_data['detail_tablename'], true);
						} else {
							$event_control_data = Config::$event_controls[$event_tx_type];
							$event_master_id = customInsertRecord(array_merge($new_event_tx['EventMaster'], array('participant_id' => $participant_id, 'event_control_id' => $event_control_data['event_control_id'])), 'event_masters', false);
							customInsertRecord(array_merge($new_event_tx['EventDetail'], array('event_master_id' => $event_master_id, 'followup_event_master_id' => $followup_event_master_id)), $event_control_data['detail_tablename'], true);
						}
					}
				}
			}
		}
		unset(Config::$followups[$patient_identification]);
	}
}