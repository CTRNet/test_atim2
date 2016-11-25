<?php

function loadDbProtcolsAndDrugs(){
	//drugs
	$query = "SELECT id, generic_name FROM drugs WHERE deleted <> 1";
	$res = mysqli_query(Config::$db_connection, $query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$query."]");
	while($row = $res->fetch_assoc()) Config::$drugs[$row['generic_name']] = $row['id'];
	//$protocols
	$query = "SELECT pm.id AS protocol_master_id, pm.code AS protocol_name, d.generic_name, ped.drug_id
		FROM protocol_masters pm 
		INNER JOIN protocol_extend_masters pem ON pem.protocol_master_id = pm.id 
		INNER JOIN pe_chemos ped ON ped.protocol_extend_master_id = pem.id
		INNER JOIN drugs d ON d.id = ped.drug_id
		WHERE pem.deleted <> 1 AND pm.deleted <> 1";
	$res = mysqli_query(Config::$db_connection, $query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$query."]");
	while($row = $res->fetch_assoc()) {
		if(!isset(Config::$protocols[$row['protocol_name']])) {
			Config::$protocols[$row['protocol_name']]['id'] = $row['protocol_master_id'];
			Config::$protocols[$row['protocol_name']]['drug_ids'] = array();
		}
		Config::$protocols[$row['protocol_name']]['drug_ids'][] = $row['drug_id'];
	}
	foreach(Config::$new_protocols_and_drugs as $new_protocol_name => $drugs) {
		if(!isset(Config::$protocols[$new_protocol_name])) {
			$protocol_master_id = customInsertRecord(array('code' => $new_protocol_name, 'protocol_control_id' => '1'), 'protocol_masters');
			customInsertRecord(array('protocol_master_id' => $protocol_master_id), 'pd_chemos', true);
			Config::$protocols[$new_protocol_name] = array('id' => $protocol_master_id, 'drug_ids' => array());
			foreach($drugs as $generic_name) {			
				$drug_id = null;
				if(!isset(Config::$drugs[$generic_name])) {
					$drug_id = customInsertRecord(array('generic_name' => $generic_name), 'drugs');
					Config::$drugs[$generic_name] = $drug_id;
				} else {
					$drug_id = Config::$drugs[$generic_name];
				}
				$protocol_extend_master_id = customInsertRecord(array('protocol_master_id' => $protocol_master_id, 'protocol_extend_control_id' => '1'), 'protocol_extend_masters');
				customInsertRecord(array('protocol_extend_master_id' => $protocol_extend_master_id, 'drug_id' => $drug_id), 'pe_chemos', true);
				Config::$protocols[$new_protocol_name]['drug_ids'][] = $drug_id;
			}
		} else {
			die("ERR New Protocol '$new_protocol_name' already exists");
		}
	}
}

function loadTreatments(&$tmp_xls_reader, $sheets_keys, $unmigrated_excel_participant_jgh_nbrs) {
	$worksheet_name = 'Sardo Tx';
	if(!isset($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]])) die('ERR 838838382');
	$summary_msg_title = 'Treatment - Worksheet '.$worksheet_name;
	$summary_msg_title_participant = 'Participant - Worksheet '.$worksheet_name;
	$excel_line_counter = 0;
	$headers = array();
	$query = "SELECT MAX(id) as id FROM treatment_masters;";
	$res = mysqli_query(Config::$db_connection, $query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$query."]");
	$row = $res->fetch_assoc();
	$treatment_master_id = ($row['id'] + 1);
	$query = "SELECT MAX(id) as id FROM treatment_extend_masters;";
	$res = mysqli_query(Config::$db_connection, $query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$query."]");
	$row = $res->fetch_assoc();
	$treatment_extend_master_id = ($row['id'] + 1);
	$query = "select max(id) as max_id FROM event_masters;";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	$row = $results->fetch_assoc();
	$event_master_id = $row['max_id'];
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $new_line) {
		$excel_line_counter++;
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);	
			$jgh_nbr = $new_line_data['No de dossier'];
			if(!in_array($jgh_nbr, $unmigrated_excel_participant_jgh_nbrs)) {
				if(!isset(Config::$participants[$jgh_nbr])) die('ERR 837623876287632732 : '.$jgh_nbr);
				$participant_id = Config::$participants[$jgh_nbr]['participant_id'];
				if(!$participant_id) {
					Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient not defined into Dx worksheet'][] = "See JGH# $jgh_nbr line $excel_line_counter";
				} else {
					//Check Patient Data
					if(empty(Config::$participants[$jgh_nbr]['tx_worksheet_patient_data'])) {
						Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['last_name'] = $new_line_data['Nom'];
						Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['vital_status'] = ($new_line_data['Censure (0 = vivant, 1 = mort)']? 'deceased' : '');
						if(Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['last_name']!= Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['last_name']) {
							Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Last Names Are Different in worksheets (Dx Vs Tx)'][] = "See JGH# ".$new_line_data['No de dossier']." line $excel_line_counter : (tx worksheet) [".Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['last_name']."] != (dx worksheet) [".Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['last_name']."]";
						}
						if(Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['vital_status']!= Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['vital_status']) {
							Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Vital Status Are Different in worksheets (Dx Vs Tx)'][] = "See JGH# ".$new_line_data['No de dossier']." line $excel_line_counter : (tx worksheet) [".Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['vital_status']."] != (dx worksheet) [".Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['vital_status']."]";
						}
					} else {
						if(Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['last_name'] != $new_line_data['Nom']) Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Date Nom'][] = "See JGH# $jgh_nbr line $excel_line_counter";
						if(Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['vital_status'] != ($new_line_data['Censure (0 = vivant, 1 = mort)']? 'deceased' : '')) Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Censure'][] = "See JGH# $jgh_nbr line $excel_line_counter";
					}
					//New Treatment
					if(!isset(Config::$topos[$new_line_data['Topographie']])) { pr(Config::$topos); die('ERR 83833283832323 : '.$new_line_data['Topographie']); }
					if(!isset(Config::$morphos[$new_line_data['Morphologie']]))  { pr(Config::$morphos); die('ERR 8388434338323232 : '.$new_line_data['Morphologie']); }
					$icd10_code = Config::$topos[$new_line_data['Topographie']];
					$morphology = Config::$morphos[$new_line_data['Morphologie']];
					$dx_date = $new_line_data['Date du diagnostic'];
					$dx_date_accuracy = 'c';
					if(preg_match('/^([0-9]{4})\-MM\-JJ$/', $dx_date, $matches)) {
						$dx_date = $matches[1].'-01-01';
						$dx_date_accuracy = 'm';
					} else if(preg_match('/^([0-9]{4}\-[0-9]{2})\-JJ$/', $dx_date, $matches)) {
						$dx_date = $matches[1].'-01';
						$dx_date_accuracy = 'd';
					} else if(!preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $dx_date)) die('ERR 383287632876287326 8 : '.$dx_date);
					$treatment_control_id = '';
					$event_control_id = '';
					switch($new_line_data['Type traitement']) {
						case 'CHIR':
							$treatment_control_id = '6';
							break;
						case 'BIOP':
							$treatment_control_id = '7';
							break;
						case 'CHIMIO':
						case 'PROTOC':
							$treatment_control_id = '1';
							break;
							
						case 'HORM':
							$treatment_control_id = '5';
							break;
						case 'RADIO':
							$treatment_control_id = '2';
							break;
						case 'IMMUNO':
							$treatment_control_id = '8';
							break;
							
						case 'IMAGE':
							$event_control_id = '53';
							break;
							
						case 'AUTRE':
							$due_date = $new_line_data['Date début traitement'];
							$due_date_accuracy = 'c';
							if(preg_match('/^([0-9]{4})\-MM\-JJ$/', $due_date, $matches)) {
								$due_date = $matches[1].'-01-01';
								$due_date_accuracy = 'm';
							} else if(preg_match('/^([0-9]{4}\-[0-9]{2})\-JJ$/', $due_date, $matches)) {
								$due_date = $matches[1].'-01';
								$due_date_accuracy = 'd';
							} else if($due_date == 'AAAA-MM-JJ') {
								$due_date = '';
								$due_date_accuracy = '';
							} else if(!preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $due_date)) die('ERR 33829798237293 : '.$due_date);
							$msg = array(
								'participant_id' => $participant_id, 
								'title' => $new_line_data['Traitement'], 
								'description' => $new_line_data['Traitement'], 
								'due_date' => $due_date, 
								'due_date_accuracy' => $due_date_accuracy, 
								'message_type' => 'note');
							customInsertRecord($msg, 'participant_messages');
							break;
							
						case '':
							break;
							
						case 'REVISION':
						case 'BILAN':
						case 'VISITE':
						case 'EXAM':
						case 'CYTO':
						case 'MEDIC':
						default: 
							Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Following treatment types have not been imported'][$new_line_data['Type traitement']] = $new_line_data['Type traitement'];
					}
					
					if($treatment_control_id || $event_control_id) {
						$diagnosis_master_id = '';
						$qc_lady_laterality = '';
						//Link trt to a dx
						if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology])) {
							die('ERR 32 2638 26387 62 : '.$excel_line_counter);
						} else if(sizeof(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis']) != 1) {
							Config::$summary_msg[$summary_msg_title]['@@WARNING@@']["Unable to link treatment do a diagnosis (perhaps it's bilateral dx - to do manually)"][] = "See JGH# $jgh_nbr line $excel_line_counter.";
						} else {
							//Found a dx...
							$tmp = array_keys(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis']);
							$qc_lady_laterality = $tmp[0];
							$diagnosis_master_id = Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['diagnosis_masters']['id'];
							if(strlen(str_replace(' ', '', $new_line_data['TNM clinique']))) {
								if(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['diagnosis_masters']['clinical_stage_summary'] 
								&& Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['diagnosis_masters']['clinical_stage_summary'] != $new_line_data['TNM clinique']) die('ERR 3289 82938 932832 line : '.$excel_line_counter);
								Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['diagnosis_masters']['clinical_stage_summary'] = $new_line_data['TNM clinique'];
								Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['diagnosis_masters']['qc_lady_clinical_stage_summary_at_dx'] = $new_line_data['TNM clinique'];
							}
						}
						//Get date
						$start_date = $new_line_data['Date début traitement'];
						$start_date_accuracy = 'c';
						if(preg_match('/^([0-9]{4})\-MM\-JJ$/', $start_date, $matches)) {
							$start_date = $matches[1].'-01-01';
							$start_date_accuracy = 'm';
						} else if(preg_match('/^([0-9]{4}\-[0-9]{2})\-JJ$/', $start_date, $matches)) {
							$start_date = $matches[1].'-01';
							$start_date_accuracy = 'd';
						} else if($start_date == 'AAAA-MM-JJ') {
							$start_date = '';
							$start_date_accuracy = '';
						} else if(!preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $start_date)) die('ERR 33829798237293 : '.$start_date);
											
						if($treatment_control_id) {
							//Record data
							$trt_key = '';
							$txd_tablename = '';
							$txe_tablename = '';
							switch($new_line_data['Type traitement']) {
								case 'CHIR':
									//Surgery
									$trt_key = 'CHIR-'.(empty($start_date)? ($treatment_master_id + 1) : $start_date);
									$trt_treatment_master_id = '';
									if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key])) {
										$treatment_master_id++;
										Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key] = array(
											'treatment_masters' => array(
												'id' => $treatment_master_id,
												'treatment_control_id' => $treatment_control_id,
												'diagnosis_master_id' => $diagnosis_master_id,
												'start_date' => $start_date,
												'start_date_accuracy' => $start_date_accuracy,
												'qc_lady_laterality' => $qc_lady_laterality,
												'participant_id' => $participant_id) ,
											'qc_lady_txd_biopsy_surgeries'	=> array(
												'treatment_master_id' => $treatment_master_id,
												'patho_nbr' => $new_line_data['No rapport traitement'],
												'path_stage_summary' => $new_line_data['TNM pathologique']),
											'treatment_extends' => array());
										$trt_treatment_master_id = $treatment_master_id;
										
									} else {
										$trt_treatment_master_id = Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_masters']['id'];
										//diff
										if($new_line_data['No rapport traitement'] && $new_line_data['No rapport traitement'] != Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['qc_lady_txd_biopsy_surgeries']['patho_nbr']) {
											Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field No rapport traitement'][] = "See JGH# $jgh_nbr line $excel_line_counter : ".$new_line_data['No rapport traitement'] ." != ". Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['qc_lady_txd_biopsy_surgeries']['patho_nbr'];
										}
										if($new_line_data['TNM pathologique'] && $new_line_data['TNM pathologique'] != Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['qc_lady_txd_biopsy_surgeries']['path_stage_summary']) {
											Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field TNM pathologique'][] = "See JGH# $jgh_nbr line $excel_line_counter";
										}
									}
									if($new_line_data['Traitement']) {
										$procedure = $new_line_data['Traitement'];
										if(strlen($procedure) > 100) die('ERR 2376 876287683276 2 '.$procedure);
										Config::$surgical_procedures[strtolower($procedure)] = $procedure;
										if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$procedure])) {
											$treatment_extend_master_id ++;
											Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$procedure] = 
												array(
													'treatment_extend_masters' => array(
														'id' => $treatment_extend_master_id,
														'treatment_extend_control_id' => 2,
														'treatment_master_id' => $trt_treatment_master_id),
													'txe_surgeries' => array(
														'surgical_procedure' => strtolower($procedure),
														'treatment_extend_master_id' => $treatment_extend_master_id));
										}
									}
									if(isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']]['tmp_receptor_data'])) {
										addReceptorData(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key],
											Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']]['tmp_receptor_data'], 
											$new_line_data['Date début traitement'], 
											$new_line_data['Type traitement'],
											$new_line_data['Traitement'],
											$jgh_nbr,
											$excel_line_counter,
											$summary_msg_title);
									}
									break;
									
								case 'BIOP':
									//Biopsy
									$trt_key = 'BIOP-'.(empty($start_date)? ($treatment_master_id + 1) : $start_date);
									$trt_treatment_master_id = '';
									if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key])) {
										$treatment_master_id++;
										Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key] = array(
											'treatment_masters' => array(
												'id' => $treatment_master_id,
												'treatment_control_id' => $treatment_control_id,
												'diagnosis_master_id' => $diagnosis_master_id,
												'start_date' => $start_date,
												'start_date_accuracy' => $start_date_accuracy,
												'qc_lady_laterality' => $qc_lady_laterality,
												'participant_id' => $participant_id) ,
											'qc_lady_txd_biopsy_surgeries'	=> array(
												'treatment_master_id' => $treatment_master_id,
												'patho_nbr' => $new_line_data['No rapport traitement'],
												'path_stage_summary' => $new_line_data['TNM pathologique']),
												'treatment_extends' => array());
										$trt_treatment_master_id = $treatment_master_id;
									
									} else {
										$trt_treatment_master_id = Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_masters']['id'];
										//diff
										if($new_line_data['No rapport traitement'] && $new_line_data['No rapport traitement'] != Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['qc_lady_txd_biopsy_surgeries']['patho_nbr']) {
											Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field No rapport traitement'][] = "See JGH# $jgh_nbr line $excel_line_counter : ".$new_line_data['No rapport traitement'] ." != ". Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['qc_lady_txd_biopsy_surgeries']['patho_nbr'];
										}
										if($new_line_data['TNM pathologique'] && $new_line_data['TNM pathologique'] != Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['qc_lady_txd_biopsy_surgeries']['path_stage_summary']) {
											Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field TNM pathologique'][] = "See JGH# $jgh_nbr line $excel_line_counter";
										}
									}
									if($new_line_data['Traitement']) {
										$procedure = $new_line_data['Traitement'];
										if(strlen($procedure) > 100) die('ERR 2376 876287683276 2 '.$procedure);
										Config::$biopsy_procedures[strtolower($procedure)] = $procedure;
										if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$procedure])) {
											$treatment_extend_master_id ++;
											Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$procedure] =
												array(
													'treatment_extend_masters' => array(
														'id' => $treatment_extend_master_id,
														'treatment_extend_control_id' => 4,
														'treatment_master_id' => $trt_treatment_master_id),
													'qc_lady_txe_biopsies' => array(
														'biopsy_procedure' => strtolower($procedure),
														'treatment_extend_master_id' => $treatment_extend_master_id));
										}
									}
									if(isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']]['tmp_receptor_data'])) {
										addReceptorData(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key],
											Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']]['tmp_receptor_data'],
											$new_line_data['Date début traitement'],
											$new_line_data['Type traitement'],
											$new_line_data['Traitement'],
											$jgh_nbr,
											$excel_line_counter,
											$summary_msg_title);
									}
									break;
									
								case 'CHIMIO':
									$txd_tablename = 'txd_chemos';
									$txe_tablename = 'txe_chemos';
									$treatment_extend_control_id = 1;
								case 'HORM':
									if(empty($txd_tablename)) {
										$txd_tablename = 'qc_lady_txd_hormonos';
										$txe_tablename = 'qc_lady_txe_hormonos';
										$treatment_extend_control_id = 3;
									}
								case 'IMMUNO':
									if(empty($txd_tablename)) {
										$txd_tablename = 'qc_lady_txd_immunos';
										$txe_tablename = 'qc_lady_txe_immunos';
										$treatment_extend_control_id = 6;
									}
									$trt_key = $new_line_data['Type traitement'].'-'.(empty($start_date)? ($treatment_master_id + 1) : $start_date);
									$trt_treatment_master_id = '';
									if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key])) {
										$treatment_master_id++;
										Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key] = array(
											'treatment_masters' => array(
												'id' => $treatment_master_id,
												'treatment_control_id' => $treatment_control_id,
												'diagnosis_master_id' => $diagnosis_master_id,
												'start_date' => $start_date,
												'start_date_accuracy' => $start_date_accuracy,
												'participant_id' => $participant_id) ,
											$txd_tablename	=> array(
												'treatment_master_id' => $treatment_master_id),
											'treatment_extends' => array());
										$trt_treatment_master_id = $treatment_master_id;
									
									} else {
										$trt_treatment_master_id = Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_masters']['id'];
									}
									if($new_line_data['Traitement']) {
										$drug_id = null;
										$drug_name = str_replace('Létrozole', 'Letrozole', $new_line_data['Traitement']);
										if(!isset(Config::$drugs[$drug_name])) {
											$drug_id = customInsertRecord(array('generic_name' => $drug_name), 'drugs');
											Config::$drugs[$drug_name] = $drug_id;
										} else {
											$drug_id = Config::$drugs[$drug_name];
										}
										if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$drug_id])) {
											$treatment_extend_master_id ++;
											Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$drug_id] =
												array(
													'treatment_extend_masters' => array(
														'id' => $treatment_extend_master_id,
														'treatment_extend_control_id' => $treatment_extend_control_id,
														'treatment_master_id' => $trt_treatment_master_id),
													$txe_tablename => array(
														'drug_id' => $drug_id,
														'treatment_extend_master_id' => $treatment_extend_master_id));
										}
									}
									break;	
									
								case 'RADIO':
									$trt_key = 'RADIO-'.(empty($start_date)? ($treatment_master_id + 1) : $start_date);
									$trt_treatment_master_id = '';
									if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key])) {
										$treatment_master_id++;
										Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key] = array(
											'treatment_masters' => array(
												'id' => $treatment_master_id,
												'treatment_control_id' => $treatment_control_id,
												'diagnosis_master_id' => $diagnosis_master_id,
												'start_date' => $start_date,
												'start_date_accuracy' => $start_date_accuracy,
												'participant_id' => $participant_id) ,
											'txd_radiations'	=> array(
												'treatment_master_id' => $treatment_master_id),
											'treatment_extends' => array());
										$trt_treatment_master_id = $treatment_master_id;
									
									} else {
										$trt_treatment_master_id = Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_masters']['id'];
									}
									if($new_line_data['Traitement']) {
										$procedure = $new_line_data['Traitement'];
										if(strlen($procedure) > 100) die('ERR 2376 876287683276 66 '.$procedure);
										Config::$radiation_procedures[strtolower($procedure)] = $procedure;
										if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$procedure])) {
											$treatment_extend_master_id ++;
											Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$procedure] =
												array(
													'treatment_extend_masters' => array(
														'id' => $treatment_extend_master_id,
														'treatment_extend_control_id' => 5,
														'treatment_master_id' => $trt_treatment_master_id),
													'qc_lady_txe_radiations' => array(
														'radiation_procedure' => strtolower($procedure),
														'treatment_extend_master_id' => $treatment_extend_master_id));
										}
									}
									break;	
									
								case 'PROTOC':
									$trt_key = 'PROTOC-'.(empty($start_date)? ($treatment_master_id + 1) : $start_date);
									$protocol_master_id = null;
									if($new_line_data['Traitement']) {
										if(!isset(Config::$protocols[$new_line_data['Traitement']])) {
											die('ERR 236326236632632632 Missging protocol '.$new_line_data['Traitement'].' in db or in $new_protocols_and_drugs');
										} else {
											$protocol_master_id = Config::$protocols[$new_line_data['Traitement']]['id'];
										}
									}
									if(!$protocol_master_id) die('ERR 32762837632876 line : '.$excel_line_counter);
									if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key])) {
										$treatment_master_id++;
										Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key] = array(
											'treatment_masters' => array(
												'id' => $treatment_master_id,
												'treatment_control_id' => $treatment_control_id,
												'diagnosis_master_id' => $diagnosis_master_id,
												'protocol_master_id' => $protocol_master_id,
												'start_date' => $start_date,
												'start_date_accuracy' => $start_date_accuracy,
												'participant_id' => $participant_id) ,
											'txd_chemos'	=> array(
												'treatment_master_id' => $treatment_master_id),
											'treatment_extends' => array());
										foreach(Config::$protocols[$new_line_data['Traitement']]['drug_ids'] as $drug_id) {
											$txe_tablename = 'txe_chemos';
											$treatment_extend_control_id = 1;
											if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$drug_id])) {
												$treatment_extend_master_id ++;
												Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$drug_id] =
													array(
														'treatment_extend_masters' => array(
															'id' => $treatment_extend_master_id,
															'treatment_extend_control_id' => $treatment_extend_control_id,
															'treatment_master_id' => $treatment_master_id),
														$txe_tablename => array(
															'drug_id' => $drug_id,
															'treatment_extend_master_id' => $treatment_extend_master_id));
											}
										}
									} else {
										//diff
										Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Duplicated PROTOC (see dx not equal to bilateral)'][] = "Protocole ".$new_line_data['Traitement']." has been assigned twice to the same patient for the same date. See JGH# $jgh_nbr line $excel_line_counter";
									}
									break;	
								
								default:
									die('ERR 237 62876 23');	
							}
							
						} else if($event_control_id) {
							//Record data
							switch($new_line_data['Type traitement']) {
								case 'IMAGE':
									//IMAGE
									$imaging_type = $new_line_data['Traitement'];
									if(strlen($imaging_type) > 100) die('ERR 2376 876287683276 332 '.$imaging_type);
									Config::$imaging_types[strtolower($imaging_type)] = $imaging_type;
									$event_master_id++;
									Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Event'][] = array(
										'event_masters' => array(
											'id' => $event_master_id,
											'event_control_id' => '53',
											'diagnosis_master_id' => $diagnosis_master_id,
											'event_date' => $start_date,
											'event_date_accuracy' => $start_date_accuracy,
											'participant_id' => $participant_id) ,
										'qc_lady_imagings'	=> array(
											'event_master_id' => $event_master_id,
											'type' => strtolower($imaging_type)));	
									break;
								
								default:
									die('ERR 237 62876 24');	
							}
						}
					}				
				}
			}
		}
	} 
}

function addReceptorData(&$treatment_data, &$dx_receptor_data, $start_date, $treatment_type, $treatment, $jgh_nbr, $excel_line_counter, $source_summary_msg_title) {
	$summary_msg_title = Config::$tmp_receptor_summary_msg_title;
	if(isset($dx_receptor_data[$treatment_type][$start_date][$treatment])) {
		if(sizeof($dx_receptor_data[$treatment_type][$start_date][$treatment]) > 1) {
			Config::$summary_msg[$summary_msg_title]['@@WARNING@@']["Duplicated Receptor Data (No data will be imported - probably bilateral dx - data to import manually)"][] = "See $treatment_type on $start_date. System is trying to link receptor data to treatment defined in '$source_summary_msg_title' for JGH# $jgh_nbr treatment defined at line $excel_line_counter.";
		} else {
			$treatment_receptor_data = $dx_receptor_data[$treatment_type][$start_date][$treatment][0];
			$processed_rec_data = array(
				'lymph_node_collection' => '',
				'nbr_of_lymph_nodes_positive' => '',
				'lymph_node_ccl' => '',
				'histological_grade' => '',
				'tumor_size_mm_x' => '',
				'fish_ccl' => '',
				'ki67_performed' => '',
				'ki67_pct' => '',
				'er_receptor_ccl' => '',
				'er_receptor_pct' => '',
				'pr_receptor_ccl' => '',
				'pr_receptor_pct' => '',
				'her2_receptor_ccl' => '',
				'her2_receptor_score' => '',
				'her2_receptor_antibody' => '',
				'residual_disease' => '',
				'oncotype_dx' => '');
			
			// Lymph Node
			$processed_rec_data['lymph_node_collection'] = '';
			$processed_rec_data['nbr_of_lymph_nodes_positive'] = '';
			$processed_rec_data['lymph_node_ccl'] = '';
			switch($treatment_receptor_data['Ganglions régionaux']) {
				case 'Positif':
					$processed_rec_data['lymph_node_ccl'] = 'positive';
					break;
				case 'Négatif':
					$processed_rec_data['lymph_node_ccl'] = 'negative';
					break;
				case 'Pas fait':
					$processed_rec_data['lymph_node_collection'] = 'n';
					break;
				case '':
				case 'N/S':
					break;
				default:
					pr($treatment_receptor_data['Ganglions régionaux']);
					die('ERR 23 876327632 87632');
			}
			if($treatment_receptor_data['Ganglions régionaux - prop']) {
				if(preg_match('/^([0-9]+)\/[0-9]+\ \+$/', $treatment_receptor_data['Ganglions régionaux - prop'], $matches)) {
					$processed_rec_data['nbr_of_lymph_nodes_positive'] = $matches[1];
					if($treatment_type != 'CHIR') die('ERR 237 63333334');
				} else {
					pr($treatment_receptor_data['Ganglions régionaux - prop']);
					die('ERR 23 876327632 87633');
				}
			}
			
			if(strlen($processed_rec_data['lymph_node_ccl'].$processed_rec_data['nbr_of_lymph_nodes_positive'])) {
				if($processed_rec_data['lymph_node_collection'] == 'n') die('ERR 2387 28736872 68726832');
				$processed_rec_data['lymph_node_collection'] = 'y';
			}
			//Grade
			$processed_rec_data['histological_grade'] = str_replace(array('/III', 'N/S', 'III', 'II', 'I'), array('', '', '3', '2', '1'), $treatment_receptor_data['Grade histologique sur 3']);
			if(!in_array($processed_rec_data['histological_grade'], array('','1','2','3'))) die('ERR 237632876 2382 ');
			//Tumor size
			$processed_rec_data['tumor_size_mm_x'] = str_replace(array('-99',','), array('','.'), $treatment_receptor_data['Taille tumeur (mm) - num']);
			if(strlen($processed_rec_data['tumor_size_mm_x'])) {
				if(!is_numeric($processed_rec_data['tumor_size_mm_x'])) die('ERR 237 63287 632732');
				if($treatment_type != 'CHIR') {
					Config::$summary_msg[$summary_msg_title]['@@ERROR@@']["Tumor size defined for treatment event different than surgery (CHIR). Data won't be migrated."][] = "Value ".$processed_rec_data['tumor_size_mm_x']." defined for '".$processed_rec_data['tumor_size_mm_x']."'. System is trying to link receptor data to treatment defined in '$source_summary_msg_title' for JGH# $jgh_nbr treatment defined at line $excel_line_counter.";
					$processed_rec_data['tumor_size_mm_x'] = '';
				}
			}
			//FISH
			$processed_rec_data['fish_ccl'] = '';
			switch($treatment_receptor_data['HER2NEU FISH']) {
				case 'Positif':
					$processed_rec_data['fish_ccl'] = 'positive';
					break;
				case 'Négatif':
					$processed_rec_data['fish_ccl'] = 'negative';
					break;
				case 'Douteux':
					$processed_rec_data['fish_ccl'] = 'equivocal';
					break;
				case '':
				case 'Pas fait':
				case 'N/S':
					break;
				default:
					Config::$summary_msg[$summary_msg_title]['@@WARNING@@']["FISH - Value not imported"][] = "Value ".$treatment_receptor_data['HER2NEU FISH'].". System is trying to link receptor data to treatment defined in '$source_summary_msg_title' for JGH# $jgh_nbr treatment defined at line $excel_line_counter.";
			}
			//Ki67
			$processed_rec_data['ki67_performed'] = '';
			$processed_rec_data['ki67_pct'] = str_replace(array('-99',','), array('','.'), $treatment_receptor_data['Ki67 - num']); 
			if(strlen($processed_rec_data['ki67_pct'])) {
				if(!is_numeric($processed_rec_data['ki67_pct'])) die('ERR 237 63287 6327354545');
				$processed_rec_data['ki67_performed'] = 'y';
			}
			switch($treatment_receptor_data['Ki67']) {
				case 'Positif':
				case 'Négatif':
					$processed_rec_data['ki67_performed'] = 'y';
					break;
				case '':
				case 'Pas fait':
				case 'N/S':
					break;
				default:
					die('ERR 238762 873268732');
			}
			if($processed_rec_data['ki67_performed'] == 'y' && !strlen($processed_rec_data['ki67_pct'])) {
				Config::$summary_msg[$summary_msg_title]['@@WARNING@@']["Ki67 - No %"][] = "Ki67 has been performed but no % will be recorded. System is trying to link receptor data to treatment defined in '$source_summary_msg_title' for JGH# $jgh_nbr treatment defined at line $excel_line_counter.";
			}
			//ER			
			$processed_rec_data['er_receptor_ccl'] = '';
			switch($treatment_receptor_data['Récepteurs oestrogènes']) {
				case 'Positif':
				case 'Faiblement positif':
					$processed_rec_data['er_receptor_ccl'] = 'positive';
					break;
				case 'Négatif':
					$processed_rec_data['er_receptor_ccl'] = 'negative';
					break;
				case 'Douteux':
					$processed_rec_data['er_receptor_ccl'] = 'equivocal';
					break;
				case '':
				case 'Examen impossible à réaliser':
				case 'Pas fait':
				case 'N/S':
					break;
				default:
					Config::$summary_msg[$summary_msg_title]['@@WARNING@@']["Récepteurs oestrogènes - Value not imported"][] = "Value ".$treatment_receptor_data['Récepteurs oestrogènes'].". System is trying to link receptor data to treatment defined in '$source_summary_msg_title' for JGH# $jgh_nbr treatment defined at line $excel_line_counter.";
			}
			$processed_rec_data['er_receptor_pct'] = str_replace(array('-99',','), array('','.'), $treatment_receptor_data['Récepteurs oestrogènes - num']);
			if(strlen($processed_rec_data['er_receptor_pct']) && !is_numeric($processed_rec_data['er_receptor_pct'])) die('ERR 237 63287 632443335');
			//PR
			$processed_rec_data['pr_receptor_ccl'] = '';
			switch($treatment_receptor_data['Récepteurs progestatifs']) {
				case 'Positif':
				case 'Faiblement positif':
					$processed_rec_data['pr_receptor_ccl'] = 'positive';
					break;
				case 'Négatif':
					$processed_rec_data['pr_receptor_ccl'] = 'negative';
					break;
				case 'Douteux':
					$processed_rec_data['pr_receptor_ccl'] = 'equivocal';
					break;
				case '':
				case 'Examen impossible à réaliser':
				case 'Pas fait':
				case 'N/S':
					break;
				default:
					Config::$summary_msg[$summary_msg_title]['@@WARNING@@']["Récepteurs progestatifs - Value not imported"][] = "Value ".$treatment_receptor_data['Récepteurs progestatifs'].". System is trying to link receptor data to treatment defined in '$source_summary_msg_title' for JGH# $jgh_nbr treatment defined at line $excel_line_counter.";
			}
			$processed_rec_data['pr_receptor_pct'] = str_replace(array('-99',','), array('','.'), $treatment_receptor_data['Récepteurs progestatifs - num']);
			if(strlen($processed_rec_data['pr_receptor_pct']) && !is_numeric($processed_rec_data['pr_receptor_pct'])) die('ERR 237 63287 632443444');
			//HER2
			$processed_rec_data['her2_receptor_ccl'] = '';
			$processed_rec_data['her2_receptor_antibody'] = '';
			$i = 0;
			$antibodies = array('HER2NEU 4B5', 'HER2NEU CB11', 'HER2NEU TAB 250', 'HER2NEU');
			while($i<count($antibodies) && empty($processed_rec_data['her2_receptor_ccl'])) {
				$antibody = $antibodies[$i];
				$i++;
				switch($treatment_receptor_data[$antibody]) {
					case 'Positif':
					case 'Faiblement positif':
						$processed_rec_data['her2_receptor_ccl'] = 'positive';
						break;
					case 'Négatif':
						$processed_rec_data['her2_receptor_ccl'] = 'negative';
						break;
					case 'Douteux':
						$processed_rec_data['her2_receptor_ccl'] = 'equivocal';
						break;
					case '':
					case 'Examen impossible à réaliser':
					case 'Pas fait':
					case 'N/S':
						break;
					default:
						Config::$summary_msg[$summary_msg_title]['@@WARNING@@']["$antibody - Value not imported"][] = "Value ".$treatment_receptor_data[$antibody].". System is trying to link receptor data to treatment defined in '$source_summary_msg_title' for JGH# $jgh_nbr treatment defined at line $excel_line_counter.";
				}
				if($processed_rec_data['her2_receptor_ccl']) {
					$processed_rec_data['her2_receptor_antibody'] = str_replace(array('HER2NEU ', 'HER2NEU'), array('', ''), $antibody);
					switch($treatment_receptor_data[$antibody.' - int']) {
						case '+++':
							$processed_rec_data['her2_receptor_score'] = '3+';
							break;
						case '++':
							$processed_rec_data['her2_receptor_score'] = '2+';
							break;
						case '+':
							$processed_rec_data['her2_receptor_score'] = '1+';
							break;
						case '0':
						case '':
							break;
						default:
							die('ERR 2387 62763286 287632 '.$treatment_receptor_data[$antibody.' - int']);
					}	
				}
			}		
			//Oncotype DX - num
			$processed_rec_data['oncotype_dx'] = str_replace(array('-99',','), array('','.'), $treatment_receptor_data['Oncotype DX - num']);
			if(strlen($processed_rec_data['oncotype_dx']) && !is_numeric($processed_rec_data['oncotype_dx'])) die('ERR 237 63287 6324322224');
			//Maladie résiduelle
			$processed_rec_data['residual_disease'] = '';
			switch($treatment_receptor_data['Maladie résiduelle']) {
				case 'Oui':
					$processed_rec_data['residual_disease'] = 'y';
					break;
				case 'Non':
					$processed_rec_data['residual_disease'] = 'n';
					break;
				case '> 2 cm':
				case '> 1 cm, <= 2 cm':
				case '<= 1 cm':
				case '<= 1 cm':
				case '> 1 cm, <= 2 cm':
				case 'Microscopique':
					Config::$summary_msg[$summary_msg_title]['@@WARNING@@']["Positive Residual Disease Value To approvee"][] = "Value ".$treatment_receptor_data['Maladie résiduelle']." has been considered as 'Yes'. System is trying to link receptor data to treatment defined in '$source_summary_msg_title' for JGH# $jgh_nbr treatment defined at line $excel_line_counter.";
					$processed_rec_data['residual_disease'] = 'y';
					break;
				case '':
				case 'N/S':
					break;
				default:
					die('ERR 2376 872632 ');
			}
			if($processed_rec_data['residual_disease'] && $treatment_type != 'CHIR') die('ERR 237 63333322332324');
			
			//Record data
			foreach($processed_rec_data as $key => $val) {
				if(strlen($val)) {
					if(!array_key_exists($key, $treatment_data['qc_lady_txd_biopsy_surgeries']) || !strlen($treatment_data['qc_lady_txd_biopsy_surgeries'][$key])) {
						$treatment_data['qc_lady_txd_biopsy_surgeries'][$key] = $val;
					} else if($treatment_data['qc_lady_txd_biopsy_surgeries'][$key] != $val) {
						Config::$summary_msg[$summary_msg_title]['@@WARNING@@']["Unconsistent data in path report"][] = "See $treatment_type on $start_date for JGH# $jgh_nbr line $excel_line_counter (recpetor worksheet) for field $key : $val != ".$treatment_data['qc_lady_txd_biopsy_surgeries'][$key];
					}
				}
			}	
		}
		unset($dx_receptor_data[$treatment_type][$start_date][$treatment]);
		if(empty($dx_receptor_data[$treatment_type][$start_date])) unset($dx_receptor_data[$treatment_type][$start_date]);
		if(empty($dx_receptor_data[$treatment_type])) unset($dx_receptor_data[$treatment_type]);
	}
}




